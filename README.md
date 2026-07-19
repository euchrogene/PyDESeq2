# PyDESeq2 Differential Expression Analysis

*EuchroGene PyDESeq2 v5.0 — for EuchroGene members.*

Differential gene expression analysis with [PyDESeq2](https://doi.org/10.1093/bioinformatics/btad547), the Python re-implementation of [DESeq2](https://doi.org/10.1186/s13059-014-0550-8). A negative-binomial GLM is fit per gene with empirical-Bayes dispersion shrinkage, and effect sizes are shrunk with apeGLM so the gene ranking is driven by evidence rather than by low-count noise. Both the **Wald test** and the **likelihood ratio test** are available, so multi-level factors, time courses and interaction designs are handled properly rather than as a series of pairwise comparisons.

Counts come straight from the EuchroGene STAR-RSEM or Salmon pipelines; the VST matrix it writes is the expected input for the EuchroGene WGCNA pipeline.

---

## Installation

### 0. Install EG_tools &nbsp; *(skip if already installed)*
```
wget https://github.com/euchrogene/EG_tools/raw/refs/heads/main/EG_tools
sudo chmod 777 EG_tools
sudo mv EG_tools /usr/bin
```

### 1. Install
```
sudo EG_tools install -r https://github.com/euchrogene/PyDESeq2.git -d PyDESeq2 -e PyDESeq2_v.5.0 -m "Differential gene expression analysis with PyDESeq2"
```

### 2. Display installed software
```
EG_tools
```

### 3. Show help contents
```
PyDESeq2_v.5.0
```

### 4. Generate experimental design templates
```
PyDESeq2_v.5.0 -template Template_Example_Folder
```

### 5. Uninstall
```
sudo EG_tools uninstall -t PyDESeq2_v.5.0 -i managene7/pydeseq2:v.2.0
```

Docker image: `managene7/pydeseq2:v.2.0`

---

## Quick Start

```bash
# Two-condition comparison
PyDESeq2_v.5.0 -exp_design_csv design.csv -count_table counts.csv \
    -exp_name stress_response -reference_level control

# Not sure how to write the design file? Generate templates from your counts
PyDESeq2_v.5.0 -template design_templates -count_table counts.csv

# Multi-factor design: control for batch, test the condition
PyDESeq2_v.5.0 -exp_design_csv design.csv -count_table counts.csv \
    -design_factors "batch,condition" -contrast "condition,treated,control"

# Time course: omnibus LRT plus every pairwise comparison in one run
PyDESeq2_v.5.0 -exp_design_csv design.csv -count_table counts.csv \
    -design_factors "batch,timepoint" -reference_level 0h \
    -test lrt -reduced_design "batch"
```

Run `PyDESeq2_v.5.0 -help` for the full option list.

---

## Inputs

| Input | Required | Notes |
|---|---|---|
| `-count_table` | yes | Raw integer counts, genes × samples. `<name>_gene_Count_all.csv` from the STAR-RSEM or Salmon pipeline drops straight in |
| `-exp_design_csv` | yes | One row per sample; first column is the sample ID, every other column is a factor. Sample IDs must match the count-table headers exactly |
| `-annotation` | no | `GeneID,Symbol,Description,...` — merged into every result table so DEG tables are supplementary-ready |

> Counts must be **raw counts**, not TPM or FPKM — the negative-binomial model needs the original count scale. Values that are not whole numbers trigger a warning. From tximport, use `lengthScaledTPM` gene counts.

> Design values are **category labels** (`control`, `treated`, `0h`, `B1`), never 0/1 indicators — that is a WGCNA trait file, not a DESeq2 design. `-template` writes five ready-to-edit examples plus a format guide.

---

## Outputs

```
<exp_name>_DEG_results/
├── 0_DESeq2_Analysis_Report.html    journal-format report, methods + figures inline
├── <exp_name>_DEGs.csv              genes passing the thresholds
├── <exp_name>_results_full.csv      full result table, unshrunken LFCs
├── <exp_name>_results_shrunk.csv    full result table, apeGLM-shrunken LFCs
├── <exp_name>_results_LRT.csv       likelihood ratio test results   [-test lrt]
├── <exp_name>_normalized_counts.csv median-of-ratios normalized counts
├── <exp_name>_vst_counts.csv        VST counts → WGCNA / clustering
├── <exp_name>_Supplementary_Tables.xlsx   submission-ready workbook, 7 sheets
├── Results_Summary.txt              key numbers and file inventory
├── run_manifest.json                every parameter, for reproducibility
├── deg_stats.json                   machine-readable run statistics + QC
├── per-contrast tables              [factor with 3+ levels]
│   ├── <exp_name>_contrast_summary.csv        DEG counts for every contrast
│   ├── <exp_name>_contrast_<A>_vs_<B>_results.csv / _DEGs.csv
│   └── <exp_name>_contrast_DEG_overlap.csv    pairwise DEG overlap
├── downstream hand-off
│   ├── <exp_name>_GSEA_ranking.rnk            ranked list for GSEA / fgsea
│   ├── <exp_name>_universe_genes.txt          background for GO/KEGG
│   ├── <exp_name>_DEG_up.txt / _DEG_down.txt  enrichment query sets
│   └── <exp_name>_PCA_scores.csv              PC coordinates
└── figures (300 DPI PNG + vector PDF)
    ├── <exp_name>_volcano_plot          ├── <exp_name>_dispersion_plot
    ├── <exp_name>_MA_plot               ├── <exp_name>_pvalue_histogram
    ├── <exp_name>_PCA_plot              ├── <exp_name>_sample_distance_heatmap
    ├── <exp_name>_PCA_scree             ├── <exp_name>_top30_DEGs_heatmap
    ├── <exp_name>_PCA_pairs             ├── <exp_name>_top_DEG_counts_panel
    ├── <exp_name>_PCA_by_<factor>       ├── <exp_name>_cooks_boxplot
    └── <exp_name>_contrast_summary
```

The whole folder is also zipped to `<exp_name>_DEG_results.zip`.

---

## Key Options

| Option | Default | Purpose |
|---|---|---|
| `-exp_name` | `Sample` | Label used for the output folder and every file name |
| `-design_factors` | `condition` | Comma-separated; the **last** one is the factor of interest, earlier ones are nuisance variables the model controls for |
| `-reference_level` | alphabetical | Baseline level of the primary factor, e.g. `control` |
| `-contrast` | auto | Explicit `factor,test_level,ref_level`; overrides `-reference_level` |
| `-test` | `wald` | `lrt` compares the full design against `-reduced_design` |
| `-reduced_design` | design minus primary factor | Factors kept in the LRT reduced model |
| `-log2fc` / `-padj` | `1.0` / `0.05` | DEG calling thresholds |
| `-alpha` | `0.05` | Target FDR for independent filtering |
| `-fit_type` | `parametric` | Dispersion trend: `parametric` or `mean` |
| `-shrinkage` | `true` | apeGLM LFC shrinkage |
| `-cooks_filter` / `-independent_filter` | `true` / `true` | Outlier and low-count filtering |
| `-min_replicates` | `3` | Group size from which a Cook's outlier is replaced and the gene refitted |
| `-min_count_sum` | `10` | Drop genes whose total count across all samples is below this |
| `-annotation` | — | Gene annotation table merged into the result tables |
| `-template` | — | Write design-file templates into a folder and exit |
| `-all_contrasts` | `auto` | Also report every remaining pairwise contrast of the primary factor; `auto` = when it has 3+ levels |
| `-top_n_genes` / `-label_top_n` | `30` / `15` | Genes in the heatmap / labelled on the volcano plot |
| `-counts_panel_n` | `12` | Genes in the per-group counts panel |
| `-threads` / `-max_mem` | `4` / `150` | CPU threads / memory budget in GB |
| `-cgroup_limits` | `auto` | `docker --memory` cap; `off` for nested Docker that refuses it |

---

## Notes

- **Wald or LRT?** Use the Wald test for one comparison between two groups — it answers "how big is the change, and is it real". Use `-test lrt` when the question is about a factor as a whole: a time course, a dose series, a genotype × treatment interaction. The LRT asks whether the full model explains a gene better than the reduced one, so no `|log2FC|` cutoff is applied; the reported fold change still describes the requested contrast, exactly as in DESeq2.
- **Three biological replicates per group is the practical minimum.** The replicate count per group goes into the methods text and the HTML report, because it is the first thing a reviewer asks. With fewer replicates than `-min_replicates`, Cook's outliers are flagged rather than refitted and those genes lose their p-value — the report says so explicitly when it happens.
- **The methods section is generated from the run, not from a template.** The contrast that was actually tested, the transformation that was actually applied, whether shrinkage really ran, and every tool version are queried at run time and written into the report. Copy it straight into a manuscript.
- **Every pairwise contrast comes for free.** A factor with *k* levels is fitted with *k*−1 coefficients, so the comparisons beyond the headline one cost a Wald test each and no refitting. With `-all_contrasts` (on by default for 3+ levels) a three-timepoint experiment yields 24h vs 0h, 72h vs 0h and 72h vs 24h in a single run, plus a DEG overlap matrix. LFC shrinkage is only defined against the model's reference level, so a pair like 72h vs 24h is reported with unshrunken effect sizes and labelled as such — in the summary table and in the report.
- **Use the right enrichment background.** `<exp_name>_universe_genes.txt` is the set of genes that actually survived filtering and were tested. Running GO or KEGG over-representation against the whole annotation instead inflates every p-value; the file exists so that mistake is harder to make.
- **`RuntimeWarning: overflow encountered in exp` during shrinkage is expected and harmless.** The apeGLM gradient evaluates `exp(-xbeta - offset)`, which overflows to `+inf` for genes whose fitted mean is essentially zero — the correct analytic limit, since the term it feeds goes to zero. PyDESeq2 bounds dispersions, so the `0 × inf` path that would produce `NaN` is unreachable, and shrinkage never touches p-values. The pipeline suppresses this one warning at the shrinkage call only; divide-by-zero and invalid-value warnings stay visible. What actually matters is reported instead: per-gene shrinkage convergence appears in the report's diagnostics table, and any non-converged genes are named in the methods text.
- **Check the p-value histogram before trusting anything else.** A flat distribution with a spike near zero is a well-behaved test. A hump in the middle or a rising right tail means the model is misspecified — usually a missing batch factor.
- **The VST is the real DESeq2 transformation**, computed in closed form from the fitted dispersion trend, not a `log2(x+1)` stand-in. That matters for PCA, clustering and heatmaps, where low-count genes otherwise dominate with pure shot noise.
- **Figures carry no in-figure titles.** Journals want the identifying information in the caption, not burned into the artwork, so every figure ships title-free and the HTML report's legend carries the factor, the thresholds and what the colours mean. Drop a PNG or PDF straight into a manuscript and write the legend from the report.
- Figures are written as 300 DPI PNG **and** vector PDF; the PDFs keep text editable (`pdf.fonttype 42`) for figure assembly in Illustrator or Inkscape.

---

## Citation

> Love MI, Huber W, Anders S (2014) Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. *Genome Biology* 15: 550.

> Muzellec B, Telenczuk M, Cabeli V, Andreux M (2023) PyDESeq2: a Python package for bulk RNA-seq differential expression analysis. *Bioinformatics* 39(9): btad547.

> Anders S, Huber W (2010) Differential expression analysis for sequence count data. *Genome Biology* 11: R106. — *variance-stabilizing transformation*

> Zhu A, Ibrahim JG, Love MI (2019) Heavy-tailed prior distributions for sequence count data. *Bioinformatics* 35(12): 2084–2092. — *apeGLM LFC shrinkage*

> Bourgon R, Gentleman R, Huber W (2010) Independent filtering increases detection power for high-throughput experiments. *PNAS* 107(21): 9546–9551.

> Benjamini Y, Hochberg Y (1995) Controlling the false discovery rate. *JRSS B* 57(1): 289–300.

> EuchroGene PyDESeq2 Pipeline v5.0 (2026). EuchroGene, LLC.

The methods section inside the HTML report is generated from the actual run settings and the tool versions queried at run time — copy it straight into a manuscript.

**Support:** bioinformatics@euchrogene.com
