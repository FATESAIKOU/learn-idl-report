#!/usr/bin/env sh
# 產生 client 與 server stub（使用 Docker openapi-generator-cli）
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SPEC_PATH="/local/specs/example-service.yaml"
OUT_CLIENT="/local/generated/client"
OUT_SERVER="/local/generated/server"

echo "清理舊產物..."
rm -rf "$OUT_CLIENT" "$OUT_SERVER"

echo "產生 TypeScript axios client..."
docker run --rm -v "$ROOT_DIR":/local openapitools/openapi-generator-cli generate \
  -i "$SPEC_PATH" -g typescript-axios -o "$OUT_CLIENT" >/dev/null
echo "  -> client 輸出: $OUT_CLIENT"

echo "產生 Node.js Express server stub..."
docker run --rm -v "$ROOT_DIR":/local openapitools/openapi-generator-cli generate \
  -i "$SPEC_PATH" -g nodejs-express-server -o "$OUT_SERVER" >/dev/null
echo "  -> server 輸出: $OUT_SERVER"

echo "完成。Generated artifacts are under ./generated/"
