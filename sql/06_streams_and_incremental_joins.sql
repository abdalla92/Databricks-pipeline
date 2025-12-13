-- 06_streams_and_incremental_joins.sql

-- This SQL script sets up streams and incremental joins for processing data in real-time.

-- 1) CREATE STREAM ON RAW TABLE
-- Purpose: Create a stream on the raw Delta table to capture changes (inserts, updates, deletes).
-- This stream will be used for incremental processing of new records.
CREATE OR REPLACE STREAM ed_pipeline_logs_stream 
ON TABLE ags_game_audience.raw.ed_pipeline_logs 
APPEND_ONLY = FALSE;

-- 2) CREATE ENRICHED TABLE WITH INCREMENTAL JOIN
-- Purpose: Create an enriched table that combines data from the raw table and the geolocation/time-of-day lookup tables.
-- This table will be updated incrementally based on the changes captured in the stream.
CREATE OR REPLACE TABLE ags_game_audience.enhanced.logs_enhanced AS
SELECT 
    logs.ip_address,
    logs.user_login AS gamer_name,
    logs.user_event AS game_event_name,
    logs.datetime_iso8601 AS game_event_utc,
    loc.city,
    loc.region,
    loc.country,
    loc.timezone AS gamer_ltz_name,
    CONVERT_TIMEZONE('UTC', loc.timezone, logs.datetime_iso8601) AS game_event_ltz,
    DAYNAME(CONVERT_TIMEZONE('UTC', loc.timezone, logs.datetime_iso8601)) AS dow_name,
    tod.tod_name AS tod_name
FROM 
    ags_game_audience.raw.ed_pipeline_logs AS logs
JOIN 
    ipinfo_geoloc.demo.location AS loc 
ON 
    ipinfo_geoloc.public.to_join_key(logs.ip_address) = loc.join_key
AND 
    ipinfo_geoloc.public.to_int(logs.ip_address) BETWEEN loc.start_ip_int AND loc.end_ip_int
JOIN 
    ags_game_audience.raw.time_of_day_lu AS tod
ON 
    HOUR(CONVERT_TIMEZONE('UTC', loc.timezone, logs.datetime_iso8601)) = tod.hour_of_day;

-- 3) MERGE INTO ENRICHED TABLE USING STREAM
-- Purpose: Incrementally merge new records from the stream into the enriched table.
-- This ensures that the enriched table is always up-to-date with the latest data.
MERGE INTO ags_game_audience.enhanced.logs_enhanced AS e
USING (
    SELECT 
        logs.ip_address,
        logs.user_login AS gamer_name,
        logs.user_event AS game_event_name,
        logs.datetime_iso8601 AS game_event_utc,
        loc.city,
        loc.region,
        loc.country,
        loc.timezone AS gamer_ltz_name,
        CONVERT_TIMEZONE('UTC', loc.timezone, logs.datetime_iso8601) AS game_event_ltz,
        DAYNAME(CONVERT_TIMEZONE('UTC', loc.timezone, logs.datetime_iso8601)) AS dow_name,
        tod.tod_name AS tod_name
    FROM 
        ags_game_audience.raw.ed_pipeline_logs AS logs
    JOIN 
        ipinfo_geoloc.demo.location AS loc 
    ON 
        ipinfo_geoloc.public.to_join_key(logs.ip_address) = loc.join_key
    AND 
        ipinfo_geoloc.public.to_int(logs.ip_address) BETWEEN loc.start_ip_int AND loc.end_ip_int
    JOIN 
        ags_game_audience.raw.time_of_day_lu AS tod
    ON 
        HOUR(CONVERT_TIMEZONE('UTC', loc.timezone, logs.datetime_iso8601)) = tod.hour_of_day
) AS r
ON 
    r.gamer_name = e.gamer_name
AND 
    r.game_event_utc = e.game_event_utc
AND 
    r.game_event_name = e.game_event_name
WHEN MATCHED THEN 
    UPDATE SET 
        e.city = r.city,
        e.region = r.region,
        e.country = r.country,
        e.gamer_ltz_name = r.gamer_ltz_name,
        e.game_event_ltz = r.game_event_ltz,
        e.dow_name = r.dow_name,
        e.tod_name = r.tod_name
WHEN NOT MATCHED THEN 
    INSERT (ip_address, gamer_name, game_event_name, game_event_utc, city, region, country, gamer_ltz_name, game_event_ltz, dow_name, tod_name)
    VALUES (r.ip_address, r.gamer_name, r.game_event_name, r.game_event_utc, r.city, r.region, r.country, r.gamer_ltz_name, r.game_event_ltz, r.dow_name, r.tod_name);