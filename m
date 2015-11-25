Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:39596 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbbKYLFC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 06:05:02 -0500
Received: from localhost
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 25 Nov 2015 21:05:00 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, chandan@mykolab.com
Subject: [PATCH 07/12] Fix btrfs/095 to work on non-4k block sized filesystems
Date: Wed, 25 Nov 2015 16:33:01 +0530
Message-Id: <1448449386-4186-8-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1448449386-4186-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1448449386-4186-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit makes use of the new _filter_xfs_io_blocks_modified filtering
function to print information in terms of file blocks rather than file
offset.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/btrfs/095     | 113 +++++++++++++++++++++++++++++-----------------------
 tests/btrfs/095.out |  10 +----
 2 files changed, 66 insertions(+), 57 deletions(-)

diff --git a/tests/btrfs/095 b/tests/btrfs/095
index 1b4ba90..e73b14e 100755
--- a/tests/btrfs/095
+++ b/tests/btrfs/095
@@ -63,85 +63,100 @@ _scratch_mkfs >>$seqres.full 2>&1
 _init_flakey
 _mount_flakey
 
-# Create prealloc extent covering range [160K, 620K[
-$XFS_IO_PROG -f -c "falloc 160K 460K" $SCRATCH_MNT/foo
+BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
 
-# Now write to the last 80K of the prealloc extent plus 40K to the unallocated
-# space that immediately follows it. This creates a new extent of 40K that spans
-# the range [620K, 660K[.
-$XFS_IO_PROG -c "pwrite -S 0xaa 540K 120K" $SCRATCH_MNT/foo | _filter_xfs_io
+# Create prealloc extent covering file block range [40, 155[
+$XFS_IO_PROG -f -c "falloc $((40 * $BLOCK_SIZE)) $((115 * $BLOCK_SIZE))" \
+	     $SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
+
+# Now write to the last 20 blocks of the prealloc extent plus 10 blocks to the
+# unallocated space that immediately follows it. This creates a new extent of 10
+# blocks that spans the block range [155, 165[.
+$XFS_IO_PROG -c "pwrite -S 0xaa $((135 * $BLOCK_SIZE)) $((30 * $BLOCK_SIZE))" \
+	     $SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
 
 # At this point, there are now 2 back references to the prealloc extent in our
-# extent tree. Both are for our file offset 160K and one relates to a file
-# extent item with a data offset of 0 and a length of 380K, while the other
-# relates to a file extent item with a data offset of 380K and a length of 80K.
+# extent tree. Both are for our file offset mapped by the 40th block of the file
+# and one relates to a file extent item with a data offset of 0 and a length of
+# 95 blocks, while the other relates to a file extent item with a data offset of
+# 95 blocks and a length of 20 blocks.
 
 # Make sure everything done so far is durably persisted (all back references are
 # in the extent tree, etc).
 sync
 
-# Now clone all extents of our file that cover the offset 160K up to its eof
-# (660K at this point) into itself at offset 2M. This leaves a hole in the file
-# covering the range [660K, 2M[. The prealloc extent will now be referenced by
-# the file twice, once for offset 160K and once for offset 2M. The 40K extent
-# that follows the prealloc extent will also be referenced twice by our file,
-# once for offset 620K and once for offset 2M + 460K.
-$CLONER_PROG -s $((160 * 1024)) -d $((2 * 1024 * 1024)) -l 0 $SCRATCH_MNT/foo \
-	$SCRATCH_MNT/foo
-
-# Now create one new extent in our file with a size of 100Kb. It will span the
-# range [3M, 3M + 100K[. It also will cause creation of a hole spanning the
-# range [2M + 460K, 3M[. Our new file size is 3M + 100K.
-$XFS_IO_PROG -c "pwrite -S 0xbb 3M 100K" $SCRATCH_MNT/foo | _filter_xfs_io
+# Now clone all extents of our file that cover the file range spanned by 40th
+# block up to its eof (165th block at this point) into itself at 512th
+# block. This leaves a hole in the file covering the block range [165, 512[. The
+# prealloc extent will now be referenced by the file twice, once for offset
+# mapped by the 40th block and once for offset mapped by 512th block. The 10
+# blocks extent that follows the prealloc extent will also be referenced twice
+# by our file, once for offset mapped by the 155th block and once for offset
+# (512 block + 115 blocks)
+$CLONER_PROG -s $((40 * $BLOCK_SIZE)) -d $((512 * $BLOCK_SIZE)) -l 0 \
+	     $SCRATCH_MNT/foo $SCRATCH_MNT/foo
+
+# Now create one new extent in our file with a size of 25 blocks. It will span
+# the block range [768, 768 + 25[. It also will cause creation of a hole
+# spanning the block range [512 + 115, 768[. Our new file size is the file
+# offset mapped by (768 + 25)th block.
+$XFS_IO_PROG -c "pwrite -S 0xbb $((768 * $BLOCK_SIZE)) $((25 * $BLOCK_SIZE))" \
+	     $SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
 
 # At this point, there are now (in memory) 4 back references to the prealloc
 # extent.
 #
