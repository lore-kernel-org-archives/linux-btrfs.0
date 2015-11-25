Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:47693 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbbKYLFN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 06:05:13 -0500
Received: from localhost
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 25 Nov 2015 21:05:11 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, chandan@mykolab.com
Subject: [PATCH 11/12] Fix btrfs/103 to work on non-4k block sized filesystems
Date: Wed, 25 Nov 2015 16:33:05 +0530
Message-Id: <1448449386-4186-12-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1448449386-4186-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1448449386-4186-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit makes use of the new _filter_xfs_io_blocks_modified filtering
function to print information in terms of file blocks rather than file
offset.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/btrfs/103     | 47 +++++++++++++++++++++++++++++------------------
 tests/btrfs/103.out | 48 ++++++++++++------------------------------------
 2 files changed, 41 insertions(+), 54 deletions(-)

diff --git a/tests/btrfs/103 b/tests/btrfs/103
index 3020c86..a807900 100755
--- a/tests/btrfs/103
+++ b/tests/btrfs/103
@@ -56,31 +56,34 @@ test_clone_and_read_compressed_extent()
 	_scratch_mkfs >>$seqres.full 2>&1
 	_scratch_mount $mount_opts
 
+	BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+
 	# Create a test file with a single extent that is compressed (the
 	# data we write into it is highly compressible no matter which
 	# compression algorithm is used, zlib or lzo).
-	$XFS_IO_PROG -f -c "pwrite -S 0xaa 0K 4K"        \
-			-c "pwrite -S 0xbb 4K 8K"        \
-			-c "pwrite -S 0xcc 12K 4K"       \
-			$SCRATCH_MNT/foo | _filter_xfs_io
+	$XFS_IO_PROG -f -c "pwrite -S 0xaa 0K $((1 * $BLOCK_SIZE))" \
+		-c "pwrite -S 0xbb $((1 * $BLOCK_SIZE)) $((2 * $BLOCK_SIZE))" \
+		-c "pwrite -S 0xcc $((3 * $BLOCK_SIZE)) $((1 * $BLOCK_SIZE))" \
+		$SCRATCH_MNT/foo | _filter_xfs_io_blocks_modified
+
 
 	# Now clone our extent into an adjacent offset.
-	$CLONER_PROG -s $((4 * 1024)) -d $((16 * 1024)) -l $((8 * 1024)) \
-		$SCRATCH_MNT/foo $SCRATCH_MNT/foo
+	$CLONER_PROG -s $((1 * $BLOCK_SIZE)) -d $((4 * $BLOCK_SIZE)) \
+		     -l $((2 * $BLOCK_SIZE)) $SCRATCH_MNT/foo $SCRATCH_MNT/foo
 
 	# Same as before but for this file we clone the extent into a lower
 	# file offset.
-	$XFS_IO_PROG -f -c "pwrite -S 0xaa 8K 4K"         \
-			-c "pwrite -S 0xbb 12K 8K"        \
-			-c "pwrite -S 0xcc 20K 4K"        \
-			$SCRATCH_MNT/bar | _filter_xfs_io
+	$XFS_IO_PROG -f \
+		-c "pwrite -S 0xaa $((2 * $BLOCK_SIZE)) $((1 * $BLOCK_SIZE))" \
+		-c "pwrite -S 0xbb $((3 * $BLOCK_SIZE)) $((2 * $BLOCK_SIZE))" \
+		-c "pwrite -S 0xcc $((5 * $BLOCK_SIZE)) $((1 * $BLOCK_SIZE))" \
+		$SCRATCH_MNT/bar | _filter_xfs_io_blocks_modified
 
-	$CLONER_PROG -s $((12 * 1024)) -d 0 -l $((8 * 1024)) \
+	$CLONER_PROG -s $((3 * $BLOCK_SIZE)) -d 0 -l $((2 * $BLOCK_SIZE)) \
 		$SCRATCH_MNT/bar $SCRATCH_MNT/bar
 
