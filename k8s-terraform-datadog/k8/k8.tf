terraform {
  required_providers {

    helm = {
      source  = "hashicorp/helm"
      version = "~> 1.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.11"
    }
    datadog = {
      source = "datadog/datadog"
    }
  }

  required_version = "~> 0.13.4"
}

variable "application_name" {
  type        = string
  description = "Application Name"
  default     = "beacon"
}
# see https://www.terraform.io/docs/providers/kubernetes/index.html for more information
provider "kubernetes" {
  # load Kubernetes Cluster configuration from `~/.kubectl/config` as opposed to manually
  # configuring `host`, `client_certificate`, `client_key`, and `cluster_ca_certificate`.
  load_config_file = true
}

provider "helm" {
  kubernetes {}
}

resource "kubernetes_namespace" "beacon" {
  metadata {
    name = "beacon"
  }
}

resource "kubernetes_deployment" "beacon" {
  metadata {
    name      = var.application_name
    namespace = kubernetes_namespace.beacon.id
    labels = {
      app = var.application_name
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = var.application_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.application_name
        }
      }

      spec {
        container {
          image = "onlydole/beacon:datadog"
          name  = var.application_name
        }
      }
    }
  }
}

resource "kubernetes_service" "beacon" {
  metadata {
    name      = var.application_name
    namespace = kubernetes_namespace.beacon.id
  }
  spec {
    selector = {
      app = kubernetes_deployment.beacon.metadata[0].labels.app
    }
    port {
      port        = 8080
      target_port = 80
    }
    type = "LoadBalancer"
  }
}