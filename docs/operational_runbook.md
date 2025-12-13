# Operational Runbook for Databricks Game Audience Pipeline

## Overview
This operational runbook provides guidelines and procedures for managing and running the Databricks Game Audience Pipeline. It outlines the necessary steps for setup, execution, monitoring, and troubleshooting.

## Pipeline Components
The pipeline consists of several key components:
- **SQL Scripts**: These scripts create the necessary schemas, tables, and jobs within Databricks.
- **Notebooks**: Python notebooks that handle data ingestion, stream consumption, and data enrichment.
- **Jobs**: Configurations for scheduling and automating the execution of the pipeline.
- **Infrastructure**: Terraform scripts for provisioning the Databricks environment.

## Setup Instructions
1. **Environment Configuration**:
   - Ensure that the Databricks workspace is properly configured.
   - Update the `configs/workspace_config.json` file with your workspace settings.

2. **Infrastructure Deployment**:
   - Navigate to the `infra/terraform` directory.
   - Run `terraform init` to initialize the Terraform configuration.
   - Execute `terraform apply` to provision the necessary resources in Databricks.

3. **Job Configuration**:
   - Review and modify the `jobs/databricks_jobs.json` file to set up job parameters and scheduling.

## Running the Pipeline
1. **Ingest Data**:
   - Execute the notebook `notebooks/01_ingest_s3_to_delta.py` to ingest data from S3 into Delta tables.

2. **Stream Processing**:
   - Run the notebook `notebooks/02_stream_consumer_and_merge.py` to consume streams and merge data into enriched tables.

3. **Data Enrichment**:
   - Execute the notebook `notebooks/03_enrichment_geolocation_and_tod.py` to enrich the data with geolocation and time-of-day information.

4. **Scheduled Jobs**:
   - Ensure that scheduled jobs are running as per the configuration in `jobs/databricks_jobs.json`.

## Monitoring and Maintenance
- Regularly monitor the execution of jobs and notebooks through the Databricks UI.
- Check the logs for any errors or warnings during the execution of the pipeline.
- Use the SQL scripts in the `tests/sql` directory to validate the integrity of the data and the correctness of the pipeline operations.

## Troubleshooting
- If data ingestion fails, verify the S3 bucket permissions and the correctness of the file formats.
- For issues with stream processing, check the stream configurations and ensure that the necessary Delta tables are available.
- Review the logs for any exceptions or errors and address them accordingly.

## Best Practices
- Regularly update the pipeline components to incorporate improvements and new features.
- Maintain documentation for any changes made to the pipeline for future reference.
- Implement monitoring and alerting mechanisms to proactively manage the pipeline's health.

## Conclusion
This operational runbook serves as a guide for effectively managing the Databricks Game Audience Pipeline. Following these procedures will help ensure smooth operation and maintenance of the data pipeline.