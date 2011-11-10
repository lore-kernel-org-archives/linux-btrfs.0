From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix our reservations for updating an inode when completing io V3
Date: Thu, 10 Nov 2011 17:57:07 -0500
Message-ID: <1320965827-1324-1-git-send-email-josef@redhat.com>
Cc: Josef Bacik <josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

People have been reporting ENOSPC crashes in finish_ordered_io.  This is because
we try to steal from the delalloc block rsv to satisfy a reservation to update
the inode.  The problem with this is we don't explicitly save space for updating
the inode when doing delalloc.  This is kind of a problem and we've gotten away
with this because way back when we just stole from the delalloc reserve without
any questions, and this worked out fine because generally speaking the leaf had
been modified either by the mtime update when we did the original write or
because we just updated the leaf when we inserted the file extent item, only on
rare occasions had the leaf not actually been modified, and that was still ok
because we'd just use a block or two out of the over-reservation that is
delalloc.

Then came the delayed inode stuff.  This is amazing, except it wants a full
reservation for updating the inode since it may do it at some point down the
road after we've written the blocks and we have to recow everything again.  This
worked out because the delayed inode stuff just stole from the global reserve,
that is until recently when I changed that because it caused other problems.

So here we are, we're doing everything right and being screwed for it.  So take
an extra reservation for the inode at delalloc reservation time and carry it
through the life of the delalloc reservation.  If we need it we can steal it in
the delayed inode stuff.  If we have already stolen it try and do a normal
metadata reservation.  If that fails try to steal from the delalloc reservation.
If _that_ fails we'll get a WARN_ON() so I can start thinking of a better way to
solve this and in the meantime we'll steal from the global reserve.

If we fail all of this, then we'll fall back to just updating the inode instead
of delaying it, since we shouldn't use that much space as we've just modified
the tree by inserting the file extent item.

With this patch I ran xfstests 13 in a loop for a couple of hours and didn't see
any problems.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V2->V3: lxo hit one of my "we should never hit this" BUG()'s with V2.  It is
possible we could have stolen all of our extra reservations, so add an option to
btrfs_update_inode to fall back to the direct update of the inode, so in the
endio case we can make sure we update the inode and don't get ENOSPC.

 fs/btrfs/btrfs_inode.h      |    4 +--
 fs/btrfs/ctree.h            |    4 +-
 fs/btrfs/delayed-inode.c    |   58 ++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/extent-tree.c      |   24 +++++++++++++++---
 fs/btrfs/free-space-cache.c |    4 +-
 fs/btrfs/inode-map.c        |    2 +-
 fs/btrfs/inode.c            |   47 +++++++++++++++++++---------------
 fs/btrfs/ioctl.c            |    6 ++--
 fs/btrfs/transaction.c      |    2 +-
 fs/btrfs/tree-log.c         |    8 +++---
 fs/btrfs/xattr.c            |    2 +-
 11 files changed, 118 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 5a5d325..634608d 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -147,14 +147,12 @@ struct btrfs_inode {
 	 * the btrfs file release call will add this inode to the
 	 * ordered operations list so that we make sure to flush out any
 	 * new data the application may have written before commit.
-	 *
-	 * yes, its silly to have a single bitflag, but we might grow more
-	 * of these.
 	 */
 	unsigned ordered_data_close:1;
 	unsigned orphan_meta_reserved:1;
 	unsigned dummy_inode:1;
 	unsigned in_defrag:1;
+	unsigned delalloc_meta_reserved:1;
 
 	/*
 	 * always compress this one file
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b9ba59f..5e7eca6 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2699,8 +2699,8 @@ struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
 				    size_t pg_offset, u64 start, u64 end,
 				    int create);
 int btrfs_update_inode(struct btrfs_trans_handle *trans,
-			      struct btrfs_root *root,
-			      struct inode *inode);
+		       struct btrfs_root *root, struct inode *inode,
+		       int fallback);
 int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode);
 int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode);
 int btrfs_orphan_cleanup(struct btrfs_root *root);
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index bbe8496..d4fadb2 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -617,12 +617,14 @@ static void btrfs_delayed_item_release_metadata(struct btrfs_root *root,
 static int btrfs_delayed_inode_reserve_metadata(
 					struct btrfs_trans_handle *trans,
 					struct btrfs_root *root,
+					struct inode *inode,
 					struct btrfs_delayed_node *node)
 {
 	struct btrfs_block_rsv *src_rsv;
 	struct btrfs_block_rsv *dst_rsv;
 	u64 num_bytes;
 	int ret;
+	int release = false;
 
 	src_rsv = trans->block_rsv;
 	dst_rsv = &root->fs_info->delayed_block_rsv;
@@ -652,12 +654,65 @@ static int btrfs_delayed_inode_reserve_metadata(
 		if (!ret)
 			node->bytes_reserved = num_bytes;
 		return ret;
+	} else if (src_rsv == &root->fs_info->delalloc_block_rsv) {
+		spin_lock(&BTRFS_I(inode)->lock);
+		if (BTRFS_I(inode)->delalloc_meta_reserved) {
+			BTRFS_I(inode)->delalloc_meta_reserved = 0;
+			spin_unlock(&BTRFS_I(inode)->lock);
+			release = true;
+			goto migrate;
+		}
+		spin_unlock(&BTRFS_I(inode)->lock);
+
+		/* Ok we didn't have space pre-reserved.  This shouldn't happen
+		 * too often but it can happen if we do delalloc to an existing
+		 * inode which gets dirtied because of the time update, and then
+		 * isn't touched again until after the transaction commits and
+		 * then we try to write out the data.  First try to be nice and
+		 * reserve something strictly for us.  If not be a pain and try
+		 * to steal from the delalloc block rsv.
+		 */
+		ret = btrfs_block_rsv_add_noflush(root, dst_rsv, num_bytes);
+		if (!ret)
+			goto out;
+
+		ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
+		if (!ret)
+			goto out;
+
+		/*
+		 * Ok this is a problem, let's just steal from the global rsv
+		 * since this really shouldn't happen that often.
+		 */
+		WARN_ON(1);
+		ret = btrfs_block_rsv_migrate(&root->fs_info->global_block_rsv,
+					      dst_rsv, num_bytes);
+		goto out;
 	}
 
