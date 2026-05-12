-- Flyway Migration: V2.1.0.1
-- Purpose:
-- 1. Drop unique constraints on GAME.COVER_IMAGE_ID and GAME.HEADER_IMAGE_ID
-- 2. Rename all remaining UK*/FK* constraints to human-readable names (idempotent)
-- PostgreSQL conversion notes:
--   - Removed all H2 CREATE ALIAS / CALL RENAME_CONSTRAINT_IF_EXISTS blocks entirely.
--     PostgreSQL has no CREATE ALIAS mechanism. Constraint renaming is done with
--     ALTER TABLE ... RENAME CONSTRAINT, wrapped in DO $$ blocks for idempotency.
--   - DROP CONSTRAINT IF EXISTS is valid PostgreSQL syntax.

/******************************************************************************************
 * 1. Drop the two unwanted unique constraints on GAME
 ******************************************************************************************/
ALTER TABLE GAME DROP CONSTRAINT IF EXISTS UK52RQ62FLPBNTI77BYKM7UAHKQ; -- COVER_IMAGE_ID unique
ALTER TABLE GAME DROP CONSTRAINT IF EXISTS UK30B16LLQV54H40XIOGP7T9P35; -- HEADER_IMAGE_ID unique

/******************************************************************************************
 * 2. Rename remaining UNIQUE constraints (UK*) — idempotent via DO blocks
 ******************************************************************************************/
DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uk4ucnyhr8i0urhwdudfahkob9e' AND conrelid = 'company'::regclass) THEN
        ALTER TABLE COMPANY RENAME CONSTRAINT UK4UCNYHR8I0URHWDUDFAHKOB9E TO UQ_COMPANY_NAME_TYPE;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ukj3gsatfahewfolseaj29o3kyt' AND conrelid = 'directory_mapping'::regclass) THEN
        ALTER TABLE DIRECTORY_MAPPING RENAME CONSTRAINT UKJ3GSATFAHEWFOLSEAJ29O3KYT TO UQ_DIRECTORY_MAPPING_INTERNAL_PATH;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uk4wxn9fpxfq8qxpsb7fy0o3noa' AND conrelid = 'game'::regclass) THEN
        ALTER TABLE GAME RENAME CONSTRAINT UK4WXN9FPXFQ8QXPSB7FY0O3NOA TO UQ_GAME_PATH;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ukbde7m3tkhieeybinm2ed0b6x1' AND conrelid = 'game_images'::regclass) THEN
        ALTER TABLE GAME_IMAGES RENAME CONSTRAINT UKBDE7M3TKHIEEYBINM2ED0B6X1 TO UQ_GAME_IMAGES_IMAGE_ID;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ukb5um4cadbnc6uc8dvomo81n5f' AND conrelid = 'library_directories'::regclass) THEN
        ALTER TABLE LIBRARY_DIRECTORIES RENAME CONSTRAINT UKB5UM4CADBNC6UC8DVOMO81N5F TO UQ_LIBRARY_DIRECTORIES_DIRECTORY_ID;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uk3e4vb9nqxpy27vmta27gu5fy8' AND conrelid = 'library_games'::regclass) THEN
        ALTER TABLE LIBRARY_GAMES RENAME CONSTRAINT UK3E4VB9NQXPY27VMTA27GU5FY8 TO UQ_LIBRARY_GAMES_GAME_ID;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uk6dotkott2kjsp8vw4d0m25fb7' AND conrelid = 'users'::regclass) THEN
        ALTER TABLE USERS RENAME CONSTRAINT UK6DOTKOTT2KJSP8VW4D0M25FB7 TO UQ_USERS_EMAIL;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ukr43af9ap4edm43mmtq01oddj6' AND conrelid = 'users'::regclass) THEN
        ALTER TABLE USERS RENAME CONSTRAINT UKR43AF9AP4EDM43MMTQ01ODDJ6 TO UQ_USERS_USERNAME;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ukrsulcn2gynjy3cddpwmosv881' AND conrelid = 'users'::regclass) THEN
        ALTER TABLE USERS RENAME CONSTRAINT UKRSULCN2GYNJY3CDDPWMOSV881 TO UQ_USERS_AVATAR_ID;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'ukhw6u2y9flwpti57qb7k0p27bl' AND conrelid = 'game_field_metadata'::regclass) THEN
        ALTER TABLE GAME_FIELD_METADATA RENAME CONSTRAINT UKHW6U2Y9FLWPTI57QB7K0P27BL TO UQ_GAME_FIELD_METADATA_SOURCE_ID;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'uk1l5oah0uoouv4v5a9p0pak77x' AND conrelid = 'game_fields'::regclass) THEN
        ALTER TABLE GAME_FIELDS RENAME CONSTRAINT UK1L5OAH0UOOUV4V5A9P0PAK77X TO UQ_GAME_FIELDS_FIELD_METADATA_ID;
    END IF;
