#!/bin/bash

# This script executes the specified Databricks job.

# Set the Databricks workspace URL and token
DATABRICKS_URL="https://dbc-0ac6af0e-d3c4.cloud.databricks.com/" #"https://<your-databricks-instance>"
DATABRICKS_TOKEN="dapi410dcdee6a3f54310d16a81d37c78c21" #"<your-databricks-token>"

# Specify the job ID or job name to run
JOB_ID="57fdf3fb81ac0409" #"<your-job-id>"

# Execute the job using the Databricks REST API
curl -X POST "$DATABRICKS_URL/api/2.0/jobs/run-now" \
-H "Authorization: Bearer $DATABRICKS_TOKEN" \
-H "Content-Type: application/json" \
-d '{
  "job_id": "'"$JOB_ID"'"
}' 

echo "Job execution initiated for Job ID: $JOB_ID"