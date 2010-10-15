From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 4/4] Btrfs: rework how we reserve metadata bytes
Date: Fri, 15 Oct 2010 17:28:35 -0400
Message-ID: <1287178115-18229-5-git-send-email-josef@redhat.com>
References: <1287178115-18229-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1287178115-18229-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

With multi-threaded writes we were getting ENOSPC early because somebody would
come in, start flushing delalloc because they couldn't make their reservation,
and in the meantime other threads would come in and use the space that was
getting freed up, so when the original thread went to check to see if they had
space they didn't and they'd return ENOSPC.  So instead if we have some free
space but not enough for our reservation, take the reservation and then start
doing the flushing.  The only time we don't take reservations is when we've
already overcommitted our space, that way we don't have people who come late to
the party way overcommitting ourselves.  This also moves all of the retrying and
flushing code into reserve_metdata_bytes so it's all uniform.  This keeps my
fs_mark test from returning -ENOSPC as soon as it starts and actually lets me
fill up the disk.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h       |    4 +-
 fs/btrfs/extent-tree.c |  230 ++++++++++++++++++++++++++++++++----------------
 fs/btrfs/relocation.c  |   14 +---
 fs/btrfs/transaction.c |    7 +-
 4 files changed, 160 insertions(+), 95 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 72f5e1a..9e923c1 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2144,7 +2144,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes);
 void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes);
 int btrfs_trans_reserve_metadata(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root,
-				int num_items, int *retries);
+				int num_items);
 void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
 				struct btrfs_root *root);
 int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
@@ -2165,7 +2165,7 @@ void btrfs_add_durable_block_rsv(struct btrfs_fs_info *fs_info,
 int btrfs_block_rsv_add(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
 			struct btrfs_block_rsv *block_rsv,
-			u64 num_bytes, int *retries);
+			u64 num_bytes);
 int btrfs_block_rsv_check(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root,
 			  struct btrfs_block_rsv *block_rsv,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 265d8e0..13f723a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3400,79 +3400,162 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
 	return reclaimed >= to_reclaim;
 }
 
