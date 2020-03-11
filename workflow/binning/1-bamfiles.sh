#!/bin/bash
#PBS -k oe
#PBS -l nodes=1:ppn=1,vmem=50gb,walltime=30:00
#PBS -M YOUREMAILHERE
#PBS -m abe
#PBS -N bamfiles

cd PWDHERE

module load bowtie2/intel/2.3.2
module load samtools/1.9

#Code for making a list of all the reads in the reads directory
reads=`ls reads | grep "1.fastq" | sed 's/_1.fastq//g'`

#dedupe binning
bowtie2-build assembly/final_contigs.fa binning/bowtie2-index
for f in $reads
do  
	bowtie2 -x binning/bowtie2-index -1 reads/"$f"_1.fastq -2 reads/"$f"_2.fastq -S binning/"$f".sam
	echo "$f"
	samtools view -bS binning/"$f".sam | samtools sort -o binning/"$f"_sort.bam
	samtools index binning/"$f"_sort.bam
	#adding this remove step since bam can always be converted to sam, and sam files take too much space
	rm -rf binning/"$f".sam
done 

