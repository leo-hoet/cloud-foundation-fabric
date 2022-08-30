# GKE Multitenant Module

TODO: add brief explanation and refer back to dev folder?

<p align="center">
  <img src="diagram.png" alt="GKE multitenant">
</p>

This is an example of that shows the use of the above variables:

```hcl
# the `cluster_defaults` variable defaults are used and not shown here
clusters = {
  "gke-00" = {
    cluster_autoscaling = null
    description         = "gke-00"
    dns_domain          = null
    location            = "europe-west1"
    labels              = {}
    net = {
      master_range = "172.17.16.0/28"
      pods         = "pods"
      services     = "services"
      subnet       = local.vpc.subnet_self_links["europe-west3/gke-dev-0"]
    }
    overrides = null
  }
  "gke-01" = {
    cluster_autoscaling = null
    description         = "gke-01"
    dns_domain          = null
    location            = "europe-west3"
    labels              = {}
    net = {
      master_range = "172.17.17.0/28"
      pods         = "pods"
      services     = "services"
      subnet       = local.vpc.subnet_self_links["europe-west3/gke-dev-0"]
    }
    overrides = {
      cloudrun_config                 = false
      database_encryption_key         = null
      gcp_filestore_csi_driver_config = true
      master_authorized_ranges = {
        rfc1918_1 = "10.0.0.0/8"
      }
      max_pods_per_node        = 64
      pod_security_policy      = true
      release_channel          = "STABLE"
      vertical_pod_autoscaling = false
    }
  }
}
nodepools = {
  "gke-0" = {
    "gke-00-000" = {
      initial_node_count = 1
      node_count         = 1
      node_type          = "n2-standard-4"
      overrides          = null
      spot               = false
    }
  }
  "gke-1" = {
    "gke-01-000" = {
      initial_node_count = 1
      node_count         = 1
      node_type          = "n2-standard-4"
      overrides          = {
        image_type        = "UBUNTU_CONTAINERD"
        max_pods_per_node = 64
        node_locations    = []
        node_tags         = []
        node_taints       = []
      }
      spot               = true
    }
  }
}
```

```hcl
fleet_configmanagement_templates = {
  default = {
    binauthz = false
    config_sync = {
      git = {
        gcp_service_account_email = null
        https_proxy               = null
        policy_dir                = "configsync"
        secret_type               = "none"
        source_format             = "hierarchy"
        sync_branch               = "main"
        sync_repo                 = "https://github.com/.../..."
        sync_rev                  = null
        sync_wait_secs            = null
      }
      prevent_drift = true
      source_format = "hierarchy"
    }
    hierarchy_controller = null
    policy_controller    = null
    version              = "1.10.2"
  }
}

fleet_configmanagement_clusters = {
  default = ["gke-1", "gke-2"]
}

fleet_features = {
  appdevexperience             = false
  configmanagement             = false
  identityservice              = false
  multiclusteringress          = "gke-1"
  multiclusterservicediscovery = true
  servicemesh                  = false
}
```

<!-- TFDOC OPTS files:1 show_extra:1 -->
<!-- BEGIN TFDOC -->

## Files

| name | description | modules |
|---|---|---|
| [gke-clusters.tf](./gke-clusters.tf) | None | <code>gke-cluster</code> |
| [gke-hub.tf](./gke-hub.tf) | None | <code>gke-hub</code> |
| [gke-nodepools.tf](./gke-nodepools.tf) | None | <code>gke-nodepool</code> |
| [main.tf](./main.tf) | Module-level locals and resources. | <code>bigquery-dataset</code> · <code>project</code> |
| [outputs.tf](./outputs.tf) | Output variables. |  |
| [variables.tf](./variables.tf) | Module variables. |  |

## Variables

