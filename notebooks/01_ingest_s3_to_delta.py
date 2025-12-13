from pyspark.sql import SparkSession
from pyspark.sql.functions import current_timestamp

# Initialize Spark session
spark = SparkSession.builder \
    .appName("Ingest S3 to Delta") \
    .getOrCreate()

# Define S3 bucket and path
s3_bucket = "s3://uni-kishore-pipeline"
raw_table_path = "/mnt/raw/ed_pipeline_logs"

# Read JSON files from S3 into a DataFrame
df_raw = spark.read.json(s3_bucket)

# Add metadata columns
df_raw_with_metadata = df_raw.withColumn("log_file_name", current_timestamp()) \
    .withColumn("log_file_row_id", current_timestamp()) \
    .withColumn("load_ltz", current_timestamp())

# Write DataFrame to Delta table
df_raw_with_metadata.write.format("delta").mode("overwrite").save(raw_table_path)

# Create Delta table in Databricks
spark.sql(f"""
CREATE TABLE IF NOT EXISTS raw.ed_pipeline_logs
USING DELTA
LOCATION '{raw_table_path}'
""")

# Stop the Spark session
spark.stop()