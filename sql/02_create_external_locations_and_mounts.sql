-- 02_create_external_locations_and_mounts.sql

-- Purpose: Set up external locations and mounts for accessing data stored in S3.
-- This script creates external locations in Databricks that point to S3 buckets and mounts them to the Databricks file system.

-- Create an external location for the S3 bucket
CREATE EXTERNAL LOCATION my_s3_external_location
WITH URL 's3://uni-kishore-pipeline'
WITH IAM_ROLE 'arn:aws:iam::123456789012:role/MyDatabricksRole';

-- Mount the external location to the Databricks file system
CREATE MOUNT my_s3_mount
  LOCATION 's3://uni-kishore-pipeline'
  WITH CREDENTIALS 'my_s3_external_location';