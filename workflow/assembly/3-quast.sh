#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=1,vmem=20gb,walltime=30:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N quast

cd PWDHERE

module load quast/5.0.0-py13

#Running quast for all the assemblies here. The results are also saved to the contigs directory
for f in assembly/contigs/*.fa; do  echo "$f"; quast.py "$f" -o "$f"_quast; done

#Saving only the report.tsv results and deleting the rest

mkdir assembly/contigs_quast
#this part of the code needs to be tested once
cd assembly
for f in contigs/*_quast
do 
	mv "$f"/report.tsv "$f"_report_quast
done 
mv contigs/*_report_quast contigs_quast/.

module unload python
module load python/3.6.8

export PATH=PWDHERE/scripts:$PATH
quast_table.py -d contigs_quast -o quast_output.tsv

