# 🧭 Pentest 全体像（2つの視点）

## 1. 実務フロー（Pentest の流れ）
1. **OSINT（外部情報収集）** ← NEW（Recon と分離）  
2. **Reconnaissance（技術的偵察）**  
3. **Enumeration（外部サービスの詳細調査）**  
4. **Initial Access（初期侵入）**  
5. **Local Enumeration（侵入後のローカル調査）**  
6. **Privilege Escalation（権限昇格）**  
7. **Credential Access（認証情報探索）**  
8. **Internal Enumeration（内部ネットワーク探索）**  
9. **Pivot / Port Forward（内部サービスへのアクセス）**  
10. **Lateral Movement（横展開）**  
11. **Repeat（繰り返し）**  
12. **Reporting（レポート）**

---

## 2. MITRE ATT&CK（攻撃者の行動体系）
Reconnaissance  
Resource Development  
Initial Access  
Execution  
Persistence  
Privilege Escalation  
Defense Evasion  
Credential Access  
Discovery  
Lateral Movement  
Collection  
Command and Control  
Exfiltration  
Impact  

Pentest-Playbook はこの体系を理解しながら、  
実務フローと結びつけて整理しています。

---

# 📘 章構成

Boot2Root のテンプレートから各章へリンクできるように、  
Pentest-Playbook は以下の構造で整理しています。

---

# 🔍 1. OSINT（外部情報収集）  
攻撃対象に関する **公開情報** を収集するフェーズ。

技術的偵察（Reconnaissance）とは別章。

### 内容（詳細は各ページへ）
- WHOIS  
- DNS / Subdomain Enumeration  
- Email Harvesting  
- Breach Data（HaveIBeenPwned など）  
- Public Code Repositories  
- Social Media  
- Wayback Machine  
- Google Dorking  
- Company / Employee OSINT  

👉 **詳細はこちら**  
`/OSINT/README.md`

---

# 🔎 2. Reconnaissance（技術的偵察）  
攻撃対象に対して **技術的にアクセスできる情報** を収集するフェーズ。

Boot2Root の Recon 章からリンクされる詳細ページ。

### 内容（詳細は各ページへ）
- Port Scan（Nmap / RustScan / Masscan）  
- Banner Grab  
- Version Detection  
- HTTP Header / SSL  
- Directory Bruteforce  
- Service Fingerprinting  
- Attack Surface Identification  

👉 **詳細はこちら**  
`/Reconnaissance/README.md`

---

# 📡 3. Enumeration（外部サービスの詳細調査）
Recon で見つけたサービスを深掘りし、  
攻撃可能なポイントを特定するフェーズ。

👉 `/Enumeration/README.md`

---

# 🚪 4. Initial Access（初期侵入）
Web / SMB / FTP / DB などから初期侵入を行う。

👉 `/Initial-Access/README.md`

---

# 🖥 5. Local Enumeration（侵入後のローカル調査）
侵入後の OS / プロセス / ファイル / アプリケーションを調査。

👉 `/Local-Enumeration/README.md`

---

# 🧗 6. Privilege Escalation（権限昇格）
Linux / Windows の権限昇格手法。

👉 `/Privilege-Escalation/README.md`

---

# 🔑 7. Credential Access（認証情報探索）
パスワード・鍵・トークン・DB情報などを探索。

👉 `/Credential-Access/README.md`

---

# 🛰 8. Internal Enumeration（内部ネットワーク探索）
netstat / ss / lsof / ip route などで内部サービスを調査。

👉 `/Internal-Enumeration/README.md`

---

# 🔁 9. Pivot / Port Forward（内部サービスへのアクセス）
SSH / Chisel / Ligolo-ng などで内部ネットワークへアクセス。

👉 `/Pivot/README.md`

---

# 🔀 10. Lateral Movement（横展開）
内部サービスから別マシンへ移動。

👉 `/Lateral-Movement/README.md`

---

# 📄 11. Reporting（レポート）
OSCP / 実務レポートの書き方。

👉 `/Reporting/README.md`

---

# 🔗 Boot2Root との連携

Boot2Root のテンプレートは軽量化し、  
**詳細は Pentest-Playbook の各章にリンクする構造**になっています。

例：  
Boot2Root の Recon →  
👉 Pentest-Playbook / Reconnaissance（詳細）

Boot2Root の OSINT →  
👉 Pentest-Playbook / OSINT（詳細）

Boot2Root の PrivEsc →  
👉 Pentest-Playbook / Privilege Escalation（詳細）

Boot2Root の Pivot →  
👉 Pentest-Playbook / Pivot（詳細）

---

# 🎯 目的
- 攻撃者の視点で環境を評価する  
- 実務的な Pentest の流れを体系化する  
- Boot2Root と連携して学習効率を最大化する  
- 防御側の改善に役立つ知識を蓄積する  
