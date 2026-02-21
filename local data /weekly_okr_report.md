# Q1'26 Core Rx Marketplace Integrations — Weekly Report

**Team** Marketplace Integrations (2026 Archive) · **Report** Feb 18, 2026 (Week 5 & 6) · **Data through** Feb 15 · **DRI** Erica Crowder  
*Resources: [H1 2026 OKR Tracking] · [Rx Integrations Annual Plan] · [MQI & HQI Sigma]*

---

## KPI Dashboard

| | **Order Error Rate** | **HQI Adoption** |
|--|----------------------|------------------|
| **North Star** | 0.28% / 0.26% goal → 🔴 Off Track | 71.72% / 77.47% goal → 🔴 Off Track |
| **3P** | 0.32% / 0.29% → 🔴 Off Track | 66.36% / 72.13% → 🔴 Off Track |
| **D2M** | 0.23% / 0.21% → 🔴 Off Track | — |
| **ANZ** | 0.25% / 0.26% → 🟢 On Track | 1.40% / 1.40% → 🟢 On Track |

| **Supporting KRs** | Current | Goal | Status |
|-------------------|--------|------|--------|
| Detailed Error Spec (3P) | 3.34% | 3.34% | 🟢 On Track |
| Integrated Promos (3P) | 3.87% | 6.37% | 🟡 At Risk |
| Item Polling (3P) | 7.70% | 8.16% | 🟡 At Risk |

---

## 🟢 Positive Updates

- **ANZ:** Order error **0.25%** (at goal). Abacus MQI on track to &lt;1% in 2–3 weeks; Redcat SSIO + Store Activate done; Abacus Item Polling & Redcat Integrated Promos pulled forward.
- **SSME win:** Blocked harmful edits + POS-aware warnings → **PFQ -27.4%**, **CXI -23.8%**, **~$180K** annualized GOV. *Slack thread.*
- **HQI build:** Providers on track for end-of-April launch. Clover SSIO go-live bugs resolved; awaiting Clover GA date. Aloha SSIO/Activate targeting EOM with Coupa Cafe. Urban Piper & Otter integrated promos code-ready; Otter testing w/c 2/18.
- **Self-Healing Store:** Dev kicked off w/b 2/17; experiment on track for **3/9** launch.
- **DTM:** ORS—Brinker live, Wingstop building, Insomnia done 1/30. SG Wraps pilot 2/18, full rollout 2/20. TH OCV experiment live 2/9.
- **BD:** LOE sizing Toast HQI for renewal; Square AU redlines shipped 2/12.

---

## 🟡 Watchouts

- **Integrated Promos (3P):** At **60.75%** of goal; Toast blocked on A&P stacked-promo decision for test store.
- **Item Polling (3P):** Slightly behind goal; Clover re-rollout paused until rate limits confirmed—re-test with deactivation-only to 100 stores for signal.
- **Universal Error Spec:** April is tight for many Px; partner-by-partner tracking. Checkmate asked for extension (Popeyes CAN different POS); timeline update ~Feb 25.
- **OCV OpenAPI:** ETA 2/27, spec 2/23. Checkmate, Qu, Otter, Chowly prioritizing HQI + split tax—no firm dev dates yet.
- **Self-Healing Menu/Item:** Relaunch aligned with store experiment (late March / early April); analysis on prior cxl increase still underway.

---

## 🔴 Critical Risks

- **North Star KRs off track:** Order Error Rate and HQI Adoption both behind plan. 3P and D2M driving Order Error gap; Clover POS mitigated but long-term 86'ing webhook still in progress.
- **CMG OCV:** Rolled back **2/17**. Validation endpoint reserves capacity per call; multiple calls/order consumed slots and impacted volume. Need Chipotle alignment on OCV + capacity logic before re-launch.
- **OCA:** Dev paused. Product re-scoping with peers and provider/merchant research; draft product plan and discovery timeline needed.
- **Toast/Clover offboarding:** Blocked until fundamental store off-boarding improvements ship.

---

## 🚀 Progress This Period

- **3P:** Olo stale validations in TAM (w/c 2/16), experiment next. Toast OCV live 2/2. OCV dev complete target Feb 27. Aloha Item Polling eng w/b 2/17.
- **D2M:** PJI Canada—4 stores on OpenAPI. DPC LDA pivoting to QA. Cxl spikes: Brinker under investigation; Dunkin/BK CAN recovered.
- **ANZ:** Abacus staging testing; Redcat integrated promos meeting scheduled. Store onboarding designs complete; ~4 wk eng + 1–2 wk ship review.

---

## 🎯 Next Milestones

| Milestone | Target |
|-----------|--------|
| Self-Healing Store experiment | **3/9** |
| OCV OpenAPI / release notes | **2/23** · **2/27** |
| OCV dev complete | **Feb 27** |
| Aloha SSIO/Activate (Coupa Cafe) | EOM |
| Menu/Item + Store experiment relaunch | Late Mar / early Apr |
| HQI / DPIP April compliance | End of April |

---

## 🤝 Asks

- **Product/Partnerships:** Clover SSIO GA date post bug resolution.
- **Clover:** Rate limits for item polling re-rollout.
- **A&P:** Enable stacked promo for Toast test store.
- **Checkmate:** Universal Error Spec & DPIP timelines (~Feb 25).
- **Chipotle:** OCV + capacity logic path to re-launch.
