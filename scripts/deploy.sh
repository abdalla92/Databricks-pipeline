#!/bin/bash

# This script automates the deployment process for the Databricks game audience pipeline.

# Set variables
DATABRICKS_HOST= "<your-databricks-host>"
DATABRICKS_TOKEN=""
WORKSPACE_DIR="/databricks-game-audience-pipeline"

# Function to deploy SQL scripts
deploy_sql_scripts() {
    for sql_file in $WORKSPACE_DIR/sql/*.sql; do
        echo "Deploying SQL script: $sql_file"
        databricks sql execute --host $DATABRICKS_HOST --token $DATABRICKS_TOKEN --file $sql_file
    done
}

# Function to deploy notebooks
deploy_notebooks() {
    for notebook_file in $WORKSPACE_DIR/notebooks/*.py; do
        echo "Deploying notebook: $notebook_file"
        databricks workspace import --overwrite --language PYTHON $notebook_file /Workspace/$(basename $notebook_file)
    done
}

# Function to deploy jobs
deploy_jobs() {
    echo "Deploying jobs from $WORKSPACE_DIR/jobs/databricks_jobs.json"
    databricks jobs create --json-file $WORKSPACE_DIR/jobs/databricks_jobs.json
}

# Main deployment process
deploy_sql_scripts
deploy_notebooks
deploy_jobs

echo "Deployment completed successfully."