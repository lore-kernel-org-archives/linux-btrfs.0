Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45342 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbbLXMOD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 07:14:03 -0500
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 2/4 v2] fstests: cleanup test btrfs/029
Date: Wed, 23 Dec 2015 04:43:13 +0000
Message-Id: <1450845795-18729-2-git-send-email-fdmanana@kernel.org>
In-Reply-To: <1450845795-18729-1-git-send-email-fdmanana@kernel.org>
References: <1450845795-18729-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

The test was using $SCRATCH_MNT as a mountpoint for $SCRATCH_DEV, which
is counter intuitive and not expected by the fstests framework - this
made the test fail after commit 27d077ec0bda (common: use mount/umount
helpers everywhere). So rewrite the test to use the scratch device for
all data and use a test specific directory inside $TEST_DIR to use as a
mount point for a cross mount of $SCRATCH_DEV.

This test was also overriding $seqres.full, through the redirect ">"
operator, if a call to cp failed. Fix that by using instead the operator
">>". Also make the test use the function _mount() instead of calling
the mount program directly.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: First version of the change, introduced in the v2 of the corresponding
    patchset.

 tests/btrfs/029     | 45 +++++++++++++++++++--------------------------
 tests/btrfs/029.out | 12 ++++++------
 2 files changed, 25 insertions(+), 32 deletions(-)

diff --git a/tests/btrfs/029 b/tests/btrfs/029
index cdce6e1..87c289b 100755
--- a/tests/btrfs/029
+++ b/tests/btrfs/029
@@ -39,7 +39,6 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
-    _scratch_unmount &>/dev/null
     cd /
     rm -f $tmp.*
 }
@@ -56,55 +55,49 @@ _supported_os Linux
 _require_test
 _require_scratch
 _require_cp_reflink
+_need_to_be_root
 
-SOURCE_DIR=$TEST_DIR/test-$seq
-CROSS_DEV_DIR=$SCRATCH_MNT/test-$seq
-# mount point & target for twice-mounted device
-TEST_DIR2=$TEST_DIR/mount2
-DUAL_MOUNT_DIR=$SCRATCH_MNT/test-bis-$seq
-
-rm -rf $SOURCE_DIR
-mkdir $SOURCE_DIR
+reflink_test_dir=$TEST_DIR/test-$seq
+rm -rf $reflink_test_dir
+mkdir $reflink_test_dir
 
 rm -f $seqres.full
 
 _scratch_mkfs > /dev/null 2>&1
-$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $SOURCE_DIR/original \
- >> $seqres.full
+_scratch_mount
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $SCRATCH_MNT/original >> $seqres.full
 
 _filter_testdirs()
 {
     _filter_test_dir | _filter_scratch
 }
 
-_create_reflinks_to()
+_create_reflinks()
 {
     # auto reflink, should fall back to non-reflink
-    rm -rf $1; mkdir $1
+    rm -rf $2
     echo "reflink=auto:"
-    cp --reflink=auto $SOURCE_DIR/original $1/copy
-    md5sum $SOURCE_DIR/original | _filter_testdirs
-    md5sum $1/copy | _filter_testdirs
+    cp --reflink=auto $1 $2
+    md5sum $1 | _filter_testdirs
+    md5sum $2 | _filter_testdirs
 
     # always reflink, should fail outright
-    rm -rf $1; mkdir $1
+    rm -rf $2
     echo "reflink=always:"
-    cp --reflink=always $SOURCE_DIR/original $1/copyfail > $seqres.full 2>&1 \
-	|| echo "cp reflink failed"
+    cp --reflink=always $1 $2 >> $seqres.full 2>&1 || echo "cp reflink failed"
 
     # The failed target actually gets created by cp:
-    ls $1/copyfail | _filter_testdirs
+    ls $2 | _filter_testdirs
 }
 
 echo "test reflinks across different devices"
-_scratch_mount
-_create_reflinks_to $CROSS_DEV_DIR
-_scratch_unmount
+_create_reflinks $SCRATCH_MNT/original $reflink_test_dir/copy
 
 echo "test reflinks across different mountpoints of same device"
-mount $TEST_DEV $SCRATCH_MNT || _fail "Couldn't double-mount $TEST_DEV"
-_create_reflinks_to $DUAL_MOUNT_DIR
-_scratch_unmount
+rm -rf $reflink_test_dir/*
+_mount $SCRATCH_DEV $reflink_test_dir
+_create_reflinks $SCRATCH_MNT/original $reflink_test_dir/copy
+$UMOUNT_PROG $reflink_test_dir
 
 # success, all done
 status=0
diff --git a/tests/btrfs/029.out b/tests/btrfs/029.out
index 9390d95..0547d28 100644
--- a/tests/btrfs/029.out
+++ b/tests/btrfs/029.out
@@ -1,15 +1,15 @@
 QA output created by 029
 test reflinks across different devices
 reflink=auto:
-42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-029/original
-42d69d1a6d333a7ebdf64792a555e392  SCRATCH_MNT/test-029/copy
+42d69d1a6d333a7ebdf64792a555e392  SCRATCH_MNT/original
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-029/copy
 reflink=always:
 cp reflink failed
-SCRATCH_MNT/test-029/copyfail
+TEST_DIR/test-029/copy
 test reflinks across different mountpoints of same device
 reflink=auto:
-42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-029/original
-42d69d1a6d333a7ebdf64792a555e392  SCRATCH_MNT/test-bis-029/copy
+42d69d1a6d333a7ebdf64792a555e392  SCRATCH_MNT/original
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-029/copy
 reflink=always:
 cp reflink failed
-SCRATCH_MNT/test-bis-029/copyfail
+TEST_DIR/test-029/copy
-- 
2.1.3

