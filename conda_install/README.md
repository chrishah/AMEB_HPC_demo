```bash
#Download Miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
#install
bash ./Miniconda3-latest-Linux-x86_64.sh

. ~/.bashrc

conda env create -f snakemake_config.yml

#activate the conda environment:
conda activate snakemake

```
