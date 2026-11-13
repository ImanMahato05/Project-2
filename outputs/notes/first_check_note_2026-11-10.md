# First-check note (Stage 0, Task 0.8)
Date: 2026-11-10
Forcing: Daymet (CAMELS v1p2). PE: airGR::PE_Oudin() with CAMELS gauge_lat.
Primary outcome: ln(mean dry-season flow). No interaction terms.

## Sample
- Candidate pool: 671 catchments; complete recharge-dry pairs in the pool: 22565.
- Primary sample: 477 catchments (frac_snow < 0.2, >= 20 complete pairs); 16066 complete pairs.
- Catchments with zero dry-season flow in > 10% of seasons: 30 (excluded from the primary model, listed separately).
- Primary model sample: 14863 rows, 447 catchments, 112 HUC-4 clusters.

## Checks
- Runoff-ratio check (Oct 1989 - Sep 2009): r = 0.9945 over 670 catchments (requirement r > 0.95).
- Some substantial catchment-level differences remain and are documented in the validation output; their causes have not yet been resolved.
- PE vs airGR re-computation: max abs difference 2.63e-07 mm/day (CSV rounding).
- G_P decomposition: max abs error 3.33e-16.
- Within-catchment correlation of G_P with P_s (primary sample): mean -0.643, median -0.649.
- Python and R (fixest) coefficients agree.

## Storage and climate (primary sample)
- r(storage, aridity) = 0.027; r(storage, mean wet-day depth) = 0.471.
- Catchments with < 90% valid storage coverage: [{'gauge_id': '10259200', 'valid_fraction': 0.4298863132155238}].
- Aridity range within each storage tercile:
           n  aridity_min  aridity_max
tercile                               
low      159        0.543        3.039
medium   159        0.482        2.673
high     159        0.233        4.763

## Overlap of seasonal totals (model sample)
- 439 of 447 catchments (98.2%) have overlapping totals.
- No overlap (comparisons conditional on similar totals): 01487000, 08070200, 11141280, 11143000, 11162500, 11451100, 11532500, 14400000.

## Usable variation
- Pooled within-catchment SD of G_P: 0.03108.
- SD of the residual of Gs after totals, controls and fixed effects: 0.745.
- sd_w sample: Task 0.5 seasonal panel, primary sample, defined G_P (16064 rows).

## Main effect (no interaction terms; SE clustered by HUC-4)
- Effect per within-catchment SD of G_P: -4.04% in dry-season flow.
- 95% interval: -7.12% to -0.86%; half-width 3.13 percentage points.
- Interval excludes zero: True. Interval within +/-5%: False.
- Within R2: 0.358.

## Decision
- Half-width <= 5 percentage points: Phase 1 continues as designed, whatever the sign or size of the estimate.
- Storage and aridity |r| <= 0.7: storage and aridity are treated as separable in this sample.

## Row accounting (primary sample to model sample)
- Complete pairs in the primary sample: 16066.
- Rows with any missing model variable: 597
  (zero dry-season flow, so ln undefined: 456; undefined G_P: 2;
  q_ante not available: 143; reasons overlap).
- Rows with all model variables: 15469.
- Rows removed because the catchment has zero flow in > 10% of seasons: 606.
- Primary model rows: 14863.

## Additional details
- Storage correlations in the model sample (447 catchments): r(storage, aridity) = -0.056; r(storage, wet-day depth) = 0.500.
- Runoff-ratio check: 670 of 671 catchments compared; CAMELS runoff_ratio is missing for ['03281100'].
- The catchment below 90% storage coverage (10259200) is in the zero-flow list and is outside the model sample.
