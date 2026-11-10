
# Sex-Chromosome Dosage in a Selected Animal Nuclear Genome Using NCBI, Galaxy, and R

## Selected Species & Study Question

- **Species**: *Bombyx mori* (Domestic silkworm)
- **Study Question**: Can whole-genome sequencing (WGS) read-depth mapping determine the chromosomal sex of *Bombyx mori* by calculating the normalized Z-to-autosome depth ratio?
- **Sex-Chromosome System**: ZZ/ZW, where males are ZZ and females are ZW.

## Accession ID

- **Reference Assembly Accession**: GCF_030269925.1
- **Assembly Name**: ASM3026992v2
- **Assembly BioSample Accession**: SAMD00586865
- **WGS Run Accession**: DRR031193
- **WGS BioSample Accession**: SAMD00026414

The reference assembly and WGS run have different BioSample accessions. Therefore, they are not confirmed to represent the same individual. This is an important limitation when interpreting the results.

## Chromosome Groups & Selection (`chromosome__group.csv`)

- **Autosomes (Group A)**: The numbered nuclear chromosome sequences NC_085107.1 through NC_085133.1 were assigned as autosomes for the analysis.
- **Z Chromosome (Group Z)**: NC_085134.1 was provisionally designated as the Z chromosome to evaluate Z-linked dosage relative to autosomal depth.
- **W Chromosome (Group W)**: NC_085135.1 was included as a candidate W sequence to examine possible W-linked read coverage.
- **Exclusions**: Mitochondrial DNA (NC_002355.1) was excluded because it is not a nuclear chromosome. Unplaced scaffolds and alternate sequences were also excluded.

**Note:** The Z and W sequence assignments must be verified using the official NCBI assembly report and chromosome annotations before making a final biological interpretation.

## Questions for the Report

### 1. What species did you choose, and what evidence supports a diploid XX/XY or ZZ/ZW system?

**Answer:** *Bombyx mori* (domestic silkworm) was selected. It follows a female-heterogametic ZZ/ZW sex-determination system, in which males have two Z chromosomes (ZZ), while females have one Z and one W chromosome (ZW). This makes it suitable for investigating sex-chromosome dosage through normalized sequencing read depth.

### 2. What are your assembly accession, WGS run, and both BioSample accessions? Are the donors the same?

**Answer:** The reference assembly used was GCF_030269925.1 (ASM3026992v2), with assembly BioSample SAMD00586865. The WGS run selected was DRR031193, with WGS BioSample SAMD00026414. Since the two BioSample accessions are different, the assembly and WGS data are not confirmed to originate from the same individual. This is an important limitation when interpreting the results.

### 3. Which sequences were used as autosomes and as X or Z? How did you verify their identities?

**Answer:** The numbered nuclear sequences NC_085107.1 through NC_085133.1 were assigned as autosomes. NC_085134.1 was provisionally assigned as the Z chromosome, while NC_085135.1 was included as a candidate W chromosome. Their identities should be verified using the NCBI RefSeq assembly report and chromosome annotations before making a final interpretation. Mitochondrial DNA and unplaced sequences were excluded.

### 4. What are the median autosomal depth, X:A or Z:A ratio, and inferred sex-chromosome complement?

**Answer:** The median autosomal depth, Z:A ratio, and inferred sex-chromosome complement will be obtained from the R analysis using the Galaxy Samtools coverage results.

- **Median autosomal depth**: 53.9475
- **Z:A ratio**: 0.941
- **Inferred sex-chromosome complement**: Consistent with two Z chromosomes (ZZ-like).

A ratio closer to 1.0 is consistent with two Z copies (ZZ-like), while a ratio closer to 0.5 is consistent with one Z copy (ZW-like), assuming the chromosome assignments and mapping are correct.

### 5. Does your result agree with the recorded sex of the WGS donor, if reported? Explain any discrepancy or uncertainty.

**Answer:** The read-depth result should be compared with the recorded sex of the WGS BioSample. However, the assembly and WGS data have different BioSample accessions, so they are not confirmed to come from the same individual. This limits the reliability of directly comparing the sequencing result with the reference assembly. Mapping bias, repetitive sequences, and differences in sequencing coverage may also affect the calculated ratio.

### 6. Why is a chromosome-level assembly alone insufficient for a reliable read-depth sex inference?

**Answer:** A chromosome-level genome assembly provides the reference DNA sequences and their organization, but it does not provide the actual sequencing read depth of an individual sample. WGS reads must first be mapped to the reference genome using Galaxy, followed by coverage calculation using Samtools. The resulting coverage data are then analyzed in R to estimate the relative dosage of the Z chromosome compared with the autosomes.

## References & Resources

- **NCBI Genome Reference**: [Bombyx mori Assembly GCF_030269925.1](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_030269925.1/)
- **NCBI WGS Run**: [DRR031193 SRA Entry](https://www.ncbi.nlm.nih.gov/sra/DRR031193)
- **NCBI Assembly BioSample**: [SAMD00586865](https://www.ncbi.nlm.nih.gov/biosample/SAMD00586865)
- **NCBI WGS BioSample**: [SAMD00026414](https://www.ncbi.nlm.nih.gov/biosample/SAMD00026414)
- **Galaxy Platform**: [UseGalaxy.org](https://usegalaxy.org/)
- **GitHub Repository**: [CellMol Sex-Chromosome Dosage – Bombyx mori](https://github.com/EllaCadungog/CellMol_SexChrom_Bombyx_mori)
