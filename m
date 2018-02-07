Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56380 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754490AbeBGP4F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Feb 2018 10:56:05 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0F817ADD2
        for <linux-btrfs@vger.kernel.org>; Wed,  7 Feb 2018 15:56:04 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 04/14] btrfs: Remove fs_info argument from btrfs_create_pending_block_groups
Date: Wed,  7 Feb 2018 17:55:40 +0200
Message-Id: <1518018950-31456-5-git-send-email-nborisov@suse.com>
In-Reply-To: <1518018950-31456-1-git-send-email-nborisov@suse.com>
References: <1518018950-31456-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from the passed transaciton so no point in
passing it as function argument. No functional changes

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       |  3 +--
 fs/btrfs/extent-tree.c | 10 +++++-----
 fs/btrfs/transaction.c |  6 +++---
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1cc77c4bf3c3..9963b6caadeb 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2712,8 +2712,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info);
 void btrfs_get_block_group_trimming(struct btrfs_block_group_cache *cache);
 void btrfs_put_block_group_trimming(struct btrfs_block_group_cache *cache);
-void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
-				       struct btrfs_fs_info *fs_info);
+void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans);
 u64 btrfs_data_alloc_profile(struct btrfs_fs_info *fs_info);
 u64 btrfs_metadata_alloc_profile(struct btrfs_fs_info *fs_info);
 u64 btrfs_system_alloc_profile(struct btrfs_fs_info *fs_info);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b079ebc1f842..99bfc628ab89 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3086,7 +3086,7 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 
 	if (run_all) {
 		if (!list_empty(&trans->new_bgs))
-			btrfs_create_pending_block_groups(trans, fs_info);
+			btrfs_create_pending_block_groups(trans);
 
 		spin_lock(&delayed_refs->lock);
 		node = rb_first(&delayed_refs->href_root);
@@ -3686,7 +3686,7 @@ int btrfs_start_dirty_block_groups(struct btrfs_trans_handle *trans,
 	 * make sure all the block groups on our dirty list actually
 	 * exist
 	 */
-	btrfs_create_pending_block_groups(trans, fs_info);
+	btrfs_create_pending_block_groups(trans);
 
 	if (!path) {
 		path = btrfs_alloc_path();
@@ -4706,7 +4706,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	 */
 	if (trans->can_flush_pending_bgs &&
 	    trans->chunk_bytes_reserved >= (u64)SZ_2M) {
-		btrfs_create_pending_block_groups(trans, fs_info);
+		btrfs_create_pending_block_groups(trans);
 		btrfs_trans_release_chunk_metadata(trans);
 	}
 	return ret;
@@ -10130,9 +10130,9 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 	return ret;
 }
 
-void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
-				       struct btrfs_fs_info *fs_info)
+void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_block_group_cache *block_group, *tmp;
 	struct btrfs_root *extent_root = fs_info->extent_root;
 	struct btrfs_block_group_item item;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 3c3ed6e3d484..82b7e5855119 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -860,7 +860,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	trans->block_rsv = NULL;
 
 	if (!list_empty(&trans->new_bgs))
-		btrfs_create_pending_block_groups(trans, info);
+		btrfs_create_pending_block_groups(trans);
 
 	trans->delayed_ref_updates = 0;
 	if (!trans->sync) {
@@ -881,7 +881,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	trans->block_rsv = NULL;
 
 	if (!list_empty(&trans->new_bgs))
-		btrfs_create_pending_block_groups(trans, info);
+		btrfs_create_pending_block_groups(trans);
 
 	btrfs_trans_release_chunk_metadata(trans);
 
@@ -1983,7 +1983,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	smp_wmb();
 
 	if (!list_empty(&trans->new_bgs))
-		btrfs_create_pending_block_groups(trans, fs_info);
+		btrfs_create_pending_block_groups(trans);
 
 	ret = btrfs_run_delayed_refs(trans, fs_info, 0);
 	if (ret) {
-- 
2.7.4

