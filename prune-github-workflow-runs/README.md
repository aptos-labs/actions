## Description

Delete obsolete runs of workflows that do not exist anymore in the given repo.

## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| token | GitHub access token | `true` |  |
| owner | Repository owner | `false` | ${{ github.repository_owner }} |
| repo | Repository name | `false` | ${{ github.event.repository.name }} |
| dry-run | Do not delete runs, just print them | `false` | false |


## Runs

This action is a `node20` action.


