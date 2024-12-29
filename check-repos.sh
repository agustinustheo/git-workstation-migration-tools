#!/bin/bash

# Function to check if directory is a git repository
is_git_repo() {
    git -C "$1" rev-parse --is-inside-work-tree >/dev/null 2>&1
}

# Function to check if repository has remote
has_remote() {
    git -C "$1" remote get-url origin >/dev/null 2>&1
}

# Function to check for uncommitted changes
has_uncommitted_changes() {
    ! git -C "$1" diff --quiet HEAD || ! git -C "$1" diff --cached --quiet
}

# Function to check if local is behind remote
is_behind_remote() {
    git -C "$1" fetch origin >/dev/null 2>&1
    BEHIND=$(git -C "$1" rev-list HEAD..origin/$(git -C "$1" branch --show-current) --count 2>/dev/null)
    [ "$BEHIND" -gt 0 ] 2>/dev/null
}

# Function to check if local is ahead of remote
is_ahead_of_remote() {
    AHEAD=$(git -C "$1" rev-list origin/$(git -C "$1" branch --show-current)..HEAD --count 2>/dev/null)
    [ "$AHEAD" -gt 0 ] 2>/dev/null
}

echo "Analyzing repositories in current directory..."
echo "----------------------------------------"

# Store results in temporary files
KEEP_LIST="/tmp/git_keep.txt"
DELETE_LIST="/tmp/git_delete.txt"
: > "$KEEP_LIST"  # Clear files
: > "$DELETE_LIST"

# Main loop - for each directory in current path
for dir in */; do
    dir=${dir%/}  # Remove trailing slash
    if ! is_git_repo "$dir"; then
        echo "📁 $dir - Not a git repository (KEEP)"
        echo "$dir" >> "$KEEP_LIST"
        continue
    fi

    status=""
    if ! has_remote "$dir"; then
        echo "🔒 $dir - No remote repository (KEEP)"
        echo "$dir" >> "$KEEP_LIST"
        continue
    fi

    needs_attention=false
    
    if has_uncommitted_changes "$dir"; then
        status+="Has uncommitted changes, "
        needs_attention=true
    fi
    
    if is_behind_remote "$dir"; then
        status+="Behind remote, "
    fi
    
    if is_ahead_of_remote "$dir"; then
        status+="Ahead of remote, "
        needs_attention=true
    fi

    if [ "$needs_attention" = true ]; then
        echo "⚠️  $dir - $status(KEEP)"
        echo "$dir" >> "$KEEP_LIST"
    else
        echo "✅ $dir - In sync with remote (CAN BE DELETED)"
        echo "$dir" >> "$DELETE_LIST"
    fi
done

echo -e "\n========== Summary =========="
echo "Repositories to keep:"
cat "$KEEP_LIST"
echo -e "\nRepositories that can be deleted (up-to-date with remote):"
cat "$DELETE_LIST"
echo -e "\nPlease confirm which repositories you want to delete."

rm "$KEEP_LIST" "$DELETE_LIST"
