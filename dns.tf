# One caller (create_zone = true) can provision the managed zone itself. Every other
# caller (create_zone = false, the default) just reads back a zone that already exists
# -- e.g. one created manually when the domain was registered, as is the case for every
# zone this module targets today. Either way, only the record sets listed in
# var.records are managed here; the rest of the zone's records (MX, TXT, unrelated
# subdomains, ...) are left untouched.

resource "google_dns_managed_zone" "this" {
  count = var.create_zone ? 1 : 0

  name        = var.zone_name
  project     = var.project_id
  dns_name    = var.dns_name
  description = var.description
}

data "google_dns_managed_zone" "this" {
  count = var.create_zone ? 0 : 1

  name    = var.zone_name
  project = var.project_id
}

locals {
  zone_name     = var.create_zone ? google_dns_managed_zone.this[0].name : data.google_dns_managed_zone.this[0].name
  zone_dns_name = var.create_zone ? google_dns_managed_zone.this[0].dns_name : data.google_dns_managed_zone.this[0].dns_name
  name_servers  = var.create_zone ? google_dns_managed_zone.this[0].name_servers : data.google_dns_managed_zone.this[0].name_servers
}

resource "google_dns_record_set" "this" {
  for_each = var.records

  project      = var.project_id
  managed_zone = local.zone_name
  name         = "${trimsuffix(each.value.name, ".")}."
  type         = each.value.type
  ttl          = each.value.ttl
  rrdatas      = each.value.rrdatas
}
