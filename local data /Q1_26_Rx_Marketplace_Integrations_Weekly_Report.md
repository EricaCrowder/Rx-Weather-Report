# Q1'26 Core Rx Marketplace Integrations — Weekly Report

| **Team / Scope** | Marketplace Integrations (2026 Archive) |
|------------------|-----------------------------------------|
| **Report Date**  | Feb 18, 2026 (Week 5 & 6)               |
| **Data Through** | Feb 15, 2026                            |
| **Owner**        | Erica Crowder (Meeting DRI); respective DRIs per KR |

*Resources: [H1 2026 Rx Integrations OKR Tracking Sheet] · [Rx Marketplace Integrations Annual Plan] · [Rx Commerce Platform Integrations Annual Plan] · [MQI & HQI Sigma]*

---

## KPI Summary

| Metric | Current | Goal | Status | DRI |
|--------|---------|------|--------|-----|
| **North: Decrease Order Error Rate** | 0.28% | 0.26% | 🔴 Off Track | Kaitlin Dunn |
| **North: Increase HQI Feature Adoption** | 71.72% | 77.47% | 🔴 Off Track | Meg Ryan |
| **HQI Feature Adoption — 3P** | 66.36% | 72.13% | 🔴 Off Track | Erica Crowder |
| **HQI Feature Adoption — ANZ** | 1.40% | 1.40% | 🟢 On Track | Manik Mittal |
| **Decrease Order Error Rate — 3P** | 0.32% | 0.29% | 🔴 Off Track | Erica Crowder |
| **Decrease Order Error Rate — D2M** | 0.23% | 0.21% | 🔴 Off Track | Kaitlin Dunn |
| **Decrease Order Error Rate — ANZ** | 0.25% | 0.26% | 🟢 On Track | Manik Mittal |
| **Detailed Error Spec — 3P** | 3.34% | 3.34% | 🟢 On Track | Erica Crowder |
| **Integrated Promos — 3P** | 3.87% | 6.37% | 🟡 At Risk | Erica Crowder |
| **Item Polling — 3P** | 7.70% | 8.16% | 🟡 At Risk | Erica Crowder |

---

## Key Takeaways

