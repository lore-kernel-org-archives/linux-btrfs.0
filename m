Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:42530 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab2IMRBV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Sep 2012 13:01:21 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id ohi0fv9PFPARCXp5 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2012 11:01:20 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: delay block group item insertion V2
Date: Thu, 13 Sep 2012 13:06:45 -0400
Message-ID: <1347556005-1966-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So we have lots of places where we try to preallocate chunks in order to
make sure we have enough space as we make our allocations.  This has
historically meant that we're constantly tweaking when we should allocate a
new chunk, and historically we have gotten this horribly wrong so we way
over allocate either metadata or data.  To try and keep this from happening
we are going to make it so that the block group item insertion is done out
of band at the end of a transaction.  This will allow us to create chunks
even if we are trying to make an allocation for the extent tree.  With this
patch my enospc tests run faster (didn't expect this) and more efficiently
use the disk space (this is what I wanted).  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: fix deadlock when inserting block groups from run_delayed_refs

 fs/btrfs/ctree.h       |    5 ++
 fs/btrfs/extent-tree.c |  127 +++++++++++++++++++++++-------------------------
 fs/btrfs/transaction.c |   10 ++++
 fs/btrfs/transaction.h |    1 +
 4 files changed, 76 insertions(+), 67 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 305002b..d66dc1c 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1137,6 +1137,9 @@ struct btrfs_block_group_cache {
 	 * Today it will only have one thing on it, but that may change
 	 */
 	struct list_head cluster_list;
+
+	/* For delayed block group creation */
+	struct list_head new_bg_list;
 };
 
 /* delayed seq elem */
@@ -2865,6 +2868,8 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 			   u64 size);
 int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root, u64 group_start);
+void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
+				       struct btrfs_root *root);
 u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags);
 u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data);
 void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a8de1c3..124f3a0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2361,10 +2361,6 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
 		}
 
 next:
-		do_chunk_alloc(trans, fs_info->extent_root,
-			       2 * 1024 * 1024,
-			       btrfs_get_alloc_profile(root, 0),
-			       CHUNK_ALLOC_NO_FORCE);
 		cond_resched();
 		spin_lock(&delayed_refs->lock);
 	}
@@ -2478,10 +2474,6 @@ int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 	if (root == root->fs_info->extent_root)
 		root = root->fs_info->tree_root;
 
-	do_chunk_alloc(trans, root->fs_info->extent_root,
-		       2 * 1024 * 1024, btrfs_get_alloc_profile(root, 0),
-		       CHUNK_ALLOC_NO_FORCE);
-
 	btrfs_delayed_refs_qgroup_accounting(trans, root->fs_info);
 
 	delayed_refs = &trans->transaction->delayed_refs;
