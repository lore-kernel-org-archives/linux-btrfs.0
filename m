Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:35329 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753030AbeAJGSU (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 10 Jan 2018 01:18:20 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 2/2] btrfs-progs: misc-test: Add test case to check if fi usage and show report consistent unallocated space
Date: Wed, 10 Jan 2018 14:18:09 +0800
Message-Id: <20180110061809.28123-2-wqu@suse.com>
In-Reply-To: <20180110061809.28123-1-wqu@suse.com>
References: <20180110061809.28123-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
v2:
  Don't create unnecessary temporary dir. Use variable directly to save
  output
  Use run_check_mount_test_dev() macro with TEST_DEV set manually.
---
 tests/misc-tests/028-fi-usage-cross-check/test.sh | 44 +++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100755 tests/misc-tests/028-fi-usage-cross-check/test.sh

diff --git a/tests/misc-tests/028-fi-usage-cross-check/test.sh b/tests/misc-tests/028-fi-usage-cross-check/test.sh
new file mode 100755
index 000000000000..0343888b3413
--- /dev/null
+++ b/tests/misc-tests/028-fi-usage-cross-check/test.sh
@@ -0,0 +1,44 @@
+#!/bin/bash
+# check fi-usage is output correct unallocated space for RAID10
+
+source "$TOP/tests/common"
+
+check_prereq mkfs.btrfs
+check_prereq btrfs
+
+setup_root_helper
+
+setup_loopdevs 4
+prepare_loopdevs
+dev1=${loopdevs[1]}
+
+run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -d raid10 -m raid10 -f ${loopdevs[@]}
+TEST_DEV=$dev1
+run_check_mount_test_dev
+
+output=$(run_check_stdout $SUDO_HELPER "$TOP/btrfs" filesystem show --raw "$TEST_MNT" |\
+	 grep "$dev1")
+if [ -z "$output" ]; then
+	_fail "failed to get correct fi show output"
+fi
+
+dev1_total=$(echo $output | awk '{print $4}')
+dev1_used=$(echo $output | awk '{print $6}')
+dev1_fi_show_unallocated=$(( $dev1_total - $dev1_used))
+
+output=$(run_check_stdout $SUDO_HELPER "$TOP/btrfs" filesystem usage --raw "$TEST_MNT" |\
+	 grep "$dev1" | tail -n1)
+if [ -z "$output" ]; then
+	_fail "failed to get correct fi usage output"
+fi
+
+dev1_fi_usage_unallocated=$(echo $output | awk '{print $2}')
+echo "fi usage unallocated for devid1 is $dev1_fi_usage_unallocated" >> "$RESULTS"
+echo "fi show unallocated for devid1 is $dev1_fi_show_unallocated" >> "$RESULTS"
+
+if [ $dev1_fi_show_unallocated -ne $dev1_fi_usage_unallocated ]; then
+	_fail "fi usage unallocated mismatch with fi show"
+fi
+
+run_check $SUDO_HELPER umount "$TEST_MNT"
+cleanup_loopdevs
-- 
2.15.1

