-- 05_enriched_tables_delta.sql

/*
    Creating enriched Delta tables that combine parsed log fields with external geolocation and time-of-day enrichment.
    - Enrichments:
        - Geolocation: join to an IP geolocation dataset using IP address transformed to an integer join key.
        - Time conversion: convert UTC event timestamps to local timezone returned by the geolocation table using CONVERT_TIMEZONE.
        - Day name and TOD: compute DOW_NAME (DAYNAME) and join to time_of_day_lu for TOD_NAME.
    - Notes:
        - Ensure values are valid timezones for CONVERT_TIMEZONE.
        - When joining by IP range (start_ip_int/end_ip_int), be mindful of indexing and performance.
*/

CREATE OR REPLACE TABLE enriched.logs_enhanced AS
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
    raw.logs logs
JOIN 
    ipinfo_geoloc.demo.location loc 
ON 
    ipinfo_geoloc.public.to_join_key(logs.ip_address) = loc.join_key
    AND ipinfo_geoloc.public.to_int(logs.ip_address) BETWEEN loc.start_ip_int AND loc.end_ip_int
JOIN 
    raw.time_of_day_lu tod
ON 
    HOUR(CONVERT_TIMEZONE('UTC', loc.timezone, logs.datetime_iso8601)) = tod.hour_of_day;