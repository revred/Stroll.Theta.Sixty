#!/bin/bash

# Auto-commit script for Stroll.Theta.Sixty repository
# Commits new SQLite hourly databases every 2 minutes

set -e

REPO_DIR="/c/code/Stroll.Theta.Sixty"
CYCLE=1

while true; do
    echo -e "\033[0;36m⏰ $(date '+%H:%M:%S') - Running auto-commit for Sixty repository...\033[0m"
    echo -e "\033[0;34m╔══════════════════════════════════════════════════════════════════╗\033[0m"
    echo -e "\033[0;34m║              \033[0;36mAUTO-COMMIT STROLL.THETA.SIXTY\033[0;34m                ║\033[0m"
    echo -e "\033[0;34m║     \033[1;33mCommit new SQLite hourly databases automatically\033[0;34m        ║\033[0m"
    echo -e "\033[0;34m╚══════════════════════════════════════════════════════════════════╝\033[0m"

    cd "$REPO_DIR"
    
    # Check for unstaged changes
    if git status --porcelain | grep -q '^??'; then
        echo -e "\033[0;36m🔍 Found new SQLite files to commit...\033[0m"
        
        # Count new files
        NEW_FILES=$(git status --porcelain | grep '^??' | wc -l)
        
        # Add all new SQLite files
        git add **/*.db 2>/dev/null || true
        
        # Check if there are staged changes
        if git diff --cached --quiet; then
            echo -e "\033[1;33m  No SQLite files to commit\033[0m"
        else
            # Create commit
            git commit -m "$(cat <<'EOC'
Auto-commit new SQLite hourly databases

- Added new hourly databases with 60-minute bar data
- Each file contains exactly 60 rows (one per minute)
- Automated commit for continuous integration

🤖 Generated with Claude Code

Co-Authored-By: Claude <noreply@anthropic.com>
EOC
)"
            
            # Push to GitHub
            git push
            
            echo -e "\033[0;32m📈 Commit Summary:\033[0m"
            echo -e "\033[0;32m  New SQLite files: $NEW_FILES\033[0m"
            echo -e "\033[0;32m📈 Auto-commit cycle $CYCLE completed\033[0m"
        fi
    else
        echo -e "\033[1;33m  No new SQLite files to commit\033[0m"
        echo -e "\033[0;32m📈 Auto-commit cycle $CYCLE completed\033[0m"
    fi
    
    echo -e "\033[1;33m  💤 Waiting 2 minutes until next cycle...\033[0m"
    echo ""
    
    CYCLE=$((CYCLE + 1))
    sleep 120
done
