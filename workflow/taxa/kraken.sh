#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=1,vmem=50gb,walltime=2:00:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N kraken

cd PWDHERE

module load kraken/2.0.8

#Code for making a list of all the reads in the reads directory
reads=`ls reads | grep "1.fastq" | sed 's/_1.fastq//g'`

for f in $reads
do 
	kraken2 --reload --db $KRAKEN_DB --paired reads/"$f"_1.fastq reads/"$f"_2.fastq --threads 1  --report-zero-counts --use-names --report taxa/"$f"_kraken_report --output taxa/"$f"_kraken.out
done

#moving the report to a new directory to generate one output 
mkdir taxa/kraken_report
mv taxa/*_kraken_report taxa/kraken_report/.

module unload python 
module load python/3.6.8 
export PATH=PWDHERE/scripts:$PATH

python scripts/kraken-multiple-taxa.py -d taxa/kraken_report/ -r F -c 2 -o taxa/kraken-report-final
python scripts/kraken-multiple-taxa.py -d taxa/kraken_report/ -r F -c 1 -o taxa/kraken-report-final-abund

sed -e "s/\[//g;s/\]//g;s/'//g;s|\t|,|g" taxa/kraken-report-final  >taxa/kraken_report-final.csv
sed -e "s/\[//g;s/\]//g;s/'//g;s|\t|,|g" taxa/kraken-report-final-abund  >taxa/kraken_report-final-abund.csv
