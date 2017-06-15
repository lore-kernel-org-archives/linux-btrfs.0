Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36246 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdFOKsN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 06:48:13 -0400
Received: by mail-wr0-f193.google.com with SMTP id 77so2716831wrb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Jun 2017 03:48:12 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH] Btrfs: inode.c convert local flags int -> bool
Date: Thu, 15 Jun 2017 13:48:01 +0300
Message-Id: <20170615104801.4949-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just conversion from int to bool where it applicable
Only change function local flags to not break external
function / structures

Reasons:
1. Separate variables like:
   - ret = 1 - ret value with special handling from caller
   - insert = 1 - three-state flag
   - reserve = 1 - just a flag
   - reserved = 0 - just a flag
   - scanned = 0 - counter
2. Sync usage of bool for flags with other code
for decrease blending int/bool

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/inode.c | 93 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 45 insertions(+), 48 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 76e8cfa8aca1..f786e22a5a0e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -458,16 +458,16 @@ static noinline void compress_file_range(struct inode *inode,
 	unsigned long total_compressed = 0;
 	unsigned long total_in = 0;
 	int i;
-	int will_compress;
+	bool will_compress;
 	int compress_type = fs_info->compress_type;
-	int redirty = 0;
+	bool redirty = false;

 	inode_should_defrag(BTRFS_I(inode), start, end, end - start + 1,
 			SZ_16K);

 	actual_end = min_t(u64, isize, end + 1);
 again:
-	will_compress = 0;
+	will_compress = false;
 	nr_pages = (end >> PAGE_SHIFT) - (start >> PAGE_SHIFT) + 1;
 	BUILD_BUG_ON((BTRFS_MAX_COMPRESSED % PAGE_SIZE) != 0);
 	nr_pages = min_t(unsigned long, nr_pages,
@@ -529,7 +529,7 @@ static noinline void compress_file_range(struct inode *inode,
 		 * dirty again later on.
 		 */
 		extent_range_clear_dirty_for_io(inode, start, end);
-		redirty = 1;
+		redirty = true;
 		ret = btrfs_compress_pages(compress_type,
 					   inode->i_mapping, start,
 					   pages,
@@ -552,7 +552,7 @@ static noinline void compress_file_range(struct inode *inode,
 				       PAGE_SIZE - offset);
 				kunmap_atomic(kaddr);
 			}
-			will_compress = 1;
+			will_compress = true;
 		}
 	}
 cont:
@@ -1279,8 +1279,8 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	int extent_type;
 	int ret, err;
 	int type;
-	int nocow;
-	int check_prev = 1;
+	bool nocow;
+	bool check_prev = true;
 	bool nolock;
 	u64 ino = btrfs_ino(BTRFS_I(inode));

@@ -1314,7 +1314,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 			    found_key.type == BTRFS_EXTENT_DATA_KEY)
 				path->slots[0]--;
 		}
-		check_prev = 0;
+		check_prev = false;
 next_slot:
 		leaf = path->nodes[0];
 		if (path->slots[0] >= btrfs_header_nritems(leaf)) {
@@ -1326,7 +1326,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 			leaf = path->nodes[0];
 		}

-		nocow = 0;
+		nocow = false;
 		disk_bytenr = 0;
 		num_bytes = 0;
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
@@ -1407,7 +1407,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 					btrfs_end_write_no_snapshoting(root);
 				goto out_check;
 			}
-			nocow = 1;
+			nocow = true;
 		} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
 			extent_end = found_key.offset +
 				btrfs_file_extent_inline_len(leaf,
@@ -3290,7 +3290,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->vfs_inode.i_sb);
 	struct btrfs_root *root = inode->root;
 	struct btrfs_block_rsv *block_rsv = NULL;
-	int reserve = 0;
+	bool reserve = false;
 	int insert = 0;
 	int ret;

@@ -3328,7 +3328,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans,

 	if (!test_and_set_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
 			      &inode->runtime_flags))
