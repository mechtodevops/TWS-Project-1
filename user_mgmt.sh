#!/bin/bash

# Function to display usage instructions
display_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -a, --add-user       Add a new user"
    echo "  -d, --delete-user    Delete an existing user"
    echo "  -m, --modify-user    Modify an existing user"
    echo "  -g, --create-group   Create a new group"
    echo "  -r, --remove-group   Remove an existing group"
    echo "  -u, --add-to-group   Add user to a group"
    echo "  -q, --remove-from-group  Remove user from a group"
    echo "  -b, --backup         Backup a directory"
    echo "      --cron CRON      Schedule backup using cron format (optional)"
    echo "  -h, --help           Display this help message"
    exit 1
}

# Function to add a new user
add_user() {
    read -p "Enter username: " username
    read -sp "Enter password: " password
    sudo useradd -m "$username"
    echo "$username:$password" | sudo chpasswd
    echo "User '$username' added successfully"
}

# Function to delete a user
delete_user() {
    read -p "Enter username to delete: " username
    sudo userdel -r "$username"
    echo "User '$username' deleted successfully"
}

# Function to modify a user
modify_user() {
    read -p "Enter username to modify: " username
    read -sp "Enter new password: " password
    echo "$username:$password" | sudo chpasswd
    echo "Password for user '$username' modified successfully"
}

# Function to create a new group
create_group() {
    read -p "Enter group name: " groupname
    sudo groupadd "$groupname"
    echo "Group '$groupname' created successfully"
}

# Function to remove a group
remove_group() {
    read -p "Enter group name to remove: " groupname
    sudo groupdel "$groupname"
    echo "Group '$groupname' removed successfully"
}

# Function to add user to a group
add_to_group() {
    read -p "Enter username: " username
    read -p "Enter group name: " groupname
    sudo usermod -aG "$groupname" "$username"
    echo "User '$username' added to group '$groupname' successfully"
}

# Function to remove user from a group
remove_from_group() {
    read -p "Enter username: " username
    read -p "Enter group name: " groupname
    sudo deluser "$username" "$groupname"
    echo "User '$username' removed from group '$groupname' successfully"
}

# Function to backup a directory
backup_directory() {
    read -p "Enter directory to backup: " directory
    read -p "Enter backup destination: " destination
    if [[ -n $cron_schedule ]]; then
        cronjob="$cron_schedule /bin/bash $(pwd)/backup.sh -b \"$directory\" \"$destination\""
        (crontab -l ; echo "$cronjob") | sort - | uniq - | crontab -
        echo "Backup scheduled with custom cron: $cron_schedule"
    else
        tar -czf "$destination/backup_$(date +%Y-%m-%d_%H-%M-%S).tar.gz" "$directory"
        echo "Backup completed successfully"
    fi
}

# Main script

# Check if arguments are provided
if [[ $# -eq 0 ]]; then
    display_usage
fi

# Parse command-line options
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -a|--add-user)
            add_user
            ;;
        -d|--delete-user)
            delete_user
            ;;
        -m|--modify-user)
            modify_user
            ;;
        -g|--create-group)
            create_group
            ;;
        -r|--remove-group)
            remove_group
            ;;
        -u|--add-to-group)
            add_to_group
            ;;
        -q|--remove-from-group)
            remove_from_group
            ;;
        -b|--backup)
            backup_directory
            ;;
        --cron)
            cron_schedule="$2"
            shift
            ;;
        -h|--help)
            display_usage
            ;;
        *)
            echo "Error: Invalid option '$key'"
            display_usage
            ;;
    esac
    shift
done