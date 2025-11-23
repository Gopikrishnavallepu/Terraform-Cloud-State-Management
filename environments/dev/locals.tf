# Development Environment Locals
# Specific overrides for dev environment

locals {
  dev_specific = {
    enable_logging = true
    log_retention  = 7
    backup_enabled = false
  }
}
