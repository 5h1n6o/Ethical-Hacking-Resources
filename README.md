# Pentest-Playbook

このリポジトリは、ペネトレーションテスト（Pentest）を  
**MITRE ATT&CK の攻撃者行動体系**と  
**実務的な Pentest の流れ（Recon → Exploit → Post-Exploitation）**  
の両面から体系化したプレイブックです。

---

# 🧭 Pentest 全体像（2つの視点）

## 1. 実務フロー（Pentest の流れ）
Pentest の実務は以下の流れで進みます：

1. **OSINT / Reconnaissance（情報収集）**  
2. **Resource Development（攻撃準備）**  
3. **Initial Access（初期侵入）**  
4. **Execution（実行）**  
5. **Post-Exploitation（侵入後活動）**  
6. **Reporting（レポート）**

この流れは、実際の企業環境を対象とした Pentest や Bug Bounty と同じです。

---

## 2. MITRE ATT&CK（攻撃者の行動体系）
攻撃者は以下の戦術に沿って行動します：

- Reconnaissance  
- Resource Development  
- Initial Access  
- Execution  
- Persistence  
- Privilege Escalation  
- Defense Evasion  
- Credential Access  
- Discovery  
- Lateral Movement  
- Collection  
- Command and Control  
- Exfiltration  
- Impact  

Pentest はこの体系を理解することで、  
攻撃者の視点で環境を評価できるようになります。

---

# 📘 章構成（融合版）

## OSINT（情報収集）
- Subdomain Enumeration  
- Port Scan  
- Directory Bruteforce  
- OSINT / Public Data  
- JS / Wayback Analysis  

---

## Reconnaissance（偵察）
- サービス調査  
- バナーグラブ  
- バージョン調査  
- 攻撃面の特定  

---

## Resource Development（リソース開発）
- Payload 作成  
- Infrastructure（C2 / VPS）  
- フィッシング準備  
- アカウント準備  

---

## Initial Access（初期アクセス）
- Web Exploit（SQLi / XSS / SSRF / RCE）  
- Cloud Misconfig  
- Credential Stuffing  
- Phishing  
- Remote Admin Tools  

---

## Execution（実行）
- コマンド実行  
- スクリプト実行  
- WebShell / Reverse Shell  

---

## Persistence（永続化）
- Scheduled Tasks  
- Registry Run Keys  
- Cloud IAM Abuse  
- SSH Keys  

---

## Privilege Escalation（権限昇格）
- Windows / Linux  
- Kernel Exploit  
- Misconfig Abuse  

---

## Defense Evasion（防衛回避）
- Logging Bypass  
- AV/EDR Evasion  
- Obfuscation  

---

## Credential Access（認証情報アクセス）
- LSASS Dump  
- Token Theft  
- Cloud Keys  

---

## Discovery（探索）
- Network Scan  
- User / Group Enumeration  
- Cloud Resource Discovery  

---

## Lateral Movement（水平展開）
- Pass-the-Hash  
- Pass-the-Ticket  
- SSH Pivot  
- Cloud Lateral Movement  

---

## Collection（収集）
- File Collection  
- Screenshot  
- Keylogging  

---

## Command and Control（C2）
- Cobalt Strike  
- Sliver  
- Mythic  
- Custom C2  

---

## Exfiltration（持ち出し）
- Cloud Storage  
- Encrypted Channel  
- Covert Channel  

---

## Impact（影響）
- Data Destruction  
- Account Takeover  
- Service Disruption  

---

# 🧪 使用ツール
- Burp Suite  
- ffuf  
- nmap  
- impacket  
- Wireshark  
- Sysinternals  
- Cobalt Strike / Sliver  

---

# 🎯 目的
- 攻撃者の視点で環境を評価する  
- 実務的な Pentest の流れを体系化する  
- 防御側の改善に役立つ知識を蓄積する  

