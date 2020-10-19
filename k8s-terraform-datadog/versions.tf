terraform {
  required_version = ">= 0.13"
  required_providers {
    datadog = {
      source = "datadog/datadog"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}
