#!/bin/bash
#SBATCH --account=gdrobertslab
#SBATCH --error=geo/slurmOut/geo_gather_%j.txt
#SBATCH --output=geo/slurmOut/geo_gather_%j.txt
#SBATCH --mem=2G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --job-name geo_gather
#SBATCH --wait
#SBATCH --array=0-3

set -e

export PATH=/gpfs0/home2/gdrobertslab/lab/Tools/10x/cellranger-7.2.0:$PATH

geo_samples=(S0001
             S0005
             S0037
             S0281)

bam_folder=(S0001
            S0005
            S0037
            S0281)

folder_array=(Counts/S0001-mix/outs
              Counts/S0005-CoCx-2/outs
              Counts_2/S0037
              Counts_2/S0281)

# S0001   os-17 mix             Figure 3/4
# S0005   os-17 coc             Figure 3/4
# S0037   os-17 pdx tibia       Figure 3/4
# S0281   os-17 pdx met         Figure 3/4

sample=${geo_samples[$SLURM_ARRAY_TASK_ID]}
bam_folder=${bam_folder[$SLURM_ARRAY_TASK_ID]}
folder=${folder_array[$SLURM_ARRAY_TASK_ID]}

echo ${sample} ${folder}

if [ ! -d geo/proc_data/${sample} ]; then
    mkdir -p geo/proc_data/${sample}
fi

# Get fastq files
/gpfs0/home2/gdrobertslab/lab/Tools/10x/cellranger-7.2.0/lib/bin/bamtofastq \
    --nthreads 5 \
    /home/gdrobertslab/lab/Counts_2/${bam_folder}/possorted_genome_bam.bam \
    geo/${sample}_fastq

zcat \
    geo/${sample}_fastq/*/*R1*.fastq.gz \
    | pigz -p 5 \
    > geo/${sample}_fastq/${sample}_S1_L001_R1_001.fastq.gz

zcat \
    geo/${sample}_fastq/*/*R2*.fastq.gz \
    | pigz -p 5 \
    > geo/${sample}_fastq/${sample}_S1_L001_R2_001.fastq.gz

rm -r geo/${sample}_fastq/*/*.fastq.gz


# Get processed data
cp \
    /home/gdrobertslab/lab/${folder}/filtered_feature_bc_matrix/* \
    geo/proc_data/${sample}/

cp  \
    /home/gdrobertslab/lab/${folder}/filtered_feature_bc_matrix.h5 \
    geo/proc_data/${sample}/

cp  \
    /home/gdrobertslab/lab/${folder}/raw_feature_bc_matrix.h5 \
    geo/proc_data/${sample}/

cp  \
    /home/gdrobertslab/lab/${folder}/web_summary.html \
    geo/proc_data/${sample}/

cp  \
    /home/gdrobertslab/lab/${folder}/metrics_summary.csv \
    geo/proc_data/${sample}/


cd geo/proc_data

tar -czf ${bam_folder}.tar.gz ${sample}
