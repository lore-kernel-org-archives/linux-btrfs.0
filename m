From: Josef Bacik <josef@redhat.com>
Subject: [PATCH 3/4] Btrfs: kill BTRFS_I(inode)->block_group
Date: Wed, 11 May 2011 17:35:54 -0400
Message-ID: <1305149755-4413-3-git-send-email-josef@redhat.com>
References: <1305149755-4413-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305149755-4413-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Originally this was going to be used as a way to give hints to the allocator,
but frankly we can get much better hints elsewhere and it's not even used at all
for anything usefull.  In addition to be completely useless, when we initialize
an inode we try and find a freeish block group to set as the inodes block group,
and with a completely full 40gb fs this takes _forever_, so I imagine with say
1tb fs this is just unbearable.  So just axe the thing altoghether, we don't
need it and it saves us 8 bytes in the inode and saves us 500 microseconds per
inode lookup in my testcase.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/btrfs_inode.h |    3 --
 fs/btrfs/ctree.h       |    3 +-
 fs/btrfs/extent-tree.c |   10 +----
 fs/btrfs/inode.c       |   86 +++++-------------------------------------------
 fs/btrfs/ioctl.c       |    3 +-
 fs/btrfs/transaction.c |    1 -
 fs/btrfs/transaction.h |   14 --------
 fs/btrfs/xattr.c       |    2 -
 8 files changed, 13 insertions(+), 109 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 57c3bb2..4bc852d 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -120,9 +120,6 @@ struct btrfs_inode {
 	 */
 	u64 index_cnt;
 
-	/* the start of block group preferred for allocations. */
-	u64 block_group;
-
 	/* the fsync log has some corner cases that mean we have to check
 	 * directories to see if any unlinks have been done before
 	 * the directory was logged.  See tree-log.c for all the
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 1a41d77..c217b45 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2514,8 +2514,7 @@ int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end,
 int btrfs_writepages(struct address_space *mapping,
 		     struct writeback_control *wbc);
 int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *new_root,
-			     u64 new_dirid, u64 alloc_hint);
+			     struct btrfs_root *new_root, u64 new_dirid);
 int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 			 size_t size, struct bio *bio, unsigned long bio_flags);
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 64d2514..0d24414 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5273,6 +5273,7 @@ checks:
 			btrfs_add_free_space(block_group, offset,
 					     search_start - offset);
 		BUG_ON(offset > search_start);
+		btrfs_put_block_group(block_group);
 		break;
 loop:
 		failed_cluster_refill = false;
@@ -5363,14 +5364,7 @@ loop:
 		ret = -ENOSPC;
 	} else if (!ins->objectid) {
 		ret = -ENOSPC;
-	}
-
-	/* we found what we needed */
-	if (ins->objectid) {
-		if (!(data & BTRFS_BLOCK_GROUP_DATA))
-			trans->block_group = block_group->key.objectid;
-
-		btrfs_put_block_group(block_group);
+	} else if (ins->objectid) {
 		ret = 0;
 	}
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1aa8cc0..7746ed3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -136,7 +136,6 @@ static noinline int insert_inline_extent(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	path->leave_spinning = 1;
-	btrfs_set_trans_block_group(trans, inode);
 
 	key.objectid = inode->i_ino;
 	key.offset = start;
@@ -422,7 +421,6 @@ again:
 	if (start == 0) {
 		trans = btrfs_join_transaction(root);
 		BUG_ON(IS_ERR(trans));
-		btrfs_set_trans_block_group(trans, inode);
 		trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 
 		/* lets try to make an inline extent */
@@ -781,7 +779,6 @@ static noinline int cow_file_range(struct inode *inode,
 	BUG_ON(root == root->fs_info->tree_root);
 	trans = btrfs_join_transaction(root);
 	BUG_ON(IS_ERR(trans));
-	btrfs_set_trans_block_group(trans, inode);
 	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 
 	num_bytes = (end - start + blocksize) & ~(blocksize - 1);
@@ -1501,8 +1498,6 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_ordered_sum *sum;
 
-	btrfs_set_trans_block_group(trans, inode);
-
 	list_for_each_entry(sum, list, list) {
 		btrfs_csum_file_blocks(trans,
 		       BTRFS_I(inode)->root->fs_info->csum_root, sum);
@@ -1721,7 +1716,6 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 			else
 				trans = btrfs_join_transaction(root);
 			BUG_ON(IS_ERR(trans));
-			btrfs_set_trans_block_group(trans, inode);
 			trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 			ret = btrfs_update_inode(trans, root, inode);
 			BUG_ON(ret);
@@ -1738,7 +1732,6 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	else
 		trans = btrfs_join_transaction(root);
 	BUG_ON(IS_ERR(trans));
-	btrfs_set_trans_block_group(trans, inode);
 	trans->block_rsv = &root->fs_info->delalloc_block_rsv;
 
 	if (test_bit(BTRFS_ORDERED_COMPRESSED, &ordered_extent->flags))
@@ -2494,7 +2487,6 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_key location;
 	int maybe_acls;
-	u64 alloc_group_block;
 	u32 rdev;
 	int ret;
 
@@ -2538,8 +2530,6 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	BTRFS_I(inode)->index_cnt = (u64)-1;
 	BTRFS_I(inode)->flags = btrfs_inode_flags(leaf, inode_item);
 
-	alloc_group_block = btrfs_inode_block_group(leaf, inode_item);
-
 	/*
 	 * try to precache a NULL acl entry for files that don't have
 	 * any xattrs or acls
@@ -2548,8 +2538,6 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	if (!maybe_acls)
 		cache_no_acl(inode);
 
-	BTRFS_I(inode)->block_group = btrfs_find_block_group(root, 0,
-						alloc_group_block, 0);
 	btrfs_free_path(path);
 	inode_item = NULL;
 
@@ -2629,7 +2617,7 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_inode_transid(leaf, item, trans->transid);
 	btrfs_set_inode_rdev(leaf, item, inode->i_rdev);
 	btrfs_set_inode_flags(leaf, item, BTRFS_I(inode)->flags);
-	btrfs_set_inode_block_group(leaf, item, BTRFS_I(inode)->block_group);
+	btrfs_set_inode_block_group(leaf, item, 0);
 
 	if (leaf->map_token) {
 		unmap_extent_buffer(leaf, leaf->map_token, KM_USER1);
@@ -2970,8 +2958,6 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	btrfs_set_trans_block_group(trans, dir);
-
 	btrfs_record_unlink_dir(trans, dir, dentry->d_inode, 0);
 
 	ret = btrfs_unlink_inode(trans, root, dir, dentry->d_inode,
@@ -3067,8 +3053,6 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	btrfs_set_trans_block_group(trans, dir);
-
 	if (unlikely(inode->i_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
 		err = btrfs_unlink_subvol(trans, root, dir,
 					  BTRFS_I(inode)->location.objectid,
@@ -3648,7 +3632,6 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
 				err = PTR_ERR(trans);
 				break;
 			}
-			btrfs_set_trans_block_group(trans, inode);
 
 			err = btrfs_drop_extents(trans, inode, cur_offset,
 						 cur_offset + hole_size,
@@ -3784,7 +3767,6 @@ void btrfs_evict_inode(struct inode *inode)
 	while (1) {
 		trans = btrfs_start_transaction(root, 0);
 		BUG_ON(IS_ERR(trans));
-		btrfs_set_trans_block_group(trans, inode);
 		trans->block_rsv = root->orphan_block_rsv;
 
 		ret = btrfs_block_rsv_check(trans, root,
@@ -4390,7 +4372,6 @@ int btrfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 			trans = btrfs_join_transaction(root);
 		if (IS_ERR(trans))
 			return PTR_ERR(trans);
-		btrfs_set_trans_block_group(trans, inode);
 		if (nolock)
 			ret = btrfs_end_transaction_nolock(trans, root);
 		else
@@ -4416,7 +4397,6 @@ void btrfs_dirty_inode(struct inode *inode)
 
 	trans = btrfs_join_transaction(root);
 	BUG_ON(IS_ERR(trans));
-	btrfs_set_trans_block_group(trans, inode);
 
 	ret = btrfs_update_inode(trans, root, inode);
 	if (ret && ret == -ENOSPC) {
@@ -4431,7 +4411,6 @@ void btrfs_dirty_inode(struct inode *inode)
 			}
 			return;
 		}
-		btrfs_set_trans_block_group(trans, inode);
 
 		ret = btrfs_update_inode(trans, root, inode);
 		if (ret) {
@@ -4526,8 +4505,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 				     struct btrfs_root *root,
 				     struct inode *dir,
 				     const char *name, int name_len,
-				     u64 ref_objectid, u64 objectid,
-				     u64 alloc_hint, int mode, u64 *index)
+				     u64 ref_objectid, u64 objectid, int mode,
+				     u64 *index)
 {
 	struct inode *inode;
 	struct btrfs_inode_item *inode_item;
@@ -4571,8 +4550,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 		owner = 0;
 	else
 		owner = 1;
-	BTRFS_I(inode)->block_group =
-			btrfs_find_block_group(root, 0, alloc_hint, owner);
 
 	key[0].objectid = objectid;
 	btrfs_set_key_type(&key[0], BTRFS_INODE_ITEM_KEY);
@@ -4733,11 +4710,9 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	btrfs_set_trans_block_group(trans, dir);
-
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len, dir->i_ino, objectid,
-				BTRFS_I(dir)->block_group, mode, &index);
+				mode, &index);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_unlock;
@@ -4748,7 +4723,6 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 		goto out_unlock;
 	}
 
-	btrfs_set_trans_block_group(trans, inode);
 	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
 	if (err)
 		drop_inode = 1;
@@ -4757,8 +4731,6 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 		init_special_inode(inode, inode->i_mode, rdev);
 		btrfs_update_inode(trans, root, inode);
 	}
-	btrfs_update_inode_block_group(trans, inode);
-	btrfs_update_inode_block_group(trans, dir);
 out_unlock:
 	nr = trans->blocks_used;
 	btrfs_end_transaction_throttle(trans, root);
@@ -4794,11 +4766,9 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	btrfs_set_trans_block_group(trans, dir);
-
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len, dir->i_ino, objectid,
-				BTRFS_I(dir)->block_group, mode, &index);
+				mode, &index);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_unlock;
@@ -4809,7 +4779,6 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 		goto out_unlock;
 	}
 
-	btrfs_set_trans_block_group(trans, inode);
 	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
 	if (err)
 		drop_inode = 1;
@@ -4820,8 +4789,6 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 		inode->i_op = &btrfs_file_inode_operations;
 		BTRFS_I(inode)->io_tree.ops = &btrfs_extent_io_ops;
 	}
-	btrfs_update_inode_block_group(trans, inode);
-	btrfs_update_inode_block_group(trans, dir);
 out_unlock:
 	nr = trans->blocks_used;
 	btrfs_end_transaction_throttle(trans, root);
@@ -4869,7 +4836,6 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 		goto fail;
 	}
 
-	btrfs_set_trans_block_group(trans, dir);
 	ihold(inode);
 
 	err = btrfs_add_nondir(trans, dir, dentry, inode, 1, index);
@@ -4878,7 +4844,6 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 		drop_inode = 1;
 	} else {
 		struct dentry *parent = dget_parent(dentry);
-		btrfs_update_inode_block_group(trans, dir);
 		err = btrfs_update_inode(trans, root, inode);
 		BUG_ON(err);
 		btrfs_log_new_name(trans, inode, NULL, parent);
@@ -4919,12 +4884,10 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	trans = btrfs_start_transaction(root, 5);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
-	btrfs_set_trans_block_group(trans, dir);
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len, dir->i_ino, objectid,
-				BTRFS_I(dir)->block_group, S_IFDIR | mode,
-				&index);
+				S_IFDIR | mode, &index);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
 		goto out_fail;
@@ -4938,7 +4901,6 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 
 	inode->i_op = &btrfs_dir_inode_operations;
 	inode->i_fop = &btrfs_dir_file_operations;
-	btrfs_set_trans_block_group(trans, inode);
 
 	btrfs_i_size_write(inode, 0);
 	err = btrfs_update_inode(trans, root, inode);
@@ -4952,8 +4914,6 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 
 	d_instantiate(dentry, inode);
 	drop_on_err = 0;
-	btrfs_update_inode_block_group(trans, inode);
-	btrfs_update_inode_block_group(trans, dir);
 
 out_fail:
 	nr = trans->blocks_used;
@@ -6652,8 +6612,6 @@ static int btrfs_truncate(struct inode *inode)
 		goto out;
 	}
 
-	btrfs_set_trans_block_group(trans, inode);
-
 	/*
 	 * Reserve space for the truncate process.  Truncate should be adding
 	 * space, but if there are snapshots it may end up using space.
@@ -6680,7 +6638,6 @@ static int btrfs_truncate(struct inode *inode)
 		err = PTR_ERR(trans);
 		goto out;
 	}
-	btrfs_set_trans_block_group(trans, inode);
 	trans->block_rsv = rsv;
 
 	/*
@@ -6715,7 +6672,6 @@ static int btrfs_truncate(struct inode *inode)
 							      rsv);
 			BUG_ON(ret);
 
-			btrfs_set_trans_block_group(trans, inode);
 			trans->block_rsv = rsv;
 		}
 
@@ -6775,15 +6731,14 @@ out:
  * create a new subvolume directory/inode (helper for the ioctl).
  */
 int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *new_root,
-			     u64 new_dirid, u64 alloc_hint)
+			     struct btrfs_root *new_root, u64 new_dirid)
 {
 	struct inode *inode;
 	int err;
 	u64 index = 0;
 
 	inode = btrfs_new_inode(trans, new_root, NULL, "..", 2, new_dirid,
-				new_dirid, alloc_hint, S_IFDIR | 0700, &index);
+				new_dirid, S_IFDIR | 0700, &index);
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 	inode->i_op = &btrfs_dir_inode_operations;
@@ -6893,21 +6848,6 @@ void btrfs_destroy_inode(struct inode *inode)
 		spin_unlock(&root->fs_info->ordered_extent_lock);
 	}
 
-	if (root == root->fs_info->tree_root) {
-		struct btrfs_block_group_cache *block_group;
-
-		block_group = btrfs_lookup_block_group(root->fs_info,
-						BTRFS_I(inode)->block_group);
-		if (block_group && block_group->inode == inode) {
-			spin_lock(&block_group->lock);
-			block_group->inode = NULL;
-			spin_unlock(&block_group->lock);
-			btrfs_put_block_group(block_group);
-		} else if (block_group) {
-			btrfs_put_block_group(block_group);
-		}
-	}
-
 	spin_lock(&root->orphan_lock);
 	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
 		printk(KERN_INFO "BTRFS: inode %lu still on the orphan list\n",
@@ -7091,8 +7031,6 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
                 goto out_notrans;
         }
 
-	btrfs_set_trans_block_group(trans, new_dir);
-
 	if (dest != root)
 		btrfs_record_root_in_trans(trans, dest);
 
@@ -7331,12 +7269,9 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	btrfs_set_trans_block_group(trans, dir);
-
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len, dir->i_ino, objectid,
-				BTRFS_I(dir)->block_group, S_IFLNK|S_IRWXUGO,
-				&index);
+				S_IFLNK|S_IRWXUGO, &index);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_unlock;
@@ -7347,7 +7282,6 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 		goto out_unlock;
 	}
 
