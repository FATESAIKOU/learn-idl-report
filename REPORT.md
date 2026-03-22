# Tech Research Result

## Problem Understanding

目標：建立一套介面定義（IDL）開發流程指南，方便多團隊在微服務 / API 發展上達到一致的契約定義、版本管理與自動化測試流程。需考量語言中立、生成 code/文檔、契約測試與版本相容策略。

## Candidate Technologies / Approaches（至少列出 3 個候選方案）

1. Smithy（AWS Smithy）
2. OpenAPI + JSON Schema
3. Protocol Buffers (gRPC)
4. GraphQL Schema（如需客製化查詢）

## Comparison（表格：Option / Pros / Cons / Complexity / Fitness for MVP）

| Option | Pros | Cons | Complexity | Fitness for MVP |
|---|---|---:|---:|---:|
| Smithy | 專為 API 和服務建模設計，支持 trait 擴充、生成 SDK 與契約，可和 AWS 生態整合 | 社群與工具生態小於 OpenAPI，學習門檻較高 | 中等 | 高（若要強類型契約與跨語言 codegen） |
| OpenAPI + JSON Schema | 生態成熟、豐富工具（Swagger、Redoc、client generators）、容易上手 | 對複雜訊息格式或 streaming 支援不足、語義表述不如 Smithy 靈活 | 低 | 高（快速驗收、文件與自動化測試） |
| Protocol Buffers (gRPC) | 高效二進位序列化、良好版本相容機制、適合內部服務間通訊 | 不以 REST/HTTP+JSON 為主流瀏覽器友好，對外部 3rd party 較不方便 | 中等 | 中（適合內部微服務與高效 RPC） |
| GraphQL Schema | 客製化查詢、避免過/欠取資料、強大的前端彈性 | 不是傳統 CRUD API 的契約式描述，需額外治理與版本策略 | 高 | 低（如需面向消費者複雜查詢才考慮） |

## Recommended Direction

建議採漸進式策略：

- MVP（短期目標）: 選擇 OpenAPI 作為起點。理由：生態成熟、工具支援充足、容易推動團隊採用（File-first 或 Code-first）。先完成 API 文檔、自動化契約測試（如 Pact 或 Dredd）與 CI 驗證流程。

- 中期（標準化）: 若需更嚴謹的契約描述與跨語言 SDK 生成（尤其面向複雜型別、traits 與版本治理），可導入 Smithy 作為內部契約語言，並提供 translator 將 Smithy 轉為 OpenAPI（或雙軌維運）以維持對外相容性。

- 長期（高效內部通訊）: 對內部高效 RPC 通訊、低延遲需求，可選用 Protobuf/gRPC，但應與公開 API（OpenAPI/GraphQL）分離管理。

實作建議步驟（MVP）：
1. 選定 OpenAPI 規範版本（3.0/3.1），建立空 repository 存放 OAS 定義檔（YAML/JSON）。
2. 定義 API 設計原則（命名、錯誤格式、分頁、驗證 headers、版本化策略）。
3. 建立 codegen pipeline（生成 server stubs / client SDKs）並在 CI 中驗證生成結果不可破壞。
4. 加入契約測試（consumer-driven 或 provider tests），並在 PR gate 中強制執行。
5. 若未來導入 Smithy，建立轉譯與雙向驗證流程，逐步替換或強化契約語義。

## Risks

- 生態鎖定（Vendor lock-in）：直接採用特定工具（例如只對 AWS Smithy 深度優化）可能造成鎖定風險。
- 團隊採用成本：新語言/工具（Smithy、gRPC）需額外培訓與文化變更成本。
- 版本與相容性管理：若未制定嚴格版本化策略，會造成向下相容破壞與回滾成本。
- 對外兼容性：若外部客戶期待 JSON/REST，採用 Protobuf-only 會增加整合難度。

## Assumptions

- 主要使用場景包含對外公開 API（REST/HTTP+JSON）與內部服務間通訊兩種需求。
- 團隊目前熟悉 REST 與 OpenAPI，Smithy 與 gRPC 為進階選項。
- CI/CD 可執行生成/測試步驟；有權在 GitHub 建立 repo 並使用 gh CLI 完成 PR。

