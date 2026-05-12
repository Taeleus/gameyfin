-- Flyway Migration: V2.3.0.4
-- Purpose: Rename config key from 'library.allow-public-access' to 'security.allow-public-access'.
-- PostgreSQL notes: Fully compatible. Standard UPDATE syntax.

UPDATE APP_CONFIG
SET "key" = 'security.allow-public-access'
WHERE "key" = 'library.allow-public-access';
