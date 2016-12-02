Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45074 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752118AbcLBFHu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Dec 2016 00:07:50 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2F52DABD3
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Dec 2016 05:07:49 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 10/18] btrfs: root->fs_info cleanup, btrfs_calc_{trans,trunc}_metadata_size
Date: Fri,  2 Dec 2016 00:07:30 -0500
Message-Id: <1480655258-15400-11-git-send-email-jeffm@suse.com>
In-Reply-To: <1480655258-15400-1-git-send-email-jeffm@suse.com>
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h            |  8 ++++----
 fs/btrfs/delayed-inode.c    |  4 ++--
 fs/btrfs/extent-tree.c      | 35 +++++++++++++++++++----------------
 fs/btrfs/file.c             |  4 ++--
 fs/btrfs/free-space-cache.c |  4 ++--
 fs/btrfs/inode-map.c        |  3 ++-
 fs/btrfs/inode.c            |  4 ++--
 fs/btrfs/props.c            |  2 +-
 fs/btrfs/transaction.c      |  5 +++--
 9 files changed, 37 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 6a5c007..19b6bb2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2535,20 +2535,20 @@ static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
 
 u64 btrfs_csum_bytes_to_leaves(struct btrfs_root *root, u64 csum_bytes);
 
-static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_root *root,
+static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_fs_info *fs_info,
 						 unsigned num_items)
 {
-	return root->fs_info->nodesize * BTRFS_MAX_LEVEL * 2 * num_items;
+	return fs_info->nodesize * BTRFS_MAX_LEVEL * 2 * num_items;
 }
 
 /*
  * Doing a truncate won't result in new nodes or leaves, just what we need for
  * COW.
  */
