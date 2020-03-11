#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=1,vmem=50gb,walltime=1:00:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N focus

cd PWDHERE

#pairing the reads 
export PATH=/N/dc2/scratch/bhnala/MAG_workflow/Metagenome-assembled-genomes-workflow/scripts:$PATH
reads=`ls reads | grep "1.fastq" | sed 's/_1.fastq//g'`
mkdir taxa/paired_reads
for f in $reads
do 
	scripts/pear -f reads/"$f"_1.fastq -r reads/"$f"_2.fastq -o taxa/paired_reads/"$f"
	rm -rf taxa/paired_reads/*discarded*
	rm -rf taxa/paired_reads/*unassembled*
done

module unload python
module load python/3.6.8
module load focus/1.4
focus -q taxa/paired_reads -o taxa/focus_output --threads 1
