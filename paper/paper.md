---
title: 'The Gene School Metagenomics'
tags:
  - metagenomics
  - microbiome
  - DNA sequencing
  - Hi-C
  - metagenome assembly
  - metagenome binning
authors:
  - name: Matthew Z DeMaere
    orcid: 0000-0002-7601-5108
    affiliation: 1
  - name: Aaron E Darling
    orcid: 0000-0003-2397-7925
    affiliation: 1
affiliations:
 - name: University of Technology Sydney, The ithree institute
   index: 1
date: 19 December 2019
bibliography: paper.bib

---

# Summary

<!-- Describe the submission, and explain its eligibility for JOSE. -->
This short manuscript describes an open educational resource for teaching applied metagenomic data analysis.
The material assumes that trainees have a basic knowledge of metagenomics and computing, or that such knowledge is supplied separately via lecture material.
Text documents provided herein are licensed as CC-BY and all software used is available under an OSI-approved license.

# Statement of need
<!-- Include a “Statement of Need” section, explaining how the submitted artifacts contribute to computationally enabled teaching and learning, and describing how they might be adopted by others. -->
The importance and pervasiveness of microbial communities in biological systems is now widely appreciated, and high throughput DNA sequencing has provided a means to characterize and quantify such microbial communities, in particular via metagenome sequencing.
Successful application of metagenome sequencing requires careful experimental design and planning, not just for the sampling process but also for the sequencing and data analysis components.
A wholistic view of the entire process from sampling to data analysis is required.
The educational materials we present in this open module are designed to give students hands-on experience with several aspects of experimental design and data analysis for metagenome analysis.
The material introduces several state of the art (as of 2019) data analysis methods for metagenome quality control, genome assembly, and genome binning.
The module also covers the application of emerging techniques such as metagenomic Hi-C for which open source analysis software has only recently been introduced and no previous educational material has been developed.


# Learning objectives

Students trained with this module are expected to develop the following skills:

- Work in a Jupyter bash environment
- Install software via conda
- Run containerized software via docker and singularity
- Carry out QC for metagenome data samples
  - Sequencing QC with FastQC and MultiQC [@ewels:2016]
  - Taxonomic profiling as QC using metaphlan and kraken2 [@segata:2012; @wood:2019]
- Understand the limitations of reference databases for metagenome analysis
- Learn how a pilot study can inform experimental design
  - Learn how to estimate metagenome sequencing depth requirements
  - How do host-associated samples affect sequencing depth requirements
  - Designs that maximize experimental interpretation via genome-centric metagenomics
    - Time-series
    - Spatial or population transects
- Learn how to assemble metagenomes
  - Use the megahit assembler [@li:2015]
  - Understand whether or not to co-assemble multiple samples
- Binning genomes from metagenomes with MetaBAT2 [@kang:2019]
- Visualization of bins and bin refinement with anvi'o [@eren:2016]
- Using Hi-C for genome binning
  - Carry out QC for a metagenomic Hi-C library with [qc3C](https://github.com/cerebis/qc3C)
  - Extract Metagenome-assembled genomes (MAGs) with Hi-C data with bin3C [@demaere:2019]


# Content

This open educational resource comprises a collection of markdown-formatted workshop pages, a collection of publicly available data sets, and a virtual machine image preloaded with data & results so that compute-intensive steps can be skipped during course delivery.

# Instructional design

The material is designed for use in a hybrid lecture and active learning format.
Lecture material that introduces the concepts of microbial communities, their genetics, and metagenome sequencing provides appropriate context for the hands on computational steps in this module.
The active learning material has been designed for use in Jupyter, enabling students to gain some basic familiarity with reproducible research environments as they learn about metagenome analysis.

# Experience of use

This course material was first delivered at The Gene School 2019, held at Kasetsart University, Bangkok, Thailand.
For that workshop, a budget from registration fees was used to spawn a fleet of virtual machines in the Amazon Web Services cloud, with one VM per student.
Each student received a unique URL at the start of the workshop to access the preconfigured Jupyter server on their own VM.
This approach worked very well, providing a stable and homogenous computing environment for the learning.
An interactive online discussion system was used during the workshop, and student questions posed in that system, and verbally, highlighted deficiencies in the first revision of the workshop material.
The material was delivered a second time at a workshop held at Western Sydney University, Sydney, Australia.
When combined with lecture material, this module requires approximately 6 hours to deliver.

# Acknowledgements

This work was funded in part via the Australian Research Council’s Discovery scheme, under ARC Discovery project DP180101506.
We thank Passorn Wonnapinij, Arinthip Thamchaipenet, Alexie Papanicolaou, Thomas Jeffries, and Kay Anantanawat for their roles in organizing the workshop at which this material was first delivered. 
That workshop was supported in part by the Australian Academy of Sciences and the Genetics Society of Thailand.

# References
