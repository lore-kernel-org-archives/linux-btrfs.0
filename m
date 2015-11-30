Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:39197 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbbK3KRe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 05:17:34 -0500
Received: from localhost
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 30 Nov 2015 15:47:32 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, chandan@mykolab.com
Subject: [PATCH 2/8] Fix btrfs/052 to work on non-4k block sized filesystems
Date: Mon, 30 Nov 2015 15:47:18 +0530
Message-Id: <1448878644-16503-3-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1448878644-16503-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1448878644-16503-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit makes use of the new _filter_xfs_io_blocks_modified filtering
function to print information in terms of file blocks rather than file
offset.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/btrfs/052     | 122 +++++----
 tests/btrfs/052.out | 744 +++++++++++++++++++++++++++++++---------------------
 2 files changed, 515 insertions(+), 351 deletions(-)

diff --git a/tests/btrfs/052 b/tests/btrfs/052
index c75193d..b760b92 100755
--- a/tests/btrfs/052
+++ b/tests/btrfs/052
@@ -59,78 +59,98 @@ test_btrfs_clone_same_file()
 	_scratch_mkfs >/dev/null 2>&1
 	_scratch_mount $MOUNT_OPTIONS
 
-	# Create a file with 5 extents, 4 of 8Kb each and 1 of 64Kb.
-	$XFS_IO_PROG -f -c "pwrite -S 0x01 -b 8192 0 8192" $SCRATCH_MNT/foo \
-		| _filter_xfs_io
+	BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+
+	EXTENT_SIZE=$((2 * $BLOCK_SIZE))
+
+	# Create a file with 5 extents, 4 extents of 2 blocks each and 1 extent
+	# of 16 blocks.
+	OFFSET=0
+	$XFS_IO_PROG -f -c "pwrite -S 0x01 -b $EXTENT_SIZE $OFFSET $EXTENT_SIZE" $SCRATCH_MNT/foo \
+		| _filter_xfs_io_blocks_modified
 	sync
-	$XFS_IO_PROG -c "pwrite -S 0x02 -b 8192 8192 8192" $SCRATCH_MNT/foo \
-		| _filter_xfs_io
+
+	OFFSET=$(($OFFSET + $EXTENT_SIZE))
+	$XFS_IO_PROG -c "pwrite -S 0x02 -b $EXTENT_SIZE $OFFSET $EXTENT_SIZE" $SCRATCH_MNT/foo \
+		| _filter_xfs_io_blocks_modified
 	sync
-	$XFS_IO_PROG -c "pwrite -S 0x03 -b 8192 16384 8192" $SCRATCH_MNT/foo \
-		| _filter_xfs_io
+
+	OFFSET=$(($OFFSET + $EXTENT_SIZE))
+	$XFS_IO_PROG -c "pwrite -S 0x03 -b $EXTENT_SIZE $OFFSET $EXTENT_SIZE" $SCRATCH_MNT/foo \
+		| _filter_xfs_io_blocks_modified
 	sync
-	$XFS_IO_PROG -c "pwrite -S 0x04 -b 8192 24576 8192" $SCRATCH_MNT/foo \
-		| _filter_xfs_io
+
+	OFFSET=$(($OFFSET + $EXTENT_SIZE))
+	$XFS_IO_PROG -c "pwrite -S 0x04 -b $EXTENT_SIZE $OFFSET $EXTENT_SIZE" $SCRATCH_MNT/foo \
+		| _filter_xfs_io_blocks_modified
 	sync
-	$XFS_IO_PROG -c "pwrite -S 0x05 -b 65536 32768 65536" $SCRATCH_MNT/foo \
-		| _filter_xfs_io
+
+	OFFSET=$(($OFFSET + $EXTENT_SIZE))
+	EXTENT_SIZE=$((16 * $BLOCK_SIZE))
+	$XFS_IO_PROG -c "pwrite -S 0x05 -b $EXTENT_SIZE $OFFSET $EXTENT_SIZE" $SCRATCH_MNT/foo \
+		| _filter_xfs_io_blocks_modified
 	sync
 
-	# Digest of initial content.
-	md5sum $SCRATCH_MNT/foo | _filter_scratch
+	# Initial file content.
+	od -t x1 $SCRATCH_MNT/foo | _filter_od
 
 	# Same source and target ranges - must fail.
-	$CLONER_PROG -s 8192 -d 8192 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
+	$CLONER_PROG -s $((2 * $BLOCK_SIZE)) -d $((2 * $BLOCK_SIZE)) \
+		     -l $((2 * $BLOCK_SIZE)) $SCRATCH_MNT/foo $SCRATCH_MNT/foo
 	# Check file content didn't change.
-	md5sum $SCRATCH_MNT/foo | _filter_scratch
+	od -t x1 $SCRATCH_MNT/foo | _filter_od
 
 	# Intersection between source and target ranges - must fail too.
