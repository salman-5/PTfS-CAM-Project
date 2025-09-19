#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --job-name=learderboard
#SBATCH --time=02:00:00
#SBATCH --constraint=hwperf
#SBATCH --export=NONE
unset SLURM_EXPORT_ENV

# Load Intel compiler
module load intel likwid
make clean
make

./leaderboard.sh "" "likwid-pin -c S0:0-35@S1:36-71"


openmpi/4.1.3-gcc14.2.0


