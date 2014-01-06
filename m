Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37601 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbaAFJSv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 04:18:51 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com, t-itoh@jp.fujitsu.com
Subject: [PATCH v2] xfstests: fix failed 022 case with qgroup limit test
Date: Mon, 6 Jan 2014 17:17:50 +0800
Message-Id: <1388999870-14842-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To have noexceed test, we should clear data before and then retry.
However, when we are near to quota limit, we may fail to truncate/remove
data before, so we restart everthing here.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
changelog v1->v2:
	on the right way to fix failed case(Thanks to Tsutomu Itoh)
---
 tests/btrfs/022 | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/tests/btrfs/022 b/tests/btrfs/022
index 5b18643..41d8588 100644
--- a/tests/btrfs/022
+++ b/tests/btrfs/022
@@ -94,8 +94,8 @@ _rescan_test()
 		_fail "exclusive values don't match after rescan"
 }
 
-#basic limit testing
-_limit_test()
+#basic exceed limit testing
+_limit_test_exceed()
 {
 	run_check $BTRFS_UTIL_PROG subvol create $SCRATCH_MNT/a
 	run_check $BTRFS_UTIL_PROG quota enable $SCRATCH_MNT
@@ -104,6 +104,15 @@ _limit_test()
 	dd if=/dev/urandom of=$SCRATCH_MNT/a/file bs=10M count=1 >> \
 		$seqres.full 2>&1
 	[ $? -ne 0 ] || _fail "quota should have limited us"
+}
+
+#basic noexceed limit testing
+_limit_test_noexceed()
+{
+	run_check $BTRFS_UTIL_PROG subvol create $SCRATCH_MNT/a
+	run_check $BTRFS_UTIL_PROG quota enable $SCRATCH_MNT
+	subvolid=$(_btrfs_get_subvolid $SCRATCH_MNT a)
+	run_check $BTRFS_UTIL_PROG qgroup limit 5M 0/$subvolid $SCRATCH_MNT
 	dd if=/dev/urandom of=$SCRATCH_MNT/a/file bs=4M count=1 >> \
 		$seqres.full 2>&1
 	[ $? -eq 0 ] || _fail "should have been allowed to write"
@@ -121,7 +130,12 @@ _scratch_unmount
 
 _scratch_mkfs > /dev/null 2>&1
 _scratch_mount
-_limit_test
+_limit_test_exceed
+_scratch_unmount
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+_limit_test_noexceed
 
 # success, all done
 echo "Silence is golden"
-- 
1.8.3.1

