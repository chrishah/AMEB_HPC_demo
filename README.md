# AMEB_HPC_demo

## Welcome

We are going to connect to and run a few tests on the HPC cluster of the Uni Graz - it's called 'Sauron'. Currently Sauron has about 90 Compute nodes, with between 256 and 768 GB RAM per Node, and a total of ~2000 cores. All employees and students at Uni Graz can apply for access the cluster - see information [here](https://hpc-wiki.uni-graz.at/HLR%20Anmeldung/Account_Instructions.htm) (Uni Graz user account required). If you are attending the course your registration will be taken care of.

## Connect to the cluster

You can access the cluster only from within the University network, e.g. either while being on campus or, if you want to access from elsewhere you'll need to have a VPN set up. Instructions on how to that can be found [here](https://it.uni-graz.at/en/services/access-to-the-university-network/vpn/).

### On Linux or Mac

If you're working on a Linux or Mac system, the easiest is to open a terminal window, type and execute something like the following.

Replace `username` below, with:
 - if you are employee - your username, e.g. `musterm`
 - if you are a student - `BZEDVZ+012musterm`

Connect via ssh.
```bash
(user@host)-$ ssh username@sauron1.uni-graz.at
```

You will be prompted for your password (this is your regular University password you also use for email, etc.).

Note that when entering your password you will most likely not see any asterisks or dots or something like that appearing as you type. Just press 'Enter' when you think you're done. 

You should be connected!!

## On Windows