-# Two of them are for file offset 160K, related to file extent items
-# matching the file offsets 160K and 540K respectively, with data offsets of
-# 0 and 380K respectively, and with lengths of 380K and 80K respectively.
+# Two of them are for file offset mapped by the 40th block, related to file
+# extent items matching the file offsets mapped by 40th and 135th block
+# respectively, with data offsets of 0 and 95 blocks respectively, and with
+# lengths of 95 and 20 blocks respectively.
 #
-# The other two references are for file offset 2M, related to file extent items
-# matching the file offsets 2M and 2M + 380K respectively, with data offsets of
-# 0 and 380K respectively, and with lengths of 380K and 80K respectively.
+# The other two references are for file offset mapped by 512th block, related to
+# file extent items matching the file offsets mapped by 512th and (512 + 95)th
+# block respectively, with data offsets mapped by 0th and 95th block
+# respectively, and with lengths of 95 and 20 blocks respectively.
 #
-# The 40K extent has 2 back references, one for file offset 620K and the other
-# for file offset 2M + 460K.
+# The 10 block extent has 2 back references, one for file offset mapped by 155th
+# block and the other for file offset mapped by (512 + 115)th block.
 #
-# The 100K extent has a single back reference and it relates to file offset 3M.
+# The 25 blocks extent has a single back reference and it relates to file offset
+# mapped by 768th block.
 
-# Now clone our 100K extent into offset 600K. That offset covers the last 20K
-# of the prealloc extent, the whole 40K extent and 40K of the hole starting at
-# offset 660K.
-$CLONER_PROG -s $((3 * 1024 * 1024)) -d $((600 * 1024)) -l $((100 * 1024)) \
+
+# Now clone our 25 block extent into offset mapped by 150th block. That offset
+# covers the last 5 blocks of the prealloc extent, the whole 10 block extent and
+# 10 blocks of the hole starting at offset mapped by 165th block.
+$CLONER_PROG -s $((768 * $BLOCK_SIZE)) -d $((150 * $BLOCK_SIZE)) -l $((25 * $BLOCK_SIZE)) \
 	$SCRATCH_MNT/foo $SCRATCH_MNT/foo
 
-# At this point there's only one reference to the 40K extent, at file offset
-# 2M + 460K, we have 4 references for the prealloc extent (2 for file offset
-# 160K and 2 for file offset 2M) and 2 references for the 100K extent (1 for
-# file offset 3M and a new one for file offset 600K).
+# At this point there's only one reference to the 10 block extent, at file
+# offset mapped by (512 + 115) block, we have 4 references for the prealloc
+# extent (2 for file offset mapped by 40th block and 2 for file offset mapped by
+# 512th block) and 2 references for the 25 block extent (1 for file offset
+# mapped by 768th block and a new one for file offset mapped by 150th block).
 
 # Now fsync our file to make all its new data and metadata updates are durably
 # persisted and present if a power failure/crash happens after a successful
 # fsync and before the next transaction commit.
 $XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foo
 
-echo "File digest before power failure:"
-md5sum $SCRATCH_MNT/foo | _filter_scratch
+orig_hash=$(md5sum $SCRATCH_MNT/foo | cut -f 1 -d ' ')
 
 # During log replay, the btrfs delayed references implementation used to run the
 # deletion of back references before the addition of new back references, which
 # made the addition fail as it didn't find the key in the extent tree that it
-# was looking for. The failure triggered by this test was related to the 40K
-# extent, which got 1 reference dropped and 1 reference added during the fsync
-# log replay - when running the delayed references at transaction commit time,
-# btrfs was applying the deletion before the insertion, resulting in a failure
-# of the insertion that ended up turning the fs into read-only mode.
+# was looking for. The failure triggered by this test was related to the 10
+# block extent, which got 1 reference dropped and 1 reference added during the
+# fsync log replay - when running the delayed references at transaction commit
+# time, btrfs was applying the deletion before the insertion, resulting in a
+# failure of the insertion that ended up turning the fs into read-only mode.
 _flakey_drop_and_remount
 
-echo "File digest after log replay:"
-md5sum $SCRATCH_MNT/foo | _filter_scratch
-
+hash=$(md5sum $SCRATCH_MNT/foo | cut -f 1 -d ' ')
+if [ $orig_hash != $hash ]; then
+	echo "Delayed refs replayed back with incorrect order: "\
+	     "Mimatching hash values detected."
+fi
 _unmount_flakey
 
 status=0
diff --git a/tests/btrfs/095.out b/tests/btrfs/095.out
index e93435c..89b423f 100644
--- a/tests/btrfs/095.out
+++ b/tests/btrfs/095.out
@@ -1,9 +1,3 @@
 QA output created by 095
-wrote 122880/122880 bytes at offset 552960
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 102400/102400 bytes at offset 3145728
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-File digest before power failure:
-beaf47c36659ac29bb9363fb8ffa10a1  SCRATCH_MNT/foo
-File digest after log replay:
-beaf47c36659ac29bb9363fb8ffa10a1  SCRATCH_MNT/foo
+Blocks modified: [135 - 164]
+Blocks modified: [768 - 792]
-- 
2.1.0

