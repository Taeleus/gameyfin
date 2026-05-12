-- Flyway Migration: V2.3.0.1
-- Purpose: Convert config values from old format to JSON format for consistency.
-- PostgreSQL conversion notes:
--   - Removed all H2 CREATE ALIAS / DROP ALIAS blocks entirely. PostgreSQL has no
--     CREATE ALIAS mechanism and cannot call arbitrary Java methods from SQL.
--   - The H2 alias functions (toJsonString, toJsonBoolean, toJsonInt, toJsonArray) are
--     reimplemented here using native PostgreSQL expressions:
--       toJsonString(v)  → to_json(v::text)::text           (wraps value in JSON quotes)
--       toJsonBoolean(v) → CASE WHEN lower(v) IN ('true','1','yes') THEN 'true' ELSE 'false' END
--       toJsonInt(v)     → v::bigint::text                  (validates and normalises)
--       toJsonArray(v)   → array_to_json(string_to_array(v, ','))::text
--                          (converts comma-separated string to JSON array)
--   - All UPDATE statements are otherwise identical.

-- Convert String values to JSON format (wrap in quotes)
UPDATE APP_CONFIG SET "value" = to_json("value"::text)::text WHERE "key" = 'logs.folder';
UPDATE APP_CONFIG SET "value" = to_json("value"::text)::text WHERE "key" = 'library.scan.title-extraction-regex';
UPDATE APP_CONFIG SET "value" = to_json("value"::text)::text WHERE "key" = 'library.metadata.update.schedule';
UPDATE APP_CONFIG SET "value" = to_json("value"::text)::text WHERE "key" = 'messages.providers.email.host';
UPDATE APP_CONFIG SET "value" = to_json("value"::text)::text WHERE "key" = 'messages.providers.email.username';
UPDATE APP_CONFIG SET "value" = to_json("value"::text)::text WHERE "key" = 'messages.providers.email.password';
UPDATE APP_CONFIG SET "value" = to_json("value"::text)::text WHERE "key" = 'sso.oidc.roles-claim';
UPDATE APP_CONFIG SET "value" = to_json("value"::text)::text WHERE "key" = 'sso.oidc.client-id';
UPDATE APP_CONFIG SET "value" = to_json("value"::text)::text WHERE "key" = 'sso.oidc.client-secret';
UPDATE APP_CONFIG SET "value" = to_json("value"::text)::text WHERE "key" = 'sso.oidc.issuer-url';
UPDATE APP_CONFIG SET "value" = to_json("value"::text)::text WHERE "key" = 'sso.oidc.authorize-url';
UPDATE APP_CONFIG SET "value" = to_json("value"::text)::text WHERE "key" = 'sso.oidc.token-url';
UPDATE APP_CONFIG SET "value" = to_json("value"::text)::text WHERE "key" = 'sso.oidc.userinfo-url';
UPDATE APP_CONFIG SET "value" = to_json("value"::text)::text WHERE "key" = 'sso.oidc.jwks-url';
UPDATE APP_CONFIG SET "value" = to_json("value"::text)::text WHERE "key" = 'sso.oidc.logout-url';

-- Convert Boolean values to JSON format (true/false without quotes)
UPDATE APP_CONFIG SET "value" = CASE WHEN lower("value") IN ('true','1','yes') THEN 'true' ELSE 'false' END WHERE "key" = 'library.allow-public-access';
UPDATE APP_CONFIG SET "value" = CASE WHEN lower("value") IN ('true','1','yes') THEN 'true' ELSE 'false' END WHERE "key" = 'library.scan.enable-filesystem-watcher';
UPDATE APP_CONFIG SET "value" = CASE WHEN lower("value") IN ('true','1','yes') THEN 'true' ELSE 'false' END WHERE "key" = 'library.scan.scan-empty-directories';
UPDATE APP_CONFIG SET "value" = CASE WHEN lower("value") IN ('true','1','yes') THEN 'true' ELSE 'false' END WHERE "key" = 'library.scan.extract-title-using-regex';
UPDATE APP_CONFIG SET "value" = CASE WHEN lower("value") IN ('true','1','yes') THEN 'true' ELSE 'false' END WHERE "key" = 'library.metadata.update.enabled';
UPDATE APP_CONFIG SET "value" = CASE WHEN lower("value") IN ('true','1','yes') THEN 'true' ELSE 'false' END WHERE "key" = 'requests.games.enabled';
UPDATE APP_CONFIG SET "value" = CASE WHEN lower("value") IN ('true','1','yes') THEN 'true' ELSE 'false' END WHERE "key" = 'requests.games.allow-guests-to-request-games';
UPDATE APP_CONFIG SET "value" = CASE WHEN lower("value") IN ('true','1','yes') THEN 'true' ELSE 'false' END WHERE "key" = 'downloads.bandwidth-limit.enabled';
UPDATE APP_CONFIG SET "value" = CASE WHEN lower("value") IN ('true','1','yes') THEN 'true' ELSE 'false' END WHERE "key" = 'users.sign-ups.allow';
UPDATE APP_CONFIG SET "value" = CASE WHEN lower("value") IN ('true','1','yes') THEN 'true' ELSE 'false' END WHERE "key" = 'users.sign-ups.confirmation-required';
UPDATE APP_CONFIG SET "value" = CASE WHEN lower("value") IN ('true','1','yes') THEN 'true' ELSE 'false' END WHERE "key" = 'sso.oidc.enabled';
UPDATE APP_CONFIG SET "value" = CASE WHEN lower("value") IN ('true','1','yes') THEN 'true' ELSE 'false' END WHERE "key" = 'sso.oidc.auto-register-new-users';
UPDATE APP_CONFIG SET "value" = CASE WHEN lower("value") IN ('true','1','yes') THEN 'true' ELSE 'false' END WHERE "key" = 'messages.providers.email.enabled';

-- Convert Int values to JSON format (plain numbers)
UPDATE APP_CONFIG SET "value" = "value"::bigint::text WHERE "key" = 'logs.max-history-days';
UPDATE APP_CONFIG SET "value" = "value"::bigint::text WHERE "key" = 'library.scan.title-match-min-ratio';
UPDATE APP_CONFIG SET "value" = "value"::bigint::text WHERE "key" = 'requests.games.max-open-requests-per-user';
UPDATE APP_CONFIG SET "value" = "value"::bigint::text WHERE "key" = 'downloads.bandwidth-limit.mbps';
UPDATE APP_CONFIG SET "value" = "value"::bigint::text WHERE "key" = 'messages.providers.email.port';

-- Convert Enum values to JSON format (quoted strings)
UPDATE APP_CONFIG SET "value" = to_json("value"::text)::text WHERE "key" = 'logs.level.gameyfin';
UPDATE APP_CONFIG SET "value" = to_json("value"::text)::text WHERE "key" = 'logs.level.root';
UPDATE APP_CONFIG SET "value" = to_json("value"::text)::text WHERE "key" = 'sso.oidc.match-existing-users-by';

-- Convert Array values to JSON format (from comma-separated to JSON array)
UPDATE APP_CONFIG SET "value" = array_to_json(string_to_array("value", ','))::text WHERE "key" = 'library.scan.game-file-extensions';
UPDATE APP_CONFIG SET "value" = array_to_json(string_to_array("value", ','))::text WHERE "key" = 'sso.oidc.oauth-scopes';
