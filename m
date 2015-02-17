Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:59153 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbbBQPql (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Feb 2015 10:46:41 -0500
Received: from /spool/local
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 18 Feb 2015 01:46:39 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH] generic/325: Fix test case to work on 64K page size.
Date: Tue, 17 Feb 2015 21:15:28 +0530
Message-Id: <1424187928-28487-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The test case passes 32K as the offset value to msync. This fails on machines
with 64K page size. Fix this by creating a larger file and passing offset
values which are multiples of 64K.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/generic/325     | 10 +++++-----
 tests/generic/325.out | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tests/generic/325 b/tests/generic/325
index c47e372..e62ac95 100755
--- a/tests/generic/325
+++ b/tests/generic/325
@@ -64,7 +64,7 @@ _init_flakey
 _mount_flakey
 
 # Create the file first.
-$XFS_IO_PROG -f -c "pwrite -S 0xff 0 64K" $SCRATCH_MNT/foo | _filter_xfs_io
+$XFS_IO_PROG -f -c "pwrite -S 0xff 0 256K" $SCRATCH_MNT/foo | _filter_xfs_io
 
 # Now sync the file data to disk using 'sync' and not an fsync. This is because
 # in btrfs the first fsync clears the btrfs inode full fsync flag, which must
@@ -80,11 +80,11 @@ sync
 # This second msync() used to be a no-op for that btrfs bug (and the first fsync
 # didn't log the last 4Kb extent as expected too).
 $XFS_IO_PROG \
-	-c "mmap -w 0 64K"         \
+	-c "mmap -w 0 256K"         \
 	-c "mwrite -S 0xaa 0 4K"   \
-	-c "mwrite -S 0xbb 60K 4K" \
-	-c "msync -s 0K 16K"       \
-	-c "msync -s 32K 32K"      \
+	-c "mwrite -S 0xbb 252K 4K" \
+	-c "msync -s 0K 64K"       \
+	-c "msync -s 192K 64K"      \
 	-c "munmap"                \
 	$SCRATCH_MNT/foo | _filter_xfs_io
 
diff --git a/tests/generic/325.out b/tests/generic/325.out
index 9a78c3e..9373e01 100644
--- a/tests/generic/325.out
+++ b/tests/generic/325.out
@@ -1,19 +1,19 @@
 QA output created by 325
-wrote 65536/65536 bytes at offset 0
+wrote 262144/262144 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 File content before crash/reboot:
 0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
 *
 0010000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0170000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
+0770000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
 *
-0200000
+1000000
 File content after crash/reboot and fs mount:
 0000000 aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa aa
 *
 0010000 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 *
-0170000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
+0770000 bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb
 *
-0200000
+1000000
-- 
2.1.0

