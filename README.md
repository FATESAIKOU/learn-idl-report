# Learn IDL — MVP (OpenAPI-based)

簡介（中文）
本專案提供一個最小可行的 IDL 開發流程：OpenAPI v3.1 範例 spec、風格指南、生成腳本與契約測試範例（使用 Docker），以及 GitHub Actions CI 範本。

快速開始（在有 Docker 的機器）
1. Lint（Spectral）：
   docker run --rm -v "$(pwd)":/src stoplight/spectral-cli lint /src/specs/example-service.yaml --fail-severity error

2. 產生 client / server stub（openapi-generator-cli via Docker）：
   ./tools/generate.sh

3. 執行契約測試（Prism + Dredd）：
   ./tools/contract-test.sh

4. 在 CI 中：.github/workflows/openapi-ci.yml 已包含 lint → codegen → contract-test 的步驟。

文件
- /specs/example-service.yaml : OpenAPI v3.1 範例
- API-STYLEGUIDE.md : API 風格與版本策略
- tools/generate.sh : 使用 docker openapi-generator-cli 產生 stub
- tools/contract-test.sh : 以 Prism mock server + Dredd 進行契約測試
- .github/workflows/openapi-ci.yml : GitHub Actions workflow
- .github/PULL_REQUEST_TEMPLATE.md : PR 模板（含相容性評估欄位）

驗證建議
- 在 feature branch 編輯 /specs/*.yaml，建立 PR，CI 將驗證 lint/codegen/contract-test。
- PR 若為 breaking-change，請在 PR 範本勾選並描述相容性影響與回滾計畫。

License: MIT
