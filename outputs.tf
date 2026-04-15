output "id" {
  value       = google_monitoring_alert_policy.alarm.id
  description = "The ID of the GCP monitoring alert policy."
}

output "name" {
  value       = google_monitoring_alert_policy.alarm.name
  description = "The resource name of the GCP monitoring alert policy."
}
