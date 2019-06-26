# Metagenome Assembled Genomes (MAGs) from metagenome binning

## What is a MAG?

A MAG, or Metagenome Assembled Genome, is a genome that has been reconstructed from metagenomic data.
Because these genomes do not derive from a clonal culture they typically represent a consensus of the genomes of many closely related cells in one or more metagenomic samples, and for this reason they are sometimes called _population genomes_.
It is important to remember that because of the way MAGs are inferred from the data the resulting sequence is usually fragmentary and may not accurately represent the genome of _any_ cell in the community.
It is merely an average estimate, and there are well-known problems with taking averages, see for example the wikipedia page on [Simpson's paradox](https://en.wikipedia.org/wiki/Simpson%27s_paradox) to get an idea of how averages can go wrong.

## What is a good MAG?

The international genomics community has made an effort to define quality standards for MAGs via the [Minimum Information about a Metagenome Assembled Genome (MIMAG)](https://www.nature.com/articles/nbt.3893) standards.
The basic idea is to require certain minimum levels of estimated completenes and maximal levels of estimated contamination in the MAG for it to be considered as one of "Low-quality", "Medium-quality", "High-quality", or "Finished". See [Table 1](https://www.nature.com/articles/nbt.3893/tables/1) in the above-linked paper for the full details.
Generally speaking it is hard to achieve "High-quality" and nearly impossible to get "Finished" with short read sequencing data alone.
Long read metagenome data has been shown to produce results in these categories, although it can be difficult to obtain sufficient DNA for those methods, and they currently remain more expensive than short read sequencing.


## Making MAGs
The process of reconstructing genomes from a metagenome is often referred to as _metagenome binning_ or just _binning_, from the process of assigning contigs to one 'bin' per genome.
There are many binning tools available to extract MAGs from metagenome assemblies.
When timeseries data is available, [MetaBAT2](https://bitbucket.org/berkeleylab/metabat/src/master/) is a good choice because it is both easy to use and offers good performance.
MetaBAT2 can be installed via conda as follows:

```
conda install -y -c bioconda metabat2
```

### MetaBAT2 input data

As input, MetaBAT2 requires reads from each of the shotgun metagenome samples to be mapped back to the metagenome assembly.
We will not cover the read mapping process in this tutorial, but it can be carried out using standard mapping software such as [bwa mem](https://github.com/lh3/bwa) or [bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml).
Be sure to sort and index the bam files with [samtools](http://www.htslib.org/) prior to running metabat.
Assuming we have bam files of mapped reads and the metagenome assembly available in a directory called `~/data` we can compute genome bins as follows:

```
mkdir ~/metabat ; cd ~/metabat
runMetaBat.sh ~/data/contigs-fixnames.fa ~/data/*.bam 
```

Depending on how much data you've got this can take a long time to compute.
Luckily MetaBAT2 has a good parallel implementation so it can go faster if you run on a large multi-core machine.
At the end of the process MetaBAT2 will produce a directory called `contigs-fixnames.fa.metabat-bins`, which contains one FastA file of contigs for each genome bin that it inferred.

