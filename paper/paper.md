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
This short manuscript describes open source educational resource for teaching applied metagenomic data analysis.
The material assumes that trainees have a basic knowledge of metagenomics and computing, or that such knowledge is supplied separately via lecture material.
Text documents provided herein are licensed as CC-BY and all software used is available under an OSI-approved license.

# Statement of need
<!-- Include a “Statement of Need” section, explaining how the submitted artifacts contribute to computationally enabled teaching and learning, and describing how they might be adopted by others. -->


# Learning objectives

- Install software via conda
- Run containerized software via docker and singularity
- Carry out QC for metagenome data samples
- Understand limitations of reference databases for metagenome analysis
- Learn experimental design via pilot studies
  - Learn how to estimate sequencing depth requirements
  - How do host-associated samples affect sequencing depth requirements
  - Designs that maximize experimental interpretation via genome-centric metagenomics
    - Time-series
    - Spatial or population transects

- Learn how to assemble metagenomes
  - megahit
  - assemble per host

- Binning genomes from metagenomes

- Visualization of bins and bin refinement

- Using Hi-C for genome binning


# Content

- A collection of markdown-formatted workshop pages
- Publicly available data sets
- A VM image preloaded with data & results so compute-intensive steps can be skipped during delivery

# Instructional design

- Hybrid lecture & active learning
  - Designed to be delivered alongside lecture material introducing microbial communities, their genetics, and metagenome sequencing
  - Active learning material designed for use in Jupyter

# Experience of use

Delivered at The Gene School 2019 workshop, Kasetsart University.


# The story behind the project

Once upon a time there were two lovebirds.


# Acknowledgements

This work was funded in part via the Australian Research Council’s Discovery scheme, under ARC Discovery project DP180101506.
We thank Passorn Wonnapinij, Arinthip Thamchaipenet, Alexie Papanicolaou, Thomas Jeffries, and Kay Anantanawat for their roles in organizing the workshop at which this material was first delivered. 
That workshop was supported in part by the Australian Academy of Sciences and the Genetics Society of Thailand...

# References
