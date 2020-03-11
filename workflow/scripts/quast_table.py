#!/usr/bin/env python

import sys 
import os
import argparse
import numpy as np
import pandas as pd
from collections import defaultdict

'''
This code takes the quast output from multiple files - and generates one big table from quast output - report.tsv 
To run this code 
1) setup a new directory for quast outputs
2) write all the report.tsv files to the new directory, but make sure to rename the report.tsv to sample-name.tsv to the new directory
	To do this, you can run mv report.tsv quast-out/sample-name.tsv 
	For multiple files - I just run the above command using a for loop 
3) Confirm that the new directory quast-out has the right number of files
'''

def quast_table (quast_output, final_table):
	files=os.listdir(quast_output)
	assert (len(files)!=0), "The directory is empty"
	path=[]
	l=[]
	for f in files:
		fipath=os.path.join(quast_output,f)
		path.append(fipath)
		report=open(fipath, 'r')
		for line in report:
			l.append(line.rstrip().split('\t'))
	
		my_list1 = [i[0] for i in l]
		my_list2 = [i[1] for i in l]

	assem=['Assembly']
	contigs0=['Contigs(>=0bp)']
	contigs1000=['Contigs(>=1000bp)']
	contigs5000=['Contigs(>=5000bp)']
	contigs10k=['Contigs(>=10000bp)']
	contigs25k=['Contigs(>=25000bp)']
	contigs50k=['Contigs(>=50000bp)']
	length0=['Total_length(>=0bp)']
	length1000=['Total_length(>=1000bp)']
	length5000=['Total_length(>=5000bp)']
	length10k=['Total_length(>=10000bp)']
	length25k=['Total_length(>=25000bp)']
	length50k=['Total_length(>=50000bp)']
	contigs=['Contigs']
	longest=['Largest_contig']
	totlen=['Total_length']
	gc=['GC(%)']
	n50=['N50']
	n75=['N75']
	l50=['L50']
	l75=['L75']
	ns=["N's_per_100_kbp"]
	for f in range(len(my_list1)):
		letter=my_list1[f]
		#print (letter)
		if (letter == "Assembly"):
			assem.append(my_list2[f])
		elif (letter == "# contigs (>= 0 bp)"):
			contigs0.append(my_list2[f])
		elif (letter == "# contigs (>= 1000 bp)"):
			contigs1000.append(my_list2[f])
		elif (letter == "# contigs (>= 5000 bp)"):
			contigs5000.append(my_list2[f])
		elif (letter == "# contigs (>= 10000 bp)"):
			contigs10k.append(my_list2[f])
		elif (letter == "# contigs (>= 25000 bp)"):
			contigs25k.append(my_list2[f])
		elif (letter == "# contigs (>= 50000 bp)"):
			contigs50k.append(my_list2[f])
		elif (letter == "Total length (>= 0 bp)"):
			length0.append(my_list2[f])
		elif (letter == "Total length (>= 1000 bp)"):
                        length1000.append(my_list2[f])
		elif (letter == "Total length (>= 5000 bp)"):
                        length5000.append(my_list2[f])
		elif (letter == "Total length (>= 10000 bp)"):
                        length10k.append(my_list2[f])
		elif (letter == "Total length (>= 25000 bp)"):
                        length25k.append(my_list2[f])
		elif (letter == "Total length (>= 50000 bp)"):
                        length50k.append(my_list2[f])
		elif (letter == "# contigs"):
                        contigs.append(my_list2[f])
		elif (letter == "Largest contig"):
                        longest.append(my_list2[f])
		elif (letter == "Total length"):
                        totlen.append(my_list2[f])
		elif (letter == "GC (%)"):
                        gc.append(my_list2[f])
		elif (letter == "N50"):
                        n50.append(my_list2[f])
		elif (letter == "N75"):
                        n75.append(my_list2[f])
		elif (letter == "L50"):
                        l50.append(my_list2[f])
		elif (letter == "L75"):
                        l75.append(my_list2[f])
		elif (letter == "# N's per 100 kbp"):
                        ns.append(my_list2[f])

	#writing the lists to an output
	with open (final_table, 'w') as filehandle:
		for item in assem: 
			filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in contigs0:
			filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in contigs1000:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in contigs5000:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in contigs10k:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in contigs25k:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in contigs50k:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in length0:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in length1000:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in length5000:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in length10k:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in length25k:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in length50k:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in contigs:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in longest:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in totlen:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in gc:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in n50:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in n75:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in l50:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in l75:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')
		for item in ns:
                        filehandle.write('%s\t' % item)
		filehandle.write('\n')

if __name__=='__main__' :
	parser=argparse.ArgumentParser(description="Take multiple quast output files and consolidate them to one output")
	parser.add_argument ('-d', dest='directory', help='Enter the quast output directories')
	parser.add_argument ('-o', dest='output', help='Enter the output file name')
	results=parser.parse_args()
	#input_dir(results.directory)
	quast_table(results.directory, results.output)

