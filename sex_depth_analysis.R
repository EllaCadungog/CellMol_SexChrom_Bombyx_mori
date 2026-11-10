
# ============================================================
# BOMBYX MORI SEX-CHROMOSOME DOSAGE ANALYSIS
# ============================================================

# 1. SELECT BOTH INPUT FILES
cat("Select chromosome_coverage.tsv or chromosome__group.csv.\n")
file1 <- file.choose()

cat("Select the remaining file.\n")
file2 <- file.choose()

# 2. IDENTIFY THE FILES AUTOMATICALLY
read_first_line <- function(path) {
  readLines(path, n = 1, warn = FALSE)
}

first1 <- read_first_line(file1)
first2 <- read_first_line(file2)

if (grepl("meandepth", first1, ignore.case = TRUE)) {
  coverage_path <- file1
  groups_path <- file2
} else if (grepl("meandepth", first2, ignore.case = TRUE)) {
  coverage_path <- file2
  groups_path <- file1
} else {
  stop("Cannot identify the coverage file. Select the correct TSV and CSV files.")
}

# 3. CREATE RESULTS FOLDER
results_dir <- file.path(dirname(groups_path), "results")
dir.create(results_dir, showWarnings = FALSE, recursive = TRUE)

# 4. READ COVERAGE FILE
coverage <- read.delim(
  coverage_path,
  header = TRUE,
  sep = "\t",
  comment.char = "",
  check.names = FALSE,
  stringsAsFactors = FALSE
)

names(coverage) <- sub("^#", "", trimws(names(coverage)))

if (!all(c("rname", "meandepth") %in% names(coverage))) {
  stop("Coverage file must contain rname and meandepth columns.")
}

# 5. READ CHROMOSOME GROUPS FILE
groups <- read.csv(
  groups_path,
  stringsAsFactors = FALSE
)

names(groups) <- trimws(names(groups))
groups$rname <- trimws(groups$rname)
groups$group <- toupper(trimws(groups$group))

if (!all(c("rname", "group") %in% names(groups))) {
  stop("Chromosome groups CSV must contain rname and group columns.")
}

# 6. CHECK CHROMOSOME LABELS
if (anyDuplicated(groups$rname)) {
  stop("Duplicate chromosome names found in chromosome groups CSV.")
}

if (sum(groups$group == "A") < 5) {
  stop("At least five autosomes must be labeled A.")
}

if (sum(groups$group == "Z") != 1) {
  stop("Exactly one chromosome must be labeled Z.")
}

# 7. MATCH COVERAGE AND CHROMOSOME GROUPS
coverage$meandepth <- as.numeric(coverage$meandepth)

analysis_data <- merge(
  groups,
  coverage[, c("rname", "meandepth")],
  by = "rname",
  all.x = TRUE,
  sort = FALSE
)

analysis_data <- analysis_data[
  match(groups$rname, analysis_data$rname),
]

if (anyNA(analysis_data$meandepth)) {
  stop("Some chromosome names do not match or have missing coverage.")
}

# 8. CALCULATE AUTOSOMAL AND Z-CHROMOSOME DEPTH
autosomes <- analysis_data[analysis_data$group == "A", ]
z_chromosome <- analysis_data[analysis_data$group == "Z", ]

autosomal_median <- median(autosomes$meandepth)
z_depth <- z_chromosome$meandepth

if (autosomal_median <= 0) {
  stop("Autosomal depth is zero or invalid.")
}

z_to_a_ratio <- z_depth / autosomal_median

analysis_data$relative_depth <-
  analysis_data$meandepth / autosomal_median

# 9. INTERPRETATION
if (autosomal_median < 1) {
  inference <- "Inconclusive: very low autosomal coverage."
} else if (z_to_a_ratio <= 0.65) {
  inference <- "Consistent with one Z chromosome (ZW-like)."
} else if (z_to_a_ratio >= 0.80) {
  inference <- "Consistent with two Z chromosomes (ZZ-like)."
} else {
  inference <- "Ambiguous Z-chromosome dosage."
}

# 10. SAVE RELATIVE DEPTH TABLE
write.csv(
  analysis_data,
  file.path(results_dir, "chromosome_relative_depth.csv"),
  row.names = FALSE
)

# 11. CREATE CHROMOSOME DEPTH GRAPH
png(
  file.path(results_dir, "chromosome_depth.png"),
  width = 1200,
  height = 800,
  res = 120
)

par(mar = c(8, 5, 4, 2))

barplot(
  analysis_data$relative_depth,
  names.arg = analysis_data$rname,
  las = 2,
  col = ifelse(analysis_data$group == "Z", "steelblue", "gray70"),
  main = "Relative Chromosome Depth in Bombyx mori",
  xlab = "Chromosome",
  ylab = "Relative Depth (Median Autosomal Depth = 1)"
)

abline(h = 1, lty = 2, col = "red", lwd = 2)
abline(h = 0.5, lty = 2, col = "blue", lwd = 2)

legend(
  "topright",
  legend = c("Z chromosome", "Autosomes", "Expected 0.5", "Expected 1.0"),
  fill = c("steelblue", "gray70", NA, NA),
  lty = c(NA, NA, 2, 2),
  col = c(NA, NA, "blue", "red"),
  bty = "n"
)

dev.off()

# 12. SAVE SUMMARY REPORT
sink(file.path(results_dir, "sex_inference.txt"))

cat("SEX-CHROMOSOME DOSAGE ANALYSIS\n")
cat("Species: Bombyx mori (Domestic silkworm)\n\n")

cat("CHROMOSOME DEPTH RESULTS\n")
print(analysis_data[, c(
  "rname", "group", "meandepth", "relative_depth"
)])

cat("\nMedian autosomal depth:", autosomal_median, "\n")
cat("Z chromosome depth:", z_depth, "\n")
cat("Z:A ratio:", z_to_a_ratio, "\n")

cat("\nINTERPRETATION\n")
cat(inference, "\n")

cat("\nLIMITATIONS\n")
cat("1. Mapping bias and repetitive sequences may affect read depth.\n")
cat("2. Sex-chromosome annotation must be verified using NCBI records.\n")
cat("3. The W chromosome may have very low coverage or may be poorly assembled.\n")
cat("4. Compare the result with the WGS BioSample sex information.\n")
cat("5. The assembly and WGS sample should ideally come from the same individual.\n")

sink()

# 13. DISPLAY RESULTS
cat("\n====================================\n")
cat("ANALYSIS COMPLETED!\n")
cat("====================================\n")

cat("Median autosomal depth:", round(autosomal_median, 3), "\n")
cat("Z:A ratio:", round(z_to_a_ratio, 3), "\n")
cat("Interpretation:", inference, "\n")

cat("\nRESULTS FOLDER:\n")
cat(normalizePath(results_dir), "\n")

cat("\nSAVED FILES:\n")
print(list.files(results_dir, full.names = TRUE))
