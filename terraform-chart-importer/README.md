# Terraform Chart Importer

This module imports Helm charts from a source Azure Container Registry (ACR) to a destination ACR and deploys them to an Azure Kubernetes Service (AKS) cluster.

## Usage

```hcl
module "chart" {
  source = "./terraform-chart-importer"
  
  acr_server                 = "instance.azurecr.io"
  acr_server_subscription    = "c9e7611c-d508-4fbf-aede-0bedfabc1560"
  source_acr_client_id       = "1b2f651e-b99c-4720-9ff1-ede324b8ae30"
  source_acr_client_secret   = "Zrrr8~5~F2Xiaaaa7eS.S85SXXAAfTYizZEF1cRp"
  source_acr_server          = "reference.azurecr.io"
  
  charts = [
    {
      chart_name        = "my-chart"
      chart_namespace   = "default"
      chart_repository  = "charts"
      chart_version     = "1.0.0"
      values            = [
        {
          name  = "replicaCount"
          value = "2"
        }
      ]
      sensitive_values  = [
        {
          name  = "secretKey"
          value = "supersecretvalue"
        }
      ]
    }
  ]
}
