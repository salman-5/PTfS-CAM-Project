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

./leaderboard.sh "numactl --cpunodebind=0,1 --membind=0,1" "likwid-pin -c S0:0-35@S1:36-71"
# ./leaderboard.sh "OMP_PROC_BIND=spread OMP_PLACES={0:72}" ""
make clean



