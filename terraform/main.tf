resource "azurerm_resource_group" "rg_runners_aca_jobs" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet_runners_aca_jobs" {
  name                = "vnet-ghrunnersacajobs-tf"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_runners_aca_jobs.name
  address_space       = ["10.0.0.0/23"]
}

resource "azurerm_subnet" "subnet_runners_aca_jobs" {
  name                 = "snet-ghrunnersacajobs-tf"
  resource_group_name  = azurerm_resource_group.rg_runners_aca_jobs.name
  address_prefixes     = ["10.0.1.0/27"]
  virtual_network_name = azurerm_virtual_network.vnet_runners_aca_jobs.name
  delegation {
    name = "containerapps"
    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}


resource "azurerm_log_analytics_workspace" "la_runners_aca_jobs" {
  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.rg_runners_aca_jobs.location
  resource_group_name = azurerm_resource_group.rg_runners_aca_jobs.name
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_analytics_workspace_retention_in_days
}

resource "azurerm_user_assigned_identity" "uai_runners_aca_jobs" {
  location            = azurerm_resource_group.rg_runners_aca_jobs.location
  name                = var.identity_name
  resource_group_name = azurerm_resource_group.rg_runners_aca_jobs.name
  tags                = {}
}

## The AzureRM provider doesn't support yet the workload profiles
# resource "azurerm_container_app_environment" "acae_runners_jobs" {
#   name                       = var.aca_environment_name
#   location                   = azurerm_resource_group.rg_runners_aca_jobs.location
#   resource_group_name        = azurerm_resource_group.rg_runners_aca_jobs.name
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.la_runners_aca_jobs.id
# }

resource "azapi_resource" "acae_runners_jobs" {
  type      = "Microsoft.App/managedEnvironments@2023-04-01-preview"
  name      = var.aca_environment_name
  parent_id = azurerm_resource_group.rg_runners_aca_jobs.id
  location  = azurerm_resource_group.rg_runners_aca_jobs.location

  schema_validation_enabled = false

  body = jsonencode({
    properties = {
      appLogsConfiguration = {
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = azurerm_log_analytics_workspace.la_runners_aca_jobs.workspace_id
          sharedKey  = azurerm_log_analytics_workspace.la_runners_aca_jobs.primary_shared_key
        }
      }
      vnetConfiguration = {
        dockerBridgeCidr       = null
        infrastructureSubnetId = azurerm_subnet.subnet_runners_aca_jobs.id
        internal               = true
        platformReservedCidr   = null
        platformReservedDnsIP  = null
      }
      workloadProfiles = var.aca_workload_profiles
    }
  })
}

resource "azapi_resource" "acaj_runners_jobs" {
  type      = "Microsoft.App/jobs@2023-04-01-preview"
  name      = var.job_name
  location  = azurerm_resource_group.rg_runners_aca_jobs.location
  parent_id = azurerm_resource_group.rg_runners_aca_jobs.id
  tags      = {}

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uai_runners_aca_jobs.id]
  }

  # Need to set to false because at the moment only 2022-11-01-preview is supported
  schema_validation_enabled = false

  body = jsonencode({
    properties = {
      environmentId       = azapi_resource.acae_runners_jobs.id
      workloadProfileName = var.job_workload_profile_name
      configuration = {
        secrets = [
          {
            name  = var.gh_pat_secret_name
            value = var.gh_pat_value
          }
        ]
        triggerType           = "Event"
        replicaTimeout        = var.job_replica_timeout
        replicaRetryLimit     = var.job_replica_retry_limit
        manualTriggerConfig   = null
        scheduleTriggerConfig = null
        registries            = null
        dapr                  = null
        eventTriggerConfig = {
          replicaCompletionCount = null
          parallelism            = var.job_parallelism
          scale = {
            minExecutions   = var.job_scale_min_executions
            maxExecutions   = var.job_scale_max_executions
            pollingInterval = var.job_scale_polling_interval
            rules = [
              {
                name = "github-runner"
                type = "github-runner"
                metadata = {
                  owner       = var.gh_owner
                  repos       = var.gh_repository
                  runnerScope = var.gh_scope
                }
                auth = [
                  {
                    secretRef        = var.gh_pat_secret_name
                    triggerParameter = "personalAccessToken"
                  }
                ]
              }
            ]
          }
        }
      }
      template = {
        containers = [
          {
            image   = var.job_image
            name    = "ghrunnersacajobs"
            command = null
            args    = null
            env     = var.env_variables
            resources = {
              cpu    = var.job_cpu
              memory = var.job_memory
            }
            volumeMounts = null
          }
        ]
        initContainers = null
        volumes        = null
      }
    }
  })
}
