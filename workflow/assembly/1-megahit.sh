#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=1,vmem=50gb,walltime=1:30:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N megahit

cd PWDHERE

module load megahit/1.1.2

#Co-assembling all the reads together
left=reads/left.fq
right=reads/right.fq

megahit -1 $left -2 $right -t 1 --tmp-dir PWDHERE -o assembly/megahit_output

#Single read assembly 
reads=`ls reads | grep "1.fastq" | sed 's/_1.fastq//g'`

for f in $reads
do 
	megahit -1 reads/"$f"_1.fastq -2 reads/"$f"_2.fastq -t 1 --tmp-dir PWDHERE -o assembly/"$f"_megahit_output
	echo "$f" 
done
