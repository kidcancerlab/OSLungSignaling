library(tidyverse)
library(Seurat)
library(rrrSingleCellUtils)
library(future)
library(future.apply)
if(Sys.info()['sysname'] == "Windows") {
  plan(multisession)
} else {
  plan(multicore)
}

samples <- c(
  # "S0007",
  # "S0015",
  # "S0016",
  # "S0023",
  # "S0024",
  # "S0027",
  # "S0082",
  # "S0084",
  # "S0086",
  # "S0092",
  # "S0093",
  # "S0097",
  # "S0124",
  # "S0132",
  # "S0279",
  # "S0280",
  # "S0281"
  "S0018",
  "S0037",
  "S0048",
  "S0131"
)
# pre_path <- "/gpfs0/home2/gdrobertslab/lab/Counts_2/"
pre_path <- "C:/Users/rxr014/OneDrive - Nationwide Children's Hospital/BIScratch/"
post_path <- "/filtered_feature_bc_matrix"


OS17 <- future_lapply(samples, function(s) { # nolint
  warning(paste("Starting sample ", s, "..."))
  obj <- tenx_load_qc(paste0(pre_path, s, post_path),
    species_pattern = "^GRCh38-",
    violin_plot = FALSE)

  if(length(Cells(obj)) > 1500) {
    subset(obj, cells = sample(Cells(obj), 1500))
  }

  obj <- NormalizeData(obj) %>%
  FindVariableFeatures() %>%
  ScaleData() %>%
  RunPCA() %>%
  RunUMAP(reduction = "pca", dims = 1:30)

  warning(paste("Sample ", s, " completed."))
  return(obj)
})

names(OS17) <- samples

plots <- lapply(seq_along(OS17), function(i) {
  p <- r_feature_plot(OS17[[i]], "CXCL8") +
    labs(title = paste("CXCL8 - ", names(OS17)[i]))
  return(p)
})

patchwork::wrap_plots(plots, ncol = 4)
