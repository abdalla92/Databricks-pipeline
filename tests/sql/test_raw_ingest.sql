-- This SQL script contains tests for validating the raw data ingestion process.

-- Test 1: Validate that the raw Delta table is populated with data
SELECT COUNT(*) AS raw_data_count
FROM delta.`/mnt/raw_data/ed_pipeline_logs`
WHERE load_ltz IS NOT NULL;

-- Test 2: Validate that the expected columns are present in the raw Delta table
SELECT *
FROM delta.`/mnt/raw_data/ed_pipeline_logs`
LIMIT 1;

-- Test 3: Validate that the data types of the columns are as expected
DESCRIBE delta.`/mnt/raw_data/ed_pipeline_logs`;