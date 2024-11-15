## Description

Use the Aptos CLI to run a local testnet. Once this action is succeeds, a local testnet will be running and ready to use. **Note**, if `WITH_INDEXER_API` is `true`, this action requires that the runner has Docker running and available. On some runners (e.g. macos-latest) Docker is not installed by default.

## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| PNPM_VERSION | The version of pnpm to install. | `false` | 8.15.6 |
| NODE_VERSION | The version of node to install. This must be specified if a .node-version file is not present. | `false` |  |
| CLI_GIT_REF | The git ref (e.g. a tag, like 'testnet' or a commit SHA) of the Aptos CLI to use. If not given, we will use the latest released CLI. If given, the local testnet is run from a Docker image. | `false` |  |
| DOCKER_ARTIFACT_REPO | The GCP Docker artifact repository + user. Only used if CLI_GIT_REF is set. | `false` | docker.io/aptoslabs |
| WITH_INDEXER_API | If true, run an indexer API in addition to the node API and faucet. | `false` | true |
| ADDITIONAL_ARGS | Additional arguments to pass to the CLI when running the local testnet. | `false` |  |


## Runs

This action is a `composite` action.


