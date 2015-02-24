Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6079 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbbBXVhg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 16:37:36 -0500
Received: from pps.filterd (m0044010 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id t1OLZWL2014845
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 13:37:36 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 1srvwfrk49-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 13:37:36 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: throttle transactions based on dirty bgs
Date: Tue, 24 Feb 2015 16:37:33 -0500
Message-ID: <1424813853-26382-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we delete large files that span many block groups we can run short on the
global reserve as we use it to account for space in the csum tree as well as the
extent tree.  If our files span many block groups then we can get into a
situation where we don't have enough room to update all the block groups and we
abort the transaction.  So keep track of the number of dirty block groups and
use that space in seeing if we have enough global reserve.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent-tree.c | 3 +++
 fs/btrfs/transaction.c | 1 +
 fs/btrfs/transaction.h | 1 +
 3 files changed, 5 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 89f1726..b2f7cf4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2632,6 +2632,7 @@ int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_block_rsv *global_rsv;
 	u64 num_heads = trans->transaction->delayed_refs.num_heads_ready;
+	u64 num_dirty_bgs = trans->transaction->num_dirty_bgs;
 	u64 num_bytes;
 	int ret = 0;
 
@@ -2640,6 +2641,7 @@ int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans,
 	if (num_heads > 1)
 		num_bytes += (num_heads - 1) * root->nodesize;
 	num_bytes <<= 1;
+	num_bytes += btrfs_calc_trans_metadata_size(root, num_dirty_bgs);
 	global_rsv = &root->fs_info->global_block_rsv;
 
 	/*
@@ -5365,6 +5367,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			if (list_empty(&cache->dirty_list)) {
 				list_add_tail(&cache->dirty_list,
 					      &trans->transaction->dirty_bgs);
+				trans->transaction->num_dirty_bgs++;
 				btrfs_get_block_group(cache);
 			}
 			spin_unlock(&trans->transaction->dirty_bgs_lock);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e0faf80..822a26e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -249,6 +249,7 @@ loop:
 	INIT_LIST_HEAD(&cur_trans->switch_commits);
 	INIT_LIST_HEAD(&cur_trans->pending_ordered);
 	INIT_LIST_HEAD(&cur_trans->dirty_bgs);
+	cur_trans->num_dirty_bgs = 0;
 	spin_lock_init(&cur_trans->dirty_bgs_lock);
 	list_add_tail(&cur_trans->list, &fs_info->trans_list);
 	extent_io_tree_init(&cur_trans->dirty_pages,
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 3305451..8ac29f0 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -59,6 +59,7 @@ struct btrfs_transaction {
 	struct list_head pending_ordered;
 	struct list_head switch_commits;
 	struct list_head dirty_bgs;
+	u64 num_dirty_bgs;
 	spinlock_t dirty_bgs_lock;
 	struct btrfs_delayed_ref_root delayed_refs;
 	int aborted;
-- 
1.8.3.1

