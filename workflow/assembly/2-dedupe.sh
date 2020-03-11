#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=1,vmem=20gb,walltime=15:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N dedupe

cd PWDHERE

module load bbtools/38.72

#First writing all the contigs to a new directory 
mkdir assembly/contigs

#this part needs to be tested once 
cd assembly

for f in *megahit_output
do
	mv "$f"/final.contigs.fa contigs/"$f"_megahit.fa
done

for f in *spades_output
do 
	mv "$f"/contigs.fasta  contigs/"$f"_spades.fa
done 

#renaming the coassembled contigs
mv contigs/megahit_output_megahit.fa contigs/all_megahit.fa
mv contigs/spades_output_spades.fa contigs/all_spades.fa

#depuplicating all the assemblies - coassembled, individual assemblies, megahit and spades assemblies - all combined. Removes all the exact duplicates and gives us a final set of contigs to work with for binning 
for f in contigs/*; do echo "$f" >>contigs-names.txt; done
tr '\n' ',' < contigs-names.txt >contig-names.txt
echo `cat contig-names.txt`
rm -rf contigs-names.txt

dedupe.sh in=`cat contig-names.txt` out=contigs/dedupe_contigs.fasta >contigs/dedupe.log 2>&1
sed 's/ //g' contigs/dedupe_contigs.fasta > contigs/dedupe_contig.fa
rm -rf contigs/dedupe_contigs.fasta 
# the output is saved to contigs/dedupe_contigs.fa
