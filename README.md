# Git Repository Migration Helper

A set of bash scripts to help migrate git repositories between workstations by identifying which repos need attention and safely cleaning up synchronized repositories.

## Scripts

### check-repos.sh
Analyzes all git repositories in the current directory and categorizes them based on their status:
- Identifies repositories with uncommitted changes
- Checks for repositories without remotes
- Detects if local branches are ahead or behind their remote counterparts
- Provides a summary of which repositories need attention and which are safe to delete

### delete-repos.sh
Safely deletes specified git repositories after confirmation:
- Shows a list of repositories to be deleted
- Indicates which repositories exist and which don't
- Requires explicit confirmation before deletion
- Handles deletion of multiple repositories in batch

### git-weekly-report.sh
Generates a detailed report of git activity across all branches (optimized for macOS):
- Shows commits and changes within a specified time period
- Supports custom date ranges through command-line options
- Provides detailed statistics per branch and overall summary

## Usage

1. First, run the check script to analyze your repositories:
```bash
./check-repos.sh
```

2. Review the output to see which repositories:
   - Need attention (uncommitted changes, ahead of remote, etc.)
   - Are safe to delete (fully synchronized with remote)

3. If you want to delete repositories that are safe to remove, use:
```bash
./delete-repos.sh
```

4. To generate a git activity report (macOS optimized):
```bash
# Generate default 7-day report
./git-weekly-report.sh

# Generate report for the last 14 days
./git-weekly-report.sh --days 14

# Generate report with custom output file
./git-weekly-report.sh --output my_report.txt
```

The report includes:
- Commit history per branch
- Changes summary (additions/deletions)
- Overall statistics including total commits and unique authors

## Safety Features

- All scripts require executable permissions
- The delete script requires explicit confirmation
- The check script identifies repositories that need attention before deletion
- No automatic deletion - all operations require user confirmation

## Requirements

- Bash shell
- Git
- macOS for full git-weekly-report.sh functionality (date handling is optimized for macOS)

## Installation

1. Clone this repository
2. Make the scripts executable:
```bash
chmod +x check-repos.sh delete-repos.sh git-weekly-report.sh
```

## License

MIT License
