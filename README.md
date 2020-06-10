# AMEB_HPC_demo

## Welcome

## Connect to the cluster

## Meet the queue

Try:
```bash
(user@host)-$ qstat
```

and
```bash
(user@host)-$ qstat -u $USER
```

## Create your first submission script

Open a new file called `my_first_submission.sge.sh` with a text editor - the simplest which is already installed is `nano`:
```bash
(user@host)-$ nano my_first_submission.sge.sh
```

Now, enter the following text.
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


Now we can submit your first job.

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

