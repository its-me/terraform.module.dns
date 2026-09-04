output "zone_name" {
  description = "Name of the managed zone."
  value       = local.zone_name
}

output "zone_dns_name" {
  description = "DNS suffix of the managed zone (e.g. \"example.com.\")."
  value       = local.zone_dns_name
}

output "name_servers" {
  description = "Name servers for the managed zone. Only meaningful the first time a zone is created; point the domain's registrar at these."
  value       = local.name_servers
}

output "record_ids" {
  description = "Map of the same keys as var.records -> the created record set's ID."
  value       = { for key, record in google_dns_record_set.this : key => record.id }
}
