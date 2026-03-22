# API 風格指南（精簡版，中文）

目的：在多團隊間保持一致的契約與可預期行為，促成自動化檢驗與生成流程。

命名規則
- 路徑以名詞（複數）表示資源：/items, /users
- 用短橫線（kebab-case）於 URL 中：/user-groups
- Query 參數採 snake_case（或團隊統一決定），範例檔採用 per_page

HTTP 狀態碼與錯誤
- 200：成功（GET/PUT）
- 201：資源建立成功（POST）
- 204：刪除成功（DELETE 無回應 body）
- 400：請求格式或參數錯誤
- 401：未授權
- 403：禁止（權限）
- 404：找不到資源
- 409：衝突（例如重複）
錯誤回應固定格式：
  { "code": "short_code", "message": "人類可讀訊息" }

版本策略（建議）
- 使用「schema-major.minor」概念（例如 1.0）
- Breaking change → major bump（需標註 PR 並由 Release Manager 審核）
- 非破壞性新增（新增可選欄位）→ minor bump

契約變更流程（建議）
1. File-first：先修改 /specs/<service>.yaml
2. 建立 feature branch 並開 PR，PR body 必填「是否 breaking-change」欄位
3. CI 執行 spectral lint → contract tests → codegen，未通過阻塞合併
4. 若為 breaking-change，要求 2 位以上 reviewer 與發佈計畫

Codegen 與生成物
- 生成的 stub / client 作為 artifact 上傳（CI）
- 不建議在 PR 中直接 commit 生成的大量檔案，除非團隊決議需要追蹤

本文件為 MVP 精簡版（供內部團隊快速採納），正式規範可擴充 lint 規則、tagging 與更多範例。