-static inline u64 btrfs_calc_trunc_metadata_size(struct btrfs_root *root,
+static inline u64 btrfs_calc_trunc_metadata_size(struct btrfs_fs_info *fs_info,
 						 unsigned num_items)
 {
-	return root->fs_info->nodesize * BTRFS_MAX_LEVEL * num_items;
+	return fs_info->nodesize * BTRFS_MAX_LEVEL * num_items;
 }
 
 int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index d90d444..d4e0781 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -549,7 +549,7 @@ static int btrfs_delayed_item_reserve_metadata(struct btrfs_trans_handle *trans,
 	src_rsv = trans->block_rsv;
 	dst_rsv = &root->fs_info->delayed_block_rsv;
 
-	num_bytes = btrfs_calc_trans_metadata_size(root, 1);
+	num_bytes = btrfs_calc_trans_metadata_size(root->fs_info, 1);
 	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
 	if (!ret) {
 		trace_btrfs_space_reservation(root->fs_info, "delayed_item",
@@ -592,7 +592,7 @@ static int btrfs_delayed_inode_reserve_metadata(
 	src_rsv = trans->block_rsv;
 	dst_rsv = &root->fs_info->delayed_block_rsv;
 
-	num_bytes = btrfs_calc_trans_metadata_size(root, 1);
+	num_bytes = btrfs_calc_trans_metadata_size(root->fs_info, 1);
 
 	/*
 	 * If our block_rsv is the delalloc block reserve then check and see if
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 127a54b..b8ad81c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2791,13 +2791,13 @@ int btrfs_check_space_for_delayed_refs(struct btrfs_trans_handle *trans,
 	u64 num_bytes, num_dirty_bgs_bytes;
 	int ret = 0;
 
-	num_bytes = btrfs_calc_trans_metadata_size(root, 1);
+	num_bytes = btrfs_calc_trans_metadata_size(root->fs_info, 1);
 	num_heads = heads_to_leaves(root, num_heads);
 	if (num_heads > 1)
 		num_bytes += (num_heads - 1) * root->fs_info->nodesize;
 	num_bytes <<= 1;
 	num_bytes += btrfs_csum_bytes_to_leaves(root, csum_bytes) * root->fs_info->nodesize;
-	num_dirty_bgs_bytes = btrfs_calc_trans_metadata_size(root,
+	num_dirty_bgs_bytes = btrfs_calc_trans_metadata_size(root->fs_info,
 							     num_dirty_bgs);
 	global_rsv = &root->fs_info->global_block_rsv;
 
@@ -4440,8 +4440,8 @@ void check_system_chunk(struct btrfs_trans_handle *trans,
 	num_devs = get_profile_num_devs(root, type);
 
 	/* num_devs device items to update and 1 chunk item to add or remove */
-	thresh = btrfs_calc_trunc_metadata_size(root, num_devs) +
-		btrfs_calc_trans_metadata_size(root, 1);
+	thresh = btrfs_calc_trunc_metadata_size(root->fs_info, num_devs) +
+		btrfs_calc_trans_metadata_size(root->fs_info, 1);
 
 	if (left < thresh && btrfs_test_opt(root->fs_info, ENOSPC_DEBUG)) {
 		btrfs_info(root->fs_info, "left=%llu, need=%llu, flags=%llu",
@@ -4695,7 +4695,7 @@ static inline int calc_reclaim_items_nr(struct btrfs_root *root, u64 to_reclaim)
 	u64 bytes;
 	int nr;
 
-	bytes = btrfs_calc_trans_metadata_size(root, 1);
+	bytes = btrfs_calc_trans_metadata_size(root->fs_info, 1);
 	nr = (int)div64_u64(to_reclaim, bytes);
 	if (!nr)
 		nr = 1;
@@ -5770,7 +5770,7 @@ int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
 	 * added it, so this takes the reservation so we can release it later
 	 * when we are truly done with the orphan item.
 	 */
-	u64 num_bytes = btrfs_calc_trans_metadata_size(root, 1);
+	u64 num_bytes = btrfs_calc_trans_metadata_size(root->fs_info, 1);
 	trace_btrfs_space_reservation(root->fs_info, "orphan",
 				      btrfs_ino(inode), num_bytes, 1);
 	return btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
@@ -5779,7 +5779,7 @@ int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
 void btrfs_orphan_release_metadata(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	u64 num_bytes = btrfs_calc_trans_metadata_size(root, 1);
+	u64 num_bytes = btrfs_calc_trans_metadata_size(root->fs_info, 1);
 	trace_btrfs_space_reservation(root->fs_info, "orphan",
 				      btrfs_ino(inode), num_bytes, 0);
 	btrfs_block_rsv_release(root, root->orphan_block_rsv, num_bytes);
@@ -5821,7 +5821,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 
 	*qgroup_reserved = num_bytes;
 
-	num_bytes = btrfs_calc_trans_metadata_size(root, items);
+	num_bytes = btrfs_calc_trans_metadata_size(root->fs_info, items);
 	rsv->space_info = __find_space_info(root->fs_info,
 					    BTRFS_BLOCK_GROUP_METADATA);
 	ret = btrfs_block_rsv_add(root, rsv, num_bytes,
@@ -5925,10 +5925,11 @@ static u64 calc_csum_metadata_size(struct inode *inode, u64 num_bytes,
 		return 0;
 
 	if (reserve)
-		return btrfs_calc_trans_metadata_size(root,
+		return btrfs_calc_trans_metadata_size(root->fs_info,
 						      num_csums - old_csums);
 
-	return btrfs_calc_trans_metadata_size(root, old_csums - num_csums);
+	return btrfs_calc_trans_metadata_size(root->fs_info,
+					      old_csums - num_csums);
 }
 
 int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
@@ -5982,7 +5983,8 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 			BTRFS_I(inode)->reserved_extents;
 
 	/* We always want to reserve a slot for updating the inode. */
-	to_reserve = btrfs_calc_trans_metadata_size(root, nr_extents + 1);
+	to_reserve = btrfs_calc_trans_metadata_size(root->fs_info,
+						    nr_extents + 1);
 	to_reserve += calc_csum_metadata_size(inode, num_bytes, 1);
 	csum_bytes = BTRFS_I(inode)->csum_bytes;
 	spin_unlock(&BTRFS_I(inode)->lock);
@@ -6004,7 +6006,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	spin_lock(&BTRFS_I(inode)->lock);
 	if (test_and_set_bit(BTRFS_INODE_DELALLOC_META_RESERVED,
 			     &BTRFS_I(inode)->runtime_flags)) {
-		to_reserve -= btrfs_calc_trans_metadata_size(root, 1);
+		to_reserve -= btrfs_calc_trans_metadata_size(root->fs_info, 1);
 		release_extra = true;
 	}
 	BTRFS_I(inode)->reserved_extents += nr_extents;
@@ -6018,8 +6020,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 					      btrfs_ino(inode), to_reserve, 1);
 	if (release_extra)
 		btrfs_block_rsv_release(root, block_rsv,
-					btrfs_calc_trans_metadata_size(root,
-								       1));
+			btrfs_calc_trans_metadata_size(root->fs_info, 1));
 	return 0;
 
 out_fail:
@@ -6074,7 +6075,8 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	}
 	spin_unlock(&BTRFS_I(inode)->lock);
 	if (dropped)
-		to_free += btrfs_calc_trans_metadata_size(root, dropped);
+		to_free += btrfs_calc_trans_metadata_size(root->fs_info,
+							  dropped);
 
 	if (to_free) {
 		btrfs_block_rsv_release(root, block_rsv, to_free);
@@ -6109,7 +6111,8 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 		to_free = calc_csum_metadata_size(inode, num_bytes, 0);
 	spin_unlock(&BTRFS_I(inode)->lock);
 	if (dropped > 0)
-		to_free += btrfs_calc_trans_metadata_size(root, dropped);
+		to_free += btrfs_calc_trans_metadata_size(root->fs_info,
+							  dropped);
 
 	if (btrfs_is_testing(root->fs_info))
 		return;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 1e0af55..008670e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2369,7 +2369,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	u64 tail_len;
 	u64 orig_start = offset;
 	u64 cur_offset;
-	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
+	u64 min_size = btrfs_calc_trunc_metadata_size(root->fs_info, 1);
 	u64 drop_end;
 	int ret = 0;
 	int err = 0;
@@ -2516,7 +2516,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		ret = -ENOMEM;
 		goto out_free;
 	}
-	rsv->size = btrfs_calc_trunc_metadata_size(root, 1);
+	rsv->size = btrfs_calc_trunc_metadata_size(root->fs_info, 1);
 	rsv->failfast = 1;
 
 	/*
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 2d71654..aee1255 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -210,8 +210,8 @@ int btrfs_check_trunc_cache_free_space(struct btrfs_root *root,
 	int ret;
 
 	/* 1 for slack space, 1 for updating the inode */
-	needed_bytes = btrfs_calc_trunc_metadata_size(root, 1) +
-		btrfs_calc_trans_metadata_size(root, 1);
+	needed_bytes = btrfs_calc_trunc_metadata_size(root->fs_info, 1) +
+		btrfs_calc_trans_metadata_size(root->fs_info, 1);
 
 	spin_lock(&rsv->lock);
 	if (rsv->reserved < needed_bytes)
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index d27014b..0c49267 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -433,7 +433,8 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	 * 1 item for free space object
 	 * 3 items for pre-allocation
 	 */
-	trans->bytes_reserved = btrfs_calc_trans_metadata_size(root, 10);
+	trans->bytes_reserved = btrfs_calc_trans_metadata_size(root->fs_info,
+							       10);
 	ret = btrfs_block_rsv_add(root, trans->block_rsv,
 				  trans->bytes_reserved,
 				  BTRFS_RESERVE_NO_FLUSH);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9d2dbdb..d0a236f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5217,7 +5217,7 @@ void btrfs_evict_inode(struct inode *inode)
 		return;
 	}
 
-	min_size = btrfs_calc_trunc_metadata_size(root, 1);
+	min_size = btrfs_calc_trunc_metadata_size(root->fs_info, 1);
 
 	evict_inode_truncate_pages(inode);
 
@@ -9073,7 +9073,7 @@ static int btrfs_truncate(struct inode *inode)
 	int err = 0;
 	struct btrfs_trans_handle *trans;
 	u64 mask = root->fs_info->sectorsize - 1;
-	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
+	u64 min_size = btrfs_calc_trunc_metadata_size(root->fs_info, 1);
 
 	ret = btrfs_wait_ordered_range(inode, inode->i_size & (~mask),
 				       (u64)-1);
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index cf0b444..f4a5876 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -320,7 +320,7 @@ static int inherit_props(struct btrfs_trans_handle *trans,
 		if (!value)
 			continue;
 
-		num_bytes = btrfs_calc_trans_metadata_size(root, 1);
+		num_bytes = btrfs_calc_trans_metadata_size(root->fs_info, 1);
 		ret = btrfs_block_rsv_add(root, trans->block_rsv,
 					  num_bytes, BTRFS_RESERVE_NO_FLUSH);
 		if (ret)
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index b8aaf1c..bec5aa0 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -502,7 +502,8 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 		if (ret)
 			return ERR_PTR(ret);
 
-		num_bytes = btrfs_calc_trans_metadata_size(root, num_items);
+		num_bytes = btrfs_calc_trans_metadata_size(root->fs_info,
+							   num_items);
 		/*
 		 * Do the reservation for the relocation root creation
 		 */
@@ -624,7 +625,7 @@ struct btrfs_trans_handle *btrfs_start_transaction_fallback_global_rsv(
 	if (IS_ERR(trans))
 		return trans;
 
-	num_bytes = btrfs_calc_trans_metadata_size(root, num_items);
+	num_bytes = btrfs_calc_trans_metadata_size(root->fs_info, num_items);
 	ret = btrfs_cond_migrate_bytes(root->fs_info,
 				       &root->fs_info->trans_block_rsv,
 				       num_bytes,
-- 
2.7.1

