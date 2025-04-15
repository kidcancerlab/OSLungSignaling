# Suggested Best Practices

## How to use this template
You can copy the entire directory into a new project folder. Rename the parent qmd file and update the author and title in the yaml header.

Identify the samples you want to use in sc_sequencing_log.xlsx and copy/paste those rows along with the header into misc/sample_metadata.tsv. If your samples have more than one species in them, you can make Seurat objects for them the way I do in this template. If you only have one species, you can remove the `species_pattern` and `organism` arguments from the `read_raw()` function.

You will want to check figures/pre_filter_hist_{sample_names}.pdf to make sure the filtering is approprate and update the subset_nCount_RNA_min, etc... columns in misc/sample_metadata.tsv as needed.

## Plots

### Save plot objects using qs
This will allow for minor edits to the figure later on

### Save plots to disk as pdfs
This allows for easy editing in illustrator or other programs

### Save to sub-folders if needed
If you have a lot of figures from a particular analysis, make a subfolder within output/figures/ to save them. For instance, if you have a GSEA analysis, you could save the figures in output/figures/gsea/.

## Use `cache.vars = ""` in the yaml header
This will mean that your variables will only be available locally within each chunk. This will reduce overall memory usage and will also prevent variables made in other chunks from being used in later chunks inappropriately making your code less prone to bugs.

You can specify variables to be cached within a chunk by putting

`#| cache.vars: [var1, var2]`

at the top of the chunk to make them available in other chunks.

This is fine to do if you need to, particularly for small variables, but a better practice is to save the variables to disk using qs::qsave() and then load them in where needed using qs::qread().

This is _particularly true_ when creating data that will be used within other qmd files. Here especially, it is important to save the data to disk and load it in as needed so it is clear where the data is coming from.

## Parent qmd
The parent qmd file should be a high-level overview of the analysis. It should load in data, run the analysis, and create the final report. It should not contain any data processing or analysis code. This will make it easier to find where specific things are happening in your code. All child qmds should be run from the parent qmd file and should be preceeded by a header with a single pound sign (#) and a brief description of what the child qmd is doing.

## Child qmds
Each child qmd file should contain a single analysis. For instance, have a qmd file for your GSEA analysis, a qmd file for loading in data. This will make it easier to find where specific things are happening in your code.

Each child qmd file should be a self-contained unit that can be run independently of the parent qmd file. This means that all data should be loaded in from disk and all variables should be created within the child qmd file. This will make it easier to debug and run the child qmd files independently of the parent qmd file.

Name your child qmds something informative so it's obvious what the file is doing. For instance, if you have a qmd file that loads in data, you could name it "load_data.qmd".

## Chunks

### Short chunks are good
Keep each chunk brief and to the point. If a chunk is getting too long, consider breaking it up into smaller chunks. This will make it easier to debug and understand what is happening in your code.

### Name your chunks
Give all chunks a descriptive name. I would recommend adding a prefix to all chunks in a single qmd to make it more obvious where that chunk is coming from. For instance, if you have a qmd file for a GSEA analysis, you could prefix all chunks with "gsea_". Also, by naming your chunks you can avoid caching issues due to having mixups with cache/unnamed_chunk_*.RData or cache_files/unnamed_chunk_*.png when you move around chunks. I would avoid adding a numeric prefix to your chunks in case you end up adding, removing, or moving chunks around.

### Make your chunks depend on each other
If you have a chunk that uses data from a previous chunk, specify that this chunk depends on the previous chunk by putting

`#| dependson: [chunk_name]`

at the top of the chunk. This will make any changes to earlier chunks cause the dependent chunks to be re-run due to caching.

## Redundant code
If you find yourself copying and pasting code, consider creating a function to do that task. This will make your code easier to read and maintain.

If you make helper functions, put them into the helper_functions.qmd file. This will make it easier to find where the functions are and will make it easier to reuse them in other qmd files. This file should be loaded at the top of the parent qmd file.

## To make tabs with plots use `qreport::make_tabs()`
Make a list of plots, where the names are going to be the tab names. In the chunk where you are going to make the tabs, put

`#| results: "asis"`

at the top of the chunk and call `qreport::make_tabs(plot_list)` on the list of plots. This will make a tabbed plot in the final report. The baselabel argument will make the caching more reliable by giving the created chunks unique names.

## Control randomness
Before any random process, set the seed using `set.seed()` immediately before the function call or loop. This will make your results reproducible.

## Use the output folder
Put all your outputs into the output folder in appropriately named and organized folders/subfolders. This will make it easier to find your outputs and will make it easier to share your code with others.

## Render frequently
This will keep your code working cleanly so you don't end up with a bunch of incompatible code at the end of your analysis.
