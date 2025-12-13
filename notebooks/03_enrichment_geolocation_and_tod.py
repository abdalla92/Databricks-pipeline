# Enrichment Geolocation and Time-of-Day Notebook

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, hour, expr
from delta.tables import *

# Initialize Spark session
spark = SparkSession.builder \
    .appName("Enrichment Geolocation and Time-of-Day") \
    .getOrCreate()

# Load raw logs from Delta table
raw_logs_df = spark.read.format("delta").load("/mnt/raw/ed_pipeline_logs")

# Load geolocation data from Delta table
geolocation_df = spark.read.format("delta").load("/mnt/geolocation/ipinfo_geoloc")

# Load time-of-day lookup table from Delta table
time_of_day_df = spark.read.format("delta").load("/mnt/raw/time_of_day_lu")

# Enrich raw logs with geolocation data
enriched_logs_df = raw_logs_df.alias("logs") \
    .join(geolocation_df.alias("geo"), 
          expr("TO_JOIN_KEY(logs.ip_address) = geo.join_key AND TO_INT(logs.ip_address) BETWEEN geo.start_ip_int AND geo.end_ip_int"), 
          "left") \
    .join(time_of_day_df.alias("tod"), 
          hour(col("logs.datetime_iso8601")) == col("tod.hour_of_day"), 
          "left") \
    .select(
        col("logs.ip_address"),
        col("logs.user_login").alias("gamer_name"),
        col("logs.user_event").alias("game_event_name"),
        col("logs.datetime_iso8601").alias("game_event_utc"),
        col("geo.city"),
        col("geo.region"),
        col("geo.country"),
        col("geo.timezone").alias("gamer_ltz_name"),
        expr("CONVERT_TIMEZONE('UTC', geo.timezone, logs.datetime_iso8601)").alias("game_event_ltz"),
        expr("DAYNAME(game_event_ltz)").alias("dow_name"),
        col("tod.tod_name").alias("tod_name")
    )

# Write enriched logs to Delta table
enriched_logs_df.write.format("delta").mode("overwrite").save("/mnt/enriched/logs_enriched")

# Stop the Spark session
spark.stop()