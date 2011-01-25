From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] btrfs: fix return value check of btrfs_join_transaction()
Date: Tue, 25 Jan 2011 11:51:38 +0900
Message-ID: <201101250251.AA00005@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The error check of btrfs_join_transaction()/btrfs_join_transaction_nolock()
is added, and the mistake of the error check in several places is
corrected.

For more stable Btrfs, I think that we should reduce BUG_ON().
But, I think that long time is necessary for this.
So, I propose this patch as a short-term solution.

With this patch:
 - To more stable Btrfs, the part that should be corrected is clarified.
 - The panic isn't done by the NULL pointer reference etc. (even if
   BUG_ON() is increased temporarily)
 - The error code is returned in the place where the error can be easily
   returned.

As a long-term plan:
 - BUG_ON() is reduced by using the forced-readonly framework, etc.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/disk-io.c     |    5 +++++
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/inode.c       |   24 ++++++++++++++++--------
 fs/btrfs/ioctl.c       |    2 +-
 fs/btrfs/relocation.c  |   26 +++++++++++++++++++++++---
 fs/btrfs/transaction.c |    5 +++++
 6 files changed, 51 insertions(+), 13 deletions(-)

diff -urNp linux-2.6.38-rc2/fs/btrfs/disk-io.c linux-2.6.38-rc2.new/fs/btrfs/disk-io.c
--- linux-2.6.38-rc2/fs/btrfs/disk-io.c	2011-01-22 12:01:34.000000000 +0900
+++ linux-2.6.38-rc2.new/fs/btrfs/disk-io.c	2011-01-24 13:26:29.000000000 +0900
@@ -1550,6 +1550,7 @@ static int transaction_kthread(void *arg
 		spin_unlock(&root->fs_info->new_trans_lock);
 
 		trans = btrfs_join_transaction(root, 1);
+		BUG_ON(IS_ERR(trans));
 		if (transid == trans->transid) {
 			ret = btrfs_commit_transaction(trans, root);
 			BUG_ON(ret);
@@ -2453,10 +2454,14 @@ int btrfs_commit_super(struct btrfs_root
 	up_write(&root->fs_info->cleanup_work_sem);
 
 	trans = btrfs_join_transaction(root, 1);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 	ret = btrfs_commit_transaction(trans, root);
 	BUG_ON(ret);
 	/* run commit again to drop the original snapshot */
 	trans = btrfs_join_transaction(root, 1);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
 	btrfs_commit_transaction(trans, root);
 	ret = btrfs_write_and_wait_transaction(NULL, root);
 	BUG_ON(ret);
diff -urNp linux-2.6.38-rc2/fs/btrfs/extent-tree.c linux-2.6.38-rc2.new/fs/btrfs/extent-tree.c
--- linux-2.6.38-rc2/fs/btrfs/extent-tree.c	2011-01-22 12:01:34.000000000 +0900
+++ linux-2.6.38-rc2.new/fs/btrfs/extent-tree.c	2011-01-24 13:26:29.000000000 +0900
@@ -7477,7 +7477,7 @@ int btrfs_drop_dead_reloc_roots(struct b
 		BUG_ON(reloc_root->commit_root != NULL);
 		while (1) {
 			trans = btrfs_join_transaction(root, 1);
-			BUG_ON(!trans);
+			BUG_ON(IS_ERR(trans));
 
 			mutex_lock(&root->fs_info->drop_mutex);
 			ret = btrfs_drop_snapshot(trans, reloc_root);
diff -urNp linux-2.6.38-rc2/fs/btrfs/inode.c linux-2.6.38-rc2.new/fs/btrfs/inode.c
--- linux-2.6.38-rc2/fs/btrfs/inode.c	2011-01-22 12:01:34.000000000 +0900
+++ linux-2.6.38-rc2.new/fs/btrfs/inode.c	2011-01-24 13:26:29.000000000 +0900
@@ -416,7 +416,7 @@ again:
 	}
 	if (start == 0) {
 		trans = btrfs_join_transaction(root, 1);
-		BUG_ON(!trans);
+		BUG_ON(IS_ERR(trans));
 		btrfs_set_trans_block_group(trans, inode);
 		trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 
@@ -612,6 +612,7 @@ retry:
 			    GFP_NOFS);
 
 		trans = btrfs_join_transaction(root, 1);
+		BUG_ON(IS_ERR(trans));
 		ret = btrfs_reserve_extent(trans, root,
 					   async_extent->compressed_size,
 					   async_extent->compressed_size,
@@ -771,7 +772,7 @@ static noinline int cow_file_range(struc
 
 	BUG_ON(root == root->fs_info->tree_root);
 	trans = btrfs_join_transaction(root, 1);
-	BUG_ON(!trans);
+	BUG_ON(IS_ERR(trans));
 	btrfs_set_trans_block_group(trans, inode);
 	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 
@@ -1049,7 +1050,7 @@ static noinline int run_delalloc_nocow(s
 	} else {
 		trans = btrfs_join_transaction(root, 1);
 	}
-	BUG_ON(!trans);
+	BUG_ON(IS_ERR(trans));
 
 	cow_start = (u64)-1;
 	cur_offset = start;
@@ -1703,7 +1704,7 @@ static int btrfs_finish_ordered_io(struc
 				trans = btrfs_join_transaction_nolock(root, 1);
 			else
 				trans = btrfs_join_transaction(root, 1);
-			BUG_ON(!trans);
+			BUG_ON(IS_ERR(trans));
 			btrfs_set_trans_block_group(trans, inode);
 			trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 			ret = btrfs_update_inode(trans, root, inode);
@@ -1720,6 +1721,7 @@ static int btrfs_finish_ordered_io(struc
 		trans = btrfs_join_transaction_nolock(root, 1);
 	else
 		trans = btrfs_join_transaction(root, 1);
+	BUG_ON(IS_ERR(trans));
 	btrfs_set_trans_block_group(trans, inode);
 	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 
@@ -2381,6 +2383,7 @@ void btrfs_orphan_cleanup(struct btrfs_r
 
 	if (root->orphan_block_rsv || root->orphan_item_inserted) {
 		trans = btrfs_join_transaction(root, 1);
+		BUG_ON(IS_ERR(trans));
 		btrfs_end_transaction(trans, root);
 	}
 
@@ -4347,6 +4350,8 @@ int btrfs_write_inode(struct inode *inod
 			trans = btrfs_join_transaction_nolock(root, 1);
 		else
 			trans = btrfs_join_transaction(root, 1);
+		if (IS_ERR(trans))
+			return PTR_ERR(trans);
 		btrfs_set_trans_block_group(trans, inode);
 		if (nolock)
 			ret = btrfs_end_transaction_nolock(trans, root);
@@ -4372,6 +4377,7 @@ void btrfs_dirty_inode(struct inode *ino
 		return;
 
 	trans = btrfs_join_transaction(root, 1);
+	BUG_ON(IS_ERR(trans));
 	btrfs_set_trans_block_group(trans, inode);
 
 	ret = btrfs_update_inode(trans, root, inode);
@@ -5176,6 +5182,8 @@ again:
 				em = NULL;
 				btrfs_release_path(root, path);
 				trans = btrfs_join_transaction(root, 1);
+				if (IS_ERR(trans))
+					return ERR_CAST(trans);
 				goto again;
 			}
 			map = kmap(page);
@@ -5280,8 +5288,8 @@ static struct extent_map *btrfs_new_exte
 	btrfs_drop_extent_cache(inode, start, start + len - 1, 0);
 
 	trans = btrfs_join_transaction(root, 0);
-	if (!trans)
-		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(trans))
+		return ERR_CAST(trans);
 
 	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 
@@ -5505,7 +5513,7 @@ static int btrfs_get_blocks_direct(struc
 		 * while we look for nocow cross refs
 		 */
 		trans = btrfs_join_transaction(root, 0);
-		if (!trans)
+		if (IS_ERR(trans))
 			goto must_cow;
 
 		if (can_nocow_odirect(trans, inode, start, len) == 1) {
@@ -5640,7 +5648,7 @@ again:
 	BUG_ON(!ordered);
 
 	trans = btrfs_join_transaction(root, 1);
-	if (!trans) {
+	if (IS_ERR(trans)) {
 		err = -ENOMEM;
 		goto out;
 	}
diff -urNp linux-2.6.38-rc2/fs/btrfs/ioctl.c linux-2.6.38-rc2.new/fs/btrfs/ioctl.c
--- linux-2.6.38-rc2/fs/btrfs/ioctl.c	2011-01-22 12:01:34.000000000 +0900
+++ linux-2.6.38-rc2.new/fs/btrfs/ioctl.c	2011-01-24 13:26:29.000000000 +0900
@@ -203,7 +203,7 @@ static int btrfs_ioctl_setflags(struct f
 
 
 	trans = btrfs_join_transaction(root, 1);
-	BUG_ON(!trans);
+	BUG_ON(IS_ERR(trans));
 
 	ret = btrfs_update_inode(trans, root, inode);
 	BUG_ON(ret);
diff -urNp linux-2.6.38-rc2/fs/btrfs/relocation.c linux-2.6.38-rc2.new/fs/btrfs/relocation.c
--- linux-2.6.38-rc2/fs/btrfs/relocation.c	2011-01-22 12:01:34.000000000 +0900
+++ linux-2.6.38-rc2.new/fs/btrfs/relocation.c	2011-01-24 13:26:29.000000000 +0900
@@ -2147,6 +2147,12 @@ again:
 	}
 
 	trans = btrfs_join_transaction(rc->extent_root, 1);
+	if (IS_ERR(trans)) {
+		if (!err)
+			btrfs_block_rsv_release(rc->extent_root,
+						rc->block_rsv, num_bytes);
+		return PTR_ERR(trans);
+	}
 
 	if (!err) {
 		if (num_bytes != rc->merging_rsv_size) {
@@ -3222,6 +3228,7 @@ truncate:
 	trans = btrfs_join_transaction(root, 0);
 	if (IS_ERR(trans)) {
 		btrfs_free_path(path);
+		ret = PTR_ERR(trans);
 		goto out;
 	}
 
@@ -3628,6 +3635,7 @@ int prepare_to_relocate(struct reloc_con
 	set_reloc_control(rc);
 
 	trans = btrfs_join_transaction(rc->extent_root, 1);
+	BUG_ON(IS_ERR(trans));
 	btrfs_commit_transaction(trans, rc->extent_root);
 	return 0;
 }
@@ -3804,7 +3812,10 @@ static noinline_for_stack int relocate_b
 
 	/* get rid of pinned extents */
 	trans = btrfs_join_transaction(rc->extent_root, 1);
-	btrfs_commit_transaction(trans, rc->extent_root);
+	if (IS_ERR(trans))
+		err = PTR_ERR(trans);
+	else
+		btrfs_commit_transaction(trans, rc->extent_root);
 out_free:
 	btrfs_free_block_rsv(rc->extent_root, rc->block_rsv);
 	btrfs_free_path(path);
@@ -4125,6 +4136,11 @@ int btrfs_recover_relocation(struct btrf
 	set_reloc_control(rc);
 
 	trans = btrfs_join_transaction(rc->extent_root, 1);
+	if (IS_ERR(trans)) {
+		unset_reloc_control(rc);
+		err = PTR_ERR(trans);
+		goto out_free;
+	}
 
 	rc->merge_reloc_tree = 1;
 
@@ -4154,9 +4170,13 @@ int btrfs_recover_relocation(struct btrf
 	unset_reloc_control(rc);
 
 	trans = btrfs_join_transaction(rc->extent_root, 1);
-	btrfs_commit_transaction(trans, rc->extent_root);
-out:
+	if (IS_ERR(trans))
+		err = PTR_ERR(trans);
+	else
+		btrfs_commit_transaction(trans, rc->extent_root);
+out_free:
 	kfree(rc);
+out:
 	while (!list_empty(&reloc_roots)) {
 		reloc_root = list_entry(reloc_roots.next,
 					struct btrfs_root, root_list);
diff -urNp linux-2.6.38-rc2/fs/btrfs/transaction.c linux-2.6.38-rc2.new/fs/btrfs/transaction.c
--- linux-2.6.38-rc2/fs/btrfs/transaction.c	2011-01-22 12:01:34.000000000 +0900
+++ linux-2.6.38-rc2.new/fs/btrfs/transaction.c	2011-01-24 13:26:29.000000000 +0900
@@ -1161,6 +1161,11 @@ int btrfs_commit_transaction_async(struc
 	INIT_DELAYED_WORK(&ac->work, do_async_commit);
 	ac->root = root;
 	ac->newtrans = btrfs_join_transaction(root, 0);
+	if (IS_ERR(ac->newtrans)) {
+		int err = PTR_ERR(ac->newtrans);
+		kfree(ac);
+		return err;
+	}
 
 	/* take transaction reference */
 	mutex_lock(&root->fs_info->trans_mutex);


