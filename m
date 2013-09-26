Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1691 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab3IZFOj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Sep 2013 01:14:39 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r8Q5EZYB019389
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Sep 2013 13:14:35 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: improve jitter performance of the sequential buffered write
Date: Thu, 26 Sep 2013 13:15:27 +0800
Message-Id: <1380172527-18982-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The performance was slowed down sometimes when we ran sysbench to measure
the performance of the sequential buffered write by 2 or more threads.

It was because the write order of the test threads might be confused
by the task scheduler, and the coming write would be beyond the end of
the file, in this case, we need insert dummy file extents and create
a hole for the area we skip. But in order to avoid the ongoing ordered
extents which are in the area, we need wait for them. Unfortunately,
the current code doesn't check if there are ordered extents in the area
or not, try to find and flush the dirty pages directly, but in fact,
there is no dirty page in that area, this step of the current code is
unnecessary, and just wastes time. Sometimes, it would increase
the contention of some locks, and makes the performance slow down suddenly.

So we remove the ordered extent flush function before the check, and flush
the dirty pages and wait for the ordered extents only when we find them.

According to my test, we got 1-2 times of the performance regression when
we ran the test by 10 times before applying this patch. After applying
this patch, the regression went away.

Test Environment:
 CPU:		1CPU * 4Cores
 Memory:	6GB
 Partition:	20GB

Test Command:
 # sysbench --test=fileio --file-total-size=16G --file-test-mode=seqwr \
 > --num-threads=512 --file-block-size=16384 --max-time=60 --max-requests=0 run

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7d0ef55..ef02866 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4230,15 +4230,16 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 
 	while (1) {
 		struct btrfs_ordered_extent *ordered;
-		btrfs_wait_ordered_range(inode, hole_start,
-					 block_end - hole_start);
+
 		lock_extent_bits(io_tree, hole_start, block_end - 1, 0,
 				 &cached_state);
-		ordered = btrfs_lookup_ordered_extent(inode, hole_start);
+		ordered = btrfs_lookup_ordered_range(inode, hole_start,
+						     block_end - hole_start);
 		if (!ordered)
 			break;
 		unlock_extent_cached(io_tree, hole_start, block_end - 1,
 				     &cached_state, GFP_NOFS);
+		btrfs_start_ordered_extent(inode, ordered, 1);
 		btrfs_put_ordered_extent(ordered);
 	}
 
-- 
1.8.3.1

