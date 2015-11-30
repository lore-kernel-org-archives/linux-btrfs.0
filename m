Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:43533 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbbK3KRt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 05:17:49 -0500
Received: from localhost
	by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 30 Nov 2015 15:47:47 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, chandan@mykolab.com
Subject: [PATCH V2 3/5] Fix btrfs/055 to work on non-4k block sized filesystems
Date: Mon, 30 Nov 2015 15:46:58 +0530
Message-Id: <1448878620-16382-4-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1448878620-16382-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1448878620-16382-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit makes use of the new _filter_xfs_io_blocks_modified and _filter_od
filtering functions to print information in terms of file blocks rather than
file offset.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/btrfs/055     | 128 ++++++++++--------
 tests/btrfs/055.out | 378 +++++++++++++++++++++++++---------------------------
 2 files changed, 259 insertions(+), 247 deletions(-)

diff --git a/tests/btrfs/055 b/tests/btrfs/055
index c0dd9ed..1f50850 100755
--- a/tests/btrfs/055
+++ b/tests/btrfs/055
@@ -60,88 +60,110 @@ test_btrfs_clone_with_holes()
 	_scratch_mkfs "$1" >/dev/null 2>&1
 	_scratch_mount
 
-	# Create a file with 4 extents and 1 hole, all with a size of 8Kb each.
-	# The hole is in the range [16384, 24576[.
-	$XFS_IO_PROG -s -f -c "pwrite -S 0x01 -b 8192 0 8192" \
-			-c "pwrite -S 0x02 -b 8192 8192 8192" \
-			-c "pwrite -S 0x04 -b 8192 24576 8192" \
-			-c "pwrite -S 0x05 -b 8192 32768 8192" \
-		$SCRATCH_MNT/foo | _filter_xfs_io
+	BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
 
-	# Clone destination file, 1 extent of 96kb.
-	$XFS_IO_PROG -s -f -c "pwrite -S 0xff -b 98304 0 98304" \
-		$SCRATCH_MNT/bar | _filter_xfs_io
+	EXTENT_SIZE=$((2 * $BLOCK_SIZE))
 
-	# Clone 2nd extent, 8Kb hole and 3rd extent of foo into bar.
-	$CLONER_PROG -s 8192 -d 0 -l 24576 $SCRATCH_MNT/foo $SCRATCH_MNT/bar
+	OFFSET=0
+
+	# Create a file with 4 extents and 1 hole, all with 2 blocks each.
+	# The hole is in the block range [4, 5[.
+	$XFS_IO_PROG -s -f -c "pwrite -S 0x01 -b $EXTENT_SIZE $OFFSET $EXTENT_SIZE" \
+		     $SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
+
+	OFFSET=$(($OFFSET + $EXTENT_SIZE))
+	$XFS_IO_PROG -s -f -c "pwrite -S 0x02 -b $EXTENT_SIZE $OFFSET $EXTENT_SIZE" \
+		     $SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
+
+	OFFSET=$(($OFFSET + 2 * $EXTENT_SIZE))
+	$XFS_IO_PROG -s -f -c "pwrite -S 0x04 -b $EXTENT_SIZE $OFFSET $EXTENT_SIZE" \
+		     $SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
+
+	OFFSET=$(($OFFSET + $EXTENT_SIZE))
+	$XFS_IO_PROG -s -f -c "pwrite -S 0x05 -b $EXTENT_SIZE $OFFSET $EXTENT_SIZE" \
+		     $SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
+
+	# Clone destination file, 1 extent of 24 blocks.
+	EXTENT_SIZE=$((24 * $BLOCK_SIZE))
+	$XFS_IO_PROG -s -f -c "pwrite -S 0xff -b $EXTENT_SIZE 0 $EXTENT_SIZE" \
+		$SCRATCH_MNT/bar | _filter_xfs_io_blocks_modified
+
+	# Clone 2nd extent, 2-blocks sized hole and 3rd extent of foo into bar.
+	$CLONER_PROG -s $((2 * $BLOCK_SIZE)) -d 0 -l $((6 * $BLOCK_SIZE)) \
+		     $SCRATCH_MNT/foo $SCRATCH_MNT/bar
 
 	# Verify both extents and the hole were cloned.
 	echo "1) Check both extents and the hole were cloned"
