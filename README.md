# Shotgun Metagenomics Nextflow Pipeline

A reproducible **shotgun metagenomics analysis pipeline** implemented using **Nextflow DSL2**, designed to process paired-end metagenomic sequencing data from raw FASTQ files through quality control, taxonomic profiling, functional profiling, downstream analysis, and automated reporting.

> **Status:** Pipeline under development. The README will be updated as additional analysis modules and final reporting components are completed.

---

## Overview

Shotgun metagenomics sequences the genetic material present in a biological or environmental sample without targeting a single marker gene.

Unlike 16S rRNA amplicon sequencing, which primarily profiles bacterial community composition using a specific marker region, shotgun metagenomics can provide information about:

* Microbial community composition
* Bacteria, archaea, fungi, viruses, and other organisms
* Genes present in the community
* Metabolic pathways
* Functional potential
* Antibiotic resistance and other genomic features, when appropriate databases and analyses are included

This pipeline is designed to provide both **taxonomic** and **functional** characterization of shotgun metagenomic samples.

---

# Pipeline Objective

The primary objective of this pipeline is to process shotgun metagenomic sequencing data and characterize:

### 1. Taxonomy

**Who is present in the sample?**

Taxonomic profiling is performed using:

```text
Kraken2
   ↓
Bracken
```

Kraken2 provides read-level taxonomic classification, while Bracken estimates more accurate abundance at selected taxonomic levels.

### 2. Functional potential

**What are the microbial communities potentially doing?**

Functional profiling is performed using:

```text
HUMAnN3
```

HUMAnN identifies microbial genes and metabolic pathways represented in the metagenomic data.

### 3. Downstream analysis

Taxonomic and functional results are subsequently prepared for downstream analysis and visualization using R/Python and an automated reporting workflow.

---

# Workflow

The current workflow is structured as:

```text
                  SHOTGUN METAGENOMICS
                           │
                           ▼
                 Raw paired-end FASTQ
                           │
                           ▼
                         FastQC
                           │
                           ▼
                         fastp
                           │
                           ▼
                    FastQC (Post-QC)
                           │
                           ▼
                ┌─────────────────────┐
                │ Taxonomic Profiling │
                └──────────┬──────────┘
                           │
                           ▼
                        Kraken2
                           │
                           ▼
                        Bracken
                           │
                           ▼
                  Taxonomic abundance
                           │
                           ▼
                ┌─────────────────────┐
                │ Functional Profiling│
                └──────────┬──────────┘
                           │
                           ▼
                         HUMAnN3
                           │
                           ▼
                    Genes / Pathways
                           │
                           ▼
                 Downstream Analysis
                       R / Python
                           │
                           ▼
                    Visualization
                           │
                           ▼
                  Automated R Markdown
                       Final Report
```

---

# Quality Control

The pipeline begins with raw paired-end sequencing reads.

## FastQC — Initial Quality Control

FastQC is used to inspect the quality of the raw sequencing reads.

The initial QC can be used to evaluate:

* Per-base sequence quality
* Per-sequence quality
* Sequence length distribution
* Adapter contamination
* Overrepresented sequences
* GC content
* Other sequencing-quality characteristics

---

## fastp — Read Preprocessing

`fastp` is used to process the raw paired-end reads.

Typical preprocessing includes:

* Adapter removal
* Quality filtering
* Low-quality read removal
* Read trimming
* Paired-end processing

The processed reads are then used for downstream metagenomic profiling.

---

## FastQC — Post-processing QC

FastQC is run again after `fastp`.

This allows the quality of the processed reads to be compared with the original sequencing data.

```text
Raw FASTQ
    ↓
FastQC
    ↓
fastp
    ↓
Clean FASTQ
    ↓
FastQC
```

This two-stage QC approach helps verify that preprocessing improved or maintained read quality before downstream analysis.

---

# Taxonomic Profiling

## Kraken2

Kraken2 is used for taxonomic classification of metagenomic sequencing reads.

The purpose of this stage is to determine:

> **Which organisms are represented in the sample?**

