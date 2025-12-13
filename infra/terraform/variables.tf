variable "databricks_workspace_name" {
  description = "The name of the Databricks workspace."
  type        = string
}

variable "databricks_region" {
  description = "The AWS region where the Databricks workspace will be created."
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket used for data storage."
  type        = string
}

variable "s3_mount_path" {
  description = "The mount path for the S3 bucket in Databricks."
  type        = string
}

variable "delta_table_location" {
  description = "The location in DBFS where Delta tables will be stored."
  type        = string
}

variable "job_schedule" {
  description = "The schedule for running Databricks jobs."
  type        = string
}

variable "aws_access_key" {
  description = "AWS access key for accessing S3."
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key for accessing S3."
  type        = string
  sensitive   = true
}