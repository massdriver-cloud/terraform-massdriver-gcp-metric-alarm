# Massdriver Variables

variable "md_metadata" {
  type        = any
  description = "Massdriver metadata object, must include name_prefix and default_tags."
}

variable "message" {
  type        = string
  description = "A message including additional context for this alarm."
}

variable "display_name" {
  type        = string
  description = "Short name to display in the Massdriver UI."
}

variable "notification_channel_id" {
  type        = string
  description = "Massdriver Alarm Channel - Notification Channel ID."
}

# Alarm Configuration

variable "alarm_name" {
  type        = string
  default     = null
  description = "Override for the alert policy display name in GCP. Defaults to a generated name based on md_metadata.name_prefix and display_name."
}

variable "metric_type" {
  type        = string
  description = "The GCP metric type (e.g., compute.googleapis.com/instance/cpu/utilization)."
}

variable "resource_type" {
  type        = string
  description = "The GCP monitored resource type (e.g., gce_instance)."
}

variable "comparison" {
  type        = string
  description = "The comparison to apply between the time series and the threshold. Valid values: COMPARISON_GT, COMPARISON_GE, COMPARISON_LT, COMPARISON_LE, COMPARISON_EQ, COMPARISON_NE."
  validation {
    condition = contains([
      "COMPARISON_GT",
      "COMPARISON_GE",
      "COMPARISON_LT",
      "COMPARISON_LE",
      "COMPARISON_EQ",
      "COMPARISON_NE",
    ], var.comparison)
    error_message = "comparison must be one of: COMPARISON_GT, COMPARISON_GE, COMPARISON_LT, COMPARISON_LE, COMPARISON_EQ, COMPARISON_NE."
  }
}

variable "threshold" {
  type        = number
  description = "The value against which the metric is compared."
}

variable "duration" {
  type        = number
  description = "The amount of time in seconds that a time series must violate the threshold to trigger an alert. Must be at least 60."
  validation {
    condition     = var.duration >= 60
    error_message = "Duration must be at least 60 seconds."
  }
}

variable "aggregations" {
  type = object({
    alignment_period     = optional(number, 60)
    per_series_aligner   = optional(string, "ALIGN_MAX")
    cross_series_reducer = optional(string, "REDUCE_MEAN")
  })
  default     = null
  description = "Aggregation settings for numeric metrics. When null, no aggregations are applied (suitable for boolean metrics). alignment_period is in seconds and must be at least 60."
  validation {
    condition     = var.aggregations == null || var.aggregations.alignment_period >= 60
    error_message = "alignment_period must be at least 60 seconds."
  }
}
