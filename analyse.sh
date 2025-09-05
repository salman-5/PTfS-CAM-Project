#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --job-name=PTFSA
#SBATCH --time=01:00:00
#SBATCH --constraint=hwperf
#SBATCH --export=NONE
unset SLURM_EXPORT_ENV

# Load Intel compiler
module load intel likwid
LIKWID=on make
# Generate arguments for srun with exponential steps
FILENAME="output.csv"
rm -f "$FILENAME"
touch "$FILENAME"
echo "X,Y,Function,Counts,Total_Time,Time_per_count" >> "$FILENAME"

# First range: 1000 to 40000, step by multiplying by 1.2
start1=1000
end1=40000
n=1
while :; do
    value=$(echo "8*1.2^$n" | bc -l)
    if (( $(echo "$value >= $end1" | bc -l) )); then
        break
    fi
    M=$(echo "$value" | awk '{printf("%d", $1)}')
    result="$(srun --cpu-freq=2000000-2000000:performance ./perf $start1 $M)"
    # Extract function rows and trim spaces from function name using awk
    function_rows=$(echo "$result" | sed -n '/^[- ]\+$/d;/^ *FUNCTION/d;s/^[[:space:]]*\([^| ][^|]*\)[[:space:]]*|[[:space:]]*\([0-9]\+\)[[:space:]]*|[[:space:]]*\([0-9.e+-]\+\)[[:space:]]*|[[:space:]]*\([0-9.e+-]\+\)[[:space:]]*|/\1\2 \3 \4/p')
    ((n++))
    while read -r line; do
        echo "$M $start1 $line" >> "$FILENAME"
    done <<< "$function_rows"
done
n=1
while :; do
    value=$(echo "8*1.2^$n" | bc -l)
    if (( $(echo "$value >= $end1" | bc -l) )); then
        break
    fi
    M=$(echo "$value" | awk '{printf("%d", $1)}')
    result="$(srun --cpu-freq=2000000-2000000:performance ./perf $M $start1)"
    # Extract function rows and trim spaces from function name using awk
    function_rows=$(echo "$result" | sed -n '/^[- ]\+$/d;/^ *FUNCTION/d;s/^[[:space:]]*\([^| ][^|]*\)[[:space:]]*|[[:space:]]*\([0-9]\+\)[[:space:]]*|[[:space:]]*\([0-9.e+-]\+\)[[:space:]]*|[[:space:]]*\([0-9.e+-]\+\)[[:space:]]*|/\1\2 \3 \4/p')
    ((n++))
    while read -r line; do
        echo "$start1 $M $line" >> "$FILENAME"
    done <<< "$function_rows"
done
start1=2000
end1=20000
n=1
while :; do
    value=$(echo "8*1.2^$n" | bc -l)
    if (( $(echo "$value >= $end1" | bc -l) )); then
        break
    fi
    M=$(echo "$value" | awk '{printf("%d", $1)}')
    result="$(srun --cpu-freq=2000000-2000000:performance ./perf $start1 $M)"
    # Extract function rows and trim spaces from function name using awk
    function_rows=$(echo "$result" | sed -n '/^[- ]\+$/d;/^ *FUNCTION/d;s/^[[:space:]]*\([^| ][^|]*\)[[:space:]]*|[[:space:]]*\([0-9]\+\)[[:space:]]*|[[:space:]]*\([0-9.e+-]\+\)[[:space:]]*|[[:space:]]*\([0-9.e+-]\+\)[[:space:]]*|/\1\2 \3 \4/p')
    ((n++))
    while read -r line; do
        echo "$M $start1 $line" >> "$FILENAME"
    done <<< "$function_rows"
done
n=1
while :; do
    value=$(echo "8*1.2^$n" | bc -l)
    if (( $(echo "$value >= $end1" | bc -l) )); then
        break
    fi
    M=$(echo "$value" | awk '{printf("%d", $1)}')
    result="$(srun --cpu-freq=2000000-2000000:performance ./perf $M $start1)"
    # Extract function rows and trim spaces from function name using awk
    function_rows=$(echo "$result" | sed -n '/^[- ]\+$/d;/^ *FUNCTION/d;s/^[[:space:]]*\([^| ][^|]*\)[[:space:]]*|[[:space:]]*\([0-9]\+\)[[:space:]]*|[[:space:]]*\([0-9.e+-]\+\)[[:space:]]*|[[:space:]]*\([0-9.e+-]\+\)[[:space:]]*|/\1\2 \3 \4/p')
    ((n++))
    while read -r line; do
        echo "$start1 $M $line" >> "$FILENAME"
    done <<< "$function_rows"
done

# Replace spaces with commas in output CSV
sed -i 's/ /,/g' "$FILENAME"
