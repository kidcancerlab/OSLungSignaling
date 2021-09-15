source("R:/RESRoberts/Bioinformatics/Analysis/scSeurat.R")
source("R:/RESRoberts/Bioinformatics/Analysis/scIntercellular.v2.R")

mix <- tenXLoadQC("R:/RESRoberts/Bioinformatics/scRNAOuts/S0001-mix/filtered_feature_bc_matrix/", spec = "human")
mix <- subset (mix, subset = nFeature_RNA >300 & nCount_RNA < 16000 & percent.mt < 14)
mix$src <- "mix"

cocx <- tenXLoadQC("R:/RESRoberts/Bioinformatics/scRNAOuts/S0005-CoCx-2/filtered_feature_bc_matrix/", spec = "human")
cocx <- subset (cocx, subset = nFeature_RNA >300 & nCount_RNA < 16000 & percent.mt <14)
cocx$src <- "cocx"

cx <- merge(mix, y = cocx, add.cell.ids = c("mix", "cocx"), project = "InterSignaling")

cx <- NormalizeData(cx)
cx <- ScaleData(cx)
cx <- FindVariableFeatures(cx)
cx <- RunPCA(cx, features = VariableFeatures(cx))
cx <- FindNeighbors(cx, dims = 1:20)
cx <- FindClusters(cx, resolution = 0.5)
cx <- RunUMAP(cx, dims = 1:20)

DimPlot(cx, group.by = "src")
DimPlot(cx)
FeaturePlot(cx, features = c("CK19", "COL1A1"))

cx <- RenameIdents(cx, `4` = "OS-Unstim")
cx <- RenameIdents(cx, `6` = "OS-Stim", `1` = "OS-Stim", `8` = "OS-Stim")
cx <- RenameIdents(cx, `0` = "HBEC-Stim", `2` = "HBEC-Unstim", `3` = "HBEC-Stim", 
                   `5` = "HBEC-Stim", `7` = "HBEC-Unstim", `9` = "HBEC-Unstim", `10` = "HBEC-Stim")

# save(cx, file = "C:/Users/rxr014/Dropbox (NCH)/BIScratch/cx.RData")
# load("C:/Users/rxr014/Dropbox (NCH)/BIScratch/cx.RData")

target.genes <- findTarGenes(cx, id1 = "OS-Stim", "OS-Unstim")

LRT.analysis <- findLigands(cx, target.genes, senders = c("HBEC-Stim", "HBEC-Unstim"), 
                            receiver = "OS-Stim", rec_pct = 0.07, stringency = "strict")

LRT.analysis.2 <- findLigands(cx, target.genes, senders = c("HBEC-Stim", "HBEC-Unstim"), 
                            send_pct = 0.2, receiver = "OS-Stim", rec_pct = 0.07, stringency = "strict")


