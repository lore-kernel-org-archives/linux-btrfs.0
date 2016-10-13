Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16152 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752746AbcJMJWs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 05:22:48 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/2] btrfs-progs: fsck-tests: Check if clear space cache works
Date: Thu, 13 Oct 2016 17:22:27 +0800
Message-Id: <20161013092227.19761-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161013092227.19761-1-quwenruo@cn.fujitsu.com>
References: <20161013092227.19761-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add test case to check the basic function of --clear-space-cache.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/fsck-tests/024-clear-space-cache/test.sh | 55 ++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100755 tests/fsck-tests/024-clear-space-cache/test.sh

diff --git a/tests/fsck-tests/024-clear-space-cache/test.sh b/tests/fsck-tests/024-clear-space-cache/test.sh
new file mode 100755
index 0000000..ce4fbae
--- /dev/null
+++ b/tests/fsck-tests/024-clear-space-cache/test.sh
@@ -0,0 +1,55 @@
+#!/bin/bash
+# confirm fsck clear space cache works fine.
+
+source $TOP/tests/common
+
+check_prereq btrfs
+check_prereq mkfs.btrfs
+
+setup_root_helper
+prepare_test_dev 1G
+
+tmp=$(mktemp)
+run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
+run_check_mount_test_dev
+
+# Create files that takes at least 3 data chunks, while 
+# can still be removed to create free space inside one chunk.
+
+for i in $(seq 0 6); do
+	run_check $SUDO_HELPER dd if=/dev/zero of=$TEST_MNT/file_${i} bs=1M \
+		count=64 > /dev/null 2>&1
+done
+sync
+
+# Remove file 1 3 5 to create holes
+for i in $(seq 1 2 6); do
+	run_check $SUDO_HELPER rm $TEST_MNT/file_${i}
+done
+
+sync
+
+run_check_umount_test_dev
+
+# Clear space cache and re-check fs
+run_check $TOP/btrfs check --clear-space-cache v1 $TEST_DEV
+run_check $TOP/btrfs check $TEST_DEV
+
+# Manually recheck space cache and super space cache generation
+run_check_stdout $TOP/btrfs inspect-internal dump-tree -t root $TEST_DEV \
+	> $tmp
+grep -q FREE_SPACE $tmp
+if [ $? -eq 0 ]; then
+	rm $tmp
+	_fail "clear space cache doesn't clear all space cache"
+fi
+
+run_check_stdout $TOP/btrfs inspect-internal dump-super $TEST_DEV |\
+       	grep cache_generation > $tmp
+
+grep -q 18446744073709551615 $tmp
+if [ $? -ne 0 ]; then
+	rm $tmp
+	_fail "clear space cache doesn't set cache_generation correctly"
+fi
+rm $tmp
-- 
2.10.0



