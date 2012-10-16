Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:7536 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab2JPLdS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Oct 2012 07:33:18 -0400
Message-ID: <507D4612.50400@cn.fujitsu.com>
Date: Tue, 16 Oct 2012 19:33:38 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH 2/2] Btrfs: improve the noflush reservation
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In some places(such as: evicting inode), we just can not flush the reserved
space of delalloc, flushing the delayed directory index and delayed inode
is OK, but we don't try to flush those things and just go back when there is
no enough space to be reserved. This patch fixes this problem.

We defined 3 types of the flush operations: NO_FLUSH, FLUSH_LIMIT and FLUSH_ALL.
If we can in the transaction, we should not flush anything, or the deadlock
would happen, so use NO_FLUSH. If we flushing the reserved space of delalloc
would cause deadlock, use FLUSH_LIMIT. In the other cases, FLUSH_ALL is used,
and we will flush all things.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h         |   26 ++++++++-----
 fs/btrfs/delayed-inode.c |    6 ++-
 fs/btrfs/extent-tree.c   |   97 +++++++++++++++++++++++-----------------------
 fs/btrfs/inode-map.c     |    5 +-
 fs/btrfs/inode.c         |    5 +-
 fs/btrfs/relocation.c    |   12 ++++--
 fs/btrfs/transaction.c   |   30 +++++++--------
 fs/btrfs/transaction.h   |    2 +-
 8 files changed, 97 insertions(+), 86 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1630be8..00bd7ba 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2900,6 +2900,18 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
 u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags);
 u64 btrfs_get_alloc_profile(struct btrfs_root *root, int data);
 void btrfs_clear_space_info_full(struct btrfs_fs_info *info);
+
+enum btrfs_reserve_flush_enum {
+	/* If we are in the transaction, we can't flush anything.*/
+	BTRFS_RESERVE_NO_FLUSH,
+	/*
+	 * Flushing delalloc may cause deadlock somewhere, in this
+	 * case, use FLUSH LIMIT
+	 */
+	BTRFS_RESERVE_FLUSH_LIMIT,
+	BTRFS_RESERVE_FLUSH_ALL,
+};
+
 int btrfs_check_data_free_space(struct inode *inode, u64 bytes);
 void btrfs_free_reserved_data_space(struct inode *inode, u64 bytes);
 void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans,
