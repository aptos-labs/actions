## Description

Install a released version of the Aptos CLI and start a local testnet. Once this action succeeds, a local testnet will be running and ready to use.

**Note:** If `WITH_INDEXER_API` is `true` (the default), this action requires Docker to be running on the runner. Linux and macOS only.

## Inputs

| Parameter | Description | Required | Default |
| --- | --- | --- | --- |
| CLI_VERSION | The version of the Aptos CLI to install. If not specified, the latest version will be installed. | `false` | |
| WITH_INDEXER_API | If true, run an indexer API in addition to the node API and faucet. Requires Docker. | `false` | `true` |
| ADDITIONAL_ARGS | Additional arguments to pass to the CLI when running the local testnet. | `false` | |
| WAIT_TIMEOUT | Health check timeout in seconds. | `false` | `120` |

## Usage

```yaml
- uses: aptos-labs/actions/run-local-testnet-from-cli-release@main

# Without the indexer API (no Docker required)
- uses: aptos-labs/actions/run-local-testnet-from-cli-release@main
  with:
    WITH_INDEXER_API: "false"

# With a specific CLI version and longer timeout
- uses: aptos-labs/actions/run-local-testnet-from-cli-release@main
  with:
    CLI_VERSION: "4.5.0"
    WAIT_TIMEOUT: "180"
```

## Default Ports

Once the testnet is running, these endpoints are available:

| Service | Port |
| --- | --- |
| Node API (REST) | 8080 |
| Faucet | 8081 |
| Indexer API (GraphQL) | 8090 |
| Readiness endpoint | 8070 |
| Transaction Stream (gRPC) | 50051 |
| Postgres | 5433 |

## Runs

This action is a `composite` action.
