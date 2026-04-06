## Description

Install the Aptos CLI using the official install scripts from [aptos.dev](https://aptos.dev). Works on Linux, macOS, and Windows runners.

## Inputs

| Parameter | Description | Required | Default |
| --- | --- | --- | --- |
| INSTALL_DIRECTORY | The directory to install the Aptos CLI. If not specified, the script default is used (`~/.local/bin` on Linux/macOS, `~\.aptoscli\bin` on Windows). | `false` | |
| CLI_VERSION | The version of the Aptos CLI to install. If not specified, the latest version will be installed. | `false` | |

## Usage

```yaml
- uses: aptos-labs/actions/install-aptos-cli@main

# With a specific version
- uses: aptos-labs/actions/install-aptos-cli@main
  with:
    CLI_VERSION: "4.5.0"

# With a custom install directory
- uses: aptos-labs/actions/install-aptos-cli@main
  with:
    INSTALL_DIRECTORY: "/usr/local/bin"
```

## Runs

This action is a `composite` action.
