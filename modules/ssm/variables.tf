variable "parameter_name" {
  description = "Name of the SSM parameter"
  type        = string
  default     = "/demo/config"
}

variable "parameter_type" {
  description = "Type of the SSM parameter"
  type        = string
  default     = "String"
}

variable "parameter_value" {
  description = "Value of the SSM parameter"
  type        = string
  default     = "example-value"
}

variable "parameter_description" {
  description = "Description of the SSM parameter"
  type        = string
  default     = "Demo app config"
}
