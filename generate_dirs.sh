#!/bin/bash

# Pentest-Playbook 章一覧（番号なし）
chapters=(
  "OSINT"
  "Reconnaissance"
  "Enumeration"
  "Initial-Access"
  "Local-Enumeration"
  "Privilege-Escalation"
  "Credential-Access"
  "Internal-Enumeration"
  "Pivot"
  "Lateral-Movement"
  "Reporting"
)

# 各章ディレクトリと README.md を作成
for chapter in "${chapters[@]}"; do
  mkdir -p "$chapter"
  cat <<EOF > "$chapter/README.md"
# $chapter

この章では **$chapter** に関する詳細な技術情報をまとめています。

Boot2Root テンプレートからこの章にリンクすることで、
実戦ログ（Boot2Root）と技術体系（Pentest-Playbook）が連携します。

---

## 📘 内容
（ここに章の詳細を記述）

---

## 🔗 Boot2Root との連携
Boot2Root の該当フェーズ：
- $chapter

EOF
done

echo "Pentest-Playbook の章ディレクトリと README.md を作成しました。（番号なし構造）"

