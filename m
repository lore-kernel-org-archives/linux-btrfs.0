Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:51952 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab3KDPMm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 10:12:42 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rA4FCVjO031734
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Nov 2013 23:12:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/7] Btrfs: remove unnecessary initialization and memory barrior in shrink_delalloc()
Date: Mon, 4 Nov 2013 23:13:20 +0800
Message-Id: <1383578006-22691-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com>
References: <1383578006-22691-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
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

