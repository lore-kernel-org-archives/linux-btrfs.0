From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH 1/2] mount ro and remount support
Date: Tue, 11 Nov 2008 21:23:09 +0800
Message-ID: <4919873D.20508@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch adds mount ro and remount support. The main
changes in patch are: adding btrfs_remount and related
helper function; splitting the transaction related code
out of close_ctree into btrfs_commit_super; updating
allocator to properly handle read only block group.

Regards

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 2/fs/btrfs/ctree.h 3/fs/btrfs/ctree.h
--- 2/fs/btrfs/ctree.h	2008-11-07 19:16:08.000000000 +0800
+++ 3/fs/btrfs/ctree.h	2008-11-11 10:46:08.000000000 +0800
@@ -541,6 +541,7 @@ struct btrfs_space_info {
 	u64 bytes_used;
 	u64 bytes_pinned;
 	u64 bytes_reserved;
+	u64 bytes_readonly;
 	int full;
 	int force_alloc;
 	struct list_head list;
diff -urp 2/fs/btrfs/disk-io.c 3/fs/btrfs/disk-io.c
--- 2/fs/btrfs/disk-io.c	2008-11-11 10:43:52.000000000 +0800
+++ 3/fs/btrfs/disk-io.c	2008-11-11 10:46:08.000000000 +0800
@@ -1075,10 +1075,12 @@ struct btrfs_root *btrfs_read_fs_root_no
 		kfree(root);
 		return ERR_PTR(ret);
 	}
-	ret = btrfs_find_dead_roots(fs_info->tree_root,
-				    root->root_key.objectid, root);
-	BUG_ON(ret);
-
+	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
+		ret = btrfs_find_dead_roots(fs_info->tree_root,
+					    root->root_key.objectid, root);
+		BUG_ON(ret);
+		btrfs_orphan_cleanup(root);
+	}
 	return root;
 }
 
