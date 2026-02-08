#!/bin/bash

# 06-databases.sh - Database installation with user/password configuration
# This script installs and configures Redis, PostgreSQL, and MariaDB

set -e

echo "=== Database Installation ==="

# Get credentials from environment or parameters
DB_USER="${1:-$USER}"
DB_PASS="${2:-}"

if [ -z "$DB_PASS" ]; then
    echo "Error: Database password is required"
    echo "Usage: $0 [username] [password]"
    exit 1
fi

# Install and configure Redis
install_redis() {
    echo "Installing Redis..."
    sudo apt-get install -y redis-server
    
    echo "Configuring Redis with password..."
    sudo redis-cli CONFIG SET requirepass "$DB_PASS"
    
    if [ "$DB_USER" != "default" ]; then
        sudo redis-cli ACL SETUSER "$DB_USER" on ">$DB_PASS" allcommands allkeys
    fi
    
    echo "✅ Redis installed and configured!"
}

# Install and configure PostgreSQL
install_postgresql() {
    echo "Installing PostgreSQL..."
    sudo apt-get install -y postgresql postgresql-contrib
    
    echo "Configuring PostgreSQL user..."
    sudo -u postgres psql -c "CREATE USER \"$DB_USER\" WITH PASSWORD '$DB_PASS';"
    sudo -u postgres psql -c "ALTER USER \"$DB_USER\" CREATEDB;"
    
    echo "✅ PostgreSQL installed and configured!"
}

# Install and configure MariaDB
install_mariadb() {
    echo "Installing MariaDB..."
    sudo apt-get install -y mariadb-server
    
    echo "Configuring MariaDB user..."
    sudo mysql -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
    sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'localhost' WITH GRANT OPTION;"
    sudo mysql -e "FLUSH PRIVILEGES;"
    
    echo "✅ MariaDB installed and configured!"
}

# Parse selected databases (passed as additional arguments starting from $3)
shift 2  # Remove username and password arguments
selected_databases="$@"

if [ -z "$selected_databases" ]; then
    selected_databases="redis postgresql mariadb"
fi

echo "Installing selected databases: $selected_databases"
echo "Using credentials - User: $DB_USER"

for db in $selected_databases; do
    case $db in
        "redis")
            install_redis
            ;;
        "postgresql"|"postgres")
            install_postgresql
            ;;
        "mariadb"|"mysql")
            install_mariadb
            ;;
        *)
            echo "Unknown database: $db"
            ;;
    esac
done

echo "✅ Database installation completed!"
echo "ℹ️  Database credentials:"
echo "   Username: $DB_USER"
echo "   Password: [hidden]"