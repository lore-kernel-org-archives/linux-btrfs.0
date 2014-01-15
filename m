Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51858 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbaAOL7j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 06:59:39 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0FBxTuP003394
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 19:59:29 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] Btrfs: fix wrong block group in trace during the free space allocation
Date: Wed, 15 Jan 2014 20:00:57 +0800
Message-Id: <1389787258-10865-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1389787258-10865-1-git-send-email-miaox@cn.fujitsu.com>
References: <1389787258-10865-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We allocate the free space from the former block group, not the current
one, so should use the former one to output the trace information.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a47efc1..3664cfb 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6345,7 +6345,8 @@ have_block_group:
 				/* we have a block, we're done */
 				spin_unlock(&last_ptr->refill_lock);
 				trace_btrfs_reserve_extent_cluster(root,
-					block_group, search_start, num_bytes);
+						used_block_group,
+						search_start, num_bytes);
 				if (used_block_group != block_group) {
 					btrfs_put_block_group(block_group);
 					block_group = used_block_group;
-- 
1.8.3.1

