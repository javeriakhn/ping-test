output "imported_charts" {
  description = "The list of charts that were imported and deployed."
  value       = [for chart in var.charts : chart.chart_name]
}
