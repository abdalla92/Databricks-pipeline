output "databricks_workspace_url" {
  value = databricks_workspace.workspace_url
}

output "databricks_token" {
  value = databricks_workspace.token
}

output "databricks_cluster_id" {
  value = databricks_cluster.cluster_id
}

output "databricks_job_id" {
  value = databricks_job.job_id
}