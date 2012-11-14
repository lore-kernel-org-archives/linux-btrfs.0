Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41571 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422661Ab2KNOf4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Nov 2012 09:35:56 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qAEEZsJN032444
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2012 14:35:55 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qAEEZs6I028050
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2012 14:35:54 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qAEEZsWY026257
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2012 08:35:54 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: cleanup for btrfs_btree_balance_dirty
Date: Wed, 14 Nov 2012 22:34:34 +0800
Message-Id: <1352903674-6975-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

- 'nr' is no more used.
- btrfs_btree_balance_dirty() and __btrfs_btree_balance_dirty() can share
  a bunch of code.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/delayed-inode.c |    5 +----
 fs/btrfs/disk-io.c       |   29 ++++++++++-------------------
 fs/btrfs/disk-io.h       |    4 ++--
 fs/btrfs/file.c          |    9 +++------
 fs/btrfs/inode.c         |   42 +++++++++++-------------------------------
 fs/btrfs/relocation.c    |   22 ++++++----------------
 fs/btrfs/transaction.c   |    4 +---
 7 files changed, 34 insertions(+), 81 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 478f66b..52b2a88 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1255,7 +1255,6 @@ static void btrfs_async_run_delayed_node_done(struct btrfs_work *work)
 	struct btrfs_delayed_node *delayed_node = NULL;
 	struct btrfs_root *root;
 	struct btrfs_block_rsv *block_rsv;
-	unsigned long nr = 0;
 	int need_requeue = 0;
 	int ret;
 
@@ -1316,11 +1315,9 @@ static void btrfs_async_run_delayed_node_done(struct btrfs_work *work)
 					   delayed_node);
 	mutex_unlock(&delayed_node->mutex);
 
-	nr = trans->blocks_used;
-
 	trans->block_rsv = block_rsv;
 	btrfs_end_transaction_dmeta(trans, root);
-	__btrfs_btree_balance_dirty(root, nr);
+	btrfs_btree_balance_dirty_nodelay(root);
 free_path:
 	btrfs_free_path(path);
 out:
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 7cda519..b1f38e5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3399,7 +3399,8 @@ void btrfs_mark_buffer_dirty(struct extent_buffer *buf)
 	}
 }
 
-void btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr)
+static void __btrfs_btree_balance_dirty(struct btrfs_root *root,
+					int flush_delayed)
 {
 	/*
 	 * looks as though older kernels can get into trouble with
@@ -3411,7 +3412,8 @@ void btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr)
 	if (current->flags & PF_MEMALLOC)
 		return;
 
-	btrfs_balance_delayed_items(root);
+	if (flush_delayed)
+		btrfs_balance_delayed_items(root);
 
 	num_dirty = root->fs_info->dirty_metadata_bytes;
 
@@ -3422,25 +3424,14 @@ void btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr)
 	return;
 }
 
-void __btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr)
+void btrfs_btree_balance_dirty(struct btrfs_root *root)
 {
-	/*
-	 * looks as though older kernels can get into trouble with
-	 * this code, they end up stuck in balance_dirty_pages forever
-	 */
-	u64 num_dirty;
-	unsigned long thresh = 32 * 1024 * 1024;
-
-	if (current->flags & PF_MEMALLOC)
-		return;
-
-	num_dirty = root->fs_info->dirty_metadata_bytes;
+	__btrfs_btree_balance_dirty(root, 1);
+}
 
-	if (num_dirty > thresh) {
-		balance_dirty_pages_ratelimited_nr(
-				   root->fs_info->btree_inode->i_mapping, 1);
-	}
-	return;
+void btrfs_btree_balance_dirty_nodelay(struct btrfs_root *root)
+{
+	__btrfs_btree_balance_dirty(root, 0);
 }
 
 int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 2025a91..305c33e 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -62,8 +62,8 @@ struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
 struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 					      struct btrfs_key *location);
 int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info);
-void btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr);
-void __btrfs_btree_balance_dirty(struct btrfs_root *root, unsigned long nr);
+void btrfs_btree_balance_dirty(struct btrfs_root *root);
+void btrfs_btree_balance_dirty_nodelay(struct btrfs_root *root);
 void btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root);
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9ab1bed..37940cd 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1349,7 +1349,7 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		balance_dirty_pages_ratelimited_nr(inode->i_mapping,
 						   dirty_pages);
 		if (dirty_pages < (root->leafsize >> PAGE_CACHE_SHIFT) + 1)
