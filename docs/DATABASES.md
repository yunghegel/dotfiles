# Database Guide

A guide to Redis, PostgreSQL, and MariaDB installation and usage.

## Table of Contents

1. [Installation](#installation)
2. [Redis](#redis)
3. [PostgreSQL](#postgresql)
4. [MariaDB](#mariadb)
5. [Connection Strings](#connection-strings)

---

## Installation

Run the installer:
```bash
./installers/06-databases.sh <username> <password> [databases...]
```

**Examples:**
```bash
# Install all databases
./installers/06-databases.sh myuser mypassword

# Install specific databases
./installers/06-databases.sh myuser mypassword redis postgresql
./installers/06-databases.sh myuser mypassword mariadb
```

---

## Redis

### Overview

Redis is an in-memory data structure store used as:
- Cache
- Message broker
- Session store
- Real-time analytics

### Configuration

**Default settings after installation:**
- Port: 6379
- Password: Set during installation
- ACL: User created with provided credentials

### Basic Commands

```bash
# Connect to Redis CLI
redis-cli

# Authenticate
AUTH password
# or
AUTH username password

# Test connection
PING
# Response: PONG
```

### Data Types and Operations

**Strings:**
```bash
SET key "value"
GET key
INCR counter
DECR counter
APPEND key " more"
SETEX key 3600 "expires in 1 hour"
```

**Lists:**
```bash
LPUSH mylist "first"
RPUSH mylist "last"
LRANGE mylist 0 -1      # Get all elements
LPOP mylist
RPOP mylist
LLEN mylist
```

**Sets:**
```bash
SADD myset "member1" "member2"
SMEMBERS myset
SISMEMBER myset "member1"
SREM myset "member1"
SUNION set1 set2
SINTER set1 set2
```

**Hashes:**
```bash
HSET user:1 name "John" age 30
HGET user:1 name
HGETALL user:1
HMSET user:1 email "john@example.com" city "NYC"
HINCRBY user:1 age 1
```

**Sorted Sets:**
```bash
ZADD leaderboard 100 "player1" 200 "player2"
ZRANGE leaderboard 0 -1 WITHSCORES
ZRANK leaderboard "player1"
ZINCRBY leaderboard 50 "player1"
```

### Key Management

```bash
KEYS pattern        # Find keys (use SCAN in production)
SCAN 0 MATCH "user:*" COUNT 100
EXISTS key
DEL key
EXPIRE key 3600     # Set TTL in seconds
TTL key             # Check remaining time
PERSIST key         # Remove expiration
TYPE key            # Get data type
```

### Pub/Sub

```bash
# Subscriber
SUBSCRIBE channel1 channel2
PSUBSCRIBE user:*   # Pattern subscribe

# Publisher (different connection)
PUBLISH channel1 "Hello!"
```

### Administration

```bash
# Server info
INFO
INFO memory
INFO replication

# Client management
CLIENT LIST
CLIENT KILL id 123

# Database operations
SELECT 1            # Switch to database 1
DBSIZE              # Number of keys
FLUSHDB             # Clear current database
FLUSHALL            # Clear all databases (careful!)

# Persistence
BGSAVE              # Background save
LASTSAVE            # Last save timestamp
```

---

## PostgreSQL

### Overview

PostgreSQL is a powerful, open-source relational database with:
- ACID compliance
- JSON support
- Full-text search
- Extensibility

### Configuration

**Default settings after installation:**
- Port: 5432
- User: Created during installation
- Privileges: CREATEDB

### Connecting

```bash
# Connect with psql
psql -U username -d database_name
psql -h localhost -U username -d database_name

# Connect with URL
psql postgresql://username:password@localhost:5432/database
```

### psql Commands

| Command | Description |
|---------|-------------|
| `\l` | List databases |
| `\c dbname` | Connect to database |
| `\dt` | List tables |
| `\d tablename` | Describe table |
| `\du` | List users/roles |
| `\dn` | List schemas |
| `\df` | List functions |
| `\di` | List indexes |
| `\q` | Quit |
| `\x` | Toggle expanded output |
| `\timing` | Toggle query timing |
| `\i file.sql` | Execute SQL file |
| `\e` | Edit in external editor |

### Database Operations

```sql
-- Create database
CREATE DATABASE myapp;
CREATE DATABASE myapp WITH OWNER = myuser;

-- Drop database
DROP DATABASE myapp;

-- Create user
CREATE USER myuser WITH PASSWORD 'password';
CREATE ROLE myuser LOGIN PASSWORD 'password';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE myapp TO myuser;
GRANT SELECT, INSERT ON table TO myuser;
GRANT USAGE ON SCHEMA public TO myuser;

-- List connections
SELECT * FROM pg_stat_activity;

-- Terminate connections
SELECT pg_terminate_backend(pid) FROM pg_stat_activity
WHERE datname = 'myapp' AND pid <> pg_backend_pid();
```

### Table Operations

```sql
-- Create table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metadata JSONB
);

-- Create with constraints
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    total DECIMAL(10,2) CHECK (total >= 0),
    status VARCHAR(20) DEFAULT 'pending'
);

-- Indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_metadata ON users USING GIN(metadata);

-- Alter table
ALTER TABLE users ADD COLUMN phone VARCHAR(20);
ALTER TABLE users DROP COLUMN phone;
ALTER TABLE users RENAME COLUMN name TO full_name;
ALTER TABLE users ALTER COLUMN email TYPE TEXT;
```

### Queries

```sql
-- Basic CRUD
INSERT INTO users (email, name) VALUES ('john@example.com', 'John');
INSERT INTO users (email, name) VALUES ('jane@example.com', 'Jane')
  RETURNING id, email;

SELECT * FROM users WHERE email LIKE '%@example.com';
SELECT id, email FROM users ORDER BY created_at DESC LIMIT 10;

UPDATE users SET name = 'John Doe' WHERE id = 1 RETURNING *;

DELETE FROM users WHERE id = 1;

-- JSON operations
SELECT metadata->>'key' FROM users;
SELECT * FROM users WHERE metadata @> '{"active": true}';
UPDATE users SET metadata = metadata || '{"verified": true}' WHERE id = 1;

-- Aggregations
SELECT COUNT(*), status FROM orders GROUP BY status;
SELECT user_id, SUM(total) FROM orders GROUP BY user_id HAVING SUM(total) > 100;

-- Joins
SELECT u.name, o.total
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.status = 'completed';

-- CTEs
WITH recent_orders AS (
    SELECT * FROM orders WHERE created_at > NOW() - INTERVAL '7 days'
)
SELECT user_id, COUNT(*) FROM recent_orders GROUP BY user_id;
```

### Backup and Restore

```bash
# Backup database
pg_dump -U username dbname > backup.sql
pg_dump -U username -Fc dbname > backup.dump  # Custom format

# Backup all databases
pg_dumpall -U username > all_databases.sql

# Restore
psql -U username dbname < backup.sql
pg_restore -U username -d dbname backup.dump
```

---

## MariaDB

### Overview

MariaDB is a MySQL-compatible relational database with:
- Drop-in MySQL replacement
- Additional storage engines
- Better performance
- Active development

### Configuration

**Default settings after installation:**
- Port: 3306
- User: Created during installation
- Host: localhost
- Privileges: ALL with GRANT OPTION

### Connecting

```bash
# Connect with mysql client
mysql -u username -p
mysql -u username -p database_name
mysql -h localhost -u username -p database_name

# Non-interactive
mysql -u username -ppassword -e "SELECT 1"
```

### MySQL Client Commands

| Command | Description |
|---------|-------------|
| `SHOW DATABASES;` | List databases |
| `USE dbname;` | Select database |
| `SHOW TABLES;` | List tables |
| `DESCRIBE tablename;` | Show table structure |
| `SHOW CREATE TABLE t;` | Show CREATE statement |
| `SHOW PROCESSLIST;` | Active connections |
| `SHOW VARIABLES;` | Server variables |
| `STATUS;` | Connection info |
| `\q` or `exit` | Quit |

### Database Operations

```sql
-- Create database
CREATE DATABASE myapp;
CREATE DATABASE myapp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Drop database
DROP DATABASE myapp;

-- Create user
CREATE USER 'myuser'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'myuser'@'%' IDENTIFIED BY 'password';  -- Remote access

-- Grant privileges
GRANT ALL PRIVILEGES ON myapp.* TO 'myuser'@'localhost';
GRANT SELECT, INSERT, UPDATE ON myapp.* TO 'reader'@'localhost';
FLUSH PRIVILEGES;

-- Show grants
SHOW GRANTS FOR 'myuser'@'localhost';

-- Revoke privileges
REVOKE ALL PRIVILEGES ON myapp.* FROM 'myuser'@'localhost';
```

### Table Operations

```sql
-- Create table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Create with foreign key
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    total DECIMAL(10,2),
    status ENUM('pending', 'completed', 'cancelled') DEFAULT 'pending',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Indexes
CREATE INDEX idx_email ON users(email);
CREATE FULLTEXT INDEX idx_name ON users(name);

-- Alter table
ALTER TABLE users ADD COLUMN phone VARCHAR(20);
ALTER TABLE users DROP COLUMN phone;
ALTER TABLE users MODIFY COLUMN name VARCHAR(200);
ALTER TABLE users CHANGE name full_name VARCHAR(100);
```

### Queries

```sql
-- Basic CRUD
INSERT INTO users (email, name) VALUES ('john@example.com', 'John');
INSERT INTO users (email, name) VALUES
  ('jane@example.com', 'Jane'),
  ('bob@example.com', 'Bob');

SELECT * FROM users WHERE email LIKE '%@example.com';
SELECT id, email FROM users ORDER BY created_at DESC LIMIT 10;

UPDATE users SET name = 'John Doe' WHERE id = 1;

DELETE FROM users WHERE id = 1;

-- Replace (insert or update)
REPLACE INTO users (id, email, name) VALUES (1, 'john@example.com', 'John');

-- Insert on duplicate key
INSERT INTO users (email, name) VALUES ('john@example.com', 'John')
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Full-text search
SELECT * FROM users WHERE MATCH(name) AGAINST('John' IN NATURAL LANGUAGE MODE);

-- Joins
SELECT u.name, o.total
FROM users u
INNER JOIN orders o ON u.id = o.user_id
WHERE o.status = 'completed';
```

### Backup and Restore

```bash
# Backup database
mysqldump -u username -p dbname > backup.sql
mysqldump -u username -p --all-databases > all_databases.sql

# Backup with structure only
mysqldump -u username -p --no-data dbname > schema.sql

# Backup with data only
mysqldump -u username -p --no-create-info dbname > data.sql

# Restore
mysql -u username -p dbname < backup.sql
```

---

## Connection Strings

### Redis

```
# Standard format
redis://username:password@localhost:6379/0

# With SSL
rediss://username:password@localhost:6379/0

# Node.js (ioredis)
redis://localhost:6379

# Python
redis://username:password@localhost:6379/0
```

### PostgreSQL

```
# Standard format
postgresql://username:password@localhost:5432/database

# With options
postgresql://username:password@localhost:5432/database?sslmode=require

# Node.js (pg)
postgres://username:password@localhost:5432/database

# JDBC
jdbc:postgresql://localhost:5432/database
```

### MariaDB / MySQL

```
# Standard format
mysql://username:password@localhost:3306/database

# With options
mysql://username:password@localhost:3306/database?charset=utf8mb4

# JDBC
jdbc:mysql://localhost:3306/database

# Python (SQLAlchemy)
mysql+pymysql://username:password@localhost:3306/database
```

---

## Service Management

```bash
# Redis
sudo systemctl start redis
sudo systemctl stop redis
sudo systemctl restart redis
sudo systemctl status redis

# PostgreSQL
sudo systemctl start postgresql
sudo systemctl stop postgresql
sudo systemctl restart postgresql
sudo systemctl status postgresql

# MariaDB
sudo systemctl start mariadb
sudo systemctl stop mariadb
sudo systemctl restart mariadb
sudo systemctl status mariadb
```

---

## Troubleshooting

### Connection Refused

```bash
# Check if service is running
sudo systemctl status <service>

# Check listening ports
ss -tlnp | grep <port>
netstat -tlnp | grep <port>
```

### Authentication Failed

```bash
# PostgreSQL - check pg_hba.conf
sudo cat /etc/postgresql/*/main/pg_hba.conf

# MariaDB - reset password
sudo mysql
ALTER USER 'user'@'localhost' IDENTIFIED BY 'newpassword';
```

### Permission Denied

```sql
-- PostgreSQL
GRANT ALL PRIVILEGES ON DATABASE dbname TO username;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO username;

-- MariaDB
GRANT ALL PRIVILEGES ON dbname.* TO 'username'@'localhost';
FLUSH PRIVILEGES;
```
