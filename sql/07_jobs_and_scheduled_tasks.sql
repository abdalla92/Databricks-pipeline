-- 07_jobs_and_scheduled_tasks.sql

-- This SQL script defines jobs and scheduled tasks for automating data processing workflows in Databricks.

-- Create a job for ingesting data from S3 into Delta tables
CREATE OR REPLACE JOB ingest_s3_to_delta
  SETTINGS (
    "maxRetries" = 3,
    "retryInterval" = 5,
    "timeout" = 3600
  )
  AS
  CALL ingest_s3_to_delta();

-- Create a job for consuming streams and merging data into enriched tables
CREATE OR REPLACE JOB stream_consumer_and_merge
  SETTINGS (
    "maxRetries" = 3,
    "retryInterval" = 5,
    "timeout" = 3600
  )
  AS
  CALL stream_consumer_and_merge();

-- Create a job for enriching data with geolocation and time-of-day information
CREATE OR REPLACE JOB enrichment_geolocation_and_tod
  SETTINGS (
    "maxRetries" = 3,
    "retryInterval" = 5,
    "timeout" = 3600
  )
  AS
  CALL enrichment_geolocation_and_tod();

-- Schedule the ingest job to run every hour
CREATE OR REPLACE SCHEDULE hourly_ingest_schedule
  FOR JOB ingest_s3_to_delta
  CRON '0 * * * *' -- Every hour at minute 0
  TIMEZONE 'UTC';

-- Schedule the stream consumer job to run every 5 minutes
CREATE OR REPLACE SCHEDULE five_minute_stream_schedule
  FOR JOB stream_consumer_and_merge
  CRON '*/5 * * * *' -- Every 5 minutes
  TIMEZONE 'UTC';

-- Schedule the enrichment job to run every hour
CREATE OR REPLACE SCHEDULE hourly_enrichment_schedule
  FOR JOB enrichment_geolocation_and_tod
  CRON '0 * * * *' -- Every hour at minute 0
  TIMEZONE 'UTC';