CREATE DATABASE qq_db;

CREATE ROLE qq_user LOGIN PASSWORD 'societyofthespectacle';

REVOKE ALL ON DATABASE qq_db FROM PUBLIC;

GRANT CONNECT ON DATABASE qq_db TO qq_user;

-- Switch to qq_db to set schema privileges
\connect qq_db

GRANT USAGE ON SCHEMA public TO qq_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO qq_user;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO qq_user;

-- Ensure future tables/sequences created by postgres superuser are also usable
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO qq_user;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
  GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO qq_user;
