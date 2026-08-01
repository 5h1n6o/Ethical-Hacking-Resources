# Reporting（レポート作成）

Reporting は、ペネトレーションテストの最終フェーズであり、  
**発見した脆弱性・侵入経路・影響範囲・再現手順・改善策を体系的にまとめるフェーズ**です。

Boot2Root テンプレートの **Reporting 章の詳細版**として機能します。

---

# 🎯 目的

- 発見した脆弱性を正確に記録する  
- 再現性のある手順を提供する  
- 影響範囲とリスクを明確化する  
- 改善策を提示し、組織のセキュリティ向上に貢献する  
- OSCP レポート品質のドキュメントを作成する  

---

# 📘 目次

1. レポート構成（全体像）  
2. 実行環境・スコープ  
3. 発見された脆弱性一覧  
4. 各脆弱性の詳細  
5. 攻撃経路（Kill Chain）  
6. 証拠（Screenshots / Logs）  
7. 改善策（Mitigation）  
8. Boot2Root との連携  
9. レポートテンプレート（コピー用）

---

# 1. レポート構成（全体像）

レポートは以下の構成が最も実務的で OSCP にも準拠する：

```
1. Executive Summary（概要）
2. Scope（対象範囲）
3. Methodology（手法）
4. Findings（脆弱性一覧）
5. Detailed Findings（脆弱性詳細）
6. Attack Path（攻撃経路）
7. Evidence（証拠）
8. Recommendations（改善策）
9. Appendix（補足）
```

---

# 2. 実行環境・スコープ

```
ターゲット: 192.168.1.10
期間: 2026/08/01 - 2026/08/03
手法: Blackbox / OSINT / Recon / Enumeration / Exploitation / PrivEsc / Pivot / Lateral Movement
```

---

# 3. 発見された脆弱性一覧

例：

| ID | 脆弱性 | 重要度 | 影響範囲 |
|----|--------|--------|-----------|
| F-01 | SQL Injection | High | 認証バイパス・DB漏洩 |
| F-02 | Weak SSH Password | High | 横展開可能 |
| F-03 | Misconfigured Cron | Medium | PrivEsc 可能 |
| F-04 | Internal Web Exposure | Medium
