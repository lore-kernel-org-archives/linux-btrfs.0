Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32606 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754441AbbDMTXA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 15:23:00 -0400
Received: from pps.filterd (m0004347 [127.0.0.1])
	by m0004347.ppops.net (8.14.5/8.14.5) with SMTP id t3DJLpYV019544
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 12:22:59 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by m0004347.ppops.net with ESMTP id 1trg6m0f4m-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 12:22:59 -0700
Received: from facebook.com (2401:db00:20:702c:face:0:2f:0)	by
 mx-out.facebook.com (10.212.236.87) with ESMTP	id
 7df36ac6e21211e4aed50002c9521c9e-c83f02c0 for <linux-btrfs@vger.kernel.org>;
	Mon, 13 Apr 2015 12:22:57 -0700
From: Chris Mason <clm@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/5] Btrfs: reserve space for block groups
Date: Mon, 13 Apr 2015 12:22:50 -0700
Message-ID: <1428952972-1266934-4-git-send-email-clm@fb.com>
In-Reply-To: <1428952972-1266934-1-git-send-email-clm@fb.com>
References: <1428952972-1266934-1-git-send-email-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

This changes our delayed refs calculations to include the space needed
to write back dirty block groups.

Signed-off-by: Chris Mason <clm@fb.com>
---
 fs/btrfs/extent-tree.c | 12 +++++++++---
 fs/btrfs/transaction.c |  1 +
 fs/btrfs/transaction.h |  1 +
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 75f4bed..ae8db3ba 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2657,7 +2657,8 @@ int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans,
 	struct btrfs_block_rsv *global_rsv;
 	u64 num_heads = trans->transaction->delayed_refs.num_heads_ready;
 	u64 csum_bytes = trans->transaction->delayed_refs.pending_csums;
-	u64 num_bytes;
+	u64 num_dirty_bgs = trans->transaction->num_dirty_bgs;
+	u64 num_bytes, num_dirty_bgs_bytes;
 	int ret = 0;
 
 	num_bytes = btrfs_calc_trans_metadata_size(root, 1);
@@ -2666,17 +2667,21 @@ int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans,
 		num_bytes += (num_heads - 1) * root->nodesize;
 	num_bytes <<= 1;
 	num_bytes += btrfs_csum_bytes_to_leaves(root, csum_bytes) * root->nodesize;
+	num_dirty_bgs_bytes = btrfs_calc_trans_metadata_size(root,
+							     num_dirty_bgs);
 	global_rsv = &root->fs_info->global_block_rsv;
 
 	/*
 	 * If we can't allocate any more chunks lets make sure we have _lots_ of
 	 * wiggle room since running delayed refs can create more delayed refs.
 	 */
-	if (global_rsv->space_info->full)
+	if (global_rsv->space_info->full) {
+		num_dirty_bgs_bytes <<= 1;
 		num_bytes <<= 1;
+	}
 
 	spin_lock(&global_rsv->lock);
-	if (global_rsv->reserved <= num_bytes)
+	if (global_rsv->reserved <= num_bytes + num_dirty_bgs_bytes)
 		ret = 1;
 	spin_unlock(&global_rsv->lock);
 	return ret;
@@ -5408,6 +5413,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 		if (list_empty(&cache->dirty_list)) {
 			list_add_tail(&cache->dirty_list,
 				      &trans->transaction->dirty_bgs);
+				trans->transaction->num_dirty_bgs++;
 			btrfs_get_block_group(cache);
 		}
 		spin_unlock(&trans->transaction->dirty_bgs_lock);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8b9eea8..234d606 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -251,6 +251,7 @@ loop:
 	INIT_LIST_HEAD(&cur_trans->switch_commits);
 	INIT_LIST_HEAD(&cur_trans->pending_ordered);
 	INIT_LIST_HEAD(&cur_trans->dirty_bgs);
+	cur_trans->num_dirty_bgs = 0;
 	spin_lock_init(&cur_trans->dirty_bgs_lock);
 	list_add_tail(&cur_trans->list, &fs_info->trans_list);
 	extent_io_tree_init(&cur_trans->dirty_pages,
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 96b189b..4cb0ae2 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -64,6 +64,7 @@ struct btrfs_transaction {
 	struct list_head pending_ordered;
 	struct list_head switch_commits;
 	struct list_head dirty_bgs;
+	u64 num_dirty_bgs;
 	spinlock_t dirty_bgs_lock;
 	struct btrfs_delayed_ref_root delayed_refs;
 	int aborted;
-- 
1.8.1

