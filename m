From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 08/10] btrfs: annotate btrfs_{start,join}_transaction failures
Date: Wed, 04 Nov 2009 14:03:54 -0500
Message-ID: <20091104190434.324983225@suse.com>
References: <20091104190346.971762946@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch locates and adds checks for failed transaction joins
and starts. It doesn't do anything other than use BTRFS_UERROR to
annotate them to keep the patch simple and obvious.

The next patch will add handling up the call chain where it's obvious.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

---
 fs/btrfs/disk-io.c     |    3 +++
 fs/btrfs/extent-tree.c |   11 +++++++----
 fs/btrfs/file.c        |    1 +
 fs/btrfs/inode.c       |   23 ++++++++++++++++++++---
 fs/btrfs/ioctl.c       |   10 ++++++----
 fs/btrfs/relocation.c  |   12 +++++++++++-
 fs/btrfs/super.c       |    1 +
 fs/btrfs/transaction.c |    3 +++
 fs/btrfs/tree-log.c    |    1 +
 fs/btrfs/volumes.c     |    6 ++++--
 fs/btrfs/xattr.c       |    1 +
 11 files changed, 58 insertions(+), 14 deletions(-)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1529,6 +1529,7 @@ static int transaction_kthread(void *arg
 		}
 		mutex_unlock(&root->fs_info->trans_mutex);
 		trans = btrfs_start_transaction(root, 1);
+		BTRFS_UERROR(!trans);
 		ret = btrfs_commit_transaction(trans, root);
 
 sleep:
