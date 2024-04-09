variable "rg_name" {
  type        = string
  description = "Name of the resource group"
  default     = "example"
}

variable "location" {
  type        = string
  description = "Location"
  default     = "example"
}

variable "sa_name" {
  type        = string
  description = "Storage Account Name"
  default     = "example"
}

variable "github_token" {
  type        = string
  description = "GitHub personal access token"
  sensitive   = true
}

variable "asuid_value" {
  description = "ASUID value for TXT record"
  type        = string
}

  