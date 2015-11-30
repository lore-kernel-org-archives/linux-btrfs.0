Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:42234 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbbK3KRV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 05:17:21 -0500
Received: from localhost
	by e28smtp03.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 30 Nov 2015 15:47:19 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, chandan@mykolab.com
Subject: [PATCH V2 2/5] Fix btrfs/017 to work on non-4k block sized filesystems
Date: Mon, 30 Nov 2015 15:46:57 +0530
Message-Id: <1448878620-16382-3-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1448878620-16382-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1448878620-16382-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This commit makes use of the new _filter_xfs_io_blocks_modified filtering
function to print information in terms of file blocks rather than file
offset.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/btrfs/017     | 16 ++++++++++++----
 tests/btrfs/017.out |  3 +--
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/tests/btrfs/017 b/tests/btrfs/017
index f8855e3..34c5f0a 100755
--- a/tests/btrfs/017
+++ b/tests/btrfs/017
@@ -63,13 +63,21 @@ rm -f $seqres.full
 _scratch_mkfs "--nodesize 65536" >>$seqres.full 2>&1
 _scratch_mount
 
-$XFS_IO_PROG -f -d -c "pwrite 0 8K" $SCRATCH_MNT/foo | _filter_xfs_io
+BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+EXTENT_SIZE=$((2 * $BLOCK_SIZE))
+
+$XFS_IO_PROG -f -d -c "pwrite 0 $EXTENT_SIZE" $SCRATCH_MNT/foo \
+	| _filter_xfs_io_blocks_modified
 
 _run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap
 
-$CLONER_PROG -s 0 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/foo-reflink
-$CLONER_PROG -s 0 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/snap/foo-reflink
-$CLONER_PROG -s 0 -d 0 -l 8192 $SCRATCH_MNT/foo $SCRATCH_MNT/snap/foo-reflink2
+$CLONER_PROG -s 0 -d 0 -l $EXTENT_SIZE $SCRATCH_MNT/foo $SCRATCH_MNT/foo-reflink
+
+$CLONER_PROG -s 0 -d 0 -l $EXTENT_SIZE $SCRATCH_MNT/foo \
+	     $SCRATCH_MNT/snap/foo-reflink
+
+$CLONER_PROG -s 0 -d 0 -l $EXTENT_SIZE $SCRATCH_MNT/foo \
+	     $SCRATCH_MNT/snap/foo-reflink2
 
 _run_btrfs_util_prog quota enable $SCRATCH_MNT
 _run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
diff --git a/tests/btrfs/017.out b/tests/btrfs/017.out
index f940f3a..503eb88 100644
--- a/tests/btrfs/017.out
+++ b/tests/btrfs/017.out
@@ -1,5 +1,4 @@
 QA output created by 017
-wrote 8192/8192 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+Blocks modified: [0 - 1]
 65536 65536
 65536 65536
-- 
2.1.0

