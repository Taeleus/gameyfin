# Gameyfin: Existing H2 → PostgreSQL Migration Guide

## Prerequisites
- Gameyfin container **stopped**
- pgAdmin connected to your PostgreSQL server
- `h2_to_postgres.py` in the same folder as your export

---

## Steps

### 1. Set up PostgreSQL

Before anything else, you need to create a dedicated user and database for Gameyfin. In pgAdmin, open the **Query Tool** connected to your PostgreSQL server (not a specific database) and run:

```sql
-- Create the Gameyfin user
CREATE USER gameyfin WITH PASSWORD 'your_password';

-- Create the Gameyfin database owned by that user
CREATE DATABASE gameyfin OWNER gameyfin;
```

Replace `your_password` with a strong password of your choice. Make note of it — you'll need it for the container environment variables in Step 6.

---

### 2. Export the H2 database

Run this on Unraid (container must be stopped first):

```bash
docker run --rm \
  -v /mnt/user/appdata/gameyfin/db:/db \
  eclipse-temurin:25-jdk-jammy bash -c "
    apt-get update -qq && apt-get install -y -qq curl &&
    curl -sL https://repo1.maven.org/maven2/com/h2database/h2/2.3.232/h2-2.3.232.jar -o /tmp/h2.jar &&
    java -cp /tmp/h2.jar org.h2.tools.Script \
      -url 'jdbc:h2:file:/db/gameyfin_db;AUTO_SERVER=FALSE' \
      -user gfadmin \
      -password gameyfin \
      -script /db/export.sql
  "
```

The export will be saved to `/mnt/user/appdata/gameyfin/db/export.sql`.

---

### 3. Convert the export for PostgreSQL

```bash
python h2_to_postgres.py export.sql gameyfin_postgres.sql
```

---

### 4. Import into PostgreSQL

In pgAdmin, connect to the `gameyfin` database you created in Step 1, open the **Query Tool**, then load and run `gameyfin_postgres.sql`.

> **Reimporting?** If you're redoing the import, first drop and recreate the database before running the script:
> 1. Disconnect from the database (right-click → Disconnect)
> 2. Drop it (right-click → Delete/Drop)
> 3. Recreate it: right-click Databases → Create → Database, name: `gameyfin`, owner: `gameyfin`
> 4. Then run `gameyfin_postgres.sql`

---

### 5. Fix Flyway checksums

Still in the pgAdmin Query Tool on the `gameyfin` database, run:

```sql
UPDATE flyway_schema_history
SET checksum = NULL
WHERE success = TRUE;
```

This clears the H2 migration checksums so Flyway accepts the PostgreSQL scripts on first boot.

---

### 6. Start the container

Add these environment variables to your Unraid container template:

| Variable | Value |
|---|---|
| `SPRING_DATASOURCE_URL` | `jdbc:postgresql://YourPostgresIP:5432/gameyfin` |
| `SPRING_DATASOURCE_USERNAME` | `gameyfin` |
| `SPRING_DATASOURCE_PASSWORD` | `your_password` |
| `SPRING_DATASOURCE_DRIVER_CLASS_NAME` | `org.postgresql.Driver` |
| `SPRING_FLYWAY_LOCATIONS` | `classpath:db/migration_postgres` |

Start the container. On first boot Flyway will validate and Gameyfin will be running on PostgreSQL.

---

