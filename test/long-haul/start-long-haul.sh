# Copyright 2020 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

pushd "./test/long-haul/"
source ./utils.sh

export ClusterName="${aks_cluster_name}"
export ResourceGroup="${aks_resource_group}"
export PoolName="${aks_pool_name}"

sed -i "s/{longhaul_agentpool}/$PoolName/g" ./sample-workload/deployment_write_print_file.yaml

print_logs_info "Connecting to AKS Cluster=$ClusterName, ResourceGroup=$ResourceGroup, AKS pool=$PoolName"
az configure --defaults group=$ResourceGroup
az aks get-credentials --resource-group $ResourceGroup --name $ClusterName

print_logs_case "Executing fault test"
./fault-test.sh

print_logs_case "Executing update test"
./update-test.sh