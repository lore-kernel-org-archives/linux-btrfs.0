Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:50291 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753106AbdK2NsV (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Wed, 29 Nov 2017 08:48:21 -0500
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 2/2] btrfs-progs: tests/convert: Introduce test case to ensure btrfs-convert won't rollback the filesystem after balance
Date: Wed, 29 Nov 2017 21:48:06 +0800
Message-Id: <20171129134806.32324-2-wqu@suse.com>
In-Reply-To: <20171129134806.32324-1-wqu@suse.com>
References: <20171129134806.32324-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 .../015-not-to-rollback-after-balance/test.sh      | 33 ++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100755 tests/convert-tests/015-not-to-rollback-after-balance/test.sh

diff --git a/tests/convert-tests/015-not-to-rollback-after-balance/test.sh b/tests/convert-tests/015-not-to-rollback-after-balance/test.sh
new file mode 100755
index 000000000000..0d523d2250db
--- /dev/null
+++ b/tests/convert-tests/015-not-to-rollback-after-balance/test.sh
@@ -0,0 +1,33 @@
+#!/bin/bash
+# Check if btrfs-convert refuse to rollback the filesystem, and leave
+# the btrfs and the convert image untouched
+
+source "$TOP/tests/common"
+source "$TOP/tests/common.convert"
+
+setup_root_helper
+prepare_test_dev
+check_prereq btrfs-convert
+check_global_prereq mke2fs
+
+# convert_test_prep_fs() will create large enough file inside the
+# test device, that's good enough for us to test rollback failure.
+convert_test_prep_fs ext4 mke2fs -t ext4 -b 4096
+run_check_umount_test_dev
+convert_test_do_convert "" 4096
+
+run_check_mount_test_dev
+
+# Now the fs is converted, balance the fs so later rollback should fail
+run_check $SUDO_HELPER "$TOP/btrfs" balance start --full-balance $TEST_MNT
+run_check_umount_test_dev
+
+# rollback should fail
+run_mustfail "rollback fs after balance" "$TOP/btrfs-convert" -r $TEST_DEV
+
+# Ensure the fs and convert image can pass the check
+run_check "$TOP/btrfs" check $TEST_DEV
+
+run_check_mount_test_dev
+run_check $SUDO_HELPER e2fsck -fn $TEST_MNT/ext2_saved/image
+run_check_umount_test_dev
-- 
2.15.0