+migrate:
 	ret = btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes);
 	if (!ret)
 		node->bytes_reserved = num_bytes;
 
+out:
+	/*
+	 * Migrate only takes a reservation, it doesn't touch the size of the
+	 * block_rsv.  This is to simplify people who don't normally have things
+	 * migrated from their block rsv.  If they go to release their
+	 * reservation, that will decrease the size as well, so if migrate
+	 * reduced size we'd end up with a negative size.  But for the
+	 * delalloc_meta_reserved stuff we will only know to drop 1 reservation,
+	 * but we could in fact do this reserve/migrate dance several times
+	 * between the time we did the original reservation and we'd clean it
+	 * up.  So to take care of this, release the space for the meta
+	 * reservation here.  I think it may be time for a documentation page on
+	 * how block rsvs. work.
+	 */
+	if (release)
+		btrfs_block_rsv_release(root, src_rsv, num_bytes);
+	node->bytes_reserved = num_bytes;
+
 	return ret;
 }
 
@@ -1708,7 +1763,8 @@ int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
 		goto release_node;
 	}
 
-	ret = btrfs_delayed_inode_reserve_metadata(trans, root, delayed_node);
+	ret = btrfs_delayed_inode_reserve_metadata(trans, root, inode,
+						   delayed_node);
 	if (ret)
 		goto release_node;
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 18ea90c..5a4f423 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2731,7 +2731,7 @@ again:
 	 * time.
 	 */
 	BTRFS_I(inode)->generation = 0;