END $$;

/******************************************************************************************
 * 3. Rename FOREIGN KEY constraints (FK*)
 ******************************************************************************************/
DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk6cvb43reaysnypi0xdy6hqtvf' AND conrelid = 'game'::regclass) THEN
        ALTER TABLE GAME RENAME CONSTRAINT FK6CVB43REAYSNYPI0XDY6HQTVF TO FK_GAME_COVER_IMAGE;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk8n86ndpgkmoo7yolx6hl8n84g' AND conrelid = 'game'::regclass) THEN
        ALTER TABLE GAME RENAME CONSTRAINT FK8N86NDPGKMOO7YOLX6HL8N84G TO FK_GAME_HEADER_IMAGE;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fkiuvr8xfb63t1k6t43eyyxvo2c' AND conrelid = 'game'::regclass) THEN
        ALTER TABLE GAME RENAME CONSTRAINT FKIUVR8XFB63T1K6T43EYYXVO2C TO FK_GAME_LIBRARY;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fkb12po9l2b9ojbaihc82mm2qxb' AND conrelid = 'game_developers'::regclass) THEN
        ALTER TABLE GAME_DEVELOPERS RENAME CONSTRAINT FKB12PO9L2B9OJBAIHC82MM2QXB TO FK_GAME_DEVELOPERS_COMPANY;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fks4ijsvpij53dsl143xvrgbs09' AND conrelid = 'game_developers'::regclass) THEN
        ALTER TABLE GAME_DEVELOPERS RENAME CONSTRAINT FKS4IJSVPIJ53DSL143XVRGBS09 TO FK_GAME_DEVELOPERS_GAME;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk63xltct60scimpm06k8bhbe4a' AND conrelid = 'game_features'::regclass) THEN
        ALTER TABLE GAME_FEATURES RENAME CONSTRAINT FK63XLTCT60SCIMPM06K8BHBE4A TO FK_GAME_FEATURES_GAME;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fkdtsx09yopd98e0luewrusjd9e' AND conrelid = 'game_genres'::regclass) THEN
        ALTER TABLE GAME_GENRES RENAME CONSTRAINT FKDTSX09YOPD98E0LUEWRUSJD9E TO FK_GAME_GENRES_GAME;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk5ywv1dmxcm2vsqueb7rhq3jk9' AND conrelid = 'game_images'::regclass) THEN
        ALTER TABLE GAME_IMAGES RENAME CONSTRAINT FK5YWV1DMXCM2VSQUEB7RHQ3JK9 TO FK_GAME_IMAGES_IMAGE;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fkowcpucv45ox8gt28txgvhf1aa' AND conrelid = 'game_images'::regclass) THEN
        ALTER TABLE GAME_IMAGES RENAME CONSTRAINT FKOWCPUCV45OX8GT28TXGVHF1AA TO FK_GAME_IMAGES_GAME;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fkmvf6hnj7romqqm2ex70a9nvac' AND conrelid = 'game_keywords'::regclass) THEN
        ALTER TABLE GAME_KEYWORDS RENAME CONSTRAINT FKMVF6HNJ7ROMQQM2EX70A9NVAC TO FK_GAME_KEYWORDS_GAME;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fkhueeng29y1ghbrdi5qhguxh6e' AND conrelid = 'game_perspectives'::regclass) THEN
        ALTER TABLE GAME_PERSPECTIVES RENAME CONSTRAINT FKHUEENG29Y1GHBRDI5QHGUXH6E TO FK_GAME_PERSPECTIVES_GAME;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk49r2kb61lij54bqb4vntst97n' AND conrelid = 'game_publishers'::regclass) THEN
        ALTER TABLE GAME_PUBLISHERS RENAME CONSTRAINT FK49R2KB61LIJ54BQB4VNTST97N TO FK_GAME_PUBLISHERS_GAME;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fkngld5esgrbrh95j5bjf0hef85' AND conrelid = 'game_publishers'::regclass) THEN
        ALTER TABLE GAME_PUBLISHERS RENAME CONSTRAINT FKNGLD5ESGRBRH95J5BJF0HEF85 TO FK_GAME_PUBLISHERS_COMPANY;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fkrv351jxlioy0a17y5bbjj6fw4' AND conrelid = 'game_themes'::regclass) THEN
        ALTER TABLE GAME_THEMES RENAME CONSTRAINT FKRV351JXLIOY0A17Y5BBJJ6FW4 TO FK_GAME_THEMES_GAME;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fkjkkwo8wds086as7b2kslsvkm6' AND conrelid = 'game_video_urls'::regclass) THEN
        ALTER TABLE GAME_VIDEO_URLS RENAME CONSTRAINT FKJKKWO8WDS086AS7B2KSLSVKM6 TO FK_GAME_VIDEO_URLS_GAME;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fkfnckiu58i9l89mlxv388dy13b' AND conrelid = 'library_directories'::regclass) THEN
        ALTER TABLE LIBRARY_DIRECTORIES RENAME CONSTRAINT FKFNCKIU58I9L89MLXV388DY13B TO FK_LIBRARY_DIRECTORIES_LIBRARY;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fkjdxs58q1irtu0idp6dxjhwapm' AND conrelid = 'library_directories'::regclass) THEN
        ALTER TABLE LIBRARY_DIRECTORIES RENAME CONSTRAINT FKJDXS58Q1IRTU0IDP6DXJHWAPM TO FK_LIBRARY_DIRECTORIES_DIRECTORY_MAPPING;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk6c71eedm0i2n1jxde9bobwg5m' AND conrelid = 'library_games'::regclass) THEN
        ALTER TABLE LIBRARY_GAMES RENAME CONSTRAINT FK6C71EEDM0I2N1JXDE9BOBWG5M TO FK_LIBRARY_GAMES_LIBRARY;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fkdkkkes3day0wj1qmv42kmmfdk' AND conrelid = 'library_games'::regclass) THEN
        ALTER TABLE LIBRARY_GAMES RENAME CONSTRAINT FKDKKKES3DAY0WJ1QMV42KMMFDK TO FK_LIBRARY_GAMES_GAME;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fksj51wc2lbnnxy0lklweli6vsb' AND conrelid = 'library_unmatched_paths'::regclass) THEN
        ALTER TABLE LIBRARY_UNMATCHED_PATHS RENAME CONSTRAINT FKSJ51WC2LBNNXY0LKLWELI6VSB TO FK_LIBRARY_UNMATCHED_PATHS_LIBRARY;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk1csd5qd7vjt7btta3g7hgybux' AND conrelid = 'game_original_ids'::regclass) THEN
        ALTER TABLE GAME_ORIGINAL_IDS RENAME CONSTRAINT FK1CSD5QD7VJT7BTTA3G7HGYBUX TO FK_GAME_ORIGINAL_IDS_GAME;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fkmt0xwlpwpu9np0q289jbahjry' AND conrelid = 'game_original_ids'::regclass) THEN
        ALTER TABLE GAME_ORIGINAL_IDS RENAME CONSTRAINT FKMT0XWLPWPU9NP0Q289JBAHJRY TO FK_GAME_ORIGINAL_IDS_PLUGIN;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fk19lflpg5seis4dwrm2lvjlxfv' AND conrelid = 'users'::regclass) THEN
        ALTER TABLE USERS RENAME CONSTRAINT FK19LFLPG5SEIS4DWRM2LVJLXFV TO FK_USERS_AVATAR_IMAGE;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fknjc4qss5apfhtpwp42oaeal5g' AND conrelid = 'game_field_source'::regclass) THEN
        ALTER TABLE GAME_FIELD_SOURCE RENAME CONSTRAINT FKNJC4QSS5APFHTPWP42OAEAL5G TO FK_GAME_FIELD_SOURCE_PLUGIN;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fksr1bgtx5xjvmal7fefgl982tp' AND conrelid = 'game_field_source'::regclass) THEN
        ALTER TABLE GAME_FIELD_SOURCE RENAME CONSTRAINT FKSR1BGTX5XJVMAL7FEFGL982TP TO FK_GAME_FIELD_SOURCE_USER;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fkq4rc409tp8fubttm733pmjd8f' AND conrelid = 'game_field_metadata'::regclass) THEN
        ALTER TABLE GAME_FIELD_METADATA RENAME CONSTRAINT FKQ4RC409TP8FUBTTM733PMJD8F TO FK_GAME_FIELD_METADATA_SOURCE;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fklnepi7ywci86yh21ko9wd9pyf' AND conrelid = 'game_fields'::regclass) THEN
        ALTER TABLE GAME_FIELDS RENAME CONSTRAINT FKLNEPI7YWCI86YH21KO9WD9PYF TO FK_GAME_FIELDS_GAME;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fkt8flofdapx5m746s5lw54c5b3' AND conrelid = 'game_fields'::regclass) THEN
        ALTER TABLE GAME_FIELDS RENAME CONSTRAINT FKT8FLOFDAPX5M746S5LW54C5B3 TO FK_GAME_FIELDS_METADATA;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fkghoialapti5jfej506jbb1o8y' AND conrelid = 'token'::regclass) THEN
        ALTER TABLE TOKEN RENAME CONSTRAINT FKGHOIALAPTI5JFEJ506JBB1O8Y TO FK_TOKEN_CREATOR_USER;
    END IF;
END $$;

DO $$ BEGIN
    IF EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fkhfh9dx7w3ubf1co1vdev94g3f' AND conrelid = 'user_roles'::regclass) THEN
        ALTER TABLE USER_ROLES RENAME CONSTRAINT FKHFH9DX7W3UBF1CO1VDEV94G3F TO FK_USER_ROLES_USER;
    END IF;
END $$;

-- End of migration
