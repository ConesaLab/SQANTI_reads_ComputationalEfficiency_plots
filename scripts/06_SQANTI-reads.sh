#!/bin/bash
#SBATCH --job-name=sqanti_readsMem
#SBATCH --output=../logs/sqantiReads_%A_%a.out 
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=150gb
#SBATCH --qos=medium
#SBATCH --time=3-00:00:00
#SBATCH --array=0-16
#SBATCH --mail-type=BEGIN,END,FAIL #Send e-mails
#SBATCH --mail-user=carolina.monzo@csic.es

source ~/.bashrc

module load samtools
conda deactivate
conda init
#conda activate 2023_carol 
conda activate SQANTI3.env

# Create array of files
readarray myarray < list_metadatas.fof

# Read the file corresponding to the task
file=${myarray[$SLURM_ARRAY_TASK_ID]}

echo $file
start=$SECONDS

#file_dir=$(dirname $file)
#qc_dir="/storage/gge/cmonzo/nanopore_RNA_degradation/analysis/SQANTI3_reports/"
#ori_name=$(basename $file)
#filename="${ori_name%.fastq}"

#echo $filename

#ref_annotation="/storage/gge/genomes/human/Homo_sapiens.GRCh38.99.gtf"
#assembly="/storage/gge/genomes/human/Homo_sapiens.GRCh38.dna.primary_assembly.fa"


# SQ input
#isoforms_gff="/storage/gge/cmonzo/nanopore_RNA_degradation/data/gffs/${filename}_primary_aln.gff"

#python3 /home/cmonzo/software/SQANTI3/sqanti3_qc.py --min_ref_len 0 --skipORF --dir "${qc_dir}/${filename}" --output "${filename}" ${isoforms_gff} ${ref_annotation} ${assembly}

python ~/software/SQANTI3/sqanti_reads.py --design $file -i ../analysis/SQANTI3_reports/ -p "${file%.csv}" -d ../analysis/SQANTI3_reports/ --annotation /storage/gge/genomes/human/Homo_sapiens.GRCh38.99.gtf

echo "Completed %A_%a for $file in $SECONDS seconds"
