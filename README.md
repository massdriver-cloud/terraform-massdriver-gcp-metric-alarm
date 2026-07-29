# terraform-massdriver-gcp-metric-alarm

Creates a Massdriver-integrated GCP Cloud Monitoring alert policy. Supports both boolean and numeric (threshold) metric alarms using a single resource with optional aggregations.

Designed to be used with a Massdriver alarm channel module that provides the `notification_channel_id`.

Registers the alarm with Massdriver for UI visibility via `massdriver_instance_alarm`.

## Usage

### Boolean metric alarm (no aggregations)

```hcl
module "alarm" {
  source = "github.com/massdriver-cloud/terraform-massdriver-gcp-metric-alarm"

  md_metadata             = var.md_metadata
  display_name            = "Instance Running"
  message                 = "Instance is not running"
  notification_channel_id = var.notification_channel_id
  metric_type             = "compute.googleapis.com/instance/uptime"
  resource_type           = "gce_instance"
  comparison              = "COMPARISON_LT"
  threshold               = 1
  duration                = 60
}
```

### Numeric metric alarm (with aggregations)

```hcl
module "alarm" {
  source = "github.com/massdriver-cloud/terraform-massdriver-gcp-metric-alarm"

  md_metadata             = var.md_metadata
  display_name            = "High CPU"
  message                 = "CPU utilization is above 80%"
  notification_channel_id = var.notification_channel_id
  metric_type             = "compute.googleapis.com/instance/cpu/utilization"
  resource_type           = "gce_instance"
  comparison              = "COMPARISON_GT"
  threshold               = 0.8
  duration                = 60

  aggregations = {
    alignment_period     = 60
    per_series_aligner   = "ALIGN_MAX"
    cross_series_reducer = "REDUCE_MEAN"
  }
}
```

## Providers

- `hashicorp/google`
- `massdriver-cloud/massdriver` (>= 2.0)
