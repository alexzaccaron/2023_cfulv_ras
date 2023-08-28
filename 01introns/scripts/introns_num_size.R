
library(ggplot2)
require(gridExtra)

# in/out files
infile = 'data/introns_num_size.txt'
output = 'plots/introns_num_size.png'


# read table with number and total size of introns of orthologous pairs of genes
tab_introns = read.table(infile, header = T)


# plot 1: scatter plot showing number of introns for each orthologous pair
p1 = ggplot(tab_introns, aes(x=Race5_no, y=Race4_no)) + 
  geom_point(alpha = 0.4) +
  xlim(0,20) +
  ylim(0,20) +
  xlab("Number of introns in Race 5") +
  ylab("Number of introns in Race 4") +
  theme_bw()

# plot 2: scatter plot showing total size of introns for each orthologous pair
p2 = ggplot(tab_introns, aes(x=Race5_size, y=Race4_size)) + 
  geom_point(alpha = 0.4) +
  xlim(0,3000) +
  ylim(0,3000) +
  xlab("Total size of introns in Race 5") +
  ylab("Total size of introns in Race 4") +
  theme_bw()

# save plot to file
#pdf(output, width = 8, height = 3.8)
png(output, width = 8, height = 3.8, units = 'in', res=300)
grid.arrange(p1, p2, ncol=2)
dev.off()