| name | description | type | required | default | producer |
|---|---|:---:|:---:|:---:|:---:|
| [billing_account_id](variables.tf#L27) | Billing account id. | <code>string</code> | ✓ |  |  |
| [clusters](variables.tf#L61) |  | <code title="map&#40;object&#40;&#123;&#10;  cluster_autoscaling &#61; object&#40;&#123;&#10;    cpu_min    &#61; number&#10;    cpu_max    &#61; number&#10;    memory_min &#61; number&#10;    memory_max &#61; number&#10;  &#125;&#41;&#10;  description &#61; string&#10;  dns_domain  &#61; string&#10;  labels      &#61; map&#40;string&#41;&#10;  location    &#61; string&#10;  net &#61; object&#40;&#123;&#10;    master_range &#61; string&#10;    pods         &#61; string&#10;    services     &#61; string&#10;    subnet       &#61; string&#10;  &#125;&#41;&#10;  overrides &#61; object&#40;&#123;&#10;    cloudrun_config         &#61; bool&#10;    database_encryption_key &#61; string&#10;    master_authorized_ranges        &#61; map&#40;string&#41;&#10;    max_pods_per_node               &#61; number&#10;    pod_security_policy             &#61; bool&#10;    release_channel                 &#61; string&#10;    vertical_pod_autoscaling        &#61; bool&#10;    gcp_filestore_csi_driver_config &#61; bool&#10;  &#125;&#41;&#10;&#125;&#41;&#41;">map&#40;object&#40;&#123;&#8230;&#125;&#41;&#41;</code> | ✓ |  |  |
| [folder_id](variables.tf#L163) | Folder used for the GKE project in folders/nnnnnnnnnnn format. | <code>string</code> | ✓ |  |  |
| [nodepools](variables.tf#L206) |  | <code title="map&#40;map&#40;object&#40;&#123;&#10;  node_count         &#61; number&#10;  node_type          &#61; string&#10;  initial_node_count &#61; number&#10;  overrides &#61; object&#40;&#123;&#10;    image_type        &#61; string&#10;    max_pods_per_node &#61; number&#10;    node_locations    &#61; list&#40;string&#41;&#10;    node_tags         &#61; list&#40;string&#41;&#10;    node_taints       &#61; list&#40;string&#41;&#10;  &#125;&#41;&#10;  spot &#61; bool&#10;&#125;&#41;&#41;&#41;">map&#40;map&#40;object&#40;&#123;&#8230;&#125;&#41;&#41;&#41;</code> | ✓ |  |  |
| [prefix](variables.tf#L236) | Prefix used for resources that need unique names. | <code>string</code> | ✓ |  |  |
| [project_id](variables.tf#L241) | ID of the project that will contain all the clusters. | <code>string</code> | ✓ |  |  |
| [vpc_config](variables.tf#L253) | Shared VPC project and VPC details. | <code title="object&#40;&#123;&#10;  host_project_id &#61; string&#10;  vpc_self_link   &#61; string&#10;&#125;&#41;">object&#40;&#123;&#8230;&#125;&#41;</code> | ✓ |  |  |
| [authenticator_security_group](variables.tf#L21) | Optional group used for Groups for GKE. | <code>string</code> |  | <code>null</code> |  |
| [cluster_defaults](variables.tf#L32) | Default values for optional cluster configurations. | <code title="object&#40;&#123;&#10;  cloudrun_config                 &#61; bool&#10;  database_encryption_key         &#61; string&#10;  master_authorized_ranges        &#61; map&#40;string&#41;&#10;  max_pods_per_node               &#61; number&#10;  pod_security_policy             &#61; bool&#10;  release_channel                 &#61; string&#10;  vertical_pod_autoscaling        &#61; bool&#10;  gcp_filestore_csi_driver_config &#61; bool&#10;&#125;&#41;">object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code title="&#123;&#10;  cloudrun_config         &#61; false&#10;  database_encryption_key &#61; null&#10;  master_authorized_ranges &#61; &#123;&#10;    rfc1918_1 &#61; &#34;10.0.0.0&#47;8&#34;&#10;    rfc1918_2 &#61; &#34;172.16.0.0&#47;12&#34;&#10;    rfc1918_3 &#61; &#34;192.168.0.0&#47;16&#34;&#10;  &#125;&#10;  max_pods_per_node               &#61; 110&#10;  pod_security_policy             &#61; false&#10;  release_channel                 &#61; &#34;STABLE&#34;&#10;  vertical_pod_autoscaling        &#61; false&#10;  gcp_filestore_csi_driver_config &#61; false&#10;&#125;">&#123;&#8230;&#125;</code> |  |
| [dns_domain](variables.tf#L94) | Domain name used for clusters, prefixed by each cluster name. Leave null to disable Cloud DNS for GKE. | <code>string</code> |  | <code>null</code> |  |
| [fleet_configmanagement_clusters](variables.tf#L100) | Config management features enabled on specific sets of member clusters, in config name => [cluster name] format. | <code>map&#40;list&#40;string&#41;&#41;</code> |  | <code>&#123;&#125;</code> |  |
| [fleet_configmanagement_templates](variables.tf#L108) | Sets of config management configurations that can be applied to member clusters, in config name => {options} format. | <code title="map&#40;object&#40;&#123;&#10;  binauthz &#61; bool&#10;  config_sync &#61; object&#40;&#123;&#10;    git &#61; object&#40;&#123;&#10;      gcp_service_account_email &#61; string&#10;      https_proxy               &#61; string&#10;      policy_dir                &#61; string&#10;      secret_type               &#61; string&#10;      sync_branch               &#61; string&#10;      sync_repo                 &#61; string&#10;      sync_rev                  &#61; string&#10;      sync_wait_secs            &#61; number&#10;    &#125;&#41;&#10;    prevent_drift &#61; string&#10;    source_format &#61; string&#10;  &#125;&#41;&#10;  hierarchy_controller &#61; object&#40;&#123;&#10;    enable_hierarchical_resource_quota &#61; bool&#10;    enable_pod_tree_labels             &#61; bool&#10;  &#125;&#41;&#10;  policy_controller &#61; object&#40;&#123;&#10;    audit_interval_seconds     &#61; number&#10;    exemptable_namespaces      &#61; list&#40;string&#41;&#10;    log_denies_enabled         &#61; bool&#10;    referential_rules_enabled  &#61; bool&#10;    template_library_installed &#61; bool&#10;  &#125;&#41;&#10;  version &#61; string&#10;&#125;&#41;&#41;">map&#40;object&#40;&#123;&#8230;&#125;&#41;&#41;</code> |  | <code>&#123;&#125;</code> |  |
| [fleet_features](variables.tf#L143) | Enable and configue fleet features. Set to null to disable GKE Hub if fleet workload identity is not used. | <code title="object&#40;&#123;&#10;  appdevexperience             &#61; bool&#10;  configmanagement             &#61; bool&#10;  identityservice              &#61; bool&#10;  multiclusteringress          &#61; string&#10;  multiclusterservicediscovery &#61; bool&#10;  servicemesh                  &#61; bool&#10;&#125;&#41;">object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code>null</code> |  |
| [fleet_workload_identity](variables.tf#L156) | Use Fleet Workload Identity for clusters. Enables GKE Hub if set to true. | <code>bool</code> |  | <code>true</code> |  |
| [group_iam](variables.tf#L168) | Project-level IAM bindings for groups. Use group emails as keys, list of roles as values. | <code>map&#40;list&#40;string&#41;&#41;</code> |  | <code>&#123;&#125;</code> |  |
| [iam](variables.tf#L175) | Project-level authoritative IAM bindings for users and service accounts in  {ROLE => [MEMBERS]} format. | <code>map&#40;list&#40;string&#41;&#41;</code> |  | <code>&#123;&#125;</code> |  |
| [labels](variables.tf#L182) | Project-level labels. | <code>map&#40;string&#41;</code> |  | <code>&#123;&#125;</code> |  |
| [nodepool_defaults](variables.tf#L188) |  | <code title="object&#40;&#123;&#10;  image_type        &#61; string&#10;  max_pods_per_node &#61; number&#10;  node_locations    &#61; list&#40;string&#41;&#10;  node_tags         &#61; list&#40;string&#41;&#10;  node_taints       &#61; list&#40;string&#41;&#10;&#125;&#41;">object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code title="&#123;&#10;  image_type        &#61; &#34;COS_CONTAINERD&#34;&#10;  max_pods_per_node &#61; 110&#10;  node_locations    &#61; null&#10;  node_tags         &#61; null&#10;  node_taints       &#61; &#91;&#93;&#10;&#125;">&#123;&#8230;&#125;</code> |  |
| [peering_config](variables.tf#L223) | Configure peering with the control plane VPC. Requires compute.networks.updatePeering. Set to null if you don't want to update the default peering configuration. | <code title="object&#40;&#123;&#10;  export_routes &#61; bool&#10;  import_routes &#61; bool&#10;&#125;&#41;">object&#40;&#123;&#8230;&#125;&#41;</code> |  | <code title="&#123;&#10;  export_routes &#61; true&#10;  &#47;&#47; TODO&#40;jccb&#41; is there any situation where the control plane VPC would export any routes&#63;&#10;  import_routes &#61; false&#10;&#125;">&#123;&#8230;&#125;</code> |  |
| [project_services](variables.tf#L246) | Additional project services to enable. | <code>list&#40;string&#41;</code> |  | <code>&#91;&#93;</code> |  |

## Outputs

| name | description | sensitive | consumers |
|---|---|:---:|---|
| [cluster_ids](outputs.tf#L22) | Cluster ids. |  |  |
| [clusters](outputs.tf#L17) | Cluster resources. |  |  |
| [project_id](outputs.tf#L29) | GKE project id. |  |  |

<!-- END TFDOC -->
