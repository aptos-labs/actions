## Description

Runs the replay-verify tool from aptos-core, assuming it is already checked out in the current working directory.


## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| TIMEOUT_MINUTES | The number of minutes to wait for the replay-verify tool to finish | `false` | 50400 |
| BUCKET | The name of the bucket to download the ledger from. | `true` |  |
| SUB_DIR | The subdirectory of the bucket to download the ledger from. | `true` |  |
| HISTORY_START | The starting history index to replay from. | `true` |  |
| TXNS_TO_SKIP | A list of transaction indices to skip during replay. | `true` |  |
| BACKUP_CONFIG_TEMPLATE_PATH | The path to the backup config template to use. | `true` |  |


## Runs

This action is a `composite` action.


