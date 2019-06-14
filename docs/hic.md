# Metagenomic HiC

## What is Metagenomic HiC?

As the name suggest, Metagenomic Hi-C incorporates a new form of sequencing datas, named Hi-C, in to traditional shotgun metagenomes. In doing so, modern analyses, such as genome binning, can be performed accurately and precisely using only a single time-point.

The Hi-C protocol was designed to capture genome-wide evidence of DNA molecules in close physical proximity _in vivo_, prior to cellular lysis. With the flexible nature of a chromosome and its capacity to bend back on itself, the most frequently captured interactions are usually those between loci on the same chromosome. After this, the most frequently observed interactions are inter-chromosomal. Lastly come inter-cellular interactions, which are often far below the rates of those found within a cell.

The original purpose of Hi-C was to study the 3-dimensional conformation of the human genome (Lieberman-Aiden 2009), but the proximity information can just as well be exploited to infer which DNA assembly fragments belong together in a bin.  Depending on the subject of study, the implied precision of "together" can range from a genome to chromosome. For metagenomic studies, methods currently aim to associate assembly fragments believed to come from the same genome.

## The Hi-C library protocol

Hi-C data-sets are generated using conventional Illumina paired-end sequencing;  the difference lies in the library protocol. 

### Protcol outline

1. **DNA Fixation:** Beginning with intact cells, the first step of the Hi-C protocol is formalin fixation. The act of cross-linking freezes close-by conformation arrangements within the DNA that existed in the cells at the time of fixation.

2. **Cell Lysis:** The cells are lysed and DNA-protein complexes extracted and purified.

3. **Restriction Digest:** The DNA is digested using a restriction endonuclease. In metagenomic Hi-C, enzymes with large overhangs and 4-nt recognition sites are common choices (i.e. Sau3AI, MluCI, DpnII). Differences in the GC bias of the recognition site and the target DNA is an important factor, as inefficient digestion will produce fewer Hi-C read-pairs.

4. **Biotin Tagging:** The overhangs produced during digestion are end-filled with biotinylated nucleotides.

5. **Free-end Ligation:** in dilute conditions or immobilised on a substrate, free-ends protruding from the DNA-protein complexes are ligated. This stochastic process favours any two ends which were nearby within the complex, however random ligation and self-ligation can occur and are non-informative.

6. **Crosslink Reversal:** The formalin fixation is reversed, allowing the now free DNA to be purified.

7. **Un-ligated End Clean-up:** Free-ends which failed to form ligation products are unwanted in subsequent steps but could still be biotin tagged. To minimise their inclusion, a light exonuclease 3' to 5' favoured chew-back can be applied.

8. **DNA Sheering:** With ligation completed, the DNA is mechanically sheered and the size range of the resulting fragment selected suitability with Illumina paired-end sequencing. 

9. **DNA repair:** Sonication can lead to damaged ends and nicks, which can be repaired.

10. **Proximity Ligation Enrichment:** Biotin tagged fragments are pulled down using affinity purification. 

11. **Adpater Ligation:** Illumina paired-end adapter ligation and associated steps to produce a sequencing library are now applied.


![hic protocol steps](img/hi-c_steps.png)


## QC: is my library ok?


## Metagenome binning with HiC data
