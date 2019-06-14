# Metagenome assembly

## What is assembly?

Assembly is the process of reconstructing long DNA sequences from a collection of overlapping shorter pieces.
In the context of single genomes (e.g. microbial isolates) the goal is usually to reconstruct a single chromosome and any associated plasmids or other replicons.
When presented with metagenomic data though, the microbial community might in reality have millions of genomes present in it.
Generally speaking, it is impossible to accurately reconstruct every genome of every cell in a metagenomic sample with current technology.
Instead we usually aim to reconstruct chromosome sequences that represent a consensus of many cells.

## Assembling metagenomes

There are several available metagenome assembly tools. 
Some examples include metaSPAdes and MEGAHIT.
In this tutorial we will use MEGAHIT.

```
singularity run docker://bioboxes/megahit:latest 

```

### Coassembly or single sample?

Just as important as deciding what assembler to use is deciding on _what to assemble_.
One approach is to assemble all of the metagenome samples together.
This can be useful if there is not much data per sample, or if low abundance organisms exist in the samples that would not have enough coverage in a single sample to be assembled.


## Limitations of metagenome assembly

Current assembly methods are limited in their ability to resolve chromosomes of closely related species and strains in a sample.
This is because most assembly methods collapse sequences > 95% or 98% identity into a single contig sequence, usually as a means to cope with sequencing error.
Therefore as a consensus representation, these assembled chromosome sequences may mask fine-scale genetic variation in the population.

