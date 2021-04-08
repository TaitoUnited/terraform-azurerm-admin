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

resource "azurerm_role_definition" "role" {
  for_each    = {for item in local.customRoles: item.key => item}

  name        = each.value.name
  scope       = each.value.scope != null ? each.value.scope : data.azurerm_subscription.current.id
  description = each.value.description
  permissions {
    actions = coalesce(each.value.actions, [])
    not_actions = coalesce(each.value.notActions, [])
    data_actions = coalesce(each.value.dataActions, [])
    not_data_actions = coalesce(each.value.notDataActions, [])
  }
  assignable_scopes = coalesce(each.value.assignableScopes, [])
}
