from pyspark.sql import SparkSession
from pyspark.sql.functions import col, current_timestamp

# Initialize Spark session
spark = SparkSession.builder \
    .appName("Stream Consumer and Merge") \
    .getOrCreate()

# Define the source stream
source_stream = spark.readStream \
    .format("delta") \
    .table("ags_game_audience.raw.ed_cdc_stream")

# Define the enriched table
enriched_table = "ags_game_audience.enhanced.logs_enhanced"

# Define the merge logic
def merge_stream_to_enriched(source_df):
    # Perform the merge operation
    source_df.createOrReplaceTempView("source_view")
    
    merge_query = f"""
    MERGE INTO {enriched_table} AS target
    USING source_view AS source
    ON target.gamer_name = source.user_login
    AND target.game_event_utc = source.datetime_iso8601
    AND target.game_event_name = source.user_event
    WHEN MATCHED THEN
        UPDATE SET
            target.city = source.city,
            target.region = source.region,
            target.country = source.country,
            target.gamer_ltz_name = source.timezone,
            target.game_event_ltz = convert_timezone('UTC', source.timezone, source.datetime_iso8601),
            target.dow_name = DAYNAME(convert_timezone('UTC', source.timezone, source.datetime_iso8601)),
            target.tod_name = tod.tod_name
    WHEN NOT MATCHED THEN
        INSERT (ip_address, gamer_name, game_event_name, game_event_utc, city, region, country, gamer_ltz_name, game_event_ltz, dow_name, tod_name)
        VALUES (source.ip_address, source.user_login, source.user_event, source.datetime_iso8601, source.city, source.region, source.country, source.timezone, convert_timezone('UTC', source.timezone, source.datetime_iso8601), DAYNAME(convert_timezone('UTC', source.timezone, source.datetime_iso8601)), tod.tod_name)
    """

    # Execute the merge query
    spark.sql(merge_query)

# Start the streaming query
query = source_stream.writeStream \
    .foreachBatch(merge_stream_to_enriched) \
    .outputMode("update") \
    .start()

# Await termination
query.awaitTermination()