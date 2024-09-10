#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

print_help() {
    echo -e "${BOLD}CredHunter by nexil${NC}"
    echo -e "Find it on GitHub: ${GREEN}https://github.com/ismailcemunver/credhunter${NC}"
    echo -e "${GREEN}Usage: $0 [--config | --sql | --scripts | --bash-history | --all] --search=term1,term2,term3${NC}"
    echo "  --config       Search only config files"
    echo "  --sql          Search only SQL and database files"
    echo "  --scripts      Search only script and code files"
    echo "  --bash-history Show last 5 lines of .bash* files (does not require --search)"
    echo "  --all          Search all files (config, SQL, scripts, and bash history)"
    echo "  --search       Specify comma-separated search terms (e.g., --search=username,password,secret)"
    echo "  --help, -h     Show this usage guide"
}

if [[ "$@" == *"--help"* || "$@" == *"-h"* ]]; then
    print_help
    exit 0
fi

if [[ "$@" != *"--bash-history"* ]] && [[ "$@" != *"--search="* ]]; then
    echo -e "${RED}Error: The --search flag is required for this operation.${NC}"
    print_help
    exit 1
fi

if [[ "$@" == *"--search="* ]]; then
    SEARCH_TERMS=$(echo "$@" | grep -oP '(?<=--search=)[^ ]+')
    IFS=',' read -ra TERMS_ARRAY <<< "$SEARCH_TERMS"
    SEARCH_PATTERN=$(printf "|%s" "${TERMS_ARRAY[@]}")
    SEARCH_PATTERN="${SEARCH_PATTERN:1}"
fi

search_config() {
    echo -e "${GREEN}===== Data Found on Config Files =====${NC}"
    for i in $(find / -name *.cnf -o -name *.conf -o -name *.config 2>/dev/null | grep -v "doc\|lib"); do
        result=$(grep --color=always -E "$SEARCH_PATTERN" $i 2>/dev/null | grep -v "\#")
        if [ ! -z "$result" ]; then
            echo -e "\n${BOLD}File: $i${NC}"
            echo "$result"
        fi
    done
}

search_sql() {
    echo -e "\n${GREEN}===== Data Found on Database and SQL Files =====${NC}"
    for i in $(find / -name *.sql -o -name *.db -o -name .*db -o -name *.db* 2>/dev/null | grep -v "doc\|lib"); do
        result=$(grep --color=always -E "$SEARCH_PATTERN" $i 2>/dev/null | grep -v "\#")
        if [ ! -z "$result" ]; then
            echo -e "\n${BOLD}File: $i${NC}"
            echo "$result"
        fi
    done
}

search_scripts() {
    echo -e "\n${GREEN}===== Data Found on Script and Code Files =====${NC}"
    for i in $(find / -name *.py -o -name *.pyc -o -name *.pl -o -name *.go -o -name *.jar -o -name *.c -o -name *.sh 2>/dev/null | grep -v "doc\|lib"); do
        result=$(grep --color=always -E "$SEARCH_PATTERN" $i 2>/dev/null | grep -v "\#")
        if [ ! -z "$result" ]; then
            echo -e "\n${BOLD}File: $i${NC}"
            echo "$result"
        fi
    done
}

search_bash_history() {
    echo -e "\n${GREEN}===== Last 5 lines of .bash* files in /home directories =====${NC}"
    for file in /home/*/.bash*; do
        if [ -f "$file" ] && [ -s "$file" ]; then
            echo -e "\n${BOLD}File: $file${NC}"
            tail -n5 "$file" 2>/dev/null
        fi
    done
}

search_anything=false

if [[ "$@" == *"--config"* ]]; then
    search_anything=true
    search_config
fi

if [[ "$@" == *"--sql"* ]]; then
    search_anything=true
    search_sql
fi

if [[ "$@" == *"--scripts"* ]]; then
    search_anything=true
    search_scripts
fi

if [[ "$@" == *"--bash-history"* ]]; then
    search_bash_history
fi

if [[ "$@" == *"--all"* ]]; then
    if [[ -z "$SEARCH_PATTERN" ]]; then
        echo -e "${RED}Error: The --search flag is required when using --all.${NC}"
        exit 1
    fi
    search_anything=true
    search_config
    search_sql
    search_scripts
    search_bash_history
fi

if [[ "$search_anything" == false ]] && [[ "$@" != *"--bash-history"* ]]; then
    echo -e "${RED}Error: No valid search section specified!${NC}"
    print_help
fi
