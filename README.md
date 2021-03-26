# Azure administration

Provides IAM and other administration configurations for your infrastructure.

Example usage:

```
provider "azurerm" {
  features {}
}

module "admin" {
  source              = "TaitoUnited/admin/azurerm"
  version             = "1.0.0"

  subscription_id     = "/subscriptions/00000000-0000-0000-0000-000000000000"

  permissions         = yamldecode(file("${path.root}/../infra.yaml"))["permissions"]
  custom_roles        = yamldecode(file("${path.root}/../infra.yaml"))["customRoles"]
}
```

Example YAML:

```
permissions:
  - name: devops
    type: group
    roles:
      - name: Azure Kubernetes Service Cluster Admin Role
      - name: Log Analytics Reader
  - name: developers
    type: group
    roles:
      - name: Azure Kubernetes Service Cluster User Role
        scope: /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/development
      - name: Log Analytics Reader
        scope: /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/development
  - name: john.doe@mydomain.com
    type: user
    roles:
      - name: Log Analytics Reader
        scope: /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/production
  - name: my-app-dev
    type: service
    roles:
      - name: my-app-dev
        type: custom
        scope: /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/development

customRoles:
  - name: my-app
    description: Custom role for my app
    actions:
      - Microsoft.Storage/storageAccounts/queueServices/queues/read
    dataActions:
      - Microsoft.Storage/storageAccounts/queueServices/queues/messages/read
    assignableScopes:
      - /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/development
      - /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/production
```

YAML attributes:

- See variables.tf for all the supported YAML attributes.
- See [Azure built-in roles](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles).

Combine with the following modules to get a complete infrastructure defined by YAML:

- [Admin](https://registry.terraform.io/modules/TaitoUnited/admin/azurerm)
- [DNS](https://registry.terraform.io/modules/TaitoUnited/dns/azurerm)
- [Network](https://registry.terraform.io/modules/TaitoUnited/network/azurerm)
- [Kubernetes](https://registry.terraform.io/modules/TaitoUnited/kubernetes/azurerm)
- [Databases](https://registry.terraform.io/modules/TaitoUnited/databases/azurerm)
- [Storage](https://registry.terraform.io/modules/TaitoUnited/storage/azurerm)
- [Monitoring](https://registry.terraform.io/modules/TaitoUnited/monitoring/azurerm)
- [Integrations](https://registry.terraform.io/modules/TaitoUnited/integrations/azurerm)
- [PostgreSQL privileges](https://registry.terraform.io/modules/TaitoUnited/privileges/postgresql)
- [MySQL privileges](https://registry.terraform.io/modules/TaitoUnited/privileges/mysql)

TIP: Similar modules are also available for AWS, Google Cloud, and DigitalOcean. All modules are used by [infrastructure templates](https://taitounited.github.io/taito-cli/templates#infrastructure-templates) of [Taito CLI](https://taitounited.github.io/taito-cli/). See also [Azure project resources](https://registry.terraform.io/modules/TaitoUnited/project-resources/azurerm), [Full Stack Helm Chart](https://github.com/TaitoUnited/taito-charts/blob/master/full-stack), and [full-stack-template](https://github.com/TaitoUnited/full-stack-template).

Contributions are welcome!
