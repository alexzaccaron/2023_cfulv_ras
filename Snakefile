

SAMPLES=["DDA_R4", "DDA_R5", "DIA_R4", "DIA_R5"]
FASTAS=["Race4_fs", "Race4_lo", "Race5_fs", "Race5_lo"]



rule all:
   input:
      expand("output/02proteins/{fasta}.fasta", fasta=FASTAS),
      expand("output/03match_peptides/{sample}__{fasta}.txt", sample=SAMPLES, fasta=FASTAS)



##remove_parenthesis: remove any characters between parenthesis and parenthesis themselves. Remove ^M characters too.
rule remove_parenthesis:
   input:
      "data/{sample}_peptides.txt"
   output:
      "output/01peptides/{sample}_peptides_par.txt"
   shell: """
      sed "s/[(][^)]*[)]//g" {input} | cat -v | sed 's/\^M//g' > {output}
   """



##single_line_fasta: multi- to single-line fasta
rule single_line_fasta:
   input:
      "data/{fasta}.fasta"
   output:
      "output/02proteins/{fasta}.fasta"
   shell: """
      seqtk seq {input} > {output}
   """



rule match_peptides:
   input:
      fasta="output/02proteins/{fasta}.fasta",
      peptides="output/01peptides/{sample}_peptides_par.txt"
   output:
      "output/03match_peptides/{sample}__{fasta}.txt"
   shell: """
      while read PEPTIDE; do
         echo -n "$PEPTIDE"$'\\t'
         (grep -B 1 $PEPTIDE {input.fasta} || true) | (grep "^>" || true) | tr -d '>' | tr '\\n' ','
         echo ""
      done < {input.peptides} | sed 's/,$//g' > {output}
   """












