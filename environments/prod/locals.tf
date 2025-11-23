# Production Environment Locals
# Specific overrides for production environment

locals {
  prod_specific = {
    enable_logging     = true
    log_retention      = 90
    backup_enabled     = true
    enable_encryption  = true
    enable_monitoring  = true
    high_availability  = true
  }
}