-		reserve = 1;
+		reserve = true;
 	spin_unlock(&root->orphan_lock);

 	/* grab metadata reservation from transaction handle */
@@ -3386,18 +3386,18 @@ static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
 			    struct btrfs_inode *inode)
 {
 	struct btrfs_root *root = inode->root;
-	int delete_item = 0;
-	int release_rsv = 0;
+	bool delete_item = false;
+	bool release_rsv = false;
 	int ret = 0;

 	spin_lock(&root->orphan_lock);
 	if (test_and_clear_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 			       &inode->runtime_flags))
-		delete_item = 1;
+		delete_item = true;

 	if (test_and_clear_bit(BTRFS_INODE_ORPHAN_META_RESERVED,
 			       &inode->runtime_flags))
-		release_rsv = 1;
+		release_rsv = true;
 	spin_unlock(&root->orphan_lock);

 	if (delete_item) {
@@ -3498,7 +3498,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 		if (ret == -ENOENT && root == fs_info->tree_root) {
 			struct btrfs_root *dead_root;
 			struct btrfs_fs_info *fs_info = root->fs_info;
-			int is_dead_root = 0;
+			bool is_dead_root = false;

 			/*
 			 * this is an orphan in the tree root. Currently these
@@ -3516,7 +3516,7 @@ int btrfs_orphan_cleanup(struct btrfs_root *root)
 					    root_list) {
 				if (dead_root->root_key.objectid ==
 				    found_key.objectid) {
-					is_dead_root = 1;
+					is_dead_root = true;
 					break;
 				}
 			}
@@ -4417,8 +4417,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	u64 item_end = 0;
 	u64 last_size = new_size;
 	u32 found_type = (u8)-1;
-	int found_extent;
-	int del_item;
+	bool found_extent;
+	bool del_item;
 	int pending_del_nr = 0;
 	int pending_del_slot = 0;
 	int extent_type = -1;
@@ -4426,9 +4426,9 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	int err = 0;
 	u64 ino = btrfs_ino(BTRFS_I(inode));
 	u64 bytes_deleted = 0;
-	bool be_nice = 0;
-	bool should_throttle = 0;
-	bool should_end = 0;
+	bool be_nice = false;
+	bool should_throttle = false;
+	bool should_end = false;

 	BUG_ON(new_size > 0 && min_type != BTRFS_EXTENT_DATA_KEY);

@@ -4438,7 +4438,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	 */
 	if (!btrfs_is_free_space_inode(BTRFS_I(inode)) &&
 	    test_bit(BTRFS_ROOT_REF_COWS, &root->state))
-		be_nice = 1;
+		be_nice = true;

 	path = btrfs_alloc_path();
 	if (!path)
@@ -4534,16 +4534,13 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			item_end--;
 		}
 		if (found_type > min_type) {
-			del_item = 1;
+			del_item = true;
 		} else {
 			if (item_end < new_size)
 				break;
-			if (found_key.offset >= new_size)
-				del_item = 1;
-			else
-				del_item = 0;
+			del_item = (found_key.offset >= new_size);
 		}
-		found_extent = 0;
+		found_extent = false;
 		/* FIXME, shrink the extent if the ref count is only 1 */
 		if (found_type != BTRFS_EXTENT_DATA_KEY)
 			goto delete;
@@ -4581,7 +4578,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 				/* FIXME blocksize != 4096 */
 				num_dec = btrfs_file_extent_num_bytes(leaf, fi);
 				if (extent_start != 0) {
-					found_extent = 1;
+					found_extent = true;
 					if (test_bit(BTRFS_ROOT_REF_COWS,
 						     &root->state))
 						inode_sub_bytes(inode, num_dec);
@@ -4644,7 +4641,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 		} else {
 			break;
 		}
-		should_throttle = 0;
+		should_throttle = false;

 		if (found_extent &&
 		    (test_bit(BTRFS_ROOT_REF_COWS, &root->state) ||
@@ -4663,11 +4660,11 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 			if (be_nice) {
 				if (truncate_space_check(trans, root,
 							 extent_num_bytes)) {
-					should_end = 1;
+					should_end = true;
 				}
 				if (btrfs_should_throttle_delayed_refs(trans,
 								       fs_info))
-					should_throttle = 1;
+					should_throttle = true;
 			}
 		}

@@ -6445,7 +6442,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct inode *inode = NULL;
 	int err;
-	int drop_inode = 0;
+	bool drop_inode = false;
 	u64 objectid;
 	u64 index = 0;

@@ -6504,7 +6501,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	return err;

 out_unlock_inode:
-	drop_inode = 1;
+	drop_inode = true;
 	unlock_new_inode(inode);
 	goto out_unlock;

@@ -6517,7 +6514,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	struct inode *inode = NULL;
-	int drop_inode_on_err = 0;
+	bool drop_inode_on_err = false;
 	int err;
 	u64 objectid;
 	u64 index = 0;
@@ -6542,7 +6539,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 		err = PTR_ERR(inode);
 		goto out_unlock;
 	}
-	drop_inode_on_err = 1;
+	drop_inode_on_err = true;
 	/*
 	* If the active LSM wants to access the inode during
 	* d_instantiate it needs these. Smack checks to see
@@ -6595,7 +6592,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	u64 index;
 	int err;
-	int drop_inode = 0;
+	bool drop_inode = false;

 	/* do not allow sys_link's with other subvols of the same device */
 	if (root->objectid != BTRFS_I(inode)->root->objectid)
@@ -6632,7 +6629,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 			1, index);

 	if (err) {
-		drop_inode = 1;
+		drop_inode = true;
 	} else {
 		struct dentry *parent = dentry->d_parent;
 		err = btrfs_update_inode(trans, root, inode);
@@ -6670,7 +6667,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = BTRFS_I(dir)->root;
 	int err = 0;
-	int drop_on_err = 0;
+	bool drop_on_err = false;
 	u64 objectid = 0;
 	u64 index = 0;

@@ -6695,7 +6692,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 		goto out_fail;
 	}

