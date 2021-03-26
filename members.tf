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

data "azuread_user" "user" {
  for_each             = {for item in local.userRoles: item.key => item}
  user_principal_name  = each.value.user.name
}

data "azuread_group" "group" {
  for_each             = {for item in local.groupRoles: item.key => item}
  display_name         = each.value.group.name
}

data "azuread_service_principal" "service" {
  for_each             = {for item in local.serviceRoles: item.key => item}
  display_name         = each.value.service.name
}

data "azurerm_role_definition" "user_role" {
  depends_on           = [ azurerm_role_definition.role ]
  for_each             = {for item in local.userRoles: item.key => item}
  name                 = each.value.role.name
  scope                = each.value.role.type == "custom" ? data.azurerm_subscription.current.id : null
}

data "azurerm_role_definition" "group_role" {
  depends_on           = [ azurerm_role_definition.role ]
  for_each             = {for item in local.groupRoles: item.key => item}
  name                 = each.value.role.name
  scope                = each.value.role.type == "custom" ? data.azurerm_subscription.current.id : null
}

data "azurerm_role_definition" "service_role" {
  depends_on           = [ azurerm_role_definition.role ]
  for_each             = {for item in local.serviceRoles: item.key => item}
  name                 = each.value.role.name
  scope                = each.value.role.type == "custom" ? data.azurerm_subscription.current.id : null
}

resource "azurerm_role_assignment" "user_role" {
  for_each             = {for item in local.userRoles: item.key => item}

  scope                = each.value.role.scope != null ? each.value.role.scope : data.azurerm_subscription.current.id
  role_definition_id   = data.azurerm_role_definition.user_role[each.key].id
  principal_id         = data.azuread_user.user[each.key].object_id
}

resource "azurerm_role_assignment" "group_role" {
  for_each             = {for item in local.groupRoles: item.key => item}

  scope                = each.value.role.scope != null ? each.value.role.scope : data.azurerm_subscription.current.id
  role_definition_id   = data.azurerm_role_definition.group_role[each.key].id
  principal_id         = data.azuread_group.group[each.key].object_id
}

resource "azurerm_role_assignment" "service_role" {
  for_each             = {for item in local.serviceRoles: item.key => item}

  scope                = each.value.role.scope != null ? each.value.role.scope : data.azurerm_subscription.current.id
  role_definition_id   = data.azurerm_role_definition.service_role[each.key].id
  principal_id         = data.azuread_service_principal.service[each.key].object_id
}
