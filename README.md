# This is for EuchroGene Members.

PyDESeq2 is a Python-based Differentially Expressed Gene analysis tool.

Two inputs are required.

1. A CSV file for experiment design.

2. A CSV file for gene expression counts.

A CSV (Comma-separated value) file can be generated in Microsoft Excel by saving the file as CSV (Comma-delimited) (*.csv).

You can use the gene expression counts generated from the RNA-seq_to_TPM_STAR or RNA-seq_to_TPM_Bowtie2 in this repository.

You can refer to the format of the experiment design file in this repository.

Outputs are DEGs, Volcano plot, MA plot, and PCA plot of samples.

## To install, copy and paste the following commands in a Jupyter Terminal, and execute:

0. Install EG_tools (*** If this is already installed, skip this step ***)
```
wget https://github.com/euchrogene/EG_tools/raw/refs/heads/main/EG_tools
sudo chmod 777 EG_tools
sudo mv EG_tools /usr/bin
```

1. install the software:
```
sudo EG_tools install -r https://github.com/euchrogene/PyDESeq2.git -d PyDESeq2 -e PyDESeq2_v.1.0 -m "PyDESeq2_v.1.0 => Analyze Differentially Expressed Genes (DEGs) using PyDESeq2."
```

2. display installed software
```
EG_tools
```

3. download example files (use the same format for your data)
```
wget https://github.com/euchrogene/PyDESeq2/raw/refs/heads/main/Example_Exp_design.csv  # This will download the experiment format file
wget https://github.com/euchrogene/PyDESeq2/raw/refs/heads/main/Example_Gene_Exp_Count.csv # this will download the gene expression count file
```

4. example run
```
PyDESeq2_v.1.0 -exp_design_csv Example_Exp_design.csv -count_table Example_Gene_Exp_Count.csv -exp_name test
```

5. show help contents
```
PyDESeq2_v.1.0
```

## Help contents:
```
________________________________________________________________________________________________

Used Tool: pydeseq2 (a python package) - Production Level

This is a software for DESeq2 analysis. It uses the PyDESeq2 Python package.
The results include DEGs, a Volcano plot, an MA plot, and a PCA plot of samples.

If you find any bugs, please email: bioinformatics@euchrogene.com
________________________________________________________________________________________________

Usage:

-help                show options
-exp_design_csv      (required) csv file name for experimental design
-count_table         (required) csv file name for gene expression count table
-exp_name            (option) name of experiment (default: 'Sample')
-log2fc              (option) threshold for log2fc (default: 1.0) 
-padj                (option) threshold for adjusted p-value (default: 0.05) 

Example:
    PyDESeq2 -exp_design_csv design.csv -count_table counts.csv \\
             -exp_name stress_response -log2fc 1.5 -padj 0.01
______________________________________________________________________________________________
```

6. Uninstall old version
```
sudo EG_tools uninstall -t PyDESeq2 -i managene7/rna-seq_to_tpm_deseq2:v.1.0
```
6. Uninstall v.1.0
```
sudo EG_tools uninstall -t PyDESeq2_v.1.0 -i managene7/rna-seq_to_tpm_deseq2:v.1.1
```


# Citation

## PyDESeq2
Boris Muzellec, Maria Teleńczuk, Vincent Cabeli, Mathieu Andreux, PyDESeq2: a python package for bulk RNA-seq differential expression analysis, Bioinformatics, Volume 39, Issue 9, September 2023, btad547, https://doi.org/10.1093/bioinformatics/btad547
