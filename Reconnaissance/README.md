# Reconnaissance（技術的偵察）

Reconnaissance は、攻撃対象に対して **技術的にアクセス可能な情報を収集するフェーズ**です。  
OSINT（公開情報収集）とは別章であり、ここでは「実際にターゲットへアクセスして得られる情報」を扱います。

---

# 🎯 目的

- 外部から見えるサービスを把握する  
- 攻撃可能なサービスを特定する  
- 次の Enumeration / Initial Access の方向性を決める  
- 内部ネットワークの存在を推測する  


## 🔍 攻撃フロー
1. フルポートスキャン  
2. サービス検出  
3. バナー取得  
4. OS推定  
5. 次の Enumeration の方向性を決定する

## 🛠 代表コマンドの使用例

### 初回ポートスキャン

```
nmap -Pn -T4 -A -oN scanlog.txt <TARGET_IP>
nmap -Pn -T4 -A -oX scanlog.xml <TARGET_IP>
```

### フルポートスキャン

```
nmap -Pn -T4 -A -p- <TARGET_IP>
nmap -p- --min-rate 5000 -sS -Pn <TARGET_IP> -oN nmap_all_tcp.txt
```

### UDP Top 100 Scan

```
nmap -sU --top-ports 100 -Pn <TARGET_IP> -oN nmap_udp.txt
```

### ネットワークに対するスキャン

```
nmap -sn xx.xx.xx.0/24
nmap -sn xx.xx.xx.1-253
nmap -sn xx.xx.xx.\*
```

### nmapスクリプト実行

```
nmap --script discovery <TARGET_IP>
nmap --script vuln <TARGET_IP>
```

### rustscan（高速）

```
rustscan -a <target> --ulimit 5000
```

### masscan（超高速）
```
masscan <target>/32 -p0-65535 --rate=10000
```

### バナー取得

```
nc <target> 80
```

```
openssl s_client -connect <TARGET>:443
```

### ヘッダー情報

```
curl -LI http://<target_ip>
```

## 🔎 攻撃面の特定（Attack Surface Identification）

Recon の結果から、攻撃可能な面を特定する。

### 主な攻撃面
- **Web**（最も突破口が多い）  
- **SMB**（認証情報・共有）  
- **FTP**（WebShell配置）  
- **DB（MySQL/MSSQL）**（弱パスワード）  
- **Redis**（未認証）  
- **SSH**（弱パスワード / 鍵）  
- **内部 Web**（Pivot 必須）  
- **AD関連サービス（SMB / LDAP / Kerberos）**  
  - OSCP 2024+ では特に重要  
  - Kerberoasting / AS-REP Roasting の前提確認  
  - LDAP でユーザー列挙可能か  
  - SMB で共有が見えるか

## 🧪 チートシート：Recon で確認すべき項目

### 🔹 SMB（後続の Enumeration に必須）
- ポート 445 が開いているか  
- Anonymous アクセス可否  
- ドメイン名の取得  

### 🔹 LDAP
- ポート 389 / 636  
- BaseDN の推測  
- ユーザー列挙の可否  

### 🔹 Kerberos
- ポート 88  
- ドメイン名  
- AS-REP Roasting の対象ユーザーが存在しそうか  

### 🔹 MSSQL
- ポート 1433  
- 認証方式  
- xp_cmdshell の可能性  

### 🔹 WinRM
- ポート 5985 / 5986  
- 後続の Initial Access に直結  

### 🔹 SNMP / SMTP / NFS
- OSCP では情報漏洩の起点になりやすい  

---
## 📚 詳細（ツールの使い方）
ツールの詳細な使い方は Security-Tools に集約しています。

- [nmap](https://github.com/5h1n6o/Pentest-Playbook/blob/main/Reconnaissance/README.md#11-nmap%E6%9C%80%E9%87%8D%E8%A6%81)  
- [nc(netcat)](https://github.com/5h1n6o/Security-Tools/blob/main/netcat/README.md)
- [curl]([Curl/README.md](https://github.com/5h1n6o/Security-Tools/blob/main/Curl/README.md))

## 📘Boot2Root との連携

Boot2Root の流れ：

```
Recon
↓
Enumeration
↓
Initial Access
```

Boot2Root では結果だけ記録し、  
技術的な深掘りは Pentest-Playbook の Reconnaissance に集約します。
