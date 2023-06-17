
library(seqinr)
library(reshape2)


# csv table with all peptides identified and the corresponding gene <geneID>,<peptide>
all_peptides = read.csv("data/DDA_R5_peptides_ed.txt")

# read a fasta file with all isoform sequences (tens of thousands)
all_isoforms = read.fasta("data/Race5_fs.fasta")


genes = readLines("data/ids")

result_matrix_long = NULL

# one gene at a time, will be inside a foor loop
for(gene in genes){
  
  # peptides of the gene
  peptides = all_peptides[all_peptides$geneID == gene, 'peptide']
  names(peptides) = peptides # name them
  
  
  # get all isoforms from gene
  gene_isoforms = all_isoforms[grep(gene, names(all_isoforms))]
  
  # convert to a list of strings
  isoforms_list = list()
  for (i in 1:length(gene_isoforms)) {
    isoforms_list[[i]] <- toupper(c2s(gene_isoforms[[i]]))
  }
  names(isoforms_list) = names(gene_isoforms) # name items in the list
  
  
  
  # Create a matrix to store the presence/absence results
  result_matrix = matrix(0, nrow = length(isoforms_list), ncol = length(peptides))
  colnames(result_matrix) = peptides
  rownames(result_matrix) = names(isoforms_list)
  
  
  # Iterate through each peptide and element of my_list
  for (peptide in peptides) {
    for (isoform in names(isoforms_list)) {
      if (grepl(peptide, isoforms_list[[isoform]])) {
        result_matrix[isoform, peptide] <- 1  # Mark presence as 1
      }
    }
  }
  
  #write.table(result_matrix, file = paste0(gene,".txt"), quote = F, sep = '\t')
  
  result_matrix_long = rbind(result_matrix_long, melt(result_matrix) )
  
}

write.table(result_matrix_long, file = "result_matrix_long.txt", quote = F, sep = '\t')
  

