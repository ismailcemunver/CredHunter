# CredHunter
CredHunter is a simple shell script to search for sensitive information across various filetypes, such as config files, db files, scripts, and bash history. The script is specifically written to automate the credential hunting phase for Linux Post Exploitation.

## Features

- **Search Configuration Files**: Search content within `.cnf`, `.conf`, and `.config` files on remote host.
- **Search Database Files**: Search credentials in database files with `.sql`, `.db`, and similar extensions.
- **Search Script and Code Files**: Search for content across multiple scripting and programming files such as `.py`, `.sh`, `.go`, `.jar`.
- **View Bash History**: Display the last 5 lines of bash files such as `.bash_history` for all users.

## Usage
```bash
./credhunter.sh [--config | --sql | --scripts | --bash-history | --all] --search=term1,term2,term3
```

**Search for config files:**
```bash
./credhunter.sh --config --search=username,password
```
**Search across all supported file types for API keys, secrets, and tokens**
```bash
./credhunter.sh --all --search=apikey,secret,token
```

**Display the last 5 lines of .bash_history of all users on host**
```bash
./credhunter.sh --bash-history
```


## Available Options

- **--config**: Search creds and secrets within configuration files only.
- **--sql**: Search creds and secrets within DB files specifically.
- **--scripts**: Search scripts for creds and secrets.
- **--bash-history**: Display the last 5 lines of bash files for all users.
- **--all**: Search for secrets, passwords, tokens inside all the file types above.
- **--search**: Specify comma-separated search terms (e.g., --search=username,password,secret).
- **--help/-h**: Display help/usage guide.

## Installation
To use CredHunter, simply download the script and make it executable:
```bash
chmod +x credhunter.sh
```

## Screenshots
**Help Menu:**
![help](https://github.com/user-attachments/assets/6c2b4b4d-089e-44dc-a4c8-9be548dda4f1) 

**Searching "secretkey" inside the configuration files on host:**

![getsecret](https://github.com/user-attachments/assets/17f5ef53-ea03-47af-9b65-a95a43553b9a)

## Disclaimer
This repository is created for educational purposes only. Users are solely responsible for complying with applicable laws and regulations while using the tools and techniques provided here. The creator of this repository is not responsible for any misuse or unlawful activities conducted by individuals using the information and resources available in this repository.


