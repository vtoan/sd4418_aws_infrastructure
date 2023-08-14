output "rg_name" {
  value = azurerm_resource_group.example.name
}

output "vm_pip" {
  value = azurerm_public_ip.example.ip_address
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.example.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.example.kube_config_raw
  sensitive = true
}

output "kube_cluster_name" {
  value = azurerm_kubernetes_cluster.example.name
}