-	$CLONER_PROG -s 4096 -d 8192 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
+	# $CLONER_PROG -s 4096 -d 8192 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
+	$CLONER_PROG -s $((1 * $BLOCK_SIZE)) -d $((2 * $BLOCK_SIZE)) \
+		     -l $((2 * $BLOCK_SIZE)) $SCRATCH_MNT/foo $SCRATCH_MNT/foo
 	# Check file content didn't change.
-	md5sum $SCRATCH_MNT/foo | _filter_scratch
+	od -t x1 $SCRATCH_MNT/foo | _filter_od
 
 	# Clone an entire extent from a higher range to a lower range.
-	$CLONER_PROG -s 24576 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
-
-	# Check entire file, the 8Kb block at offset 0 now has the same content
-	# as the 8Kb block at offset 24576.
-	od -t x1 $SCRATCH_MNT/foo
+	$CLONER_PROG -s $((6 * $BLOCK_SIZE)) -d 0 -l $((2 * $BLOCK_SIZE)) \
+		     $SCRATCH_MNT/foo $SCRATCH_MNT/foo
+	# Check entire file, 0th and 1st blocks now have the same content
+	# as the 6th and 7th blocks.
+	od -t x1 $SCRATCH_MNT/foo | _filter_od
 
 	# Clone an entire extent from a lower range to a higher range.
-	$CLONER_PROG -s 8192 -d 16384 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo
-
-	# Check entire file, the 8Kb block at offset 0 now has the same content
-	# as the 8Kb block at offset 24576, and the 8Kb block at offset 16384
-	# now has the same content as the 8Kb block at offset 8192.
-	od -t x1 $SCRATCH_MNT/foo
-
-	# Now clone 1 extent and an half into the file range starting at offset
-	# 65536. So we get the second half of the extent at offset 16384 and the
-	# whole extent at 24576 cloned into the middle of the 64Kb extent that
-	# starts at file offset 32768. This makes the clone ioctl process more
-	# extent items from the b+tree and forces a split of the large 64Kb
-	# extent at the end of the file.
-	$CLONER_PROG -s 20480 -d 65536 -l 12288 $SCRATCH_MNT/foo \
-		$SCRATCH_MNT/foo
-
-	# Check entire file. Besides the previous changes, we now should have
-	# 4096 bytes with the value 0x02 at file offset 65536, and 8192 bytes
-	# with value 0x04 at the file offset 69632. The ranges [32768, 65536[
-	# and [77824, 98304[ should remain with all bytes having the value 0x05.
-	od -t x1 $SCRATCH_MNT/foo
-
-	# Now update 8Kb of data at offset 0. The extent at this position is a
-	# clone of the extent at offset 24576. Check that writing to this offset
-	# doesn't change data at offset 24576.
-	$XFS_IO_PROG -c "pwrite -S 0xff -b 8192 0 8192" $SCRATCH_MNT/foo \
-		| _filter_xfs_io
-	od -t x1 $SCRATCH_MNT/foo
+	$CLONER_PROG -s $((2 * $BLOCK_SIZE)) -d $((4 * $BLOCK_SIZE)) \
+		     -l $((2 * $BLOCK_SIZE)) $SCRATCH_MNT/foo $SCRATCH_MNT/foo
+	# Check entire file, 0th and 1st blocks now have the same content
+	# as the 6th and 7th block, and 4th and 5th blocks now has the same
+	# content as the 2nd and 3rd blocks.
+	od -t x1 $SCRATCH_MNT/foo | _filter_od
+
+	# Now clone 1 extent and an half into the file range starting
+	# at 16th block So we get the second half of the extent
+	# starting at 4th block and the whole extent starting at 6th
+	# block cloned into the middle of the 16 blocks extent that
+	# starts at 8th block. This makes the clone ioctl process more
+	# extent items from the b+tree and forces a split of the large
+	# 16-block extent at the end of the file.
+	$CLONER_PROG -s $((5 * $BLOCK_SIZE)) -d $((16 * $BLOCK_SIZE)) \
+		     -l $((3 * $BLOCK_SIZE)) $SCRATCH_MNT/foo $SCRATCH_MNT/foo
+
+	# Check entire file. Besides the previous changes, we now
+	# should have 1 block with the value 0x02 at 16th block, and 2
+	# blocks with value 0x04 starting at the 17th block . The
+	# block ranges [8, 16[ and [19, 24[ should remain with all
+	# bytes having the value 0x05.
+	od -t x1 $SCRATCH_MNT/foo | _filter_od
+
+	# Now update 2 blocks of data at offset 0. The extent at this
+	# position is a clone of the extent at 6th block. Check that
+	# writing to this offset doesn't change data at 6th block.
+	$XFS_IO_PROG -c "pwrite -S 0xff -b $((2 * $BLOCK_SIZE)) 0 $((2 * $BLOCK_SIZE))" \
+		     $SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
+	od -t x1 $SCRATCH_MNT/foo | _filter_od
 
 	# Check that after defragmenting the file and re-mounting, the file
 	# content remains exactly the same as before.
 	_run_btrfs_util_prog filesystem defragment $SCRATCH_MNT/foo
 	_scratch_remount
