#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=1,vmem=50gb,walltime=30:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N fraggenescan

cd PWDHERE

module load fraggenescan/1.31

for f in assembly/contigs/*.fa
do
	run_FragGeneScan.pl -genome="$f" -out="$f"_fraggenescan -complete=0  -train=illumina_10 -thread=1
	echo "$f"
done


mkdir functions/fraggenescan_output
cd assembly/contigs
mv *_fraggenescan* funcions/fraggenescan_output/*
