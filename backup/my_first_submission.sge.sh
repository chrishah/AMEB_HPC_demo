#!/bin/bash
#
#$ -N test	   	# Job name
#$ -S /bin/bash         # Set shell to bash
#
#$ -l h_vmem=2G         # Request Max. Virt. Mem.
#
#$ -q all.q@C147	# choose the queue
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

#pick a random number between 100 and 200 - this will be how many seconds the job will be taking
delay=$((100 + RANDOM % 100))

echo -e "Hello $USER in stdout - I will wait $delay seconds for you"
echo -e "Hello $USER in stderr - I will wait $delay seconds for you" >&2
sleep $delay

echo -e "\n[$(date)] - Done!\n"