You are going to need an ssh client. The simplest one I know (simple in the sense that it should work on almost any Windows flavor) is [putty](https://www.putty.org/). The installation should be as easy as (see also [here](https://github.com/chrishah/AMEB_HPC_demo/blob/master/backup/putty/README.md)):
 - Go to the webpage
 - Download the 64-bit version for windows
 - Execute, and say yes, yes, yes (assuming you agree)

Once it's installed you can start the program, then enter into the field 'Host Name (or IP address)':
 - if you are employee - e.g. `musterm@sauron1.uni-graz.at`
 - if you are a student - `BZEDVZ+012musterm@sauron1.uni-graz.at`

Click 'open'.
Then you will be warned that you are about to connect to an unknown computer. If you trust Sauron, say 'yes'.

You will be prompted for your password (this is your regular University password you also use for email, etc.).

Note that when entering your password you will most likely not see any asterisks or dots or something like that appearing as you type. Just press 'Enter' when you think you're done. 

You should be connected!!


## Meet the queue

HPC clusters usually have some kind of queuing system in place that organizes and manages the jobs of all users, i.e. if your job request a certain amount of resources, e.g. 20 cores and a total of 240GB RAM, the queuing system will hold your job until the requested resources are avaialable for you.

Sauron uses the `SGE` (son of grid engine) system.

You can see what's currently going on in the queue with the following command.
```bash
(user@host)-$ qstat
```

If you only want to see your jobs that are currently waiting/running, try:
```bash
(user@host)-$ qstat -u $USER
```

## Create your first submission script

The amount of resources you are requesting for your job and the actual commands that you want to be run are usually bundled in a submission script. Let's try to make one. 

Open a new file called `my_first_submission.sge.sh` with a text editor - the simplest which is already installed is `nano`:
```bash
(user@host)-$ nano my_first_submission.sge.sh
```

Now, enter (or copy/paste) the following text.
```bash

#!/bin/bash
#
#$ -N test              # Job name
#$ -S /bin/bash         # Set shell to bash
#
#$ -l h_vmem=2G         # Request Max. Virt. Mem.
#
#$ -q all.q@C147        # choose the queue
#$ -cwd                 # Change to current working directory
#$ -V                   # Export environment variables into script
#$ -pe smp 1            # Select the parallel environment
#
#$ -o log.$JOB_NAME.$JOB_ID.out      # SGE-Output File
#$ -e log.$JOB_NAME.$JOB_ID.err      # SGE-Error File

#print some info to log
echo "Running under shell '${SHELL}' in directory '`pwd`' using $NSLOTS slots"
echo "Host: $HOSTNAME"
echo "Job: $JOB_ID"

#get going
echo -e "\n[$(date)] - Starting ..\n"

#pick a random number between 100 and 200 - this will be how many seconds the job will be taking
delay=$((100 + RANDOM % 100))

echo -e "Hello $USER in stdout - I will wait $delay seconds for you"
echo -e "Hello $USER in stderr - I will wait $delay seconds for you" >&2
sleep $delay

echo -e "\n[$(date)] - Done!\n"

```

Save the file. If you are using `nano` press CTRL-x` then say 'yes' when asked if you want to save the changes.

### Some explanation:
The first few lines (all the ones starting with `#$ ` are instructions for the cluster). You can use this as a basic template for future jobs, simply modifying it according to your respective needs.
   - `-N` give your job a name (no spaces in the name)
   - `-l h_vmem=2G` - request 2G of RAM per core
   - `-q all.q@C147` - specify the queue/node you want to submit to (in this case cluster administration has reserved node `C147` for our tests, so we submit directly to that). If this was not the case, we could just say `-q all.q`, then SGE would just assign us the a suitable node (for which we'd potentially have to compete for with other users). There is other queues available, which we can discuss later on.
   - `-pe smp 1` - request 1 core for your job. This could be up the maximum number of cores available on a given node - via smp I specify that all cores should be on the same node. Most software is designed for such use cases, but there are others which can use cores across multiple nodes (you would put, e.g. `-pe mpi 50` in such a case).
   - `-o log.$JOB_NAME.$JOB_ID.out` and `-e log.$JOB_NAME.$JOB_ID.err` specify the files where any output that the process might produce will be written to, this includes status of the process, errors that may have occured, etc.. We use variables in the filenames, so that they will be called automatically according to what you called your job and also get a unique job id.
   
   - the remainder you can basically leave as they are unless you want to do some a bit more unusual in which case you probably know what you are doing anyway
 
The rest is a mock analyses that gives some output. In a nutshell, the job will give some output and wait for 100-200 seconds, then finish.


## submit your first job

Execute the following, to submit your job to the queue.

```bash
(user@host)-$ qsub my_first_submission.sge.sh
```

If you want to know the status of your job you can check via:
```bash
#to see all queued jobs
(user@host)-$ qstat
#to see only your jobs
(user@host)-$ qstat -u $USER
```

Once your jobs starts it will generate two files, something like `log.test.311953.out` and `log.test.311953.err` (the number will be different in your case - this is the unique job identifier). You can look into the files with `less`. Exit `less` by typing 'q'. Or since it's not too much output you could use `cat`.

```bash
(user@host)-$ less log.test.311953.out
(user@host)-$ less log.test.311953.err


(user@host)-$ cat log.test.311953.out
(user@host)-$ cat log.test.311953.err
```

__You ran your first job on a HPC cluster - Congratulations!!!__


## Set up conda and install Snakemake
(skip and go to the next section if you're impatient)

To set us up with Snakemake we are going to use a package management system called `conda` (see [Documentation](https://docs.conda.io/en/latest/)).

First we need to setup `conda`. I will create a new directory called `conda`, then move to it, then download the installation script.
```bash
(user@host)-$ mkdir conda
(user@host)-$ cd conda
(user@host)-$ wget https://repo.anaconda.com/miniconda/Miniconda3-py37_4.8.2-Linux-x86_64.sh
```

The installation script we just downloaded contains all instructions to set up Miniconda. Execute it (the `bash` part is telling the system that it should interpret the content in the Bash language). 
```bash
(user@host)-$ bash ./Miniconda3-py37_4.8.2-Linux-x86_64.sh
```

Now you will be prompted to agree to the licence - press enter, then space until you reach the end of the licence agreement (reading it along the way). At the bottom, you need to confirm with 'yes'. Then the installer asks you where you want to put the installation. For now you can just stick with the default and press enter. Then the installer will start working, downloading stuff, etc.. Might take a minute or two. Then you're asked if you want Miniconda to be initialized. Answer 'yes', and that should be almost it.

If you answered yes and you want to activate `conda` immediately in this session you can then do the following. If you're done for today you can just exit the session and `conda` will be available automatically for you once you start the next session.

Assuming you want to activate immediately.
```bash
(user@host)-$ . ~/.bashrc
```

If you install `conda` in this way it will by default be configured so that whenever you start a new shell you'll be setup in a virtual (base) conda environment - you may see your prompt change somewhat after you executed the above command. Nothing wrong with that in principle, but I don't want that so I disable this behaviour by executing the following command.
```bash
(base) (user@host)-$ conda config --set auto_activate_base false
```

If you are in the base environment at this point (note the `(base)` at the beginning of the prompt line), I suggest you deactivate the virtual env for now.
```bash
(base) (user@host)-$ conda deactivate
```

Now we want to set us up a virtual environment that has Snakemake installed using the `conda` package managing system. For reproducibility it's a good idea to put all the instructions for the setup in a configuration file. Conda expects this to come in the so-called `YAML` format. Let's use `nano` to make a new file.

```bash
(user@host)-$ nano snakemake_config.yml
```
Enter (or copy/paste) the following text to our config file. This will define the name of the environment to be created and the snakemake version you want to be installed. Conda will automatically fetch all packages that this particular snakemake version depends on. Within the conda universe software packages are more or less losely grouped in so-called channels and we'll ask conda to look for any software dependies of snakemake in these two channels. It's not so obvious why, but the order in which you list the channels may matter and in this case it's important to stick to this order (hats off to [@HannesOberreiter](https://github.com/HannesOberreiter) for calling that!)
```bash
name: snakemake
channels:
  - conda-forge
  - bioconda
dependencies:
  - snakemake==5.9.1
```
Save and close. 

Now, let's create the environment (this will take about 10 minutes in the test run).
```bash
(user@host)-$ conda env create -f snakemake_config.yml
```

After that, if you want to run Snakemake, you first need to enter the environment, then give it a whirl.
```bash
(user@host)-$ conda activate snakemake
(snakemake) (user@host)-$ snakemake -h
```

## Setting up conda and a snakemake environment (for the impatient)

If you finished the above steps successfully, great. I hope you've learned somethings along the way. If you can't be bothered to do all the manual work and are eager to submit jobs to the cluster you can do the whole process inside a cluster job. Copy the following into a file called, e.g. `install_miniconda_plus_snakemake.sge.sh`.
```bash
#!/bin/bash
#
#$ -N inst-miniconda    # Job name
#$ -S /bin/bash         # Set shell to bash
#
#$ -l h_vmem=10G         # Request Max. Virt. Mem.
#
#$ -q all.q 	        # choose the queue
#$ -cwd                 # Change to current working directory
#$ -V                   # Export environment variables into script
#$ -pe smp 1            # Select the parallel environment
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

#this solved the issue with the channel order (not necessary if you have the 'right' order)
conda config --set channel_priority false

#create environment file
echo -e "name: snakemake
channels:
  -  conda-forge
  - bioconda
dependencies:
  - snakemake==5.9.1" > snakemake_config.yml 

#create Snakemake conda environment based on config file
conda env create -f snakemake_config.yml

echo -e "\n[$(date)] - Done!\n"

```

Then submit the job and when you come back after your coffee break everything should be set up for you (if the queue wasn't too busy and your job actually started).
```bash
(user@host)-$ qsub install_miniconda_plus_snakemake.sge.sh 
```

If you just want to install without the fun of using the queue, you can exectue the script you just made as a simple bash script. In this way the instructions for the cluster will be ignored and the process will just run on your current Compute node.
```bash
(user@host)-$ bash ./install_miniconda_plus_snakemake.sge.sh
```

## Run Snakemake

After you've done the above once, if you want to run Snakemake, you first need to enter the environment, then give it a whirl.
```bash
(user@host)-$ conda activate snakemake
(snakemake) (user@host)-$ snakemake -h
```

And after, deactivate if you want, and then exit Sauron.
```bash
(snakemake) (user@host)-$ conda deactivate
(user@host)-$ exit
```


__Come again soon!!__
