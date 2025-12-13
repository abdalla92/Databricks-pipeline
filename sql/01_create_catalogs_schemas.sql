-- Create necessary catalogs and schemas in Databricks for organizing data

-- Create the main catalog for the game audience pipeline
CREATE CATALOG IF NOT EXISTS game_audience_pipeline;

-- Create schemas for raw and enriched data
CREATE SCHEMA IF NOT EXISTS game_audience_pipeline.raw;
CREATE SCHEMA IF NOT EXISTS game_audience_pipeline.enriched;