-	ret = btrfs_update_inode(trans, root, inode);
+	ret = btrfs_update_inode(trans, root, inode, 0);
 	WARN_ON(ret);
 
 	if (i_size_read(inode) > 0) {
@@ -4063,23 +4063,30 @@ int btrfs_snap_reserve_metadata(struct btrfs_trans_handle *trans,
  */
 static unsigned drop_outstanding_extent(struct inode *inode)
 {
+	unsigned drop_inode_space = 0;
 	unsigned dropped_extents = 0;
 
 	BUG_ON(!BTRFS_I(inode)->outstanding_extents);
 	BTRFS_I(inode)->outstanding_extents--;
 
+	if (BTRFS_I(inode)->outstanding_extents == 0 &&
+	    BTRFS_I(inode)->delalloc_meta_reserved) {
+		drop_inode_space = 1;
+		BTRFS_I(inode)->delalloc_meta_reserved = 0;
+	}
+
 	/*
 	 * If we have more or the same amount of outsanding extents than we have
 	 * reserved then we need to leave the reserved extents count alone.
 	 */
 	if (BTRFS_I(inode)->outstanding_extents >=
 	    BTRFS_I(inode)->reserved_extents)
-		return 0;
+		return drop_inode_space;
 
 	dropped_extents = BTRFS_I(inode)->reserved_extents -
 		BTRFS_I(inode)->outstanding_extents;
 	BTRFS_I(inode)->reserved_extents -= dropped_extents;
-	return dropped_extents;
+	return dropped_extents + drop_inode_space;
 }
 
 /**
@@ -4165,9 +4172,18 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 		nr_extents = BTRFS_I(inode)->outstanding_extents -
 			BTRFS_I(inode)->reserved_extents;
 		BTRFS_I(inode)->reserved_extents += nr_extents;
+	}
 
-		to_reserve = btrfs_calc_trans_metadata_size(root, nr_extents);
+	/*
+	 * Add an item to reserve for updating the inode when we complete the
+	 * delalloc io.
+	 */
+	if (!BTRFS_I(inode)->delalloc_meta_reserved) {
+		nr_extents++;
+		BTRFS_I(inode)->delalloc_meta_reserved = 1;
 	}
+
+	to_reserve = btrfs_calc_trans_metadata_size(root, nr_extents);
 	to_reserve += calc_csum_metadata_size(inode, num_bytes, 1);
 	spin_unlock(&BTRFS_I(inode)->lock);
 
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 7a15fcf..043f96b 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -234,7 +234,7 @@ int btrfs_truncate_free_space_cache(struct btrfs_root *root,
 		return ret;
 	}
 
-	ret = btrfs_update_inode(trans, root, inode);
+	ret = btrfs_update_inode(trans, root, inode, 0);
 	trans->block_rsv = rsv;
 
 	return ret;
@@ -1008,7 +1008,7 @@ out:
 		invalidate_inode_pages2(inode->i_mapping);
 		BTRFS_I(inode)->generation = 0;
 	}
-	btrfs_update_inode(trans, root, inode);
+	btrfs_update_inode(trans, root, inode, 0);
 	return err;
 
 out_nospc:
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 53dcbdf..c4daa62 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -439,7 +439,7 @@ again:
 	}
 
 	BTRFS_I(inode)->generation = 0;
-	ret = btrfs_update_inode(trans, root, inode);
+	ret = btrfs_update_inode(trans, root, inode, 0);
 	WARN_ON(ret);
 
 	if (i_size_read(inode) > 0) {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9d0eaa5..c814898 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -203,7 +203,7 @@ static noinline int insert_inline_extent(struct btrfs_trans_handle *trans,
 	 * could end up racing with unlink.
 	 */
 	BTRFS_I(inode)->disk_i_size = inode->i_size;
-	btrfs_update_inode(trans, root, inode);
+	btrfs_update_inode(trans, root, inode, 0);
 
 	return 0;
 fail:
@@ -1741,7 +1741,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 				trans = btrfs_join_transaction(root);
 			BUG_ON(IS_ERR(trans));
 			trans->block_rsv = &root->fs_info->delalloc_block_rsv;
-			ret = btrfs_update_inode(trans, root, inode);
+			ret = btrfs_update_inode(trans, root, inode, 1);
 			BUG_ON(ret);
 		}
 		goto out;
@@ -1791,7 +1791,7 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 
 	ret = btrfs_ordered_update_i_size(inode, 0, ordered_extent);
 	if (!ret || !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags)) {
-		ret = btrfs_update_inode(trans, root, inode);
+		ret = btrfs_update_inode(trans, root, inode, 1);
 		BUG_ON(ret);
 	}
 	ret = 0;
@@ -2427,7 +2427,8 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
  * copy everything in the in-memory inode into the btree.
  */
 noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root, struct inode *inode)
+				struct btrfs_root *root, struct inode *inode,
+				int fallback)
 {
 	struct btrfs_inode_item *inode_item;
 	struct btrfs_path *path;
@@ -2446,9 +2447,12 @@ noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
 		ret = btrfs_delayed_update_inode(trans, root, inode);
 		if (!ret)
 			btrfs_set_inode_last_trans(trans, inode);
+		if (ret && fallback)
+			goto update;
 		return ret;
 	}
 
+update:
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
@@ -2547,7 +2551,7 @@ err:
 
 	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
 	inode->i_ctime = dir->i_mtime = dir->i_ctime = CURRENT_TIME;
-	btrfs_update_inode(trans, root, dir);
+	btrfs_update_inode(trans, root, dir, 0);
 out:
 	return ret;
 }
@@ -2561,7 +2565,7 @@ int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	ret = __btrfs_unlink_inode(trans, root, dir, inode, name, name_len);
 	if (!ret) {
 		btrfs_drop_nlink(inode);
-		ret = btrfs_update_inode(trans, root, inode);
+		ret = btrfs_update_inode(trans, root, inode, 0);
 	}
 	return ret;
 }