@@ -1700,7 +1702,8 @@ struct btrfs_root *open_ctree(struct sup
 
 	btrfs_read_block_groups(extent_root);
 
-	fs_info->generation = btrfs_super_generation(disk_super) + 1;
+	fs_info->generation = generation + 1;
+	fs_info->last_trans_committed = generation;
 	fs_info->data_alloc_profile = (u64)-1;
 	fs_info->metadata_alloc_profile = (u64)-1;
 	fs_info->system_alloc_profile = fs_info->metadata_alloc_profile;
@@ -1715,6 +1718,9 @@ struct btrfs_root *open_ctree(struct sup
 	if (!fs_info->transaction_kthread)
 		goto fail_cleaner;
 
+	if (sb->s_flags & MS_RDONLY)
+		return tree_root;
+
 	if (btrfs_super_log_root(disk_super) != 0) {
 		u32 blocksize;
 		u64 bytenr = btrfs_super_log_root(disk_super);
@@ -1735,7 +1741,6 @@ struct btrfs_root *open_ctree(struct sup
 		ret = btrfs_recover_log_trees(log_tree_root);
 		BUG_ON(ret);
 	}
-	fs_info->last_trans_committed = btrfs_super_generation(disk_super);
 
 	ret = btrfs_cleanup_reloc_trees(tree_root);
 	BUG_ON(ret);
@@ -1955,28 +1960,69 @@ static int del_fs_roots(struct btrfs_fs_
 	return 0;
 }
 
-int close_ctree(struct btrfs_root *root)
+int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info)
 {
+	u64 root_objectid = 0;
+	struct btrfs_root *gang[8];
+	int i;
 	int ret;
-	struct btrfs_trans_handle *trans;
-	struct btrfs_fs_info *fs_info = root->fs_info;
 
-	fs_info->closing = 1;
-	smp_mb();
+	while (1) {
+		ret = radix_tree_gang_lookup(&fs_info->fs_roots_radix,
+					     (void **)gang, root_objectid,
+					     ARRAY_SIZE(gang));
+		if (!ret)
+			break;
+		for (i = 0; i < ret; i++) {
+			root_objectid = gang[i]->root_key.objectid;
+			ret = btrfs_find_dead_roots(fs_info->tree_root,
+						    root_objectid, gang[i]);
+			BUG_ON(ret);
+			btrfs_orphan_cleanup(gang[i]);
+		}
+		root_objectid++;
+	}
+	return 0;
+}
 
-	kthread_stop(root->fs_info->transaction_kthread);
-	kthread_stop(root->fs_info->cleaner_kthread);
+int btrfs_commit_super(struct btrfs_root *root)
+{
+	struct btrfs_trans_handle *trans;
+	int ret;
 
+	mutex_lock(&root->fs_info->cleaner_mutex);
 	btrfs_clean_old_snapshots(root);
+	mutex_unlock(&root->fs_info->cleaner_mutex);
 	trans = btrfs_start_transaction(root, 1);
 	ret = btrfs_commit_transaction(trans, root);
-	/* run commit again to  drop the original snapshot */
+	BUG_ON(ret);
+	/* run commit again to drop the original snapshot */
 	trans = btrfs_start_transaction(root, 1);
 	btrfs_commit_transaction(trans, root);
 	ret = btrfs_write_and_wait_transaction(NULL, root);
 	BUG_ON(ret);
 
-	write_ctree_super(NULL, root);
+	ret = write_ctree_super(NULL, root);
+	return ret;
+}
+
+int close_ctree(struct btrfs_root *root)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	int ret;
+
+	fs_info->closing = 1;
+	smp_mb();
+
+	kthread_stop(root->fs_info->transaction_kthread);
+	kthread_stop(root->fs_info->cleaner_kthread);
+
+	if (!(fs_info->sb->s_flags & MS_RDONLY)) {
+		ret =  btrfs_commit_super(root);
+		if (ret) {
+			printk("btrfs: commit super returns %d\n", ret);
+		}
+	}
 
 	if (fs_info->delalloc_bytes) {
 		printk("btrfs: at unmount delalloc count %Lu\n",
@@ -2000,12 +2046,10 @@ int close_ctree(struct btrfs_root *root)
 		free_extent_buffer(root->fs_info->dev_root->node);
 
 	btrfs_free_block_groups(root->fs_info);
-	fs_info->closing = 2;
-	del_fs_roots(fs_info);
 
-	filemap_write_and_wait(fs_info->btree_inode->i_mapping);
+	del_fs_roots(fs_info);
 
-	truncate_inode_pages(fs_info->btree_inode->i_mapping, 0);
+	iput(fs_info->btree_inode);
 
 	btrfs_stop_workers(&fs_info->fixup_workers);
 	btrfs_stop_workers(&fs_info->delalloc_workers);
@@ -2014,7 +2058,6 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_stop_workers(&fs_info->endio_write_workers);
 	btrfs_stop_workers(&fs_info->submit_workers);
 
-	iput(fs_info->btree_inode);
 #if 0
 	while(!list_empty(&fs_info->hashers)) {
 		struct btrfs_hasher *hasher;
diff -urp 2/fs/btrfs/disk-io.h 3/fs/btrfs/disk-io.h
--- 2/fs/btrfs/disk-io.h	2008-11-07 19:16:08.000000000 +0800
+++ 3/fs/btrfs/disk-io.h	2008-11-11 10:46:08.000000000 +0800
@@ -38,6 +38,7 @@ struct btrfs_root *open_ctree(struct sup
 int close_ctree(struct btrfs_root *root);
 int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root);
+int btrfs_commit_super(struct btrfs_root *root);
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
 					    u64 bytenr, u32 blocksize);
 struct btrfs_root *btrfs_lookup_fs_root(struct btrfs_fs_info *fs_info,
@@ -49,6 +50,7 @@ struct btrfs_root *btrfs_read_fs_root_no
 					       struct btrfs_key *location);
 struct btrfs_root *btrfs_read_fs_root_no_name(struct btrfs_fs_info *fs_info,
 					      struct btrfs_key *location);
+int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info);
 int btrfs_insert_dev_radix(struct btrfs_root *root,
 			   struct block_device *bdev,
 			   u64 device_id,
diff -urp 2/fs/btrfs/extent-tree.c 3/fs/btrfs/extent-tree.c
--- 2/fs/btrfs/extent-tree.c	2008-11-11 10:44:14.000000000 +0800
+++ 3/fs/btrfs/extent-tree.c	2008-11-11 10:46:08.000000000 +0800
@@ -1277,7 +1277,7 @@ static int update_space_info(struct btrf
 		*space_info = found;
 		return 0;
 	}
-	found = kmalloc(sizeof(*found), GFP_NOFS);
+	found = kzalloc(sizeof(*found), GFP_NOFS);
 	if (!found)
 		return -ENOMEM;
 
@@ -1290,6 +1290,7 @@ static int update_space_info(struct btrf
 	found->bytes_used = bytes_used;
 	found->bytes_pinned = 0;
 	found->bytes_reserved = 0;
+	found->bytes_readonly = 0;
 	found->full = 0;
 	found->force_alloc = 0;
 	*space_info = found;
@@ -1312,6 +1313,19 @@ static void set_avail_alloc_bits(struct 
 	}
 }
 
+static void set_block_group_readonly(struct btrfs_block_group_cache *cache)
+{
+	spin_lock(&cache->space_info->lock);
+	spin_lock(&cache->lock);
+	if (!cache->ro) {
+		cache->space_info->bytes_readonly += cache->key.offset -
+					btrfs_block_group_used(&cache->item);
+		cache->ro = 1;
+	}
+	spin_unlock(&cache->lock);
+	spin_unlock(&cache->space_info->lock);
+}
+
 static u64 reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 {
 	u64 num_devices = root->fs_info->fs_devices->num_devices;
@@ -1348,7 +1362,9 @@ static int do_chunk_alloc(struct btrfs_t
 	u64 thresh;
 	u64 start;
 	u64 num_bytes;
-	int ret = 0, waited = 0;
+	int ret = 0;
+
+	mutex_lock(&extent_root->fs_info->chunk_mutex);
 
 	flags = reduce_alloc_profile(extent_root, flags);
 
@@ -1370,46 +1386,28 @@ static int do_chunk_alloc(struct btrfs_t
 		goto out;
 	}
 
-	thresh = div_factor(space_info->total_bytes, 6);
+	thresh = space_info->total_bytes - space_info->bytes_readonly;
+	thresh = div_factor(thresh, 6);
 	if (!force &&
 	   (space_info->bytes_used + space_info->bytes_pinned +
 	    space_info->bytes_reserved + alloc_bytes) < thresh) {
 		spin_unlock(&space_info->lock);
 		goto out;
 	}
-
 	spin_unlock(&space_info->lock);
 
-	ret = mutex_trylock(&extent_root->fs_info->chunk_mutex);
-	if (!ret && !force) {
-		goto out;
-	} else if (!ret) {
-		mutex_lock(&extent_root->fs_info->chunk_mutex);
-		waited = 1;
-	}
-
-	if (waited) {
-		spin_lock(&space_info->lock);
-		if (space_info->full) {
-			spin_unlock(&space_info->lock);
-			goto out_unlock;
-		}
-		spin_unlock(&space_info->lock);
-	}
-
 	ret = btrfs_alloc_chunk(trans, extent_root, &start, &num_bytes, flags);
 	if (ret) {
 printk("space info full %Lu\n", flags);
 		space_info->full = 1;
-		goto out_unlock;
+		goto out;
 	}
 
 	ret = btrfs_make_block_group(trans, extent_root, 0, flags,
 		     BTRFS_FIRST_CHUNK_TREE_OBJECTID, start, num_bytes);
 	BUG_ON(ret);
-out_unlock:
-	mutex_unlock(&extent_root->fs_info->chunk_mutex);
 out:
+	mutex_unlock(&extent_root->fs_info->chunk_mutex);
 	return ret;
 }
 
@@ -1440,12 +1438,18 @@ static int update_block_group(struct btr
 		if (alloc) {
 			old_val += num_bytes;
 			cache->space_info->bytes_used += num_bytes;
+			if (cache->ro) {
+				cache->space_info->bytes_readonly -= num_bytes;
+				WARN_ON(1);
+			}
 			btrfs_set_block_group_used(&cache->item, old_val);
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
 		} else {
 			old_val -= num_bytes;
 			cache->space_info->bytes_used -= num_bytes;
+			if (cache->ro)
+				cache->space_info->bytes_readonly += num_bytes;
 			btrfs_set_block_group_used(&cache->item, old_val);
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
@@ -4918,8 +4922,7 @@ int btrfs_relocate_block_group(struct bt
 	BUG_ON(IS_ERR(reloc_inode));
 
 	__alloc_chunk_for_shrink(root, block_group, 1);
-	block_group->ro = 1;
-	block_group->space_info->total_bytes -= block_group->key.offset;
+	set_block_group_readonly(block_group);
 
 	btrfs_start_delalloc_inodes(info->tree_root);
 	btrfs_wait_ordered_extents(info->tree_root, 0);
@@ -5226,6 +5229,7 @@ int btrfs_remove_block_group(struct btrf
 
 	block_group = btrfs_lookup_block_group(root->fs_info, group_start);
 	BUG_ON(!block_group);
+	BUG_ON(!block_group->ro);
 
 	memcpy(&key, &block_group->key, sizeof(key));
 
@@ -5239,6 +5243,11 @@ int btrfs_remove_block_group(struct btrf
 	list_del(&block_group->list);
 	up_write(&block_group->space_info->groups_sem);
 
+	spin_lock(&block_group->space_info->lock);
+	block_group->space_info->total_bytes -= block_group->key.offset;
+	block_group->space_info->bytes_readonly -= block_group->key.offset;
+	spin_unlock(&block_group->space_info->lock);
+
 	/*
 	memset(shrink_block_group, 0, sizeof(*shrink_block_group));
 	kfree(shrink_block_group);
diff -urp 2/fs/btrfs/inode.c 3/fs/btrfs/inode.c
--- 2/fs/btrfs/inode.c	2008-11-11 10:43:08.000000000 +0800
+++ 3/fs/btrfs/inode.c	2008-11-11 10:46:08.000000000 +0800
@@ -1808,10 +1808,6 @@ void btrfs_orphan_cleanup(struct btrfs_r
 	struct inode *inode;
 	int ret = 0, nr_unlink = 0, nr_truncate = 0;
 
-	/* don't do orphan cleanup if the fs is readonly. */
-	if (root->fs_info->sb->s_flags & MS_RDONLY)
-		return;
-
 	path = btrfs_alloc_path();
 	if (!path)
 		return;
@@ -3050,7 +3046,7 @@ static struct dentry *btrfs_lookup(struc
 	struct btrfs_root *root = bi->root;
 	struct btrfs_root *sub_root = root;
 	struct btrfs_key location;
-	int ret, new, do_orphan = 0;
+	int ret, new;
 
 	if (dentry->d_name.len > BTRFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -3076,13 +3072,9 @@ static struct dentry *btrfs_lookup(struc
 		if (new && root != sub_root) {
 			igrab(inode);
 			sub_root->inode = inode;
-			do_orphan = 1;
 		}
 	}
 
-	if (unlikely(do_orphan))
-		btrfs_orphan_cleanup(sub_root);
-
 	return d_splice_alias(inode, dentry);
 }
 
@@ -3237,7 +3229,7 @@ int btrfs_write_inode(struct inode *inod
 	struct btrfs_trans_handle *trans;
 	int ret = 0;
 
-	if (root->fs_info->closing > 1)
+	if (root->fs_info->btree_inode == inode)
 		return 0;
 
 	if (wait) {
@@ -4625,6 +4617,9 @@ int btrfs_start_delalloc_inodes(struct b
 	struct inode *inode;
 	unsigned long flags;
 
+	if (root->fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
 	spin_lock_irqsave(&root->fs_info->delalloc_lock, flags);
 	while(!list_empty(head)) {
 		binode = list_entry(head->next, struct btrfs_inode,
diff -urp 2/fs/btrfs/ioctl.c 3/fs/btrfs/ioctl.c
--- 2/fs/btrfs/ioctl.c	2008-11-01 01:04:31.000000000 +0800
+++ 3/fs/btrfs/ioctl.c	2008-11-11 10:46:08.000000000 +0800
@@ -378,6 +378,9 @@ static int btrfs_ioctl_resize(struct btr
 	int namelen;
 	int mod = 0;
 
+	if (root->fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
 	vol_args = kmalloc(sizeof(*vol_args), GFP_NOFS);
 
 	if (!vol_args)
@@ -478,6 +481,9 @@ static noinline int btrfs_ioctl_snap_cre
 	int namelen;
 	int ret;
 
+	if (root->fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
 	vol_args = kmalloc(sizeof(*vol_args), GFP_NOFS);
 
 	if (!vol_args)
@@ -534,6 +540,11 @@ static int btrfs_ioctl_defrag(struct fil
 {
 	struct inode *inode = fdentry(file)->d_inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret;
+
+	ret = mnt_want_write(file->f_path.mnt);
+	if (ret)
+		return ret;
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFDIR:
@@ -575,6 +586,9 @@ long btrfs_ioctl_rm_dev(struct btrfs_roo
 	struct btrfs_ioctl_vol_args *vol_args;
 	int ret;
 
+	if (root->fs_info->sb->s_flags & MS_RDONLY)
+		return -EROFS;
+
 	vol_args = kmalloc(sizeof(*vol_args), GFP_NOFS);
 
 	if (!vol_args)
@@ -607,6 +621,10 @@ long btrfs_ioctl_clone(struct file *file
 	int slot;
 	int ret;
 
+	ret = mnt_want_write(file->f_path.mnt);
+	if (ret)
+		return ret;
+
 	src_file = fget(src_fd);
 	if (!src_file)
 		return -EBADF;
@@ -789,6 +807,10 @@ long btrfs_ioctl_trans_start(struct file
 		goto out;
 	}
 
+	ret = mnt_want_write(file->f_path.mnt);
+	if (ret)
+		goto out;
+
 	mutex_lock(&root->fs_info->trans_mutex);
 	root->fs_info->open_ioctl_trans++;
 	mutex_unlock(&root->fs_info->trans_mutex);
diff -urp 2/fs/btrfs/super.c 3/fs/btrfs/super.c
--- 2/fs/btrfs/super.c	2008-11-07 19:16:08.000000000 +0800
+++ 3/fs/btrfs/super.c	2008-11-11 10:46:08.000000000 +0800
@@ -370,6 +370,9 @@ int btrfs_sync_fs(struct super_block *sb
 	int ret;
 	root = btrfs_sb(sb);
 
+	if (sb->s_flags & MS_RDONLY)
+		return 0;
+
 	sb->s_dirt = 0;
 	if (!wait) {
 		filemap_flush(root->fs_info->btree_inode->i_mapping);
@@ -438,7 +441,7 @@ static int btrfs_get_sb(struct file_syst
 			up_write(&s->s_umount);
 			deactivate_super(s);
 			error = -EBUSY;
-			goto error_bdev;
+			goto error_close_devices;
 		}
 
 	} else {
@@ -487,7 +490,7 @@ static int btrfs_get_sb(struct file_syst
 
 error_s:
 	error = PTR_ERR(s);
-error_bdev:
+error_close_devices:
 	btrfs_close_devices(fs_devices);
 error_free_subvol_name:
 	kfree(subvol_name);
@@ -495,6 +498,35 @@ error:
 	return error;
 }
 
+static int btrfs_remount(struct super_block *sb, int *flags, char *data)
+{
+	struct btrfs_root *root = btrfs_sb(sb);
+	int ret;
+
+	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY))
+		return 0;
+
+	if (*flags & MS_RDONLY) {
+		sb->s_flags |= MS_RDONLY;
+
+		ret =  btrfs_commit_super(root);
+		WARN_ON(ret);
+	} else {
+		if (btrfs_super_log_root(&root->fs_info->super_copy) != 0)
+			return -EINVAL;
+
+		ret = btrfs_cleanup_reloc_trees(root);
+		WARN_ON(ret);
+
+		ret = btrfs_cleanup_fs_roots(root->fs_info);
+		WARN_ON(ret);
+
+		sb->s_flags &= ~MS_RDONLY;
+	}
+
+	return 0;
+}
+
 static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct btrfs_root *root = btrfs_sb(dentry->d_sb);
@@ -582,6 +614,7 @@ static struct super_operations btrfs_sup
 	.alloc_inode	= btrfs_alloc_inode,
 	.destroy_inode	= btrfs_destroy_inode,
 	.statfs		= btrfs_statfs,
+	.remount_fs	= btrfs_remount,
 	.write_super_lockfs = btrfs_write_super_lockfs,
 	.unlockfs	= btrfs_unlockfs,
 };

