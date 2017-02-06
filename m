Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11354 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751225AbdBFFsD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Feb 2017 00:48:03 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <calestyo@scientia.net>, <chris@colorremedies.com>, <dsterba@suse.cz>
Subject: [PATCH v2 10/12] btrfs-progs: fsck-test: Add new test case for file extent false alerts
Date: Mon, 6 Feb 2017 13:47:33 +0800
Message-ID: <20170206054735.5227-11-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170206054735.5227-1-quwenruo@cn.fujitsu.com>
References: <20170206054735.5227-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lowmem mode exposed several false alerts, all related to file extents
check.

1) Partly written prealloc extent
   Cause lowmem mode to report missing csum or prealloc extent should
   not have csum

2) Compressed inline extent
   Cause lowmem mode to find mismatch on inline len and item len.
   While no error message is output but exit silently.

Reported-by: Chris Murphy <chris@colorremedies.com>
Reported-by: Christoph Anton Mitterer <calestyo@scientia.net>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/fsck-tests/025-file-extents/test.sh | 42 +++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)
 create mode 100755 tests/fsck-tests/025-file-extents/test.sh

diff --git a/tests/fsck-tests/025-file-extents/test.sh b/tests/fsck-tests/025-file-extents/test.sh
new file mode 100755
index 00000000..cb64c500
--- /dev/null
+++ b/tests/fsck-tests/025-file-extents/test.sh
@@ -0,0 +1,42 @@
+#!/bin/bash
+# Confirm btrfs check can check file extents without causing false alert
+
+source $TOP/tests/common
+
+check_prereq btrfs
+check_prereq mkfs.btrfs
+check_global_prereq xfs_io
+check_global_prereq fallocate
+
+setup_root_helper
+prepare_test_dev 128M
+
+# Do some write into a large prealloc range
+# Lowmem mode can report missing csum due to wrong csum range
+test_paritical_write_into_prealloc()
+{
+	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_check_mount_test_dev
+
+	run_check fallocate -l 128K "$TEST_MNT/file"
+	sync
+	run_check xfs_io -c "pwrite 0 64K" "$TEST_MNT/file"
+	run_check_umount_test_dev
+	run_check "$TOP/btrfs" check "$TEST_DEV"
+}
+
+# Inline compressed file extent
+# Lowmem mode can cause silent error without any error message
+# due to too restrict check on inline extent size
+test_compressed_inline_extent()
+{
+	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_check_mount_test_dev -o compress=lzo,max_inline=2048
+
+	run_check xfs_io -f -c "pwrite 0 1K" "$TEST_MNT/file"
+	run_check_umount_test_dev
+	run_check "$TOP/btrfs" check "$TEST_DEV"
+}
+
+test_paritical_write_into_prealloc
+test_compressed_inline_extent
-- 
2.11.0



