# Databricks Game Audience Pipeline

## Overview
This project is an end-to-end data pipeline designed to ingest, process, and analyze gaming data using Databricks. The pipeline ingests JSON log files from S3, processes them into raw Delta tables, enriches them with geolocation and time-of-day metadata, and provides analytical capabilities through SQL queries.

## Project Structure
The project is organized into several directories, each serving a specific purpose:

- **sql/**: Contains SQL scripts for creating catalogs, schemas, external locations, Delta tables, and jobs.
- **notebooks/**: Includes Python notebooks for data ingestion, stream consumption, and data enrichment.
- **jobs/**: Defines the configuration for Databricks jobs.
- **configs/**: Contains configuration files for the Databricks workspace and environment settings.
- **infra/**: Holds Terraform scripts for infrastructure setup.
- **scripts/**: Includes shell scripts for deployment and job execution.
- **tests/**: Contains SQL and Python tests for validating the pipeline processes.
- **docs/**: Provides operational guidelines and documentation for running the pipeline.

## Setup Instructions
1. **Clone the Repository**: 
   Clone this repository to your local machine.

2. **Configure Environment**:
   - Update the `configs/env.sample` file with your environment variables.
   - Rename it to `.env` and ensure it is properly configured.

3. **Deploy Infrastructure**:
   - Navigate to the `infra/terraform` directory.
   - Run `terraform init` to initialize Terraform.
   - Execute `terraform apply` to create the necessary infrastructure in Databricks.

4. **Run SQL Scripts**:
   - Execute the SQL scripts in the `sql/` directory in order to set up catalogs, schemas, and tables.

5. **Ingest Data**:
   - Use the `notebooks/01_ingest_s3_to_delta.py` notebook to ingest data from S3 into Delta tables.

6. **Process Data**:
   - Run the `notebooks/02_stream_consumer_and_merge.py` notebook to consume streams and merge data into enriched tables.
   - Execute the `notebooks/03_enrichment_geolocation_and_tod.py` notebook to enrich the data with additional metadata.

7. **Schedule Jobs**:
   - Use the `sql/07_jobs_and_scheduled_tasks.sql` script to define and schedule jobs for automated data processing.

8. **Run Tests**:
   - Execute the tests located in the `tests/` directory to validate the pipeline processes.

## Usage Guidelines
- Use the provided analytical queries in `sql/08_example_analytical_queries.sql` to explore the enriched data.
- Refer to the `docs/operational_runbook.md` for operational procedures and troubleshooting tips.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.