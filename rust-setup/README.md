## Description

Runs an opionated rust setup after optionally checking out a repository


## Inputs

| parameter | description | required | default |
| --- | --- | --- | --- |
| CHECKOUT_GIT_REF | Optional git ref to checkout | `false` |  |
| CHECKOUT_REPOSITORY | Optional repository to checkout. If this repository has a rust-toolchain file, it will be used to override the default toolchain | `false` |  |
| CHECKOUT_FETCH_DEPTH | Optional depth to checkout repository to | `false` |  |
| REPOSITORY_SPECIFIC_SETUP | Optional repository specific dependencies to install | `false` |  |
| GIT_CREDENTIALS | Optional credentials to pass to git. Useful if you need to pull private repos for dependencies | `false` |  |


## Runs

This action is a `composite` action.


