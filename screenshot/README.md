
## Step-by-Step Galaxy Workflow

This section describes the bioinformatics procedures used to obtain genomic data, perform read alignment, and calculate chromosome coverage for *Bombyx mori* (Domestic silkworm) using WGS data.

### 1. Reference Genome and Data Collection
- Retrieved the reference genome FASTA file and assembly information for *Bombyx mori* using Assembly accession `GCF_030269925.1` (ASM3026992v2).
- Created a separate Galaxy history named `Sex-Dosage-Bombyx-mori` to organize the analysis.
- Imported the whole-genome sequencing (WGS) dataset with accession `DRR031193` into Galaxy using the SRA import tool.

### 2. Read Quality Assessment and Mapping
- Used **FastQC** to examine the quality of the downloaded sequencing reads and identify possible quality issues.
- Performed read alignment using **BWA-MEM**, mapping the WGS reads to the selected *Bombyx mori* reference genome.

### 3. Alignment Processing
- Processed the alignment output to generate a coordinate-sorted BAM file.
- Created a BAM index to allow efficient access to the aligned sequencing reads during coverage analysis.

### 4. Chromosome Coverage Analysis
- Applied the **Samtools coverage** tool to the sorted and indexed BAM file to measure sequencing coverage across the reference sequences.
- Used minimum mapping quality and minimum base quality settings of 20 to retain more reliable alignment and base-quality information.
- Selected tabular output and saved the resulting coverage statistics as `chromosome_coverage.tsv` for further analysis in RStudio.

### Galaxy Workflow

The Galaxy history containing the genomic data processing and coverage analysis is available here:

**[Open Bombyx mori Galaxy Workflow](https://usegalaxy.org/u/ella_cadungog/h/sex-dosage-bombyx-mori)**
