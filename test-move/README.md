## Description

Run move formatting checks, linting, compilation, and tests. You must checkout the code prior to using this. This uses the latest released version of the Aptos CLI.

## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| WORKING_DIRECTORY | The directory to run the commands from. | `false` | . |
| SKIP_FMT | If true, skip formatting. | `false` | false |
| SKIP_LINT | If true, skip linting. | `false` | false |
| SKIP_COMPILE | If true, skip compilation. | `false` | false |
| SKIP_TEST | If true, skip tests. | `false` | false |
| ADDITIONAL_FMT_ARGS | Additional arguments to pass to the CLI when running movefmt. | `false` |  |
| ADDITIONAL_LINT_ARGS | Additional arguments to pass to the CLI when running move lint. | `false` |  |
| ADDITIONAL_COMPILE_ARGS | Additional arguments to pass to the CLI when running move compile. | `false` |  |
| ADDITIONAL_TEST_ARGS | Additional arguments to pass to the CLI when running move test. | `false` |  |
| CLI_VERSION | The version of the Aptos CLI to install. If not specified, the latest version will be installed. | `false` |  |
| SKIP_INSTALLING_CLI | If true, skip installing the Aptos CLI. We will assume it is already on the PATH. | `false` | false |
| SHELL | The shell to use for the steps. | `false` | bash |


## Runs

This action is a `composite` action.


