Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36496 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678AbbKYLEx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 06:04:53 -0500
Received: from localhost
	by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 25 Nov 2015 21:04:51 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, chandan@mykolab.com
Subject: [PATCH 05/12] Fix btrfs/056 to work on non-4k block sized filesystems
Date: Wed, 25 Nov 2015 16:32:59 +0530
Message-Id: <1448449386-4186-6-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1448449386-4186-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1448449386-4186-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit makes use of the new _filter_xfs_io_blocks_modified and _filter_od
filtering functions to print information in terms of file blocks rather than
file offset.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/btrfs/056     |  51 ++++++++++--------
 tests/btrfs/056.out | 152 +++++++++++++++++++++-------------------------------
 2 files changed, 90 insertions(+), 113 deletions(-)

diff --git a/tests/btrfs/056 b/tests/btrfs/056
index 66a59b8..6dc3bfd 100755
--- a/tests/btrfs/056
+++ b/tests/btrfs/056
@@ -68,33 +68,42 @@ test_btrfs_clone_fsync_log_recover()
 	MOUNT_OPTIONS="$MOUNT_OPTIONS $2"
 	_mount_flakey
 
-	# Create a file with 4 extents and 1 hole, all with a size of 8Kb each.
-	# The hole is in the range [16384, 24576[.
-	$XFS_IO_PROG -s -f -c "pwrite -S 0x01 -b 8192 0 8192" \
-			-c "pwrite -S 0x02 -b 8192 8192 8192" \
-			-c "pwrite -S 0x04 -b 8192 24576 8192" \
-			-c "pwrite -S 0x05 -b 8192 32768 8192" \
-		$SCRATCH_MNT/foo | _filter_xfs_io
-
-	# Clone destination file, 1 extent of 96kb.
-	$XFS_IO_PROG -f -c "pwrite -S 0xff -b 98304 0 98304" -c "fsync" \
-		$SCRATCH_MNT/bar | _filter_xfs_io
-
-	# Clone second half of the 2nd extent, the 8kb hole, the 3rd extent
+	BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+
+	EXTENT_SIZE=$((2 * $BLOCK_SIZE))
+
+	# Create a file with 4 extents and 1 hole, all with a size of
+	# 2 blocks each.
+	# The hole is in the block range [4, 5].
+	$XFS_IO_PROG -s -f -c "pwrite -S 0x01 -b $EXTENT_SIZE 0 $EXTENT_SIZE" \
+			-c "pwrite -S 0x02 -b $EXTENT_SIZE $((2 * $BLOCK_SIZE)) $EXTENT_SIZE" \
+			-c "pwrite -S 0x04 -b $EXTENT_SIZE $((6 * $BLOCK_SIZE)) $EXTENT_SIZE" \
+			-c "pwrite -S 0x05 -b $EXTENT_SIZE $((8 * $BLOCK_SIZE)) $EXTENT_SIZE" \
+		$SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
+
+	# Clone destination file, 1 extent of 24 blocks.
+	$XFS_IO_PROG -f -c "pwrite -S 0xff -b $((24 * $BLOCK_SIZE)) 0 $((24 * $BLOCK_SIZE))" \
+		     -c "fsync" $SCRATCH_MNT/bar | _filter_xfs_io_blocks_modified
+
+	# Clone second half of the 2nd extent, the 2 block hole, the 3rd extent
 	# and the first half of the 4th extent into file bar.
-	$CLONER_PROG -s 12288 -d 0 -l 24576 $SCRATCH_MNT/foo $SCRATCH_MNT/bar
+	$CLONER_PROG -s $((3 * $BLOCK_SIZE)) -d 0 -l $((6 * $BLOCK_SIZE)) \
+		     $SCRATCH_MNT/foo $SCRATCH_MNT/bar
 	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar
 
 	# Test small files too consisting of 1 inline extent
-	$XFS_IO_PROG -f -c "pwrite -S 0x00 -b 3500 0 3500" -c "fsync" \
-		$SCRATCH_MNT/foo2 | _filter_xfs_io
+	EXTENT_SIZE=$(($BLOCK_SIZE - 48))
+	$XFS_IO_PROG -f -c "pwrite -S 0x00 -b $EXTENT_SIZE 0 $EXTENT_SIZE" -c "fsync" \
+		$SCRATCH_MNT/foo2 | _filter_xfs_io_blocks_modified
 