Kraken2 uses a reference database to classify reads based on sequence information.

The output can contain taxonomic assignments at different levels, including:

```text
Kingdom
Phylum
Class
Order
Family
Genus
Species
```

The quality and biological interpretation of the results depend on the reference database used.

---

# Bracken

Bracken is used after Kraken2 to estimate taxonomic abundances from Kraken2 classification results.

The workflow is:

```text
Clean FASTQ
     ↓
  Kraken2
     ↓
Classification
     ↓
  Bracken
     ↓
Abundance estimation
```

Bracken can generate abundance estimates at selected taxonomic levels, such as:

* Species
* Genus
* Family
* Order
* Class
* Phylum

These abundance tables can subsequently be used for visualization and comparative analysis.

---

# Functional Profiling

## HUMAnN3

HUMAnN3 is used to characterize the functional potential of the microbial community.

The main question at this stage is:

> **What are the microorganisms potentially doing?**

HUMAnN can generate information about:

* Gene families
* Metabolic pathways
* Pathway abundance
* Pathway coverage

Conceptually:

```text
Clean metagenomic reads
          ↓
        HUMAnN3
          ↓
   ┌──────┴──────┐
   ▼             ▼
Gene families   Pathways
   │             │
   └──────┬──────┘
          ▼
 Functional analysis
```

The resulting functional profiles can be used for downstream comparison and visualization.

---

# MetaPhlAn4

MetaPhlAn4 is included as an additional taxonomic profiling approach.

MetaPhlAn uses marker genes to estimate the relative abundance of microbial taxa.

It can provide a complementary taxonomic profile alongside the Kraken2/Bracken workflow.

Conceptually:

```text
Clean FASTQ
     │
     ├──────────────► Kraken2 → Bracken
     │
     └──────────────► MetaPhlAn4
```

The final pipeline documentation will specify how MetaPhlAn4 results are used relative to Kraken2/Bracken once the complete workflow is finalized.

---

# Downstream Analysis

After taxonomic and functional profiling, the generated tables can be analyzed using R and/or Python.

Potential downstream analyses include:

### Taxonomic analysis

* Relative abundance
* Taxonomic composition
* Genus-level profiles
* Species-level profiles
* Community comparisons

### Functional analysis

* Gene-family abundance
* Pathway abundance
* Pathway coverage
* Functional comparisons

### Visualization

Possible visualizations include:

* Stacked bar plots
* Heatmaps
* Abundance plots
* Taxonomic composition plots
* Functional pathway plots
* Ordination plots where appropriate

Statistical analyses should be selected according to the number of biological replicates, metadata structure, and experimental design.

---

# Automated Reporting

The pipeline is being developed to generate an automated final report using R Markdown.

The final report is intended to integrate:

```text
Quality Control
      ↓
Taxonomic Profiling
      ↓
Functional Profiling
      ↓
Downstream Analysis
      ↓
Visualization
      ↓
Final R Markdown Report
```

The report will provide a consolidated view of the major pipeline results.

---

# Nextflow Architecture

The pipeline uses **Nextflow DSL2** to organize the analysis into modular processes.

The project structure is designed so that individual tools can be maintained as separate modules while being connected through the main workflow.

Current modules include:

```text
modules/
├── 01_kraken2.nf
├── 02_bracken.nf
├── 03_metaphlan.nf
└── 04_humann.nf
```

Additional modules may be added as the pipeline develops.

---

# Repository Structure

The repository follows a structure similar to:

```text
Shotgun-Metagenomics-Nextflow-Pipeline/
│
├── main.nf
├── nextflow.config
│
├── modules/
│   ├── 01_kraken2.nf
│   ├── 02_bracken.nf
│   ├── 03_metaphlan.nf
│   └── 04_humann.nf
│
├── templates/
│   └── ...
│
└── .gitignore
```

Large sequencing datasets, generated results, Nextflow work directories, databases, and container images should not be committed to the GitHub repository.

---

# Input Data

The pipeline is designed for paired-end shotgun metagenomic FASTQ files.

Example:

