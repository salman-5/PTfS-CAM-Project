#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --job-name=learderboard
#SBATCH --time=01:00:00
#SBATCH --constraint=hwperf
#SBATCH --export=NONE
unset SLURM_EXPORT_ENV

# Load Intel compiler
module load intel likwid
make
# ./leaderboard.sh "" "likwid-pin -c S0:0-35@S1:36-71"
./leaderboard.sh "OMP_NUM_THREADS=72 OMP_PLACES=threads OMP_PROC_BIND=close" ""