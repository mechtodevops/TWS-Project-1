Detailed Explanation:

1. Shebang (`#!/bin/bash`):
   - This line at the beginning of the script specifies the shell interpreter that should be used to run the script, which is `bash` in this case.

2. `display_usage()` Function:
   - This function prints out the usage instructions and available options of the script. It uses `echo` to output text to the console and `exit 1` to terminate the script with a non-zero exit status (indicating an error).

3. User Management Functions (`add_user()`, `delete_user()`, `modify_user()`):
   - These functions handle user management tasks:
     - `add_user()`: Prompts for a username and password, creates a new user with `sudo useradd -m`, and sets the password using `echo "$username:$password" | sudo chpasswd`.
     - `delete_user()`: Prompts for a username and deletes the user with `sudo userdel -r`.
     - `modify_user()`: Prompts for a username and new password, and updates the user's password using `sudo chpasswd`.

4. Group Management Functions (`create_group()`, `remove_group()`):
   - These functions manage groups:
     - `create_group()`: Prompts for a group name and creates a new group using `sudo groupadd`.
     - `remove_group()`: Prompts for a group name and removes the group using `sudo groupdel`.

5. User-Group Management Functions (`add_to_group()`, `remove_from_group()`):
   - These functions manage adding and removing users from groups:
     - `add_to_group()`: Prompts for a username and group name, and adds the user to the group using `sudo usermod -aG`.
     - `remove_from_group()`: Prompts for a username and group name, and removes the user from the group using `sudo deluser`.

6. Backup Function (`backup_directory()`):
   - This function handles directory backup tasks:
     - Prompts for a directory and backup destination.
     - If a `--cron` option is provided (`cron_schedule` variable set), it schedules a backup using `crontab`.
     - Otherwise, it creates a compressed backup file using `tar`.

7. Main Script Execution:
   - Checks if any command-line arguments (`$#`) are provided.
   - Uses a `while` loop to iterate over each argument (`$1`) until there are no more (`$# -gt 0`).
   - `case` statement (`case $key in ...`) matches each argument (`$1`) against predefined options (`-a`, `-d`, `-m`, etc.) and calls corresponding functions.
   - For unrecognized options, it prints an error message and displays usage instructions.
    
Usage:
- Running the Script: Execute the script with `./script.sh` followed by desired options.
- Options: Use `-h` or `--help` to display usage instructions.
- User and Group Management: Add, delete, modify users; create or remove groups; add or remove users from groups.
- Backup: Backup directories, optionally scheduling backups using `--cron`.

This script provides a comprehensive set of administrative functions for managing users, groups, and backups on a Unix/Linux system. Adjustments can be made as needed for specific environments or additional functionality.