@@ -2919,19 +2931,13 @@ struct btrfs_block_rsv *btrfs_alloc_block_rsv(struct btrfs_root *root,
 void btrfs_free_block_rsv(struct btrfs_root *root,
 			  struct btrfs_block_rsv *rsv);
 int btrfs_block_rsv_add(struct btrfs_root *root,
-			struct btrfs_block_rsv *block_rsv,
-			u64 num_bytes);
-int btrfs_block_rsv_add_noflush(struct btrfs_root *root,
-				struct btrfs_block_rsv *block_rsv,
-				u64 num_bytes);
+			struct btrfs_block_rsv *block_rsv, u64 num_bytes,
+			enum btrfs_reserve_flush_enum flush);
 int btrfs_block_rsv_check(struct btrfs_root *root,
 			  struct btrfs_block_rsv *block_rsv, int min_factor);
 int btrfs_block_rsv_refill(struct btrfs_root *root,
-			  struct btrfs_block_rsv *block_rsv,
-			  u64 min_reserved);
-int btrfs_block_rsv_refill_noflush(struct btrfs_root *root,
-				   struct btrfs_block_rsv *block_rsv,
-				   u64 min_reserved);
+			   struct btrfs_block_rsv *block_rsv, u64 min_reserved,
+			   enum btrfs_reserve_flush_enum flush);
 int btrfs_block_rsv_migrate(struct btrfs_block_rsv *src_rsv,
 			    struct btrfs_block_rsv *dst_rsv,
 			    u64 num_bytes);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index b26d2f9..c1b6ea8 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -651,7 +651,8 @@ static int btrfs_delayed_inode_reserve_metadata(
 	 */
 	if (!src_rsv || (!trans->bytes_reserved &&
 			 src_rsv->type != BTRFS_BLOCK_RSV_DELALLOC)) {
-		ret = btrfs_block_rsv_add_noflush(root, dst_rsv, num_bytes);
+		ret = btrfs_block_rsv_add(root, dst_rsv, num_bytes,
+					  BTRFS_RESERVE_NO_FLUSH);
 		/*
 		 * Since we're under a transaction reserve_metadata_bytes could
 		 * try to commit the transaction which will make it return
@@ -686,7 +687,8 @@ static int btrfs_delayed_inode_reserve_metadata(
 		 * reserve something strictly for us.  If not be a pain and try
 		 * to steal from the delalloc block rsv.
 		 */
-		ret = btrfs_block_rsv_add_noflush(root, dst_rsv, num_bytes);
+		ret = btrfs_block_rsv_add(root, dst_rsv, num_bytes,
+					  BTRFS_RESERVE_NO_FLUSH);
 		if (!ret)
 			goto out;
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2cfcce2..2136add 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3644,7 +3644,7 @@ out:
 
 static int can_overcommit(struct btrfs_root *root,
 			  struct btrfs_space_info *space_info, u64 bytes,
-			  int flush)
+			  enum btrfs_reserve_flush_enum flush)
 {
 	u64 profile = btrfs_get_alloc_profile(root, 0);
 	u64 avail;
@@ -3672,7 +3672,7 @@ static int can_overcommit(struct btrfs_root *root,
 	 * 1/2th of the space. If we can flush, don't let us overcommit
 	 * too much, let it overcommit up to 1/8 of the space.
 	 */
-	if (flush)
+	if (flush == BTRFS_RESERVE_FLUSH_ALL)
 		avail >>= 3;
 	else
 		avail >>= 1;
@@ -3696,6 +3696,7 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 	long time_left;
 	unsigned long nr_pages = (2 * 1024 * 1024) >> PAGE_CACHE_SHIFT;
 	int loops = 0;
+	enum btrfs_reserve_flush_enum flush;
 
 	trans = (struct btrfs_trans_handle *)current->journal_info;
 	block_rsv = &root->fs_info->delalloc_block_rsv;
@@ -3723,8 +3724,12 @@ static void shrink_delalloc(struct btrfs_root *root, u64 to_reclaim, u64 orig,
 		wait_event(root->fs_info->async_submit_wait,
 			   !atomic_read(&root->fs_info->async_delalloc_pages));
 
+		if (!trans)
+			flush = BTRFS_RESERVE_FLUSH_ALL;
+		else
+			flush = BTRFS_RESERVE_NO_FLUSH;
 		spin_lock(&space_info->lock);
-		if (can_overcommit(root, space_info, orig, !trans)) {
+		if (can_overcommit(root, space_info, orig, flush)) {
 			spin_unlock(&space_info->lock);
 			break;
 		}
@@ -3882,7 +3887,8 @@ static int flush_space(struct btrfs_root *root,
  */
 static int reserve_metadata_bytes(struct btrfs_root *root,
 				  struct btrfs_block_rsv *block_rsv,
-				  u64 orig_bytes, int flush)
+				  u64 orig_bytes,
+				  enum btrfs_reserve_flush_enum flush)
 {
 	struct btrfs_space_info *space_info = block_rsv->space_info;
 	u64 used;
@@ -3895,10 +3901,11 @@ again:
 	ret = 0;
 	spin_lock(&space_info->lock);
 	/*
-	 * We only want to wait if somebody other than us is flushing and we are
-	 * actually alloed to flush.
+	 * We only want to wait if somebody other than us is flushing and we
+	 * are actually allowed to flush all things.
 	 */
-	while (flush && !flushing && space_info->flush) {
+	while (flush == BTRFS_RESERVE_FLUSH_ALL && !flushing &&
+	       space_info->flush) {
 		spin_unlock(&space_info->lock);
 		/*
 		 * If we have a trans handle we can't wait because the flusher
@@ -3964,23 +3971,40 @@ again:
 	 * Couldn't make our reservation, save our place so while we're trying
 	 * to reclaim space we can actually use it instead of somebody else
 	 * stealing it from us.
+	 *
+	 * We make the other tasks wait for the flush only when we can flush
+	 * all things.
 	 */
-	if (ret && flush) {
+	if (ret && flush == BTRFS_RESERVE_FLUSH_ALL) {
 		flushing = true;
 		space_info->flush = 1;
 	}
 
 	spin_unlock(&space_info->lock);
 
-	if (!ret || !flush)
+	if (!ret || flush == BTRFS_RESERVE_NO_FLUSH)
 		goto out;
 
 	ret = flush_space(root, space_info, num_bytes, orig_bytes,
 			  flush_state);
 	flush_state++;
+
+	/*
+	 * If we are FLUSH_LIMIT, we can not flush delalloc, or the deadlock
+	 * would happen. So skip delalloc flush.
+	 */
+	if (flush == BTRFS_RESERVE_FLUSH_LIMIT &&
+	    (flush_state == FLUSH_DELALLOC ||
+	     flush_state == FLUSH_DELALLOC_WAIT))
+		flush_state = ALLOC_CHUNK;
+
 	if (!ret)
 		goto again;
-	else if (flush_state <= COMMIT_TRANS)
+	else if (flush == BTRFS_RESERVE_FLUSH_LIMIT &&
+		 flush_state < COMMIT_TRANS)
+		goto again;
+	else if (flush == BTRFS_RESERVE_FLUSH_ALL &&
+		 flush_state <= COMMIT_TRANS)
 		goto again;
 
 out:
@@ -4131,9 +4155,9 @@ void btrfs_free_block_rsv(struct btrfs_root *root,
 	kfree(rsv);
 }
 
-static inline int __block_rsv_add(struct btrfs_root *root,
-				  struct btrfs_block_rsv *block_rsv,
-				  u64 num_bytes, int flush)
+int btrfs_block_rsv_add(struct btrfs_root *root,
+			struct btrfs_block_rsv *block_rsv, u64 num_bytes,
+			enum btrfs_reserve_flush_enum flush)
 {
 	int ret;
 
@@ -4149,20 +4173,6 @@ static inline int __block_rsv_add(struct btrfs_root *root,
 	return ret;
 }
 
-int btrfs_block_rsv_add(struct btrfs_root *root,
-			struct btrfs_block_rsv *block_rsv,
-			u64 num_bytes)
-{
-	return __block_rsv_add(root, block_rsv, num_bytes, 1);
-}
-
-int btrfs_block_rsv_add_noflush(struct btrfs_root *root,
-				struct btrfs_block_rsv *block_rsv,
-				u64 num_bytes)
-{
-	return __block_rsv_add(root, block_rsv, num_bytes, 0);
-}
-
 int btrfs_block_rsv_check(struct btrfs_root *root,
 			  struct btrfs_block_rsv *block_rsv, int min_factor)
 {
@@ -4181,9 +4191,9 @@ int btrfs_block_rsv_check(struct btrfs_root *root,
 	return ret;
 }
 
-static inline int __btrfs_block_rsv_refill(struct btrfs_root *root,
-					   struct btrfs_block_rsv *block_rsv,
-					   u64 min_reserved, int flush)
+int btrfs_block_rsv_refill(struct btrfs_root *root,
+			   struct btrfs_block_rsv *block_rsv, u64 min_reserved,
+			   enum btrfs_reserve_flush_enum flush)
 {
 	u64 num_bytes = 0;
 	int ret = -ENOSPC;
@@ -4211,20 +4221,6 @@ static inline int __btrfs_block_rsv_refill(struct btrfs_root *root,
 	return ret;
 }
 
-int btrfs_block_rsv_refill(struct btrfs_root *root,
-			   struct btrfs_block_rsv *block_rsv,
-			   u64 min_reserved)
-{
-	return __btrfs_block_rsv_refill(root, block_rsv, min_reserved, 1);
-}
-
-int btrfs_block_rsv_refill_noflush(struct btrfs_root *root,
-				   struct btrfs_block_rsv *block_rsv,
-				   u64 min_reserved)
-{
-	return __btrfs_block_rsv_refill(root, block_rsv, min_reserved, 0);
-}
-
 int btrfs_block_rsv_migrate(struct btrfs_block_rsv *src_rsv,
 			    struct btrfs_block_rsv *dst_rsv,
 			    u64 num_bytes)
@@ -4515,14 +4511,15 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	u64 csum_bytes;
 	unsigned nr_extents = 0;
 	int extra_reserve = 0;
-	int flush = 1;
+	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
 	int ret;
 
 	/* Need to be holding the i_mutex here if we aren't free space cache */
 	if (btrfs_is_free_space_inode(inode))
-		flush = 0;
+		flush = BTRFS_RESERVE_NO_FLUSH;
 
-	if (flush && btrfs_transaction_in_commit(root->fs_info))
+	if (flush != BTRFS_RESERVE_NO_FLUSH &&
+	    btrfs_transaction_in_commit(root->fs_info))
 		schedule_timeout(1);
 
 	mutex_lock(&BTRFS_I(inode)->delalloc_mutex);
@@ -6252,7 +6249,8 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 	block_rsv = get_block_rsv(trans, root);
 
 	if (block_rsv->size == 0) {
-		ret = reserve_metadata_bytes(root, block_rsv, blocksize, 0);
+		ret = reserve_metadata_bytes(root, block_rsv, blocksize,
+					     BTRFS_RESERVE_NO_FLUSH);
 		/*
 		 * If we couldn't reserve metadata bytes try and use some from
 		 * the global reserve.
@@ -6279,7 +6277,8 @@ use_block_rsv(struct btrfs_trans_handle *trans,
 			printk(KERN_DEBUG "btrfs: block rsv returned %d\n", ret);
 			WARN_ON(1);
 		}
-		ret = reserve_metadata_bytes(root, block_rsv, blocksize, 0);
+		ret = reserve_metadata_bytes(root, block_rsv, blocksize,
+					     BTRFS_RESERVE_NO_FLUSH);
 		if (!ret) {
 			return block_rsv;
 		} else if (ret && block_rsv != global_rsv) {
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index b1a1c92..d26f67a 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -434,8 +434,9 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 	 * 3 items for pre-allocation
 	 */
 	trans->bytes_reserved = btrfs_calc_trans_metadata_size(root, 8);
-	ret = btrfs_block_rsv_add_noflush(root, trans->block_rsv,
-					  trans->bytes_reserved);
+	ret = btrfs_block_rsv_add(root, trans->block_rsv,
+				  trans->bytes_reserved,
+				  BTRFS_RESERVE_NO_FLUSH);
 	if (ret)
 		goto out;
 	trace_btrfs_space_reservation(root->fs_info, "ino_cache",
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2c785c0..5afb12b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4446,7 +4446,8 @@ void btrfs_evict_inode(struct inode *inode)
 	 * inode item when doing the truncate.
 	 */
 	while (1) {
-		ret = btrfs_block_rsv_refill_noflush(root, rsv, min_size);
+		ret = btrfs_block_rsv_refill(root, rsv, min_size,
+					     BTRFS_RESERVE_FLUSH_LIMIT);
 
 		/*
 		 * Try and steal from the global reserve since we will
@@ -4464,7 +4465,7 @@ void btrfs_evict_inode(struct inode *inode)
 			goto no_delete;
 		}
 
-		trans = btrfs_start_transaction_noflush(root, 1);
+		trans = btrfs_start_transaction_lflush(root, 1);
 		if (IS_ERR(trans)) {
 			btrfs_orphan_del(NULL, inode);
 			btrfs_free_block_rsv(root, rsv);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 776f0aa..242d6de 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2074,7 +2074,8 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 		BUG_ON(IS_ERR(trans));
 		trans->block_rsv = rc->block_rsv;
 
-		ret = btrfs_block_rsv_refill(root, rc->block_rsv, min_reserved);
+		ret = btrfs_block_rsv_refill(root, rc->block_rsv, min_reserved,
+					     BTRFS_RESERVE_FLUSH_ALL);
 		if (ret) {
 			BUG_ON(ret != -EAGAIN);
 			ret = btrfs_commit_transaction(trans, root);
@@ -2184,7 +2185,8 @@ int prepare_to_merge(struct reloc_control *rc, int err)
 again:
 	if (!err) {
 		num_bytes = rc->merging_rsv_size;
-		ret = btrfs_block_rsv_add(root, rc->block_rsv, num_bytes);
+		ret = btrfs_block_rsv_add(root, rc->block_rsv, num_bytes,
+					  BTRFS_RESERVE_FLUSH_ALL);
 		if (ret)
 			err = ret;
 	}
@@ -2459,7 +2461,8 @@ static int reserve_metadata_space(struct btrfs_trans_handle *trans,
 	num_bytes = calcu_metadata_size(rc, node, 1) * 2;
 
 	trans->block_rsv = rc->block_rsv;
-	ret = btrfs_block_rsv_add(root, rc->block_rsv, num_bytes);
+	ret = btrfs_block_rsv_add(root, rc->block_rsv, num_bytes,
+				  BTRFS_RESERVE_FLUSH_ALL);
 	if (ret) {
 		if (ret == -EAGAIN)
 			rc->commit_transaction = 1;
@@ -3685,7 +3688,8 @@ int prepare_to_relocate(struct reloc_control *rc)
 	 * is no reservation in transaction handle.
 	 */
 	ret = btrfs_block_rsv_add(rc->extent_root, rc->block_rsv,
-				  rc->extent_root->nodesize * 256);
+				  rc->extent_root->nodesize * 256,
+				  BTRFS_RESERVE_FLUSH_ALL);
 	if (ret)
 		return ret;
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 77db875..83aa617 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -295,9 +295,9 @@ static int may_wait_transaction(struct btrfs_root *root, int type)
 	return 0;
 }
 
-static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
-						    u64 num_items, int type,
-						    int noflush)
+static struct btrfs_trans_handle *
+start_transaction(struct btrfs_root *root, u64 num_items, int type,
+		  enum btrfs_reserve_flush_enum flush)
 {
 	struct btrfs_trans_handle *h;
 	struct btrfs_transaction *cur_trans;
@@ -331,14 +331,9 @@ static struct btrfs_trans_handle *start_transaction(struct btrfs_root *root,
 		}
 
 		num_bytes = btrfs_calc_trans_metadata_size(root, num_items);
-		if (noflush)
-			ret = btrfs_block_rsv_add_noflush(root,
-						&root->fs_info->trans_block_rsv,
-						num_bytes);
-		else
-			ret = btrfs_block_rsv_add(root,
-						&root->fs_info->trans_block_rsv,
-						num_bytes);
+		ret = btrfs_block_rsv_add(root,
+					  &root->fs_info->trans_block_rsv,
+					  num_bytes, flush);
 		if (ret)
 			return ERR_PTR(ret);
 	}
@@ -422,13 +417,15 @@ got_it:
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 						   int num_items)
 {
-	return start_transaction(root, num_items, TRANS_START, 0);
+	return start_transaction(root, num_items, TRANS_START,
+				 BTRFS_RESERVE_FLUSH_ALL);
 }
 
-struct btrfs_trans_handle *btrfs_start_transaction_noflush(
+struct btrfs_trans_handle *btrfs_start_transaction_lflush(
 					struct btrfs_root *root, int num_items)
 {
-	return start_transaction(root, num_items, TRANS_START, 1);
+	return start_transaction(root, num_items, TRANS_START,
+				 BTRFS_RESERVE_FLUSH_LIMIT);
 }
 
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root)
@@ -1032,8 +1029,9 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	btrfs_reloc_pre_snapshot(trans, pending, &to_reserve);
 
 	if (to_reserve > 0) {
-		ret = btrfs_block_rsv_add_noflush(root, &pending->block_rsv,
-						  to_reserve);
+		ret = btrfs_block_rsv_add(root, &pending->block_rsv,
+					  to_reserve,
+					  BTRFS_RESERVE_NO_FLUSH);
 		if (ret) {
 			pending->error = ret;
 			goto no_free_objectid;
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 8096194..0e8aa1e 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -105,7 +105,7 @@ int btrfs_end_transaction(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 						   int num_items);
-struct btrfs_trans_handle *btrfs_start_transaction_noflush(
+struct btrfs_trans_handle *btrfs_start_transaction_lflush(
 					struct btrfs_root *root, int num_items);
 struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root);
-- 
1.7.6.5
