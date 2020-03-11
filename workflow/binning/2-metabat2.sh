#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=1,vmem=50gb,walltime=15:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N metabat_binning

cd PWDHERE

module load metabat/2.11.3

jgi_summarize_bam_contig_depths --outputDepth binning/metabat_depth binning/*_sort.bam

#should mention the 1500bp min length in the presentation and workflow
mkdir binning/metabat_bins
metabat2 -i assembly/final_contigs.fa -a binning/metabat_depth -m 1500 -o binning/metabat_bins/metabat_bins