@@ -2862,7 +2866,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 
 	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
-	ret = btrfs_update_inode(trans, root, dir);
+	ret = btrfs_update_inode(trans, root, dir, 0);
 	BUG_ON(ret);
 
 	btrfs_free_path(path);
@@ -4189,7 +4193,7 @@ void btrfs_dirty_inode(struct inode *inode, int flags)
 	trans = btrfs_join_transaction(root);
 	BUG_ON(IS_ERR(trans));
 
-	ret = btrfs_update_inode(trans, root, inode);
+	ret = btrfs_update_inode(trans, root, inode, 0);
 	if (ret && ret == -ENOSPC) {
 		/* whoops, lets try again with the full transaction */
 		btrfs_end_transaction(trans, root);
@@ -4202,7 +4206,7 @@ void btrfs_dirty_inode(struct inode *inode, int flags)
 			return;
 		}
 
-		ret = btrfs_update_inode(trans, root, inode);
+		ret = btrfs_update_inode(trans, root, inode, 0);
 		if (ret) {
 			printk_ratelimited(KERN_ERR "btrfs: fail to "
 				       "dirty  inode %llu error %d\n",
@@ -4465,7 +4469,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 		btrfs_i_size_write(parent_inode, parent_inode->i_size +
 				   name_len * 2);
 		parent_inode->i_mtime = parent_inode->i_ctime = CURRENT_TIME;
-		ret = btrfs_update_inode(trans, root, parent_inode);
+		ret = btrfs_update_inode(trans, root, parent_inode, 0);
 	}
 	return ret;
 }
@@ -4534,7 +4538,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	else {
 		inode->i_op = &btrfs_special_inode_operations;
 		init_special_inode(inode, inode->i_mode, rdev);
-		btrfs_update_inode(trans, root, inode);
+		btrfs_update_inode(trans, root, inode, 0);
 	}
 out_unlock:
 	nr = trans->blocks_used;
@@ -4650,7 +4654,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 		drop_inode = 1;
 	} else {
 		struct dentry *parent = dentry->d_parent;
-		err = btrfs_update_inode(trans, root, inode);
+		err = btrfs_update_inode(trans, root, inode, 0);
 		BUG_ON(err);
 		btrfs_log_new_name(trans, inode, NULL, parent);
 	}
@@ -4708,7 +4712,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	inode->i_fop = &btrfs_dir_file_operations;
 
 	btrfs_i_size_write(inode, 0);
-	err = btrfs_update_inode(trans, root, inode);
+	err = btrfs_update_inode(trans, root, inode, 0);
 	if (err)
 		goto out_fail;
 
@@ -5632,7 +5636,7 @@ again:
 	if (test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags)) {
 		ret = btrfs_ordered_update_i_size(inode, 0, ordered);
 		if (!ret)
-			err = btrfs_update_inode(trans, root, inode);
+			err = btrfs_update_inode(trans, root, inode, 1);
 		goto out;
 	}
 
@@ -5670,7 +5674,7 @@ again:
 	add_pending_csums(trans, inode, ordered->file_offset, &ordered->list);
 	ret = btrfs_ordered_update_i_size(inode, 0, ordered);
 	if (!ret || !test_bit(BTRFS_ORDERED_PREALLOC, &ordered->flags))
-		btrfs_update_inode(trans, root, inode);
+		btrfs_update_inode(trans, root, inode, 1);
 	ret = 0;
 out_unlock:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, ordered->file_offset,
@@ -6504,7 +6508,7 @@ static int btrfs_truncate(struct inode *inode)
 		}
 
 		trans->block_rsv = &root->fs_info->trans_block_rsv;
-		ret = btrfs_update_inode(trans, root, inode);
+		ret = btrfs_update_inode(trans, root, inode, 0);
 		if (ret) {
 			err = ret;
 			break;
@@ -6530,7 +6534,7 @@ end_trans:
 	}
 
 	trans->block_rsv = &root->fs_info->trans_block_rsv;
-	ret = btrfs_update_inode(trans, root, inode);
+	ret = btrfs_update_inode(trans, root, inode, 0);
 	if (ret && !err)
 		err = ret;
 
@@ -6567,7 +6571,7 @@ int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
 	inode->i_nlink = 1;
 	btrfs_i_size_write(inode, 0);
 
-	err = btrfs_update_inode(trans, new_root, inode);
+	err = btrfs_update_inode(trans, new_root, inode, 0);
 	BUG_ON(err);
 
 	iput(inode);
