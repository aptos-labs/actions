# Docker Build Setup

This is an opinionated and unified docker build setup action. It does the following:
* Logs in to docker image registries (AWS ECR and GCP GAR)
* Setup for buildx and other dependencies (crane)
* Sets git credentials for private builds
