library(vegan)

#importing the file and parsing the file correctly
# Replace the kraken_final name to the actual filename.
Data=read.table("kraken_report-final.csv", header=TRUE, row.names = 1, sep=",")

#Below set of commands, need to change based on the table
Data_sub=as.data.frame(Data[,c(1:3)])
Data_t=(t(Data_sub))

#count the number of species
S <- specnumber(Data_t)
raremax<-min(rowSums(Data_t))
 
#Rarefaction of the samples
Srare <- rarefy(Data_t, raremax)
 
#plotting the rarefaction curves
plot(S, Srare, xlab = "Observed No. of Species", ylab = "Rarefied No. of Species")
abline(0, 1)
pdf("Rarefaction_curve.pdf")
rarecurve(Data_t, step =1, sample = raremax, col = "blue", cex = 0.4, )
dev.off()

#The rarefaction plot is saved to a file called "Rarefaction_curve.pdf"
