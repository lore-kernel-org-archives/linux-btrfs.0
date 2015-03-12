Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51282 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbbCLFk5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Mar 2015 01:40:57 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] Revert "Btrfs: allow superblock mismatch from older mkfs"
Date: Thu, 12 Mar 2015 13:40:47 +0800
Message-Id: <1426138847-10851-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit 667e7d94a1683661cff5fe9a0fa0d7f8fdd2c007.

This was used to make sure that a fresh btrfs from an older mkfs.btrfs,
and it also allows us to mount a buggy btrfs if this btrfs has the right
superblock head part but has something wrong with chunk tree part[1], and
after that we can hit BUG_ON()s set in the code to prevent something
impossible.

Since David has gave us "Btrfs progs v3.19-rc2", just remove the check,
if anyone who wants to make a fresh btrfs, please use the latest one.

[1]: http://www.spinics.net/lists/linux-btrfs/msg42358.html

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Conflicts:
	fs/btrfs/disk-io.c
---
 fs/btrfs/disk-io.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 41b320e..f63aacf 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -418,12 +418,6 @@ static int btrfs_check_super_csum(char *raw_disk_sb)
 
 		if (memcmp(raw_disk_sb, result, csum_size))
 			ret = 1;
-
-		if (ret && btrfs_super_generation(disk_sb) < 10) {
-			printk(KERN_WARNING
-				"BTRFS: super block crcs don't match, older mkfs detected\n");
-			ret = 0;
-		}
 	}
 
 	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
-- 
1.8.1.4

