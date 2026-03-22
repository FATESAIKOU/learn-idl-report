#!/usr/bin/env sh
# 使用 Prism (mock) + Dredd 進行契約測試
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SPEC="/specs/example-service.yaml"
PRISM_NAME="prism-mock-for-dredd"
PRISM_PORT=4010

echo "啟動 Prism mock server (背景)..."
# 啟動 prism 並對外暴露 PRISM_PORT
docker run -d --rm --name "$PRISM_NAME" -p "${PRISM_PORT}:${PRISM_PORT}" -v "$ROOT_DIR":/app stoplight/prism:4 mock /app$SPEC --hostname 0.0.0.0 --port ${PRISM_PORT} >/dev/null

# 等待 Prism 就緒（簡單輪詢）
echo "等待 Prism 啟動..."
RETRIES=15
SLEEP=1
i=0
while [ $i -lt $RETRIES ]; do
  if docker ps --filter "name=${PRISM_NAME}" --format '{{.Names}}' | grep -q "$PRISM_NAME"; then
    # 嘗試呼叫 health endpoint /items（GET）
    if docker run --rm --network host curlimages/curl:latest -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:${PRISM_PORT}/items" | grep -E '^2|^4' >/dev/null; then
      echo "Prism 已就緒"
      break
    fi
  fi
  i=$((i+1))
  sleep $SLEEP
done

echo "執行 Dredd 測試..."
# 使用 dredd docker image，對本地 host 的 prism 進行測試
# 使用 --network host 讓容器能存取本機暴露的 port
docker run --rm --network host -v "$ROOT_DIR":/tmp dredd/dredd dredd /tmp$SPEC http://127.0.0.1:${PRISM_PORT} || TEST_RC=$?

# 結束 Prism
echo "停止 Prism..."
docker stop "$PRISM_NAME" >/dev/null 2>&1 || true

# 若 dredd 失敗，回傳非零
if [ -n "${TEST_RC:-}" ]; then
  echo "Dredd 測試失敗 (RC=$TEST_RC)"
  exit $TEST_RC
fi

echo "契約測試通過。"
