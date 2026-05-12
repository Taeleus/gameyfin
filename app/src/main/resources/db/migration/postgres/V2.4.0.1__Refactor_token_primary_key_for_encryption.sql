-- Flyway Migration: V2.4.0.1
-- Purpose: Refactor TOKEN table to support encryption on secret field by separating primary key from secret.
-- PostgreSQL conversion notes:
--   - RANDOM_UUID() is an H2 function. PostgreSQL equivalent is gen_random_uuid()
--     (available built-in since PostgreSQL 13; no extension required in PG17).
--   - ALTER TABLE ... DROP PRIMARY KEY is H2 syntax.
--     PostgreSQL requires: ALTER TABLE ... DROP CONSTRAINT <constraint_name>.
--     The PK constraint name on TOKEN.SECRET from V2.0.0 is the column-inline PRIMARY KEY,
--     which PostgreSQL names automatically as 'token_pkey'. We handle both that default
--     name and a DO block to find it dynamically for robustness.
--   - All other syntax is standard and compatible.

-- Step 1: Add new ID column (nullable initially to allow data population)
ALTER TABLE TOKEN
    ADD COLUMN ID CHARACTER VARYING(255);

-- Step 2: Populate ID column with new UUIDs for existing rows
-- gen_random_uuid() is the PostgreSQL equivalent of H2's RANDOM_UUID()
UPDATE TOKEN
SET ID = gen_random_uuid()::text
WHERE ID IS NULL;

-- Step 3: Make ID column non-null now that it has values
ALTER TABLE TOKEN
    ALTER COLUMN ID SET NOT NULL;

-- Step 4: Drop the primary key constraint on SECRET
-- PostgreSQL auto-names inline PKs as <table>_pkey; use a DO block for robustness.
DO $$
DECLARE
    v_constraint_name text;
BEGIN
    SELECT conname INTO v_constraint_name
    FROM pg_constraint
    WHERE conrelid = 'token'::regclass
      AND contype = 'p';

    IF v_constraint_name IS NOT NULL THEN
        EXECUTE 'ALTER TABLE TOKEN DROP CONSTRAINT ' || quote_ident(v_constraint_name);
    END IF;
END $$;

-- Step 5: Add primary key constraint on ID
ALTER TABLE TOKEN
    ADD PRIMARY KEY (ID);

-- Step 6: Add unique constraint on SECRET
ALTER TABLE TOKEN
    ADD CONSTRAINT UK_TOKEN_SECRET UNIQUE (SECRET);

-- Step 7: Create index on SECRET for fast lookups
CREATE INDEX IDX_TOKEN_SECRET ON TOKEN (SECRET);
