# This is for EuchroGene customers.

## To install:

1. get the installation file:
```
wget https://github.com/euchrogene/PyDESeq2/raw/refs/heads/main/Install_PyDESeq2.sh
```

2. install the pipeline:
```
sudo bash Install_PyDESeq2.sh
```

3. check installation
```
pipelines # This shows installed pipelines
```

4. download example files (use the same format for your data)
```
wget https://github.com/euchrogene/PyDESeq2/raw/refs/heads/main/Example_Exp_design.csv  # This will download the experiment format file
wget https://github.com/euchrogene/PyDESeq2/raw/refs/heads/main/Example_Gene_Exp_Count.csv # this will download the gene expression count file
```

5. example run
```
PyDESeq2 -exp_design_csv Example_Exp_design.csv -count_table Example_Gene_Exp_Count.csv -exp_name test
```

6. show help content
```
PyDESeq2 # this will show the following help contents
```




## Help contents:
```
________________________________________________________________________________________________

Used Tool: pydeseq2 (a Python package)

This is a software for DESeq2 analysis. It uses the PyDESeq2 Python package.
The results include DEGs, a Volcano plot, an MA plot, and a PCA plot of samples.

The gene counter table can be generated with the following pipeline:
https://github.com/euchrogene/AdapterRemoval_bowtie2_RSEM

If you find any bugs, please email: bioinformatics@euchrogene.com

________________________________________________________________________________________________

You can run this software by modifying this example:

PyDESeq2 -exp_design_csv exp_design_file.csv -count_table gene_count_number.csv \\
         -exp_name stress_response -log2fc 1 -padj 0.05
________________________________________________________________________________________________

Usage;

-help                       show options
-exp_design_csv (required)  csv file name for experimental design
-count_table    (required)  csv file name for gene expression count table
-exp_name       (option)    name of experiment (default is 'Sample'. Will be used for name in the figures)
-log2fc         (option)    threshold for log2fc (default is 1) 
-padj           (option)    threshold for adjusted p-value (default is 0.05) 
______________________________________________________________________________________________
```


# Citation

## PyDESeq2
Boris Muzellec, Maria Teleńczuk, Vincent Cabeli, Mathieu Andreux, PyDESeq2: a python package for bulk RNA-seq differential expression analysis, Bioinformatics, Volume 39, Issue 9, September 2023, btad547, https://doi.org/10.1093/bioinformatics/btad547
