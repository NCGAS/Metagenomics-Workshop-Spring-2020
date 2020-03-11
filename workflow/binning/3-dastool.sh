#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=1,vmem=50gb,walltime=1:00:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N dastool

cd PWDHERE

module unload python
module load anaconda/python3.7/2019.03
module load dastool/1.1.2

Fasta_to_Scaffolds2Bin.sh -e fa -i binning/metabat_bins > binning/metabat_scaffolds2bin.tsv
Fasta_to_Scaffolds2Bin.sh -e fa -i binning/concoct_bins > binning/concoct_scaffolds2bin.tsv

module load diamond/0.9.13

DAS_Tool -i binning/metabat_scaffolds2bin.tsv,binning/concoct_scaffolds2bin.tsv -l metabat,concoct -c assembly/final_contigs.fa --search_engine diamond -o binning/DASToolRun1 --write_bin_evals 1 --threads 1 --write_bins 1 --score_threshold -0.5