-			btrfs_btree_balance_dirty(root, 1);
+			btrfs_btree_balance_dirty(root);
 
 		pos += copied;
 		num_written += copied;
@@ -1803,7 +1803,6 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	u64 cur_offset = lockstart;
 	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
 	u64 drop_end;
-	unsigned long nr;
 	int ret = 0;
 	int err = 0;
 	bool same_page = (offset >> PAGE_CACHE_SHIFT) ==
@@ -1931,9 +1930,8 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 			break;
 		}
 
-		nr = trans->blocks_used;
 		btrfs_end_transaction(trans, root);
-		btrfs_btree_balance_dirty(root, nr);
+		btrfs_btree_balance_dirty(root);
 
 		trans = btrfs_start_transaction(root, 3);
 		if (IS_ERR(trans)) {
@@ -1966,9 +1964,8 @@ out_trans:
 
 	trans->block_rsv = &root->fs_info->trans_block_rsv;
 	ret = btrfs_update_inode(trans, root, inode);
-	nr = trans->blocks_used;
 	btrfs_end_transaction(trans, root);
-	btrfs_btree_balance_dirty(root, nr);
+	btrfs_btree_balance_dirty(root);
 out_free:
 	btrfs_free_path(path);
 	btrfs_free_block_rsv(root, rsv);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 95542a1..8496da2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3074,7 +3074,6 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	struct btrfs_trans_handle *trans;
 	struct inode *inode = dentry->d_inode;
 	int ret;
-	unsigned long nr = 0;
 
 	trans = __unlink_start_trans(dir, dentry);
 	if (IS_ERR(trans))
@@ -3094,9 +3093,8 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	}
 
 out:
-	nr = trans->blocks_used;
 	__unlink_end_trans(trans, root);
-	btrfs_btree_balance_dirty(root, nr);
+	btrfs_btree_balance_dirty(root);
 	return ret;
 }
 
@@ -3186,7 +3184,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	int err = 0;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_trans_handle *trans;
-	unsigned long nr = 0;
 
 	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE)
 		return -ENOTEMPTY;
@@ -3215,9 +3212,8 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	if (!err)
 		btrfs_i_size_write(inode, 0);
 out:
-	nr = trans->blocks_used;
 	__unlink_end_trans(trans, root);
-	btrfs_btree_balance_dirty(root, nr);
+	btrfs_btree_balance_dirty(root);
 
 	return err;
 }
@@ -3783,7 +3779,6 @@ void btrfs_evict_inode(struct inode *inode)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_block_rsv *rsv, *global_rsv;
 	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
-	unsigned long nr;
 	int ret;
 
 	trace_btrfs_inode_evict(inode);
@@ -3864,10 +3859,9 @@ void btrfs_evict_inode(struct inode *inode)
 		ret = btrfs_update_inode(trans, root, inode);
 		BUG_ON(ret);
 
-		nr = trans->blocks_used;
 		btrfs_end_transaction(trans, root);
 		trans = NULL;
-		btrfs_btree_balance_dirty(root, nr);
+		btrfs_btree_balance_dirty(root);
 	}
 
 	btrfs_free_block_rsv(root, rsv);
@@ -3883,9 +3877,8 @@ void btrfs_evict_inode(struct inode *inode)
 	      root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID))
 		btrfs_return_ino(root, btrfs_ino(inode));
 
-	nr = trans->blocks_used;
 	btrfs_end_transaction(trans, root);
-	btrfs_btree_balance_dirty(root, nr);
+	btrfs_btree_balance_dirty(root);
 no_delete:
 	clear_inode(inode);
 	return;
@@ -4897,7 +4890,6 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	int err;
 	int drop_inode = 0;
 	u64 objectid;
-	unsigned long nr = 0;
 	u64 index = 0;
 
 	if (!new_valid_dev(rdev))
@@ -4947,9 +4939,8 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 		d_instantiate(dentry, inode);
 	}
 out_unlock:
