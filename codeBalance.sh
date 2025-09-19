#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --job-name=PTFSA
#SBATCH --time=01:00:00
#SBATCH --constraint=hwperf
#SBATCH --export=NONE
unset SLURM_EXPORT_ENV

# Load Intel compiler
module load intel likwid
make clean
LIKWID=on make
iterate() {
    Y="$1"
    X="$2"
    CASE="$3"
    echo "Running with X=$X Y=$Y for $CASE"
    for thread in $(seq 1 18); do
        srun --cpu-freq=2200000-2200000:performance likwid-perfctr -C M0:0-$((thread-1)) -g MEM_DP -m ./perf "$Y" "$X"
    done

    # function_rows=$(echo "$result" | sed -n '/^[- ]\+$/d;/^ *FUNCTION/d;s/^[[:space:]]*\([^| ][^|]*\)[[:space:]]*|[[:space:]]*\([0-9]\+\)[[:space:]]*|[[:space:]]*\([0-9.e+-]\+\)[[:space:]]*|[[:space:]]*\([0-9.e+-]\+\)[[:space:]]*|/\1\2 \3 \4/p')
    # while read -r line; do
    #     echo "$OPENMP $CASE $line" >> "$FILENAME"
    # done <<< "$function_rows"
}
call(){
Y=20000
X=2000
iterate "$X" "$Y" "CASE1"
Y=2000
X=20000
iterate "$X" "$Y" "CASE2"
Y=1000
X=400000
iterate "$X" "$Y" "CASE3"
}
call
make clean