#!/usr/bin/env python3

import unittest
import subprocess

from replay_verify import find_latest_version_from_db_backup_output


class ReplayVerifyHarnessTests(unittest.TestCase):
    def testFindLatestVersionFromDbBackupOutput(self) -> None:
        proc = subprocess.Popen(
            "cat fixtures/backup_oneshot.fixture", shell=True, stdout=subprocess.PIPE
        )
        latest_version = find_latest_version_from_db_backup_output(proc.stdout)
        self.assertEqual(latest_version, 417000000)
        proc.communicate()
