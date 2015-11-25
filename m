Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:34749 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbbKYLFK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 06:05:10 -0500
Received: from localhost
	by e23smtp03.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 25 Nov 2015 21:05:07 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, chandan@mykolab.com
Subject: [PATCH 10/12] Fix btrfs/098 to work on non-4k block sized filesystems
Date: Wed, 25 Nov 2015 16:33:04 +0530
Message-Id: <1448449386-4186-11-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1448449386-4186-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1448449386-4186-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit makes use of the new _filter_xfs_io_blocks_modified filtering
function to print information in terms of file blocks rather than file
offset.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/btrfs/098     | 65 ++++++++++++++++++++++++++++++-----------------------
 tests/btrfs/098.out |  7 +-----
 2 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/tests/btrfs/098 b/tests/btrfs/098
index 8aef119..4879a90 100755
--- a/tests/btrfs/098
+++ b/tests/btrfs/098
@@ -58,43 +58,49 @@ _scratch_mkfs >>$seqres.full 2>&1
 _init_flakey
 _mount_flakey
 
-# Create our test file with a single 100K extent starting at file offset 800K.
-# We fsync the file here to make the fsync log tree gets a single csum item that
-# covers the whole 100K extent, which causes the second fsync, done after the
-# cloning operation below, to not leave in the log tree two csum items covering
-# two sub-ranges ([0, 20K[ and [20K, 100K[)) of our extent.
-$XFS_IO_PROG -f -c "pwrite -S 0xaa 800K 100K"  \
+BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+
+# Create our test file with a single 25 block extent starting at file offset
+# mapped by 200th block We fsync the file here to make the fsync log tree get a
+# single csum item that covers the whole 25 block extent, which causes the
+# second fsync, done after the cloning operation below, to not leave in the log
+# tree two csum items covering two block sub-ranges ([0, 5[ and [5, 25[)) of our
+# extent.
+$XFS_IO_PROG -f -c "pwrite -S 0xaa $((200 * $BLOCK_SIZE)) $((25 * $BLOCK_SIZE))" \
 		-c "fsync"                     \
-		$SCRATCH_MNT/foo | _filter_xfs_io
+		$SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
+
 
-# Now clone part of our extent into file offset 400K. This adds a file extent
-# item to our inode's metadata that points to the 100K extent we created before,
-# using a data offset of 20K and a data length of 20K, so that it refers to
-# the sub-range [20K, 40K[ of our original extent.
-$CLONER_PROG -s $((800 * 1024 + 20 * 1024)) -d $((400 * 1024)) \
-	-l $((20 * 1024)) $SCRATCH_MNT/foo $SCRATCH_MNT/foo
+# Now clone part of our extent into file offset mapped by 100th block. This adds
+# a file extent item to our inode's metadata that points to the 25 block extent
+# we created before, using a data offset of 5 blocks and a data length of 5
+# blocks, so that it refers to the block sub-range [5, 10[ of our original
+# extent.
+$CLONER_PROG -s $(((200 * $BLOCK_SIZE) + (5 * $BLOCK_SIZE))) \
+	     -d $((100 * $BLOCK_SIZE)) -l $((5 * $BLOCK_SIZE)) \
+	     $SCRATCH_MNT/foo $SCRATCH_MNT/foo
 
 # Now fsync our file to make sure the extent cloning is durably persisted. This
 # fsync will not add a second csum item to the log tree containing the checksums
-# for the blocks in the sub-range [20K, 40K[ of our extent, because there was
+# for the blocks in the block sub-range [5, 10[ of our extent, because there was
 # already a csum item in the log tree covering the whole extent, added by the
 # first fsync we did before.
 $XFS_IO_PROG -c "fsync" $SCRATCH_MNT/foo
 
-echo "File digest before power failure:"
-md5sum $SCRATCH_MNT/foo | _filter_scratch
+orig_hash=$(md5sum $SCRATCH_MNT/foo | cut -f 1 -d ' ')
 
 # The fsync log replay first processes the file extent item corresponding to the
-# file offset 400K (the one which refers to the [20K, 40K[ sub-range of our 100K
-# extent) and then processes the file extent item for file offset 800K. It used
-# to happen that when processing the later, it erroneously left in the csum tree
-# 2 csum items that overlapped each other, 1 for the sub-range [20K, 40K[ and 1
-# for the whole range of our extent. This introduced a problem where subsequent
-# lookups for the checksums of blocks within the range [40K, 100K[ of our extent
-# would not find anything because lookups in the csum tree ended up looking only
-# at the smaller csum item, the one covering the subrange [20K, 40K[. This made
-# read requests assume an expected checksum with a value of 0 for those blocks,
-# which caused checksum verification failure when the read operations finished.
+# file offset mapped by 100th block (the one which refers to the [5, 10[ block
+# sub-range of our 25 block extent) and then processes the file extent item for
+# file offset mapped by 200th block. It used to happen that when processing the
+# later, it erroneously left in the csum tree 2 csum items that overlapped each
+# other, 1 for the block sub-range [5, 10[ and 1 for the whole range of our
+# extent. This introduced a problem where subsequent lookups for the checksums
+# of blocks within the block range [10, 25[ of our extent would not find
+# anything because lookups in the csum tree ended up looking only at the smaller
+# csum item, the one covering the block subrange [5, 10[. This made read
+# requests assume an expected checksum with a value of 0 for those blocks, which
+# caused checksum verification failure when the read operations finished.
 # However those checksum failure did not result in read requests returning an
 # error to user space (like -EIO for e.g.) because the expected checksum value
 # had the special value 0, and in that case btrfs set all bytes of the
@@ -106,10 +112,13 @@ md5sum $SCRATCH_MNT/foo | _filter_scratch
 #
 _flakey_drop_and_remount
 
-echo "File digest after log replay:"
 # Must match the same digest he had after cloning the extent and before the
 # power failure happened.
-md5sum $SCRATCH_MNT/foo | _filter_scratch
+hash=$(md5sum $SCRATCH_MNT/foo | cut -f 1 -d ' ')
+if [ $orig_hash != $hash ]; then
+	echo "Log replay caused corrupted file: "\
+	     "Mimatching hash values detected."
+fi
 
 _unmount_flakey
 
diff --git a/tests/btrfs/098.out b/tests/btrfs/098.out
index 3aa0772..b490cb1 100644
--- a/tests/btrfs/098.out
+++ b/tests/btrfs/098.out
@@ -1,7 +1,2 @@
 QA output created by 098
-wrote 102400/102400 bytes at offset 819200
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-File digest before power failure:
-39b386375971248740ed8651d5a2ed9f  SCRATCH_MNT/foo
-File digest after log replay:
-39b386375971248740ed8651d5a2ed9f  SCRATCH_MNT/foo
+Blocks modified: [200 - 224]
-- 
2.1.0

