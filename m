Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:38315 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbbK3KRi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 05:17:38 -0500
Received: from localhost
	by e28smtp02.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 30 Nov 2015 15:47:36 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, chandan@mykolab.com
Subject: [PATCH 8/8] Fix btrfs/106 to work on non-4k page sized machines
Date: Mon, 30 Nov 2015 15:47:24 +0530
Message-Id: <1448878644-16503-9-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1448878644-16503-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1448878644-16503-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit makes use of the new _filter_xfs_io_pages_modified filtering
function to print information in terms of page size units rather than file
offset.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/btrfs/106     | 36 ++++++++++++++++++++----------------
 tests/btrfs/106.out | 30 ++++++++++++++++++------------
 2 files changed, 38 insertions(+), 28 deletions(-)

diff --git a/tests/btrfs/106 b/tests/btrfs/106
index 1670453..30c43fa 100755
--- a/tests/btrfs/106
+++ b/tests/btrfs/106
@@ -58,31 +58,35 @@ test_clone_and_read_compressed_extent()
 	_scratch_mkfs >>$seqres.full 2>&1
 	_scratch_mount $mount_opts
 
-	# Create our test file with a single extent of 64Kb that is going to be
-	# compressed no matter which compression algorithm is used (zlib/lzo).
-	$XFS_IO_PROG -f -c "pwrite -S 0xaa 0K 64K" \
-		$SCRATCH_MNT/foo | _filter_xfs_io
+	PAGE_SIZE=$(get_page_size)
+
+	# Create our test file with 16 pages worth of data in a single extent
+	# that is going to be compressed no matter which compression algorithm
+	# is used (zlib/lzo).
+	$XFS_IO_PROG -f -c "pwrite -S 0xaa 0K $((16 * $PAGE_SIZE))" \
+		     $SCRATCH_MNT/foo | _filter_xfs_io_pages_modified
 
 	# Now clone the compressed extent into an adjacent file offset.
-	$CLONER_PROG -s 0 -d $((64 * 1024)) -l $((64 * 1024)) \
+	$CLONER_PROG -s 0 -d $((16 * $PAGE_SIZE)) -l $((16 * $PAGE_SIZE)) \
 		$SCRATCH_MNT/foo $SCRATCH_MNT/foo
 
-	echo "File digest before unmount:"
-	md5sum $SCRATCH_MNT/foo | _filter_scratch
+	echo "File contents before unmount:"
+	od -t x1 $SCRATCH_MNT/foo | _filter_od
 
 	# Remount the fs or clear the page cache to trigger the bug in btrfs.
-	# Because the extent has an uncompressed length that is a multiple of
-	# 16 pages, all the pages belonging to the second range of the file
-	# (64K to 128K), which points to the same extent as the first range
-	# (0K to 64K), had their contents full of zeroes instead of the byte
-	# 0xaa. This was a bug exclusively in the read path of compressed
-	# extents, the correct data was stored on disk, btrfs just failed to
-	# fill in the pages correctly.
+	# Because the extent has an uncompressed length that is a multiple of 16
+	# pages, all the pages belonging to the second range of the file that is
+	# mapped by the page index range [16, 31], which points to the same
+	# extent as the first file range mapped by the page index range [0, 15],
+	# had their contents full of zeroes instead of the byte 0xaa. This was a
+	# bug exclusively in the read path of compressed extents, the correct
+	# data was stored on disk, btrfs just failed to fill in the pages
+	# correctly.
 	_scratch_remount
 
-	echo "File digest after remount:"
+	echo "File contents after remount:"
 	# Must match the digest we got before.
-	md5sum $SCRATCH_MNT/foo | _filter_scratch
+	od -t x1 $SCRATCH_MNT/foo | _filter_od
 }
 
 echo -e "\nTesting with zlib compression..."
diff --git a/tests/btrfs/106.out b/tests/btrfs/106.out
index 692108d..1144a82 100644
--- a/tests/btrfs/106.out
+++ b/tests/btrfs/106.out
@@ -1,17 +1,23 @@
 QA output created by 106
 
 Testing with zlib compression...
-wrote 65536/65536 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-File digest before unmount:
-be68df46e3cf60b559376a35f9fbb05d  SCRATCH_MNT/foo
-File digest after remount:
-be68df46e3cf60b559376a35f9fbb05d  SCRATCH_MNT/foo
+Pages modified: [0 - 15]
+File contents before unmount:
+0 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+40
+File contents after remount:
+0 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+40
 
 Testing with lzo compression...
-wrote 65536/65536 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-File digest before unmount:
-be68df46e3cf60b559376a35f9fbb05d  SCRATCH_MNT/foo
-File digest after remount:
-be68df46e3cf60b559376a35f9fbb05d  SCRATCH_MNT/foo
+Pages modified: [0 - 15]
+File contents before unmount:
+0 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+40
+File contents after remount:
+0 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
+*
+40
-- 
2.1.0

