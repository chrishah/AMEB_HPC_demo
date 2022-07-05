#!/bin/bash
#
#SBATCH -J my_first_job
#SBATCH -N 1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=2
#SBATCH --ntasks-per-core=2
#SBATCH --mem=1000M
#SBATCH --time 00:10:00
#SBATCh --hint=multithread
#SBATCH --qos=hpc
#SBATCH --reservation=hahnc_1` # if you have a reservation
#SBATCH --nodelist=IT010214 #if you want a specific node

#SBATCH --output slurm-%j.out
#SBATCH --error slurm-%j.err

#From here on out the magic happens
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