-	$XFS_IO_PROG -f -c "pwrite -S 0xcc -b 1000 0 1000" -c "fsync" \
-		$SCRATCH_MNT/bar2 | _filter_xfs_io
+	EXTENT_SIZE=$(($BLOCK_SIZE - 1048))
+	$XFS_IO_PROG -f -c "pwrite -S 0xcc -b $EXTENT_SIZE 0 $EXTENT_SIZE" -c "fsync" \
+		$SCRATCH_MNT/bar2 | _filter_xfs_io_blocks_modified
 
 	# Clone the entire foo2 file into bar2, overwriting all data in bar2
 	# and increasing its size.
-	$CLONER_PROG -s 0 -d 0 -l 3500 $SCRATCH_MNT/foo2 $SCRATCH_MNT/bar2
+	EXTENT_SIZE=$(($BLOCK_SIZE - 48))
+	$CLONER_PROG -s 0 -d 0 -l $EXTENT_SIZE $SCRATCH_MNT/foo2 $SCRATCH_MNT/bar2
 	$XFS_IO_PROG -c "fsync" $SCRATCH_MNT/bar2
 
 	_flakey_drop_and_remount yes
@@ -102,10 +111,10 @@ test_btrfs_clone_fsync_log_recover()
 	# Verify the cloned range was persisted by fsync and the log recovery
 	# code did its work well.
 	echo "Verifying file bar content"
-	od -t x1 $SCRATCH_MNT/bar
+	od -t x1 $SCRATCH_MNT/bar | _filter_od
 
 	echo "Verifying file bar2 content"
-	od -t x1 $SCRATCH_MNT/bar2
+	od -t x1 $SCRATCH_MNT/bar2 | _filter_od
 
 	_unmount_flakey
 
diff --git a/tests/btrfs/056.out b/tests/btrfs/056.out
index 1b77ae3..c4c6b2c 100644
--- a/tests/btrfs/056.out
+++ b/tests/btrfs/056.out
@@ -1,129 +1,97 @@
 QA output created by 056
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
-wrote 3500/3500 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 1000/1000 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Blocks modified: [0 - 1]
+Blocks modified: [2 - 3]
+Blocks modified: [6 - 7]
+Blocks modified: [8 - 9]
+Blocks modified: [0 - 23]
+Blocks modified: [0 - 0]
+Blocks modified: [0 - 0]
 Verifying file bar content
-0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+0 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0010000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+1 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0030000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+3 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0050000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+5 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+6 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0300000
+30
 Verifying file bar2 content
-0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0006640 00 00 00 00 00 00 00 00 00 00 00 00
-0006654
+0
 Testing without the NO_HOLES feature and compression (lzo)
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
-wrote 3500/3500 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 1000/1000 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Blocks modified: [0 - 1]
+Blocks modified: [2 - 3]
+Blocks modified: [6 - 7]
+Blocks modified: [8 - 9]
+Blocks modified: [0 - 23]
+Blocks modified: [0 - 0]
+Blocks modified: [0 - 0]
 Verifying file bar content
-0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+0 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0010000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+1 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0030000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+3 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0050000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+5 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+6 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0300000
+30
 Verifying file bar2 content
-0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0006640 00 00 00 00 00 00 00 00 00 00 00 00
-0006654
+0
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
-wrote 3500/3500 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 1000/1000 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Blocks modified: [0 - 1]
+Blocks modified: [2 - 3]
+Blocks modified: [6 - 7]
+Blocks modified: [8 - 9]
+Blocks modified: [0 - 23]
+Blocks modified: [0 - 0]
+Blocks modified: [0 - 0]
 Verifying file bar content
-0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+0 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0010000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+1 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0030000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+3 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0050000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+5 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+6 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0300000
+30
 Verifying file bar2 content
-0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0006640 00 00 00 00 00 00 00 00 00 00 00 00
-0006654
+0
 Testing with the NO_HOLES feature enabled and compression (lzo)
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
-wrote 3500/3500 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 1000/1000 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Blocks modified: [0 - 1]
+Blocks modified: [2 - 3]
+Blocks modified: [6 - 7]
+Blocks modified: [8 - 9]
+Blocks modified: [0 - 23]
+Blocks modified: [0 - 0]
+Blocks modified: [0 - 0]
 Verifying file bar content
-0000000 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
+0 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02
 *
-0010000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+1 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0030000 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
+3 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04 04
 *
-0050000 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
+5 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05 05
 *
-0060000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
+6 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0300000
+30
 Verifying file bar2 content
-0000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
+0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 *
-0006640 00 00 00 00 00 00 00 00 00 00 00 00
-0006654
+0
-- 
2.1.0

