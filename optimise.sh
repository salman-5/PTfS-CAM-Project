#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --job-name=PTFSA
#SBATCH --time=01:00:00
#SBATCH --constraint=hwperf
#SBATCH --export=NONE
unset SLURM_EXPORT_ENV

# Load Intel compiler
module load intel likwid
iterate() {
    Y="$1"
    X="$2"
    CASE="$3"
    OPENMP="$4"
    result="$(srun --cpu-freq=2000000-2000000:performance ./perf "$Y" "$X")"
    function_rows=$(echo "$result" | sed -n '/^[- ]\+$/d;/^ *FUNCTION/d;s/^[[:space:]]*\([^| ][^|]*\)[[:space:]]*|[[:space:]]*\([0-9]\+\)[[:space:]]*|[[:space:]]*\([0-9.e+-]\+\)[[:space:]]*|[[:space:]]*\([0-9.e+-]\+\)[[:space:]]*|/\1\2 \3 \4/p')
    while read -r line; do
        echo "$OPENMP $CASE $line" >> "$FILENAME"
    done <<< "$function_rows"
}
call(){
    OPENMP="$1"
Y=20000
X=2000
iterate "$X" "$Y" "CASE1" "$OPENMP"
Y=2000
X=20000
iterate "$X" "$Y" "CASE2" "$OPENMP"
Y=1000
X=40000
iterate "$X" "$Y" "CASE3" "$OPENMP"
Y=12345
X=9876
iterate "$X" "$Y" "CASE4" "$OPENMP"
}
# Generate arguments for srun with exponential steps
FILENAME="optimise.csv"
rm -f "$FILENAME"
touch "$FILENAME"
echo "openmp,CASE,Function,Counts,Total_Time,Time_per_count" >> "$FILENAME"
make EXTRA_FLAGS=-DGRID_OMP_SIMD
call "SIMD"
make EXTRA_FLAGS=-DGRID_OMP_DYNAMIC
call "DYNAMIC"
make EXTRA_FLAGS=-DGRID_OMP_STATIC
call "STATIC"
make EXTRA_FLAGS=-DGRID_OMP_COLLAPSE_STATIC
call "COLLAPSE_STATIC"
make EXTRA_FLAGS=-DGRID_OMP_COLLAPSE
call "COLLAPSE"
# Replace spaces with commas in output CSV
sed -i 's/ /,/g' "$FILENAME"
