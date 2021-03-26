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

variable "subscription_id" {
  type = string
  default = ""
}

variable "permissions" {
  type = list(object({
    name = string
    type = string
    roles = list(object({
      name = string
      type = optional(string)
      scope = optional(string)
    }))
  }))
  default = []
  description = "Resources as JSON (see README.md). You can read values from a YAML file with yamldecode()."
}

variable "custom_roles" {
  type = list(object({
    name = string
    description = optional(string)
    actions = optional(list(string))
    notActions = optional(list(string))
    dataActions = optional(list(string))
    notDataActions = optional(list(string))
    assignableScopes = optional(list(string))
  }))
  default = []
  description = "Resources as JSON (see README.md). You can read values from a YAML file with yamldecode()."
}
