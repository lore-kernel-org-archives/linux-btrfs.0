Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:46887 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932Ab3FLR7k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Jun 2013 13:59:40 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 282457C064D
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Jun 2013 11:59:39 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id 2AtSFzgdC3dn3GpU (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 12 Jun 2013 11:59:38 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix transaction throttling for delayed refs
Date: Wed, 12 Jun 2013 13:59:35 -0400
Message-ID: <1371059975-8192-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave has this fs_mark script that can make btrfs abort with sufficient amount of
ram.  This is because with more ram we can keep more dirty metadata in cache
which in a round about way makes for many more pending delayed refs.  What
happens is we end up not throttling the transaction enough so when we go to
commit the transaction when we've completely filled the file system we'll
abort() because we use all of the space in the global reserve and we still have
delayed refs to run.  To fix this we need to make the delayed ref flushing and
the transaction throttling dependant upon the number of delayed refs that we
have instead of how much reserved space is left in the global reserve.  With
this patch we not only stop aborting transactions but we also get a smoother run
speed with fs_mark and it makes us about 10% faster.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.h       |    2 +
 fs/btrfs/extent-tree.c |   61 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/transaction.c |   24 ++++++++-----------
 3 files changed, 69 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0049fe0..76e4983 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3056,6 +3056,8 @@ static inline u64 btrfs_calc_trunc_metadata_size(struct btrfs_root *root,
 		num_items;
 }
 
+int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
+				       struct btrfs_root *root);
 void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
 int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, unsigned long count);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ca1893e..6d5c5f7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2526,6 +2526,51 @@ static int refs_newer(struct btrfs_delayed_ref_root *delayed_refs, int seq,
 	return 0;
 }
 
+static inline u64 heads_to_leaves(struct btrfs_root *root, u64 heads)
+{
+	u64 num_bytes;
+
+	num_bytes = heads * (sizeof(struct btrfs_extent_item) +
+			     sizeof(struct btrfs_extent_inline_ref));
+	if (!btrfs_fs_incompat(root->fs_info, SKINNY_METADATA))
+		num_bytes += heads * sizeof(struct btrfs_tree_block_info);
+
+	/*
+	 * We don't ever fill up leaves all the way so multiply by 2 just to be
+	 * closer to what we're really going to want to ouse.
+	 */
+	return div64_u64(num_bytes, BTRFS_LEAF_DATA_SIZE(root));
+}
+
+int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
+				       struct btrfs_root *root)
+{
+	struct btrfs_block_rsv *global_rsv;
+	u64 num_heads = trans->transaction->delayed_refs.num_heads_ready;
+	u64 num_bytes;
+	int ret = 0;
+
+	num_bytes = btrfs_calc_trans_metadata_size(root, 1);
+	num_heads = heads_to_leaves(root, num_heads);
+	if (num_heads > 1)
+		num_bytes += (num_heads - 1) * root->leafsize;
+	num_bytes <<= 1;
+	global_rsv = &root->fs_info->global_block_rsv;
+
+	/*
+	 * If we can't allocate any more chunks lets make sure we have _lots_ of
+	 * wiggle room since running delayed refs can create more delayed refs.
+	 */
+	if (global_rsv->space_info->full)
+		num_bytes <<= 1;
+
+	spin_lock(&global_rsv->lock);
+	if (global_rsv->reserved <= num_bytes)
+		ret = 1;
+	spin_unlock(&global_rsv->lock);
+	return ret;
+}
+
 /*
  * this starts processing the delayed reference count updates and
  * extent insertions we have queued up so far.  count can be
@@ -2573,7 +2618,8 @@ progress:
 		old = atomic_cmpxchg(&delayed_refs->procs_running_refs, 0, 1);
 		if (old) {
 			DEFINE_WAIT(__wait);
-			if (delayed_refs->num_entries < 16348)
+			if (delayed_refs->flushing ||
+			    !btrfs_should_throttle_delayed_refs(trans, root))
 				return 0;
 
 			prepare_to_wait(&delayed_refs->wait, &__wait,
@@ -2608,7 +2654,7 @@ again:
 
 	while (1) {
 		if (!(run_all || run_most) &&
-		    delayed_refs->num_heads_ready < 64)
+		    !btrfs_should_throttle_delayed_refs(trans, root))
 			break;
 
 		/*
@@ -8665,8 +8711,15 @@ int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range)
 		if (end - start >= range->minlen) {
 			if (!block_group_cache_done(cache)) {
 				ret = cache_block_group(cache, 0);
-				if (!ret)
-					wait_block_group_cache_done(cache);
+				if (ret) {
+					btrfs_put_block_group(cache);
+					break;
+				}
+				ret = wait_block_group_cache_done(cache);
+				if (ret) {
+					btrfs_put_block_group(cache);
+					break;
+				}
 			}
 			ret = btrfs_trim_block_group(cache,
 						     &group_trimmed,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c11b7ef..c916ebd 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -615,10 +615,11 @@ void btrfs_throttle(struct btrfs_root *root)
 static int should_end_transaction(struct btrfs_trans_handle *trans,
 				  struct btrfs_root *root)
 {
-	int ret;
+	if (root->fs_info->global_block_rsv.space_info->full &&
+	    btrfs_should_throttle_delayed_refs(trans, root))
+		return 1;
 
-	ret = btrfs_block_rsv_check(root, &root->fs_info->global_block_rsv, 5);
-	return ret ? 1 : 0;
+	return !!btrfs_block_rsv_check(root, &root->fs_info->global_block_rsv, 5);
 }
 
 int btrfs_should_end_transaction(struct btrfs_trans_handle *trans,
@@ -649,7 +650,7 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	struct btrfs_fs_info *info = root->fs_info;
-	int count = 0;
+	unsigned long cur = trans->delayed_ref_updates;
 	int lock = (trans->type != TRANS_JOIN_NOLOCK);
 	int err = 0;
 
@@ -678,17 +679,11 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	if (!list_empty(&trans->new_bgs))
 		btrfs_create_pending_block_groups(trans, root);
 
-	while (count < 1) {
-		unsigned long cur = trans->delayed_ref_updates;
+	trans->delayed_ref_updates = 0;
+	if (btrfs_should_throttle_delayed_refs(trans, root)) {
+		cur = max_t(unsigned long, cur, 1);
 		trans->delayed_ref_updates = 0;
-		if (cur &&
-		    trans->transaction->delayed_refs.num_heads_ready > 64) {
-			trans->delayed_ref_updates = 0;
-			btrfs_run_delayed_refs(trans, root, cur);
-		} else {
-			break;
-		}
-		count++;
+		btrfs_run_delayed_refs(trans, root, cur);
 	}
 
 	btrfs_trans_release_metadata(trans, root);
@@ -1626,6 +1621,7 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 	 * start sending their work down.
 	 */
 	cur_trans->delayed_refs.flushing = 1;
+	smp_wmb();
 
 	if (!list_empty(&trans->new_bgs))
 		btrfs_create_pending_block_groups(trans, root);
-- 
1.7.7.6

