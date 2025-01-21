## Description

Install the Aptos CLI. By default we use the latest released version of the Aptos CLI but you can specify the version. For now this only works on Linux runners.

## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| INSTALL_DIRECTORY | The directory to install the Aptos CLI. If not specified, it will be installed in /usr/local/bin | `false` | /usr/local/bin |
| CLI_VERSION | The version of the Aptos CLI to install. If not specified, the latest version will be installed. | `false` |  |
| SHELL | The shell to use for the steps. | `false` | bash |


## Runs

This action is a `composite` action.


