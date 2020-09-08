#### Azure Output Variables ####

output "ip_address" {
  value = "${azurerm_container_group.app.ip_address}:3000"
}

#the dns fqdn of the container group if dns_name_label is set
output "fqdn" {
  value = "http://${azurerm_container_group.app.fqdn}:3000"
}

output "contrast" { 
  value = "This app should appear in the environment ${data.external.yaml.result.url}" 
}