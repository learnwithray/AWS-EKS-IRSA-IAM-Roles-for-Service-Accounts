# AWS Region
variable "region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = ""
}
# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = ""
}
# organization Division
variable "organization" {
  description = "organization- Infrastructure belongs"
  type        = string
  default     = ""
}
# team Variable
variable "team" {
  description = "organization team for  Infrastructure belongs"
  type        = string
  default     = ""
}