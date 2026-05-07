# This is for EuchroGene Members.

PyDESeq2 (EuchroGene PyDESeq2 v4.0)
Full-feature, journal-grade differential gene expression analysis built on PyDESeq2 (Muzellec et al. 2023), the Python re-implementation of DESeq2 (Love et al. 2014). The wrapper accepts a raw integer count matrix and a sample metadata table and runs the complete DESeq2 statistical workflow — size-factor estimation, dispersion shrinkage, GLM fitting, Wald testing, optional log2 fold-change shrinkage, Cook's outlier filtering, and independent filtering. Multi-factor designs and explicit Wald contrasts are exposed directly. Each run produces seven publication-quality figures (300 DPI PNG **and** vector PDF), a full results table plus a filtered DEG table, normalized and VST-transformed counts, an interactive HTML report with the journal-ready methods section inlined, and a complete `run_manifest.json` for reproducibility.

## How It Works:
1. **Input Validation:** Count matrix and design CSV are validated for format, sample-name agreement, and integer counts, then staged for containerized execution.
2. **Pre-filtering & Model Setup:** Genes with row-sum below `-min_count_sum` are removed. A negative-binomial GLM is built with the design formula `~ <design_factors>`; the reference level is set explicitly when `-reference_level` is provided.
3. **DESeq2 Workflow:** Size factors are estimated by median-of-ratios; gene-wise dispersions are obtained by Cox–Reid adjusted profile likelihood and shrunk toward a parametric (or mean) trend; the GLM is fit and the requested Wald contrast is tested. Cook's outlier filtering and independent filtering are applied per the user's flags.
4. **Effect-Size Shrinkage:** Optional apeGLM-style log2 fold-change shrinkage produces stabilized effect sizes for ranking and visualization.
5. **Figure & Table Generation:** PCA (with 95 % confidence ellipses grouped by the primary design factor), volcano plot with top-N gene labels, MA plot, dispersion-estimates plot, sample-distance heatmap, top-N DEG heatmap, and p-value histogram are rendered. Five tabular outputs (full results, shrunken results, filtered DEGs, normalized counts, VST counts) are written.
6. **Report Generation:** A self-contained interactive HTML report, a machine-readable `run_manifest.json`, a `deg_stats.json` summary, and a journal-ready methods section (inlined inside the HTML report) are produced automatically. A zip archive of the full results folder is also created.

## Required Inputs:
1. **Sample design CSV** (`-exp_design_csv`) — Sample metadata table where rows are samples and columns are experimental factors (e.g., `condition`, `batch`, `genotype`). The sample IDs must match the column names of the count table.
2. **Count table** (`-count_table`) — Raw **integer** count matrix where rows are genes (first column = gene IDs) and columns are samples. Output of featureCounts, HTSeq-count, STAR `--quantMode GeneCounts`, salmon → tximport, or equivalent.

## Post-Analysis:
- Open `DESeq2_Analysis_Report.html` for an interactive summary of DEG counts, run parameters, all seven figures inline, and the journal-ready methods section ready to paste into a manuscript.
- Use `<exp_name>_DEGs.csv` for downstream functional enrichment (GO, KEGG, Reactome, GSEA), and `<exp_name>_normalized_counts.csv` / `<exp_name>_vst_counts.csv` for single-gene follow-up or co-expression analysis.
- The `run_manifest.json` records the wrapper version, Docker image tag, run timestamp, and every parameter value — paste it into a manuscript supplement for full reproducibility.

---

## Installation

### 0. Install EG_tools &nbsp; *(skip if already installed)*
```
wget https://github.com/euchrogene/EG_tools/raw/refs/heads/main/EG_tools
sudo chmod 777 EG_tools
sudo mv EG_tools /usr/bin
```

### 1. Install PyDESeq2
```
sudo EG_tools install -r https://github.com/euchrogene/PyDESeq2.git -d PyDESeq2 -e PyDESeq2_v.4.0 -m "Full-feature differential gene expression analysis using PyDESeq2"
```

### 2. Display installed software
```
EG_tools
```

### 3. Show help contents
```
PyDESeq2_v.4.0
```

### 4. Uninstall
```
sudo EG_tools uninstall -t PyDESeq2_v.4.0 -i managene7/pydeseq2:v.1.0
```

---