-	nr = trans->blocks_used;
 	btrfs_end_transaction(trans, root);
-	btrfs_btree_balance_dirty(root, nr);
+	btrfs_btree_balance_dirty(root);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
@@ -4965,7 +4956,6 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	struct inode *inode = NULL;
 	int drop_inode = 0;
 	int err;
-	unsigned long nr = 0;
 	u64 objectid;
 	u64 index = 0;
 
@@ -5015,13 +5005,12 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 		d_instantiate(dentry, inode);
 	}
 out_unlock:
-	nr = trans->blocks_used;
 	btrfs_end_transaction(trans, root);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
 	}
-	btrfs_btree_balance_dirty(root, nr);
+	btrfs_btree_balance_dirty(root);
 	return err;
 }
 
@@ -5032,7 +5021,6 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct inode *inode = old_dentry->d_inode;
 	u64 index;
-	unsigned long nr = 0;
 	int err;
 	int drop_inode = 0;
 
@@ -5076,14 +5064,13 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 		btrfs_log_new_name(trans, inode, NULL, parent);
 	}
 
-	nr = trans->blocks_used;
 	btrfs_end_transaction(trans, root);
 fail:
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
 	}
-	btrfs_btree_balance_dirty(root, nr);
+	btrfs_btree_balance_dirty(root);
 	return err;
 }
 
@@ -5096,7 +5083,6 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	int drop_on_err = 0;
 	u64 objectid = 0;
 	u64 index = 0;