@@ -2395,10 +2396,12 @@ int btrfs_commit_super(struct btrfs_root
 	btrfs_clean_old_snapshots(root);
 	mutex_unlock(&root->fs_info->cleaner_mutex);
 	trans = btrfs_start_transaction(root, 1);
+	BTRFS_UERROR(!trans);
 	ret = btrfs_commit_transaction(trans, root);
 	BUG_ON(ret);
 	/* run commit again to drop the original snapshot */
 	trans = btrfs_start_transaction(root, 1);
+	BTRFS_UERROR(!trans);
 	btrfs_commit_transaction(trans, root);
 	ret = btrfs_write_and_wait_transaction(NULL, root);
 	BUG_ON(ret);
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3272,7 +3272,7 @@ alloc:
 			committed = 1;
 			trans = btrfs_join_transaction(root, 1);
 			if (!trans)
-				return -ENOMEM;
+				return PTR_ERR(trans);
 			ret = btrfs_commit_transaction(trans, root);
 			if (ret)
 				return ret;
@@ -5396,6 +5396,7 @@ int btrfs_drop_snapshot(struct btrfs_roo
 	}
 
 	trans = btrfs_start_transaction(tree_root, 1);
+	BTRFS_UERROR(!trans);
 
 	if (btrfs_disk_key_objectid(&root_item->drop_progress) == 0) {
 		level = btrfs_header_level(root->node);
@@ -5492,6 +5493,7 @@ int btrfs_drop_snapshot(struct btrfs_roo
 
 			btrfs_end_transaction(trans, tree_root);
 			trans = btrfs_start_transaction(tree_root, 1);
+			BTRFS_UERROR(!trans);
 		} else {
 			unsigned long update;
 			update = trans->delayed_ref_updates;
@@ -6654,7 +6656,7 @@ int btrfs_drop_dead_reloc_roots(struct b
 		BUG_ON(reloc_root->commit_root != NULL);
 		while (1) {
 			trans = btrfs_join_transaction(root, 1);
-			BUG_ON(!trans);
+			BTRFS_UERROR(!trans);
 
 			mutex_lock(&root->fs_info->drop_mutex);
 			ret = btrfs_drop_snapshot(trans, reloc_root);
@@ -6712,7 +6714,7 @@ int btrfs_cleanup_reloc_trees(struct btr
 
 	if (found) {
 		trans = btrfs_start_transaction(root, 1);
-		BUG_ON(!trans);
+		BTRFS_UERROR(!trans);
 		ret = btrfs_commit_transaction(trans, root);
 		BUG_ON(ret);
 	}
@@ -6957,7 +6959,7 @@ static noinline int relocate_one_extent(
 
 
 	trans = btrfs_start_transaction(extent_root, 1);
-	BUG_ON(!trans);
+	BTRFS_UERROR(!trans);
 
 	if (extent_key->objectid == 0) {
 		ret = del_extent_zero(trans, extent_root, path, extent_key);
@@ -7140,6 +7142,7 @@ static int __alloc_chunk_for_shrink(stru
 		spin_unlock(&shrink_block_group->lock);
 
 		trans = btrfs_start_transaction(root, 1);
+		BTRFS_UERROR(!trans);
 		spin_lock(&shrink_block_group->lock);
 
 		new_alloc_flags = update_block_group_flags(root,
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1083,6 +1083,7 @@ out_nolock:
 
 		if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
 			trans = btrfs_start_transaction(root, 1);
+			BTRFS_UERROR(!trans);
 			ret = btrfs_log_dentry_safe(trans, root,
 						    file->f_dentry);
 			if (ret == 0) {
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -403,7 +403,7 @@ again:
 	}
 	if (start == 0) {
 		trans = btrfs_join_transaction(root, 1);
-		BUG_ON(!trans);
+		BTRFS_UERROR(!trans);
 		btrfs_set_trans_block_group(trans, inode);
 
 		/* lets try to make an inline extent */
@@ -550,6 +550,7 @@ static noinline int submit_compressed_ex
 		return 0;
 
 	trans = btrfs_join_transaction(root, 1);
+	BTRFS_UERROR(!trans);
 
 	while (!list_empty(&async_cow->extents)) {
 		async_extent = list_entry(async_cow->extents.next,
@@ -664,6 +665,7 @@ static noinline int submit_compressed_ex
 
 		BUG_ON(ret);
 		trans = btrfs_join_transaction(root, 1);
+		BTRFS_UERROR(!trans);
 		alloc_hint = ins.objectid + ins.offset;
 		kfree(async_extent);
 		cond_resched();
@@ -708,7 +710,7 @@ static noinline int cow_file_range(struc
 	int ret = 0;
 
 	trans = btrfs_join_transaction(root, 1);
-	BUG_ON(!trans);
+	BTRFS_UERROR(!trans);
 	btrfs_set_trans_block_group(trans, inode);
 
 	actual_end = min_t(u64, isize, end + 1);
@@ -990,7 +992,7 @@ static noinline int run_delalloc_nocow(s
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 	trans = btrfs_join_transaction(root, 1);
-	BUG_ON(!trans);
+	BTRFS_UERROR(!trans);
 
 	cow_start = (u64)-1;
 	cur_offset = start;
@@ -1709,6 +1711,7 @@ static int btrfs_finish_ordered_io(struc
 	}
 
 	trans = btrfs_join_transaction(root, 1);
+	BTRFS_UERROR(!trans);
 
 	if (!ordered_extent)
 		ordered_extent = btrfs_lookup_ordered_extent(inode, start);
@@ -2129,6 +2132,7 @@ void btrfs_orphan_cleanup(struct btrfs_r
 		 */
 		if (is_bad_inode(inode)) {
 			trans = btrfs_start_transaction(root, 1);
+			BTRFS_UERROR(!trans);
 			btrfs_orphan_del(trans, inode);
 			btrfs_end_transaction(trans, root);
 			iput(inode);
@@ -2482,6 +2486,7 @@ static int btrfs_unlink(struct inode *di
 	root = BTRFS_I(dir)->root;
 
 	trans = btrfs_start_transaction(root, 1);
+	BTRFS_UERROR(!trans);
 
 	btrfs_set_trans_block_group(trans, dir);
 
@@ -2577,6 +2582,7 @@ static int btrfs_rmdir(struct inode *dir
 		return -ENOTEMPTY;
 
 	trans = btrfs_start_transaction(root, 1);
+	BTRFS_UERROR(!trans);
 	btrfs_set_trans_block_group(trans, dir);
 
 	if (unlikely(inode->i_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
@@ -3152,6 +3158,7 @@ int btrfs_cont_expand(struct inode *inod
 	}
 
 	trans = btrfs_start_transaction(root, 1);
+	BTRFS_UERROR(!trans);
 	btrfs_set_trans_block_group(trans, inode);
 
 	cur_offset = hole_start;
@@ -3249,6 +3256,7 @@ void btrfs_delete_inode(struct inode *in
 
 	btrfs_i_size_write(inode, 0);
 	trans = btrfs_join_transaction(root, 1);
+	BTRFS_UERROR(!trans);
 
 	btrfs_set_trans_block_group(trans, inode);
 	ret = btrfs_truncate_inode_items(trans, root, inode, inode->i_size, 0);
@@ -3845,6 +3853,7 @@ int btrfs_write_inode(struct inode *inod
 
 	if (wait) {
 		trans = btrfs_join_transaction(root, 1);
+		BTRFS_UERROR(!trans);
 		btrfs_set_trans_block_group(trans, inode);
 		ret = btrfs_commit_transaction(trans, root);
 	}
@@ -3863,6 +3872,7 @@ void btrfs_dirty_inode(struct inode *ino
 	struct btrfs_trans_handle *trans;
 
 	trans = btrfs_join_transaction(root, 1);
+	BTRFS_UERROR(!trans);
 	btrfs_set_trans_block_group(trans, inode);
 	btrfs_update_inode(trans, root, inode);
 	btrfs_end_transaction(trans, root);
@@ -4156,6 +4166,7 @@ static int btrfs_mknod(struct inode *dir
 		return err;
 
 	trans = btrfs_start_transaction(root, 1);
+	err = -ENOMEM;
 	if (!trans)
 		goto fail;
 	btrfs_set_trans_block_group(trans, dir);
@@ -4226,6 +4237,7 @@ static int btrfs_create(struct inode *di
 		return err;
 
 	trans = btrfs_start_transaction(root, 1);
+	err = -ENOMEM;
 	if (!trans)
 		goto fail;
 	btrfs_set_trans_block_group(trans, dir);
@@ -4306,6 +4318,7 @@ static int btrfs_link(struct dentry *old
 		goto fail;
 
 	trans = btrfs_start_transaction(root, 1);
+	BTRFS_UERROR(!trans);
 
 	btrfs_set_trans_block_group(trans, dir);
 	atomic_inc(&inode->i_count);
@@ -4673,6 +4686,7 @@ again:
 				em = NULL;
 				btrfs_release_path(root, path);
 				trans = btrfs_join_transaction(root, 1);
+				BTRFS_UERROR(!trans);
 				goto again;
 			}
 			map = kmap(page);
@@ -5042,6 +5056,7 @@ static void btrfs_truncate(struct inode
 	btrfs_wait_ordered_range(inode, inode->i_size & (~mask), (u64)-1);
 
 	trans = btrfs_start_transaction(root, 1);
+	BTRFS_UERROR(!trans);
 
 	/*
 	 * setattr is responsible for setting the ordered_data_close flag,
@@ -5314,6 +5329,7 @@ static int btrfs_rename(struct inode *ol
 		down_read(&root->fs_info->subvol_sem);
 
 	trans = btrfs_start_transaction(root, 1);
+	BTRFS_UERROR(!trans);
 	btrfs_set_trans_block_group(trans, new_dir);
 
 	if (dest != root)
@@ -5494,6 +5510,7 @@ static int btrfs_symlink(struct inode *d
 		return err;
 
 	trans = btrfs_start_transaction(root, 1);
+	err = -ENOMEM;
 	if (!trans)
 		goto out_fail;
 	btrfs_set_trans_block_group(trans, dir);
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -199,7 +199,7 @@ static int btrfs_ioctl_setflags(struct f
 
 
 	trans = btrfs_join_transaction(root, 1);
-	BUG_ON(!trans);
+	BTRFS_UERROR(!trans);
 
 	ret = btrfs_update_inode(trans, root, inode);
 	BUG_ON(ret);
@@ -250,7 +250,7 @@ static noinline int create_subvol(struct
 		return ret;
 
 	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
+	BTRFS_UERROR(!trans);
 
 	ret = btrfs_find_free_objectid(trans, root->fs_info->tree_root,
 				       0, &objectid);
@@ -391,7 +391,7 @@ static int create_snapshot(struct btrfs_
 	pending_snapshot->name[namelen] = '\0';
 	pending_snapshot->dentry = dentry;
 	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
+	BTRFS_UERROR(!trans);
 	pending_snapshot->root = root;
 	list_add(&pending_snapshot->list,
 		 &trans->transaction->pending_snapshots);
@@ -639,6 +639,7 @@ static noinline int btrfs_ioctl_resize(s
 
 	if (new_size > old_size) {
 		trans = btrfs_start_transaction(root, 1);
+		BTRFS_UERROR(!trans);
 		ret = btrfs_grow_device(trans, device, new_size);
 		btrfs_commit_transaction(trans, root);
 	} else {
@@ -804,6 +805,7 @@ static noinline int btrfs_ioctl_snap_des
 		goto out_up_write;
 
 	trans = btrfs_start_transaction(root, 1);
+	BTRFS_UERROR(!trans);
 	ret = btrfs_unlink_subvol(trans, root, dir,
 				dest->root_key.objectid,
 				dentry->d_name.name,
@@ -1024,7 +1026,7 @@ static noinline long btrfs_ioctl_clone(s
 	}
 
 	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
+	BTRFS_UERROR(!trans);
 
 	/* punch hole in destination first */
 	btrfs_drop_extents(trans, root, inode, off, off + len,
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1638,6 +1638,7 @@ static noinline_for_stack int merge_relo
 
 	if (level == 0 && rc->stage == UPDATE_DATA_PTRS) {
 		trans = btrfs_start_transaction(root, 1);
+		BTRFS_UERROR(!trans);
 
 		leaf = path->nodes[0];
 		btrfs_item_key_to_cpu(leaf, &key, 0);
@@ -1664,6 +1665,7 @@ static noinline_for_stack int merge_relo
 		leaf = NULL;
 		replaced = 0;
 		trans = btrfs_start_transaction(root, 1);
+		BTRFS_UERROR(!trans);
 		max_level = level;
 
 		ret = walk_down_reloc_tree(reloc_root, path, &level);
@@ -1799,6 +1801,7 @@ static void merge_func(struct btrfs_work
 		merge_reloc_root(async->rc, root);
 
 		trans = btrfs_start_transaction(root, 1);
+		BTRFS_UERROR(!trans);
 		btrfs_update_reloc_root(trans, root);
 		btrfs_end_transaction(trans, root);
 	}
@@ -3291,10 +3294,12 @@ static noinline_for_stack int relocate_b
 	set_reloc_control(rc);
 
 	trans = btrfs_start_transaction(rc->extent_root, 1);
+	BTRFS_UERROR(!trans);
 	btrfs_commit_transaction(trans, rc->extent_root);
 
 	while (1) {
 		trans = btrfs_start_transaction(rc->extent_root, 1);
+		BTRFS_UERROR(!trans);
 
 		ret = find_next_extent(trans, rc, path);
 		if (ret < 0)
@@ -3405,6 +3410,7 @@ static noinline_for_stack int relocate_b
 
 	if (rc->extents_found > 0) {
 		trans = btrfs_start_transaction(rc->extent_root, 1);
+		BTRFS_UERROR(!trans);
 		btrfs_commit_transaction(trans, rc->extent_root);
 	}
 
@@ -3414,6 +3420,7 @@ static noinline_for_stack int relocate_b
 
 	/* get rid of pinned extents */
 	trans = btrfs_start_transaction(rc->extent_root, 1);
+	BTRFS_UERROR(!trans);
 	btrfs_commit_transaction(trans, rc->extent_root);
 
 	return err;
@@ -3469,7 +3476,7 @@ static struct inode *create_reloc_inode(
 		return ERR_CAST(root);
 
 	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
+	BTRFS_UERROR(!trans);
 
 	err = btrfs_find_free_objectid(trans, root, objectid, &objectid);
 	if (err)
@@ -3603,6 +3610,7 @@ static noinline_for_stack int mark_garba
 	int ret;
 
 	trans = btrfs_start_transaction(root->fs_info->tree_root, 1);
+	BTRFS_UERROR(!trans);
 
 	memset(&root->root_item.drop_progress, 0,
 		sizeof(root->root_item.drop_progress));
@@ -3730,6 +3738,7 @@ int btrfs_recover_relocation(struct btrf
 	}
 
 	trans = btrfs_start_transaction(rc->extent_root, 1);
+	BTRFS_UERROR(!trans);
 	btrfs_commit_transaction(trans, rc->extent_root);
 
 	merge_reloc_roots(rc);
@@ -3737,6 +3746,7 @@ int btrfs_recover_relocation(struct btrf
 	unset_reloc_control(rc);
 
 	trans = btrfs_start_transaction(rc->extent_root, 1);
+	BTRFS_UERROR(!trans);
 	btrfs_commit_transaction(trans, rc->extent_root);
 out:
 	if (rc) {
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -417,6 +417,7 @@ int btrfs_sync_fs(struct super_block *sb
 	btrfs_wait_ordered_extents(root, 0);
 
 	trans = btrfs_start_transaction(root, 1);
+	BTRFS_UERROR(!trans);
 	ret = btrfs_commit_transaction(trans, root);
 	return ret;
 }
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -630,6 +630,7 @@ int btrfs_defrag_root(struct btrfs_root
 	if (root->defrag_running)
 		return 0;
 	trans = btrfs_start_transaction(root, 1);
+	BTRFS_UERROR(!trans);
 	while (1) {
 		root->defrag_running = 1;
 		ret = btrfs_defrag_leaves(trans, root, cacheonly);
@@ -639,6 +640,7 @@ int btrfs_defrag_root(struct btrfs_root
 		cond_resched();
 
 		trans = btrfs_start_transaction(root, 1);
+		BTRFS_UERROR(!trans);
 		if (root->fs_info->closing || ret != -EAGAIN)
 			break;
 	}
@@ -812,6 +814,7 @@ static noinline int finish_pending_snaps
 	parent_inode = pending->dentry->d_parent->d_inode;
 	parent_root = BTRFS_I(parent_inode)->root;
 	trans = btrfs_join_transaction(parent_root, 1);
+	BTRFS_UERROR(!trans);
 
 	/*
 	 * insert the directory item
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3024,6 +3024,7 @@ int btrfs_recover_log_trees(struct btrfs
 	BUG_ON(!path);
 
 	trans = btrfs_start_transaction(fs_info->tree_root, 1);
+	BTRFS_UERROR(!trans);
 
 	wc.trans = trans;
 	wc.pin = 1;
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1090,6 +1090,7 @@ static int btrfs_rm_dev_item(struct btrf
 		return -ENOMEM;
 
 	trans = btrfs_start_transaction(root, 1);
+	BTRFS_UERROR(!trans);
 	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
 	key.type = BTRFS_DEV_ITEM_KEY;
 	key.offset = device->devid;
@@ -1480,6 +1481,7 @@ int btrfs_init_new_device(struct btrfs_r
 	}
 
 	trans = btrfs_start_transaction(root, 1);
+	BTRFS_UERROR(!trans);
 	lock_chunks(root);
 
 	device->barriers = 1;
@@ -1747,7 +1749,7 @@ static int btrfs_relocate_chunk(struct b
 	BUG_ON(ret);
 
 	trans = btrfs_start_transaction(root, 1);
-	BUG_ON(!trans);
+	BTRFS_UERROR(!trans);
 
 	lock_chunks(root);
 
@@ -1919,7 +1921,7 @@ int btrfs_balance(struct btrfs_root *dev
 		BUG_ON(ret);
 
 		trans = btrfs_start_transaction(dev_root, 1);
-		BUG_ON(!trans);
+		BTRFS_UERROR(!trans);
 
 		ret = btrfs_grow_device(trans, device, old_size);
 		BUG_ON(ret);
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -99,6 +99,7 @@ int __btrfs_setxattr(struct inode *inode
 		return -ENOMEM;
 
 	trans = btrfs_join_transaction(root, 1);
+	BTRFS_UERROR(!trans);
 	btrfs_set_trans_block_group(trans, inode);
 
 	/* first lets see if we already have this xattr */

