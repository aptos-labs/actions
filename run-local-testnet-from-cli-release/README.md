## Description

Install a released version of the Aptos CLI and start a local testnet. Once this action succeeds, a local testnet will be running and ready to use. Requires Docker if WITH_INDEXER_API is true. Linux and macOS only.

## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| CLI_VERSION | The version of the Aptos CLI to install. If not specified, the latest version will be installed. | `false` |  |
| WITH_INDEXER_API | If true, run an indexer API in addition to the node API and faucet. Requires Docker. | `false` | true |
| ADDITIONAL_ARGS | Additional arguments to pass to the CLI when running the local testnet. | `false` |  |
| WAIT_TIMEOUT | Health check timeout in seconds. | `false` | 120 |


## Runs

This action is a `composite` action.


