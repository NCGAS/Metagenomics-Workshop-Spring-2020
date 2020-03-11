#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=1,vmem=50gb,walltime=15:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N concoct_binning

cd PWDHERE

module unload python
module load anaconda/python3.7/2019.03
module load concoct/1.1.0

# Slice contigs into smaller sequences
cut_up_fasta.py assembly/final_contigs.fa -c 10000 -o 0 --merge_last -b binning/contigs_10K.bed > binning/contigs_10K.fa
 
# Generate coverage depth 
concoct_coverage_table.py binning/contigs_10K.bed binning/*.bam > binning/concoct_coverage.tsv
 
# Execute CONCOCT
concoct --composition_file binning/contigs_10K.fa --coverage_file binning/concoct_coverage.tsv -b binning/concoct_output/
 
# Merge sub-contig clustering into original contig clustering
merge_cutup_clustering.py binning/concoct_output/clustering_gt1000.csv > binning/concoct_output/clustering_merged.csv
 
# Create output folder for bins
mkdir binning/concoct_bins
 
# Parse bins into different files
extract_fasta_bins.py assembly/final_contigs.fa binning/concoct_output/clustering_merged.csv --output_path binning/concoct_bins

cd binning/concoct_bins
for file in *.fa; do mv "$file" concoct_"$file"; done