```text
sample1_1.fastq.gz
sample1_2.fastq.gz

sample2_1.fastq.gz
sample2_2.fastq.gz
```

The input directory and other pipeline parameters are configured through:

```text
nextflow.config
```

---

# Running the Pipeline

Clone the repository:

```bash
git clone https://github.com/livolo/Shotgun-Metagenomics-Nextflow-Pipeline.git
cd Shotgun-Metagenomics-Nextflow-Pipeline
```

Configure the required parameters in:

```text
nextflow.config
```

Run using Singularity:

```bash
nextflow run main.nf -profile singularity
```

For a previously started workflow:

```bash
nextflow run main.nf -profile singularity -resume
```

---

# Software

The pipeline currently uses or is being developed around:

| Tool                  | Purpose                          |
| --------------------- | -------------------------------- |
| Nextflow              | Workflow management              |
| FastQC                | Sequencing QC                    |
| fastp                 | Read preprocessing               |
| Kraken2               | Taxonomic classification         |
| Bracken               | Taxonomic abundance estimation   |
| MetaPhlAn4            | Marker-based taxonomic profiling |
| HUMAnN3               | Functional profiling             |
| R                     | Downstream analysis              |
| Python                | Supporting analysis              |
| R Markdown            | Automated reporting              |
| Singularity/Apptainer | Containerized execution          |

Tool versions and database versions should be recorded in the final pipeline configuration when the workflow is completed.

---

# Reproducibility

Nextflow provides several features that support reproducible analysis:

* Modular workflow design
* Process-level execution
* Automatic process caching
* `-resume` support
* Containerized software environments
* Configurable parameters
* Organized output directories

The use of containers also helps maintain consistent software environments across systems.

---

# Current Pipeline Status

The shotgun workflow is currently under development.

### Completed / implemented stages

```text
FastQC
   ↓
fastp
   ↓
FastQC
   ↓
Kraken2
   ↓
Bracken
```

### Current / planned stages

```text
MetaPhlAn4
   ↓
HUMAnN3
   ↓
Downstream R/Python analysis
   ↓
Visualization
   ↓
Final R Markdown report
```

The README will be updated as these stages are completed and validated.

---

# Important Interpretation Notes

Shotgun metagenomics provides substantially more sequence information than targeted 16S sequencing, but results depend on:

* Sequencing depth
* Read quality
* Host DNA contamination
* Reference database quality
* Database completeness
* Taxonomic classifier
* Functional reference databases
* Experimental design

High host-DNA content can reduce the fraction of reads available for microbial analysis. Such reads should therefore be considered during QC and downstream interpretation.

Statistical group comparisons should only be performed when the available biological replicates and experimental design support them.

---

# Advanced Analysis

The main pipeline focuses on:

```text
QC
 ↓
Taxonomy
 ↓
Function
 ↓
Downstream analysis
```

Assembly-based analyses such as:

```text
MEGAHIT
   ↓
Metagenome assembly
   ↓
MetaBAT2
   ↓
MAG binning
   ↓
CheckM2
   ↓
MAG quality assessment
   ↓
GTDB-Tk
   ↓
MAG taxonomy
```

can be considered as an advanced or separate branch of the workflow rather than being assumed to be part of the primary profiling pipeline.

---

# Final Objective

The overall goal of the shotgun metagenomics pipeline is to transform raw paired-end sequencing reads into interpretable information about:

```text
                    Shotgun Reads
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
         Taxonomic Profile     Functional Profile
              │                     │
              ▼                     ▼
        Who is present?       What can they do?
              │                     │
              └──────────┬──────────┘
                         ▼
                  Downstream Analysis
                         │
                         ▼
                   Visualization
                         │
                         ▼
                  Final R Markdown
                      Report
```

This provides a reproducible framework for microbial community and functional characterization from shotgun metagenomic sequencing data.

---

# Author

**Kirti Vishwakarma**

GitHub:

`https://github.com/livolo`

---

# License

This project is intended for research and educational use.

A formal open-source license can be added according to the intended distribution and usage of the repository.
