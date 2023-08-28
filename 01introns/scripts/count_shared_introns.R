
library(stringr)   # to use str_count() function

# command line arguments
args = commandArgs(trailingOnly = T)
infile  = args[1]
outfile = args[2]


# function to count how many loci have same coordidates
#   coords format: seqId|start|end;seqId|start|end;...
count_same_coords <- function(coords1, coords2){
  
  # of coords empty, return zero
  if(length(coords1) > 0 && length(coords2) > 0){
    # split at ";", then count how many in common
    return(sum( unlist( strsplit(coords1, ';') ) %in% unlist( strsplit(coords2, ';') ) ))
  }else{
    return(0)
  }
  
}

# read table
tab = read.table(infile, sep = '\t',
                 col.names = c('geneId', 'coords'))

# add these columns
tab$count_introns = NA    # how many introns in the gene
tab$count_matches = NA    # how many introns in common (same coordinates)

# for each pair of orthologous genes
for(i in seq(1, nrow(tab), by=2)){
  
  # get intron coordinates from both orthologs
  coords1 = tab[i, 'coords']
  coords2 = tab[i+1, 'coords']
  
  # count number of shared introns
  num_matches = count_same_coords(coords1, coords2)
  
  # count number of introns of each ortholog
  tab[i, 'count_introns'] = str_count(coords1, ";")
  tab[i+1, 'count_introns'] = str_count(coords2, ";")
  
  # add number of shared introns
  tab[i, 'count_matches']   = num_matches
  tab[i+1, 'count_matches'] = num_matches
}


# write output table
write.table(tab, outfile, sep = '\t', quote = F, row.names = F)



