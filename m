Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:6647 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750802Ab3KFF2t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 00:28:49 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA65Slc7015702
	for <linux-btrfs@vger.kernel.org>; Wed, 6 Nov 2013 13:28:47 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 1/7] Btrfs: remove unnecessary initialization and memory barrior in shrink_delalloc()
Date: Wed, 6 Nov 2013 13:29:49 +0800
Message-Id: <1383715789-4081-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <20131105114516.GG16662@twin.jikos.cz>
References: <20131105114516.GG16662@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

- The variant nr_pages is assigned before we use it, so the initialization
  at the beginning is unnecessary.
- If we enter the branch of the first if statement, the initialization of
  the variant loops is also unnecessary.
- The memory barriers here are misused, the barrier is used to prevent the
  problems that we may get unexpected value that is caused by the random
  order of the independent memory operations. But here, though the memory
  operations before and after the barrier are independent, we are sure that
  all the variants we access before the memory barrier can not be changed,
  so even though the operations are reordered, it is safe and the memory
  barriers are unnecessary.

So we remove those statements.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- Add the explanation why we remove those statements in the changelog.
---
 fs/btrfs/extent-tree.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1d238ed..abe65ed 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4016,15 +4016,14 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 	u64 delalloc_bytes;
 	u64 max_reclaim;
 	long time_left;
-	unsigned long nr_pages = (2 * 1024 * 1024) >> PAGE_CACHE_SHIFT;
-	int loops = 0;
+	unsigned long nr_pages;
+	int loops;
 	enum btrfs_reserve_flush_enum flush;
 
 	trans = (struct btrfs_trans_handle *)current->journal_info;
 	block_rsv = &root->fs_info->delalloc_block_rsv;
 	space_info = block_rsv->space_info;
 
-	smp_mb();
 	delalloc_bytes = percpu_counter_sum_positive(
 						&root->fs_info->delalloc_bytes);
 	if (delalloc_bytes == 0) {
@@ -4034,6 +4033,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 		return;
 	}
 
+	loops = 0;
 	while (delalloc_bytes && loops < 3) {
 		max_reclaim = min(delalloc_bytes, to_reclaim);
 		nr_pages = max_reclaim >> PAGE_CACHE_SHIFT;
@@ -4064,7 +4064,6 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 			if (time_left)
 				break;
 		}
-		smp_mb();
 		delalloc_bytes = percpu_counter_sum_positive(
 						&root->fs_info->delalloc_bytes);
 	}
-- 
1.8.1.4

