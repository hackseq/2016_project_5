library(ChIPpeakAnno)
library(org.Hs.eg.db)

# load in annotation of transcription factor start sites
data(TSS.human.GRCh37)

# load in ChIP-Seq datasets for histone modifications - needs to be annotated to hg19
# gets loaded in as genome ranges object

# load in file from fimo of up DMR regions
fimo_up =  read.delim("~/hackseq/results/fimo_upmeth/fimo.txt")
jaspar_names = read.delim("~/hackseq/results/JASPAR_NAMES", sep = " ", header = F)
colnames(jaspar_names) = c("X.pattern.name", "TF_name")

# merge fimo and file for jaspar names
fimo_up = merge(fimo_up, jaspar_names, by = "X.pattern.name")

# filter just runx1 TF
runx1_up = fimo_up %>% filter(TF_name == 'RUNX1')