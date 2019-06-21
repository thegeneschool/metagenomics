# Visualization of metagenome data

In this section we will explore ways to visualize the metagenomic data, with a view toward understanding the MAGs that we have reconstructed from our metagenomes.
For this we will use software called anvi'o, a highly versatile visualization and analysis environment for metagenomic (and pan-genomic) data.
The anvi'o software is extensively documented on [the anvi'o website](http://merenlab.org/software/anvio/), and rather than recapitulate all of that material here we will just go through the basic steps involved in getting our data loaded into anvi'o.
For further details on using the variety of features in anvi'o you can refer to the above site.

## Installing anvi'o

The simplest way to install anvi'o is via conda:

```
conda create -n anvio5 -c bioconda -c conda-forge anvio=5.5.0
```

Notice this command is slightly different to our previous conda software installations, in this command we are invoking `conda create` which creates a new conda environment for anvi'o.
After the installation has completed, to use anvi'o we will first need to activate the environment with `conda activate anvio5`.


## Using anvi'o

First we need to prepare our data for use in anvi'o.
Because we already have binning results from MetaBAT2 we will ask anvi'o to import those bins rather than computing new bins.
This will allow us to use anvi'o to browse the bins and interactively check and refine them as necessary.

```
cp contigs.fa contigs-fixnames.fa
perl -p -i -e "s/(>\w+) flag.*/\$1/g" contigs-fixnames.fa
#anvi-script-reformat-fasta contigs.fa -o contigs-anvio.fa -l 1000 --simplify-names 
anvi-gen-contigs-database -f contigs-fixnames.fa -o contigs.db -n 'A gene school DB'
anvi-run-hmms -c contigs.db
for bam in `ls *.bam`; do anvi-profile -i $bam -c contigs.db; done
anvi-merge */PROFILE.db -o SAMPLES-MERGED -c contigs.db
anvi-import-collection binning_results.txt -p SAMPLES-MERGED/PROFILE.db -c contigs.db --source "MetaBAT2"
```

The above series of commands will take us from assembly contigs to a working anvi'o database, but there is a lot of compute along the way so if the data set is anything more than extremely trivial you will have to be _very patient_.


## Connecting to an anvi'o server

When used in interactive mode anvi'o is usually expected to be running locally on your own machine.
However, we are working on VMs in the cloud and so we need to start up an anvi'o server on our remote machine and then connect to it with our web browser.
Note that *this will only work with google chrome browser*. 
anvi'o's interactive mode does not currently work with any other browsers. 
You can try it of course but you're on your own when something goes wrong (which, in fact, could be said of almost anything in bioinformatics).

```
anvi-interactive -p MERGED/PROFILE.db -c CONTIGS.db -s SAMPLES.db --server-only -P 8080 --password-protected
```