-	unsigned long nr = 1;
 
 	/*
 	 * 2 items for inode and ref
@@ -5142,11 +5128,10 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	drop_on_err = 0;
 
 out_fail:
-	nr = trans->blocks_used;
 	btrfs_end_transaction(trans, root);
 	if (drop_on_err)
 		iput(inode);
-	btrfs_btree_balance_dirty(root, nr);
+	btrfs_btree_balance_dirty(root);
 	return err;
 }
 
@@ -6855,7 +6840,6 @@ static int btrfs_truncate(struct inode *inode)
 	int ret;
 	int err = 0;
 	struct btrfs_trans_handle *trans;
-	unsigned long nr;
 	u64 mask = root->sectorsize - 1;
 	u64 min_size = btrfs_calc_trunc_metadata_size(root, 1);
 
@@ -6978,9 +6962,8 @@ static int btrfs_truncate(struct inode *inode)
 			break;
 		}
 
-		nr = trans->blocks_used;
 		btrfs_end_transaction(trans, root);
-		btrfs_btree_balance_dirty(root, nr);
+		btrfs_btree_balance_dirty(root);
 
 		trans = btrfs_start_transaction(root, 2);
 		if (IS_ERR(trans)) {
@@ -7014,9 +6997,8 @@ static int btrfs_truncate(struct inode *inode)
 		if (ret && !err)
 			err = ret;
 
-		nr = trans->blocks_used;
 		ret = btrfs_end_transaction(trans, root);
-		btrfs_btree_balance_dirty(root, nr);
+		btrfs_btree_balance_dirty(root);
 	}
 
 out:
@@ -7512,7 +7494,6 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	unsigned long ptr;
 	struct btrfs_file_extent_item *ei;
 	struct extent_buffer *leaf;
-	unsigned long nr = 0;
 
 	name_len = strlen(symname) + 1;
 	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(root))
@@ -7610,13 +7591,12 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 out_unlock:
 	if (!err)
 		d_instantiate(dentry, inode);
-	nr = trans->blocks_used;
 	btrfs_end_transaction(trans, root);
 	if (drop_inode) {
 		inode_dec_link_count(inode);
 		iput(inode);
 	}
-	btrfs_btree_balance_dirty(root, nr);
+	btrfs_btree_balance_dirty(root);
 	return err;
 }
 
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 776f0aa..253fa01 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2025,7 +2025,6 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 	struct btrfs_root_item *root_item;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
-	unsigned long nr;
 	int level;
 	int max_level;
 	int replaced = 0;
@@ -2125,10 +2124,9 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 			       path->slots[level]);
 		root_item->drop_level = level;
 
-		nr = trans->blocks_used;
 		btrfs_end_transaction_throttle(trans, root);
 
-		btrfs_btree_balance_dirty(root, nr);
+		btrfs_btree_balance_dirty(root);
 
 		if (replaced && rc->stage == UPDATE_DATA_PTRS)
 			invalidate_extent_cache(root, &key, &next_key);
@@ -2155,10 +2153,9 @@ out:
 		btrfs_update_reloc_root(trans, root);
 	}
 
-	nr = trans->blocks_used;
 	btrfs_end_transaction_throttle(trans, root);
 
-	btrfs_btree_balance_dirty(root, nr);
+	btrfs_btree_balance_dirty(root);
 
 	if (replaced && rc->stage == UPDATE_DATA_PTRS)
 		invalidate_extent_cache(root, &key, &next_key);
@@ -3259,7 +3256,6 @@ static int delete_block_group_cache(struct btrfs_fs_info *fs_info,
 	struct btrfs_path *path;
 	struct btrfs_root *root = fs_info->tree_root;
 	struct btrfs_trans_handle *trans;
-	unsigned long nr;
 	int ret = 0;
 
 	if (inode)
@@ -3293,9 +3289,8 @@ truncate:
 	ret = btrfs_truncate_free_space_cache(root, trans, path, inode);
 
 	btrfs_free_path(path);
-	nr = trans->blocks_used;
 	btrfs_end_transaction(trans, root);
-	btrfs_btree_balance_dirty(root, nr);
+	btrfs_btree_balance_dirty(root);
 out:
 	iput(inode);
 	return ret;
@@ -3711,7 +3706,6 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_path *path;
 	struct btrfs_extent_item *ei;
-	unsigned long nr;
 	u64 flags;
 	u32 item_size;
 	int ret;
@@ -3828,9 +3822,8 @@ restart:
 			ret = btrfs_commit_transaction(trans, rc->extent_root);
 			BUG_ON(ret);
 		} else {
-			nr = trans->blocks_used;
 			btrfs_end_transaction_throttle(trans, rc->extent_root);
-			btrfs_btree_balance_dirty(rc->extent_root, nr);
+			btrfs_btree_balance_dirty(rc->extent_root);
 		}
 		trans = NULL;
 
@@ -3860,9 +3853,8 @@ restart:
 			  GFP_NOFS);
 
 	if (trans) {
-		nr = trans->blocks_used;
 		btrfs_end_transaction_throttle(trans, rc->extent_root);
-		btrfs_btree_balance_dirty(rc->extent_root, nr);
+		btrfs_btree_balance_dirty(rc->extent_root);
 	}
 
 	if (!err) {
@@ -3941,7 +3933,6 @@ struct inode *create_reloc_inode(struct btrfs_fs_info *fs_info,
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root;
 	struct btrfs_key key;
-	unsigned long nr;
 	u64 objectid = BTRFS_FIRST_FREE_OBJECTID;
 	int err = 0;
 
@@ -3969,9 +3960,8 @@ struct inode *create_reloc_inode(struct btrfs_fs_info *fs_info,
 
 	err = btrfs_orphan_add(trans, inode);
 out:
-	nr = trans->blocks_used;
 	btrfs_end_transaction(trans, root);
-	btrfs_btree_balance_dirty(root, nr);
+	btrfs_btree_balance_dirty(root);
 	if (err) {
 		if (inode)
 			iput(inode);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 04bbfb1..e36ed6d 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -958,7 +958,6 @@ int btrfs_defrag_root(struct btrfs_root *root, int cacheonly)
 	struct btrfs_fs_info *info = root->fs_info;
 	struct btrfs_trans_handle *trans;
 	int ret;
-	unsigned long nr;
 
 	if (xchg(&root->defrag_running, 1))
 		return 0;
@@ -970,9 +969,8 @@ int btrfs_defrag_root(struct btrfs_root *root, int cacheonly)
 
 		ret = btrfs_defrag_leaves(trans, root, cacheonly);
 
-		nr = trans->blocks_used;
 		btrfs_end_transaction(trans, root);
-		btrfs_btree_balance_dirty(info->tree_root, nr);
+		btrfs_btree_balance_dirty(info->tree_root);
 		cond_resched();
 
 		if (btrfs_fs_closing(root->fs_info) || ret != -EAGAIN)
-- 
1.7.7.6

