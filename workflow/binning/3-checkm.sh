#!/bin/bash
#PBS -k oe
#PBS -m abe
#PBS -M YOUREMAILHERE
#PBS -N checkm
#PBS -l nodes=1:ppn=1,vmem=50gb,walltime=30:00

cd PWDHERE

module load checkm/1.0.18
module load hmmer/3.1

#making one directory with all the bins so we can run CheckM on them once 
mkdir binning/bins
for f in binning/metabat_bins/*; do cp "$f" binning/bins/.; done
for f in binning/concoct_bins/*; do cp "$f" binning/bins/.; done

#get the list of bins generated 
bins=`ls binning/bins`

#adding checkm results to directory called checkm 
mkdir binning/checkm

#CheckM
checkm tree -x fa binning/bins binning/checkm/checkm_tree
checkm tree_qa binning/checkm/checkm_tree/ -f binning/checkm/checkm_tree_qa
checkm lineage_set binning/checkm/checkm_tree binning/checkm/checkm_marker
checkm analyze binning/checkm/checkm_marker -x fa binning/bins binning/checkm/checkm_analyze
checkm qa binning/checkm/checkm_marker binning/checkm/checkm_analyze > binning/checkm/checkm_summary
echo "CheckM done"
