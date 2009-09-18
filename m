From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 4/4] add snapshot/subvolume destroy ioctl
Date: Fri, 18 Sep 2009 20:19:05 +0800
Message-ID: <4AB37AB9.3060401@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds snapshot/subvolume destroy ioctl. Subvolume that
isn't being used and doesn't contains links to other subvolumes
can be destroyed.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 4/fs/btrfs/ctree.h 5/fs/btrfs/ctree.h
--- 4/fs/btrfs/ctree.h	2009-09-18 15:48:21.807350311 +0800
+++ 5/fs/btrfs/ctree.h	2009-09-17 12:17:05.641608000 +0800
@@ -828,11 +828,7 @@ struct btrfs_fs_info {
 	struct mutex transaction_kthread_mutex;
 	struct mutex cleaner_mutex;
 	struct mutex chunk_mutex;
-	struct mutex drop_mutex;
 	struct mutex volume_mutex;
-	struct mutex tree_reloc_mutex;
-	struct rw_semaphore extent_commit_sem;
-
 	/*
 	 * this protects the ordered operations list only while we are
 	 * processing all of the entries on it.  This way we make
@@ -842,6 +838,12 @@ struct btrfs_fs_info {
 	 */
 	struct mutex ordered_operations_mutex;
 
+	struct rw_semaphore extent_commit_sem;
+
+	struct rw_semaphore subvol_sem;
+
+	struct srcu_struct subvol_srcu;
+
 	struct list_head trans_list;
 	struct list_head hashers;
 	struct list_head dead_roots;
@@ -2131,6 +2133,7 @@ int btrfs_find_last_root(struct btrfs_ro
 int btrfs_search_root(struct btrfs_root *root, u64 search_start,
 		      u64 *found_objectid);
 int btrfs_find_dead_roots(struct btrfs_root *root, u64 objectid);
+int btrfs_find_orphan_roots(struct btrfs_root *tree_root);
 int btrfs_set_root_node(struct btrfs_root_item *item,
 			struct extent_buffer *node);
 /* dir-item.c */
@@ -2262,7 +2265,7 @@ int btrfs_set_extent_delalloc(struct ino
 int btrfs_writepages(struct address_space *mapping,
 		     struct writeback_control *wbc);
 int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *new_root, struct dentry *dentry,
+			     struct btrfs_root *new_root,
 			     u64 new_dirid, u64 alloc_hint);
 int btrfs_merge_bio_hook(struct page *page, unsigned long offset,
 			 size_t size, struct bio *bio, unsigned long bio_flags);
@@ -2278,6 +2281,7 @@ int btrfs_write_inode(struct inode *inod
 void btrfs_dirty_inode(struct inode *inode);
 struct inode *btrfs_alloc_inode(struct super_block *sb);
 void btrfs_destroy_inode(struct inode *inode);
+void btrfs_drop_inode(struct inode *inode);
 int btrfs_init_cachep(void);
 void btrfs_destroy_cachep(void);
 long btrfs_ioctl_trans_end(struct file *file);
@@ -2295,6 +2299,8 @@ int btrfs_orphan_add(struct btrfs_trans_
 int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode);
 void btrfs_orphan_cleanup(struct btrfs_root *root);
 int btrfs_cont_expand(struct inode *inode, loff_t size);
+int btrfs_invalidate_inodes(struct btrfs_root *root);
+extern struct dentry_operations btrfs_dentry_operations;
 
 /* ioctl.c */
 long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
diff -urp 4/fs/btrfs/disk-io.c 5/fs/btrfs/disk-io.c
--- 4/fs/btrfs/disk-io.c	2009-09-18 15:47:37.111351060 +0800
+++ 5/fs/btrfs/disk-io.c	2009-09-17 15:56:51.819715000 +0800
@@ -1378,8 +1378,10 @@ static int setup_bdi(struct btrfs_fs_inf
 
 	err = bdi_register(bdi, NULL, "btrfs-%d",
 				atomic_inc_return(&btrfs_bdi_num));
-	if (err)
+	if (err) {
+		bdi_destroy(bdi);
 		return err;
+	}
 
 	bdi->ra_pages	= default_backing_dev_info.ra_pages;
 	bdi->unplug_io_fn	= btrfs_unplug_io_fn;
@@ -1469,9 +1471,12 @@ static int cleaner_kthread(void *arg)
 			break;
 
 		vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);
-		mutex_lock(&root->fs_info->cleaner_mutex);
-		btrfs_clean_old_snapshots(root);
-		mutex_unlock(&root->fs_info->cleaner_mutex);
+
+		if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
+		    mutex_trylock(&root->fs_info->cleaner_mutex)) {
+			btrfs_clean_old_snapshots(root);
+			mutex_unlock(&root->fs_info->cleaner_mutex);
+		}
 
 		if (freezing(current)) {
 			refrigerator();
@@ -1576,7 +1581,26 @@ struct btrfs_root *open_ctree(struct sup
 		err = -ENOMEM;
 		goto fail;
 	}
-	INIT_RADIX_TREE(&fs_info->fs_roots_radix, GFP_NOFS);
+
+	ret = init_srcu_struct(&fs_info->subvol_srcu);
+	if (ret) {
+		err = ret;
+		goto fail;
+	}
+
+	ret = setup_bdi(fs_info, &fs_info->bdi);
+	if (ret) {
+		err = ret;
+		goto fail_srcu;
+	}
+
+	fs_info->btree_inode = new_inode(sb);
+	if (!fs_info->btree_inode) {
+		err = -ENOMEM;
+		goto fail_bdi;
+	}
+
+	INIT_RADIX_TREE(&fs_info->fs_roots_radix, GFP_ATOMIC);
 	INIT_LIST_HEAD(&fs_info->trans_list);
 	INIT_LIST_HEAD(&fs_info->dead_roots);
 	INIT_LIST_HEAD(&fs_info->hashers);
@@ -1585,6 +1609,7 @@ struct btrfs_root *open_ctree(struct sup
 	spin_lock_init(&fs_info->delalloc_lock);
 	spin_lock_init(&fs_info->new_trans_lock);
 	spin_lock_init(&fs_info->ref_cache_lock);
+	spin_lock_init(&fs_info->fs_roots_radix_lock);
 
 	init_completion(&fs_info->kobj_unregister);
 	fs_info->tree_root = tree_root;
@@ -1603,11 +1628,6 @@ struct btrfs_root *open_ctree(struct sup
 	fs_info->sb = sb;
 	fs_info->max_extent = (u64)-1;
 	fs_info->max_inline = 8192 * 1024;
-	if (setup_bdi(fs_info, &fs_info->bdi))
-		goto fail_bdi;
-	fs_info->btree_inode = new_inode(sb);
-	fs_info->btree_inode->i_ino = 1;
-	fs_info->btree_inode->i_nlink = 1;
 	fs_info->metadata_ratio = 8;
 
 	fs_info->thread_pool_size = min_t(unsigned long,
@@ -1619,6 +1639,8 @@ struct btrfs_root *open_ctree(struct sup
 	sb->s_blocksize = 4096;
 	sb->s_blocksize_bits = blksize_bits(4096);
 
+	fs_info->btree_inode->i_ino = BTRFS_BTREE_INODE_OBJECTID;
+	fs_info->btree_inode->i_nlink = 1;
 	/*
 	 * we set the i_size on the btree inode to the max possible int.
 	 * the real end of the address space is determined by all of
@@ -1637,6 +1659,11 @@ struct btrfs_root *open_ctree(struct sup
 
 	BTRFS_I(fs_info->btree_inode)->io_tree.ops = &btree_extent_io_ops;
 
+	BTRFS_I(fs_info->btree_inode)->root = tree_root;
+	memset(&BTRFS_I(fs_info->btree_inode)->location, 0,
+	       sizeof(struct btrfs_key));
+	BTRFS_I(fs_info->btree_inode)->dummy_inode = 1;
+
 	spin_lock_init(&fs_info->block_group_cache_lock);
 	fs_info->block_group_cache_tree.rb_node = NULL;
 
@@ -1644,21 +1671,16 @@ struct btrfs_root *open_ctree(struct sup
 			     fs_info->btree_inode->i_mapping, GFP_NOFS);
 	fs_info->do_barriers = 1;
 
-	BTRFS_I(fs_info->btree_inode)->root = tree_root;
-	memset(&BTRFS_I(fs_info->btree_inode)->location, 0,
-	       sizeof(struct btrfs_key));
-	insert_inode_hash(fs_info->btree_inode);
 
 	mutex_init(&fs_info->trans_mutex);
 	mutex_init(&fs_info->ordered_operations_mutex);
 	mutex_init(&fs_info->tree_log_mutex);
-	mutex_init(&fs_info->drop_mutex);
 	mutex_init(&fs_info->chunk_mutex);
 	mutex_init(&fs_info->transaction_kthread_mutex);
 	mutex_init(&fs_info->cleaner_mutex);
 	mutex_init(&fs_info->volume_mutex);
-	mutex_init(&fs_info->tree_reloc_mutex);
 	init_rwsem(&fs_info->extent_commit_sem);
+	init_rwsem(&fs_info->subvol_sem);
 
 	btrfs_init_free_cluster(&fs_info->meta_alloc_cluster);
 	btrfs_init_free_cluster(&fs_info->data_alloc_cluster);
@@ -1937,6 +1959,9 @@ printk("thread pool is %d\n", fs_info->t
 		}
 	}
 
+	ret = btrfs_find_orphan_roots(tree_root);
+	BUG_ON(ret);
+
 	if (!(sb->s_flags & MS_RDONLY)) {
 		ret = btrfs_recover_relocation(tree_root);
 		BUG_ON(ret);
@@ -1996,6 +2021,8 @@ fail_iput:
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
 fail_bdi:
 	bdi_destroy(&fs_info->bdi);
+fail_srcu:
+	cleanup_srcu_struct(&fs_info->subvol_srcu);
 fail:
 	kfree(extent_root);
 	kfree(tree_root);
@@ -2259,6 +2286,10 @@ int btrfs_free_fs_root(struct btrfs_fs_i
 	radix_tree_delete(&fs_info->fs_roots_radix,
 			  (unsigned long)root->root_key.objectid);
 	spin_unlock(&fs_info->fs_roots_radix_lock);
+
+	if (btrfs_root_refs(&root->root_item) == 0)
+		synchronize_srcu(&fs_info->subvol_srcu);
+
 	free_fs_root(root);
 	return 0;
 }
@@ -2282,6 +2313,20 @@ static int del_fs_roots(struct btrfs_fs_
 	struct btrfs_root *gang[8];
 	int i;
 
+	while (!list_empty(&fs_info->dead_roots)) {
+		gang[0] = list_entry(fs_info->dead_roots.next,
+				     struct btrfs_root, root_list);
+		list_del(&gang[0]->root_list);
+
+		if (gang[0]->in_radix) {
+			btrfs_free_fs_root(fs_info, gang[0]);
+		} else {
+			free_extent_buffer(gang[0]->node);
+			free_extent_buffer(gang[0]->commit_root);
+			kfree(gang[0]);
+		}
+	}
+
 	while (1) {
 		ret = radix_tree_gang_lookup(&fs_info->fs_roots_radix,
 					     (void **)gang, 0,
@@ -2311,9 +2356,6 @@ int btrfs_cleanup_fs_roots(struct btrfs_
 		root_objectid = gang[ret - 1]->root_key.objectid + 1;
 		for (i = 0; i < ret; i++) {
 			root_objectid = gang[i]->root_key.objectid;
-			ret = btrfs_find_dead_roots(fs_info->tree_root,
-						    root_objectid);
-			BUG_ON(ret);
 			btrfs_orphan_cleanup(gang[i]);
 		}
 		root_objectid++;
@@ -2402,6 +2444,7 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_mapping_tree_free(&fs_info->mapping_tree);
 
 	bdi_destroy(&fs_info->bdi);
+	cleanup_srcu_struct(&fs_info->subvol_srcu);
 
 	kfree(fs_info->extent_root);
 	kfree(fs_info->tree_root);
diff -urp 4/fs/btrfs/export.c 5/fs/btrfs/export.c
--- 4/fs/btrfs/export.c	2009-07-27 08:40:03.372530000 +0800
+++ 5/fs/btrfs/export.c	2009-09-17 11:54:44.813935000 +0800
@@ -28,7 +28,7 @@ static int btrfs_encode_fh(struct dentry
 	len  = BTRFS_FID_SIZE_NON_CONNECTABLE;
 	type = FILEID_BTRFS_WITHOUT_PARENT;
 
-	fid->objectid = BTRFS_I(inode)->location.objectid;
+	fid->objectid = inode->i_ino;
 	fid->root_objectid = BTRFS_I(inode)->root->objectid;
 	fid->gen = inode->i_generation;
 
@@ -60,34 +60,61 @@ static int btrfs_encode_fh(struct dentry
 }
 
 static struct dentry *btrfs_get_dentry(struct super_block *sb, u64 objectid,
-				       u64 root_objectid, u32 generation)
+				       u64 root_objectid, u32 generation,
+				       int check_generation)
 {
+	struct btrfs_fs_info *fs_info = btrfs_sb(sb)->fs_info;
 	struct btrfs_root *root;
+	struct dentry *dentry;
 	struct inode *inode;
 	struct btrfs_key key;
+	int index;
+	int err = 0;
+
+	if (objectid < BTRFS_FIRST_FREE_OBJECTID)
+		return ERR_PTR(-ESTALE);
 
 	key.objectid = root_objectid;
 	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
 	key.offset = (u64)-1;
 
-	root = btrfs_read_fs_root_no_name(btrfs_sb(sb)->fs_info, &key);
-	if (IS_ERR(root))
-		return ERR_CAST(root);
+	index = srcu_read_lock(&fs_info->subvol_srcu);
+
+	root = btrfs_read_fs_root_no_name(fs_info, &key);
+	if (IS_ERR(root)) {
+		err = PTR_ERR(root);
+		goto fail;
+	}
+
+	if (btrfs_root_refs(&root->root_item) == 0) {
+		err = -ENOENT;
+		goto fail;
+	}
 
 	key.objectid = objectid;
 	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
 	key.offset = 0;
 
 	inode = btrfs_iget(sb, &key, root);
-	if (IS_ERR(inode))
-		return (void *)inode;
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
+		goto fail;
+	}
+
+	srcu_read_unlock(&fs_info->subvol_srcu, index);
 
-	if (generation != inode->i_generation) {
+	if (check_generation && generation != inode->i_generation) {
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}
 
-	return d_obtain_alias(inode);
+	dentry = d_obtain_alias(inode);
+	if (!IS_ERR(dentry))
+		dentry->d_op = &btrfs_dentry_operations;
+	return dentry;
+fail:
+	srcu_read_unlock(&fs_info->subvol_srcu, index);
+	return ERR_PTR(err);
 }
 
 static struct dentry *btrfs_fh_to_parent(struct super_block *sb, struct fid *fh,
@@ -111,7 +138,7 @@ static struct dentry *btrfs_fh_to_parent
 	objectid = fid->parent_objectid;
 	generation = fid->parent_gen;
 
-	return btrfs_get_dentry(sb, objectid, root_objectid, generation);
+	return btrfs_get_dentry(sb, objectid, root_objectid, generation, 1);
 }
 
 static struct dentry *btrfs_fh_to_dentry(struct super_block *sb, struct fid *fh,
@@ -133,66 +160,76 @@ static struct dentry *btrfs_fh_to_dentry
 	root_objectid = fid->root_objectid;
 	generation = fid->gen;
 
-	return btrfs_get_dentry(sb, objectid, root_objectid, generation);
+	return btrfs_get_dentry(sb, objectid, root_objectid, generation, 1);
 }
 
 static struct dentry *btrfs_get_parent(struct dentry *child)
 {
 	struct inode *dir = child->d_inode;
+	static struct dentry *dentry;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
-	struct btrfs_key key;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
-	int slot;
-	u64 objectid;
+	struct btrfs_root_ref *ref;
+	struct btrfs_key key;
+	struct btrfs_key found_key;
 	int ret;
 
 	path = btrfs_alloc_path();
 
-	key.objectid = dir->i_ino;
-	btrfs_set_key_type(&key, BTRFS_INODE_REF_KEY);
-	key.offset = (u64)-1;
+	if (dir->i_ino == BTRFS_FIRST_FREE_OBJECTID) {
+		key.objectid = root->root_key.objectid;
+		key.type = BTRFS_ROOT_BACKREF_KEY;
+		key.offset = (u64)-1;
+		root = root->fs_info->tree_root;
+	} else {
+		key.objectid = dir->i_ino;
+		key.type = BTRFS_INODE_REF_KEY;
+		key.offset = (u64)-1;
+	}
 
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
-	if (ret < 0) {
-		/* Error */
-		btrfs_free_path(path);
-		return ERR_PTR(ret);
+	if (ret < 0)
+		goto fail;
+
+	BUG_ON(ret == 0);
+	if (path->slots[0] == 0) {
+		ret = -ENOENT;
+		goto fail;
 	}
+
+	path->slots[0]--;
 	leaf = path->nodes[0];
-	slot = path->slots[0];
-	if (ret) {
-		/* btrfs_search_slot() returns the slot where we'd want to
-		   insert a backref for parent inode #0xFFFFFFFFFFFFFFFF.
-		   The _real_ backref, telling us what the parent inode
-		   _actually_ is, will be in the slot _before_ the one
-		   that btrfs_search_slot() returns. */
-		if (!slot) {
-			/* Unless there is _no_ key in the tree before... */
-			btrfs_free_path(path);
-			return ERR_PTR(-EIO);
-		}
-		slot--;
+
+	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+	if (found_key.objectid != key.objectid || found_key.type != key.type) {
+		ret = -ENOENT;
+		goto fail;
 	}
 
-	btrfs_item_key_to_cpu(leaf, &key, slot);
+	if (found_key.type == BTRFS_ROOT_BACKREF_KEY) {
+		ref = btrfs_item_ptr(leaf, path->slots[0],
+				     struct btrfs_root_ref);
+		key.objectid = btrfs_root_ref_dirid(leaf, ref);
+	} else {
+		key.objectid = found_key.offset;
+	}
 	btrfs_free_path(path);
 
-	if (key.objectid != dir->i_ino || key.type != BTRFS_INODE_REF_KEY)
-		return ERR_PTR(-EINVAL);
-
-	objectid = key.offset;
-
-	/* If we are already at the root of a subvol, return the real root */
-	if (objectid == dir->i_ino)
-		return dget(dir->i_sb->s_root);
+	if (found_key.type == BTRFS_ROOT_BACKREF_KEY) {
+		return btrfs_get_dentry(root->fs_info->sb, key.objectid,
+					found_key.offset, 0, 0);
+	}
 
-	/* Build a new key for the inode item */
-	key.objectid = objectid;
-	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
+	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
-
-	return d_obtain_alias(btrfs_iget(root->fs_info->sb, &key, root));
+	dentry = d_obtain_alias(btrfs_iget(root->fs_info->sb, &key, root));
+	if (!IS_ERR(dentry))
+		dentry->d_op = &btrfs_dentry_operations;
+	return dentry;
+fail:
+	btrfs_free_path(path);
+	return ERR_PTR(ret);
 }
 
 const struct export_operations btrfs_export_ops = {
diff -urp 4/fs/btrfs/extent-tree.c 5/fs/btrfs/extent-tree.c
--- 4/fs/btrfs/extent-tree.c	2009-09-18 15:00:46.433350000 +0800
+++ 5/fs/btrfs/extent-tree.c	2009-09-16 16:04:16.957171000 +0800
@@ -5356,9 +5356,24 @@ int btrfs_drop_snapshot(struct btrfs_roo
 	ret = btrfs_del_root(trans, tree_root, &root->root_key);
 	BUG_ON(ret);
 
-	free_extent_buffer(root->node);
-	free_extent_buffer(root->commit_root);
-	kfree(root);
+	if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID) {
+		ret = btrfs_find_last_root(tree_root, root->root_key.objectid,
+					   NULL, NULL);
+		BUG_ON(ret < 0);
+		if (ret > 0) {
+			ret = btrfs_del_orphan_item(trans, tree_root,
+						    root->root_key.objectid);
+			BUG_ON(ret);
+		}
+	}
+
+	if (root->in_radix) {
+		btrfs_free_fs_root(tree_root->fs_info, root);
+	} else {
+		free_extent_buffer(root->node);
+		free_extent_buffer(root->commit_root);
+		kfree(root);
+	}
 out:
 	btrfs_end_transaction(trans, tree_root);
 	kfree(wc);
diff -urp 4/fs/btrfs/inode.c 5/fs/btrfs/inode.c
--- 4/fs/btrfs/inode.c	2009-09-18 16:58:27.740127798 +0800
+++ 5/fs/btrfs/inode.c	2009-09-18 10:11:09.466105000 +0800
@@ -3081,6 +3081,11 @@ void btrfs_delete_inode(struct inode *in
 	}
 	btrfs_wait_ordered_range(inode, 0, (u64)-1);
 
+	if (inode->i_nlink > 0) {
+		BUG_ON(btrfs_root_refs(&root->root_item) != 0);
+		goto no_delete;
+	}
+
 	btrfs_i_size_write(inode, 0);
 	trans = btrfs_join_transaction(root, 1);
 
@@ -3217,11 +3222,13 @@ static void inode_tree_add(struct inode 
 	struct btrfs_inode *entry;
 	struct rb_node **p;
 	struct rb_node *parent;
-
 again:
 	p = &root->inode_tree.rb_node;
 	parent = NULL;
 
+	if (hlist_unhashed(&inode->i_hash))
+		return;
+
 	spin_lock(&root->inode_lock);
 	while (*p) {
 		parent = *p;
@@ -3248,13 +3255,87 @@ again:
 static void inode_tree_del(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int empty = 0;
 
 	spin_lock(&root->inode_lock);
 	if (!RB_EMPTY_NODE(&BTRFS_I(inode)->rb_node)) {
 		rb_erase(&BTRFS_I(inode)->rb_node, &root->inode_tree);
 		RB_CLEAR_NODE(&BTRFS_I(inode)->rb_node);
+		empty = RB_EMPTY_ROOT(&root->inode_tree);
+	}
+	spin_unlock(&root->inode_lock);
+
+	if (empty && btrfs_root_refs(&root->root_item) == 0) {
+		synchronize_srcu(&root->fs_info->subvol_srcu);
+		spin_lock(&root->inode_lock);
+		empty = RB_EMPTY_ROOT(&root->inode_tree);
+		spin_unlock(&root->inode_lock);
+		if (empty)
+			btrfs_add_dead_root(root);
+	}
+}
+
+int btrfs_invalidate_inodes(struct btrfs_root *root)
+{
+	struct rb_node *node;
+	struct rb_node *prev;
+	struct btrfs_inode *entry;
+	struct inode *inode;
+	u64 objectid = 0;
+
+	WARN_ON(btrfs_root_refs(&root->root_item) != 0);
+
+	spin_lock(&root->inode_lock);
+again:
+	node = root->inode_tree.rb_node;
+	prev = NULL;
+	while (node) {
+		prev = node;
+		entry = rb_entry(node, struct btrfs_inode, rb_node);
+
+		if (objectid < entry->vfs_inode.i_ino)
+			node = node->rb_left;
+		else if (objectid > entry->vfs_inode.i_ino)
+			node = node->rb_right;
+		else
+			break;
+	}
+	if (!node) {
+		while (prev) {
+			entry = rb_entry(prev, struct btrfs_inode, rb_node);
+			if (objectid <= entry->vfs_inode.i_ino) {
+				node = prev;
+				break;
+			}
+			prev = rb_next(prev);
+		}
+	}
+	while (node) {
+		entry = rb_entry(node, struct btrfs_inode, rb_node);
+		objectid = entry->vfs_inode.i_ino + 1;
+		inode = igrab(&entry->vfs_inode);
+		if (inode) {
+			spin_unlock(&root->inode_lock);
+			if (atomic_read(&inode->i_count) > 1)
+				d_prune_aliases(inode);
+			/*
+			 * btrfs_drop_inode will remove it from
+			 * the inode cache when its usage count
+			 * hits zero.
+			 */
+			iput(inode);
+			cond_resched();
+			spin_lock(&root->inode_lock);
+			goto again;
+		}
+
+		if (cond_resched_lock(&root->inode_lock))
+			goto again;
+
+		node = rb_next(node);
 	}
 	spin_unlock(&root->inode_lock);
+	return 0;
 }
 
 static noinline void init_btrfs_i(struct inode *inode)
@@ -3371,8 +3452,11 @@ struct inode *btrfs_lookup_dentry(struct
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct btrfs_root *sub_root = root;
 	struct btrfs_key location;
+	int index;
 	int ret;
 
+	dentry->d_op = &btrfs_dentry_operations;
+
 	if (dentry->d_name.len > BTRFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
@@ -3391,6 +3475,7 @@ struct inode *btrfs_lookup_dentry(struct
 
 	BUG_ON(location.type != BTRFS_ROOT_ITEM_KEY);
 
+	index = srcu_read_lock(&root->fs_info->subvol_srcu);
 	ret = fixup_tree_root_location(root, dir, dentry,
 				       &location, &sub_root);
 	if (ret < 0) {
@@ -3401,9 +3486,24 @@ struct inode *btrfs_lookup_dentry(struct
 	} else {
 		inode = btrfs_iget(dir->i_sb, &location, sub_root);
 	}
+	srcu_read_unlock(&root->fs_info->subvol_srcu, index);
+
 	return inode;
 }
 
+static int btrfs_dentry_delete(struct dentry *dentry)
+{
+	struct btrfs_root *root;
+
+	if (!dentry->d_inode)
+		return 0;
+
+	root = BTRFS_I(dentry->d_inode)->root;
+	if (btrfs_root_refs(&root->root_item) == 0)
+		return 1;
+	return 0;
+}
+
 static struct dentry *btrfs_lookup(struct inode *dir, struct dentry *dentry,
 				   struct nameidata *nd)
 {
@@ -4765,11 +4865,11 @@ out:
  * create a new subvolume directory/inode (helper for the ioctl).
  */
 int btrfs_create_subvol_root(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *new_root, struct dentry *dentry,
+			     struct btrfs_root *new_root,
 			     u64 new_dirid, u64 alloc_hint)
 {
 	struct inode *inode;
-	int error;
+	int err;
 	u64 index = 0;
 
 	inode = btrfs_new_inode(trans, new_root, NULL, "..", 2, new_dirid,
@@ -4782,11 +4882,10 @@ int btrfs_create_subvol_root(struct btrf
 	inode->i_nlink = 1;
 	btrfs_i_size_write(inode, 0);
 
-	error = btrfs_update_inode(trans, new_root, inode);
-	if (error)
-		return error;
+	err = btrfs_update_inode(trans, new_root, inode);
+	BUG_ON(err);
 
-	d_instantiate(dentry, inode);
+	iput(inode);
 	return 0;
 }
 
@@ -4864,6 +4963,16 @@ void btrfs_destroy_inode(struct inode *i
 	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
 }
 
+void btrfs_drop_inode(struct inode *inode)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+
+	if (inode->i_nlink > 0 && btrfs_root_refs(&root->root_item) == 0)
+		generic_delete_inode(inode);
+	else
+		generic_drop_inode(inode);
+}
+
 static void init_once(void *foo)
 {
 	struct btrfs_inode *ei = (struct btrfs_inode *) foo;
@@ -4965,6 +5074,10 @@ static int btrfs_rename(struct inode *ol
 	    old_inode->i_size > BTRFS_ORDERED_OPERATIONS_FLUSH_LIMIT)
 		filemap_flush(old_inode->i_mapping);
 
+	/* close the racy window with snapshot create/destroy ioctl */
+	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
+		down_read(&root->fs_info->subvol_sem);
+
 	trans = btrfs_start_transaction(root, 1);
 
 	if (dest != root)
@@ -5054,6 +5167,8 @@ static int btrfs_rename(struct inode *ol
 
 	btrfs_end_transaction_throttle(trans, root);
 
+	if (old_inode->i_ino == BTRFS_FIRST_FREE_OBJECTID)
+		up_read(&root->fs_info->subvol_sem);
 	return ret;
 }
 
@@ -5412,6 +5527,7 @@ static struct inode_operations btrfs_dir
 	.lookup		= btrfs_lookup,
 	.permission	= btrfs_permission,
 };
+
 static struct file_operations btrfs_dir_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
@@ -5498,3 +5614,7 @@ static struct inode_operations btrfs_sym
 	.listxattr	= btrfs_listxattr,
 	.removexattr	= btrfs_removexattr,
 };
+
+struct dentry_operations btrfs_dentry_operations = {
+	.d_delete	= btrfs_dentry_delete,
+};
diff -urp 4/fs/btrfs/ioctl.c 5/fs/btrfs/ioctl.c
--- 4/fs/btrfs/ioctl.c	2009-09-18 15:42:47.377359227 +0800
+++ 5/fs/btrfs/ioctl.c	2009-09-18 14:50:22.821113000 +0800
@@ -230,8 +230,8 @@ static noinline int create_subvol(struct
 	struct btrfs_root_item root_item;
 	struct btrfs_inode_item *inode_item;
 	struct extent_buffer *leaf;
-	struct btrfs_root *new_root = root;
-	struct inode *dir;
+	struct btrfs_root *new_root;
+	struct inode *dir = dentry->d_parent->d_inode;
 	int ret;
 	int err;
 	u64 objectid;
@@ -241,7 +241,7 @@ static noinline int create_subvol(struct
 
 	ret = btrfs_check_metadata_free_space(root);
 	if (ret)
-		goto fail_commit;
+		return ret;
 
 	trans = btrfs_start_transaction(root, 1);
 	BUG_ON(!trans);
@@ -304,11 +304,17 @@ static noinline int create_subvol(struct
 	if (ret)
 		goto fail;
 
+	key.offset = (u64)-1;
+	new_root = btrfs_read_fs_root_no_name(root->fs_info, &key);
+	BUG_ON(IS_ERR(new_root));
+
+	btrfs_record_root_in_trans(trans, new_root);
+
+	ret = btrfs_create_subvol_root(trans, new_root, new_dirid,
+				       BTRFS_I(dir)->block_group);
 	/*
 	 * insert the directory item
 	 */
-	key.offset = (u64)-1;
-	dir = dentry->d_parent->d_inode;
 	ret = btrfs_set_inode_index(dir, &index);
 	BUG_ON(ret);
 
@@ -325,30 +331,15 @@ static noinline int create_subvol(struct
 	ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
 				 objectid, root->root_key.objectid,
 				 dir->i_ino, index, name, namelen);
-	BUG_ON(ret);
 
-	ret = btrfs_commit_transaction(trans, root);
-	if (ret)
-		goto fail_commit;
-
-	new_root = btrfs_read_fs_root_no_name(root->fs_info, &key);
-	BUG_ON(!new_root);
-
-	trans = btrfs_start_transaction(new_root, 1);
-	BUG_ON(!trans);
-
-	ret = btrfs_create_subvol_root(trans, new_root, dentry, new_dirid,
-				       BTRFS_I(dir)->block_group);
-	if (ret)
-		goto fail;
+	BUG_ON(ret);
 
+	d_instantiate(dentry, btrfs_lookup_dentry(dir, dentry));
 fail:
 	nr = trans->blocks_used;
-	err = btrfs_commit_transaction(trans, new_root);
+	err = btrfs_commit_transaction(trans, root);
 	if (err && !ret)
 		ret = err;
-fail_commit:
-	btrfs_btree_balance_dirty(root, nr);
 	return ret;
 }
 
@@ -409,14 +400,15 @@ static inline int btrfs_may_create(struc
  * sys_mkdirat and vfs_mkdir, but we only do a single component lookup
  * inside this filesystem so it's quite a bit simpler.
  */
-static noinline int btrfs_mksubvol(struct path *parent, char *name,
-				   int mode, int namelen,
+static noinline int btrfs_mksubvol(struct path *parent,
+				   char *name, int namelen,
 				   struct btrfs_root *snap_src)
 {
+	struct inode *dir  = parent->dentry->d_inode;
 	struct dentry *dentry;
 	int error;
 
-	mutex_lock_nested(&parent->dentry->d_inode->i_mutex, I_MUTEX_PARENT);
+	mutex_lock_nested(&dir->i_mutex, I_MUTEX_PARENT);
 
 	dentry = lookup_one_len(name, parent->dentry, namelen);
 	error = PTR_ERR(dentry);
@@ -427,99 +419,39 @@ static noinline int btrfs_mksubvol(struc
 	if (dentry->d_inode)
 		goto out_dput;
 
-	if (!IS_POSIXACL(parent->dentry->d_inode))
-		mode &= ~current_umask();
-
 	error = mnt_want_write(parent->mnt);
 	if (error)
 		goto out_dput;
 
-	error = btrfs_may_create(parent->dentry->d_inode, dentry);
+	error = btrfs_may_create(dir, dentry);
 	if (error)
 		goto out_drop_write;
 
-	/*
-	 * Actually perform the low-level subvolume creation after all
-	 * this VFS fuzz.
-	 *
-	 * Eventually we want to pass in an inode under which we create this
-	 * subvolume, but for now all are under the filesystem root.
-	 *
-	 * Also we should pass on the mode eventually to allow creating new
-	 * subvolume with specific mode bits.
-	 */
+	down_read(&BTRFS_I(dir)->root->fs_info->subvol_sem);
+
+	if (btrfs_root_refs(&BTRFS_I(dir)->root->root_item) == 0)
+		goto out_up_read;
+
 	if (snap_src) {
-		struct dentry *dir = dentry->d_parent;
-		struct dentry *test = dir->d_parent;
-		struct btrfs_path *path = btrfs_alloc_path();
-		int ret;
-		u64 test_oid;
-		u64 parent_oid = BTRFS_I(dir->d_inode)->root->root_key.objectid;
-
-		test_oid = snap_src->root_key.objectid;
-
-		ret = btrfs_find_root_ref(snap_src->fs_info->tree_root,
-					  path, parent_oid, test_oid);
-		if (ret == 0)
-			goto create;
-		btrfs_release_path(snap_src->fs_info->tree_root, path);
-
-		/* we need to make sure we aren't creating a directory loop
-		 * by taking a snapshot of something that has our current
-		 * subvol in its directory tree.  So, this loops through
-		 * the dentries and checks the forward refs for each subvolume
-		 * to see if is references the subvolume where we are
-		 * placing this new snapshot.
-		 */
-		while (1) {
-			if (!test ||
-			    dir == snap_src->fs_info->sb->s_root ||
-			    test == snap_src->fs_info->sb->s_root ||
-			    test->d_inode->i_sb != snap_src->fs_info->sb) {
-				break;
-			}
-			if (S_ISLNK(test->d_inode->i_mode)) {
-				printk(KERN_INFO "Btrfs symlink in snapshot "
-				       "path, failed\n");
-				error = -EMLINK;
-				btrfs_free_path(path);
-				goto out_drop_write;
-			}
-			test_oid =
-				BTRFS_I(test->d_inode)->root->root_key.objectid;
-			ret = btrfs_find_root_ref(snap_src->fs_info->tree_root,
-				  path, test_oid, parent_oid);
-			if (ret == 0) {
-				printk(KERN_INFO "Btrfs snapshot creation "
-				       "failed, looping\n");
-				error = -EMLINK;
-				btrfs_free_path(path);
-				goto out_drop_write;
-			}
-			btrfs_release_path(snap_src->fs_info->tree_root, path);
-			test = test->d_parent;
-		}
-create:
-		btrfs_free_path(path);
-		error = create_snapshot(snap_src, dentry, name, namelen);
+		error = create_snapshot(snap_src, dentry,
+					name, namelen);
 	} else {
-		error = create_subvol(BTRFS_I(parent->dentry->d_inode)->root,
-				      dentry, name, namelen);
+		error = create_subvol(BTRFS_I(dir)->root, dentry,
+				      name, namelen);
 	}
-	if (error)
-		goto out_drop_write;
-
-	fsnotify_mkdir(parent->dentry->d_inode, dentry);
+	if (!error)
+		fsnotify_mkdir(dir, dentry);
+out_up_read:
+	up_read(&BTRFS_I(dir)->root->fs_info->subvol_sem);
 out_drop_write:
 	mnt_drop_write(parent->mnt);
 out_dput:
 	dput(dentry);
 out_unlock:
-	mutex_unlock(&parent->dentry->d_inode->i_mutex);
+	mutex_unlock(&dir->i_mutex);
 	return error;
 }
 
-
 static int btrfs_defrag_file(struct file *file)
 {
 	struct inode *inode = fdentry(file)->d_inode;
@@ -597,7 +529,8 @@ out_unlock:
 	return 0;
 }
 
-static int btrfs_ioctl_resize(struct btrfs_root *root, void __user *arg)
+static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
+					void __user *arg)
 {
 	u64 new_size;
 	u64 old_size;
@@ -706,10 +639,7 @@ static noinline int btrfs_ioctl_snap_cre
 {
 	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
 	struct btrfs_ioctl_vol_args *vol_args;
-	struct btrfs_dir_item *di;
-	struct btrfs_path *path;
 	struct file *src_file;
-	u64 root_dirid;
 	int namelen;
 	int ret = 0;
 
@@ -727,32 +657,9 @@ static noinline int btrfs_ioctl_snap_cre
 		goto out;
 	}
 
-	path = btrfs_alloc_path();
-	if (!path) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	root_dirid = root->fs_info->sb->s_root->d_inode->i_ino,
-	di = btrfs_lookup_dir_item(NULL, root->fs_info->tree_root,
-			    path, root_dirid,
-			    vol_args->name, namelen, 0);
-	btrfs_free_path(path);
-
-	if (di && !IS_ERR(di)) {
-		ret = -EEXIST;
-		goto out;
-	}
-
-	if (IS_ERR(di)) {
-		ret = PTR_ERR(di);
-		goto out;
-	}
-
 	if (subvol) {
-		ret = btrfs_mksubvol(&file->f_path, vol_args->name,
-				     file->f_path.dentry->d_inode->i_mode,
-				     namelen, NULL);
+		ret = btrfs_mksubvol(&file->f_path, vol_args->name, namelen,
+				     NULL);
 	} else {
 		struct inode *src_inode;
 		src_file = fget(vol_args->fd);
@@ -769,17 +676,156 @@ static noinline int btrfs_ioctl_snap_cre
 			fput(src_file);
 			goto out;
 		}
-		ret = btrfs_mksubvol(&file->f_path, vol_args->name,
-			     file->f_path.dentry->d_inode->i_mode,
-			     namelen, BTRFS_I(src_inode)->root);
+		ret = btrfs_mksubvol(&file->f_path, vol_args->name, namelen,
+				     BTRFS_I(src_inode)->root);
 		fput(src_file);
 	}
-
 out:
 	kfree(vol_args);
 	return ret;
 }
 
+/*
+ * helper to check if the subvolume references other subvolumes
+ */
+static noinline int may_destroy_subvol(struct btrfs_root *root)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = root->root_key.objectid;
+	key.type = BTRFS_ROOT_REF_KEY;
+	key.offset = (u64)-1;
+
+	ret = btrfs_search_slot(NULL, root->fs_info->tree_root,
+				&key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	BUG_ON(ret == 0);
+
+	ret = 0;
+	if (path->slots[0] > 0) {
+		path->slots[0]--;
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+		if (key.objectid == root->root_key.objectid &&
+		    key.type == BTRFS_ROOT_REF_KEY)
+			ret = -ENOTEMPTY;
+	}
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static noinline int btrfs_ioctl_snap_destroy(struct file *file,
+					     void __user *arg)
+{
+	struct dentry *parent = fdentry(file);
+	struct dentry *dentry;
+	struct inode *dir = parent->d_inode;
+	struct inode *inode;
+	struct btrfs_root *root = BTRFS_I(dir)->root;
+	struct btrfs_root *dest = NULL;
+	struct btrfs_ioctl_vol_args *vol_args;
+	struct btrfs_trans_handle *trans;
+	int namelen;
+	int ret;
+	int err = 0;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	vol_args = memdup_user(arg, sizeof(*vol_args));
+	if (IS_ERR(vol_args))
+		return PTR_ERR(vol_args);
+
+	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
+	namelen = strlen(vol_args->name);
+	if (strchr(vol_args->name, '/') ||
+	    strncmp(vol_args->name, "..", namelen) == 0) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = mnt_want_write(file->f_path.mnt);
+	if (err)
+		goto out;
+
+	mutex_lock_nested(&dir->i_mutex, I_MUTEX_PARENT);
+	dentry = lookup_one_len(vol_args->name, parent, namelen);
+	if (IS_ERR(dentry)) {
+		err = PTR_ERR(dentry);
+		goto out_unlock_dir;
+	}
+
+	if (!dentry->d_inode) {
+		err = -ENOENT;
+		goto out_dput;
+	}
+
+	inode = dentry->d_inode;
+	if (inode->i_ino != BTRFS_FIRST_FREE_OBJECTID) {
+		err = -EINVAL;
+		goto out_dput;
+	}
+
+	dest = BTRFS_I(inode)->root;
+
+	mutex_lock(&inode->i_mutex);
+	err = d_invalidate(dentry);
+	if (err)
+		goto out_unlock;
+
+	down_write(&root->fs_info->subvol_sem);
+
+	err = may_destroy_subvol(dest);
+	if (err)
+		goto out_up_write;
+
+	trans = btrfs_start_transaction(root, 1);
+	ret = btrfs_unlink_subvol(trans, root, dir,
+				dest->root_key.objectid,
+				dentry->d_name.name,
+				dentry->d_name.len);
+	BUG_ON(ret);
+
+	btrfs_record_root_in_trans(trans, dest);
+
+	memset(&dest->root_item.drop_progress, 0,
+		sizeof(dest->root_item.drop_progress));
+	dest->root_item.drop_level = 0;
+	btrfs_set_root_refs(&dest->root_item, 0);
+
+	ret = btrfs_insert_orphan_item(trans,
+				root->fs_info->tree_root,
+				dest->root_key.objectid);
+	BUG_ON(ret);
+
+	ret = btrfs_commit_transaction(trans, root);
+	BUG_ON(ret);
+	inode->i_flags |= S_DEAD;
+out_up_write:
+	up_write(&root->fs_info->subvol_sem);
+out_unlock:
+	mutex_unlock(&inode->i_mutex);
+	if (!err) {
+		btrfs_invalidate_inodes(dest);
+		d_delete(dentry);
+	}
+out_dput:
+	dput(dentry);
+out_unlock_dir:
+	mutex_unlock(&dir->i_mutex);
+	mnt_drop_write(file->f_path.mnt);
+out:
+	kfree(vol_args);
+	return err;
+}
+
 static int btrfs_ioctl_defrag(struct file *file)
 {
 	struct inode *inode = fdentry(file)->d_inode;
@@ -853,8 +899,8 @@ static long btrfs_ioctl_rm_dev(struct bt
 	return ret;
 }
 
-static long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
-		u64 off, u64 olen, u64 destoff)
+static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
+				       u64 off, u64 olen, u64 destoff)
 {
 	struct inode *inode = fdentry(file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -1246,6 +1292,8 @@ long btrfs_ioctl(struct file *file, unsi
 		return btrfs_ioctl_snap_create(file, argp, 0);
 	case BTRFS_IOC_SUBVOL_CREATE:
 		return btrfs_ioctl_snap_create(file, argp, 1);
+	case BTRFS_IOC_SNAP_DESTROY:
+		return btrfs_ioctl_snap_destroy(file, argp);
 	case BTRFS_IOC_DEFRAG:
 		return btrfs_ioctl_defrag(file);
 	case BTRFS_IOC_RESIZE:
diff -urp 4/fs/btrfs/ioctl.h 5/fs/btrfs/ioctl.h
--- 4/fs/btrfs/ioctl.h	2009-07-24 09:51:38.398056000 +0800
+++ 5/fs/btrfs/ioctl.h	2009-09-16 16:04:16.967166000 +0800
@@ -65,5 +65,6 @@ struct btrfs_ioctl_clone_range_args {
 
 #define BTRFS_IOC_SUBVOL_CREATE _IOW(BTRFS_IOCTL_MAGIC, 14, \
 				   struct btrfs_ioctl_vol_args)
-
+#define BTRFS_IOC_SNAP_DESTROY _IOW(BTRFS_IOCTL_MAGIC, 15, \
+				struct btrfs_ioctl_vol_args)
 #endif
diff -urp 4/fs/btrfs/relocation.c 5/fs/btrfs/relocation.c
--- 4/fs/btrfs/relocation.c	2009-09-16 14:49:02.265419000 +0800
+++ 5/fs/btrfs/relocation.c	2009-09-16 17:17:14.127166000 +0800
@@ -3203,6 +3203,7 @@ static int check_extent_flags(u64 flags)
 	return 0;
 }
 
+
 static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 {
 	struct rb_root blocks = RB_ROOT;
@@ -3220,6 +3221,9 @@ static noinline_for_stack int relocate_b
 	if (!path)
 		return -ENOMEM;
 
+	rc->extents_found = 0;
+	rc->extents_skipped = 0;
+
 	rc->search_start = rc->block_group->key.objectid;
 	clear_extent_bits(&rc->processed_blocks, 0, (u64)-1, EXTENT_DIRTY,
 			  GFP_NOFS);
@@ -3475,14 +3479,15 @@ int btrfs_relocate_block_group(struct bt
 	btrfs_wait_ordered_extents(fs_info->tree_root, 0);
 
 	while (1) {
-		mutex_lock(&fs_info->cleaner_mutex);
-		btrfs_clean_old_snapshots(fs_info->tree_root);
-		mutex_unlock(&fs_info->cleaner_mutex);
-
 		rc->extents_found = 0;
 		rc->extents_skipped = 0;
 
+		mutex_lock(&fs_info->cleaner_mutex);
+
+		btrfs_clean_old_snapshots(fs_info->tree_root);
 		ret = relocate_block_group(rc);
+
+		mutex_unlock(&fs_info->cleaner_mutex);
 		if (ret < 0) {
 			err = ret;
 			break;
@@ -3530,6 +3535,26 @@ out:
 	return err;
 }
 
+static noinline_for_stack int mark_garbage_root(struct btrfs_root *root)
+{
+	struct btrfs_trans_handle *trans;
+	int ret;
+
+	trans = btrfs_start_transaction(root->fs_info->tree_root, 1);
+
+	memset(&root->root_item.drop_progress, 0,
+		sizeof(root->root_item.drop_progress));
+	root->root_item.drop_level = 0;
+	btrfs_set_root_refs(&root->root_item, 0);
+	ret = btrfs_update_root(trans, root->fs_info->tree_root,
+				&root->root_key, &root->root_item);
+	BUG_ON(ret);
+
+	ret = btrfs_end_transaction(trans, root->fs_info->tree_root);
+	BUG_ON(ret);
+	return 0;
+}
+
 /*
  * recover relocation interrupted by system crash.
  *
@@ -3589,8 +3614,12 @@ int btrfs_recover_relocation(struct btrf
 			fs_root = read_fs_root(root->fs_info,
 					       reloc_root->root_key.offset);
 			if (IS_ERR(fs_root)) {
-				err = PTR_ERR(fs_root);
-				goto out;
+				ret = PTR_ERR(fs_root);
+				if (ret != -ENOENT) {
+					err = ret;
+					goto out;
+				}
+				mark_garbage_root(reloc_root);
 			}
 		}
 
diff -urp 4/fs/btrfs/root-tree.c 5/fs/btrfs/root-tree.c
--- 4/fs/btrfs/root-tree.c	2009-09-18 15:42:47.377359227 +0800
+++ 5/fs/btrfs/root-tree.c	2009-09-16 17:31:30.480416000 +0800
@@ -94,17 +94,23 @@ int btrfs_find_last_root(struct btrfs_ro
 		goto out;
 
 	BUG_ON(ret == 0);
+	if (path->slots[0] == 0) {
+		ret = 1;
+		goto out;
+	}
 	l = path->nodes[0];
-	BUG_ON(path->slots[0] == 0);
 	slot = path->slots[0] - 1;
 	btrfs_item_key_to_cpu(l, &found_key, slot);
-	if (found_key.objectid != objectid) {
+	if (found_key.objectid != objectid ||
+	    found_key.type != BTRFS_ROOT_ITEM_KEY) {
 		ret = 1;
 		goto out;
 	}
-	read_extent_buffer(l, item, btrfs_item_ptr_offset(l, slot),
-			   sizeof(*item));
-	memcpy(key, &found_key, sizeof(found_key));
+	if (item)
+		read_extent_buffer(l, item, btrfs_item_ptr_offset(l, slot),
+				   sizeof(*item));
+	if (key)
+		memcpy(key, &found_key, sizeof(found_key));
 	ret = 0;
 out:
 	btrfs_free_path(path);
@@ -249,6 +255,59 @@ err:
 	return ret;
 }
 
+int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
+{
+	struct extent_buffer *leaf;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	int err = 0;
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = BTRFS_ORPHAN_OBJECTID;
+	key.type = BTRFS_ORPHAN_ITEM_KEY;
+	key.offset = 0;
+
+	while (1) {
+		ret = btrfs_search_slot(NULL, tree_root, &key, path, 0, 0);
+		if (ret < 0) {
+			err = ret;
+			break;
+		}
+
+		leaf = path->nodes[0];
+		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(tree_root, path);
+			if (ret < 0)
+				err = ret;
+			if (ret != 0)
+				break;
+			leaf = path->nodes[0];
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+		btrfs_release_path(tree_root, path);
+
+		if (key.objectid != BTRFS_ORPHAN_OBJECTID ||
+		    key.type != BTRFS_ORPHAN_ITEM_KEY)
+			break;
+
+		ret = btrfs_find_dead_roots(tree_root, key.offset);
+		if (ret) {
+			err = ret;
+			break;
+		}
+
+		key.offset++;
+	}
+
+	btrfs_free_path(path);
+	return err;
+}
+
 /* drop the root item for 'key' from 'root' */
 int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		   struct btrfs_key *key)
diff -urp 4/fs/btrfs/super.c 5/fs/btrfs/super.c
--- 4/fs/btrfs/super.c	2009-09-16 15:24:37.332171000 +0800
+++ 5/fs/btrfs/super.c	2009-09-16 16:10:50.191171000 +0800
@@ -676,6 +676,7 @@ static int btrfs_unfreeze(struct super_b
 }
 
 static struct super_operations btrfs_super_ops = {
+	.drop_inode 	= btrfs_drop_inode,
 	.delete_inode	= btrfs_delete_inode,
 	.put_super	= btrfs_put_super,
 	.sync_fs	= btrfs_sync_fs,
diff -urp 4/fs/btrfs/transaction.c 5/fs/btrfs/transaction.c
--- 4/fs/btrfs/transaction.c	2009-09-18 15:42:47.378358670 +0800
+++ 5/fs/btrfs/transaction.c	2009-09-17 16:23:29.546249000 +0800
@@ -104,7 +104,6 @@ static noinline int record_root_in_trans
 {
 	if (root->ref_cows && root->last_trans < trans->transid) {
 		WARN_ON(root == root->fs_info->extent_root);
-		WARN_ON(root->root_item.refs == 0);
 		WARN_ON(root->commit_root != root->node);
 
 		radix_tree_tag_set(&root->fs_info->fs_roots_radix,
@@ -1087,8 +1086,13 @@ int btrfs_clean_old_snapshots(struct btr
 
 	while (!list_empty(&list)) {
 		root = list_entry(list.next, struct btrfs_root, root_list);
-		list_del_init(&root->root_list);
-		btrfs_drop_snapshot(root, 0);
+		list_del(&root->root_list);
+
+		if (btrfs_header_backref_rev(root->node) <
+		    BTRFS_MIXED_BACKREF_REV)
+			btrfs_drop_snapshot(root, 0);
+		else
+			btrfs_drop_snapshot(root, 1);
 	}
 	return 0;
 }
diff -urp 4/fs/btrfs/tree-log.c 5/fs/btrfs/tree-log.c
--- 4/fs/btrfs/tree-log.c	2009-09-18 15:01:03.965350000 +0800
+++ 5/fs/btrfs/tree-log.c	2009-09-18 16:47:50.595350494 +0800
@@ -2841,7 +2841,7 @@ static noinline int check_parent_dirs_fo
 		if (!parent || !parent->d_inode || sb != parent->d_inode->i_sb)
 			break;
 
-		if (parent == sb->s_root)
+		if (IS_ROOT(parent))
 			break;
 
 		parent = parent->d_parent;
@@ -2880,6 +2880,12 @@ int btrfs_log_inode_parent(struct btrfs_
 		goto end_no_trans;
 	}
 
+	if (root != BTRFS_I(inode)->root ||
+	    btrfs_root_refs(&root->root_item) == 0) {
+		ret = 1;
+		goto end_no_trans;
+	}
+
 	ret = check_parent_dirs_for_sync(trans, inode, parent,
 					 sb, last_committed);
 	if (ret)
@@ -2907,12 +2913,15 @@ int btrfs_log_inode_parent(struct btrfs_
 			break;
 
 		inode = parent->d_inode;
+		if (root != BTRFS_I(inode)->root)
+			break;
+
 		if (BTRFS_I(inode)->generation >
 		    root->fs_info->last_trans_committed) {
 			ret = btrfs_log_inode(trans, root, inode, inode_only);
 			BUG_ON(ret);
 		}
-		if (parent == sb->s_root)
+		if (IS_ROOT(parent))
 			break;
 
 		parent = parent->d_parent;