## Help Contents:
```
This pipeline is provided by EuchroGene, LLC.
Bug reports: bioinformatics@euchrogene.com

============================================================================
EuchroGene PyDESeq2 Pipeline v4.0
Docker Image: managene7/pydeseq2:v.1.0
============================================================================

DESCRIPTION:
  Full-feature differential gene expression analysis built on PyDESeq2,
  the Python re-implementation of DESeq2. Runs the complete DESeq2
  statistical workflow with multi-factor designs, explicit Wald contrasts,
  and optional log2 fold-change shrinkage. Produces journal-grade figures
  (300 DPI PNG + vector PDF), full results tables, and a self-contained
  HTML report with an inlined journal-ready methods section.

USAGE:
  PyDESeq2_v.4.0 -exp_design_csv <design.csv> -count_table <counts.csv> [OPTIONS]

REQUIRED:
  -exp_design_csv <FILE>   Sample metadata CSV (rows = samples, cols = factors)
  -count_table    <FILE>   Raw integer count matrix (rows = genes, cols = samples)

EXPERIMENT:
  -exp_name       <STR>    Experiment label used in filenames and report
                           (default: Sample)

DESIGN / CONTRAST:
  -design_factors <STR>    Comma-separated factors. The LAST factor is the
                           primary factor of interest, matching the PyDESeq2
                           convention. e.g. "batch,condition"
                           (default: condition)
  -reference_level <STR>   Reference level for the primary factor.
                           e.g. "control"
                           (default: alphabetically first level)
  -contrast       <STR>    Explicit Wald contrast "factor,test_level,ref_level".
                           Overrides -reference_level when given.
                           e.g. "condition,treated,control"

STATISTICAL THRESHOLDS:
  -log2fc         <FLOAT>  |log2FC| cutoff for DEG calling     (default: 1.0)
  -padj           <FLOAT>  Adjusted p-value (FDR) cutoff       (default: 0.05)
  -alpha          <FLOAT>  Target FDR for independent filter   (default: 0.05)

MODEL / FILTERING:
  -fit_type       <STR>    Dispersion fit: parametric | mean   (default: parametric)
  -min_replicates <INT>    Cook's filter min replicates        (default: 7)
  -cooks_filter   <BOOL>   Apply Cook's outlier filter         (default: true)
  -independent_filter <BOOL>  Apply independent filtering       (default: true)
  -shrinkage      <BOOL>   Apply LFC shrinkage to results      (default: true)
  -min_count_sum  <INT>    Pre-filter genes with row-sum < N   (default: 10)

REPORTING:
  -top_n_genes    <INT>    Top-N DEGs for heatmap              (default: 30)
  -label_top_n    <INT>    Top-N gene labels on volcano plot   (default: 15)

MISC:
  -threads        <INT>    Threads passed to PyDESeq2          (default: 4)
  -random_seed    <INT>    Random seed                         (default: 42)

EXAMPLES:

  # Minimal two-condition contrast
  PyDESeq2_v.4.0 -exp_design_csv design.csv -count_table counts.csv \
                 -exp_name stress_response

  # Multi-factor design with explicit contrast and tighter thresholds
  PyDESeq2_v.4.0 -exp_design_csv design.csv -count_table counts.csv \
                 -exp_name treated_vs_ctrl \
                 -design_factors "batch,condition" \
                 -reference_level "condition,control" \
                 -contrast "condition,treated,control" \
                 -log2fc 1.5 -padj 0.01

  # Disable shrinkage and use the mean-dispersion trend
  PyDESeq2_v.4.0 -exp_design_csv design.csv -count_table counts.csv \
                 -exp_name pilot_run \
                 -shrinkage false -fit_type mean

OUTPUT FILES:

  <exp_name>_DEG_results/
  ├── <exp_name>_results_full.csv             Complete DESeq2 results (all genes)
  ├── <exp_name>_results_shrunk.csv           LFC-shrunken results (all genes)
  ├── <exp_name>_DEGs.csv                     Filtered DEGs (|log2FC|, padj cutoffs)
  ├── <exp_name>_normalized_counts.csv        Median-of-ratios normalized counts
  ├── <exp_name>_vst_counts.csv               Variance-stabilizing-transformed counts
  ├── <exp_name>_PCA_plot.png|pdf             PCA — clusters with 95% confidence ellipses
  ├── <exp_name>_volcano_plot.png|pdf         Volcano with top-N gene labels
  ├── <exp_name>_MA_plot.png|pdf              MA plot (mean expression vs. log2FC)
  ├── <exp_name>_dispersion_plot.png|pdf      Dispersion estimates and fitted trend
  ├── <exp_name>_sample_distance_heatmap.png|pdf   Sample-to-sample distance heatmap
  ├── <exp_name>_top<N>_DEGs_heatmap.png|pdf  Top-N DEGs z-scored expression heatmap
  ├── <exp_name>_pvalue_histogram.png|pdf     P-value distribution diagnostic
  ├── DESeq2_Analysis_Report.html             Self-contained HTML report (methods inlined)
  ├── Results_Summary.txt                     Human-readable summary
  ├── run_manifest.json                       Full parameter record (reproducibility)
  └── deg_stats.json                          Programmatic DEG counts

  A zip archive (<exp_name>_DEG_results.zip) is also created next to the folder.

SUPPORT:
  Bugs / Questions: bioinformatics@euchrogene.com

============================================================================
```


6. Uninstall old version
```
sudo EG_tools uninstall -t PyDESeq2 -i managene7/rna-seq_to_tpm_deseq2:v.1.0
```
6. Uninstall v.1.0
```
sudo EG_tools uninstall -t PyDESeq2_v.1.0 -i managene7/rna-seq_to_tpm_deseq2:v.1.1
```
6. Uninstall v.4.0
```
sudo EG_tools uninstall -t PyDESeq2_v.4.0 -i managene7/pydeseq2:v.1.0
```
---

## Citation

If you use this pipeline in published research, please cite:

> Love MI, Huber W, Anders S (2014) Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. *Genome Biology* 15: 550. https://doi.org/10.1186/s13059-014-0550-8

> Muzellec B, Telenczuk M, Cabeli V, Andreux M (2023) PyDESeq2: a Python package for bulk RNA-seq differential expression analysis. *Bioinformatics* 39(9): btad547. https://doi.org/10.1093/bioinformatics/btad547

> Benjamini Y, Hochberg Y (1995) Controlling the false discovery rate: a practical and powerful approach to multiple testing. *Journal of the Royal Statistical Society B* 57(1): 289–300.

> EuchroGene PyDESeq2 v4.0 (2026). EuchroGene, LLC. bioinformatics@euchrogene.com

The journal-ready methods section is inlined inside `DESeq2_Analysis_Report.html` and is parameterized on the actual run settings (design formula, contrast, shrinkage state, alpha, filtering flags), so the text reflects exactly what was run — copy directly from the rendered report into your manuscript.
