Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:38444 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbbK3KRq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 05:17:46 -0500
Received: from localhost
	by e28smtp02.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 30 Nov 2015 15:47:44 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, chandan@mykolab.com
Subject: [PATCH 5/8] Fix btrfs/097 to work on non-4k block sized filesystems
Date: Mon, 30 Nov 2015 15:47:21 +0530
Message-Id: <1448878644-16503-6-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1448878644-16503-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1448878644-16503-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit makes use of the new _filter_xfs_io_blocks_modified filtering
function to print information in terms of file blocks rather than file
offset.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/btrfs/097     | 41 ++++++++++++++++++++++++-----------------
 tests/btrfs/097.out | 23 +++++++++++++++++------
 2 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/tests/btrfs/097 b/tests/btrfs/097
index d9138ea..d1cfff1 100755
--- a/tests/btrfs/097
+++ b/tests/btrfs/097
@@ -57,22 +57,29 @@ mkdir $send_files_dir
 _scratch_mkfs >>$seqres.full 2>&1
 _scratch_mount
 
-# Create our test file with a single extent of 64K starting at file offset 128K.
-$XFS_IO_PROG -f -c "pwrite -S 0xaa 128K 64K" $SCRATCH_MNT/foo | _filter_xfs_io
+BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+
+# Create our test file with a single extent of 16 blocks starting at a file
+# offset mapped by 32nd block.
+$XFS_IO_PROG -f -c "pwrite -S 0xaa $((32 * $BLOCK_SIZE)) $((16 * $BLOCK_SIZE))" \
+	     $SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
 
 _run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
 
 # Now clone parts of the original extent into lower offsets of the file.
 #
 # The first clone operation adds a file extent item to file offset 0 that points
-# to our initial extent with a data offset of 16K. The corresponding data back
-# reference in the extent tree has an offset of 18446744073709535232, which is
-# the result of file_offset - data_offset = 0 - 16K.
-#
-# The second clone operation adds a file extent item to file offset 16K that
-# points to our initial extent with a data offset of 48K. The corresponding data
-# back reference in the extent tree has an offset of 18446744073709518848, which
-# is the result of file_offset - data_offset = 16K - 48K.
+# to our initial extent with a data offset of 4 blocks. The corresponding data back
+# reference in the extent tree has a large value for the 'offset' field, which is
+# the result of file_offset - data_offset = 0 - (file offset of 4th block).  For
+# example in case of 4k block size, it will be 0 - 16k = 18446744073709535232.
+
+# The second clone operation adds a file extent item to file offset mapped by
+# 4th block that points to our initial extent with a data offset of 12
+# blocks. The corresponding data back reference in the extent tree has a large
+# value for the 'offset' field, which is the result of file_offset - data_offset
+# = (file offset of 4th block) - (file offset of 12th block). For example in
+# case of 4k block size, it will be 16K - 48K = 18446744073709518848.
 #
 # Those large back reference offsets (result of unsigned arithmetic underflow)
 # confused the back reference walking code (used by an incremental send and
@@ -83,10 +90,10 @@ _run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
 # "BTRFS error (device sdc): did not find backref in send_root. inode=257, \
 #  offset=0, disk_byte=12845056 found extent=12845056"
 #
-$CLONER_PROG -s $(((128 + 16) * 1024)) -d 0 -l $((16 * 1024)) \
-	$SCRATCH_MNT/foo $SCRATCH_MNT/foo
-$CLONER_PROG -s $(((128 + 48) * 1024)) -d $((16 * 1024)) -l $((16 * 1024)) \
+$CLONER_PROG -s $(((32 + 4) * $BLOCK_SIZE)) -d 0 -l $((4 * $BLOCK_SIZE)) \
 	$SCRATCH_MNT/foo $SCRATCH_MNT/foo
+$CLONER_PROG -s $(((32 + 12) * $BLOCK_SIZE)) -d $((4 * $BLOCK_SIZE)) \
+	     -l $((4 * $BLOCK_SIZE)) $SCRATCH_MNT/foo $SCRATCH_MNT/foo
 
 _run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
 
@@ -94,8 +101,8 @@ _run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $send_files_dir/1.snap
 _run_btrfs_util_prog send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
 	-f $send_files_dir/2.snap
 
-echo "File digest in the original filesystem:"
-md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
+echo "File contents in the original filesystem:"
+od -t x1 $SCRATCH_MNT/mysnap2/foo | _filter_od
 
 # Now recreate the filesystem by receiving both send streams and verify we get
 # the same file contents that the original filesystem had.
@@ -106,8 +113,8 @@ _scratch_mount
 _run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
 _run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/2.snap
 
-echo "File digest in the new filesystem:"
-md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
+echo "File contents in the new filesystem:"
+od -t x1 $SCRATCH_MNT/mysnap2/foo | _filter_od
 
 status=0
 exit
diff --git a/tests/btrfs/097.out b/tests/btrfs/097.out
index 5e87eb2..aa9e549 100644
--- a/tests/btrfs/097.out
+++ b/tests/btrfs/097.out
@@ -1,7 +1,18 @@
 QA output created by 097
-wrote 65536/65536 bytes at offset 131072
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-File digest in the original filesystem:
-6c6079335cff141b8a31233ead04cbff  SCRATCH_MNT/mysnap2/foo
-File digest in the new filesystem:
-6c6079335cff141b8a31233ead04cbff  SCRATCH_MNT/mysnap2/foo
+Blocks modified: [32 - 47]
+File contents in the original filesystem:
+0 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+40 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+60
+File contents in the new filesystem:
+0 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+40 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+60
-- 
2.1.0

