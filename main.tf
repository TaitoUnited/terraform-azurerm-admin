/**
 * Copyright 2021 Taito United
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {
  subscription_id = var.subscription_id != "" ? var.subscription_id : null
}

locals {
  customRoles = try(var.custom_roles, [])
  permissions = try(var.permissions, [])

  userRoles = flatten([
    for user in [for p in local.permissions: p if p.type == "user"]: [
      for role in user.roles:
      {
        key  = "${user.name}-${role.name}-${role.scope}"
        user = user
        role = role
      }
    ]
  ])

  groupRoles = flatten([
    for group in [for p in local.permissions: p if p.type == "group"]: [
      for role in group.roles:
      {
        key  = "${group.name}-${role.name}-${role.scope}"
        group = group
        role = role
      }
    ]
  ])

  serviceRoles = flatten([
    for service in [for p in local.permissions: p if p.type == "service"]: [
      for role in service.roles:
      {
        key  = "${service.name}-${role.name}-${role.scope}"
        service = service
        role = role
      }
    ]
  ])
}
