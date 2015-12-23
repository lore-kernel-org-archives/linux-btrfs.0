Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45356 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbbLXMOG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 07:14:06 -0500
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 3/4 v2] fstests: cleanup test btrfs/031
Date: Wed, 23 Dec 2015 04:43:14 +0000
Message-Id: <1450845795-18729-3-git-send-email-fdmanana@kernel.org>
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

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: First version of the change, introduced in the v2 of the corresponding
    patchset.

 tests/btrfs/031 | 102 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 51 insertions(+), 51 deletions(-)

diff --git a/tests/btrfs/031 b/tests/btrfs/031
index 0159c95..fe8cd4e 100755
--- a/tests/btrfs/031
+++ b/tests/btrfs/031
@@ -36,11 +36,6 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
-    _scratch_unmount
-    rm -rf $TESTDIR1
-    rm -rf $TESTDIR2
-    $BTRFS_UTIL_PROG subvolume delete $SUBVOL1 >> $seqres.full
-    $BTRFS_UTIL_PROG subvolume delete $SUBVOL2 >> $seqres.full
     cd /
     rm -f $tmp.*
 }
@@ -57,84 +52,89 @@ _supported_os Linux
 _require_test
 _require_scratch
 _require_cp_reflink
+_need_to_be_root
 
-_checksum_files() {
-    for F in file1 file2 file3
-    do
-        echo "$F:"
-        for D in $TESTDIR1 $SCRATCH_MNT $SUBVOL2
-        do
-            _md5_checksum $D/$F
-        done
-    done
+_checksum_files()
+{
+	for f in file1 file2 file3; do
+		echo "$f:"
+		for d in $testdir1 $cross_mount_test_dir $subvol2; do
+			_md5_checksum $d/$f
+		done
+	done
 }
 
-TESTDIR1=$TEST_DIR/test-$seq-1
-TESTDIR2=$TEST_DIR/test-$seq-2
-SUBVOL1=$TEST_DIR/subvol-$seq-1
-SUBVOL2=$TEST_DIR/subvol-$seq-2
+testdir1=$SCRATCH_MNT/test-$seq-1
+testdir2=$SCRATCH_MNT/test-$seq-2
+subvol1=$SCRATCH_MNT/subvol-$seq-1
+subvol2=$SCRATCH_MNT/subvol-$seq-2
+cross_mount_test_dir=$TEST_DIR/test-$seq
+
+rm -f $seqres.full
 
-_scratch_unmount 2>/dev/null
-rm -rf $seqres.full
-rm -rf $TESTDIR1 $TESTDIR2
-$BTRFS_UTIL_PROG subvolume delete $SUBVOL1 >/dev/null 2>&1
-$BTRFS_UTIL_PROG subvolume delete $SUBVOL2 >/dev/null 2>&1
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
 
-mkdir $TESTDIR1
-mkdir $TESTDIR2
-$BTRFS_UTIL_PROG subvolume create $SUBVOL1 >> $seqres.full
-$BTRFS_UTIL_PROG subvolume create $SUBVOL2 >> $seqres.full
-_mount -t btrfs -o subvol=subvol-$seq-1 $TEST_DEV $SCRATCH_MNT
+mkdir $testdir1
+mkdir $testdir2
+$BTRFS_UTIL_PROG subvolume create $subvol1 >> $seqres.full
+$BTRFS_UTIL_PROG subvolume create $subvol2 >> $seqres.full
+rm -rf $cross_mount_test_dir
+mkdir $cross_mount_test_dir
+
+_mount -t btrfs -o subvol=subvol-$seq-1 $SCRATCH_DEV $cross_mount_test_dir
 
 echo "Create initial files"
-# TESTDIR1/file1 is very small and will be inlined
-$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 10' $TESTDIR1/file1 \
+# #testdir1/file1 is very small and will be inlined
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 10' $testdir1/file1 \
     >> $seqres.full
-$XFS_IO_PROG -f -c 'pwrite -S 0x62 0 13000' $SCRATCH_MNT/file2 \
+$XFS_IO_PROG -f -c 'pwrite -S 0x62 0 13000' $cross_mount_test_dir/file2 \
     >> $seqres.full
-$XFS_IO_PROG -f -c 'pwrite -S 0x63 0 17000' $SUBVOL2/file3 \
+$XFS_IO_PROG -f -c 'pwrite -S 0x63 0 17000' $subvol2/file3 \
     >> $seqres.full
 
 echo "Create reflinks to the initial files on other subvolumes"
-cp --reflink=always $TESTDIR1/file1 $SUBVOL1
-cp --reflink=always $TESTDIR1/file1 $SUBVOL2
-cp --reflink=always $SUBVOL1/file2 $TESTDIR1/
-cp --reflink=always $SUBVOL1/file2 $SUBVOL2
-cp --reflink=always $SUBVOL2/file3 $TESTDIR1/
-cp --reflink=always $SUBVOL2/file3 $SUBVOL1
+cp --reflink=always $testdir1/file1 $subvol1
+cp --reflink=always $testdir1/file1 $subvol2
+cp --reflink=always $subvol1/file2 $testdir1/
+cp --reflink=always $subvol1/file2 $subvol2
+cp --reflink=always $subvol2/file3 $testdir1/
+cp --reflink=always $subvol2/file3 $subvol1
 
 echo "Verify the reflinks"
-_verify_reflink $SCRATCH_MNT/file2 $TESTDIR1/file2
-_verify_reflink $SCRATCH_MNT/file2 $SUBVOL2/file2
-_verify_reflink $SUBVOL2/file3 $TESTDIR1/file3
-_verify_reflink $SUBVOL2/file3 $SCRATCH_MNT/file3
+_verify_reflink $cross_mount_test_dir/file2 $testdir1/file2
+_verify_reflink $cross_mount_test_dir/file2 $subvol2/file2
+_verify_reflink $subvol2/file3 $testdir1/file3
+_verify_reflink $subvol2/file3 $cross_mount_test_dir/file3
 echo "Verify the file contents:"
 _checksum_files
 
 echo -e "---\nOverwrite some files with new content"
-$XFS_IO_PROG -c 'pwrite -S 0x64 0 20' $TESTDIR1/file1 >> $seqres.full
-$XFS_IO_PROG -c 'pwrite -S 0x66 0 21000' $SUBVOL2/file2 >> $seqres.full
-$XFS_IO_PROG -c 'pwrite -S 0x65 5000 5000' $SCRATCH_MNT/file3 \
+$XFS_IO_PROG -c 'pwrite -S 0x64 0 20' $testdir1/file1 >> $seqres.full
+$XFS_IO_PROG -c 'pwrite -S 0x66 0 21000' $subvol2/file2 >> $seqres.full
+$XFS_IO_PROG -c 'pwrite -S 0x65 5000 5000' $cross_mount_test_dir/file3 \
     >> $seqres.full
 
 echo -n "Verify that non-overwritten reflinks "
 echo "still have the same data blocks"
-_verify_reflink $TESTDIR1/file2 $SCRATCH_MNT/file2
-_verify_reflink $TESTDIR1/file3 $SUBVOL2/file3
+_verify_reflink $testdir1/file2 $cross_mount_test_dir/file2
+_verify_reflink $testdir1/file3 $subvol2/file3
 echo "Verify the file contents:"
 _checksum_files
 
 echo -e "---\nShuffle files between directories"
-mv $TESTDIR1/file* $TESTDIR2
-mv $SCRATCH_MNT/file* $TESTDIR1/
-mv $SUBVOL2/file* $SCRATCH_MNT/
-mv $TESTDIR2/file* $SUBVOL2/
+mv $testdir1/file* $testdir2
+mv $cross_mount_test_dir/file* $testdir1/
+mv $subvol2/file* $cross_mount_test_dir/
+mv $testdir2/file* $subvol2/
 
 # No _verify_reflink here as data is copied when moving files
 # between subvols
 echo "Verify the file contents:"
 _checksum_files
 
+$UMOUNT_PROG $cross_mount_test_dir
+
 # success, all done
 status=0
 exit
-- 
2.1.3