- **POS Error Rate:** 3P and DTM are behind target; **ANZ is on track** (0.25% vs 0.26% goal). Clover POS rate-limiting mitigated; long-term fix (86'ing webhook) in progress. Self-healing menu/item impact delayed to early April.
- **HQI:** 3P and ANZ on track for adoption; providers building toward **end-of-April launch**. Px waiting on certification for integrated promos. **Clover SSIO** go-live bugs resolved; awaiting Clover go-live date.
- **Win:** Blocked harmful SSME edits and added POS-aware warnings → **stat sig** reductions in PFQ (**-27.4%**) and CXI (**-23.8%**), **~$180K** annualized GOV unlocked. *Slack thread.*
- **Self-healing:** Store experiment on track for **3/9** launch; menu/item experiment relaunch aligned with store experiment (**late March / early April**). Clover item polling re-rollout paused until rate limits confirmed.
- **Universal Error Spec:** Challenging for many Px by April; team tracking **partner-by-partner** to keep top of mind. **OCA** and **OCV OpenAPI** (ETA 2/27) in progress; provider timelines skewed by HQI + split tax priorities.

---

## 🚀 Progress This Period

### High Quality Integrations (HQI)

- **3P:** Aloha SSIO/Activate targeting EOM launch with Coupa Cafe. **Toast Promos** blocked on A&P stacked-promo decision; Urban Piper & Otter integrated promos code-ready; Otter testing w/c 2/18. **Clover SSIO** unblocked; awaiting Clover GA date. Aloha Item Polling brief completed 2/9; eng work planned w/b 2/17.
- **DTM:** No HQI KR; ORS progress: Brinker launched (early Jan), Wingstop building, Insomnia completed 1/30. Co-funded promos: CMG building, DD to scope. **SG:** DD menu formatting for full product selection on DDMP; Wraps pilot 2/18, full rollout 2/20.
- **ANZ:** Redcat SSIO w/ Store Activate completed. **Abacus Item Polling:** staging dev done; testing in staging; aligning GTM for production. **Redcat Integrated Promos:** prioritising due to merchant demand; meeting scheduled for alignment.

### POS Error Rate / Self-Healing

- **Self-Healing Store:** Dev kicked off w/b 2/17 (~2 weeks); experiment on ATD durations targeting **early March** (tracking **3/9**).
- **Self-Healing Menu/Item:** Analysis ongoing on menu-pull experiment cxls; relaunch planned with store experiment (**late March / early April**).
- **3P:** Olo stale validations in TAM testing (w/c 2/16), experiment to follow. Toast OCV experiment live 2/2. OCV dev in progress; completion target **Feb 27**. Olo OCV self-healing readout directionally positive but not stat sig.
- **D2M:** TH OCV experiment launched 2/9. **Chipotle OCV** launched 2/12; **rolled back 2/17** due to capacity logic impact—investigating with Chipotle. PJI Canada (S4D): 4 stores on OpenAPI. DPC LDA bug in dev; pivoting to QA.
- **ANZ:** **0.25%** (goal 0.26%). Abacus MQI remediation &lt;1% by June 26; currently **1.36%**; on track in 2–3 weeks if rates hold.

### BD / Other

- **LOE:** Sizing willingness to pay for Toast HQI status for renewal negotiation.
- **Square:** Updated AU redlines shipped **2/12**.

---

## ⚠️ Risks / Blockers

| Risk | Impact | Status |
|------|--------|--------|
| **Self-Healing Menu/Item** | Delayed impact to POS error improvement | Analysis on increased cxls ongoing; relaunch with store experiment (late March / early April) |
| **Clover Item Polling** | HQI + POS error rate; re-rollout paused | Need Clover rate limits before reactivating; re-test with deactivation-only to 100 stores for directional signal |
| **OCA** | Timeline slip | Dev paused; product re-scoping with peers + provider/merchant research; next: draft product plan and discovery timeline |
| **OCV OpenAPI** | Partner capacity | ETA 2/27; spec on dev docs 2/23. Checkmate, Qu, Otter, Chowly—no official dev timeline; HQI + split tax prioritized |
| **Universal Error Spec** | April compliance for many Px | Partner-by-partner tracking; Checkmate requested extension (Popeyes CAN different POS) |
| **Toast Integrated Promos** | Testing blocked | A&P disabled US promo stacking; working to enable for test store |
| **CMG OCV** | D2M POS error / capacity | Rollback 2/17; validation endpoint reserves capacity per call → multiple calls/order consuming slots; investigating with Chipotle |
| **Toast/Clover Offboarding** | Store offboarding improvements | Blocked until fundamental improvements complete |

---

## 🎯 Next Milestones

| Milestone | Target |
|-----------|--------|
| Self-Healing Store experiment launch | **3/9** |
| OCV OpenAPI spec in release notes | **2/23**; ETA **2/27** |
| Olo stale validations | TAM testing w/c 2/16; experiment shortly after |
| Order Cart Validations (OCV) dev complete | **Feb 27** |
| Self-Healing Menu/Item experiment relaunch | Late March / early April (with store experiment) |
| Aloha SSIO/Activate with Coupa Cafe | EOM |
| Abacus MQI &lt;1% / MQI compliant | 2–3 weeks at current rates (ANZ) |
| HQI / DPIP April compliance | End of April (Px build; certification in progress) |

---

## 🤝 Asks

- **Product / Partnerships:** Confirm **Clover SSIO GA date** following bug resolution.
- **Clover:** Provide **rate limits** to assess Clover item polling re-rollout risk.
- **A&P / Promos:** Enable **stacked promo** for Toast test store to unblock final testing.
- **Checkmate:** Align on **Universal Error Spec** and DPIP timelines (update expected ~Feb 25).
- **Chipotle:** Align on **OCV + capacity logic** so OCV can be re-launched without impacting store volume.

---

*Agenda: ~5 min pre-read, then live discussion. Mark live topics “DT,” offline “C.”*
