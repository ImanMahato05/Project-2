# Stage 0 Addendum — Corrections and Additional Checks

**Date:** 23 November 2026

**Related records:**
- `task0_prespecified_rules_2026-10-28.md`
- `first_check_note_2026-10-28.md`

## 1. Purpose of this addendum

This addendum records the corrections and additional checks carried out after the original Stage 0 first-check analysis dated 28 October 2026.

The purpose was to check the consistency of the catchment areas used for discharge conversion, repeat the runoff-ratio validation, update the usable-variation calculation, and examine the effect of rainfall concentration when zero-flow observations are retained.

The original rule note and first-check note retain their original date. This addendum provides a separate record of the subsequent work.

## 2. Earlier first-check result

The original Stage 0 log-linear model estimated the association between recharge-season rainfall concentration and subsequent dry-season mean streamflow.

The earlier estimate was:

- Effect of Gs: -4.04%.
- 95% confidence interval: -7.12% to -0.86%.
- Half-width of the confidence interval: 3.13 percentage points.
- Observations: 14,863.
- Catchments: 447.
- HUC-4 clusters: 112.

The confidence interval excluded zero, indicating a negative association in this model. Its half-width was below the pre-specified 5-percentage-point threshold.

According to the decision rule in the original first-check note, Phase 1 therefore continues as designed.

## 3. Corrections made after the earlier run

### 3.1 Discharge conversion using CAMELS area_gages2

In the earlier processing, discharge was converted from cubic feet per second (cfs) to millimetres per day using the catchment area recorded in the Daymet forcing-file header.

The processing was updated to use the CAMELS GAGES-II `area_gages2` value for the discharge conversion:

Q (mm/day) = 2.4466 × Q (cfs) / area_gages2 (km²)

The Daymet forcing-header area was retained separately so that the two area estimates could be compared.

The updated daily panel contains:

- 671 catchments.
- 8,578,064 daily records.
- Period: 1 January 1980 to 31 December 2014.

The updated calculation uses `area_gages2` for the flow-depth conversion.

### 3.2 Runoff-ratio validation

The runoff-ratio check was repeated for October 1989 to September 2009 using the corrected discharge depth.

The results were:

- Catchments compared: 670.
- Correlation with the CAMELS `runoff_ratio` attribute: 1.0000.
- Required correlation: greater than 0.95.

The runoff-ratio check therefore passed.

One catchment, gauge `03281100`, had no CAMELS runoff-ratio value and was not included in the correlation calculation.

### 3.3 Missing-flow handling and completeness

The daily-flow processing was checked again.

Discharge sentinel values (≤ -999) were converted to missing values.

The updated daily panel contains 232,056 days flagged as missing flow, including 69,481 sentinel values.

The antecedent-flow calculation requires all 30 days before the recharge season to be present and valid. Under this definition, 143 catchment-season records have missing antecedent flow.

Incomplete seasons are not used to calculate the seasonal flow outcomes.

### 3.4 Potential evaporation validation

Potential evaporation was calculated using `airGR::PE_Oudin()` with the CAMELS gauge latitude.

The result was checked against the reference calculation.

The maximum absolute difference across the comparison was approximately 2.67 × 10⁻⁷ mm/day, consistent with rounding when the data were saved.

The potential-evaporation validation passed.

### 3.5 Usable-variation calculation

The usable-variation regression was updated to include all controls used in the main outcome model.

The updated regression includes:

`P`, `P_c2`, `T`, `PE`, `q_ante`, `P_dry` and `PE_dry`, together with catchment and season-year fixed effects.

The pooled within-catchment standard deviation of GP was:

- `sd_w` = 0.031079.
- Number of rows used to calculate `sd_w` = 16,064.

The updated standard deviation of the residuals from the usable-variation regression was:

- Usable variation = 0.739505.

The corrected calculation now includes dry-season precipitation and dry-season potential evaporation, as required.

## 4. Updated Stage 0 main-effect model

The original log-linear model was rerun using the corrected daily flow panel and updated seasonal data.

The updated results were:

