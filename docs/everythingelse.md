# What we didn't cover

## Experimental design

There are an almost endless array of questions that can be addressed with metagenomics and in this tutorial material we have only begun to scratch the surface of what is possible.
As a research tool, metagenomics is now beginning to move away from being purely discovery-oriented towards becoming a tool that is used to test specific hypotheses.
There are many, many things to consider when designing an experiment that involves metagenomics as a means to test a hypothesis.
First among these is whether the effect would be measurable via metagenomic data, e.g. is metagenomics the right tool for the job?
Then comes questions like:

* How deeply will you sequence?
* How many samples will you need?
* Will samples be structured as a time-series, or transect of some kind?
* How much background variation exists in the metagenomes that will be sampled?
* And based on the above, using a particular set of metagenome analysis tools, what is our statistical power to reject the hypothesis in question?

### Simulation for experimental design

One way to design and power a large metagenomic experiment is to carry out a computational simulation of the metagenomic sequencing that follows the experimental structure.
While this may seem tedious, I would argue that if the experiment is worth doing, then it is almost certainly worth doing a simulation study first.
There are a number of advantages to this kind of an approach.
For example:

* Hidden obstacles to the data analysis will be identified _a priori_, before the long and expensive experimental work and data generation begins.
* A data analysis workflow can be developed up front, so that when the data arrives the work to analyse it becomes simpler.
* The experiment can be rationally designed, with clear expectations about the number and type of samples required to measure an effect of a particular size.

One of the challenges to taking this approach is that reasonable simulation parameters may not be known.
If you're working in a well-studied microbial ecosystem like the human gut it may be possible to design an experiment entirely using knowledge gained from existing public datasets.
But if you're working in a more obscure system then there may not be much, if any, public data to use for experimental design.
In general the solution to this problem requires an iterative process, in which an initial small batch of pilot data is created, from which reasonable parameters can be estimated for the design of a larger study.

## Resolving strain mixtures

When a metagenomic sample contains genomes from more than one strain of the same species, or from two closely related species, it can cause the assembly to become highly fragmentary. 
The resulting assembly contigs can be very difficult to analyse with standard genome binning methods, for multiple reasons.
First, many binning tools will not process contigs if they are below a particular size.
Depending on the exact level of sequence identity among the two strains, only a small fraction of the genome might be present in contigs above the lower size limit.
Second, some of the contigs can represent a coassembly of the two strains.
Not only can this result in contig sequences that look unlike any of the individual genomes, but it also poses a problem for standard metagenome binning software because the contig belongs in more than one bin, yet these softwares can only assign contigs to single bins.
While there has been some work to try to resolve strain mixtures from metagenome assemblies, such as that implemented in the [DESMAN software](https://www.ncbi.nlm.nih.gov/pubmed/28934976), the problem remains challenging and better solutions are needed.

## Alpha and beta diversity, ecological networks

Although people usually carry out 16S amplicon sequencing to answer questions about microbial ecology it is also possible to address these with metagenomic data.
There are a range of computational methods and tools for taxonomy-driven metagenome community profiling.
Some of these were reviewed and evaluated in the [CAMI publication](https://www.nature.com/articles/nmeth.4458).
The taxonomy-based methods are limited, however, in that they can only resolve named taxonomic groups.
Much of the microbial diversity on our planet remains undescribed, and this is where phylogenetic methods have the potential to greatly outperform the taxonomic methods.
Phylogenetic methods don't depend on human-curated taxonomic structures, and therefore are capable of analysing wholly novel groups of organisms.
The equivalent class of methods in the 16S amplicon sequencing world are the reference-free _de novo_ OTU or Amplicon Sequence Variant (ASV) analysis methods.

## The list goes on

There are many, many more ways to analyze metagenomic data. 
Once MAGs have been reconstructed from the metagenomes pretty much any of the analyses that could be carried out on isolate genomes can be applied.
There are also a range of metagenome-specific analyses that could be applied to MAGs, such as association studies, phylogenetic studies, functional and metabolic analyses, and more.

