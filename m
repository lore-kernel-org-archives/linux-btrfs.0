Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34267 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbbLVMG0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 07:06:26 -0500
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 1/2] fstests: fix btrfs test failures after commit 27d077ec0bda
Date: Tue, 22 Dec 2015 02:22:40 +0000
Message-Id: <1450750960-5172-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

Commit 27d077ec0bda (common: use mount/umount helpers everywhere) made
a few btrfs test fail for 2 different reasons:

1) Some tests (btrfs/029 and btrfs/031) use $SCRATCH_MNT as a mount
   point for some subvolume created in $TEST_DEV, therefore calling
   _scratch_unmount does not work as it passes $SCRATCH_DEV as the
   argument to the umount program. This is intentional to test reflinks
   accross different mountpoints of the same filesystem but for different
   subvolumes;

2) For multiple devices filesystems (btrfs/003 and btrfs/011) that test
   the device replace feature, we need to unmount using the mount path
   ($SCRATCH_MNT) because unmounting using one of the devices as an
   argument ($SCRATCH_DEV) does not always work - after replace operations
   we get in /proc/mounts a device other than $SCRATCH_DEV associated
   with the mount point $SCRATCH_MNT (this is mentioned in a comment at
   btrfs/011 for example), so we need to pass that other device to the
   umount program or pass it the mount point.

Using $SCRATCH_MNT as a mountpoint for a device other than $SCRATCH_DEV is
misleading, but that's a different problem that existed long before and
this change attempts only to fix the regression from 27d077ec0bda.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/003 | 16 ++++++++--------
 tests/btrfs/011 |  6 +++---
 tests/btrfs/029 |  4 ++--
 tests/btrfs/031 |  3 +--
 4 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/tests/btrfs/003 b/tests/btrfs/003
index 353cb48..05029f4 100755
--- a/tests/btrfs/003
+++ b/tests/btrfs/003
@@ -36,7 +36,7 @@ _cleanup()
     cd /
     rm -f $tmp.*
     if [ $dev_removed == 1 ]; then
-	_scratch_unmount
+	$UMOUNT_PROG $SCRATCH_MNT
         _devmgt_add "${DEVHTL}"
     fi
 }
@@ -63,7 +63,7 @@ _test_raid0()
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
-	_scratch_unmount
+	$UMOUNT_PROG $SCRATCH_MNT
 }
 
 _test_raid1()
@@ -73,7 +73,7 @@ _test_raid1()
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
-	_scratch_unmount
+	$UMOUNT_PROG $SCRATCH_MNT
 }
 
 _test_raid10()
@@ -83,7 +83,7 @@ _test_raid10()
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
-	_scratch_unmount
+	$UMOUNT_PROG $SCRATCH_MNT
 }
 
 _test_single()
@@ -93,7 +93,7 @@ _test_single()
 	_scratch_mount
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
-	_scratch_unmount
+	$UMOUNT_PROG $SCRATCH_MNT
 }
 
 _test_add()
@@ -115,7 +115,7 @@ _test_add()
 		$BTRFS_UTIL_PROG device add ${devs[$i]} $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "device add failed"
 	done
 	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "balance failed"
-	_scratch_unmount
+	$UMOUNT_PROG $SCRATCH_MNT
 }
 
 _test_replace()
@@ -161,7 +161,7 @@ _test_replace()
 	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "dev balance failed"
 
 	# cleaup. add the removed disk
-	_scratch_unmount
+	$UMOUNT_PROG $SCRATCH_MNT
 	_devmgt_add "${DEVHTL}"
 	dev_removed=0
 }
@@ -177,7 +177,7 @@ _test_remove()
 	dev_del=`echo ${SCRATCH_DEV_POOL} | awk '{print $NF}'`
 	$BTRFS_UTIL_PROG device delete $dev_del $SCRATCH_MNT || _fail "btrfs device delete failed"
 	$BTRFS_UTIL_PROG filesystem show $SCRATCH_DEV 2>&1 | grep $dev_del >> $seqres.full && _fail "btrfs still shows the deleted dev"
-	_scratch_unmount
+	$UMOUNT_PROG $SCRATCH_MNT
 }
 
 _test_raid0
diff --git a/tests/btrfs/011 b/tests/btrfs/011
index 72c53ab..ab2f96c 100755
--- a/tests/btrfs/011
+++ b/tests/btrfs/011
@@ -151,7 +151,7 @@ workout()
 	sync; sync
 
 	btrfs_replace_test $source_dev $target_dev "" $with_cancel $quick
-	_scratch_unmount > /dev/null 2>&1
+	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
 
 	if echo $mkfs_options | egrep -qv "raid1|raid5|raid6|raid10" || \
 	   [ "${with_cancel}Q" = "cancelQ" ]; then
@@ -201,7 +201,7 @@ workout()
 	fi
 
 	btrfs_replace_test $source_dev $target_dev "-r" $with_cancel $quick
-	_scratch_unmount > /dev/null 2>&1
+	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
 }
 
 btrfs_replace_test()
@@ -264,7 +264,7 @@ btrfs_replace_test()
 	# because in /proc/mounts the 2nd device of the filesystem is
 	# shown after the replace operation. Let's just do the mount
 	# test manually after _check_btrfs_filesystem is finished.
-	_scratch_unmount > /dev/null 2>&1
+	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
 	if [ "${with_cancel}Q" != "cancelQ" ]; then
 		# after the replace operation, use the target_dev for everything
 		_check_btrfs_filesystem $target_dev
diff --git a/tests/btrfs/029 b/tests/btrfs/029
index cdce6e1..a8c1214 100755
--- a/tests/btrfs/029
+++ b/tests/btrfs/029
@@ -39,7 +39,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
-    _scratch_unmount &>/dev/null
+    $UMOUNT_PROG $SCRATCH_MNT &>/dev/null
     cd /
     rm -f $tmp.*
 }
@@ -104,7 +104,7 @@ _scratch_unmount
 echo "test reflinks across different mountpoints of same device"
 mount $TEST_DEV $SCRATCH_MNT || _fail "Couldn't double-mount $TEST_DEV"
 _create_reflinks_to $DUAL_MOUNT_DIR
-_scratch_unmount
+$UMOUNT_PROG $SCRATCH_MNT
 
 # success, all done
 status=0
diff --git a/tests/btrfs/031 b/tests/btrfs/031
index 0159c95..521cd01 100755
--- a/tests/btrfs/031
+++ b/tests/btrfs/031
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
-    _scratch_unmount
+    $UMOUNT_PROG $SCRATCH_MNT
     rm -rf $TESTDIR1
     rm -rf $TESTDIR2
     $BTRFS_UTIL_PROG subvolume delete $SUBVOL1 >> $seqres.full
@@ -74,7 +74,6 @@ TESTDIR2=$TEST_DIR/test-$seq-2
 SUBVOL1=$TEST_DIR/subvol-$seq-1
 SUBVOL2=$TEST_DIR/subvol-$seq-2
 
-_scratch_unmount 2>/dev/null
 rm -rf $seqres.full
 rm -rf $TESTDIR1 $TESTDIR2
 $BTRFS_UTIL_PROG subvolume delete $SUBVOL1 >/dev/null 2>&1
-- 
2.1.3

