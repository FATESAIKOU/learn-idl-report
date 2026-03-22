<!-- 請以中文填寫 -->
## 概要
- 變更目標（簡述）:

## 是否變更契約（必填）
- [ ] 否（向下相容）
- [ ] 是（breaking change）

若為 breaking change，請說明相容性影響與回滾計畫：

## 相容性評估（必填）
- schema 變更類型（新增可選欄位 / 修改型別 / 刪欄位 / path 變更）:
- 是否需要通知外部使用者（若有，如何通知）:
- 測試說明（CI 將執行 spectral lint / contract tests / codegen）:

## 本地驗證步驟（給 reviewer）
1. spectral lint
2. ./tools/generate.sh
3. ./tools/contract-test.sh

