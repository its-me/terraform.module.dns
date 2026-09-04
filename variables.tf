variable "project_id" {
  description = "GCP project ID the managed zone lives in."
  type        = string
}

variable "zone_name" {
  description = "Cloud DNS managed zone resource name (e.g. \"example-com\" for example.com)."
  type        = string
}

variable "create_zone" {
  description = "Whether this caller creates the managed zone (true), or just reads back a zone created elsewhere (false, e.g. a zone set up manually when the domain was registered)."
  type        = bool
  default     = false
}

variable "dns_name" {
  description = "DNS suffix for the zone, with trailing dot (e.g. \"example.com.\"). Required when create_zone = true."
  type        = string
  default     = null
}

variable "description" {
  description = "Description for the managed zone. Only used when create_zone = true."
  type        = string
  default     = "Managed by Terraform."
}

variable "records" {
  description = "DNS record sets to manage in the zone, keyed by an arbitrary caller-chosen label (so the same hostname can have multiple types, e.g. \"crm_a\" and \"crm_aaaa\"). Only touches the records listed here; every other record already in the zone (MX, TXT, unrelated apps, ...) is left alone."
  type = map(object({
    name    = string
    type    = string
    ttl     = optional(number, 300)
    rrdatas = list(string)
  }))
  default = {}
}
