-- 03_file_formats_and_parsing.sql

-- Define file formats and parsing rules for ingesting data into Delta tables.

-- Create a file format for JSON data
CREATE OR REPLACE FILE FORMAT json_format
  TYPE = 'JSON'
  STRIP_OUTER_ARRAY = TRUE;

-- Create a file format for CSV data
CREATE OR REPLACE FILE FORMAT csv_format
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  HEADER = TRUE;

-- Create a file format for Parquet data
CREATE OR REPLACE FILE FORMAT parquet_format
  TYPE = 'PARQUET';

-- Example of parsing JSON data into a Delta table
CREATE OR REPLACE TABLE raw_data_table
USING DELTA
AS
SELECT 
  data:datetime_iso8601::timestamp AS datetime_iso8601,
  data:user_event::string AS user_event,
  data:user_login::string AS user_login,
  data:ip_address::string AS ip_address
FROM 
  cloud_files
  FILE_FORMAT = json_format; 

-- Example of parsing CSV data into a Delta table
CREATE OR REPLACE TABLE raw_csv_data_table
USING DELTA
AS
SELECT 
  datetime_iso8601,
  user_event,
  user_login,
  ip_address
FROM 
  cloud_files
  FILE_FORMAT = csv_format; 

-- Example of parsing Parquet data into a Delta table
CREATE OR REPLACE TABLE raw_parquet_data_table
USING DELTA
AS
SELECT 
  *
FROM 
  cloud_files
  FILE_FORMAT = parquet_format; 