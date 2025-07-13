#!/bin/bash

# Configuration
BACKUP_DIR="/root/backup/mariadb"
DB_USER="root"
DB_PASSWORD="SUPERSECRETPASS"
DATE=$(date +"%Y-%m-%d")
BACKUP_FILE="$BACKUP_DIR/$DATE.sql.gz"

# Create backup directory if not exists
mkdir -p "$BACKUP_DIR"

# Dump and compress
mysqldump -u "$DB_USER" -p"$DB_PASSWORD" --all-databases | gzip > "$BACKUP_FILE"

# Remove backups older than 30 days
find "$BACKUP_DIR" -name "mariadb-*.sql.gz" -type f -mtime +30 -delete
