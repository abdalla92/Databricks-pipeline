provider "databricks" {
  host     = var.databricks_host
  token    = var.databricks_token
}

resource "databricks_cluster" "pipeline_cluster" {
  cluster_name            = "game-audience-pipeline-cluster"
  spark_version           = "7.3.x-scala2.12"
  node_type_id           = "i3.xlarge"
  autotermination_minutes = 30

  autoscale {
    min_workers = 1
    max_workers = 5
  }
}

resource "databricks_sql_endpoint" "pipeline_sql_endpoint" {
  name                = "game-audience-sql-endpoint"
  max_num_clusters    = 1
  min_num_clusters    = 1
  enable_serverless   = false
  auto_stop_minutes   = 15
  cluster_id          = databricks_cluster.pipeline_cluster.id
}

resource "databricks_job" "data_ingestion_job" {
  name = "Data Ingestion Job"

  new_cluster {
    cluster_id = databricks_cluster.pipeline_cluster.id
  }

  notebook_task {
    notebook_path = "/notebooks/01_ingest_s3_to_delta"
  }
}

resource "databricks_job" "stream_consumer_job" {
  name = "Stream Consumer Job"

  new_cluster {
    cluster_id = databricks_cluster.pipeline_cluster.id
  }

  notebook_task {
    notebook_path = "/notebooks/02_stream_consumer_and_merge"
  }
}

resource "databricks_job" "enrichment_job" {
  name = "Enrichment Job"

  new_cluster {
    cluster_id = databricks_cluster.pipeline_cluster.id
  }

  notebook_task {
    notebook_path = "/notebooks/03_enrichment_geolocation_and_tod"
  }
}

output "cluster_id" {
  value = databricks_cluster.pipeline_cluster.id
}

output "sql_endpoint_id" {
  value = databricks_sql_endpoint.pipeline_sql_endpoint.id
}