output "asp_id" {
  description = "The ID of the App service plan"
  value       = azurerm_service_plan.asp.id
}

output "asp_name" {
  description = "Name of the App service plan"
  value = azurerm_service_plan.asp.name
}