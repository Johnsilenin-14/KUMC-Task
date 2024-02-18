library(readr)
library(tidyr)
library(GSA)
##Importing gmt file#
data <-  GSA.read.gmt("h.all.v2023.1.Hs.symbols.gmt")
len_vec=c()          
# Now create a vector for containing the length of genes at each position
#len_vec[1] = 3
for(i in 1:length(data$genesets)){
  len_vec[i] <- length(data$genesets[[i]])
}
# Now create a vector for all the pathways in the data
pathway_vec <- unlist(Vectorize(rep.int)(data$geneset.names, len_vec),use.names = FALSE) 
# This gives your desired dataframe
desired_df <- as.data.frame(cbind(pathway_vec,unlist(data$genesets,use.names = FALSE))) 
desired_df2 <- as.data.frame(cbind(data$geneset.names,data$geneset.descriptions)) 
write.table(desired_df2,"2.xlsx", row.names = F)
head(desired_df)
names(desired_df)=c("Pathway","Genes")
names(desired_df2)=c("Pathway","Description")


##importing gene info file
gene_info <- read_delim("Homo_sapiens.gene_info.gz", delim = "\t", escape_double = FALSE)
gene_info1<-gene_info[,c(2,3,5)]
gene_info2<-separate_rows(gene_info1,Synonyms, sep = "\\|")
head(gene_info2)

##making unique id mapping file
Symbol=unique(gene_info1[,c(1,2)])
Synonyms=unique(gene_info2[,c(1,3)])
names(Synonyms)[2]="Symbol"

##identifying and removing the gene_symbol which is present as Synonym of another gene-symbol##
same=intersect(gene_info2$Symbol,gene_info2$Synonyms)
length(same)
UniqueSyn <- subset(Synonyms, !(Symbol %in% same))

##final geneid and symbols
Merging_allgenes<-rbind(Symbol,UniqueSyn)

#merging GeneId with Symbols in geneset
Final_merge<- merge(desired_df, Merging_allgenes, by.x= "Genes", by.y = "Symbol")
##genesymbol HBD has two geneids

# Combine genes of the 'GeneID' column based on the 'Geneset' column
combined_values <- aggregate(GeneID ~ Pathway , data = Final_merge, FUN = function(x) paste(x, collapse = "  "))

###Merging gene description with geneset 
final_data<-merge(combined_values,desired_df2, by ="Pathway")
final_data=final_data[,c(1,3,2)]

##Saving entrezid replaced gmt file
write.table(final_data, file = "entrez_replaced.gmt",sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)
##checking##
new<-GSA.read.gmt("entrez_renamed.gmt")
print(head(new))