- Effect of Gs: -4.0414%.
- 95% confidence interval: -7.1205% to -0.8602%.
- Half-width: 3.1301 percentage points.
- Observations: 14,863.
- Catchments: 447.
- HUC-4 clusters: 112.
- Within R²: 0.3576.

The updated estimate is effectively unchanged from the earlier reported result.

The confidence interval still excludes zero, and its half-width remains below 5 percentage points.

No interaction terms were included in this first-check model.

## 5. Additional zero-flow-inclusive Poisson analysis

An additional Poisson pseudo-maximum-likelihood (PPML) model was fitted using `fixest::fepois()` to retain eligible zero-flow observations.

The model uses mean dry-season flow as the outcome and includes the same explanatory variables as the main Stage 0 model:

`Gs`, `P`, `P_c2`, `T`, `PE`, `q_ante`, `P_dry` and `PE_dry`.

Catchment and season-year fixed effects were included, and standard errors were clustered by HUC-4.

The original primary seasonal panel contained 16,066 observations, including 456 zero-flow seasons.

After excluding observations with missing explanatory variables, the Poisson estimation sample contained:

- Observations: 15,921.
- Catchments: 477.
- HUC-4 clusters: 115.
- Zero-flow observations retained: 452.
- Positive-flow observations retained: 15,469.

Four zero-flow observations were excluded:
- Two had undefined GP because no daily rainfall value reached the 1 mm threshold.
- Two had missing antecedent flow because the required 30 preceding days of valid flow were unavailable.

The main Poisson result was:

- Gs effect: -4.9553%.
- 95% confidence interval: -7.5314% to -2.3074%.
- p-value: 0.000289.

The association between rainfall concentration and expected mean dry-season flow was negative and statistically significant in this zero-flow-inclusive model.

The Poisson model is an additional analysis. It does not replace the original log-linear model and does not directly estimate the probability of zero flow.

## 6. Catchment-area diagnosis

The Daymet forcing-header area was compared with the CAMELS GAGES-II area and the Geospatial Fabric area.

The percentage difference between the Daymet header area and `area_gages2` was calculated relative to `area_gages2`.

For the 671 catchments:

- 30 catchments had a Daymet versus GAGES-II area difference greater than 10%.
- 641 catchments had an area difference of 10% or less.
- All 671 catchments were retained for flow models.
- The 30 flagged catchments were marked as ineligible for water-budget comparisons.

The wider area comparison showed:

| Area comparison | Within 10% | More than 20% difference |
|---|---:|---:|
| Daymet vs GAGES-II | 641 (95.53%) | 17 (2.53%) |
| Daymet vs Geospatial Fabric | 589 (87.78%) | 48 (7.15%) |
| GAGES-II vs Geospatial Fabric | 611 (91.06%) | 31 (4.62%) |

The detailed comparison of 55 selected catchments in Texas and North Dakota showed that several large discrepancies were concentrated in North Dakota.

## 7. Updated first-check decision

The updated log-linear first-check model has:

- A concentration effect of -4.0414%.
- A 95% confidence interval of -7.1205% to -0.8602%.
- A confidence-interval half-width of 3.1301 percentage points.

The half-width is below the pre-specified 5-percentage-point threshold.

The correlation between plant-accessible storage and aridity in the primary sample is 0.027, which is below the absolute correlation threshold of 0.7.

In addition, 439 of the 447 model catchments (98.2%) have overlapping seasonal precipitation totals between the upper and lower thirds of GP. Eight catchments do not have overlapping ranges and are listed in the original first-check note.

Therefore, the first-check decision remains:

**Phase 1 continues as designed.**

## 8. Remaining limitations and records

- The CAMELS runoff-ratio attribute was unavailable for one catchment (`03281100`).
- The four excluded zero-flow observations remain excluded because of missing explanatory variables.
- The 30 catchments with area differences greater than 10% remain eligible for flow models but are flagged for water-budget comparisons.

All corrections and additional checks are documented in the updated Stage 0 notebook and associated output tables.

**Conclusion:** The corrected area conversion, runoff-ratio validation and usable-variation calculation have been completed. The original first-check result remains essentially unchanged, and the additional Poisson analysis gives a negative and statistically significant association between rainfall concentration and expected dry-season flow.
