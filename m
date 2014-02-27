Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14393 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbaB0F4e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 00:56:34 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s1R5uVRa006350
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 13:56:32 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] Btrfs: fix wrong lock range and write size in check_can_nocow()
Date: Thu, 27 Feb 2014 13:58:04 +0800
Message-Id: <1393480685-4320-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1393480685-4320-1-git-send-email-miaox@cn.fujitsu.com>
References: <1393480685-4320-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The write range may not be sector-aligned, for example:

       |--------|--------|	<- write range, sector-unaligned, size: 2blocks
  |--------|--------|--------|  <- correct lock range, size: 3blocks

But according to the old code, we used the size of write range to calculate
the lock range directly, not considered the offset, we would get a wrong lock
range:

       |--------|--------|	<- write range, sector-unaligned, size: 2blocks
  |--------|--------|		<- wrong lock range, size: 2blocks

And besides that, the old code also had the same problem when calculating
the real write size. Correct them.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 0165b86..56f8a07 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1397,7 +1397,7 @@ static noinline int check_can_nocow(struct inode *inode, loff_t pos,
 	int ret;
 
 	lockstart = round_down(pos, root->sectorsize);
-	lockend = lockstart + round_up(*write_bytes, root->sectorsize) - 1;
+	lockend = round_up(pos + *write_bytes, root->sectorsize) - 1;
 
 	while (1) {
 		lock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend);
@@ -1420,7 +1420,8 @@ static noinline int check_can_nocow(struct inode *inode, loff_t pos,
 				 EXTENT_DIRTY | EXTENT_DELALLOC |
 				 EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, 0, 0,
 				 NULL, GFP_NOFS);
-		*write_bytes = min_t(size_t, *write_bytes, num_bytes);
+		*write_bytes = min_t(size_t, *write_bytes ,
+				     num_bytes - pos + lockstart);
 	}
 
 	unlock_extent(&BTRFS_I(inode)->io_tree, lockstart, lockend);
-- 
1.8.1.4

