# Pentest-Playbook  
ペネトレーションテスト（Pentest）を  
**MITRE ATT&CK × 実務的 Pentest フロー**  
の両面から体系化したプレイブックです。

Boot2Root（CTF形式の実戦ログ）と連携し、  
**Boot2Root = 実戦テンプレート / Pentest-Playbook = 詳細技術体系**  
という構造で運用します。

---

# 🧭 Pentest 全体像（実務フロー）

1. OSINT（外部情報収集）  
2. Reconnaissance（技術的偵察）  
3. Enumeration（外部サービスの詳細調査）  
4. Initial Access（初期侵入）  
5. Local Enumeration（侵入後のローカル調査）  
6. Privilege Escalation（権限昇格）  
7. Credential Access（認証情報探索）  
8. Internal Enumeration（内部ネットワーク探索）  
9. Pivot / Port Forward（内部サービスへのアクセス）  
10. Lateral Movement（横展開）  
11. Reporting（レポート）

---

# 📘 章構成

## 🔍 1. OSINT（外部情報収集）
👉 **[OSINT/README.md](./OSINT/README.md)**

---

## 🔎 2. Reconnaissance（技術的偵察）
👉 **[Reconnaissance/README.md](./Reconnaissance/README.md)**

---

## 📡 3. Enumeration（外部サービスの詳細調査）
👉 **[Enumeration/README.md](./Enumeration/README.md)**

---

## 🚪 4. Initial Access（初期侵入）
👉 **[Initial-Access/README.md](./Initial-Access/README.md)**

---

## 🖥 5. Local Enumeration（侵入後のローカル調査）
👉 **[Local-Enumeration/README.md](./Local-Enumeration/README.md)**

---

## 🧗 6. Privilege Escalation（権限昇格）
👉 **[Privilege-Escalation/README.md](./Privilege-Escalation/README.md)**

---

## 🔑 7. Credential Access（認証情報探索）
👉 **[Credential-Access/README.md](./Credential-Access/README.md)**

---

## 🛰 8. Internal Enumeration（内部ネットワーク探索）
👉 **[Internal-Enumeration/README.md](./Internal-Enumeration/README.md)**

---

## 🔁 9. Pivot / Port Forward（内部サービスへのアクセス）
👉 **[Pivot/README.md](./Pivot/README.md)**

---

## 🔀 10. Lateral Movement（横展開）
👉 **[Lateral-Movement/README.md](./Lateral-Movement/README.md)**

---

## 📄 11. Reporting（レポート）
👉 **[Reporting/README.md](./Reporting/README.md)**

---

# 🔗 Boot2Root との連携

Boot2Root のテンプレートは軽量化し、  
詳細は Pentest-Playbook の各章にリンクする構造になっています。

例：  
- Boot2Root の Recon → Pentest-Playbook / Reconnaissance  
- Boot2Root の OSINT → Pentest-Playbook / OSINT  
- Boot2Root の PrivEsc → Pentest-Playbook / Privilege Escalation  
- Boot2Root の Pivot → Pentest-Playbook / Pivot

---

# 🎯 目的
- 攻撃者の視点で環境を評価する  
- 実務的な Pentest の流れを体系化する  
- Boot2Root と連携して学習効率を最大化する  
- 防御側の改善に役立つ知識を蓄積する  
