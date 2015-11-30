Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:42554 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbbK3KRo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 05:17:44 -0500
Received: from localhost
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 30 Nov 2015 15:47:42 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, chandan@mykolab.com
Subject: [PATCH 3/8] Fix btrfs/094 to work on non-4k block sized filesystems
Date: Mon, 30 Nov 2015 15:47:19 +0530
Message-Id: <1448878644-16503-4-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1448878644-16503-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1448878644-16503-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit makes use of the new _filter_xfs_io_blocks_modified filtering
function to print information in terms of file blocks rather than file
offset.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/btrfs/094     | 75 ++++++++++++++++++++++++++++++-----------------------
 tests/btrfs/094.out | 71 ++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 100 insertions(+), 46 deletions(-)

diff --git a/tests/btrfs/094 b/tests/btrfs/094
index 6f6cdeb..45f108d 100755
--- a/tests/btrfs/094
+++ b/tests/btrfs/094
@@ -67,36 +67,41 @@ mkdir $send_files_dir
 _scratch_mkfs >>$seqres.full 2>&1
 _scratch_mount "-o compress"
 
-# Create the file with a single extent of 128K. This creates a metadata file
-# extent item with a data start offset of 0 and a logical length of 128K.
-$XFS_IO_PROG -f -c "pwrite -S 0xaa 64K 128K" -c "fsync" \
-	$SCRATCH_MNT/foo | _filter_xfs_io
-
-# Now rewrite the range 64K to 112K of our file. This will make the inode's
-# metadata continue to point to the 128K extent we created before, but now
-# with an extent item that points to the extent with a data start offset of
-# 112K and a logical length of 16K.
-# That metadata file extent item is associated with the logical file offset
-# at 176K and covers the logical file range 176K to 192K.
-$XFS_IO_PROG -c "pwrite -S 0xbb 64K 112K" -c "fsync" \
-	$SCRATCH_MNT/foo | _filter_xfs_io
-
-# Now rewrite the range 180K to 12K. This will make the inode's metadata
-# continue to point the the 128K extent we created earlier, with a single
-# extent item that points to it with a start offset of 112K and a logical
-# length of 4K.
-# That metadata file extent item is associated with the logical file offset
-# at 176K and covers the logical file range 176K to 180K.
-$XFS_IO_PROG -c "pwrite -S 0xcc 180K 12K" -c "fsync" \
-	$SCRATCH_MNT/foo | _filter_xfs_io
+BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+
+# Create the file with a single extent of 32 blocks. This creates a metadata
+# file extent item with a data start offset of 0 and a logical length of
+# 32 blocks.
+$XFS_IO_PROG -f -c "pwrite -S 0xaa $((16 * $BLOCK_SIZE)) $((32 * $BLOCK_SIZE))" \
+	     -c "fsync" $SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
+
+# Now rewrite the block range [16, 28[ of our file. This will make
+# the inode's metadata continue to point to the single 32 block extent
+# we created before, but now with an extent item that points to the
+# extent with a data start offset referring to the 28th block and a
+# logical length of 4 blocks.
+# That metadata file extent item is associated with the block range
+# [44, 48[.
+$XFS_IO_PROG -c "pwrite -S 0xbb $((16 * $BLOCK_SIZE)) $((28 * $BLOCK_SIZE))" \
+	     -c "fsync" $SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
+
+
+# Now rewrite the block range [45, 48[. This will make the inode's
+# metadata continue to point the 32 block extent we created earlier,
+# with a single extent item that points to it with a start offset
+# referring to the 28th block and a logical length of 1 block.
+# That metadata file extent item is associated with the block range
+# [44, 45[.
+$XFS_IO_PROG -c "pwrite -S 0xcc $((45 * $BLOCK_SIZE)) $((3 * $BLOCK_SIZE))" \
+	     -c "fsync" $SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
 
 _run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
 
-# Now clone that same region of the 128K extent into a new file, so that it
+# Now clone that same region of the 32 block extent into a new file, so that it
 # gets referenced twice and the incremental send operation below decides to
 # issue a clone operation instead of copying the data.
 touch $SCRATCH_MNT/bar
