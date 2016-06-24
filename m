Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbcFXWPc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 18:15:32 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 5CF1FADE2
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 22:15:28 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 16/31] btrfs: call functions that always use the same root with fs_info instead
Date: Fri, 24 Jun 2016 18:15:09 -0400
Message-Id: <1466806524-27508-17-git-send-email-jeffm@suse.com>
In-Reply-To: <1466806524-27508-1-git-send-email-jeffm@suse.com>
References: <1466806524-27508-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

There are many functions that are always called with the same root
argument.  Rather than passing the same root every time, we can
pass an fs_info pointer instead and have the function get the root
pointer itself.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ctree.h             | 16 +++++++--------
 fs/btrfs/disk-io.c           | 44 ++++++++++++++++++++++--------------------
 fs/btrfs/disk-io.h           |  4 ++--
 fs/btrfs/extent-tree.c       | 20 ++++++++++---------
 fs/btrfs/inode.c             |  6 +++---
 fs/btrfs/ioctl.c             | 18 ++++++++---------
 fs/btrfs/relocation.c        |  4 ++--
 fs/btrfs/root-tree.c         |  9 ++++++---
 fs/btrfs/super.c             | 13 +++++++------
 fs/btrfs/transaction.c       |  6 +++---
 fs/btrfs/uuid-tree.c         | 10 ++++++----
 fs/btrfs/volumes.c           | 46 +++++++++++++++++++++++++-------------------
 fs/btrfs/volumes.h           |  4 ++--
 include/trace/events/btrfs.h | 16 +++++++--------
 14 files changed, 115 insertions(+), 101 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index cc2d8f5..7063c55 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2612,7 +2612,7 @@ int btrfs_setup_space_cache(struct btrfs_trans_handle *trans,
 int btrfs_extent_readonly(struct btrfs_root *root, u64 bytenr);
 int btrfs_free_block_groups(struct btrfs_fs_info *info);
 int btrfs_read_block_groups(struct btrfs_fs_info *info);
-int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr);
+int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr);
 int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, u64 bytes_used,
 			   u64 type, u64 chunk_objectid, u64 chunk_offset,
@@ -2621,7 +2621,7 @@ struct btrfs_trans_handle *btrfs_start_trans_remove_block_group(
 				struct btrfs_fs_info *fs_info,
 				const u64 chunk_offset);
 int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root, u64 group_start,
+			     struct btrfs_fs_info *fs_info, u64 group_start,
 			     struct extent_map *em);
 void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info);
 void btrfs_get_block_group_trimming(struct btrfs_block_group_cache *cache);
@@ -2894,11 +2894,11 @@ int btrfs_old_root_level(struct btrfs_root *root, u64 time_seq);
 
 /* root-item.c */
 int btrfs_add_root_ref(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *tree_root,
+		       struct btrfs_fs_info *fs_info,
 		       u64 root_id, u64 ref_id, u64 dirid, u64 sequence,
 		       const char *name, int name_len);
 int btrfs_del_root_ref(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *tree_root,
+		       struct btrfs_fs_info *fs_info,
 		       u64 root_id, u64 ref_id, u64 dirid, u64 *sequence,
 		       const char *name, int name_len);
 int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
