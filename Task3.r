#loading the required library
library(ggplot2)
library(readr)
library(dplyr)
##importing the data file
gene_info <- read_delim("Homo_sapiens.gene_info.gz", delim = "\t", escape_double = FALSE)
#Extracting required columns
gene_info<-gene_info[,c(3,7)]
## Filtering the data
gene_info_filtered= gene_info[!grepl("[\\|-]",gene_info$chromosome),]
##cross-checking the filtered data
missing_geneinfo <- anti_join(gene_info, gene_info_filtered, by = "chromosome")
##counting the genes corresponding to the chromosome
gene_counts <- table(gene_info_filtered$chromosome)
bar_input= data.frame(Chromosome=names(gene_counts),Gene_count=as.vector(gene_counts))
chrOrder <-c((1:22),"X","Y","MT","Un")
##creating the barplot
my_plot<-ggplot(bar_input, aes(x =factor(bar_input$Chromosome, levels=chrOrder), y = Gene_count)) +
  geom_bar(stat = "identity",) +
  labs(x = "Chromosomes", y = "Gene Count", title = "Number of genes in each chromosome",) +
  theme(panel.background = element_rect(fill = "white"),axis.line = element_line(colour = "black"),plot.title = element_text(hjust = 0.5))
##saving the plot in pdf format
ggsave("Task3-plot.pdf",my_plot, width = 6, height = 4)
