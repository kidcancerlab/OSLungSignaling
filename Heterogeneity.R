library(tidyverse)
library(Seurat)
library(rrrSingleCellUtils)

pre_path <- "/gpfs0/home2/gdrobertslab/lab/Counts_2/"
post_path <- "/filtered_feature_bc_matrix"
sample <- "S0132"

met <- tenx_load_qc(paste0(pre_path, sample, post_path),
    species_pattern = "^GRCh38-",
    violin_plot = FALSE) %>%
  NormalizeData() %>%
  FindVariableFeatures() %>%
  ScaleData() %>%
  RunPCA() %>%
  FindNeighbors(k.param = 100L) %>%
  FindClusters(resolution = 0.8) %>%
  RunUMAP(reduction = "pca", dims = 1:30)

r_dim_plot(met)

g <- igraph::graph_from_adjacency_matrix(
  adjmatrix = met@graphs$RNA_snn,
  mode = "undirected",
  weighted = TRUE,
  add.colnames = TRUE)

fdl <- igraph::layout_with_fr(g, grid = "nogrid")
rownames(fdl) <- colnames(met)
colnames(fdl) <- c("fdl_1", "fdl_2")

met[["fdl"]] <- CreateDimReducObject(
  embeddings = fdl,
  key = "fdl_",
  assay = DefaultAssay(met))

r_dim_plot(met, reduction = "fdl")
r_feature_plot(met,
  "CBFB",
  min.cutoff = 2,
  max.cutoff = 4,
  reduction = "fdl")

c5 <- FindMarkers(met,
  ident.1 = 5,
  ident.2 = c(4, 6)) %>%
  filter(p_val_adj < 0.01 & pct.1 > 0.35) %>%
  mutate(diff = pct.1 - pct.2) %>%
  arrange(-avg_log2FC)

head(c5, n = 30)
