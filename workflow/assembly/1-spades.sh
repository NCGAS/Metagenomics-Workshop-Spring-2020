#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=1,vmem=75gb,walltime=3:00:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N spades

cd PWDHERE

module load spades/intel/3.11.1

#Co-assembling
left=reads/left.fq
right=reads/right.fq
spades.py -1 $left  -2 $right --meta -t 1 -o assembly/spades_output

#Running individual assemblies
reads=`ls reads | grep "1.fastq" | sed 's/_1.fastq//g'`

for f in $reads
do 
	spades.py -1 reads/"$f"_1.fastq -2 reads/"$f"_2.fastq --meta -t 1 -o assembly/"$f"_spades_output
	echo "$f"
done
