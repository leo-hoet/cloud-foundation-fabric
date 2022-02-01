# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# tfdoc:file:description Trasformation VPC.

module "trf-vpc" {
  count      = var.network_config.network != null ? 0 : 1
  source     = "../../../modules/net-vpc"
  project_id = module.trf-prj.project_id
  name       = "${local.prefix_trf}-vpc"
  subnets = [
    {
      ip_cidr_range      = var.network_config.vpc_subnet_range.transformation
      name               = "${local.prefix_trf}-subnet"
      region             = var.location_config.region
      secondary_ip_range = {}
    }
  ]
}

module "trf-vpc-firewall" {
  count        = var.network_config.network != null ? 0 : 1
  source       = "../../../modules/net-vpc-firewall"
  project_id   = module.trf-prj.project_id
  network      = module.trf-vpc[0].name
  admin_ranges = values(module.orc-vpc[0].subnet_ips)
}

module "trf-nat" {
  count          = var.network_config.network != null ? 0 : 1
  source         = "../../../modules/net-cloudnat"
  project_id     = module.trf-prj.project_id
  region         = var.location_config.region
  name           = "${local.prefix_trf}-default"
  router_network = module.trf-vpc[0].name
}