-	od -t x1 $SCRATCH_MNT/bar
+	od -t x1 $SCRATCH_MNT/bar | _filter_od
 
-	# Cloning range starts at the middle of an hole.
-	$CLONER_PROG -s 20480 -d 32768 -l 12288 $SCRATCH_MNT/foo \
-		$SCRATCH_MNT/bar
+	# Cloning range starts at the middle of a hole.
+	$CLONER_PROG -s $((5 * $BLOCK_SIZE)) -d $((8 * $BLOCK_SIZE)) \
+		     -l $((3 * $BLOCK_SIZE)) $SCRATCH_MNT/foo $SCRATCH_MNT/bar
 
-	# Verify that half of the hole and the following 8Kb extent were cloned.
-	echo "2) Check half hole and one 8Kb extent were cloned"
-	od -t x1 $SCRATCH_MNT/bar
+	# Verify that half of the hole and the following 2 block extent were cloned.
+	echo "2) Check half hole and the following 2 block extent were cloned"
+	od -t x1 $SCRATCH_MNT/bar | _filter_od
 
-	# Cloning range ends at the middle of an hole.
-	$CLONER_PROG -s 0 -d 65536 -l 20480 $SCRATCH_MNT/foo $SCRATCH_MNT/bar
+	# Cloning range ends at the middle of a hole.
+	$CLONER_PROG -s 0 -d $((16 * $BLOCK_SIZE)) -l $((5 * $BLOCK_SIZE)) \
+		     $SCRATCH_MNT/foo $SCRATCH_MNT/bar
 
-	# Verify that 2 extents of 8kb and a 4kb hole were cloned.
-	echo "3) Check that 2 extents of 8kb eacg and a 4kb hole were cloned"
-	od -t x1 $SCRATCH_MNT/bar
+	# Verify that 2 extents of 2 blocks size and a 1-block hole were cloned.
+	echo "3) Check that 2 extents of 2 blocks each and a hole of 1 block were cloned"
+	od -t x1 $SCRATCH_MNT/bar | _filter_od
 
-	# Create a 24Kb hole at the end of the source file (foo).
-	$XFS_IO_PROG -c "truncate 65536" $SCRATCH_MNT/foo
+	# Create a 6-block hole at the end of the source file (foo).
+	$XFS_IO_PROG -c "truncate $((16 * $BLOCK_SIZE))" $SCRATCH_MNT/foo \
+		| _filter_xfs_io_blocks_modified
 	sync
 
 	# Now clone a range that overlaps that hole at the end of the foo file.
-	# It should clone the last 4Kb of the extent at offset 32768 and the
-	# first 8kb of the 24kb hole at the end of foo.
-	$CLONER_PROG -s 36864 -d 86016 -l 12288 $SCRATCH_MNT/foo \
-		$SCRATCH_MNT/bar
+	# It should clone the 10th block and the first two blocks of the hole
+	# at the end of foo.
+	$CLONER_PROG -s $((9 * $BLOCK_SIZE)) -d $((21 * $BLOCK_SIZE)) \
+		     -l $((3 * $BLOCK_SIZE)) $SCRATCH_MNT/foo $SCRATCH_MNT/bar
 
-	# Verify that the second half of the 8Kb extent at offset 32768 of foo
-	# and the first 8Kb of the 24kb hole of foo were cloned into bar.
-	echo "4) Check that 4kb of 1 extent and 8Kb of an hole were cloned"
-	od -t x1 $SCRATCH_MNT/bar
+	# Verify that the 9th block of foo and the first 2 blocks of the
+	# 6-block hole of foo were cloned into bar.
+	echo "4) Check that a block of 1 extent and 2 blocks of a hole were cloned"
+	od -t x1 $SCRATCH_MNT/bar | _filter_od
 
 	# Clone the same range as before, but clone it into a different offset
 	# of the target (bar) such that it increases the size of the target
