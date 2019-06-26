# Sequencing run QC

## Get some sequence data

The first thing we'll do is to get some sequence data to work with. If you are working on a new sequencing project the data might come from a sequencing facility. For this tutorial we'll work with data that is available in public databases.
Published sequence data is usually archived in the NCBI SRA, the ENA, and the DDBJ.
These databases provide a [convenient interface to search](https://www.ncbi.nlm.nih.gov/) the descriptions of samples by keyword, and by sample type (e.g. shotgun metagenome).
For the following exercises we'll use a set of small datasets (SRA accessions SRR9323808, SRR9323810, SRR9323811, SRR9323809) which will be quick to process because they are small.
The easiest way to download data from these databases is via the `fastq-dump` software.
First, let's install the parallel version of fastq-dump using conda.
To do this, start a terminal session in your Jupyter server (click the Terminal icon) and run the following command (ok to copy and paste):

```
conda install -y -c bioconda parallel-fastq-dump 
```

Now that you've installed fastq-dump we can use it to download data by accession number. Copy and paste the following to your terminal:

```
parallel-fastq-dump -s SRR9323808 -s SRR9323810 -s SRR9323811 -s SRR9323809 --threads 4 --outdir qc_data/ --split-files --gzip
```

If the download was successful you should see something like the following on your terminal:

![Screenshot of parallel-fastq-dump](img/screenshot_fastq_dump.png)


## Evaluating sequence quality with FastQC and MultiQC

The very first thing one would normally do when working with a new dataset is to look at some basic quality statistics on the data.
There are many, many tools available to compute quality metrics. For our current data we will use the FastQC software, applied to each sample, and then combine the results using MultiQC to a single report. First step is to install `fastqc` and `multiqc`.

```
conda install -y -c bioconda fastqc
pip install multiqc
```
In the above we've used conda to install fastqc, but we've used another way to install multiqc -- something called `pip`. pip is an installer for python programs, and like conda it will download and install the software along with any dependencies. The reason we use pip in this case is because conda can be very, very slow to install some programs and in this case pip is much faster.

```
cd qc_data
find . -name "*.fastq.gz" -exec fastqc {} \;
```

Let's unpack those commands a bit. The first part, `cd qc_data` just changes the current directory to qc_data, so any following commands run will run in that directory.
The next command is `find . -name "*.fastq.gz" -exec fastqc {} \;`. The first part, `find` is a command that finds files. If you just run `find .` it will find all the files in and below the current directory (the `.` part specifies to look in the current directory). The next part, `-name "*.fastq.gz"` tells `find` that we only want it to find files with names that end with `.fastq.gz`. The `*` is a wildcard that matches anything. Finally, the last part `-exec fastqc {} \;` tells `find` that whenever it finds a file, it should run `fastqc` on that file, putting the name of the file where the `{}` are.

If this step has worked, then you should have several new `.zip` files containing the QC data in that directory, along with some html files. When we have a lot of samples it is too tedious to look at all the QC reports individually for each sample, so we can summarize them using multiqc:

```
multiqc .
```

At this point a multiqc file will appear inside the QC directory. First double click to open the QC folder.
![Screenshot of QC folder](img/qc_folder.png)

Once that's open a file called `multiqc_report.html` will appear in the listing. 
We can open this file from within our jupyter browser environment and inspect it.
To open it, we need to right click (or two-finger tap) on the file name to get a context menu that will give several options for how to open it. It looks like this:

![Opening MultiQC context menu](img/qc_open_in_browser_tab.png)

Click the option to "Open in a New Browser Tab". From here we can evaluate the quality of the libraries.


## Taxonomic analysis

Metagenome taxonomic analysis offers a means to estimate a microbial community profile from metagenomic sequence data.
It can give us a very high-level, rough idea of what kinds of microbes are present in a sample.
It can also give an idea of how complex/diverse the microbial community is -- whether there are many species or few.
It is useful as an initial quality check to ensure that the microbial community composition looks roughly as expected, and to confirm that nothing obvious went wrong during the sample collection and sequencing steps.

### Taxonomic analysis with Metaphlan2

While it may be possible to install metaphlan2 via conda, at least in my experience, conda struggles with "solving the environment".
Therefore it's suggested to install it via the simple download method described on the [metaphlan tutorial page](https://bitbucket.org/nsegata/metaphlan/wiki/MetaPhlAn_Pipelines_Tutorial):

```
cd ; wget -c -O metaphlan.tar.bz2 https://bitbucket.org/nsegata/metaphlan/get/default.tar.bz2
tar xvjf metaphlan.tar.bz2
mv nsegata-metaphlan* metaphlan
```

Once metaphlan has been downloaded we can run it on our QC samples:

```
cd ~/qc_data
pig_samples="SRR9323808 SRR9323810 SRR9323811 SRR9323809"
for s in ${pig_samples}
do
     zcat ${s}*.fastq.gz | python2 ~/metaphlan/metaphlan.py --input_type multifastq --bt2_ps very-sensitive --bowtie2db ~/metaphlan/bowtie2db/mpa  --bowtie2out ${s}.bt2out -o ${s}.mph2
done
```

The above series of commands creates a "for loop" where each iteration processes one of our metagenome samples. This is a convenient way to process many samples without having to type out the commands for each sample. The sample names get stored in a variable `$pig_samples` and at each loop iteration, one of the sample names is placed into the loop variable `${s}`, where it can get used in the command inside the loop.

Finally we can plot the taxonomic profile of the samples:
```
python2 ~/metaphlan/utils/merge_metaphlan_tables.py *.mph2 > pig_mph2.merged
python2 ~/metaphlan/plotting_scripts/metaphlan_hclust_heatmap.py -c bbcry --top 25 --minv 0.1 -s log --in pig_mph2.merged --out mph2_heatmap.png
```

Once that has completed successfully, a new file called `mph2_heatmap.png` will appear in the qc_data folder of our Jupyter file browser. We can double click it to view.

There are other ways to visualize the data, and they are described in the graphlan section of the [metaphlan tutorial](https://bitbucket.org/nsegata/metaphlan/wiki/MetaPhlAn_Pipelines_Tutorial) page.

### Taxonomic analysis with other tools

There are a whole range of other software tools available for metagenome taxonomic analysis. 
They all have strengths and weaknesses.

A few other commonly used tools are listed here:

* [kraken2](https://ccb.jhu.edu/software/kraken2/index.shtml)
* [MEGAN](http://ab.inf.uni-tuebingen.de/software/megan6/)
* [Centrifuge](http://www.ccb.jhu.edu/software/centrifuge/manual.shtml)
* [CLARK](http://clark.cs.ucr.edu/)


## Evaluating the host genomic content

In many applications of metagenomics we are working with host-associated samples. 
The samples might have come from an animal gut, mouth, or other surface.
Similarly for plants we might be working with leaf or root surfaces or rhizobia.
When such samples are collected the resulting DNA extracts can include a significant fraction of host material.
Let's have a look at what this looks like in data.
To do so, we'll download another set of pig gut samples: a set of samples that was taken using scrapings or swabs from different parts of the porcine digestive system, including the duodenum, jejunum, ileum, colon, and caecum.
Rather than using metaphlan2 to profile these, we will use the kraken2 classifier in conjunction with the bracken tool for estimating relative abundances.
We first need to install kraken2 and bracken:
```
conda install -c bioconda kraken2 bracken
```

Next, we need to get a kraken2 database.
For this tutorial we will simply use a precomputed kraken2 database but note the very important limitation that the only non-microbial genome it includes is the human genome.
If you would like to evaluate host genomic content on plants or other things you should follow the instructions on the kraken2 web site to build a complete database.
We can download and unpack the kraken2 database with:
```
cd ; wget -c ftp://ftp.ccb.jhu.edu/pub/data/kraken2_dbs/minikraken2_v2_8GB_201904_UPDATE.tgz
tar xvzf minikraken2_v2_8GB_201904_UPDATE.tgz
```

Finally we are ready to profile our samples with kraken2 and bracken.
We'll first download the sample set with `parallel-fastq-dump` and then run kraken2 and bracken's `est_abundance.py` script on each sample using a bash for loop.
The analysis can be run as follows:
```
parallel-fastq-dump  -s SRR9332442 -s SRR9332438 -s SRR9332439 -s SRR9332443 -s SRR9332440 --threads 4 --outdir host_qc/ --split-files --gzip
cd host_qc
samples="SRR9332442 SRR9332438 SRR9332439 SRR9332443 SRR9332440"
for s in $samples; do kraken2 --paired ${s}_1.fastq.gz ${s}_2.fastq.gz --db ../minikraken2_v2_8GB_201904_UPDATE/ --report ${s}.kreport > ${s}.kraken; done
for s in $samples; do est_abundance.py -i ${s}.kreport -k ../minikraken2_v2_8GB_201904_UPDATE/database150mers.kmer_distrib -o ${s}.bracken; done
```

Once the above has completed, navigate over to the `host_qc` folder in the Jupyter file browser and click on the `*.bracken` files to open them.
What do you see?
In particular, why does sample SRR9332438 look so different to sample SRR9332440?
Keep in mind the isolation sources of the samples were as follows:

| Sample     | Source   |
|------------|----------|
| SRR9332442 | Duodenum |
| SRR9332440 | Caecum   |
| SRR9332439 | Ileum    |
| SRR9332438 | Jejunum  |
| SRR9332443 | Colon    |

### Some challenge questions
* If we sequenced samples from pigs, why is human DNA being predicted in these samples?
* If we were to design a large study around these samples which of them would be suitable for metagenomics, and why?
* How much sequencing data would we need to generate from sample SRR9332440 to reconstruct the genome of the _Bifidobacterium_ in that sample? What about the _E. coli_?
* Are there really six species of _Lactobacillus_ present in SRR9332440?
* Go to the [NCBI SRA search tool](https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=search_obj) and find a metagenome of interest to you. Download the first 100000 reads from it (use the `--maxSpotId` parameter) and analyse it with kraken2. Is it what you expected? How does it compare to the others we've looked at?

## A note on negative controls

Negative controls are a key element in any microbiome profiling or metagenome analysis work.
Every aspect of the sample collection and processing can be impacted by the presence of contaminating microbial DNA.
This is true even of 'sterile' material -- just because no viable cells exist in a sample collection swab, for example, does not mean there is no microbial DNA on that swab.
It is well known that molecular biology reagents frequently contain contaminating DNA.
Usually it is at low levels, but this is not always the case.

Therefore, the best practice is to collect multiple negative control samples that are taken all the way through sequencing.
These negative controls can then be used to correct for contamination artifacts in the remaining samples.

