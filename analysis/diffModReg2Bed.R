# load peaks from ChIPSeq histone marks 

library(ChIPpeakAnno)
library(org.Hs.eg.db)

# load in annotation of transcription factor start sites
data(TSS.human.GRCh37)

# load in ChIP-Seq datasets for histone modifications - needs to be annotated to hg19
# gets loaded in as genome ranges object

# H3K4me3 ChIP-seq on human H1-hESC
bed_file_name =  "~/hackseq/data/ENCFF729JWY.bed"
hesc_gr <- toGRanges(bed_file_name, format="BED", header=TRUE) 

#H3K4me3 ChIP-seq on human K562
bed_file_name =  "~/hackseq/data/ENCFF001XGW.bed"
k562_gr <- toGRanges(bed_file_name, format="BED", header=TRUE) 

# calculate difference in peak locations based on simple set differences
hesc_vs_k562_gr = setdiff(hesc_gr, k562_gr)
k562_hesc_vs_gr = setdiff(k562_gr, hesc_gr)

# annotate each set difference genome range file with closest genes
hesc_vs_k562_gr_anno <- annotatePeakInBatch(hesc_vs_k562_gr, AnnotationData=TSS.human.GRCh37)
hesc_vs_k562_gr_anno <- addGeneIDs(annotatedPeak=hesc_vs_k562_gr_anno, 
                        orgAnn="org.Hs.eg.db", 
                        IDs2Add="symbol")

k562_hesc_vs_gr_anno <- annotatePeakInBatch(k562_hesc_vs_gr, AnnotationData=TSS.human.GRCh37)
k562_hesc_vs_gr_anno <- addGeneIDs(annotatedPeak=hesc_vs_k562_gr_anno, 
                                   orgAnn="org.Hs.eg.db", 
                                   IDs2Add="symbol")

# filter out peaks which are not annotated as being inside the TSS
hesc_vs_k562_gr_anno = hesc_vs_k562_gr_anno[which(hesc_vs_k562_gr_anno$insideFeature == 'inside')]
k562_hesc_vs_gr_anno = k562_hesc_vs_gr_anno[which(k562_hesc_vs_gr_anno$insideFeature == 'inside')]

# export genome ranges set difference files as bed files
export(hesc_vs_k562_gr_anno, "~/hackseq/data/diffHistModified/hesc_vs_k562.bed")
export(k562_hesc_vs_gr_anno, "~/hackseq/data/diffHistModified/k562_vs_hesc.bed")