-	# by 8Kb.
-	$CLONER_PROG -s 36864 -d 94208 -l 12288 $SCRATCH_MNT/foo \
-		$SCRATCH_MNT/bar
+	# by 2 blocks.
+	$CLONER_PROG -s $((9 * $BLOCK_SIZE)) -d $((23 * $BLOCK_SIZE)) \
+		     -l $((3 * $BLOCK_SIZE)) $SCRATCH_MNT/foo $SCRATCH_MNT/bar
 
-	# Verify that the second half of the 8Kb extent at offset 32768 of foo
-	# and the first 8Kb of the 24kb hole of foo were cloned into bar at
-	# bar's offset 94208 and that bar's size increased by 8Kb.
-	echo "5) Check that 4kb of 1 extent and 8Kb of an hole were cloned and file size increased"
-	od -t x1 $SCRATCH_MNT/bar
+	# Verify that the 9th block of foo and the first 2 blocks of the 6-block
+	# hole of foo were cloned into bar at bar's 23rd block and that bar's
+	# size increased by 2 blocks.
+	echo "5) Check that a block of 1 extent and 2 blocks of a hole were" \
+	     "cloned and file size increased"
+	od -t x1 $SCRATCH_MNT/bar | _filter_od
 
 	# Create a new completely sparse file (no extents, it's a big hole).
-	$XFS_IO_PROG -f -c "truncate 100000" $SCRATCH_MNT/qwerty
+	$XFS_IO_PROG -f -c "truncate $((25 * $BLOCK_SIZE))" $SCRATCH_MNT/qwerty \
+		| _filter_xfs_io_blocks_modified
 	sync
 
 	# Test cloning a range from the sparse file to the bar file without
 	# increasing bar's size.
-	$CLONER_PROG -s 4096 -d 0 -l 8192 $SCRATCH_MNT/qwerty $SCRATCH_MNT/bar
+	$CLONER_PROG -s $((1 * $BLOCK_SIZE)) -d 0 -l $((2 * $BLOCK_SIZE)) \
+		     $SCRATCH_MNT/qwerty $SCRATCH_MNT/bar
 
-	# First 8Kb of bar should now be zeroes.
-	echo "6) Check that 8kb of the hole were cloned"
-	od -t x1 $SCRATCH_MNT/bar
+	# First 2 blocks of bar should now be zeroes.
+	echo "6) Check that 2 blocks of the hole were cloned"
+	od -t x1 $SCRATCH_MNT/bar | _filter_od
 
 	# Test cloning a range from the sparse file to the end of the bar file.
-	# The bar file currently has a size of 106496 bytes.
-	$CLONER_PROG -s 0 -d 106496 -l 32768 $SCRATCH_MNT/qwerty \
+	# The bar file currently has 26 blocks.
+	$CLONER_PROG -s 0 -d $((26 * $BLOCK_SIZE)) -l $((8 * $BLOCK_SIZE)) $SCRATCH_MNT/qwerty \
 		$SCRATCH_MNT/bar
 
-	# Verify bar's size increased to 106496 + 32768 bytes (136Kb), and its
-	# last 32768 bytes are all zeroes.
-	echo "7) Check that 32kb of the hole were cloned and the file size increased"
-	od -t x1 $SCRATCH_MNT/bar
+	# Verify bar's size increased to 26 + 8 blocks, and its
+	# last 8 blocks are all zeroes.
+	echo "7) Check that 8 blocks of the hole were cloned and the file size increased"
+	od -t x1 $SCRATCH_MNT/bar | _filter_od
 
 	# Verify that there are no consistency errors.
 	_check_scratch_fs
diff --git a/tests/btrfs/055.out b/tests/btrfs/055.out
index d8d4893..2d29d6f 100644
--- a/tests/btrfs/055.out
+++ b/tests/btrfs/055.out
@@ -1,347 +1,337 @@
 QA output created by 055
 Testing without the NO_HOLES feature
-wrote 8192/8192 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 8192
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 24576
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 32768
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 98304/98304 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Blocks modified: [0 - 1]
+Blocks modified: [2 - 3]
+Blocks modified: [6 - 7]
+Blocks modified: [8 - 9]
+Blocks modified: [0 - 23]
 1) Check both extents and the hole were cloned
