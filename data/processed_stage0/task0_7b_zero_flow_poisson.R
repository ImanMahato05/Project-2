
suppressMessages({
    library(data.table)
    library(fixest)
})

# Read prepared zero-inclusive model panel
panel0 <- fread(
    "/content/drive/MyDrive/ecohydro_project/Project 2/data/processed/task0_7b_zero_flow_poisson_panel.csv",
    colClasses = list(character = c("gauge_id", "huc4"))
)

# Check required columns
required <- c(
    "gauge_id", "huc4", "season_year", "q_dry_mean",
    "Gs", "P", "P_c2", "T", "PE",
    "q_ante", "P_dry", "PE_dry"
)

stopifnot(all(required %in% names(panel0)))

# Convert identifiers
panel0[, gauge_id := as.factor(gauge_id)]
panel0[, season_year := as.factor(season_year)]
panel0[, huc4 := as.factor(huc4)]

cat("ZERO-FLOW POISSON MODEL SAMPLE\n")
cat("Observations:", nrow(panel0), "\n")
cat("Catchments:", uniqueN(panel0$gauge_id), "\n")
cat("HUC-4 clusters:", uniqueN(panel0$huc4), "\n")
cat("Zero-flow observations:",
    sum(panel0$q_dry_mean == 0), "\n")

# Fit Poisson pseudo-maximum-likelihood model
m_zero <- fepois(
    q_dry_mean ~ Gs + P + P_c2 + T + PE +
        q_ante + P_dry + PE_dry |
        gauge_id + season_year,
    data = panel0,
    cluster = ~huc4
)

# Display model results
print(summary(m_zero))

# Extract coefficient table
ct <- as.data.frame(coeftable(m_zero))
ct$term <- rownames(ct)
rownames(ct) <- NULL

# Calculate percentage effects
ct$effect_pct <- 100 * (exp(ct$Estimate) - 1)

# Calculate confidence intervals
ci <- confint(m_zero)

ct$ci_low_pct <- 100 * (exp(ci[ct$term, 1]) - 1)
ct$ci_high_pct <- 100 * (exp(ci[ct$term, 2]) - 1)

# Save coefficient results
fwrite(
    ct,
    "/content/drive/MyDrive/ecohydro_project/Project 2/data/processed/task0_7b_zero_flow_poisson_coefs.csv"
)

# Save model information
summ <- data.frame(
    nobs_model = nobs(m_zero),
    nobs_panel = nrow(panel0),
    n_catchments = uniqueN(panel0$gauge_id),
    n_huc4 = uniqueN(panel0$huc4),
    n_zero_flow = sum(panel0$q_dry_mean == 0),
    n_positive_flow = sum(panel0$q_dry_mean > 0),
    pseudo_r2 = as.numeric(r2(m_zero, "pr2"))
)

fwrite(
    summ,
    "/content/drive/MyDrive/ecohydro_project/Project 2/data/processed/task0_7b_zero_flow_poisson_summary.csv"
)

cat("\nFinished zero-flow Poisson model.\n")
