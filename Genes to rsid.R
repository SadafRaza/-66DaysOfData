#installing packages

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("biomaRt")
#load library
library(biomaRt)

#since all the genes are in gene symbol, converting them to ensembl id to find snps
mygenes <- read.csv("genes.csv", header = F)

hsmart <- useMart(dataset = "hsapiens_gene_ensembl", biomart = "ensembl")
attributes = listAttributes(ensembl)
hsmart
mapping <- getBM(
  attributes = c('ensembl_gene_id'), 
  filters = 'hgnc_symbol',
  values = mygenes,
  mart = hsmart
)
write.csv(mapping, "ensemble_gene_id.csv", row.names = F)
#Now converting ensemble gene id to find the reference snp id and the alleles.
#Since there are numerous rsid associated with each gene, here is the code for finding them individually
#list database
myMarts <- listMarts()
#select database
ensembl=useMart("ENSEMBL_MART_SNP")
#list datasets in biomart
mydatasets<- listDatasets(ensembl)
#selecting dataset for assignment change to short human variants (hg38)
ensembl=useMart("ENSEMBL_MART_SNP", dataset = "hsapiens_snp")
#list  filters
myFilters <- listFilters(ensembl)
#make vector for your filters
filter1 <- c('ensembl_gene')
values1 <- c('ENSG00000278850')
#list attributes
myAttributes <- listAttributes(ensembl)
#make variable for our attributes
att1 <- c('refsnp_id', 'ensembl_gene_name','minor_allele', 'minor_allele_freq','allele')
searchResults <- getBM(att1, filters = filter1,
                       values= values1, mart=ensembl)
write.csv(searchResults, "gene_to_rsid.csv", row.names = F)
