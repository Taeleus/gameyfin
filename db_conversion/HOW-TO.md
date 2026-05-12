.db export to postgres
# 1. Export from H2 (container stopped)
docker run --rm \
  -v /mnt/user/appdata/gameyfin/db:/db \
  eclipse-temurin:25-jdk-jammy bash -c "
    apt-get update -qq && apt-get install -y -qq curl &&
    curl -sL https://repo1.maven.org/maven2/com/h2database/h2/2.3.232/h2-2.3.232.jar -o /tmp/h2.jar &&
    java -cp /tmp/h2.jar org.h2.tools.Script \
      -url 'jdbc:h2:file:/db/gameyfin_db;AUTO_SERVER=FALSE' \
      -user gfadmin -password gameyfin \
      -script /db/export.sql
  "

# 2. Convert
python3 h2_to_postgres.py export.sql gameyfin_postgres.sql

# 3. Drop/recreate DB in pgAdmin, run gameyfin_postgres.sql