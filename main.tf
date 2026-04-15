locals {
  alarm_name = coalesce(var.alarm_name, "${var.md_metadata.name_prefix}-${lower(replace(var.display_name, " ", ""))}")
  filter     = "metric.type=\"${var.metric_type}\" AND resource.type=\"${var.resource_type}\" AND metadata.user_labels.md-package=\"${var.md_metadata.name_prefix}\""
}

resource "google_monitoring_alert_policy" "alarm" {
  display_name = local.alarm_name
  combiner     = "OR"

  conditions {
    display_name = var.display_name
    condition_threshold {
      filter          = local.filter
      duration        = "${var.duration}s"
      comparison      = var.comparison
      threshold_value = var.threshold

      dynamic "aggregations" {
        for_each = var.aggregations != null ? [var.aggregations] : []
        content {
          alignment_period     = "${aggregations.value.alignment_period}s"
          cross_series_reducer = aggregations.value.cross_series_reducer
          per_series_aligner   = aggregations.value.per_series_aligner
        }
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = [var.notification_channel_id]
  user_labels           = var.md_metadata.default_tags
}

resource "massdriver_package_alarm" "package_alarm" {
  display_name      = var.display_name
  cloud_resource_id = google_monitoring_alert_policy.alarm.id
}
