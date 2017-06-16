Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8454 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751739AbdFPBnm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 21:43:42 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 2/2] btrfs-progs: Add test case to check hole file extents with NO_HOLES flag
Date: Fri, 16 Jun 2017 09:43:23 +0800
Message-ID: <20170616014323.13170-2-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170616014323.13170-1-quwenruo@cn.fujitsu.com>
References: <20170616014323.13170-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add test case which we have NO_HOLES incompat flag while still have
hole file extent.

This can be created by enabling NO_HOLES feature on an existing
filesystem, which lowmem mode would cause false alert for it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/fsck-tests/025-file-extents/test.sh | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tests/fsck-tests/025-file-extents/test.sh b/tests/fsck-tests/025-file-extents/test.sh
index e4bc4247..66cfbaab 100755
--- a/tests/fsck-tests/025-file-extents/test.sh
+++ b/tests/fsck-tests/025-file-extents/test.sh
@@ -5,6 +5,7 @@ source "$TOP/tests/common"
 
 check_prereq btrfs
 check_prereq mkfs.btrfs
+check_prereq btrfstune
 check_global_prereq dd
 check_global_prereq fallocate
 
@@ -38,5 +39,21 @@ test_compressed_inline_extent()
 	run_check "$TOP/btrfs" check "$TEST_DEV"
 }
 
+# Hole file extent with NO_HOLES incompat flag
+# Lowmem mode will cause false alert as it doesn't allow any hole file extent
+# exist, while we can set NO_HOLES at anytime we want, it's definitely a false
+# alert
+test_hole_extent_with_no_holes_flag()
+{
+	run_check $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$TEST_DEV"
+	run_check_mount_test_dev
+
+	run_check $SUDO_HELPER truncate -s 16K "$TEST_MNT/tmp"
+	run_check_umount_test_dev
+	run_check $SUDO_HELPER "$TOP/btrfstune" -n "$TEST_DEV"
+	run_check "$TOP/btrfs" check "$TEST_DEV"
+}
+
 test_paritical_write_into_prealloc
 test_compressed_inline_extent
+test_hole_extent_with_no_holes_flag
-- 
2.13.1



