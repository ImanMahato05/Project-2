# Stage 0 rules fixed before the first-check model
Date: 2026-11-10

- Candidate pool: 671 CAMELS catchments.
- Primary sample: 477 catchments (frac_snow < 0.2, >= 20 complete recharge-dry pairs).
- Complete pairs in the primary sample: 16066.
- Catchments with zero dry-season flow in > 10% of seasons: 30.
  Rule: these are excluded from the primary model and listed separately.
- Remaining zero-flow seasons: ln(flow) is undefined, so these rows are dropped.
- Rows with undefined G_P (no day >= 1 mm) are dropped.
- q_ante requires all 30 antecedent days present and valid.
- Primary model sample: 14863 rows, 447 catchments, 112 HUC-4 clusters.
- sd_w computed on the Task 0.5 seasonal panel (primary sample, defined G_P): 16064 rows.
- Model: ln_qdry ~ Gs + P + P_c2 + T + PE + q_ante + P_dry + PE_dry | gauge_id + season_year, SE clustered by HUC-4. No interaction terms.
- Decision rule: half-width of the 95% CI <= 5% -> Phase 1 as designed; > 5% -> mechanism experiments.
