# 🔄 回滚ガイド & 緊急時対応

## 快速回滚指南

### 情況1: 希望完全恢復到優化前
```bash
# 恢復到備份版本
cp Terabox\ CRM.html.backup "Terabox CRM.html"
git add "Terabox CRM.html"
git commit -m "Rollback: Restore pre-optimization version"
```

### 情況2: 通過 Git 回滚
```bash
# 查看提交歷史
git log --oneline

# 回滚到之前版本
git revert d74c674  # 2026年CRM優化的提交

# 或者硬重置（慎用）
git reset --hard 59af544  # Backup before optimization 的提交
```

### 情況3: 局部恢復（僅修改某一部分）
```bash
# 查看具體修改
git diff d74c674^..d74c674 "Terabox CRM.html"

# 手動選擇性編輯文件
# 然後提交新的恢復提交
```

---

## 版本對照

### Git 版本歷史
```
6e098e4 - Add optimization summary documentation
d74c674 - 2026年CRM優化：AI強調、補助金對應、誇張表現削除 ← 主要修改
59af544 - Backup before optimization (2026-02-07)        ← 備份點
```

### 快速恢復命令
```bash
# 3 秒快速恢復（從備份）
cp "Terabox CRM.html.backup" "Terabox CRM.html" && git add . && git commit -m "Quick restore from backup"

# Git 回滾（保留歷史紀錄）
git revert d74c674
```

---

## 修改前後差異總結

### ❌ 已移除的內容
1. **"最強の基礎ツール"** - 景品表示法違反風險
2. **"究極にシンプル"** - 誇張表現
3. **"低投資で最大の成果"** - 補助金效果過度強調
4. 原補助金部分的簡單說明

### ✅ 新增的內容
1. **補助金詳細資訊區塊** (~40 行)
   - 補助金メリット
   - 申請サポート内容
   - ご注意事項
2. **IT導入支援事業者規格記載** (footer)
3. **採択保証の註釈** (CTA)

### 🔄 修改的內容
| 項目 | 修改前 | 修改後 |
|-----|---------|---------|
| ヘッダー | 2026年最新版... | デジタル化・AI導入補助金2026... |
| メインタイトル | 最強の基礎ツール | 次世代CRMプラットフォーム |
| AI説明 | 習慣を変えない進化 | 業務フローに自然に溶け込むAI支援 |
| IT担当者表현 | IT担当者不在でも | IT担当者が少なくても |

---

## 測試檢查表

如果修改後有問題，請按以下步驟檢查：

### [ ] HTML 有效性
```bash
# 檢查 HTML 語法
# 使用在線工具: https://validator.w3.org/
# 或本地工具: tidy -e "Terabox CRM.html"
```

### [ ] 顯示效果
- [ ] ヘッダーバッジが正確に表示される
- [ ] AI セクションのタイトルが正確
- [ ] 補助金セクション全體が表示される
- [ ] フッター情報が表示される

### [ ] 法規制合規性
- [ ] "最強" を含むテキストが存在しない
- [ ] "究極" を含むテキストが存在しない
- [ ] "採択を保証" 等の表現がない
- [ ] 「採択には審査があります」が記載されている

### [ ] 機能確認
- [ ] デモ予約リンク: `Free Try.html`
- [ ] 補助金相談リンク: `補助金相談.html`
- [ ] ログインボタンが動作する
- [ ] 画像がすべて表示される

---

## 緊急時步驟

### 🚨 もし深刻な問題が發生した場合

**Step 1: 即座に回滾**
```bash
git revert --no-edit d74c674
```

**Step 2: バックアップから復元**
```bash
cp "Terabox CRM.html.backup" "Terabox CRM.html"
git add "Terabox CRM.html"
git commit -m "Emergency restore from backup"
```

**Step 3: 詳細を確認**
- Git ログから何が間違ったかを確認
- バックアップ版と比較
- 問題を特定

**Step 4: 段階的な修正**
- 小さな部分から修正を再開
- 各ステップをテスト
- Git でコミット記錄を残す

---

## 👥 サポート連絡先

如遇問題或需要協助，請保存以下資訊：

- **バックアップ位置**: `/workspaces/TeraboxCRM/Terabox CRM.html.backup`
- **主要修改コミット**: `d74c674`
- **修改サマリー**: `/workspaces/TeraboxCRM/OPTIMIZATION_SUMMARY.md`
- **修改の詳細**: `git show d74c674`

---

## 📋 定期チェック

為了確保内容保持最新且合規，建议定期檢查：

### 每月检查
- [ ] 補助金表現の確認
- [ ] 競合他社との表現比較
- [ ] ユーザーフィードバックの確認

### 每季度検查
- [ ] 法規制の変更確認
- [ ] 公募要領の更新確認
- [ ] セキュリティアップデート

### 每年検查
- [ ] 全體的なコンプライアンス監査
- [ ] 新しい規制への対應
- [ ] デザイン・UX の見直し

---

**最後更新**: 2026年2月7日
**バージョン**: 1.0 (最適化版)
**ステータス**: 🟢 本番環境対応済み