@@ -2551,6 +2543,12 @@ again:
 	}
 
 	if (run_all) {
+		if (!list_empty(&trans->new_bgs)) {
+			spin_unlock(&delayed_refs->lock);
+			btrfs_create_pending_block_groups(trans, root);
+			spin_lock(&delayed_refs->lock);
+		}
+
 		node = rb_first(&delayed_refs->root);
 		if (!node)
 			goto out;
@@ -3826,7 +3824,8 @@ enum flush_state {
 	FLUSH_DELALLOC_WAIT	=	2,
 	FLUSH_DELAYED_ITEMS_NR	=	3,
 	FLUSH_DELAYED_ITEMS	=	4,
-	COMMIT_TRANS		=	5,
+	ALLOC_CHUNK		=	5,
+	COMMIT_TRANS		=	6,
 };
 
 static int flush_space(struct btrfs_root *root,
@@ -3863,6 +3862,20 @@ static int flush_space(struct btrfs_root *root,
 		ret = btrfs_run_delayed_items_nr(trans, root, nr);
 		btrfs_end_transaction(trans, root);
 		break;
+	case ALLOC_CHUNK:
+		trans = btrfs_join_transaction(root);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			break;
+		}
+		ret = do_chunk_alloc(trans, root->fs_info->extent_root,
+				     num_bytes,
+				     btrfs_get_alloc_profile(root, 0),
+				     CHUNK_ALLOC_NO_FORCE);
+		btrfs_end_transaction(trans, root);
+		if (ret == -ENOSPC)
+			ret = 0;
+		break;
 	case COMMIT_TRANS:
 		ret = may_commit_transaction(root, space_info, orig_bytes, 0);
 		break;
@@ -5515,8 +5528,6 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_block_group_cache *used_block_group;
 	u64 search_start = 0;
 	int empty_cluster = 2 * 1024 * 1024;
-	int allowed_chunk_alloc = 0;
-	int done_chunk_alloc = 0;
 	struct btrfs_space_info *space_info;
 	int loop = 0;
 	int index = 0;
@@ -5548,9 +5559,6 @@ static noinline int find_free_extent(struct btrfs_trans_handle *trans,
 	if (btrfs_mixed_space_info(space_info))
 		use_cluster = false;
 
-	if (orig_root->ref_cows || empty_size)
-		allowed_chunk_alloc = 1;
-
 	if (data & BTRFS_BLOCK_GROUP_METADATA && use_cluster) {
 		last_ptr = &root->fs_info->meta_alloc_cluster;
 		if (!btrfs_test_opt(root, SSD))
@@ -5860,34 +5868,18 @@ loop:
 		index = 0;
 		loop++;
 		if (loop == LOOP_ALLOC_CHUNK) {
-		       if (allowed_chunk_alloc) {
-				ret = do_chunk_alloc(trans, root, num_bytes +
-						     2 * 1024 * 1024, data,
-						     CHUNK_ALLOC_LIMITED);
-				/*
-				 * Do not bail out on ENOSPC since we
-				 * can do more things.
-				 */
-				if (ret < 0 && ret != -ENOSPC) {
-					btrfs_abort_transaction(trans,
-								root, ret);
-					goto out;
-				}
-				allowed_chunk_alloc = 0;
-				if (ret == 1)
-					done_chunk_alloc = 1;
-			} else if (!done_chunk_alloc &&
-				   space_info->force_alloc ==
-				   CHUNK_ALLOC_NO_FORCE) {
-				space_info->force_alloc = CHUNK_ALLOC_LIMITED;
+			ret = do_chunk_alloc(trans, root, num_bytes +
+					     2 * 1024 * 1024, data,
+					     CHUNK_ALLOC_FORCE);
+			/*
+			 * Do not bail out on ENOSPC since we
+			 * can do more things.
+			 */
+			if (ret < 0 && ret != -ENOSPC) {
+				btrfs_abort_transaction(trans,
+							root, ret);
+				goto out;
 			}
-
-		       /*
-			* We didn't allocate a chunk, go ahead and drop the
-			* empty size and loop again.
-			*/
-		       if (!done_chunk_alloc)
-			       loop = LOOP_NO_EMPTY_SIZE;
 		}
 
 		if (loop == LOOP_NO_EMPTY_SIZE) {
@@ -5962,20 +5954,6 @@ int btrfs_reserve_extent(struct btrfs_trans_handle *trans,
 
 	data = btrfs_get_alloc_profile(root, data);
 again:
-	/*
-	 * the only place that sets empty_size is btrfs_realloc_node, which
-	 * is not called recursively on allocations
-	 */
-	if (empty_size || root->ref_cows) {
-		ret = do_chunk_alloc(trans, root->fs_info->extent_root,
-				     num_bytes + 2 * 1024 * 1024, data,
-				     CHUNK_ALLOC_NO_FORCE);
-		if (ret < 0 && ret != -ENOSPC) {
-			btrfs_abort_transaction(trans, root, ret);
-			return ret;
-		}
-	}
-
 	WARN_ON(num_bytes < root->sectorsize);
 	ret = find_free_extent(trans, root, num_bytes, empty_size,
 			       hint_byte, ins, data);
@@ -5985,12 +5963,6 @@ again:
 			num_bytes = num_bytes >> 1;
 			num_bytes = num_bytes & ~(root->sectorsize - 1);
 			num_bytes = max(num_bytes, min_alloc_size);
-			ret = do_chunk_alloc(trans, root->fs_info->extent_root,
-				       num_bytes, data, CHUNK_ALLOC_FORCE);
-			if (ret < 0 && ret != -ENOSPC) {
-				btrfs_abort_transaction(trans, root, ret);
-				return ret;
-			}
 			if (num_bytes == min_alloc_size)
 				final_tried = true;
 			goto again;
@@ -7828,6 +7800,31 @@ error:
 	return ret;
 }
 
+void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
+				       struct btrfs_root *root)
+{
+	struct btrfs_block_group_cache *block_group, *tmp;
+	struct btrfs_root *extent_root = root->fs_info->extent_root;
+	struct btrfs_block_group_item item;
+	struct btrfs_key key;
+	int ret;
+
+	list_for_each_entry_safe(block_group, tmp, &trans->new_bgs,
+				 new_bg_list) {
+		list_del_init(&block_group->new_bg_list);
+
+		spin_lock(&block_group->lock);
+		memcpy(&item, &block_group->item, sizeof(item));
+		memcpy(&key, &block_group->key, sizeof(key));
+		spin_unlock(&block_group->lock);
+
+		ret = btrfs_insert_item(trans, extent_root, &key, &item,
+					sizeof(item));
+		if (ret)
+			btrfs_abort_transaction(trans, extent_root, ret);
+	}
+}
+
 int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, u64 bytes_used,
 			   u64 type, u64 chunk_objectid, u64 chunk_offset,
@@ -7861,6 +7858,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	spin_lock_init(&cache->lock);
 	INIT_LIST_HEAD(&cache->list);
 	INIT_LIST_HEAD(&cache->cluster_list);
+	INIT_LIST_HEAD(&cache->new_bg_list);
 
 	btrfs_init_free_space_ctl(cache);
 
@@ -7892,12 +7890,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 	ret = btrfs_add_block_group_cache(root->fs_info, cache);
 	BUG_ON(ret); /* Logic error */
 
-	ret = btrfs_insert_item(trans, extent_root, &cache->key, &cache->item,
-				sizeof(cache->item));
-	if (ret) {
-		btrfs_abort_transaction(trans, extent_root, ret);
-		return ret;
-	}
+	list_add_tail(&cache->new_bg_list, &trans->new_bgs);
 
 	set_avail_alloc_bits(extent_root->fs_info, type);
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 0629edf..c01dec7 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -374,6 +374,7 @@ again:
 	h->qgroup_reserved = qgroup_reserved;
 	h->delayed_ref_elem.seq = 0;
 	INIT_LIST_HEAD(&h->qgroup_ref_list);
+	INIT_LIST_HEAD(&h->new_bgs);
 
 	smp_mb();
 	if (cur_trans->blocked && may_wait_transaction(root, type)) {
@@ -549,6 +550,9 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		trans->qgroup_reserved = 0;
 	}
 
+	if (!list_empty(&trans->new_bgs))
+		btrfs_create_pending_block_groups(trans, root);
+
 	while (count < 2) {
 		unsigned long cur = trans->delayed_ref_updates;
 		trans->delayed_ref_updates = 0;
@@ -564,6 +568,9 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	btrfs_trans_release_metadata(trans, root);
 	trans->block_rsv = NULL;
 
+	if (!list_empty(&trans->new_bgs))
+		btrfs_create_pending_block_groups(trans, root);
+
 	if (lock && !atomic_read(&root->fs_info->open_ioctl_trans) &&
 	    should_end_transaction(trans, root)) {
 		trans->transaction->blocked = 1;
@@ -1400,6 +1407,9 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	 */
 	cur_trans->delayed_refs.flushing = 1;
 
+	if (!list_empty(&trans->new_bgs))
+		btrfs_create_pending_block_groups(trans, root);
+
 	ret = btrfs_run_delayed_refs(trans, root, 0);
 	if (ret)
 		goto cleanup_transaction;
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 1b05480..b6463e1 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -68,6 +68,7 @@ struct btrfs_trans_handle {
 	struct btrfs_root *root;
 	struct seq_list delayed_ref_elem;
 	struct list_head qgroup_ref_list;
+	struct list_head new_bgs;
 };
 
 struct btrfs_pending_snapshot {
-- 
1.7.7.6

