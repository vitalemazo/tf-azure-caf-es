# Declare the Terraform Module for Cloud Adoption Framework
# Enterprise-scale and provide a base configuration.
module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "3.1.2"

  providers = {
    azurerm              = azurerm
    azurerm.management   = azurerm.management
    azurerm.connectivity = azurerm.connectivity
  }

  # Base module configuration settings.
  root_parent_id   = data.azurerm_client_config.current.tenant_id
  root_id          = local.root_id
  root_name        = local.root_name
  default_location = local.default_location

  # Control deployment of the core landing zone hierachy.
  deploy_core_landing_zones   = true
  deploy_corp_landing_zones   = local.deploy_corp_landing_zones
  deploy_online_landing_zones = local.deploy_online_landing_zones
  deploy_sap_landing_zones    = local.deploy_sap_landing_zones

  custom_landing_zones = {
    "${local.root_id}-docsquad-tf" = {
      display_name               = "docsquad"
      parent_management_group_id = "${local.root_id}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "default_empty"
        parameters     = {}
        access_control = {}
      }
    }
  }


  # Configuration settings for management resources.
  # These are used to ensure Azure Policy is correctly configured with the same
  # settings as the resources deployed by module.enterprise_scale_management.
  # Please refer to file: settings.management.tf
  deploy_management_resources    = true
  configure_management_resources = local.configure_management_resources
  subscription_id_management     = data.azurerm_client_config.management.subscription_id





  # Configuration settings for connectivity resources.
  # Uses default settings.
  deploy_connectivity_resources    = true
  subscription_id_connectivity     = data.azurerm_client_config.connectivity.subscription_id
  configure_connectivity_resources = local.configure_connectivity_resources

}
