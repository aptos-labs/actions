#!/usr/bin/env python3

# Test replay-verify by running it on a public testnet backup
# While the replay-verify composite Github Action is meant to run with aptos-core checked out in the current
# working directory, this test script is meant to be run from this separate repo. The environment variable APTOS_CORE_PATH
# is required to be set to the path of your local checkout of aptos-core, which will be used to build and copy over test dependencies.

import os
import shutil
import subprocess

import replay_verify


def local_setup():
    # Take these from the expected replay verify run
    envs = {
        "TIMEOUT_MINUTES": "5",
        "BUCKET": "aptos-testnet-backup-2223d95b",
        "SUB_DIR": "e1",
        "HISTORY_START": "350000000",
        "TXNS_TO_SKIP": "46874937 151020059",
        "BACKUP_CONFIG_TEMPLATE_PATH": "terraform/helm/fullnode/files/backup/s3-public.yaml",
    }

    # This is the path to the backup config template
    APTOS_CORE_PATH = os.environ["APTOS_CORE_PATH"]
    if not APTOS_CORE_PATH:
        raise Exception(
            "Missing required APTOS_CORE_PATH env variable. It is required for copying artifacts over."
        )

    # build backup tools
    subprocess.run(
        [
            "cargo",
            "build",
            "--release",
            "-p",
            "aptos-backup-cli",
            "--bin",
            "replay-verify",
            "--bin",
            "db-backup",
        ],
        cwd=APTOS_CORE_PATH,
        check=True,
    )

    # copy stuff from aptos-core to here, to achieve the environment we expect
    # in the github actions action
    shutil.copy(
        f"{APTOS_CORE_PATH}/{envs['BACKUP_CONFIG_TEMPLATE_PATH']}",
        envs["BACKUP_CONFIG_TEMPLATE_PATH"],
    )
    shutil.copy(
        f"{APTOS_CORE_PATH}/target/release/replay-verify",
        "target/release/replay-verify",
    )
    shutil.copy(
        f"{APTOS_CORE_PATH}/target/release/db-backup", "target/release/db-backup"
    )

    # write to environment variables
    for key, value in envs.items():
        os.environ[key] = value


if __name__ == "__main__":
    local_setup()
    replay_verify.main()
