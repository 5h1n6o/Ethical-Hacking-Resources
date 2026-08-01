# OSINT（Open Source Intelligence / 公開情報収集）

OSINT は、攻撃対象に関する **公開情報を収集するフェーズ**です。  
Reconnaissance（技術的偵察）とは別章であり、  
ここでは「ターゲットに直接アクセスせずに得られる情報」を扱います。

Boot2Root テンプレートの **OSINT 章の詳細版**として機能します。

---

# 🎯 目的

- 公開情報から攻撃対象の全体像を把握する  
- ドメイン・サブドメイン・メール・従業員情報を収集する  
- 過去の漏洩情報（Breach Data）を確認する  
- 攻撃面（Attack Surface）を Recon 前に予測する  
- OSCP レポートで必要な「事前調査の根拠」を整理する  

---

# 📘 目次

1. Domain & WHOIS 情報  
2. DNS / Subdomain Enumeration  
3. Email Harvesting  
4. Breach Data（漏洩情報）  
5. Public Code Repositories  
6. Social Media OSINT  
7. Wayback Machine  
8. Google Dorking  
9. Attack Surface Prediction  
10. Boot2Root との連携

---

# 1. Domain & WHOIS 情報

## WHOIS
```
whois example.com
```

### 確認ポイント
- 管理者メールアドレス  
- 組織名  
- ネームサーバ  
- 登録日・更新日  

### 目的
- メールアドレス → パスワード推測  
- 組織名 → OSINT の方向性  
- ネームサーバ → DNS の構造把握  

---

# 2. DNS / Subdomain Enumeration

## DNS 基本情報
```
dig A example.com
dig NS example.com
dig MX example.com
```

## サブドメイン探索
```
subfinder -d example.com
amass enum -d example.com
```

## DNSゾーン転送（AXFR）
```
dig AXFR example.com @ns1.example.com
```

### 確認ポイント
- admin / dev / staging / api  
- 内部ホスト名  
- メールサーバ  
- AXFR が通る場合 → 大量の内部情報が漏洩  

---

# 3. Email Harvesting

```
theHarvester -d example.com -b all
```

### 確認ポイント
- 従業員メール  
- パスワード推測の材料  
- 社内の命名規則（firstname.lastname など）  

---

# 4. Breach Data（漏洩情報）

```
haveibeenpwned.com
dehashed.com
```

### 確認ポイント
- 過去の漏洩パスワード  
- 再利用パスワードの可能性  
- 社内アカウントの存在  

---

# 5. Public Code Repositories

```
github.com/org/example
gitlab.com/example
```

### 確認ポイント
- APIキー  
- 認証情報  
- 内部ツール  
- 社内の技術スタック  

---

# 6. Social Media OSINT

### 対象
- LinkedIn  
- Twitter  
- Facebook  
- 技術ブログ  

### 確認ポイント
- 従業員の役職  
- 使用技術（AWS / Azure / Cisco / Linux）  
- 社内の構成（部署・チーム）  
- 新規サービスの情報  

---

# 7. Wayback Machine

```
https://web.archive.org/web/*/example.com
```

### 確認ポイント
- 過去の管理画面  
- 古い API  
- 削除されたディレクトリ  
- 過去の JS ファイル  

---

# 8. Google Dorking

```
site:example.com
site:example.com intitle:"index of"
site:example.com filetype:pdf
site:example.com "password"
```

### 確認ポイント
- 公開ディレクトリ  
- 認証情報  
- PDF / DOCX 内の内部情報  
- 誤公開されたファイル  

---

# 9. Attack Surface Prediction

OSINT の結果から、Recon の方向性を決める。

### 例：
- サブドメインが多い → Web が攻撃面  
- 従業員メールが多い → パスワードスプレー  
- GitHub に APIキー → 初期侵入  
- 古い JS → Web exploit  
- 過去の漏洩パスワード → SSH / SMB  

---

# 10. Boot2Root との連携

Boot2Root の OSINT 章は軽量化されており、  
詳細はこのページにリンクされます。

Boot2Root の流れ：

```
OSINT
↓
Reconnaissance
↓
Enumeration
```

そのため、Boot2Root では結果だけ記録し、  
技術的な深掘りは Pentest-Playbook の OSINT に集約します。

---

# 🎯 この章の目的

- OSINT の技術体系を 1ページに集約  
- Boot2Root の軽量テンプレートと連携  
- OSCP レポート品質の情報整理  
- 将来の構造変更にも強い設計  
