# Staging Environment Locals
# Specific overrides for staging environment

locals {
  staging_specific = {
    enable_logging = true
    log_retention  = 30
    backup_enabled = true
  }
}