-0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+0 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+2 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+4 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+6 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0300000
-2) Check half hole and one 8Kb extent were cloned
-0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+30
+2) Check half hole and the following 2 block extent were cloned
+0 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+2 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+4 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+6 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+11 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+13 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0300000
-3) Check that 2 extents of 8kb eacg and a 4kb hole were cloned
-0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+30
+3) Check that 2 extents of 2 blocks each and a hole of 1 block were cloned
+0 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+2 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+4 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+6 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+11 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+13 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+20 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
 *
-0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+22 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+24 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0250000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+25 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0300000
-4) Check that 4kb of 1 extent and 8Kb of an hole were cloned
-0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+30
+4) Check that a block of 1 extent and 2 blocks of a hole were cloned
+0 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+2 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+4 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+6 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+11 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+13 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+20 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
 *
-0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+22 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+24 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0250000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+25 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0260000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0300000
-5) Check that 4kb of 1 extent and 8Kb of an hole were cloned and file size increased
-0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+30
+5) Check that a block of 1 extent and 2 blocks of a hole were cloned and file size increased
+0 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+2 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+4 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+6 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+11 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+13 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+20 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
 *
-0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+22 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+24 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0250000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+25 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0260000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0270000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+27 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0320000
-6) Check that 8kb of the hole were cloned
-0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+32
+6) Check that 2 blocks of the hole were cloned
+0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+4 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+6 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+11 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+13 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+20 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
 *
-0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+22 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+24 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0250000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+25 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0260000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0270000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+27 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0320000
-7) Check that 32kb of the hole were cloned and the file size increased
-0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+32
+7) Check that 8 blocks of the hole were cloned and the file size increased
+0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+4 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+6 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+11 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+13 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+20 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
 *
-0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+22 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+24 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0250000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+25 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0260000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0270000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+27 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0420000
+42
 Testing with the NO_HOLES feature enabled
-wrote 8192/8192 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 8192
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 24576
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 32768
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 98304/98304 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Blocks modified: [0 - 1]
+Blocks modified: [2 - 3]
+Blocks modified: [6 - 7]
+Blocks modified: [8 - 9]
+Blocks modified: [0 - 23]
 1) Check both extents and the hole were cloned
-0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+0 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+2 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+4 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+6 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0300000
-2) Check half hole and one 8Kb extent were cloned
-0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+30
+2) Check half hole and the following 2 block extent were cloned
+0 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+2 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+4 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+6 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+11 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+13 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0300000
-3) Check that 2 extents of 8kb eacg and a 4kb hole were cloned
-0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+30
+3) Check that 2 extents of 2 blocks each and a hole of 1 block were cloned
+0 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+2 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+4 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+6 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+11 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+13 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+20 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
 *
-0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+22 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+24 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0250000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+25 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0300000
-4) Check that 4kb of 1 extent and 8Kb of an hole were cloned
-0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+30
+4) Check that a block of 1 extent and 2 blocks of a hole were cloned
+0 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+2 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+4 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+6 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+11 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+13 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+20 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
 *
-0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+22 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+24 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0250000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+25 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0260000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0300000
-5) Check that 4kb of 1 extent and 8Kb of an hole were cloned and file size increased
-0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+30
+5) Check that a block of 1 extent and 2 blocks of a hole were cloned and file size increased
+0 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0020000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+2 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+4 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+6 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+11 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+13 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+20 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
 *
-0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+22 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+24 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0250000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+25 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0260000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0270000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+27 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0320000
-6) Check that 8kb of the hole were cloned
-0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+32
+6) Check that 2 blocks of the hole were cloned
+0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+4 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+6 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+11 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+13 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+20 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
 *
-0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+22 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+24 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0250000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+25 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0260000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0270000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+27 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0320000
-7) Check that 32kb of the hole were cloned and the file size increased
-0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+32
+7) Check that 8 blocks of the hole were cloned and the file size increased
+0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0040000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+4 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+6 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0100000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0110000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+11 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0130000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+13 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0200000 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
+20 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01
 *
-0220000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+22 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0240000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+24 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0250000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+25 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0260000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+26 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0270000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+27 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0300000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+30 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0420000
+42
-- 
2.1.0

