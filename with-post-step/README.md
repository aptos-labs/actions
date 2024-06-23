## Description

Generic JS Action to execute a main command and set a command as a post step.

Learn more about why we need this here: https://github.com/actions/runner/issues/1478

Originally forked from https://github.com/pyTooling/Actions/tree/main/with-post-step.


## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| main | Main command/script. | `true` |  |
| post | Post command/script. | `true` |  |
| key | Name of the state variable used to detect the post step. | `false` | POST |


## Runs

This action is a `node20` action.


