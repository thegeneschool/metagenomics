# Metagenome assembly

## What is assembly?

Assembly is the process of reconstructing long DNA sequences from a collection of overlapping shorter pieces.
In the context of single genomes (e.g. microbial isolates) the goal is usually to reconstruct a single chromosome and any associated plasmids or other replicons.
When presented with metagenomic data though, the microbial community might in reality have millions of genomes present in it.
Generally speaking, it is impossible to accurately reconstruct every genome of every cell in a metagenomic sample with current technology.
Instead we usually aim to reconstruct chromosome sequences that represent a consensus of many cells.

## Assembling metagenomes

There are several available metagenome assembly tools. 
Some examples include [metaSPAdes](http://bioinf.spbau.ru/metaspades) and [MEGAHIT](https://github.com/voutcn/megahit).
In this tutorial we will use MEGAHIT, and we will use it via a docker container.
As such, no installation step is necessary.

### Coassembly or single sample?

Just as important as deciding what assembler to use is deciding on _what to assemble_.
One approach is to assemble all of the metagenome samples together.
This can be useful if there is not much data per sample, or if low abundance organisms exist in the samples that would not have enough coverage in a single sample to be assembled.
But it can create problems if closely related species or strains exist in the different samples.

### Limitations of metagenome assembly

Current assembly methods are limited in their ability to resolve chromosomes of closely related species and strains in a sample.
This is because most assembly methods collapse sequences > 95% or 98% identity into a single contig sequence, usually as a means to cope with sequencing error.
Therefore as a consensus representation, these assembled chromosome sequences may mask fine-scale genetic variation in the population.

## Assembling some example data

!!! example "Get a timeseries dataset"
    ```bash
    cd
    parallel-fastq-dump/parallel-fastq-dump -t 8 --outdir asm --split-files --gzip  --minSpotId 0 --maxSpotId 50000 \
        -s SRR8960410 -s SRR8960409 -s SRR8960402 -s SRR8960368 -s SRR8960420 \
        -s SRR8960739 -s SRR8960679 -s SRR8960627 -s SRR8960591 -s SRR8960887 \
        && mv asm assembly
    ```
The above command will download the first 50000 read-pairs of a set of samples.
All of these samples come from the same pig, and were collected at different time points in consecutive weeks.

Now we can assemble with megahit:

!!! example "Assemble using megahit"
    ```bash
    singularity exec -B ~/assembly/:/data docker://quay.io/biocontainers/megahit:1.1.3--py36_0 megahit \
        -1 /data/SRR8960410_1.fastq.gz,/data/SRR8960409_1.fastq.gz,/data/SRR8960402_1.fastq.gz,/data/SRR8960368_1.fastq.gz,/data/SRR8960420_1.fastq.gz,/data/SRR8960739_1.fastq.gz,/data/SRR8960679_1.fastq.gz,/data/SRR8960627_1.fastq.gz,/data/SRR8960591_1.fastq.gz,/data/SRR8960887_1.fastq.gz \
        -2 /data/SRR8960410_2.fastq.gz,/data/SRR8960409_2.fastq.gz,/data/SRR8960402_2.fastq.gz,/data/SRR8960368_2.fastq.gz,/data/SRR8960420_2.fastq.gz,/data/SRR8960739_2.fastq.gz,/data/SRR8960679_2.fastq.gz,/data/SRR8960627_2.fastq.gz,/data/SRR8960591_2.fastq.gz,/data/SRR8960887_2.fastq.gz \
        -o /data/metaasm
    ```

That's a big command-line, so let's unpack what's happening. 
First, we're invoking `singularity`. 
Singularity is a container service that can download and run programs that have been packaged as _containers_ -- a system that allows all needed dependency software to be specified and obtained automatically. 
By invoking `singularity exec` we are saying that we want to run a command inside a container. 
Simply put it allows us to run the software easily and reliably, avoiding the manual software install process. 
The container we want to use is specified as `docker://quay.io/biocontainers/megahit:1.1.3--py36_0`. 
This is a docker container, and the `docker://` syntax tells singularity that it can download the container from a public server. 
The `:1.1.3--py36_0` specifies the exact version of the megahit container to use. 
Before the container specification we have the argument `-B ~/assembly/:/data`. 
This argument binds the `assembly/` directory in our current path to appear as `/data` inside the running container. 
Therefore the programs running inside the container (e.g. megahit) will be able to see all the files inside `~/assembly/` at the path `/data`. Next we have the megahit command line. 
This includes parameters `-1` and `-2` with a list of the FastQ files we want to assemble. 
Finally we ask megahit to save the assembly in the container path `/data/metaasm`, so it will show up in `~/assembly/metaasm` when the container has finished running.

At the end of this process we will have a metagenome assembly saved in the file `~/assembly/final.contigs.fa`. 
We can use this file for subsequent analyses.
One small detail we need to resolve is the formatting of contig names in the assembly file.
Besides just sequence names (eg `>k141_1`), megahit includes additional information in the faster header (eg `>k141_1 flag=1 multi=2.0000 len=315`). Although this is a valid use of the format, the whitespace causes problems for certain downstream analyses, such as visualization with anvi'o.
Therefore as a final step in the assembly process we need to rename the contigs with the following commands:

!!! example "Simplifying contig names"
    ```bash
    cd assembly/metaasm
    # use pattern replacement to remove extra details from fasta headers
    sed -r 's/(>[^ ]+).*/\1/' final.contigs.fa > contigs-fixnames.fa
    ```

