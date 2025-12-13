-- 04_raw_tables_delta.sql

-- Creating raw Delta tables to store ingested data from S3

-- Step 1: Create a Delta table for storing raw JSON logs
CREATE TABLE IF NOT EXISTS game_audience.raw.ed_pipeline_logs
USING DELTA
LOCATION '/mnt/raw/ed_pipeline_logs'
AS
SELECT 
    input_file_name() AS log_file_name,  -- Metadata column for the log file name
    monotonically_increasing_id() AS log_file_row_id,  -- Unique row identifier
    current_timestamp() AS load_ltz,  -- Load timestamp
    get_json_object(value, '$.datetime_iso8601') AS datetime_iso8601,  -- Extracted datetime
    get_json_object(value, '$.user_event') AS user_event,  -- Extracted user event
    get_json_object(value, '$.user_login') AS user_login,  -- Extracted user login
    get_json_object(value, '$.ip_address') AS ip_address  -- Extracted IP address
FROM 
    cloud_files('/mnt/raw/uni_kishore_pipeline', 
                 'json', 
                 'strip_outer_array=true');  -- Ingesting JSON files from S3

-- Step 2: Validate the creation of the raw table
DESCRIBE EXTENDED game_audience.raw.ed_pipeline_logs;