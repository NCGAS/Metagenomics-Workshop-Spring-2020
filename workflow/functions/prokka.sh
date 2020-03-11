#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=1,vmem=50gb,walltime=30:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N prokka

cd PWDHERE

module unload python
module load anaconda/python3.7/2019.03
module load prokka/1.14.6

mkdir functions/prokka_output
for f in assembly/contigs/*.fa
do
        prokka --outdir PWDHERE/"$f"_prokka --prefix "$f" "$f" --cpus 1 --kingdom Bacteria --force
        echo "$f"
done

cd assembly/contigs
mv *_prokka functions/prokka_output/.

