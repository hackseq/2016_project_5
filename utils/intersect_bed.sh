#!/bin/bash

DMR=$1
GENOME_MOTIFS=$2
GENOME="mm9/mm9.chrom.sizes"
SORTED=$3
#./intersectBed -f 1 -a $GENOME_MOTIFS -b $DMR $SORTED -g $GENOME > $DMR".intersection.bed"
intersectBed -f 1 -a $GENOME_MOTIFS -b $DMR > $DMR".intersection.bed"
