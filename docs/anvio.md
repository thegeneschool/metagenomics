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
Once the installation has completed, we will need to activate the environment with `conda activate anvio5` in order to use anvi'o.


## Preparing data for anvi'o

First we need to prepare our data for use in anvi'o.
Because we already have binning results from MetaBAT2 we will ask anvi'o to import those bins rather than computing new bins.
This will allow us to use anvi'o to browse the bins and interactively check and refine them as necessary.
But before we get to that, we need to get anvi'o to process the metagenome assembly contigs and the bam files of mapped reads:

```
anvi-gen-contigs-database -f contigs-fixnames.fa -o contigs.db -n 'A gene school DB'
anvi-run-hmms -c contigs.db
for bam in `ls *.bam`; do anvi-profile -i $bam -c contigs.db; done
anvi-merge */PROFILE.db -o SAMPLES-MERGED -c contigs.db --skip-hierarchical-clustering --skip-concoct-binning
```

The above series of commands will take us from assembly contigs to a working anvi'o database, but there is a lot of compute along the way so if the data set is anything more than extremely trivial you will have to be _very patient_.
The pig metagenome timeseries dataset we are using in this tutorial requires over 900 hours of CPU time to process with the above commands.
If you have access to a large multicore machine (or large AWS instance) this process can be sped up by running many threads via the `-T` command-line parameter.

Next, we need to create a file that will allow us to import our MetaBAT2 bins into anvi'o.
This is a pretty simple process:

```
cd contigs-fixnames.fa.metabat-bins/
grep ">" bin.*fa | perl -p -i -e "s/bin\.(.+).fa:>(.+)/\$2\tbin_\$1/g" > ../binning_results.txt
cd ..
anvi-import-collection binning_results.txt -p SAMPLES-MERGED/PROFILE.db -c contigs.db -C "MetaBAT2" --contigs-mode
anvi-summarize -p SAMPLES-MERGED/PROFILE.db -c contigs.db -C MetaBAT2 -o MERGED_SUMMARY
```

The idea is to create a tab-delimited text file with two columns: the first is contig name and the second is the name of the bin that contig belongs to.
The command `grep ">" bin.*fa` pulls out the contig names from each FastA bin file, and pipes the result to this command `perl -p -i -e "s/(.+).fa:>(.+)/\$2\t\$1/g"` which is using a perl regular expression to extract the contig name (in $2) and bin ID (in $1) and report them in two columns separated by the tab character `\t`.
The results are saved in a file called `binning_results.txt`.
We can then import the binning results into our anvi'o database with `anvi-import-collection`, and then compute some useful summaries of the bins with `anvi-summarize`.

## Connecting to an anvi'o server

When used in interactive mode anvi'o is usually expected to be running locally on your own machine.
However, we are working on VMs in the cloud and so we need to start up an anvi'o server on our remote machine and then connect to it with our web browser.
Note that *this will only work with google chrome browser*. 
anvi'o's interactive mode does not currently work with any other browsers. 
You can try it of course but you're on your own when something goes wrong (which, in fact, could be said of almost anything in bioinformatics).

```
anvi-interactive -p SAMPLES-MERGED/PROFILE.db -c contigs.db --server-only -P 8080 --password-protected -C MetaBAT2
```

when anvi'o launches it will ask you to provide a password. 
Make one up, and be sure to choose one you can remember at least long enough to log into the server!
Once the server is running you can log into it via the chrome web browser by providing the IP address and port 8080 in the location bar, e.g. `http://AA.BB.CC.DD:8080` where AA.BB.CC.DD is the IP of your VM. 
Alternatively if you are using the a provided workshop VM you can just open (in a new tab) the `anvio.html` file from Jupyter and it will redirect the browser to port 8080.

*IMPORTANT:* if you are working in the Jupyter bash notebook you must remove the parameter `--password-protected` from the above command because it is impossible to interact with running shell programs, and therefore impossible to provide the password that anvi'o requests.

## Refining MAGs with anvi'o

While the automated binning process implemented in MetaBAT2 is relatively easy to apply even to large datasets, these methods are not perfect and sometimes they can produce erroneous genome bins.
anvi'o offers some useful data visualizations methods that can help us to identify cases where a MAG appears to have dubious features.
This might be especially relevant if there is a genome that is particularly relevant for your study, for example a nitrogen fixing organism associated with a plant.
You might want to confirm that the genome bin looks correct prior to metabolic analysis, for example, to predict culture conditions for isolating an organism.
With anvi'o we can inspect individual genome bins, and even modify them interactively, using the `anvi-refine` command.
As with `anvi-interactive` above this runs via a web server/client structure, so we can launch it on our VM and connect to it with our browser in the same way.
For example if we want to refine bin 42 we would run:

```
anvi-refine -p SAMPLES-MERGED/PROFILE.db -c contigs.db --server-only -P 8080 --password-protected -C MetaBAT2 -b bin_42
```
and then point our browser at the anvi'o server as noted above.

*IMPORTANT:* if you are working in the Jupyter bash notebook you must remove the parameter `--password-protected` from the above command because it is impossible to interact with running shell programs, and therefore impossible to provide the password that anvi'o requests.


For more details about bin refinement with anvi'o check out the tutorials and notes on the anvi'o website:

* [Refining MAGs with anvi'o](http://merenlab.org/2015/05/11/anvi-refine/)
* [Notes on bin refinement with anvi'o](http://merenlab.org/2017/05/11/anvi-refine-by-veronika/)


### Challenge exercises

* Using `anvi-interactive` find a bin with a high predicted redundancy rate and another with a low rate. Then load each bin in `anvi-refine`. How do their profiles differ?
* If we had a metagenome with two strains where 80% of the gene content was common to both strains, and the binning software reconstructed the most abundant one as a bin, what would the coverage profile for that bin look like in `anvi-refine`? What about the coverage standard deviation?
* What can Single Nucleotide Variants (SNVs) tell us about a genome bin?


