# Reconnaissance（技術的偵察）

Reconnaissance は、攻撃対象に対して **技術的にアクセス可能な情報を収集するフェーズ**です。  
OSINT（公開情報収集）とは別章であり、ここでは「実際にターゲットへアクセスして得られる情報」を扱います。

Boot2Root テンプレートの **Recon 章の詳細版**として機能します。

---

# 🎯 目的

- 外部から見えるサービスを把握する  
- 攻撃可能なサービスを特定する  
- 次の Enumeration / Initial Access の方向性を決める  
- 内部ネットワークの存在を推測する  
- OSCP レポートで必要な「攻撃の根拠」を整理する  

---

# 📘 目次

1. Port Scanning  
   - Nmap  
   - RustScan  
   - Masscan  
2. Banner Grab / Version Detection  
3. HTTP / SSL Recon  
4. SMB / FTP / SSH Recon  
5. Attack Surface Identification  
6. Boot2Root との連携

---

# 1. Port Scanning

ポートスキャンは Recon の中心であり、  
**攻撃の入口を決める最重要フェーズ**です。

---

## 1.1 Nmap（最重要）

### 主なスキャン
```
nmap -p- -T4 -v <TARGET>
nmap -sC -sV -O -T4 <TARGET>
nmap --script vuln <TARGET>
```

### 確認ポイント
- 開いているポート  
- サービスの種類  
- バージョン（古いほど exploit が多い）  
- Web / SMB / FTP / SSH の有無  
- 内部 Web（8080/8000/5000）  
- DB（3306 / 5432）  
- Redis（6379）  

---

## 1.2 RustScan（高速）

```
rustscan -a <TARGET> --ulimit 5000 -- -sC -sV
```

### 使いどころ
- ポートだけ高速で知りたいとき  
- Nmap の前処理として最適  

---

## 1.3 Masscan（超高速）

```
masscan -p1-65535 <TARGET> --rate=10000
```

### 使いどころ
- 大規模ポートスキャン  
- FW / ACL の存在確認  

---

# 2. Banner Grab / Version Detection

```
nc -nv <TARGET> <PORT>
curl -I http://<TARGET>
openssl s_client -connect <TARGET>:443
```

### 目的
- サービスの種類  
- バージョン  
- ミドルウェア  
- 内部ホスト名（SSL CN/SAN）  

---

# 3. HTTP / SSL Recon

### HTTP
```
curl -I http://<TARGET>
whatweb <TARGET>
ffuf -u http://<TARGET>/FUZZ -w common.txt
```

### SSL
```
openssl s_client -connect <TARGET>:443
```

### 確認ポイント
- Server: Apache / nginx / IIS  
- X-Powered-By: PHP / ASP.NET  
- admin パネルの存在  
- 内部ホスト名（CN/SAN）  

---

# 4. SMB / FTP / SSH Recon

## SMB
```
smbclient -N -L //<TARGET>/
```

### 確認ポイント
- anonymous  
- 認証情報  
- バックアップファイル  

---

## FTP
```
ftp <TARGET>
```

### 確認ポイント
- anonymous  
- 書き込み可能か  
- Web ソースコードの有無  

---

## SSH
```
ssh -v user@<TARGET>
```

### 確認ポイント
- バナー情報  
- OS / バージョン  
- ユーザー名の推測  

---

# 5. Attack Surface Identification

Recon の結果から、攻撃可能な面を特定する。

### 主な攻撃面
- Web（最も突破口が多い）  
- SMB（認証情報）  
- FTP（WebShell）  
- DB（弱パスワード）  
- Redis（未認証）  
- 内部 Web（Pivot 必須）  

---

# 6. Boot2Root との連携

Boot2Root の **Recon 章**は軽量化されており、  
詳細はこのページにリンクされます。

Boot2Root の流れ：

```
Recon
↓
Enumeration
↓
Initial Access
```

そのため、Boot2Root では結果だけ記録し、  
技術的な深掘りは Pentest-Playbook の Reconnaissance に集約します。

---

# 🎯 この章の目的

- Recon の技術体系を 1ページに集約  
- Boot2Root の軽量テンプレートと連携  
- OSCP レポート品質の情報整理  
- 将来の構造変更にも強い設計  