@@ -2913,7 +2913,7 @@ int __must_check btrfs_update_root(struct btrfs_trans_handle *trans,
 int btrfs_find_root(struct btrfs_root *root, struct btrfs_key *search_key,
 		    struct btrfs_path *path, struct btrfs_root_item *root_item,
 		    struct btrfs_key *root_key);
-int btrfs_find_orphan_roots(struct btrfs_root *tree_root);
+int btrfs_find_orphan_roots(struct btrfs_fs_info *fs_info);
 void btrfs_set_root_node(struct btrfs_root_item *item,
 			 struct extent_buffer *node);
 void btrfs_check_and_init_root_item(struct btrfs_root_item *item);
@@ -2922,10 +2922,10 @@ void btrfs_update_root_times(struct btrfs_trans_handle *trans,
 
 /* uuid-tree.c */
 int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans,
-			struct btrfs_root *uuid_root, u8 *uuid, u8 type,
+			struct btrfs_fs_info *fs_info, u8 *uuid, u8 type,
 			u64 subid);
 int btrfs_uuid_tree_rem(struct btrfs_trans_handle *trans,
-			struct btrfs_root *uuid_root, u8 *uuid, u8 type,
+			struct btrfs_fs_info *fs_info, u8 *uuid, u8 type,
 			u64 subid);
 int btrfs_uuid_tree_iterate(struct btrfs_fs_info *fs_info,
 			    int (*check_func)(struct btrfs_fs_info *, u8 *, u8,
@@ -3542,7 +3542,7 @@ static inline int btrfs_init_acl(struct btrfs_trans_handle *trans,
 #endif
 
 /* relocation.c */
-int btrfs_relocate_block_group(struct btrfs_root *root, u64 group_start);
+int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start);
 int btrfs_init_reloc_root(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root);
 int btrfs_update_reloc_root(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 42d4a31..5a71cb8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2258,8 +2258,7 @@ static void btrfs_init_balance(struct btrfs_fs_info *fs_info)
 	init_waitqueue_head(&fs_info->balance_wait_q);
 }
 
-static void btrfs_init_btree_inode(struct btrfs_fs_info *fs_info,
-				   struct btrfs_root *tree_root)
+static void btrfs_init_btree_inode(struct btrfs_fs_info *fs_info)
 {
 	fs_info->btree_inode->i_ino = BTRFS_BTREE_INODE_OBJECTID;
 	set_nlink(fs_info->btree_inode, 1);
@@ -2279,7 +2278,7 @@ static void btrfs_init_btree_inode(struct btrfs_fs_info *fs_info,
 
 	BTRFS_I(fs_info->btree_inode)->io_tree.ops = &btree_extent_io_ops;
 
-	BTRFS_I(fs_info->btree_inode)->root = tree_root;
+	BTRFS_I(fs_info->btree_inode)->root = fs_info->tree_root;
 	memset(&BTRFS_I(fs_info->btree_inode)->location, 0,
 	       sizeof(struct btrfs_key));
 	set_bit(BTRFS_INODE_DUMMY,
@@ -2448,7 +2447,7 @@ static int btrfs_replay_log(struct btrfs_fs_info *fs_info,
 	}
 
 	if (fs_info->sb->s_flags & MS_RDONLY) {
-		ret = btrfs_commit_super(tree_root);
+		ret = btrfs_commit_super(fs_info);
 		if (ret)
 			return ret;
 	}
@@ -2456,13 +2455,15 @@ static int btrfs_replay_log(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-static int btrfs_read_roots(struct btrfs_fs_info *fs_info,
-			    struct btrfs_root *tree_root)
+static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
 {
+	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_root *root;
 	struct btrfs_key location;
 	int ret;
 
+	BUG_ON(!fs_info->tree_root);
+
 	location.objectid = BTRFS_EXTENT_TREE_OBJECTID;
 	location.type = BTRFS_ROOT_ITEM_KEY;
 	location.offset = 0;
@@ -2672,7 +2673,7 @@ int open_ctree(struct super_block *sb,
 	sb->s_blocksize_bits = blksize_bits(4096);
 	sb->s_bdi = &fs_info->bdi;
 
-	btrfs_init_btree_inode(fs_info, tree_root);
+	btrfs_init_btree_inode(fs_info);
 
 	spin_lock_init(&fs_info->block_group_cache_lock);
 	fs_info->block_group_cache_tree = RB_ROOT;
@@ -2871,7 +2872,7 @@ int open_ctree(struct super_block *sb,
 	sb->s_blocksize_bits = blksize_bits(sectorsize);
 
 	mutex_lock(&fs_info->chunk_mutex);
-	ret = btrfs_read_sys_array(tree_root);
+	ret = btrfs_read_sys_array(fs_info);
 	mutex_unlock(&fs_info->chunk_mutex);
 	if (ret) {
 		btrfs_err(fs_info, "failed to read the system array: %d", ret);
@@ -2948,7 +2949,7 @@ retry_root_backup:
 
 	mutex_unlock(&tree_root->objectid_mutex);
 
-	ret = btrfs_read_roots(fs_info, tree_root);
+	ret = btrfs_read_roots(fs_info);
 	if (ret)
 		goto recovery_tree_root;
 
@@ -3069,7 +3070,7 @@ retry_root_backup:
 		}
 	}
 
-	ret = btrfs_find_orphan_roots(tree_root);
+	ret = btrfs_find_orphan_roots(fs_info);
 	if (ret)
 		goto fail_qgroup;
 
@@ -3109,7 +3110,7 @@ retry_root_backup:
 		if (ret) {
 			btrfs_warn(fs_info,
 				"failed to create free space tree: %d", ret);
-			close_ctree(tree_root);
+			close_ctree(fs_info);
 			return ret;
 		}
 	}
@@ -3118,7 +3119,7 @@ retry_root_backup:
 	if ((ret = btrfs_orphan_cleanup(fs_info->fs_root)) ||
 	    (ret = btrfs_orphan_cleanup(fs_info->tree_root))) {
 		up_read(&fs_info->cleanup_work_sem);
-		close_ctree(tree_root);
+		close_ctree(fs_info);
 		return ret;
 	}
 	up_read(&fs_info->cleanup_work_sem);
@@ -3126,14 +3127,14 @@ retry_root_backup:
 	ret = btrfs_resume_balance_async(fs_info);
 	if (ret) {
 		btrfs_warn(fs_info, "failed to resume balance: %d", ret);
-		close_ctree(tree_root);
+		close_ctree(fs_info);
 		return ret;
 	}
 
 	ret = btrfs_resume_dev_replace_async(fs_info);
 	if (ret) {
 		btrfs_warn(fs_info, "failed to resume device replace: %d", ret);
-		close_ctree(tree_root);
+		close_ctree(fs_info);
 		return ret;
 	}
 
@@ -3146,7 +3147,7 @@ retry_root_backup:
 		if (ret) {
 			btrfs_warn(fs_info,
 				"failed to clear free space tree: %d", ret);
-			close_ctree(tree_root);
+			close_ctree(fs_info);
 			return ret;
 		}
 	}
@@ -3157,7 +3158,7 @@ retry_root_backup:
 		if (ret) {
 			btrfs_warn(fs_info,
 				"failed to create the UUID tree: %d", ret);
-			close_ctree(tree_root);
+			close_ctree(fs_info);
 			return ret;
 		}
 	} else if (btrfs_test_opt(tree_root->fs_info, RESCAN_UUID_TREE) ||
@@ -3168,7 +3169,7 @@ retry_root_backup:
 		if (ret) {
 			btrfs_warn(fs_info,
 				"failed to check the UUID tree: %d", ret);
-			close_ctree(tree_root);
+			close_ctree(fs_info);
 			return ret;
 		}
 	} else {
@@ -3834,8 +3835,9 @@ int btrfs_cleanup_fs_roots(struct btrfs_fs_info *fs_info)
 	return err;
 }
 
-int btrfs_commit_super(struct btrfs_root *root)
+int btrfs_commit_super(struct btrfs_fs_info *fs_info)
 {
+	struct btrfs_root *root = fs_info->tree_root;
 	struct btrfs_trans_handle *trans;
 
 	mutex_lock(&root->fs_info->cleaner_mutex);
@@ -3853,9 +3855,9 @@ int btrfs_commit_super(struct btrfs_root *root)
 	return btrfs_commit_transaction(trans, root);
 }
 
-void close_ctree(struct btrfs_root *root)
+void close_ctree(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_root *root = fs_info->tree_root;
 	int ret;
 
 	fs_info->closing = 1;
@@ -3893,7 +3895,7 @@ void close_ctree(struct btrfs_root *root)
 		 */
 		btrfs_delete_unused_bgs(root->fs_info);
 
-		ret = btrfs_commit_super(root);
+		ret = btrfs_commit_super(fs_info);
 		if (ret)
 			btrfs_err(fs_info, "commit super ret %d", ret);
 	}
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index c9d42c9..25cb43c 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -56,13 +56,13 @@ void clean_tree_block(struct btrfs_trans_handle *trans,
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options);
-void close_ctree(struct btrfs_root *root);
+void close_ctree(struct btrfs_fs_info *fs_info);
 int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int max_mirrors);
 struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
 int btrfs_read_dev_one_super(struct block_device *bdev, int copy_num,
 			struct buffer_head **bh_ret);
-int btrfs_commit_super(struct btrfs_root *root);
+int btrfs_commit_super(struct btrfs_fs_info *fs_info);
 struct extent_buffer *btrfs_find_tree_block(struct btrfs_fs_info *fs_info,
 					    u64 bytenr);
 struct btrfs_root *btrfs_read_fs_root(struct btrfs_root *tree_root,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 0b493c4..e6ad776 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9495,8 +9495,9 @@ void btrfs_dec_block_group_ro(struct btrfs_root *root,
  * @return - -1 if it's not a good idea to relocate this block group, 0 if its
  * ok to go ahead and try.
  */
-int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
+int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr)
 {
+	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_block_group_cache *block_group;
 	struct btrfs_space_info *space_info;
 	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
@@ -9640,9 +9641,11 @@ out:
 	return ret;
 }
 
-static int find_first_block_group(struct btrfs_root *root,
-		struct btrfs_path *path, struct btrfs_key *key)
+static int find_first_block_group(struct btrfs_fs_info *fs_info,
+				  struct btrfs_path *path,
+				  struct btrfs_key *key)
 {
+	struct btrfs_root *root = fs_info->extent_root;
 	int ret = 0;
 	struct btrfs_key found_key;
 	struct extent_buffer *leaf;
@@ -9913,7 +9916,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 		need_clear = 1;
 
 	while (1) {
-		ret = find_first_block_group(root, path, &key);
+		ret = find_first_block_group(info, path, &key);
 		if (ret > 0)
 			break;
 		if (ret != 0)
@@ -10085,7 +10088,7 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
 					sizeof(item));
 		if (ret)
 			btrfs_abort_transaction(trans, ret);
-		ret = btrfs_finish_chunk_alloc(trans, extent_root,
+		ret = btrfs_finish_chunk_alloc(trans, extent_root->fs_info,
 					       key.objectid, key.offset);
 		if (ret)
 			btrfs_abort_transaction(trans, ret);
@@ -10213,9 +10216,10 @@ static void clear_avail_alloc_bits(struct btrfs_fs_info *fs_info, u64 flags)
 }
 
 int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
-			     struct btrfs_root *root, u64 group_start,
+			     struct btrfs_fs_info *fs_info, u64 group_start,
 			     struct extent_map *em)
 {
+	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_path *path;
 	struct btrfs_block_group_cache *block_group;
 	struct btrfs_free_cluster *cluster;
@@ -10229,9 +10233,7 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	struct btrfs_caching_control *caching_ctl = NULL;
 	bool remove_em;
 
-	root = root->fs_info->extent_root;
-
-	block_group = btrfs_lookup_block_group(root->fs_info, group_start);
+	block_group = btrfs_lookup_block_group(fs_info, group_start);
 	BUG_ON(!block_group);
 	BUG_ON(!block_group->ro);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 322ee50..4a9ebb7 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4148,7 +4148,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	}
 	btrfs_release_path(path);
 
-	ret = btrfs_del_root_ref(trans, root->fs_info->tree_root,
+	ret = btrfs_del_root_ref(trans, root->fs_info,
 				 objectid, root->root_key.objectid,
 				 dir_ino, &index, name, name_len);
 	if (ret < 0) {
@@ -6296,7 +6296,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	}
 
 	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
-		ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
+		ret = btrfs_add_root_ref(trans, root->fs_info,
 					 key.objectid, root->root_key.objectid,
 					 parent_ino, index, name, name_len);
 	} else if (add_backref) {
@@ -6332,7 +6332,7 @@ fail_dir_item:
 	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		u64 local_index;
 		int err;
-		err = btrfs_del_root_ref(trans, root->fs_info->tree_root,
+		err = btrfs_del_root_ref(trans, root->fs_info,
 				 key.objectid, root->root_key.objectid,
 				 parent_ino, &local_index, name, name_len);
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 14ed1e9..2ce7c18 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -599,14 +599,13 @@ static noinline int create_subvol(struct inode *dir,
 	ret = btrfs_update_inode(trans, root, dir);
 	BUG_ON(ret);
 
-	ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
+	ret = btrfs_add_root_ref(trans, root->fs_info,
 				 objectid, root->root_key.objectid,
 				 btrfs_ino(dir), index, name, namelen);
 	BUG_ON(ret);
 
-	ret = btrfs_uuid_tree_add(trans, root->fs_info->uuid_root,
-				  root_item->uuid, BTRFS_UUID_KEY_SUBVOL,
-				  objectid);
+	ret = btrfs_uuid_tree_add(trans, root->fs_info, root_item->uuid,
+				  BTRFS_UUID_KEY_SUBVOL, objectid);
 	if (ret)
 		btrfs_abort_transaction(trans, ret);
 
@@ -2510,8 +2509,8 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 		}
 	}
 
-	ret = btrfs_uuid_tree_rem(trans, root->fs_info->uuid_root,
-				  dest->root_item.uuid, BTRFS_UUID_KEY_SUBVOL,
+	ret = btrfs_uuid_tree_rem(trans, root->fs_info, dest->root_item.uuid,
+				  BTRFS_UUID_KEY_SUBVOL,
 				  dest->root_key.objectid);
 	if (ret && ret != -ENOENT) {
 		btrfs_abort_transaction(trans, ret);
@@ -2519,7 +2518,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 		goto out_end_trans;
 	}
 	if (!btrfs_is_empty_uuid(dest->root_item.received_uuid)) {
-		ret = btrfs_uuid_tree_rem(trans, root->fs_info->uuid_root,
+		ret = btrfs_uuid_tree_rem(trans, root->fs_info,
 					  dest->root_item.received_uuid,
 					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
 					  dest->root_key.objectid);
@@ -5136,7 +5135,7 @@ static long _btrfs_ioctl_set_received_subvol(struct file *file,
 				       BTRFS_UUID_SIZE);
 	if (received_uuid_changed &&
 	    !btrfs_is_empty_uuid(root_item->received_uuid))
-		btrfs_uuid_tree_rem(trans, root->fs_info->uuid_root,
+		btrfs_uuid_tree_rem(trans, root->fs_info,
 				    root_item->received_uuid,
 				    BTRFS_UUID_KEY_RECEIVED_SUBVOL,
 				    root->root_key.objectid);
@@ -5155,8 +5154,7 @@ static long _btrfs_ioctl_set_received_subvol(struct file *file,
 		goto out;
 	}
 	if (received_uuid_changed && !btrfs_is_empty_uuid(sa->uuid)) {
-		ret = btrfs_uuid_tree_add(trans, root->fs_info->uuid_root,
-					  sa->uuid,
+		ret = btrfs_uuid_tree_add(trans, root->fs_info, sa->uuid,
 					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
 					  root->root_key.objectid);
 		if (ret < 0 && ret != -EEXIST) {
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 9d07953..8ee2c2f 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4197,9 +4197,9 @@ static struct reloc_control *alloc_reloc_control(struct btrfs_fs_info *fs_info)
 /*
  * function to relocate all extents in a block group.
  */
-int btrfs_relocate_block_group(struct btrfs_root *extent_root, u64 group_start)
+int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start)
 {
-	struct btrfs_fs_info *fs_info = extent_root->fs_info;
+	struct btrfs_root *extent_root = fs_info->extent_root;
 	struct reloc_control *rc;
 	struct inode *inode;
 	struct btrfs_path *path;
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 7fd7e18..a2a99da 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -220,8 +220,9 @@ int btrfs_insert_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	return btrfs_insert_item(trans, root, key, item, sizeof(*item));
 }
 
-int btrfs_find_orphan_roots(struct btrfs_root *tree_root)
+int btrfs_find_orphan_roots(struct btrfs_fs_info *fs_info)
 {
+	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct extent_buffer *leaf;
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -355,11 +356,12 @@ out:
 }
 
 int btrfs_del_root_ref(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *tree_root,
+		       struct btrfs_fs_info *fs_info,
 		       u64 root_id, u64 ref_id, u64 dirid, u64 *sequence,
 		       const char *name, int name_len)
 
 {
+	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_path *path;
 	struct btrfs_root_ref *ref;
 	struct extent_buffer *leaf;
@@ -426,10 +428,11 @@ out:
  * Will return 0, -ENOMEM, or anything from the CoW path
  */
 int btrfs_add_root_ref(struct btrfs_trans_handle *trans,
-		       struct btrfs_root *tree_root,
+		       struct btrfs_fs_info *fs_info,
 		       u64 root_id, u64 ref_id, u64 dirid, u64 sequence,
 		       const char *name, int name_len)
 {
+	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_key key;
 	int ret;
 	struct btrfs_path *path;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4c031d7..1cdb9a2 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -284,7 +284,7 @@ void __btrfs_panic(struct btrfs_fs_info *fs_info, const char *function,
 
 static void btrfs_put_super(struct super_block *sb)
 {
-	close_ctree(btrfs_sb(sb)->tree_root);
+	close_ctree(btrfs_sb(sb));
 }
 
 enum {
@@ -1145,7 +1145,7 @@ static int btrfs_fill_super(struct super_block *sb,
 	return 0;
 
 fail_close:
-	close_ctree(fs_info->tree_root);
+	close_ctree(fs_info);
 	return err;
 }
 
@@ -1754,7 +1754,7 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		btrfs_scrub_cancel(fs_info);
 		btrfs_pause_balance(fs_info);
 
-		ret = btrfs_commit_super(root);
+		ret = btrfs_commit_super(fs_info);
 		if (ret)
 			goto restore;
 	} else {
@@ -1869,9 +1869,10 @@ static inline void btrfs_descending_sort_devices(
  * The helper to calc the free space on the devices that can be used to store
  * file data.
  */
-static int btrfs_calc_avail_data_space(struct btrfs_root *root, u64 *free_bytes)
+static int btrfs_calc_avail_data_space(struct btrfs_fs_info *fs_info,
+				       u64 *free_bytes)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_root *root = fs_info->tree_root;
 	struct btrfs_device_info *devices_info;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *device;
@@ -2112,7 +2113,7 @@ static int btrfs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	spin_unlock(&block_rsv->lock);
 
 	buf->f_bavail = div_u64(total_free_data, factor);
-	ret = btrfs_calc_avail_data_space(fs_info->tree_root, &total_free_data);
+	ret = btrfs_calc_avail_data_space(fs_info, &total_free_data);
 	if (ret)
 		return ret;
 	buf->f_bavail += div_u64(total_free_data, factor);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index b540de1..4b18a20 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1574,7 +1574,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	/*
 	 * insert root back/forward references
 	 */
-	ret = btrfs_add_root_ref(trans, tree_root, objectid,
+	ret = btrfs_add_root_ref(trans, fs_info, objectid,
 				 parent_root->root_key.objectid,
 				 btrfs_ino(parent_inode), index,
 				 dentry->d_name.name, dentry->d_name.len);
@@ -1634,14 +1634,14 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		btrfs_abort_transaction(trans, ret);
 		goto fail;
 	}
-	ret = btrfs_uuid_tree_add(trans, fs_info->uuid_root, new_uuid.b,
+	ret = btrfs_uuid_tree_add(trans, fs_info, new_uuid.b,
 				  BTRFS_UUID_KEY_SUBVOL, objectid);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto fail;
 	}
 	if (!btrfs_is_empty_uuid(new_root_item->received_uuid)) {
-		ret = btrfs_uuid_tree_add(trans, fs_info->uuid_root,
+		ret = btrfs_uuid_tree_add(trans, fs_info,
 					  new_root_item->received_uuid,
 					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
 					  objectid);
diff --git a/fs/btrfs/uuid-tree.c b/fs/btrfs/uuid-tree.c
index 7782829..27cfd7c 100644
--- a/fs/btrfs/uuid-tree.c
+++ b/fs/btrfs/uuid-tree.c
@@ -91,9 +91,10 @@ out:
 }
 
 int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans,
-			struct btrfs_root *uuid_root, u8 *uuid, u8 type,
+			struct btrfs_fs_info *fs_info, u8 *uuid, u8 type,
 			u64 subid_cpu)
 {
+	struct btrfs_root *uuid_root = fs_info->uuid_root;
 	int ret;
 	struct btrfs_path *path = NULL;
 	struct btrfs_key key;
@@ -137,7 +138,7 @@ int btrfs_uuid_tree_add(struct btrfs_trans_handle *trans,
 		offset = btrfs_item_ptr_offset(eb, slot);
 		offset += btrfs_item_size_nr(eb, slot) - sizeof(subid_le);
 	} else if (ret < 0) {
-		btrfs_warn(uuid_root->fs_info, "insert uuid item failed %d "
+		btrfs_warn(fs_info, "insert uuid item failed %d "
 			"(0x%016llx, 0x%016llx) type %u!",
 			ret, (unsigned long long)key.objectid,
 			(unsigned long long)key.offset, type);
@@ -155,9 +156,10 @@ out:
 }
 
 int btrfs_uuid_tree_rem(struct btrfs_trans_handle *trans,
-			struct btrfs_root *uuid_root, u8 *uuid, u8 type,
+			struct btrfs_fs_info *fs_info, u8 *uuid, u8 type,
 			u64 subid)
 {
+	struct btrfs_root *uuid_root = fs_info->uuid_root;
 	int ret;
 	struct btrfs_path *path = NULL;
 	struct btrfs_key key;
@@ -248,7 +250,7 @@ static int btrfs_uuid_iter_rem(struct btrfs_root *uuid_root, u8 *uuid, u8 type,
 		goto out;
 	}
 
-	ret = btrfs_uuid_tree_rem(trans, uuid_root, uuid, type, subid);
+	ret = btrfs_uuid_tree_rem(trans, uuid_root->fs_info, uuid, type, subid);
 	btrfs_end_transaction(trans, uuid_root);
 
 out:
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index befe4a7..ae18210 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2701,9 +2701,10 @@ out:
 	return ret;
 }
 
-static int btrfs_del_sys_chunk(struct btrfs_root *root, u64 chunk_objectid, u64
-			chunk_offset)
+static int btrfs_del_sys_chunk(struct btrfs_fs_info *fs_info,
+			       u64 chunk_objectid, u64 chunk_offset)
 {
+	struct btrfs_root *root = fs_info->chunk_root;
 	struct btrfs_super_block *super_copy = root->fs_info->super_copy;
 	struct btrfs_disk_key *disk_key;
 	struct btrfs_chunk *chunk;
@@ -2832,17 +2833,18 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 		goto out;
 	}
 
-	trace_btrfs_chunk_free(root, map, chunk_offset, em->len);
+	trace_btrfs_chunk_free(fs_info, map, chunk_offset, em->len);
 
 	if (map->type & BTRFS_BLOCK_GROUP_SYSTEM) {
-		ret = btrfs_del_sys_chunk(root, chunk_objectid, chunk_offset);
+		ret = btrfs_del_sys_chunk(fs_info, chunk_objectid,
+					  chunk_offset);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
 			goto out;
 		}
 	}
 
-	ret = btrfs_remove_block_group(trans, extent_root, chunk_offset, em);
+	ret = btrfs_remove_block_group(trans, fs_info, chunk_offset, em);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
 		goto out;
@@ -2875,13 +2877,13 @@ static int btrfs_relocate_chunk(struct btrfs_fs_info *fs_info, u64 chunk_offset)
 	 */
 	ASSERT(mutex_is_locked(&root->fs_info->delete_unused_bgs_mutex));
 
-	ret = btrfs_can_relocate(extent_root, chunk_offset);
+	ret = btrfs_can_relocate(root->fs_info, chunk_offset);
 	if (ret)
 		return -ENOSPC;
 
 	/* step one, relocate all the extents inside this chunk */
 	btrfs_scrub_pause(root);
-	ret = btrfs_relocate_block_group(extent_root, chunk_offset);
+	ret = btrfs_relocate_block_group(root->fs_info, chunk_offset);
 	btrfs_scrub_continue(root);
 	if (ret)
 		return ret;
@@ -2978,9 +2980,10 @@ error:
 	return ret;
 }
 
-static int insert_balance_item(struct btrfs_root *root,
+static int insert_balance_item(struct btrfs_fs_info *fs_info,
 			       struct btrfs_balance_control *bctl)
 {
+	struct btrfs_root *root = fs_info->tree_root;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_balance_item *item;
 	struct btrfs_disk_balance_args disk_bargs;
@@ -3031,8 +3034,9 @@ out:
 	return ret;
 }
 
-static int del_balance_item(struct btrfs_root *root)
+static int del_balance_item(struct btrfs_fs_info *fs_info)
 {
+	struct btrfs_root *root = fs_info->tree_root;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_path *path;
 	struct btrfs_key key;
@@ -3669,7 +3673,7 @@ static void __cancel_balance(struct btrfs_fs_info *fs_info)
 	int ret;
 
 	unset_balance_control(fs_info);
-	ret = del_balance_item(fs_info->tree_root);
+	ret = del_balance_item(fs_info);
 	if (ret)
 		btrfs_handle_fs_error(fs_info, ret, NULL);
 
@@ -3801,7 +3805,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 				bctl->sys.target));
 	}
 
-	ret = insert_balance_item(fs_info->tree_root, bctl);
+	ret = insert_balance_item(fs_info, bctl);
 	if (ret && ret != -EEXIST)
 		goto out;
 
@@ -4093,7 +4097,7 @@ static int btrfs_uuid_scan_kthread(void *data)
 		}
 update_tree:
 		if (!btrfs_is_empty_uuid(root_item.uuid)) {
-			ret = btrfs_uuid_tree_add(trans, fs_info->uuid_root,
+			ret = btrfs_uuid_tree_add(trans, fs_info,
 						  root_item.uuid,
 						  BTRFS_UUID_KEY_SUBVOL,
 						  key.objectid);
@@ -4105,7 +4109,7 @@ update_tree:
 		}
 
 		if (!btrfs_is_empty_uuid(root_item.received_uuid)) {
-			ret = btrfs_uuid_tree_add(trans, fs_info->uuid_root,
+			ret = btrfs_uuid_tree_add(trans, fs_info,
 						  root_item.received_uuid,
 						 BTRFS_UUID_KEY_RECEIVED_SUBVOL,
 						  key.objectid);
@@ -4748,7 +4752,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 
 	num_bytes = stripe_size * data_stripes;
 
-	trace_btrfs_chunk_alloc(info->chunk_root, map, start, num_bytes);
+	trace_btrfs_chunk_alloc(info, map, start, num_bytes);
 
 	em = alloc_extent_map();
 	if (!em) {
@@ -4816,11 +4820,12 @@ error:
 }
 
 int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
-				struct btrfs_root *extent_root,
+				struct btrfs_fs_info *fs_info,
 				u64 chunk_offset, u64 chunk_size)
 {
+	struct btrfs_root *extent_root = fs_info->extent_root;
+	struct btrfs_root *chunk_root = fs_info->chunk_root;
 	struct btrfs_key key;
-	struct btrfs_root *chunk_root = extent_root->fs_info->chunk_root;
 	struct btrfs_device *device;
 	struct btrfs_chunk *chunk;
 	struct btrfs_stripe *stripe;
@@ -6580,8 +6585,9 @@ static int read_one_dev(struct btrfs_root *root,
 	return ret;
 }
 
-int btrfs_read_sys_array(struct btrfs_root *root)
+int btrfs_read_sys_array(struct btrfs_fs_info *fs_info)
 {
+	struct btrfs_root *root = fs_info->tree_root;
 	struct btrfs_super_block *super_copy = root->fs_info->super_copy;
 	struct extent_buffer *sb;
 	struct btrfs_disk_key *disk_key;
@@ -6874,9 +6880,10 @@ out:
 }
 
 static int update_dev_stat_item(struct btrfs_trans_handle *trans,
-				struct btrfs_root *dev_root,
+				struct btrfs_fs_info *fs_info,
 				struct btrfs_device *device)
 {
+	struct btrfs_root *dev_root = fs_info->dev_root;
 	struct btrfs_path *path;
 	struct btrfs_key key;
 	struct extent_buffer *eb;
@@ -6942,7 +6949,6 @@ out:
 int btrfs_run_dev_stats(struct btrfs_trans_handle *trans,
 			struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_root *dev_root = fs_info->dev_root;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	struct btrfs_device *device;
 	int stats_cnt;
@@ -6954,7 +6960,7 @@ int btrfs_run_dev_stats(struct btrfs_trans_handle *trans,
 			continue;
 
 		stats_cnt = atomic_read(&device->dev_stats_ccnt);
-		ret = update_dev_stat_item(trans, dev_root, device);
+		ret = update_dev_stat_item(trans, fs_info, device);
 		if (!ret)
 			atomic_sub(stats_cnt, &device->dev_stats_ccnt);
 	}
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index b0605cb..c5d310d 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -385,7 +385,7 @@ int btrfs_map_sblock(struct btrfs_fs_info *fs_info, int rw,
 int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 		     u64 chunk_start, u64 physical, u64 devid,
 		     u64 **logical, int *naddrs, int *stripe_len);
-int btrfs_read_sys_array(struct btrfs_root *root);
+int btrfs_read_sys_array(struct btrfs_fs_info *fs_info);
 int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info);
 int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *extent_root, u64 type);
@@ -459,7 +459,7 @@ unsigned long btrfs_full_stripe_len(struct btrfs_root *root,
 				    struct btrfs_mapping_tree *map_tree,
 				    u64 logical);
 int btrfs_finish_chunk_alloc(struct btrfs_trans_handle *trans,
-				struct btrfs_root *extent_root,
+				struct btrfs_fs_info *fs_info,
 				u64 chunk_offset, u64 chunk_size);
 int btrfs_remove_chunk(struct btrfs_trans_handle *trans,
 		       struct btrfs_fs_info *fs_info, u64 chunk_offset);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index eba0c65..72ca3a8 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -658,10 +658,10 @@ DEFINE_EVENT(btrfs_delayed_ref_head,  run_delayed_ref_head,
 
 DECLARE_EVENT_CLASS(btrfs__chunk,
 
-	TP_PROTO(struct btrfs_root *root, struct map_lookup *map,
+	TP_PROTO(struct btrfs_fs_info *fs_info, struct map_lookup *map,
 		 u64 offset, u64 size),
 
-	TP_ARGS(root, map, offset, size),
+	TP_ARGS(fs_info, map, offset, size),
 
 	TP_STRUCT__entry_btrfs(
 		__field(	int,  num_stripes		)
@@ -672,13 +672,13 @@ DECLARE_EVENT_CLASS(btrfs__chunk,
 		__field(	u64,  root_objectid		)
 	),
 
-	TP_fast_assign_btrfs(root->fs_info,
+	TP_fast_assign_btrfs(fs_info,
 		__entry->num_stripes	= map->num_stripes;
 		__entry->type		= map->type;
 		__entry->sub_stripes	= map->sub_stripes;
 		__entry->offset		= offset;
 		__entry->size		= size;
-		__entry->root_objectid	= root->root_key.objectid;
+		__entry->root_objectid	= fs_info->chunk_root->root_key.objectid;
 	),
 
 	TP_printk_btrfs("root = %llu(%s), offset = %llu, size = %llu, "
@@ -692,18 +692,18 @@ DECLARE_EVENT_CLASS(btrfs__chunk,
 
 DEFINE_EVENT(btrfs__chunk,  btrfs_chunk_alloc,
 
-	TP_PROTO(struct btrfs_root *root, struct map_lookup *map,
+	TP_PROTO(struct btrfs_fs_info *fs_info, struct map_lookup *map,
 		 u64 offset, u64 size),
 
-	TP_ARGS(root, map, offset, size)
+	TP_ARGS(fs_info, map, offset, size)
 );
 
 DEFINE_EVENT(btrfs__chunk,  btrfs_chunk_free,
 
-	TP_PROTO(struct btrfs_root *root, struct map_lookup *map,
+	TP_PROTO(struct btrfs_fs_info *fs_info, struct map_lookup *map,
 		 u64 offset, u64 size),
 
-	TP_ARGS(root, map, offset, size)
+	TP_ARGS(fs_info, map, offset, size)
 );
 
 TRACE_EVENT(btrfs_cow_block,
-- 
2.7.1

