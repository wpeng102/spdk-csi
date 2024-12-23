This document describes how to build SPDK CSI image, helm chart and how to deploy SPDK CSI into the DPF environment through DPUservice.

## Prerequisites

SPDK-CSI is currently developed and tested with `Go 1.19`, `Docker 20.10`. 
Minimal requirement: Go 1.19+, Docker 18.03+

Beofre building/pushing images and helm chart, it is recommended to set `CSI_IMAGE_REGISTRY` for the image and chart.

### Build image
- `$ make image`

### Push image
- `$ make push-image`

### Build helm chart
- `$ make helm-package`

### Push helm chart
- `$ make helm-push`

### Deploy SPDK CSI controller through DPUService
#### create RBAC in DPU cluster
- `$ kubectl apply -f dpf/dpu-service/examples/spdk-csi-controller-dpu-cluster-role.yaml`

#### Create DPUServiceCredentialRequest in host cluster

`dpf/dpu-service/DPUServiceCredentialRequest.yaml` is an example of a `DPUServiceCredentialRequest` which requests credentials
to access a cluster. We need update the `namespace` base on the namespace where the DPUCluster is in your DPF environment.

- `$ kubectl apply -f dpf/dpu-service/DPUServiceCredentialRequest.yaml`

#### Create DPUService in host cluster

`dpf/dpu-service/DPUService.yaml` is an example of a `DPUService` which requests credentials
to access a cluster. We need update the `namespace` base on the namespace where the DPUCluster is in your DPF environment.

- `$ kubectl apply -f dpf/dpu-service/DPUService.yaml`