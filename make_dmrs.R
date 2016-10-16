library(tidyverse)
library(readr)
library(DSS)
library(bsseq)

args <- commandArgs()
first_bed <- args[1]
second_bed <- args[2]
number_of_reads <- args[3]

# first_bed <- "SL759.MspI_RRBS_HEK293__PF_.DCC.CGs.bed"
# second_bed <- "SL1812.MCF7_NoStarve_B1__GC_.DCC.CGs.bed"
# number_of_reads <- 1000

first_open <- read_tsv(first_bed, skip = 1, col_names = FALSE)
second_open <- read_tsv(second_bed, skip = 1, col_names = FALSE)

format_to_dss <- function(open_bed) {
  ready_for_dss <- open_bed %>% 
    select(X1, X2, X10, X11) %>%
    dplyr::rename(chr = X1, pos = X2, N = X10, X = X11) %>% 
    mutate(X = floor(N * X / 100))
  return(ready_for_dss)
}

first_dss <- format_to_dss(first_open)
second_dss <- format_to_dss(second_open)

bss <- makeBSseqData(list(first_dss, second_dss), c(first_bed, second_bed))[1:number_of_reads, ]

dmlTest <- DMLtest(bss, group1=c(first_bed), group2=c(second_bed), smoothing = TRUE)
dmrs <- callDMR(dmlTest, p.threshold=0.01)

write_tsv(dmrs, "dmrs.tsv")
print("Finished")