@@ -6605,6 +6609,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->orphan_meta_reserved = 0;
 	ei->dummy_inode = 0;
 	ei->in_defrag = 0;
+	ei->delalloc_meta_reserved = 0;
 	ei->force_compress = BTRFS_COMPRESS_NONE;
 
 	ei->delayed_node = NULL;
@@ -6898,7 +6903,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 					old_dentry->d_name.name,
 					old_dentry->d_name.len);
 		if (!ret)
-			ret = btrfs_update_inode(trans, root, old_inode);
+			ret = btrfs_update_inode(trans, root, old_inode, 0);
 	}
 	BUG_ON(ret);
 
@@ -7095,7 +7100,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	inode->i_mapping->backing_dev_info = &root->fs_info->bdi;
 	inode_set_bytes(inode, name_len);
 	btrfs_i_size_write(inode, name_len - 1);
-	err = btrfs_update_inode(trans, root, inode);
+	err = btrfs_update_inode(trans, root, inode, 0);
 	if (err)
 		drop_inode = 1;
 
@@ -7167,7 +7172,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 			btrfs_ordered_update_i_size(inode, i_size, NULL);
 		}
 
-		ret = btrfs_update_inode(trans, root, inode);
+		ret = btrfs_update_inode(trans, root, inode, 0);
 		BUG_ON(ret);
 
 		if (own_trans)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4a34c47..f10bdfd 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -252,7 +252,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	trans = btrfs_join_transaction(root);
 	BUG_ON(IS_ERR(trans));
 
-	ret = btrfs_update_inode(trans, root, inode);
+	ret = btrfs_update_inode(trans, root, inode, 0);
 	BUG_ON(ret);
 
 	btrfs_update_iflags(inode);
@@ -434,7 +434,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 		goto fail;
 
 	btrfs_i_size_write(dir, dir->i_size + namelen * 2);
-	ret = btrfs_update_inode(trans, root, dir);
+	ret = btrfs_update_inode(trans, root, dir, 0);
 	BUG_ON(ret);
 
 	ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
@@ -2488,7 +2488,7 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 			if (endoff > inode->i_size)
 				btrfs_i_size_write(inode, endoff);
 
-			ret = btrfs_update_inode(trans, root, inode);
+			ret = btrfs_update_inode(trans, root, inode, 0);
 			BUG_ON(ret);
 			btrfs_end_transaction(trans, root);
 		}
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 960835e..889ee8a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -915,7 +915,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 
 	btrfs_i_size_write(parent_inode, parent_inode->i_size +
 					 dentry->d_name.len * 2);
-	ret = btrfs_update_inode(trans, parent_root, parent_inode);
+	ret = btrfs_update_inode(trans, parent_root, parent_inode, 0);
 	BUG_ON(ret);
 
 	/*
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f4d81c0..896e2dc 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -639,7 +639,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	}
 
 	inode_set_bytes(inode, saved_nbytes);
-	btrfs_update_inode(trans, root, inode);
+	btrfs_update_inode(trans, root, inode, 0);
 out:
 	if (inode)
 		iput(inode);
@@ -936,7 +936,7 @@ insert:
 			     btrfs_inode_ref_index(eb, ref));
 	BUG_ON(ret);
 
-	btrfs_update_inode(trans, root, inode);
+	btrfs_update_inode(trans, root, inode, 0);
 
 out:
 	ref_ptr = (unsigned long)(ref + 1) + namelen;
@@ -1032,7 +1032,7 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 	if (nlink != inode->i_nlink) {
 		inode->i_nlink = nlink;
-		btrfs_update_inode(trans, root, inode);
+		btrfs_update_inode(trans, root, inode, 0);
 	}
 	BTRFS_I(inode)->index_cnt = (u64)-1;
 
@@ -1132,7 +1132,7 @@ static noinline int link_to_fixup_dir(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 	if (ret == 0) {
 		btrfs_inc_nlink(inode);
-		btrfs_update_inode(trans, root, inode);
+		btrfs_update_inode(trans, root, inode, 0);
 	} else if (ret == -EEXIST) {
 		ret = 0;
 	} else {
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index a76e41c..93d0c75 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -197,7 +197,7 @@ int __btrfs_setxattr(struct btrfs_trans_handle *trans,
 		goto out;
 
 	inode->i_ctime = CURRENT_TIME;
-	ret = btrfs_update_inode(trans, root, inode);
+	ret = btrfs_update_inode(trans, root, inode, 0);
 	BUG_ON(ret);
 out:
 	btrfs_end_transaction_throttle(trans, root);
-- 
1.7.6.4

