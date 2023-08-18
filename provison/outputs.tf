output "rg_name" {
  value = azurerm_resource_group.example.name
}

output "acr_name" {
  value = azurerm_container_registry.example.name
}

output "kube_cluster_name" {
  value = azurerm_kubernetes_cluster.example.name
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.example.kube_config_raw
  sensitive = true
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.example.kube_config.0.client_certificate
  sensitive = true
}

output "app_ip_address" {
  value = azurerm_public_ip.example.ip_address
}
