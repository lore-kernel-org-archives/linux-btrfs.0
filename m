From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: take away the num_items argument from btrfs_join_transaction
Date: Wed, 13 Apr 2011 12:55:56 -0400
Message-ID: <1302713756-27876-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I keep forgetting that btrfs_join_transaction() just ignores the num_items
argument, which leads me to sending pointless patches and looking stupid :).  So
just kill the num_items argument from btrfs_join_transaction and
btrfs_start_ioctl_transaction, since neither of them use it.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/disk-io.c     |    6 +++---
 fs/btrfs/extent-tree.c |   12 ++++++------
 fs/btrfs/inode.c       |   34 +++++++++++++++++-----------------
 fs/btrfs/ioctl.c       |    4 ++--
 fs/btrfs/relocation.c  |   12 ++++++------
 fs/btrfs/transaction.c |   13 +++++--------
 fs/btrfs/transaction.h |    9 +++------
 7 files changed, 42 insertions(+), 48 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 68c84c8..0a141df 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1568,7 +1568,7 @@ static int transaction_kthread(void *arg)
 		transid = cur->transid;
 		spin_unlock(&root->fs_info->new_trans_lock);
 
-		trans = btrfs_join_transaction(root, 1);
+		trans = btrfs_join_transaction(root);
 		BUG_ON(IS_ERR(trans));
 		if (transid == trans->transid) {
 			ret = btrfs_commit_transaction(trans, root);
@@ -2495,13 +2495,13 @@ int btrfs_commit_super(struct btrfs_root *root)
 	down_write(&root->fs_info->cleanup_work_sem);
 	up_write(&root->fs_info->cleanup_work_sem);
 
-	trans = btrfs_join_transaction(root, 1);
+	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 	ret = btrfs_commit_transaction(trans, root);
 	BUG_ON(ret);
 	/* run commit again to drop the original snapshot */
-	trans = btrfs_join_transaction(root, 1);
+	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 	btrfs_commit_transaction(trans, root);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 362cc9b..0714a57 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3155,7 +3155,7 @@ again:
 			spin_unlock(&data_sinfo->lock);
 alloc:
 			alloc_target = btrfs_get_alloc_profile(root, 1);
-			trans = btrfs_join_transaction(root, 1);
+			trans = btrfs_join_transaction(root);
 			if (IS_ERR(trans))
 				return PTR_ERR(trans);
 
@@ -3182,7 +3182,7 @@ alloc:
 commit_trans:
 		if (!committed && !root->fs_info->open_ioctl_trans) {
 			committed = 1;
-			trans = btrfs_join_transaction(root, 1);
+			trans = btrfs_join_transaction(root);
 			if (IS_ERR(trans))
 				return PTR_ERR(trans);
 			ret = btrfs_commit_transaction(trans, root);
@@ -3543,7 +3543,7 @@ again:
 		goto out;
 
 	ret = -ENOSPC;
-	trans = btrfs_join_transaction(root, 1);
+	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans))
 		goto out;
 	ret = btrfs_commit_transaction(trans, root);