-static int should_retry_reserve(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
-				struct btrfs_block_rsv *block_rsv,
-				u64 num_bytes, int *retries)
+/*
+ * Retries tells us how many times we've called reserve_metadata_bytes.  The
+ * idea is if this is the first call (retries == 0) then we will add to our
+ * reserved count if we can't make the allocation in order to hold our place
+ * while we go and try and free up space.  That way for retries > 1 we don't try
+ * and add space, we just check to see if the amount of unused space is >= the
+ * total space, meaning that our reservation is valid.
+ *
+ * However if we don't intend to retry this reservation, pass -1 as retries so
+ * that it short circuits this logic.
+ */
+static int reserve_metadata_bytes(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *root,
+				  struct btrfs_block_rsv *block_rsv,
+				  u64 orig_bytes)
 {
 	struct btrfs_space_info *space_info = block_rsv->space_info;
-	int ret;
-
-	if ((*retries) > 2)
-		return -ENOSPC;
+	u64 unused;
+	u64 num_bytes = orig_bytes;
+	int retries = 0;
+	int ret = 0;
+	bool reserved = false;
 
-	ret = maybe_allocate_chunk(trans, root, space_info, num_bytes);
-	if (ret)
-		return 1;
+again:
+	ret = -ENOSPC;
+	if (reserved)
+		num_bytes = 0;
 
-	if (trans && trans->transaction->in_commit)
-		return -ENOSPC;
+	spin_lock(&space_info->lock);
+	unused = space_info->bytes_used + space_info->bytes_reserved +
+		 space_info->bytes_pinned + space_info->bytes_readonly +
+		 space_info->bytes_may_use;
 
-	ret = shrink_delalloc(trans, root, num_bytes, 0);
-	if (ret)
-		return ret;
+	/*
+	 * The idea here is that we've not already over-reserved the block group
+	 * then we can go ahead and save our reservation first and then start
+	 * flushing if we need to.  Otherwise if we've already overcommitted
+	 * lets start flushing stuff first and then come back and try to make
+	 * our reservation.
+	 */
+	if (unused <= space_info->total_bytes) {
+		unused -= space_info->total_bytes;
+		if (unused >= num_bytes) {
+			if (!reserved)
+				space_info->bytes_reserved += orig_bytes;
+			reserved = true;
+			ret = 0;
+		} else if (!reserved) {
+			/*
+			 * Don't have enough space, reserve what we need and try
+			 * to flush.
+			 */
+			space_info->bytes_reserved += orig_bytes;
+			reserved = true;
+		}
+	} else {
+		/*
+		 * Ok we're over committed, set num_bytes to some huge number so
+		 * that the flushing stuff will give us plenty of slack space.
+		 */
+		num_bytes = orig_bytes * 2;
+	}
 
-	spin_lock(&space_info->lock);
-	if (space_info->bytes_pinned < num_bytes)
-		ret = 1;
 	spin_unlock(&space_info->lock);
-	if (ret)
-		return -ENOSPC;
 
-	(*retries)++;
+	if (!ret)
+		return 0;
 
-	if (trans)
-		return -EAGAIN;
+	/* We haven't retried yet, try and allocate a chunk. */
+	if (retries == 0) {
+		retries++;
+		ret = maybe_allocate_chunk(trans, root, space_info, num_bytes);
+		if (ret) {
+			if (reserved)
+				return 0;
+			goto again;
+		}
+	}
 
-	trans = btrfs_join_transaction(root, 1);
-	BUG_ON(IS_ERR(trans));
-	ret = btrfs_commit_transaction(trans, root);
-	BUG_ON(ret);
+	/*
+	 * So for the first round of retries (retries == 1) we don't want to be
+	 * synchronously writing out inodes.  For retries == 2 we want to do
+	 * sync, and if that still doesn't work out move on.
+	 */
+	if (retries < 3) {
+		/*
+		 * We do this because sometimes we get trans from
+		 * start_trans_handle, which will deal with shrink_delalloc
+		 * returning -EAGAIN.  HOWEVER, there are cases that don't deal
+		 * with -EAGAIN, so we'll get things erroring out that really
+		 * shouldn't have.  So instead just force us to use synchronous
+		 * delalloc flushing if we have a trans to give us the best
+		 * possible chance of actually reclaiming space.
+		 */
+		if (trans)
+			retries = 2;
 
-	return 1;
-}
+		ret = shrink_delalloc(trans, root, num_bytes, retries == 2);
+		if (ret > 0) {
+			/*
+			 * Ok we reclaimed enough space and already reserved,
+			 * we're good to go.
+			 */
+			if (reserved)
+				return 0;
+			/*
+			 * We got enough space but didn't actually reserve
+			 * already, which means we're quite low on space, so try
+			 * and reserve again and if it fails lets just skip to
+			 * doing synchronous writeout.
+			 */
+			retries = 2;
+			goto again;
+		} else if (ret < 0) {
+			goto out;
+		}
 
-static int reserve_metadata_bytes(struct btrfs_block_rsv *block_rsv,
-				  u64 num_bytes)
-{
-	struct btrfs_space_info *space_info = block_rsv->space_info;
-	u64 unused;
-	int ret = -ENOSPC;
+		/*
+		 * Ok shrink_delalloc didn't reclaim enough, but we may not have
+		 * done a synchronous writeout either, so bump retries and try
+		 * again.
+		 */
+		retries++;
+		goto again;
+	}
 
 	spin_lock(&space_info->lock);
-	unused = space_info->bytes_used + space_info->bytes_reserved +
-		 space_info->bytes_pinned + space_info->bytes_readonly +
-		 space_info->bytes_may_use;
+	/*
+	 * Not enough space to be reclaimed, don't bother committing the
+	 * transaction.
+	 */
+	if (space_info->bytes_pinned < orig_bytes)
+		ret = -ENOSPC;
+	spin_unlock(&space_info->lock);
+	if (ret)
+		goto out;
 
-	if (unused < space_info->total_bytes)
-		unused = space_info->total_bytes - unused;
-	else
-		unused = 0;
+	ret = -EAGAIN;
+	if (trans)
+		goto out;
 
-	if (unused >= num_bytes) {
-		if (block_rsv->priority >= 10) {
-			space_info->bytes_reserved += num_bytes;
-			ret = 0;
-		} else {
-			if ((unused + block_rsv->reserved) *
-			    block_rsv->priority >=
-			    (num_bytes + block_rsv->reserved) * 10) {
-				space_info->bytes_reserved += num_bytes;
-				ret = 0;
-			}
-		}
+
+	ret = -ENOSPC;
+	trans = btrfs_join_transaction(root, 1);
+	if (IS_ERR(trans))
+		goto out;
+	ret = btrfs_commit_transaction(trans, root);
+	if (!ret)
+		goto again;
+
+out:
+	if (reserved) {
+		spin_lock(&space_info->lock);
+		space_info->bytes_reserved -= orig_bytes;
+		spin_unlock(&space_info->lock);
 	}
-	spin_unlock(&space_info->lock);
 
 	return ret;
 }
@@ -3616,23 +3699,19 @@ void btrfs_add_durable_block_rsv(struct btrfs_fs_info *fs_info,
 int btrfs_block_rsv_add(struct btrfs_trans_handle *trans,
 			struct btrfs_root *root,
 			struct btrfs_block_rsv *block_rsv,
-			u64 num_bytes, int *retries)
+			u64 num_bytes)
 {
 	int ret;
 
 	if (num_bytes == 0)
 		return 0;
-again:
-	ret = reserve_metadata_bytes(block_rsv, num_bytes);
+
+	ret = reserve_metadata_bytes(trans, root, block_rsv, num_bytes);
 	if (!ret) {
 		block_rsv_add_bytes(block_rsv, num_bytes, 1);
 		return 0;
 	}
 
-	ret = should_retry_reserve(trans, root, block_rsv, num_bytes, retries);
-	if (ret > 0)
-		goto again;
-
 	return ret;
 }
 
@@ -3667,7 +3746,8 @@ int btrfs_block_rsv_check(struct btrfs_trans_handle *trans,
 		return 0;
 
 	if (block_rsv->refill_used) {
-		ret = reserve_metadata_bytes(block_rsv, num_bytes);
+		ret = reserve_metadata_bytes(trans, root, block_rsv,
+					     num_bytes);
 		if (!ret) {
 			block_rsv_add_bytes(block_rsv, num_bytes, 0);
 			return 0;
@@ -3847,7 +3927,7 @@ static u64 calc_trans_metadata_size(struct btrfs_root *root, int num_items)
 
 int btrfs_trans_reserve_metadata(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root,
-				 int num_items, int *retries)
+				 int num_items)
 {
 	u64 num_bytes;
 	int ret;
@@ -3857,7 +3937,7 @@ int btrfs_trans_reserve_metadata(struct btrfs_trans_handle *trans,
 
 	num_bytes = calc_trans_metadata_size(root, num_items);
 	ret = btrfs_block_rsv_add(trans, root, &root->fs_info->trans_block_rsv,
-				  num_bytes, retries);
+				  num_bytes);
 	if (!ret) {
 		trans->bytes_reserved += num_bytes;
 		trans->block_rsv = &root->fs_info->trans_block_rsv;
@@ -3931,14 +4011,13 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	struct btrfs_block_rsv *block_rsv = &root->fs_info->delalloc_block_rsv;
 	u64 to_reserve;
 	int nr_extents;
-	int retries = 0;
 	int ret;
 
 	if (btrfs_transaction_in_commit(root->fs_info))
 		schedule_timeout(1);
 
 	num_bytes = ALIGN(num_bytes, root->sectorsize);
-again:
+
 	spin_lock(&BTRFS_I(inode)->accounting_lock);
 	nr_extents = atomic_read(&BTRFS_I(inode)->outstanding_extents) + 1;
 	if (nr_extents > BTRFS_I(inode)->reserved_extents) {
@@ -3948,18 +4027,14 @@ again:
 		nr_extents = 0;
 		to_reserve = 0;
 	}
+	spin_unlock(&BTRFS_I(inode)->accounting_lock);
 
 	to_reserve += calc_csum_metadata_size(inode, num_bytes);
-	ret = reserve_metadata_bytes(block_rsv, to_reserve);
-	if (ret) {
-		spin_unlock(&BTRFS_I(inode)->accounting_lock);
-		ret = should_retry_reserve(NULL, root, block_rsv, to_reserve,
-					   &retries);
-		if (ret > 0)
-			goto again;
+	ret = reserve_metadata_bytes(NULL, root, block_rsv, to_reserve);
+	if (ret)
 		return ret;
-	}
 
+	spin_lock(&BTRFS_I(inode)->accounting_lock);
 	BTRFS_I(inode)->reserved_extents += nr_extents;
 	atomic_inc(&BTRFS_I(inode)->outstanding_extents);
 	spin_unlock(&BTRFS_I(inode)->accounting_lock);
@@ -5586,7 +5661,8 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 	block_rsv = get_block_rsv(trans, root);
 
 	if (block_rsv->size == 0) {
-		ret = reserve_metadata_bytes(block_rsv, blocksize);
+		ret = reserve_metadata_bytes(trans, root, block_rsv,
+					     blocksize);
 		if (ret)
 			return ERR_PTR(ret);
 		return block_rsv;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index af339ee..fd07144 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -179,8 +179,6 @@ struct reloc_control {
 	u64 search_start;
 	u64 extents_found;
 
-	int block_rsv_retries;
-
 	unsigned int stage:8;
 	unsigned int create_reloc_tree:1;
 	unsigned int merge_reloc_tree:1;
@@ -2134,7 +2132,6 @@ int prepare_to_merge(struct reloc_control *rc, int err)
 	LIST_HEAD(reloc_roots);
 	u64 num_bytes = 0;
 	int ret;
-	int retries = 0;
 
 	mutex_lock(&root->fs_info->trans_mutex);
 	rc->merging_rsv_size += root->nodesize * (BTRFS_MAX_LEVEL - 1) * 2;
@@ -2144,7 +2141,7 @@ again:
 	if (!err) {
 		num_bytes = rc->merging_rsv_size;
 		ret = btrfs_block_rsv_add(NULL, root, rc->block_rsv,
-					  num_bytes, &retries);
+					  num_bytes);
 		if (ret)
 			err = ret;
 	}
@@ -2156,7 +2153,6 @@ again:
 			btrfs_end_transaction(trans, rc->extent_root);
 			btrfs_block_rsv_release(rc->extent_root,
 						rc->block_rsv, num_bytes);
-			retries = 0;
 			goto again;
 		}
 	}
@@ -2406,15 +2402,13 @@ static int reserve_metadata_space(struct btrfs_trans_handle *trans,
 	num_bytes = calcu_metadata_size(rc, node, 1) * 2;
 
 	trans->block_rsv = rc->block_rsv;
-	ret = btrfs_block_rsv_add(trans, root, rc->block_rsv, num_bytes,
-				  &rc->block_rsv_retries);
+	ret = btrfs_block_rsv_add(trans, root, rc->block_rsv, num_bytes);
 	if (ret) {
 		if (ret == -EAGAIN)
 			rc->commit_transaction = 1;
 		return ret;
 	}
 
-	rc->block_rsv_retries = 0;
 	return 0;
 }
 
@@ -3615,8 +3609,7 @@ int prepare_to_relocate(struct reloc_control *rc)
 	 * is no reservation in transaction handle.
 	 */
 	ret = btrfs_block_rsv_add(NULL, rc->extent_root, rc->block_rsv,
-				  rc->extent_root->nodesize * 256,
-				  &rc->block_rsv_retries);
+				  rc->extent_root->nodesize * 256);
 	if (ret)
 		return ret;
 
@@ -3628,7 +3621,6 @@ int prepare_to_relocate(struct reloc_control *rc)
 	rc->extents_found = 0;
 	rc->nodes_relocated = 0;
 	rc->merging_rsv_size = 0;
-	rc->block_rsv_retries = 0;
 
 	rc->create_reloc_tree = 1;
 	set_reloc_control(rc);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index db0da35..0af647c 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -180,7 +180,6 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 {
 	struct btrfs_trans_handle *h;
 	struct btrfs_transaction *cur_trans;
-	int retries = 0;
 	int ret;
 again:
 	h = kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
@@ -215,8 +214,7 @@ again:
 	}
 
 	if (num_items > 0) {
-		ret = btrfs_trans_reserve_metadata(h, root, num_items,
-						   &retries);
+		ret = btrfs_trans_reserve_metadata(h, root, num_items);
 		if (ret == -EAGAIN) {
 			btrfs_commit_transaction(h, root);
 			goto again;
@@ -855,7 +853,6 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	struct extent_buffer *tmp;
 	struct extent_buffer *old;
 	int ret;
-	int retries = 0;
 	u64 to_reserve = 0;
 	u64 index = 0;
 	u64 objectid;
@@ -877,7 +874,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 
 	if (to_reserve > 0) {
 		ret = btrfs_block_rsv_add(trans, root, &pending->block_rsv,
-					  to_reserve, &retries);
+					  to_reserve);
 		if (ret) {
 			pending->error = ret;
 			goto fail;
-- 
1.6.6.1

