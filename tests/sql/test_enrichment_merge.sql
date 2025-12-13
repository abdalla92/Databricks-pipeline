-- This SQL script contains tests for validating the enrichment and merging process.

-- Test for successful merge of enriched data into the enriched table
MERGE INTO enriched_table AS target
USING (
    SELECT 
        ip_address,
        user_login,
        user_event,
        datetime_iso8601,
        city,
        region,
        country,
        timezone,
        game_event_ltz,
        dow_name,
        tod_name
    FROM raw_table
    WHERE datetime_iso8601 >= '2024-01-01' -- Example filter for recent data
) AS source
ON target.user_login = source.user_login 
   AND target.datetime_iso8601 = source.datetime_iso8601 
   AND target.user_event = source.user_event
WHEN MATCHED THEN 
    UPDATE SET 
        target.city = source.city,
        target.region = source.region,
        target.country = source.country,
        target.timezone = source.timezone,
        target.game_event_ltz = source.game_event_ltz,
        target.dow_name = source.dow_name,
        target.tod_name = source.tod_name
WHEN NOT MATCHED THEN 
    INSERT (ip_address, user_login, user_event, datetime_iso8601, city, region, country, timezone, game_event_ltz, dow_name, tod_name)
    VALUES (source.ip_address, source.user_login, source.user_event, source.datetime_iso8601, source.city, source.region, source.country, source.timezone, source.game_event_ltz, source.dow_name, source.tod_name);

-- Validate the merge operation
SELECT COUNT(*) AS total_records FROM enriched_table WHERE datetime_iso8601 >= '2024-01-01'; -- Check the number of records after merge

-- Check for duplicates in the enriched table
SELECT user_login, datetime_iso8601, COUNT(*) AS record_count
FROM enriched_table
GROUP BY user_login, datetime_iso8601
HAVING COUNT(*) > 1; -- Ensure no duplicates exist after merge