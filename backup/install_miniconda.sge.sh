#!/bin/bash
#
#$ -N inst-miniconda   	# Job name
#$ -S /bin/bash         # Set shell to bash
#
#$ -l h_vmem=10G         # Request Max. Virt. Mem.
#
#$ -q all.q		# choose the queue
#$ -cwd                 # Change to current working directory
#$ -V                   # Export environment variables into script
#$ -pe smp 1    	# Select the parallel environment
#
#$ -o log.$JOB_NAME.$JOB_ID.out      # SGE-Output File
#$ -e log.$JOB_NAME.$JOB_ID.err      # SGE-Error File

#print some info to log
echo "Running under shell '${SHELL}' in directory '`pwd`' using $NSLOTS slots"
echo "Host: $HOSTNAME"
echo "Job: $JOB_ID"

#get going
echo -e "\n[$(date)] - Starting ..\n"

#Download installer
installer=Miniconda3-py37_4.8.2-Linux-x86_64.sh
wget https://repo.anaconda.com/miniconda/$installer
#install with batch mode, i.e. say yes to all / no interaction required
#first make sure that there isn't a miniconda3 directory there, in case you've tried before
if [ -d "miniconda3" ]
then
	rm -rf miniconda3
fi
bash ./$installer -b -p $(pwd)/miniconda3

#activate the shell
#eval "$(./miniconda3/bin/conda shell.bash hook)"
#eval "$(./miniconda3/bin/conda shell.$(echo $SHELL | awk -F "/" '{print $NF}') hook)"
eval "$(./miniconda3/bin/conda shell.${SHELL##*/} hook)"

#initiate conda environment globally, i.e. add instructions to ~/.bashrc
conda init
#unset auto-activate behaviour for base environment
conda config --set auto_activate_base false

#this is trying to preempt the issue with the channel order that we've seen (not necessary if you have the 'right' order)
conda config --set channel_priority false

#create environment file
echo -e "
name: snakemake
channels:
  - conda-forge
  - bioconda
dependencies:
  - snakemake==5.9.1" > snakemake_config.yml 

#create Snakemake conda environment based on config file
conda env create -f snakemake_config.yml

echo -e "\n[$(date)] - Done!\n"

