variable "project_prefix" {
  type        = string
  description = "Project Prefix"
  default     = "dash-2020-terraform-workshop"
}

variable "project_description" {
  type        = string
  description = "Project Description"
  default     = "Project for Dash 2020 workshop: Pups and Pods"
}

variable "application_name" {
  type        = string
  description = "Application Name"
  default     = "beacon"
}

variable "datadog_user_email" {
  type        = string
  description = "Email address for Datadog User"
  default     = "rachel@hashicorp.com"
}

variable "datadog_api_key" {
  type        = string
  description = "Datadog API Key"
  # the value for this variable is available via the Katacoda environment
}

variable "datadog_app_key" {
  type        = string
  description = "Datadog App Key"
  # the value for this variable is available via the Katacoda environment
}



resource "helm_release" "datadog_agent" {
  name       = "datadog-agent"
  chart      = "datadog"
  repository = "https://helm.datadoghq.com"
  version    = "2.4.5"
  namespace  = kubernetes_namespace.beacon.id

  set_sensitive {
    name  = "datadog.apiKey"
    value = var.datadog_api_key
  }

  set {
    name  = "datadog.logs.enabled"
    value = true
  }

  set {
    name  = "datadog.logs.containerCollectAll"
    value = true
  }

  set {
    name  = "datadog.leaderElection"
    value = true
  }

  set {
    name  = "datadog.collectEvents"
    value = true
  }

  set {
    name  = "clusterAgent.enabled"
    value = true
  }

  set {
    name  = "clusterAgent.metricsProvider.enabled"
    value = true
  }

  set {
    name  = "datadog.systemProbe.enabled"
    value = true
  }
}

resource "datadog_monitor" "beacon" {
  name               = "Kubernetes Pod Health"
  type               = "metric alert"
  message            = "Kubernetes Pods are not in an optimal health state. Notify: @operator"
  escalation_message = "Please investigate the Kubernetes Pods, @operator"

  query = "max(last_1m):sum:docker.containers.running{short_image:beacon} <= 1"

  thresholds = {
    ok       = 3
    warning  = 2
    critical = 1
  }

  notify_no_data = true

  tags = ["app:beacon", "env:demo"]
}

resource "datadog_synthetics_test" "beacon" {
  type    = "api"
  subtype = "http"

  request = {
    method = "GET"
    url    = "localhost"
  }

  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }

  locations = ["aws:us-west-2"]
  options_list {
    tick_every          = 900
    min_location_failed = 1
  }

  name    = "Beacon API Check"
  message = "Oh no! Light from the Beacon app is no longer shining!"
  tags    = ["app:beacon", "env:demo"]

  status = "live"
}

resource "datadog_service_level_objective" "beacon" {
  name        = "${kubernetes_deployment.beacon.metadata[0].name} SLO"
  type        = "monitor"
  description = "SLO for the ${kubernetes_deployment.beacon.metadata[0].name} deployment"
  monitor_ids = [datadog_synthetics_test.beacon.monitor_id]

  thresholds {
    timeframe       = "7d"
    target          = 99.9
    warning         = 99.99
    target_display  = "99.9"
    warning_display = "99.99"
  }

  thresholds {
    timeframe       = "30d"
    target          = 99.9
    warning         = 99.99
    target_display  = "99.9"
    warning_display = "99.99"
  }

  tags = ["app:beacon", "env:demo"]
}

resource "datadog_dashboard" "beacon" {
  title        = "Beacon Service"
  description  = "A Datadog Dashboard for the ${kubernetes_deployment.beacon.metadata[0].name} deployment"
  layout_type  = "ordered"
  is_read_only = true

  widget {
    service_level_objective_definition {
      show_error_budget = true
      slo_id            = datadog_service_level_objective.beacon.id
      time_windows = [
        "7d",
        "30d",
      ]
      title     = "Beacon SLO"
      view_mode = "overall"
      view_type = "detail"
    }
  }

  widget {
    hostmap_definition {
      no_group_hosts  = true
      no_metric_hosts = true
      node_type       = "container"
      title           = "Kubernetes Pods"

      request {
        fill {
          q = "avg:process.stat.container.cpu.total_pct{image_name:onlydole/beacon} by {host}"
        }
      }

      style {
        palette      = "hostmap_blues"
        palette_flip = false
      }
    }
  }

  widget {


    timeseries_definition {
      show_legend = false
      title       = "CPU Utilization"

      request {
        display_type = "line"
        q            = "top(avg:docker.cpu.usage{image_name:onlydole/beacon} by {docker_image,container_id}, 10, 'mean', 'desc')"

        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "dog_classic"
        }
      }

      yaxis {
        include_zero = true
        max          = "auto"
        min          = "auto"
        scale        = "linear"
      }
    }
  }
  widget {


    alert_graph_definition {
      alert_id = datadog_monitor.beacon.id
      title    = "Kubernetes Node CPU"
      viz_type = "timeseries"
    }
  }
  widget {
    hostmap_definition {
      no_group_hosts  = true
      no_metric_hosts = true
      node_type       = "host"
      title           = "Kubernetes Nodes"

      request {
        fill {
          q = "avg:system.cpu.user{*} by {host}"
        }
      }

      style {
        palette      = "hostmap_blues"
        palette_flip = false
      }
    }
  }

  widget {
    timeseries_definition {
      show_legend = false
      title       = "Memory Utilization"
      request {
        display_type = "line"
        q            = "top(avg:docker.mem.in_use{image_name:onlydole/beacon} by {container_name}, 10, 'mean', 'desc')"

        style {
          line_type  = "solid"
          line_width = "normal"
          palette    = "dog_classic"
        }
      }
      yaxis {
        include_zero = true
        max          = "auto"
        min          = "auto"
        scale        = "linear"
      }
    }
  }
}

resource "datadog_user" "operator" {
  access_role = "st"
  disabled    = false
  email       = var.datadog_user_email
  handle      = var.datadog_user_email
  name        = "Operator"
}


# see https://www.terraform.io/docs/providers/datadog/index.html for more information
provider "datadog" {
  # The values for `api_key` and `app_key` are populated from the environment
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
}




output "beacon_dashboard" {
  description = "Datadog dashboard for the Beacon application"
  value       = "https://app.datadoghq.com${datadog_dashboard.beacon.url}"
}
