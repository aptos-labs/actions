## Description

Runs an opinionated and unified docker build setup action. It does the following:
* Logs in to docker image registries (AWS ECR and GCP GAR)
* Setup for buildx and other dependencies (crane)
* Sets git credentials for private builds


## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| GCP_WORKLOAD_IDENTITY_PROVIDER | GCP Workload Identity provider | `true` |  |
| GCP_SERVICE_ACCOUNT_EMAIL | GCP service account email | `true` |  |
| GCP_DOCKER_ARTIFACT_REPO | GCP GAR repo to authenticate to | `true` |  |
| AWS_ACCESS_KEY_ID | AWS access key id | `true` |  |
| AWS_SECRET_ACCESS_KEY | AWS secret access key | `true` |  |
| AWS_DOCKER_ARTIFACT_REPO | AWS ECR repo to authenticate to | `true` |  |
| GIT_CREDENTIALS | Optional credentials to pass to git. Useful if you need to pull private repos for dependencies | `false` |  |


## Runs

This action is a `composite` action.


