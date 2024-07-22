# Data source for source ACR
data "azurerm_container_registry" "source_acr" {
  name                = var.source_acr_server
  resource_group_name = "source-resource-group"
  provider            = azurerm
}

# Data source for destination ACR
data "azurerm_container_registry" "destination_acr" {
  name                = var.acr_server
  resource_group_name = "destination-resource-group"
  provider            = azurerm
}

# Local-exec provisioner to handle Helm chart operations
resource "null_resource" "import_charts" {
  count = length(var.charts)

  provisioner "local-exec" {
    command = <<EOT
      # Log in to source ACR
      az acr login --name ${data.azurerm_container_registry.source_acr.name}
      # Pull the Helm chart from source ACR
      helm pull ${var.source_acr_server}/${var.charts[count.index].chart_repository}/${var.charts[count.index].chart_name} --version ${var.charts[count.index].chart_version}
      # Tag and push the Helm chart to destination ACR
      helm chart import ${var.charts[count.index].chart_name}-${var.charts[count.index].chart_version}.tgz --destination ${var.acr_server}/${var.charts[count.index].chart_repository}
    EOT
    environment = {
      AZURE_SUBSCRIPTION_ID = var.acr_server_subscription
      AZURE_CLIENT_ID       = var.source_acr_client_id
      AZURE_CLIENT_SECRET   = var.source_acr_client_secret
    }
  }
}

# Helm provider setup
provider "helm" {
  # Configuration for Helm provider will be supplied by the caller
}

# Deploy charts to AKS
resource "helm_release" "chart" {
  count = length(var.charts)

  name       = var.charts[count.index].chart_name
  repository = "https://${var.acr_server}/"
  chart      = "${var.charts[count.index].chart_repository}/${var.charts[count.index].chart_name}"
  version    = var.charts[count.index].chart_version
  namespace  = var.charts[count.index].chart_namespace

  values = [
    for val in var.charts[count.index].values : {
      val.name = val.value
    }
  ]

  dynamic "set_sensitive" {
    for_each = var.charts[count.index].sensitive_values
    content {
      name  = set_sensitive.value.name
      value = set_sensitive.value.value
    }
  }
}
