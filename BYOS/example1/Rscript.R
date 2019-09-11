# Code provided by Emeline Perthame and Kenzo-Hugo Hillion (Institut Pasteur)

# Reference for the data
# [1] L. J. Yockey, K. A. Jurado, N. Arora, A. Millet, T. Rakib, K. M. Milano, A. K. Hastings, E. Fikrig, Y. Kong, T. L. Horvath, 
# S. Weatherbee, H. J. Kliman, C. B. Coyne, A. Iwasaki, Type I interferons instigate fetal demise after Zika virus infection. 
# Sci. Immunol. 3, eaao1680 (2018). doi:10.1126/sciimmunol.aao1680 Medline
# [2] Accession number GSE104349
# [3] Buchrieser J, Degrelle SA, Couderc T, Nevers Q, Disson O, Manet C, Donahue DA, Porrot F, Hillion KH, Perthame E, Arroyo MV, 
# Souquere S, Ruigrok K, Dupressoir A, Heidmann T, Montagutelli X, Fournier T, Lecuit M, Schwartz O, IFITM proteins inhibit 
# placental syncytiotrophoblast formation and promote fetal demise, Science 2019 Jul;365(6449):176-180.

# Load needed packages
require(DESeq2)
require(limma)
require(FactoMineR)
require(factoextra)

### In the app, the user could manually load its data
# load count table
counts <- read.table("data/counts.txt")
# load target file 
target <- read.table("data/target.txt")

# We are going to perform a Principal Components Analysis on this dataset
# On RNA-Seq data, it is necessary to transform the data before applying the PCA to restaure homoskedasticity
### In the app, the user could choose between 3 transformations (none, varianceStabilizingTransformation implemented in DESeq2 or
# voom implemented in limma)
# Depending on the data, voom or VST is more adapted, "none" is not recommended for RNA-Seq data
choice <- 3
transform <- c("none","VST","voom")[choice]
if (transform == "none") counts.trans <- counts
if (transform == "VST") counts.trans <- varianceStabilizingTransformation(as.matrix(counts))
if (transform == "voom") counts.trans <- voom(counts)$E

# In such analysis, it is usual to restrain the analysis to the most variant genes
### In the app, the user could choose the number of genes, default is 200 genes 
nbgenes <- 200
std <- apply(counts.trans,1,sd)
idx <- order(std, decreasing = TRUE)[1:nbgenes]

# perform PCA with FactoMineR
pca <- PCA(t(counts.trans[idx,]),ncp=6,graph=FALSE)

# visualise PCA with factoextra

# Screeplot of eigen values (3 principal dimensions to explore here)
fviz_eig(pca)

# explore the sources of variability

# bwith a biplot
fviz_pca_biplot(pca,select.var = list(cos2=10), habillage=target$tissue_code, mean.point=FALSE)

# with the factorial map of samples
### In the app, the user could color the samples depending on the factor in the target file (see examples below)
fviz_pca_ind(pca, habillage=target$tissue_code, mean.point=FALSE, axes=c(1,2))
### In the app, the user could choose what dimensions it want to see (see examples below)
fviz_pca_ind(pca, habillage=target$treatment, mean.point=FALSE, axes=c(2,3))

# with the factorial map of genes
### In the app, the user could restrain the plot to the 10 most contributive genes (see examples below for dim 1,2 and 2,3)
fviz_pca_var(pca,select.var = list(cos2=10),repel = TRUE)
fviz_pca_var(pca,select.var = list(cos2=10),repel = TRUE, axes=c(2,3))
