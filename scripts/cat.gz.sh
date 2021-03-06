#!/bin/bash -l
##Modified by Qiang Lan from Rishi's 4-rna-seq scripts on 21.12.2019
#SBATCH -J cat_gz
#SBATCH --account=Project_2002302 ##*account name must be specified*
#SBATCH -o OUT/cat_gz_out_%j.txt
#SBATCH -e ERROR/cat_gz_err_%j.txt
#SBATCH -p large
#SBATCH -n 1
#SBATCH -t 12:20:00
#SBATCH --mem-per-cpu=1000
#SBATCH --mail-type=END


source scripts/command_utility.sh
num_cmnds=$( cmnds_in_file )

if test -f "$1" ; then
        if test ! -d $2 ; then
                mkdir $2
        else
                echo "Output directory exists!!"
                exit 1 
        fi

        while IFS= read -r line
        do
          echo "cat */*$line*fastq.gz > $2/$line.fastq.gz" >> commands/$num_cmnds"_cat.gz".txt
        done < "$1"
        
        sbatch_commandlist -jobname cat -commands commands/$num_cmnds"_cat.gz".txt
else 
    echo "sample names is missing"
        # sbatch_commandlist -jobname cat -commands commands/cat_gz.txt
fi

mv *_out_*txt OUT
mv *_err_*txt ERROR

# This script will print some usage statistics to the
# end of file: cat_gz_out
# Use that to improve your resource request estimate
# on later jobs.
##used_slurm_resources.bash