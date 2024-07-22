variable "acr_server" {
  description = "The server URL of the destination ACR where charts will be imported."
  type        = string
}

variable "acr_server_subscription" {
  description = "The Azure subscription ID where the destination ACR is located."
  type        = string
}

variable "source_acr_client_id" {
  description = "The client ID for accessing the source ACR."
  type        = string
}

variable "source_acr_client_secret" {
  description = "The client secret for accessing the source ACR."
  type        = string
  sensitive   = true
}

variable "source_acr_server" {
  description = "The server URL of the source ACR where charts are hosted."
  type        = string
}

variable "charts" {
  description = "A list of Helm charts to import and deploy."
  type = list(object({
    chart_name        = string
    chart_namespace   = string
    chart_repository  = string
    chart_version     = string
    values            = list(object({
      name  = string
      value = string
    }))
    sensitive_values  = list(object({
      name  = string
      value = string
    }))
  }))
}