-	btrfs_set_trans_block_group(trans, inode);
 	err = btrfs_add_nondir(trans, dir, dentry, inode, 0, index);
 	if (err)
 		drop_inode = 1;
@@ -7358,8 +7292,6 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 		inode->i_op = &btrfs_file_inode_operations;
 		BTRFS_I(inode)->io_tree.ops = &btrfs_extent_io_ops;
 	}
-	btrfs_update_inode_block_group(trans, inode);
-	btrfs_update_inode_block_group(trans, dir);
 	if (drop_inode)
 		goto out_unlock;
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4a9a277..1783b25 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -407,8 +407,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 
 	btrfs_record_root_in_trans(trans, new_root);
 
-	ret = btrfs_create_subvol_root(trans, new_root, new_dirid,
-				       BTRFS_I(dir)->block_group);
+	ret = btrfs_create_subvol_root(trans, new_root, new_dirid);
 	/*
 	 * insert the directory item
 	 */
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 43816f8..f4ea695 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -241,7 +241,6 @@ again:
 	h->transid = cur_trans->transid;
 	h->transaction = cur_trans;
 	h->blocks_used = 0;
-	h->block_group = 0;
 	h->bytes_reserved = 0;
 	h->delayed_ref_updates = 0;
 	h->use_count = 1;
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 11c6efc..da7289e 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -47,7 +47,6 @@ struct btrfs_transaction {
 
 struct btrfs_trans_handle {
 	u64 transid;
-	u64 block_group;
 	u64 bytes_reserved;
 	unsigned long use_count;
 	unsigned long blocks_reserved;
@@ -70,19 +69,6 @@ struct btrfs_pending_snapshot {
 	struct list_head list;
 };
 
-static inline void btrfs_set_trans_block_group(struct btrfs_trans_handle *trans,
-					       struct inode *inode)
-{
-	trans->block_group = BTRFS_I(inode)->block_group;
-}
-
-static inline void btrfs_update_inode_block_group(
-					  struct btrfs_trans_handle *trans,
-					  struct inode *inode)
-{
-	BTRFS_I(inode)->block_group = trans->block_group;
-}
-
 static inline void btrfs_set_inode_last_trans(struct btrfs_trans_handle *trans,
 					      struct inode *inode)
 {
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index a5303b8..8fff09a 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -158,8 +158,6 @@ int __btrfs_setxattr(struct btrfs_trans_handle *trans,
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	btrfs_set_trans_block_group(trans, inode);
-
 	ret = do_setxattr(trans, inode, name, value, size, flags);
 	if (ret)
 		goto out;
-- 
1.7.2.3

