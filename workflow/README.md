# README
## Description:
This workflow takes a set of input shortgun sequenced metagenomes and build metagenome assembled genomes (MAGs) using currently available programs. The workflow includes job scripts that can be submitted to a PBS/TORQUE job scheduler, but can be transferable to other clusters. 
Follow the README to run this workflow. 

## Steps to run the scripts

**SETTING UP SCRIPTS FIRST** \
Run the following commands, that will find the job scripts saved with an extension .sh and replaces the emailaddress and adds the path
make sure to CHNAGE MY EMAIL ADDRESS TO YOURS HERE,
	
	for f in */*.sh; do sed -i 's/YOUREMAILHERE/email@iu.edu/g' $f; done
	for f in */*.sh; do p=`pwd`; sed -i "s|PWDHERE|$p|g" $f ; done 

**LETS START WITH THE READS** \
Make sure all the reads do end with the extension "*.fastq" and NOT "*.fq".
Add you reads as files to the reads directory. In the reads directory, run the command

	cd reads/
        cat *1.fastq >left.fq
        cat *2.fastq >right.fq 

This command joins all the left reads(ending with 1.fastq) toegther to left.fq and all the right reads (ending with 2.fastq). 

**ASSEMBLY AND ASSEMBLY REPORTS** \
- Go to to assembly directory to start assembling the reads. 
The script co-assembles all the samples together, and individual assemblies for each sample. 
	
	cd assembly
	
- Before you start, take a look at the job script and make sure the email and path is set correctly before you submit the job. 
To take a look at the job script you can use the command
	
        less 1-spades.sh
        less 1-megahit.sh 

To run the job script, the command is
        
        qusb 1-spades.sh
        qsub 1-megahit.sh 

Wait for these jobs to complete. Take a look at the job logs to make sure the job completed successfully before continuing 
OUTPUT - should end with the filename "_output"

- Next, lets deduplicate all the assemblies to generate one set of final contigs using bbtools/dedupe.sh. 
To run this script, run the command, 
	
	qsub 2-dedupe.sh
	
Wait for the jobs to complete before running the next script. 
All the contigs should be saved to a directory called "contigs".
 
- Once the deduplication is complete, then run the next script. 
        
        qsub 3-quast.sh 

The quast.sh script runs assembly statistics to all the assemblers (coassembly, individual assemblies, deduplicated contigs), and writes the output to a table.
OUTPUT- saved to a file called quast_table.tsv. 
Take a look at the quast_table.tsv, pick the assembler that likely produced the most number of reads, with high N50 lengths. 

- Move the asemmbled contigs you would like to use for the rest of the workflow from the contigs directory. 
Generally since dedupe.sh would have more contigs since it contains the final deduplicated set of contigs from the assemblies. 
Do make note that using this result for estimating taxa/functional abundance can highly bias the results. 

	`mv assembly/contigs/dedupe.sh assembly/final_contigs.fa`

**BINNING AND BIN QUALITY REPORTS** 
- Lets start grouping similar sequences together now. 
Enter the binning directory.

	cd binning
        
- Run the first script here to realign all the reads back to the contigs to generate bam files that are required as input for the binning programs we will be using next.

        qsub 1-bamfiles.sh

OUTPUT- a set of files that end with the extension *.bam and *.bai. 
- Wait for this job to complete before starting the next one. 

		qsub 2-metabat2.sh
		qsub 2-concoct.sh

OUTPUT - MetaBat2 outputs the bins to metabat_bins and concoct outputs to concoct_bins. Both these directories should have a list of bins that was put from the two programs. 

BELOW is *Work in progress*
- Running dastool that takes the bins from metabat2 and concoct to remove non-redundant set of bins from both the binning algorithms. This will generate one set of outputs, 

		qsub 3-dastool.sh

OUTPUT - DASToolRun1_metabat_eval, DASToolRun1_metabat_eval - contains the completness and redundancy scores calculated for eeach bin
	 DASToolRun1_DASTool_bins - list of bins from metabat, concoct that passed the threshold score

- Finally run checkM to generate quality statistics of all the bins from Metabat2 and Concoct to see how the quality improved and the final set of bins to use for Downstream analysis 

		qsub 4-checkm.sh

OUTPUT- saved to file in path binning/checkm/checkm_summary.

**TAXA ANNOTATION** \
Enter the taxa directory, run any one or all of the taxonomic identification tools to generate a taxonomic profile of the metagenomic samples. The input for these taxa annotation tools are reads (post processing). 

        cd taxa/

        qsub kraken.sh
OUTPUT is saved to the file "kraken-report-final.csv"

        qsub focus.sh
OUTPUT is saved to the files in a directory "focus_output/".

        qsub centrifuge.sh
OUTPUT is saved to multiple files.

Another note to make here, notice how the script don't run for the left.fq and right.fq, this is because these are concaternated from all the individual file, meaning their abundance scores really don't tell you any inforamtion about each sample.

**FUNCTIONAL ANNOTATION** \
Enter the function directory, run any of the scripts to generate a functional profile for the metagenome samples. In this instance the input files are the assembled contigs NOT the reads. This is because, the input read are much smaller in length, therefore can be fragmenting the whole protein information. 

        cd functions\

	qsub prokka.sh
OUTPUT is saved to functions/prokka_output

	qsub fragenescan.sh
OUTPUT is saved to functiona/fraggenescan_output

## Contact 
Email bhnala@iu.edu