-	od -t x1 $SCRATCH_MNT/foo
+	od -t x1 $SCRATCH_MNT/foo | _filter_od
 
 	# Verify that there are no consistency errors.
 	_check_scratch_fs
diff --git a/tests/btrfs/052.out b/tests/btrfs/052.out
index 53a1868..ac5924e 100644
--- a/tests/btrfs/052.out
+++ b/tests/btrfs/052.out
@@ -1,499 +1,643 @@
 QA output created by 052
 Testing with a cow file (default)
-wrote 8192/8192 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 8192
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 16384
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 24576
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 65536/65536 bytes at offset 32768
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+Blocks modified: [0 - 1]
+Blocks modified: [2 - 3]
+Blocks modified: [4 - 5]
+Blocks modified: [6 - 7]
+Blocks modified: [8 - 23]
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
 clone failed: Invalid argument
-5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
 clone failed: Invalid argument
-5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
-0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0300000
-0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0300000
-0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000
-wrote 8192/8192 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+30
+Blocks modified: [0 - 1]
+0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000
-0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+30
+0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
 Testing with a nocow file (-O nodatacow)
-wrote 8192/8192 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 8192
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 16384
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 24576
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 65536/65536 bytes at offset 32768
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+Blocks modified: [0 - 1]
+Blocks modified: [2 - 3]
+Blocks modified: [4 - 5]
+Blocks modified: [6 - 7]
+Blocks modified: [8 - 23]
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
 clone failed: Invalid argument
-5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
 clone failed: Invalid argument
-5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
-0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0300000
-0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0300000
-0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0300000
-wrote 8192/8192 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+30
+Blocks modified: [0 - 1]
+0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0300000
-0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+30
+0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0300000
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
 Testing with a cow file and lzo compression
-wrote 8192/8192 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 8192
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 16384
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 24576
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 65536/65536 bytes at offset 32768
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+Blocks modified: [0 - 1]
+Blocks modified: [2 - 3]
+Blocks modified: [4 - 5]
+Blocks modified: [6 - 7]
+Blocks modified: [8 - 23]
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
 clone failed: Invalid argument
-5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
 clone failed: Invalid argument
-5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
-0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000
-0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000
-0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000
-wrote 8192/8192 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+30
+Blocks modified: [0 - 1]
+0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000
-0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+30
+0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000
+30
 Testing with a cow file and zlib compression
-wrote 8192/8192 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 8192
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 16384
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 24576
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 65536/65536 bytes at offset 32768
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+Blocks modified: [0 - 1]
+Blocks modified: [2 - 3]
+Blocks modified: [4 - 5]
+Blocks modified: [6 - 7]
+Blocks modified: [8 - 23]
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
 clone failed: Invalid argument
-5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
 clone failed: Invalid argument
-5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
-0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0300000
-0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0300000
-0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000
-wrote 8192/8192 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+30
+Blocks modified: [0 - 1]
+0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000
-0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+30
+0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
 Testing with a nocow file and lzo compression
-wrote 8192/8192 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 8192
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 16384
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 24576
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 65536/65536 bytes at offset 32768
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+Blocks modified: [0 - 1]
+Blocks modified: [2 - 3]
+Blocks modified: [4 - 5]
+Blocks modified: [6 - 7]
+Blocks modified: [8 - 23]
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
 clone failed: Invalid argument
-5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
 clone failed: Invalid argument
-5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
-0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0300000
-0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0300000
-0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0300000
-wrote 8192/8192 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+30
+Blocks modified: [0 - 1]
+0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0300000
-0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+30
+0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0300000
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
 Testing with a nocow file and zlib compression
-wrote 8192/8192 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 8192
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 16384
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 24576
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 65536/65536 bytes at offset 32768
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+Blocks modified: [0 - 1]
+Blocks modified: [2 - 3]
+Blocks modified: [4 - 5]
+Blocks modified: [6 - 7]
+Blocks modified: [8 - 23]
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
 clone failed: Invalid argument
-5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
 clone failed: Invalid argument
-5af7a1d6d3757be1e3e911ba5fdf4cbe  SCRATCH_MNT/foo
-0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+0 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+*
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+*
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+*
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+*
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+*
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0040000 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
+4 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000
-0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000
-0000000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+30
+0 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000
-wrote 8192/8192 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+30
+Blocks modified: [0 - 1]
+0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000
-0000000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+30
+0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0020000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+2 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0060000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+6 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0100000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+10 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0200000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+20 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0210000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+21 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0230000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+23 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000
+30
-- 
2.1.0

