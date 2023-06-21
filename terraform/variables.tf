variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location of the resources"
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analitics Workspace"
  type        = string
}

variable "log_analytics_workspace_sku" {
  description = "SKU for the Log Analytics workspace"
  type        = string
}

variable "log_analytics_workspace_retention_in_days" {
  description = "Retention period for Log Analytics data"
  type        = number
}

variable "identity_name" {
  description = "Name of the user-assigned identity"
  type        = string
}

variable "aca_environment_name" {
  description = "Name of the Azure Container Apps environment"
  type        = string
}

variable "aca_workload_profiles" {
  description = "Workload profiles configured for the Managed Environment"
  type = list(object({
    name                = string
    workloadProfileType = string
    minimumCount        = number
    maximumCount        = number
  }))
}


variable "job_name" {
  description = "Name of the job"
  type        = string
}

variable "job_image" {
  description = "Container image for the job"
  type        = string
}

variable "job_replica_timeout" {
  description = "Timeout for job replicas"
  type        = number
}

variable "job_replica_retry_limit" {
  description = "Retry limit for job replicas"
  type        = number
}

variable "gh_owner" {
  description = "The owner of the GitHub repository, or the organization that owns the repository"
  type        = string
}

variable "gh_repository" {
  description = "The list of repositories to scale, separated by comma"
  type        = string
}

variable "gh_scope" {
  description = "The scope of the runner, can be either “org”, “ent” or “repo”"
  type        = string
  default     = "repo"
}

variable "gh_pat_secret_name" {
  description = "Name of the secret storing the GitHub PAT token"
  type        = string
}

variable "gh_pat_value" {
  description = "Value of the GitHub PAT token"
  type        = string
  sensitive   = true
}

variable "job_cpu" {
  description = "CPU limit for the job"
  type        = number
}

variable "job_memory" {
  description = "Memory limit for the job"
  type        = string
}


variable "env_variables" {
  description = "List of environment variables for the job"
  type = list(object({
    name      = string
    value     = optional(string)
    secretRef = optional(string)
  }))
}

variable "job_scale_min_executions" {
  description = "The minimum number of job executions to run per polling interval."
  type        = number
}

variable "job_scale_max_executions" {
  description = "The maximum number of job executions to run per polling interval"
  type        = number
}

variable "job_scale_polling_interval" {
  description = "The polling interval at which to evaluate the scale rule"
  type        = number
  default     = 30
}

variable "job_parallelism" {
  description = "Number of parallel replicas of a job that can run at a given time."
  type        = number
}

variable "job_workload_profile_name" {
  description = "Workload profile name to pin for container apps job execution"
  type = string
}