-$CLONER_PROG -s $((176 * 1024)) -d $((176 * 1024)) -l $((4 * 1024)) \
+$CLONER_PROG -s $((44 * $BLOCK_SIZE)) -d $((44 * $BLOCK_SIZE)) -l $BLOCK_SIZE \
 	$SCRATCH_MNT/foo $SCRATCH_MNT/bar
 
 _run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
@@ -105,10 +110,13 @@ _run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $send_files_dir/1.snap
 _run_btrfs_util_prog send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
 	-f $send_files_dir/2.snap
 
-echo "File digests in the original filesystem:"
-md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch
-md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
-md5sum $SCRATCH_MNT/mysnap2/bar | _filter_scratch
+echo "File contents in the original filesystem:"
+echo "mysnap1/foo"
+od -t x1 $SCRATCH_MNT/mysnap1/foo | _filter_od
+echo "mysnap2/foo"
+od -t x1 $SCRATCH_MNT/mysnap2/foo | _filter_od
+echo "mysnap2/bar"
+od -t x1 $SCRATCH_MNT/mysnap2/bar | _filter_od
 
 # Now recreate the filesystem by receiving both send streams and verify we get
 # the same file contents that the original filesystem had.
@@ -119,10 +127,13 @@ _scratch_mount
 _run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/1.snap
 _run_btrfs_util_prog receive $SCRATCH_MNT -f $send_files_dir/2.snap
 
-echo "File digests in the new filesystem:"
-md5sum $SCRATCH_MNT/mysnap1/foo | _filter_scratch
-md5sum $SCRATCH_MNT/mysnap2/foo | _filter_scratch
-md5sum $SCRATCH_MNT/mysnap2/bar | _filter_scratch
+echo "File contents in the new filesystem:"
+echo "mysnap1/foo"
+od -t x1 $SCRATCH_MNT/mysnap1/foo | _filter_od
+echo "mysnap2/foo"
+od -t x1 $SCRATCH_MNT/mysnap2/foo | _filter_od
+echo "mysnap2/bar"
+od -t x1 $SCRATCH_MNT/mysnap2/bar | _filter_od
 
 status=0
 exit
diff --git a/tests/btrfs/094.out b/tests/btrfs/094.out
index c3ac1bf..1c00cc5 100644
--- a/tests/btrfs/094.out
+++ b/tests/btrfs/094.out
@@ -1,15 +1,58 @@
 QA output created by 094
-wrote 131072/131072 bytes at offset 65536
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 114688/114688 bytes at offset 65536
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 12288/12288 bytes at offset 184320
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-File digests in the original filesystem:
-f98243c603750f7daf225b1745b31516  SCRATCH_MNT/mysnap1/foo
-f98243c603750f7daf225b1745b31516  SCRATCH_MNT/mysnap2/foo
-7fccf6175f5c68504b408719a21db99f  SCRATCH_MNT/mysnap2/bar
-File digests in the new filesystem:
-f98243c603750f7daf225b1745b31516  SCRATCH_MNT/mysnap1/foo
-f98243c603750f7daf225b1745b31516  SCRATCH_MNT/mysnap2/foo
-7fccf6175f5c68504b408719a21db99f  SCRATCH_MNT/mysnap2/bar
+Blocks modified: [16 - 47]
+Blocks modified: [16 - 43]
+Blocks modified: [45 - 47]
+File contents in the original filesystem:
+mysnap1/foo
+0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+20 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
+*
+54 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+55 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
+*
+60
+mysnap2/foo
+0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+20 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
+*
+54 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+55 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
+*
+60
+mysnap2/bar
+0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+54 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+55
+File contents in the new filesystem:
+mysnap1/foo
+0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+20 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
+*
+54 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+55 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
+*
+60
+mysnap2/foo
+0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+20 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
+*
+54 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+55 cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
+*
+60
+mysnap2/bar
+0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+*
+54 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+55
-- 
2.1.0

