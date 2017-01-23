Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18859 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750916AbdAWJPP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 04:15:15 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <calestyo@scientia.net>, <chris@colorremedies.com>, <dsterba@suse.cz>
Subject: [PATCH 8/9] btrfs-progs: fsck-tests: Add new test case for partly written prealloc extent
Date: Mon, 23 Jan 2017 17:13:58 +0800
Message-ID: <20170123091359.21390-10-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170123091359.21390-1-quwenruo@cn.fujitsu.com>
References: <20170123091359.21390-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a bug found in lowmem mode, which reports false alert for partly
written prealloc extent.

Reported-by: Chris Murphy <chris@colorremedies.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/fsck-tests/020-extent-ref-cases/test.sh | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tests/fsck-tests/020-extent-ref-cases/test.sh b/tests/fsck-tests/020-extent-ref-cases/test.sh
index 5dc5e55d..91340671 100755
--- a/tests/fsck-tests/020-extent-ref-cases/test.sh
+++ b/tests/fsck-tests/020-extent-ref-cases/test.sh
@@ -18,6 +18,7 @@
 source $TOP/tests/common
 
 check_prereq btrfs
+check_global_prereq xfs_io
 
 for img in *.img *.raw.xz
 do
@@ -28,3 +29,17 @@ do
 	run_check $TOP/btrfs check "$image"
 	rm -f "$image"
 done
+
+# Extra test case for partly written prealloc extents.
+test_prealloc_written()
+{
+	run_check $SUDO_HELPER $TOP/mkfs.btrfs -f $TEST_DEV
+
+	run_check_mount_test_dev
+	xfs_io -f -c "falloc 0 128k" -c "syncfs" $TEST_MNT/tmpfile
+	xfs_io -c "pwrite 0 64k" $TEST_MNT/tmpfile
+
+	run_check_umount_test_dev
+
+	run_check $TOP/btrfs check $TEST_DEV
+}
-- 
2.11.0



