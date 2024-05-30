library(tidyverse)
library(Seurat)
library(rrrSingleCellUtils)

samples <- c(
  "S0007",
#  "S0008",
#  "S0009",
  "S0015",
  "S0016",
  "S0023",
  "S0024",
  "S0027",
#  "S0065",
#  "S0073",
  "S0082",
  "S0084",
  "S0086",
  "S0092",
  "S0093",
  "S0097",
#  "S0098",
#  "S0099",
  "S0124",
#  "S0125",
  "S0132",
  "S0279",
  "S0280",
  "S0281"
)
pre_path <- "/gpfs0/home2/gdrobertslab/lab/Counts_2/"
post_path <- "/filtered_feature_bc_matrix"


OS17 <- parallel::mclapply(samples, function(s) { # nolint
  tenx_load_qc(paste0(pre_path, s, post_path),
    species_pattern = "^GRCh38-",
    violin_plot = FALSE) %>%
  NormalizeData() %>%
  FindVariableFeatures() %>%
  ScaleData() %>%
  RunPCA() %>%
  RunUMAP(reduction = "pca", dims = 1:30)
}, mc.cores = parallelly::availableCores())

names(OS17) <- samples

plots <- parallel::mclapply(seq_along(OS17), function(i) {
  p <- r_feature_plot(OS17[[i]], "CXCL8")
  return(p)
}, mc.cores = parallelly::availableCores())

plots
plots[[14]]
samples[14]