@@ -3770,7 +3770,7 @@ int btrfs_block_rsv_check(struct btrfs_trans_handle *trans,
 		if (trans)
 			return -EAGAIN;
 
-		trans = btrfs_join_transaction(root, 1);
+		trans = btrfs_join_transaction(root);
 		BUG_ON(IS_ERR(trans));
 		ret = btrfs_commit_transaction(trans, root);
 		return 0;
@@ -7600,7 +7600,7 @@ int btrfs_drop_dead_reloc_roots(struct btrfs_root *root)
 
 		BUG_ON(reloc_root->commit_root != NULL);
 		while (1) {
-			trans = btrfs_join_transaction(root, 1);
+			trans = btrfs_join_transaction(root);
 			BUG_ON(IS_ERR(trans));
 
 			mutex_lock(&root->fs_info->drop_mutex);
@@ -8123,7 +8123,7 @@ int btrfs_set_block_group_ro(struct btrfs_root *root,
 
 	BUG_ON(cache->ro);
 
-	trans = btrfs_join_transaction(root, 1);
+	trans = btrfs_join_transaction(root);
 	BUG_ON(IS_ERR(trans));
 
 	alloc_flags = update_block_group_flags(root, cache->flags);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a23e9ee..ade00e7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -420,7 +420,7 @@ again:
 		}
 	}
 	if (start == 0) {
-		trans = btrfs_join_transaction(root, 1);
+		trans = btrfs_join_transaction(root);
 		BUG_ON(IS_ERR(trans));
 		btrfs_set_trans_block_group(trans, inode);
 		trans->block_rsv = &root->fs_info->delalloc_block_rsv;
@@ -617,7 +617,7 @@ retry:
 			    async_extent->start + async_extent->ram_size - 1,
 			    GFP_NOFS);
 
-		trans = btrfs_join_transaction(root, 1);
+		trans = btrfs_join_transaction(root);
 		BUG_ON(IS_ERR(trans));
 		trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 		ret = btrfs_reserve_extent(trans, root,
@@ -779,7 +779,7 @@ static noinline int cow_file_range(struct inode *inode,
 	int ret = 0;
 
 	BUG_ON(root == root->fs_info->tree_root);
-	trans = btrfs_join_transaction(root, 1);
+	trans = btrfs_join_transaction(root);
 	BUG_ON(IS_ERR(trans));
 	btrfs_set_trans_block_group(trans, inode);
 	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
@@ -1055,9 +1055,9 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	BUG_ON(!path);
 	if (root == root->fs_info->tree_root) {
 		nolock = true;
-		trans = btrfs_join_transaction_nolock(root, 1);
+		trans = btrfs_join_transaction_nolock(root);
 	} else {
-		trans = btrfs_join_transaction(root, 1);
+		trans = btrfs_join_transaction(root);
 	}
 	BUG_ON(IS_ERR(trans));
 	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
@@ -1717,9 +1717,9 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 		ret = btrfs_ordered_update_i_size(inode, 0, ordered_extent);
 		if (!ret) {
 			if (nolock)
-				trans = btrfs_join_transaction_nolock(root, 1);
+				trans = btrfs_join_transaction_nolock(root);
 			else
-				trans = btrfs_join_transaction(root, 1);
+				trans = btrfs_join_transaction(root);
 			BUG_ON(IS_ERR(trans));
 			btrfs_set_trans_block_group(trans, inode);
 			trans->block_rsv = &root->fs_info->delalloc_block_rsv;
@@ -1734,9 +1734,9 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 			 0, &cached_state, GFP_NOFS);
 
 	if (nolock)
-		trans = btrfs_join_transaction_nolock(root, 1);
+		trans = btrfs_join_transaction_nolock(root);
 	else
-		trans = btrfs_join_transaction(root, 1);
+		trans = btrfs_join_transaction(root);
 	BUG_ON(IS_ERR(trans));
 	btrfs_set_trans_block_group(trans, inode);
 	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
@@ -2414,7 +2414,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 					(u64)-1);
 
 	if (root->orphan_block_rsv || root->orphan_item_inserted) {
-		trans = btrfs_join_transaction(root, 1);
+		trans = btrfs_join_transaction(root);
 		if (!IS_ERR(trans))
 			btrfs_end_transaction(trans, root);
 	}
@@ -4385,9 +4385,9 @@ int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 	if (wbc->sync_mode == WB_SYNC_ALL) {
 		if (nolock)
-			trans = btrfs_join_transaction_nolock(root, 1);
+			trans = btrfs_join_transaction_nolock(root);
 		else
-			trans = btrfs_join_transaction(root, 1);
+			trans = btrfs_join_transaction(root);
 		if (IS_ERR(trans))
 			return PTR_ERR(trans);
 		btrfs_set_trans_block_group(trans, inode);
@@ -4414,7 +4414,7 @@ void btrfs_dirty_inode(struct inode *inode)
 	if (BTRFS_I(inode)->dummy_inode)
 		return;
 
-	trans = btrfs_join_transaction(root, 1);
+	trans = btrfs_join_transaction(root);
 	BUG_ON(IS_ERR(trans));
 	btrfs_set_trans_block_group(trans, inode);
 
@@ -5226,7 +5226,7 @@ again:
 				free_extent_map(em);
 				em = NULL;
 				btrfs_release_path(root, path);
-				trans = btrfs_join_transaction(root, 1);
+				trans = btrfs_join_transaction(root);
 				if (IS_ERR(trans))
 					return ERR_CAST(trans);
 				goto again;
@@ -5470,7 +5470,7 @@ static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
 		btrfs_drop_extent_cache(inode, start, start + len - 1, 0);
 	}
 
-	trans = btrfs_join_transaction(root, 0);
+	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans))
 		return ERR_CAST(trans);
 
@@ -5703,7 +5703,7 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 		 * to make sure the current transaction stays open
 		 * while we look for nocow cross refs
 		 */
-		trans = btrfs_join_transaction(root, 0);
+		trans = btrfs_join_transaction(root);
 		if (IS_ERR(trans))
 			goto must_cow;
 
@@ -5841,7 +5841,7 @@ again:
 
 	BUG_ON(!ordered);
 
-	trans = btrfs_join_transaction(root, 1);
+	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
 		err = -ENOMEM;
 		goto out;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index dc9ff27..3696f23 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -236,7 +236,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	else if (flags & FS_COW_FL)
 		ip->flags &= ~BTRFS_INODE_NODATACOW;
 
