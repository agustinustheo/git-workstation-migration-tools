#!/bin/bash

# Function to show usage
show_usage() {
    echo "Usage: $0 [-d|--days DAYS_AGO] [-o|--output OUTPUT_FILE]"
    echo "Options:"
    echo "  -d, --days     Number of days ago to start from (default: 7)"
    echo "  -o, --output   Output file name (default: git_weekly_report.txt)"
    echo "  -h, --help     Show this help message"
    exit 1
}

# Default values
days_ago=7
output_file="git_weekly_report.txt"

# Parse command line arguments using getopt
TEMP=$(getopt -o d:o:h --long days:,output:,help -n 'git-weekly-report' -- "$@")
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

eval set -- "$TEMP"

while true; do
    case "$1" in
        -d|--days)
            days_ago="$2"
            shift 2
            ;;
        -o|--output)
            output_file="$2"
            shift 2
            ;;
        -h|--help)
            show_usage
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal error!"
            exit 1
            ;;
    esac
done

# Validate days_ago is a non-negative number
if ! [[ "$days_ago" =~ ^[0-9]+$ ]]; then
    echo "Error: Days must be a non-negative number"
    exit 1
fi

# Calculate dates
end_date=$(date +%Y-%m-%d)
start_date=$(date -v-${days_ago}d +%Y-%m-%d)

# Create or clear the output file
echo "Git Activity Report from $start_date to $end_date" > "$output_file"
echo "================================================" >> "$output_file"

# Get all branches (including remote branches)
git fetch --all >/dev/null 2>&1
branches=$(git branch -r | grep -v '\->' | sed "s/origin\///")

# Loop through each branch
for branch in $branches; do
    echo -e "\nBranch: $branch" >> "$output_file"
    echo "----------------" >> "$output_file"
    
    # Get commits for the branch within date range
    git log \
        "origin/$branch" \
        --since="$start_date" \
        --until="$end_date" \
        --pretty=format:"%h | %an | %ad | %s" \
        --date=format:"%Y-%m-%d %H:%M" >> "$output_file"
    
    # Get stat summary for the branch
    echo -e "\n\nChanges Summary:" >> "$output_file"
    git log \
        "origin/$branch" \
        --since="$start_date" \
        --until="$end_date" \
        --numstat \
        --pretty=format:"%h" | awk 'NF==3 {plus+=$1; minus+=$2;} END {printf "Added: %d, Deleted: %d\n", plus, minus}' >> "$output_file"
    
    echo -e "\n------------------------------------------------" >> "$output_file"
done

# Add summary statistics at the end
echo -e "\nOverall Statistics" >> "$output_file"
echo "=================" >> "$output_file"
echo "Total commits: $(git log --all --since="$start_date" --until="$end_date" --pretty=format:"%h" | wc -l)" >> "$output_file"
echo "Total authors: $(git log --all --since="$start_date" --until="$end_date" --pretty=format:"%an" | sort -u | wc -l)" >> "$output_file"

echo "Report generated in $output_file"
