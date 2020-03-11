#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=1,vmem=100gb,walltime=6:00:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N centrifuge

cd PWDHERE

module load centrifuge/1.0.3

#Code for making a list of all the reads in the reads directory
reads=`ls 1-reads | grep "1.fastq" | sed 's/_1.fastq//g'`

for f in $reads
do 
	centrifuge -x $CENTRIFUGE_INDEX -1 1-reads/"$f"_1.fastq -2 1-reads/"$f"_2.fastq > 2-taxa/"$f".centrifuge.out
	mv centrifuge_report.tsv 2-taxa/"$f"_centrifige_report.tsv
done