-	trans = btrfs_join_transaction(root, 1);
+	trans = btrfs_join_transaction(root);
 	BUG_ON(IS_ERR(trans));
 
 	ret = btrfs_update_inode(trans, root, inode);
@@ -2176,7 +2176,7 @@ static long btrfs_ioctl_trans_start(struct file *file)
 	mutex_unlock(&root->fs_info->trans_mutex);
 
 	ret = -ENOMEM;
-	trans = btrfs_start_ioctl_transaction(root, 0);
+	trans = btrfs_start_ioctl_transaction(root);
 	if (IS_ERR(trans))
 		goto out_drop;
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 58250e0..db5b15c 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2149,7 +2149,7 @@ again:
 			err = ret;
 	}
 
-	trans = btrfs_join_transaction(rc->extent_root, 1);
+	trans = btrfs_join_transaction(rc->extent_root);
 	if (IS_ERR(trans)) {
 		if (!err)
 			btrfs_block_rsv_release(rc->extent_root,
@@ -3233,7 +3233,7 @@ truncate:
 		goto out;
 	}
 
-	trans = btrfs_join_transaction(root, 0);
+	trans = btrfs_join_transaction(root);
 	if (IS_ERR(trans)) {
 		btrfs_free_path(path);
 		ret = PTR_ERR(trans);
@@ -3642,7 +3642,7 @@ int prepare_to_relocate(struct reloc_control *rc)
 	rc->create_reloc_tree = 1;
 	set_reloc_control(rc);
 
-	trans = btrfs_join_transaction(rc->extent_root, 1);
+	trans = btrfs_join_transaction(rc->extent_root);
 	BUG_ON(IS_ERR(trans));
 	btrfs_commit_transaction(trans, rc->extent_root);
 	return 0;
@@ -3831,7 +3831,7 @@ restart:
 	btrfs_block_rsv_release(rc->extent_root, rc->block_rsv, (u64)-1);
 
 	/* get rid of pinned extents */
-	trans = btrfs_join_transaction(rc->extent_root, 1);
+	trans = btrfs_join_transaction(rc->extent_root);
 	if (IS_ERR(trans))
 		err = PTR_ERR(trans);
 	else
@@ -4156,7 +4156,7 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 
 	set_reloc_control(rc);
 
-	trans = btrfs_join_transaction(rc->extent_root, 1);
+	trans = btrfs_join_transaction(rc->extent_root);
 	if (IS_ERR(trans)) {
 		unset_reloc_control(rc);
 		err = PTR_ERR(trans);
@@ -4190,7 +4190,7 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 
 	unset_reloc_control(rc);
 
-	trans = btrfs_join_transaction(rc->extent_root, 1);
+	trans = btrfs_join_transaction(rc->extent_root);
 	if (IS_ERR(trans))
 		err = PTR_ERR(trans);
 	else
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c571734..70bfb26 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -257,22 +257,19 @@ struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 {
 	return start_transaction(root, num_items, TRANS_START);
 }
-struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root,
-						   int num_blocks)
+struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root)
 {
 	return start_transaction(root, 0, TRANS_JOIN);
 }
 
-struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root,
-							  int num_blocks)
+struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root)
 {
 	return start_transaction(root, 0, TRANS_JOIN_NOLOCK);
 }
 
-struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *r,
-							 int num_blocks)
+struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root)
 {
-	return start_transaction(r, 0, TRANS_USERSPACE);
+	return start_transaction(root, 0, TRANS_USERSPACE);
 }
 
 /* wait for a transaction commit to be fully complete */
@@ -1171,7 +1168,7 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 
 	INIT_DELAYED_WORK(&ac->work, do_async_commit);
 	ac->root = root;
-	ac->newtrans = btrfs_join_transaction(root, 0);
+	ac->newtrans = btrfs_join_transaction(root);
 	if (IS_ERR(ac->newtrans)) {
 		int err = PTR_ERR(ac->newtrans);
 		kfree(ac);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index e441acc..1f573f0 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -92,12 +92,9 @@ int btrfs_end_transaction_nolock(struct btrfs_trans_handle *trans,
 				 struct btrfs_root *root);
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
 						   int num_items);
-struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root,
-						  int num_blocks);
-struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root,
-							  int num_blocks);
-struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *r,
-							 int num_blocks);
+struct btrfs_trans_handle *btrfs_join_transaction(struct btrfs_root *root);
+struct btrfs_trans_handle *btrfs_join_transaction_nolock(struct btrfs_root *root);
+struct btrfs_trans_handle *btrfs_start_ioctl_transaction(struct btrfs_root *root);
 int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid);
 int btrfs_write_and_wait_transaction(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root);
-- 
1.7.2.3

