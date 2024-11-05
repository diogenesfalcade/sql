-- Check the Size of the Entire Database
SELECT 
  pg_size_pretty(
    pg_database_size('database_name') --change database_name
  ) AS size;

--Check the Size of All Tables in the Database
SELECT 
  table_name AS table, 
  pg_size_pretty(
    pg_total_relation_size(table_name :: regclass)
  ) AS size 
FROM 
  information_schema.tables 
WHERE 
  table_schema = 'public' --change schema
ORDER BY 
  pg_total_relation_size(table_name :: regclass) DESC;

--Check the Size of All Databases on the Server
SELECT 
  pg_database.datname AS database, 
  pg_size_pretty(
    pg_database_size(pg_database.datname)
  ) AS size 
FROM 
  pg_database 
ORDER BY 
  pg_database_size(pg_database.datname) DESC;

--Check the Size of Specific Indexes
SELECT 
  indexrelname AS index, 
  pg_size_pretty(
    pg_relation_size(indexrelid)
  ) AS size 
FROM 
  pg_stat_user_indexes 
WHERE 
  schemaname = 'public' --change schema and table_name
  AND relname = 'table_name';