-	echo "File digests before unmounting filesystem:"
-	md5sum $SCRATCH_MNT/foo | _filter_scratch
-	md5sum $SCRATCH_MNT/bar | _filter_scratch
+	foo_orig_hash=$(md5sum $SCRATCH_MNT/foo | cut -f 1 -d ' ')
+	bar_orig_hash=$(md5sum $SCRATCH_MNT/bar | cut -f 1 -d ' ')
 
 	# Evicting the inode or clearing the page cache before reading again
 	# the file would also trigger the bug - reads were returning all bytes
@@ -91,10 +94,18 @@ test_clone_and_read_compressed_extent()
 	# ranges that point to the same compressed extent.
 	_scratch_remount
 
-	echo "File digests after mounting filesystem again:"
-	# Must match the same digests we got before.
-	md5sum $SCRATCH_MNT/foo | _filter_scratch
-	md5sum $SCRATCH_MNT/bar | _filter_scratch
+	foo_hash=$(md5sum $SCRATCH_MNT/foo | cut -f 1 -d ' ')
+	bar_hash=$(md5sum $SCRATCH_MNT/bar | cut -f 1 -d ' ')
+
+	if [ $foo_orig_hash != $foo_hash ]; then
+		echo "Read operation failed on $SCRATCH_MNT/foo: "\
+		     "Mimatching hash values detected."
+	fi
+
+	if [ $bar_orig_hash != $bar_hash ]; then
+		echo "Read operation failed on $SCRATCH_MNT/bar: "\
+		     "Mimatching hash values detected."
+	fi
 }
 
 echo -e "\nTesting with zlib compression..."
diff --git a/tests/btrfs/103.out b/tests/btrfs/103.out
index f62de2f..964b70f 100644
--- a/tests/btrfs/103.out
+++ b/tests/btrfs/103.out
@@ -1,41 +1,17 @@
 QA output created by 103
 
 Testing with zlib compression...
-wrote 4096/4096 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 4096
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 4096/4096 bytes at offset 12288
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 4096/4096 bytes at offset 8192
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 12288
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 4096/4096 bytes at offset 20480
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-File digests before unmounting filesystem:
-4b985a45790261a706c3ddbf22c5f765  SCRATCH_MNT/foo
-fd331e6b7a9ab105f48f71b53162d5b5  SCRATCH_MNT/bar
-File digests after mounting filesystem again:
-4b985a45790261a706c3ddbf22c5f765  SCRATCH_MNT/foo
-fd331e6b7a9ab105f48f71b53162d5b5  SCRATCH_MNT/bar
+Blocks modified: [0 - 0]
+Blocks modified: [1 - 2]
+Blocks modified: [3 - 3]
+Blocks modified: [2 - 2]
+Blocks modified: [3 - 4]
+Blocks modified: [5 - 5]
 
 Testing with lzo compression...
-wrote 4096/4096 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 4096
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 4096/4096 bytes at offset 12288
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 4096/4096 bytes at offset 8192
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 8192/8192 bytes at offset 12288
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-wrote 4096/4096 bytes at offset 20480
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-File digests before unmounting filesystem:
-4b985a45790261a706c3ddbf22c5f765  SCRATCH_MNT/foo
-fd331e6b7a9ab105f48f71b53162d5b5  SCRATCH_MNT/bar
-File digests after mounting filesystem again:
-4b985a45790261a706c3ddbf22c5f765  SCRATCH_MNT/foo
-fd331e6b7a9ab105f48f71b53162d5b5  SCRATCH_MNT/bar
+Blocks modified: [0 - 0]
+Blocks modified: [1 - 2]
+Blocks modified: [3 - 3]
+Blocks modified: [2 - 2]
+Blocks modified: [3 - 4]
+Blocks modified: [5 - 5]
-- 
2.1.0