-	drop_on_err = 1;
+	drop_on_err = true;
 	/* these must be set before we unlock the inode */
 	inode->i_op = &btrfs_dir_inode_operations;
 	inode->i_fop = &btrfs_dir_file_operations;
@@ -6721,7 +6718,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	 * to avoid a race with nfsd calling d_instantiate.
 	 */
 	unlock_new_inode(inode);
-	drop_on_err = 0;
+	drop_on_err = false;

 out_fail:
 	btrfs_end_transaction(trans);
@@ -9048,7 +9045,7 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 	unsigned long zero_start;
 	loff_t size;
 	int ret;
-	int reserved = 0;
+	bool reserved = false;
 	u64 reserved_space;
 	u64 page_start;
 	u64 page_end;
@@ -9073,7 +9070,7 @@ int btrfs_page_mkwrite(struct vm_fault *vmf)
 					   reserved_space);
 	if (!ret) {
 		ret = file_update_time(vmf->vma->vm_file);
-		reserved = 1;
+		reserved = true;
 	}
 	if (ret) {
 		if (ret == -ENOMEM)
@@ -10292,7 +10289,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	struct btrfs_key key;
 	struct inode *inode = NULL;
 	int err;
-	int drop_inode = 0;
+	bool drop_inode = false;
 	u64 objectid;
 	u64 index = 0;
 	int name_len;
@@ -10389,7 +10386,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 		err = btrfs_add_nondir(trans, BTRFS_I(dir), dentry,
 				BTRFS_I(inode), 0, index);
 	if (err) {
-		drop_inode = 1;
+		drop_inode = true;
 		goto out_unlock_inode;
 	}

@@ -10406,7 +10403,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	return err;

 out_unlock_inode:
-	drop_inode = 1;
+	drop_inode = true;
 	unlock_new_inode(inode);
 	goto out_unlock;
 }
--
2.13.1
