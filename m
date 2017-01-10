Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:33011 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938758AbdAJSgB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 13:36:01 -0500
Received: by mail-wj0-f196.google.com with SMTP id kp2so88396057wjc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Jan 2017 10:36:00 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>
Subject: [PATCH 01/12] btrfs: Make btrfs_ino take a struct btrfs_inode
Date: Tue, 10 Jan 2017 20:35:31 +0200
Message-Id: <1484073342-28854-2-git-send-email-n.borisov.lkml@gmail.com>
In-Reply-To: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
References: <1484073342-28854-1-git-send-email-n.borisov.lkml@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently btrfs_ino takes a struct inode and this causes a lot of
internal btrfs functions which consume this ino to take a VFS inode,
rather than btrfs' own struct btrfs_inode. In order to fix this "leak"
of VFS structs into the internals of btrfs first it's necessary to
eliminate all uses of struct inode for the purpose of inode. This patch
does that by using BTRFS_I to convert an inode to btrfs_inode. With
this problem eliminated subsequent patches will start eliminating the
passing of struct inode altogether, eventually resulting in a lot cleaner
code.

Signed-off-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
---
 fs/btrfs/btrfs_inode.h      |  10 ++--
 fs/btrfs/compression.c      |   2 +-
 fs/btrfs/delayed-inode.c    |  14 +++---
 fs/btrfs/dir-item.c         |   2 +-
 fs/btrfs/export.c           |  10 ++--
 fs/btrfs/extent-tree.c      |  10 ++--
 fs/btrfs/extent_io.c        |  10 ++--
 fs/btrfs/file-item.c        |   4 +-
 fs/btrfs/file.c             |  12 ++---
 fs/btrfs/free-space-cache.c |   2 +-
 fs/btrfs/inode.c            | 120 ++++++++++++++++++++++----------------------
 fs/btrfs/ioctl.c            |  26 +++++-----
 fs/btrfs/props.c            |   4 +-
 fs/btrfs/relocation.c       |  16 +++---
 fs/btrfs/transaction.c      |   4 +-
 fs/btrfs/tree-log.c         |  42 ++++++++--------
 fs/btrfs/xattr.c            |  10 ++--
 17 files changed, 149 insertions(+), 149 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 1a8fa46ff87e..4fed080545c6 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -224,16 +224,16 @@ static inline void btrfs_insert_inode_hash(struct inode *inode)
 	__insert_inode_hash(inode, h);
 }
 
-static inline u64 btrfs_ino(struct inode *inode)
+static inline u64 btrfs_ino(struct btrfs_inode *inode)
 {
-	u64 ino = BTRFS_I(inode)->location.objectid;
+	u64 ino = inode->location.objectid;
 
 	/*
 	 * !ino: btree_inode
 	 * type == BTRFS_ROOT_ITEM_KEY: subvol dir
 	 */
-	if (!ino || BTRFS_I(inode)->location.type == BTRFS_ROOT_ITEM_KEY)
-		ino = inode->i_ino;
+	if (!ino || inode->location.type == BTRFS_ROOT_ITEM_KEY)
+		ino = inode->vfs_inode.i_ino;
 	return ino;
 }
 
@@ -248,7 +248,7 @@ static inline bool btrfs_is_free_space_inode(struct inode *inode)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 
 	if (root == root->fs_info->tree_root &&
-	    btrfs_ino(inode) != BTRFS_BTREE_INODE_OBJECTID)
+	    btrfs_ino(BTRFS_I(inode)) != BTRFS_BTREE_INODE_OBJECTID)
 		return true;
 	if (BTRFS_I(inode)->location.objectid == BTRFS_FREE_INO_OBJECTID)
 		return true;
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 7f390849343b..8c2ca2d0585b 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -126,7 +126,7 @@ static int check_compressed_csum(struct inode *inode,
 		if (csum != *cb_sum) {
 			btrfs_info(BTRFS_I(inode)->root->fs_info,
 			   "csum failed ino %llu extent %llu csum %u wanted %u mirror %d",
-			   btrfs_ino(inode), disk_start, csum, *cb_sum,
+			   btrfs_ino(BTRFS_I(inode)), disk_start, csum, *cb_sum,
 			   cb->mirror_num);
 			ret = -EIO;
 			goto fail;
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 80982a83c9fd..15f9b8e9dbf6 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -76,7 +76,7 @@ static struct btrfs_delayed_node *btrfs_get_delayed_node(struct inode *inode)
 {
 	struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
 	struct btrfs_root *root = btrfs_inode->root;
-	u64 ino = btrfs_ino(inode);
+	u64 ino = btrfs_ino(btrfs_inode);
 	struct btrfs_delayed_node *node;
 
 	node = ACCESS_ONCE(btrfs_inode->delayed_node);
@@ -112,7 +112,7 @@ static struct btrfs_delayed_node *btrfs_get_or_create_delayed_node(
 	struct btrfs_delayed_node *node;
 	struct btrfs_inode *btrfs_inode = BTRFS_I(inode);
 	struct btrfs_root *root = btrfs_inode->root;
-	u64 ino = btrfs_ino(inode);
+	u64 ino = btrfs_ino(btrfs_inode);
 	int ret;
 
 again:
@@ -637,7 +637,7 @@ static int btrfs_delayed_inode_reserve_metadata(
 			node->bytes_reserved = num_bytes;
 			trace_btrfs_space_reservation(fs_info,
 						      "delayed_inode",
-						      btrfs_ino(inode),
+						      btrfs_ino(BTRFS_I(inode)),
 						      num_bytes, 1);
 		}
 		return ret;
@@ -660,13 +660,13 @@ static int btrfs_delayed_inode_reserve_metadata(
 	 */
 	if (!ret) {
 		trace_btrfs_space_reservation(fs_info, "delayed_inode",
-					      btrfs_ino(inode), num_bytes, 1);
+					      btrfs_ino(BTRFS_I(inode)), num_bytes, 1);
 		node->bytes_reserved = num_bytes;
 	}
 
 	if (release) {
 		trace_btrfs_space_reservation(fs_info, "delalloc",
-					      btrfs_ino(inode), num_bytes, 0);
+					      btrfs_ino(BTRFS_I(inode)), num_bytes, 0);
 		btrfs_block_rsv_release(fs_info, src_rsv, num_bytes);
 	}
 
@@ -1453,7 +1453,7 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 		goto release_node;
 	}
 
-	delayed_item->key.objectid = btrfs_ino(dir);
+	delayed_item->key.objectid = btrfs_ino(BTRFS_I(dir));
 	delayed_item->key.type = BTRFS_DIR_INDEX_KEY;
 	delayed_item->key.offset = index;
 
@@ -1521,7 +1521,7 @@ int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 	if (IS_ERR(node))
 		return PTR_ERR(node);
 
-	item_key.objectid = btrfs_ino(dir);
+	item_key.objectid = btrfs_ino(BTRFS_I(dir));
 	item_key.type = BTRFS_DIR_INDEX_KEY;
 	item_key.offset = index;
 
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index b039fe0c751a..74de492bd490 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -133,7 +133,7 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	struct btrfs_disk_key disk_key;
 	u32 data_size;
 
-	key.objectid = btrfs_ino(dir);
+	key.objectid = btrfs_ino(BTRFS_I(dir));
 	key.type = BTRFS_DIR_ITEM_KEY;
 	key.offset = btrfs_name_hash(name, name_len);
 
diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 340d90751263..f6d1aebc8e64 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -30,7 +30,7 @@ static int btrfs_encode_fh(struct inode *inode, u32 *fh, int *max_len,
 	len  = BTRFS_FID_SIZE_NON_CONNECTABLE;
 	type = FILEID_BTRFS_WITHOUT_PARENT;
 
-	fid->objectid = btrfs_ino(inode);
+	fid->objectid = btrfs_ino(BTRFS_I(inode));
 	fid->root_objectid = BTRFS_I(inode)->root->objectid;
 	fid->gen = inode->i_generation;
 
@@ -166,13 +166,13 @@ static struct dentry *btrfs_get_parent(struct dentry *child)
 	if (!path)
 		return ERR_PTR(-ENOMEM);
 
-	if (btrfs_ino(dir) == BTRFS_FIRST_FREE_OBJECTID) {
+	if (btrfs_ino(BTRFS_I(dir)) == BTRFS_FIRST_FREE_OBJECTID) {
 		key.objectid = root->root_key.objectid;
 		key.type = BTRFS_ROOT_BACKREF_KEY;
 		key.offset = (u64)-1;
 		root = fs_info->tree_root;
 	} else {
-		key.objectid = btrfs_ino(dir);
+		key.objectid = btrfs_ino(BTRFS_I(dir));
 		key.type = BTRFS_INODE_REF_KEY;
 		key.offset = (u64)-1;
 	}
@@ -241,7 +241,7 @@ static int btrfs_get_name(struct dentry *parent, char *name,
 	if (!S_ISDIR(dir->i_mode))
 		return -EINVAL;
 
-	ino = btrfs_ino(inode);
+	ino = btrfs_ino(BTRFS_I(inode));
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -255,7 +255,7 @@ static int btrfs_get_name(struct dentry *parent, char *name,
 		root = fs_info->tree_root;
 	} else {
 		key.objectid = ino;
-		key.offset = btrfs_ino(dir);
+		key.offset = btrfs_ino(BTRFS_I(dir));
 		key.type = BTRFS_INODE_REF_KEY;
 	}
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e97302f437a1..f1232260cc8f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5753,7 +5753,7 @@ int btrfs_orphan_reserve_metadata(struct btrfs_trans_handle *trans,
 	u64 num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
 
 	trace_btrfs_space_reservation(fs_info, "orphan",
-				      btrfs_ino(inode), num_bytes, 1);
+				      btrfs_ino(BTRFS_I(inode)), num_bytes, 1);
 	return btrfs_block_rsv_migrate(src_rsv, dst_rsv, num_bytes, 1);
 }
 
@@ -5764,7 +5764,7 @@ void btrfs_orphan_release_metadata(struct inode *inode)
 	u64 num_bytes = btrfs_calc_trans_metadata_size(fs_info, 1);
 
 	trace_btrfs_space_reservation(fs_info, "orphan",
-				      btrfs_ino(inode), num_bytes, 0);
+				      btrfs_ino(BTRFS_I(inode)), num_bytes, 0);
 	btrfs_block_rsv_release(fs_info, root->orphan_block_rsv, num_bytes);
 }
 
@@ -6002,7 +6002,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 
 	if (to_reserve)
 		trace_btrfs_space_reservation(fs_info, "delalloc",
-					      btrfs_ino(inode), to_reserve, 1);
+					      btrfs_ino(BTRFS_I(inode)), to_reserve, 1);
 	if (release_extra)
 		btrfs_block_rsv_release(fs_info, block_rsv,
 				btrfs_calc_trans_metadata_size(fs_info, 1));
@@ -6065,7 +6065,7 @@ int btrfs_delalloc_reserve_metadata(struct inode *inode, u64 num_bytes)
 	if (to_free) {
 		btrfs_block_rsv_release(fs_info, block_rsv, to_free);
 		trace_btrfs_space_reservation(fs_info, "delalloc",
-					      btrfs_ino(inode), to_free, 0);
+					      btrfs_ino(BTRFS_I(inode)), to_free, 0);
 	}
 	if (delalloc_lock)
 		mutex_unlock(&BTRFS_I(inode)->delalloc_mutex);
@@ -6101,7 +6101,7 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 		return;
 
 	trace_btrfs_space_reservation(fs_info, "delalloc",
-				      btrfs_ino(inode), to_free, 0);
+				      btrfs_ino(BTRFS_I(inode)), to_free, 0);
 
 	btrfs_block_rsv_release(fs_info, &fs_info->delalloc_block_rsv, to_free);
 }
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4ac383a3a649..f5c3ed6423f2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -98,7 +98,7 @@ static inline void __btrfs_debug_check_extent_io_range(const char *caller,
 	if (end >= PAGE_SIZE && (end % 2) == 0 && end != isize - 1) {
 		btrfs_debug_rl(BTRFS_I(inode)->root->fs_info,
 		    "%s: ino %llu isize %llu odd range [%llu,%llu]",
-				caller, btrfs_ino(inode), isize, start, end);
+				caller, btrfs_ino(BTRFS_I(inode)), isize, start, end);
 	}
 }
 #else
@@ -2060,7 +2060,7 @@ int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
 
 	btrfs_info_rl_in_rcu(fs_info,
 		"read error corrected: ino %llu off %llu (dev %s sector %llu)",
-				  btrfs_ino(inode), start,
+				  btrfs_ino(BTRFS_I(inode)), start,
 				  rcu_str_deref(dev->name), sector);
 	btrfs_bio_counter_dec(fs_info);
 	bio_put(bio);
@@ -4410,7 +4410,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	 * lookup the last file extent.  We're not using i_size here
 	 * because there might be preallocation past i_size
 	 */
-	ret = btrfs_lookup_file_extent(NULL, root, path, btrfs_ino(inode), -1,
+	ret = btrfs_lookup_file_extent(NULL, root, path, btrfs_ino(BTRFS_I(inode)), -1,
 				       0);
 	if (ret < 0) {
 		btrfs_free_path(path);
@@ -4426,7 +4426,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	found_type = found_key.type;
 
 	/* No extents, but there might be delalloc bits */
-	if (found_key.objectid != btrfs_ino(inode) ||
+	if (found_key.objectid != btrfs_ino(BTRFS_I(inode)) ||
 	    found_type != BTRFS_EXTENT_DATA_KEY) {
 		/* have to trust i_size as the end */
 		last = (u64)-1;
@@ -4536,7 +4536,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			 */
 			ret = btrfs_check_shared(trans, root->fs_info,
 						 root->objectid,
-						 btrfs_ino(inode), bytenr);
+						 btrfs_ino(BTRFS_I(inode)), bytenr);
 			if (trans)
 				btrfs_end_transaction(trans);
 			if (ret < 0)
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index e97e322c28f0..d7cf5d1c0cc4 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -255,7 +255,7 @@ static int __btrfs_lookup_bio_sums(struct inode *inode, struct bio *bio,
 				} else {
 					btrfs_info_rl(fs_info,
 						   "no csum found for inode %llu start %llu",
-					       btrfs_ino(inode), offset);
+					       btrfs_ino(BTRFS_I(inode)), offset);
 				}
 				item = NULL;
 				btrfs_release_path(path);
@@ -977,7 +977,7 @@ void btrfs_extent_item_to_extent_map(struct inode *inode,
 	} else {
 		btrfs_err(fs_info,
 			  "unknown file extent item type %d, inode %llu, offset %llu, root %llu",
-			  type, btrfs_ino(inode), extent_start,
+			  type, btrfs_ino(BTRFS_I(inode)), extent_start,
 			  root->root_key.objectid);
 	}
 }
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b5c5da215d05..0d32f45cef28 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -168,7 +168,7 @@ int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
 	if (!defrag)
 		return -ENOMEM;
 
-	defrag->ino = btrfs_ino(inode);
+	defrag->ino = btrfs_ino(BTRFS_I(inode));
 	defrag->transid = transid;
 	defrag->root = root->root_key.objectid;
 
@@ -702,7 +702,7 @@ int __btrfs_drop_extents(struct btrfs_trans_handle *trans,
 	struct btrfs_file_extent_item *fi;
 	struct btrfs_key key;
 	struct btrfs_key new_key;
-	u64 ino = btrfs_ino(inode);
+	u64 ino = btrfs_ino(BTRFS_I(inode));
 	u64 search_start = start;
 	u64 disk_bytenr = 0;
 	u64 num_bytes = 0;
@@ -1102,7 +1102,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 	int del_slot = 0;
 	int recow;
 	int ret;
-	u64 ino = btrfs_ino(inode);
+	u64 ino = btrfs_ino(BTRFS_I(inode));
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -2203,7 +2203,7 @@ static int hole_mergeable(struct inode *inode, struct extent_buffer *leaf,
 		return 0;
 
 	btrfs_item_key_to_cpu(leaf, &key, slot);
-	if (key.objectid != btrfs_ino(inode) ||
+	if (key.objectid != btrfs_ino(BTRFS_I(inode)) ||
 	    key.type != BTRFS_EXTENT_DATA_KEY)
 		return 0;
 
@@ -2237,7 +2237,7 @@ static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
 	if (btrfs_fs_incompat(fs_info, NO_HOLES))
 		goto out;
 
-	key.objectid = btrfs_ino(inode);
+	key.objectid = btrfs_ino(BTRFS_I(inode));
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = offset;
 
@@ -2285,7 +2285,7 @@ static int fill_holes(struct btrfs_trans_handle *trans, struct inode *inode,
 	}
 	btrfs_release_path(path);
 
-	ret = btrfs_insert_file_extent(trans, root, btrfs_ino(inode), offset,
+	ret = btrfs_insert_file_extent(trans, root, btrfs_ino(BTRFS_I(inode)), offset,
 				       0, 0, end - offset, 0, end - offset,
 				       0, 0, 0);
 	if (ret)
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 7015892c9ee8..437580e84d9d 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -313,7 +313,7 @@ static int io_ctl_init(struct btrfs_io_ctl *io_ctl, struct inode *inode,
 
 	num_pages = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
 
-	if (btrfs_ino(inode) != BTRFS_FREE_INO_OBJECTID)
+	if (btrfs_ino(BTRFS_I(inode)) != BTRFS_FREE_INO_OBJECTID)
 		check_crcs = 1;
 
 	/* Make sure we can fit our crcs into the first page */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f2b281ad7af6..6818a09a0317 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -166,7 +166,7 @@ static int insert_inline_extent(struct btrfs_trans_handle *trans,
 		struct btrfs_key key;
 		size_t datasize;
 
-		key.objectid = btrfs_ino(inode);
+		key.objectid = btrfs_ino(BTRFS_I(inode));
 		key.offset = start;
 		key.type = BTRFS_EXTENT_DATA_KEY;
 
@@ -1269,7 +1269,7 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 	int nocow;
 	int check_prev = 1;
 	bool nolock;
-	u64 ino = btrfs_ino(inode);
+	u64 ino = btrfs_ino(BTRFS_I(inode));
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -2161,7 +2161,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 		goto out;
 
 	if (!extent_inserted) {
-		ins.objectid = btrfs_ino(inode);
+		ins.objectid = btrfs_ino(BTRFS_I(inode));
 		ins.offset = file_pos;
 		ins.type = BTRFS_EXTENT_DATA_KEY;
 
@@ -2194,7 +2194,7 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	ins.offset = disk_num_bytes;
 	ins.type = BTRFS_EXTENT_ITEM_KEY;
 	ret = btrfs_alloc_reserved_file_extent(trans, root->root_key.objectid,
-					       btrfs_ino(inode), file_pos,
+					       btrfs_ino(BTRFS_I(inode)), file_pos,
 					       ram_bytes, &ins);
 	/*
 	 * Release the reserved range from inode dirty range map, as it is
@@ -2320,7 +2320,7 @@ static noinline int record_one_backref(u64 inum, u64 offset, u64 root_id,
 	u64 num_bytes;
 
 	if (BTRFS_I(inode)->root->root_key.objectid == root_id &&
-	    inum == btrfs_ino(inode))
+	    inum == btrfs_ino(BTRFS_I(inode)))
 		return 0;
 
 	key.objectid = root_id;
@@ -2589,7 +2589,7 @@ static noinline int relink_extent_backref(struct btrfs_path *path,
 	if (ret)
 		goto out_free_path;
 again:
-	key.objectid = btrfs_ino(inode);
+	key.objectid = btrfs_ino(BTRFS_I(inode));
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = start;
 
@@ -2768,7 +2768,7 @@ record_old_file_extents(struct inode *inode,
 	if (!path)
 		goto out_kfree;
 
-	key.objectid = btrfs_ino(inode);
+	key.objectid = btrfs_ino(BTRFS_I(inode));
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = new->file_pos;
 
@@ -2803,7 +2803,7 @@ record_old_file_extents(struct inode *inode,
 
 		btrfs_item_key_to_cpu(l, &key, slot);
 
-		if (key.objectid != btrfs_ino(inode))
+		if (key.objectid != btrfs_ino(BTRFS_I(inode)))
 			break;
 		if (key.type != BTRFS_EXTENT_DATA_KEY)
 			break;
@@ -3125,7 +3125,7 @@ static int __readpage_endio_check(struct inode *inode,
 zeroit:
 	btrfs_warn_rl(BTRFS_I(inode)->root->fs_info,
 		"csum failed ino %llu off %llu csum %u expected csum %u",
-			   btrfs_ino(inode), start, csum, csum_expected);
+			   btrfs_ino(BTRFS_I(inode)), start, csum, csum_expected);
 	memset(kaddr + pgoff, 1, len);
 	flush_dcache_page(page);
 	kunmap_atomic(kaddr);
@@ -3326,7 +3326,7 @@ int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
 
 	/* insert an orphan item to track this unlinked/truncated file */
 	if (insert >= 1) {
-		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(inode));
+		ret = btrfs_insert_orphan_item(trans, root, btrfs_ino(BTRFS_I(inode)));
 		if (ret) {
 			atomic_dec(&root->orphan_inodes);
 			if (reserve) {
@@ -3382,7 +3382,7 @@ static int btrfs_orphan_del(struct btrfs_trans_handle *trans,
 		atomic_dec(&root->orphan_inodes);
 		if (trans)
 			ret = btrfs_del_orphan_item(trans, root,
-						    btrfs_ino(inode));
+						    btrfs_ino(BTRFS_I(inode)));
 	}
 
 	if (release_rsv)
@@ -3789,7 +3789,7 @@ static int btrfs_read_locked_inode(struct inode *inode)
 		goto cache_acl;
 
 	btrfs_item_key_to_cpu(leaf, &location, path->slots[0]);
-	if (location.objectid != btrfs_ino(inode))
+	if (location.objectid != btrfs_ino(BTRFS_I(inode)))
 		goto cache_acl;
 
 	ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);
@@ -3811,14 +3811,14 @@ static int btrfs_read_locked_inode(struct inode *inode)
 	 * any xattrs or acls
 	 */
 	maybe_acls = acls_after_inode_item(leaf, path->slots[0],
-					   btrfs_ino(inode), &first_xattr_slot);
+					   btrfs_ino(BTRFS_I(inode)), &first_xattr_slot);
 	if (first_xattr_slot != -1) {
 		path->slots[0] = first_xattr_slot;
 		ret = btrfs_load_inode_props(inode, path);
 		if (ret)
 			btrfs_err(fs_info,
 				  "error loading props for ino %llu (root %llu): %d",
-				  btrfs_ino(inode),
+				  btrfs_ino(BTRFS_I(inode)),
 				  root->root_key.objectid, ret);
 	}
 	btrfs_free_path(path);
@@ -4006,8 +4006,8 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	struct btrfs_dir_item *di;
 	struct btrfs_key key;
 	u64 index;
-	u64 ino = btrfs_ino(inode);
-	u64 dir_ino = btrfs_ino(dir);
+	u64 ino = btrfs_ino(BTRFS_I(inode));
+	u64 dir_ino = btrfs_ino(BTRFS_I(dir));
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -4173,7 +4173,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	u64 index;
 	int ret;
-	u64 dir_ino = btrfs_ino(dir);
+	u64 dir_ino = btrfs_ino(BTRFS_I(dir));
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -4252,14 +4252,14 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	if (inode->i_size > BTRFS_EMPTY_DIR_SIZE)
 		return -ENOTEMPTY;
-	if (btrfs_ino(inode) == BTRFS_FIRST_FREE_OBJECTID)
+	if (btrfs_ino(BTRFS_I(inode)) == BTRFS_FIRST_FREE_OBJECTID)
 		return -EPERM;
 
 	trans = __unlink_start_trans(dir);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 
-	if (unlikely(btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
+	if (unlikely(btrfs_ino(BTRFS_I(inode)) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
 		err = btrfs_unlink_subvol(trans, root, dir,
 					  BTRFS_I(inode)->location.objectid,
 					  dentry->d_name.name,
@@ -4401,7 +4401,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	int extent_type = -1;
 	int ret;
 	int err = 0;
-	u64 ino = btrfs_ino(inode);
+	u64 ino = btrfs_ino(BTRFS_I(inode));
 	u64 bytes_deleted = 0;
 	bool be_nice = 0;
 	bool should_throttle = 0;
@@ -4862,7 +4862,7 @@ static int maybe_insert_hole(struct btrfs_root *root, struct inode *inode,
 		return ret;
 	}
 
-	ret = btrfs_insert_file_extent(trans, root, btrfs_ino(inode), offset,
+	ret = btrfs_insert_file_extent(trans, root, btrfs_ino(BTRFS_I(inode)), offset,
 				       0, 0, len, 0, len, 0, 0, 0);
 	if (ret)
 		btrfs_abort_transaction(trans, ret);
@@ -5394,7 +5394,7 @@ void btrfs_evict_inode(struct inode *inode)
 	trans->block_rsv = &fs_info->trans_block_rsv;
 	if (!(root == fs_info->tree_root ||
 	      root->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID))
-		btrfs_return_ino(root, btrfs_ino(inode));
+		btrfs_return_ino(root, btrfs_ino(BTRFS_I(inode)));
 
 	btrfs_end_transaction(trans);
 	btrfs_btree_balance_dirty(fs_info);
@@ -5421,7 +5421,7 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 	if (!path)
 		return -ENOMEM;
 
-	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(dir), name,
+	di = btrfs_lookup_dir_item(NULL, root, path, btrfs_ino(BTRFS_I(dir)), name,
 				    namelen, 0);
 	if (IS_ERR(di))
 		ret = PTR_ERR(di);
@@ -5477,7 +5477,7 @@ static int fixup_tree_root_location(struct btrfs_fs_info *fs_info,
 
 	leaf = path->nodes[0];
 	ref = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_root_ref);
-	if (btrfs_root_ref_dirid(leaf, ref) != btrfs_ino(dir) ||
+	if (btrfs_root_ref_dirid(leaf, ref) != btrfs_ino(BTRFS_I(dir)) ||
 	    btrfs_root_ref_name_len(leaf, ref) != dentry->d_name.len)
 		goto out;
 
@@ -5512,7 +5512,7 @@ static void inode_tree_add(struct inode *inode)
 	struct rb_node **p;
 	struct rb_node *parent;
 	struct rb_node *new = &BTRFS_I(inode)->rb_node;
-	u64 ino = btrfs_ino(inode);
+	u64 ino = btrfs_ino(BTRFS_I(inode));
 
 	if (inode_unhashed(inode))
 		return;
@@ -5523,9 +5523,9 @@ static void inode_tree_add(struct inode *inode)
 		parent = *p;
 		entry = rb_entry(parent, struct btrfs_inode, rb_node);
 
-		if (ino < btrfs_ino(&entry->vfs_inode))
+		if (ino < btrfs_ino(BTRFS_I(&entry->vfs_inode)))
 			p = &parent->rb_left;
-		else if (ino > btrfs_ino(&entry->vfs_inode))
+		else if (ino > btrfs_ino(BTRFS_I(&entry->vfs_inode)))
 			p = &parent->rb_right;
 		else {
 			WARN_ON(!(entry->vfs_inode.i_state &
@@ -5585,9 +5585,9 @@ void btrfs_invalidate_inodes(struct btrfs_root *root)
 		prev = node;
 		entry = rb_entry(node, struct btrfs_inode, rb_node);
 
-		if (objectid < btrfs_ino(&entry->vfs_inode))
+		if (objectid < btrfs_ino(BTRFS_I(&entry->vfs_inode)))
 			node = node->rb_left;
-		else if (objectid > btrfs_ino(&entry->vfs_inode))
+		else if (objectid > btrfs_ino(BTRFS_I(&entry->vfs_inode)))
 			node = node->rb_right;
 		else
 			break;
@@ -5595,7 +5595,7 @@ void btrfs_invalidate_inodes(struct btrfs_root *root)
 	if (!node) {
 		while (prev) {
 			entry = rb_entry(prev, struct btrfs_inode, rb_node);
-			if (objectid <= btrfs_ino(&entry->vfs_inode)) {
+			if (objectid <= btrfs_ino(BTRFS_I(&entry->vfs_inode))) {
 				node = prev;
 				break;
 			}
@@ -5604,7 +5604,7 @@ void btrfs_invalidate_inodes(struct btrfs_root *root)
 	}
 	while (node) {
 		entry = rb_entry(node, struct btrfs_inode, rb_node);
-		objectid = btrfs_ino(&entry->vfs_inode) + 1;
+		objectid = btrfs_ino(BTRFS_I(&entry->vfs_inode)) + 1;
 		inode = igrab(&entry->vfs_inode);
 		if (inode) {
 			spin_unlock(&root->inode_lock);
@@ -5787,7 +5787,7 @@ static int btrfs_dentry_delete(const struct dentry *dentry)
 		if (btrfs_root_refs(&root->root_item) == 0)
 			return 1;
 
-		if (btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
+		if (btrfs_ino(BTRFS_I(inode)) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
 			return 1;
 	}
 	return 0;
@@ -5856,7 +5856,7 @@ static int btrfs_real_readdir(struct file *file, struct dir_context *ctx)
 
 	key.type = BTRFS_DIR_INDEX_KEY;
 	key.offset = ctx->pos;
-	key.objectid = btrfs_ino(inode);
+	key.objectid = btrfs_ino(BTRFS_I(inode));
 
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
@@ -6053,7 +6053,7 @@ static int btrfs_set_inode_index_count(struct inode *inode)
 	struct extent_buffer *leaf;
 	int ret;
 
-	key.objectid = btrfs_ino(inode);
+	key.objectid = btrfs_ino(BTRFS_I(inode));
 	key.type = BTRFS_DIR_INDEX_KEY;
 	key.offset = (u64)-1;
 
@@ -6085,7 +6085,7 @@ static int btrfs_set_inode_index_count(struct inode *inode)
 	leaf = path->nodes[0];
 	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 
-	if (found_key.objectid != btrfs_ino(inode) ||
+	if (found_key.objectid != btrfs_ino(BTRFS_I(inode)) ||
 	    found_key.type != BTRFS_DIR_INDEX_KEY) {
 		BTRFS_I(inode)->index_cnt = 2;
 		goto out;
@@ -6285,7 +6285,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	if (ret)
 		btrfs_err(fs_info,
 			  "error inheriting props for ino %llu (root %llu): %d",
-			  btrfs_ino(inode), root->root_key.objectid, ret);
+			  btrfs_ino(BTRFS_I(inode)), root->root_key.objectid, ret);
 
 	return inode;
 
@@ -6318,8 +6318,8 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	int ret = 0;
 	struct btrfs_key key;
 	struct btrfs_root *root = BTRFS_I(parent_inode)->root;
-	u64 ino = btrfs_ino(inode);
-	u64 parent_ino = btrfs_ino(parent_inode);
+	u64 ino = btrfs_ino(BTRFS_I(inode));
+	u64 parent_ino = btrfs_ino(BTRFS_I(parent_inode));
 
 	if (unlikely(ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		memcpy(&key, &BTRFS_I(inode)->root->root_key, sizeof(key));
@@ -6418,7 +6418,7 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 		goto out_unlock;
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
-				dentry->d_name.len, btrfs_ino(dir), objectid,
+				dentry->d_name.len, btrfs_ino(BTRFS_I(dir)), objectid,
 				mode, &index);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
@@ -6490,7 +6490,7 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 		goto out_unlock;
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
-				dentry->d_name.len, btrfs_ino(dir), objectid,
+				dentry->d_name.len, btrfs_ino(BTRFS_I(dir)), objectid,
 				mode, &index);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
@@ -6640,7 +6640,7 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 		goto out_fail;
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
-				dentry->d_name.len, btrfs_ino(dir), objectid,
+				dentry->d_name.len, btrfs_ino(BTRFS_I(dir)), objectid,
 				S_IFDIR | mode, &index);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
@@ -6801,7 +6801,7 @@ struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
 	int err = 0;
 	u64 extent_start = 0;
 	u64 extent_end = 0;
-	u64 objectid = btrfs_ino(inode);
+	u64 objectid = btrfs_ino(BTRFS_I(inode));
 	u32 found_type;
 	struct btrfs_path *path = NULL;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -7295,7 +7295,7 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 	if (!path)
 		return -ENOMEM;
 
-	ret = btrfs_lookup_file_extent(NULL, root, path, btrfs_ino(inode),
+	ret = btrfs_lookup_file_extent(NULL, root, path, btrfs_ino(BTRFS_I(inode)),
 				       offset, 0);
 	if (ret < 0)
 		goto out;
@@ -7312,7 +7312,7 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 	ret = 0;
 	leaf = path->nodes[0];
 	btrfs_item_key_to_cpu(leaf, &key, slot);
-	if (key.objectid != btrfs_ino(inode) ||
+	if (key.objectid != btrfs_ino(BTRFS_I(inode)) ||
 	    key.type != BTRFS_EXTENT_DATA_KEY) {
 		/* not our file or wrong item type, must cow */
 		goto out;
@@ -7384,7 +7384,7 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
 		goto out;
 	}
 
-	ret = btrfs_cross_ref_exist(trans, root, btrfs_ino(inode),
+	ret = btrfs_cross_ref_exist(trans, root, btrfs_ino(BTRFS_I(inode)),
 				    key.offset - backref_offset, disk_bytenr);
 	btrfs_end_transaction(trans);
 	if (ret) {
@@ -8240,7 +8240,7 @@ static void btrfs_end_dio_bio(struct bio *bio)
 	if (err)
 		btrfs_warn(BTRFS_I(dip->inode)->root->fs_info,
 			   "direct IO failed ino %llu rw %d,%u sector %#Lx len %u err no %d",
-			   btrfs_ino(dip->inode), bio_op(bio), bio->bi_opf,
+			   btrfs_ino(BTRFS_I(dip->inode)), bio_op(bio), bio->bi_opf,
 			   (unsigned long long)bio->bi_iter.bi_sector,
 			   bio->bi_iter.bi_size, err);
 
@@ -9367,7 +9367,7 @@ void btrfs_destroy_inode(struct inode *inode)
 	if (test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
 		     &BTRFS_I(inode)->runtime_flags)) {
 		btrfs_info(fs_info, "inode %llu still on the orphan list",
-			   btrfs_ino(inode));
+			   btrfs_ino(BTRFS_I(inode)));
 		atomic_dec(&root->orphan_inodes);
 	}
 
@@ -9496,8 +9496,8 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	struct inode *old_inode = old_dentry->d_inode;
 	struct timespec ctime = current_time(old_inode);
 	struct dentry *parent;
-	u64 old_ino = btrfs_ino(old_inode);
-	u64 new_ino = btrfs_ino(new_inode);
+	u64 old_ino = btrfs_ino(BTRFS_I(old_inode));
+	u64 new_ino = btrfs_ino(BTRFS_I(new_inode));
 	u64 old_idx = 0;
 	u64 new_idx = 0;
 	u64 root_objectid;
@@ -9554,7 +9554,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 					     new_dentry->d_name.name,
 					     new_dentry->d_name.len,
 					     old_ino,
-					     btrfs_ino(new_dir), old_idx);
+					     btrfs_ino(BTRFS_I(new_dir)), old_idx);
 		if (ret)
 			goto out_fail;
 	}
@@ -9570,7 +9570,7 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 					     old_dentry->d_name.name,
 					     old_dentry->d_name.len,
 					     new_ino,
-					     btrfs_ino(old_dir), new_idx);
+					     btrfs_ino(BTRFS_I(old_dir)), new_idx);
 		if (ret)
 			goto out_fail;
 	}
@@ -9719,7 +9719,7 @@ static int btrfs_whiteout_for_rename(struct btrfs_trans_handle *trans,
 	inode = btrfs_new_inode(trans, root, dir,
 				dentry->d_name.name,
 				dentry->d_name.len,
-				btrfs_ino(dir),
+				btrfs_ino(BTRFS_I(dir)),
 				objectid,
 				S_IFCHR | WHITEOUT_MODE,
 				&index);
@@ -9767,10 +9767,10 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	u64 index = 0;
 	u64 root_objectid;
 	int ret;
-	u64 old_ino = btrfs_ino(old_inode);
+	u64 old_ino = btrfs_ino(BTRFS_I(old_inode));
 	bool log_pinned = false;
 
-	if (btrfs_ino(new_dir) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
+	if (btrfs_ino(BTRFS_I(new_dir)) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)
 		return -EPERM;
 
 	/* we only allow rename subvolume link between subvolumes */
@@ -9778,7 +9778,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		return -EXDEV;
 
 	if (old_ino == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID ||
-	    (new_inode && btrfs_ino(new_inode) == BTRFS_FIRST_FREE_OBJECTID))
+	    (new_inode && btrfs_ino(BTRFS_I(new_inode)) == BTRFS_FIRST_FREE_OBJECTID))
 		return -ENOTEMPTY;
 
 	if (S_ISDIR(old_inode->i_mode) && new_inode &&
@@ -9853,7 +9853,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 					     new_dentry->d_name.name,
 					     new_dentry->d_name.len,
 					     old_ino,
-					     btrfs_ino(new_dir), index);
+					     btrfs_ino(BTRFS_I(new_dir)), index);
 		if (ret)
 			goto out_fail;
 	}
@@ -9889,7 +9889,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (new_inode) {
 		inode_inc_iversion(new_inode);
 		new_inode->i_ctime = current_time(new_inode);
-		if (unlikely(btrfs_ino(new_inode) ==
+		if (unlikely(btrfs_ino(BTRFS_I(new_inode)) ==
 			     BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
 			root_objectid = BTRFS_I(new_inode)->location.objectid;
 			ret = btrfs_unlink_subvol(trans, dest, new_dir,
@@ -10220,7 +10220,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 		goto out_unlock;
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
-				dentry->d_name.len, btrfs_ino(dir), objectid,
+				dentry->d_name.len, btrfs_ino(BTRFS_I(dir)), objectid,
 				S_IFLNK|S_IRWXUGO, &index);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
@@ -10247,7 +10247,7 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 		err = -ENOMEM;
 		goto out_unlock_inode;
 	}
-	key.objectid = btrfs_ino(inode);
+	key.objectid = btrfs_ino(BTRFS_I(inode));
 	key.offset = 0;
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	datasize = btrfs_file_extent_calc_inline_size(name_len);
@@ -10500,7 +10500,7 @@ static int btrfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 		goto out;
 
 	inode = btrfs_new_inode(trans, root, dir, NULL, 0,
-				btrfs_ino(dir), objectid, mode, &index);
+				btrfs_ino(BTRFS_I(dir)), objectid, mode, &index);
 	if (IS_ERR(inode)) {
 		ret = PTR_ERR(inode);
 		inode = NULL;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 33f967d30b2a..e8e1f5f5f93a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -601,7 +601,7 @@ static noinline int create_subvol(struct inode *dir,
 
 	ret = btrfs_add_root_ref(trans, fs_info,
 				 objectid, root->root_key.objectid,
-				 btrfs_ino(dir), index, name, namelen);
+				 btrfs_ino(BTRFS_I(dir)), index, name, namelen);
 	BUG_ON(ret);
 
 	ret = btrfs_uuid_tree_add(trans, fs_info, root_item->uuid,
@@ -941,7 +941,7 @@ static int find_new_extents(struct btrfs_root *root,
 	struct btrfs_file_extent_item *extent;
 	int type;
 	int ret;
-	u64 ino = btrfs_ino(inode);
+	u64 ino = btrfs_ino(BTRFS_I(inode));
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -1780,7 +1780,7 @@ static noinline int btrfs_ioctl_subvol_getflags(struct file *file,
 	int ret = 0;
 	u64 flags = 0;
 
-	if (btrfs_ino(inode) != BTRFS_FIRST_FREE_OBJECTID)
+	if (btrfs_ino(BTRFS_I(inode)) != BTRFS_FIRST_FREE_OBJECTID)
 		return -EINVAL;
 
 	down_read(&fs_info->subvol_sem);
@@ -1812,7 +1812,7 @@ static noinline int btrfs_ioctl_subvol_setflags(struct file *file,
 	if (ret)
 		goto out;
 
-	if (btrfs_ino(inode) != BTRFS_FIRST_FREE_OBJECTID) {
+	if (btrfs_ino(BTRFS_I(inode)) != BTRFS_FIRST_FREE_OBJECTID) {
 		ret = -EINVAL;
 		goto out_drop_write;
 	}
@@ -2446,7 +2446,7 @@ static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 	if (err)
 		goto out_dput;
 
-	if (btrfs_ino(inode) != BTRFS_FIRST_FREE_OBJECTID) {
+	if (btrfs_ino(BTRFS_I(inode)) != BTRFS_FIRST_FREE_OBJECTID) {
 		err = -EINVAL;
 		goto out_dput;
 	}
@@ -3420,7 +3420,7 @@ static int clone_copy_inline_extent(struct inode *src,
 	if (new_key->offset > 0)
 		return -EOPNOTSUPP;
 
-	key.objectid = btrfs_ino(dst);
+	key.objectid = btrfs_ino(BTRFS_I(dst));
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = 0;
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
@@ -3435,7 +3435,7 @@ static int clone_copy_inline_extent(struct inode *src,
 				goto copy_inline_extent;
 		}
 		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
-		if (key.objectid == btrfs_ino(dst) &&
+		if (key.objectid == btrfs_ino(BTRFS_I(dst)) &&
 		    key.type == BTRFS_EXTENT_DATA_KEY) {
 			ASSERT(key.offset > 0);
 			return -EOPNOTSUPP;
@@ -3469,7 +3469,7 @@ static int clone_copy_inline_extent(struct inode *src,
 		} else if (ret == 0) {
 			btrfs_item_key_to_cpu(path->nodes[0], &key,
 					      path->slots[0]);
-			if (key.objectid == btrfs_ino(dst) &&
+			if (key.objectid == btrfs_ino(BTRFS_I(dst)) &&
 			    key.type == BTRFS_EXTENT_DATA_KEY)
 				return -EOPNOTSUPP;
 		}
@@ -3563,7 +3563,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 
 	path->reada = READA_FORWARD;
 	/* clone data */
-	key.objectid = btrfs_ino(src);
+	key.objectid = btrfs_ino(BTRFS_I(src));
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = off;
 
@@ -3606,7 +3606,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (key.type > BTRFS_EXTENT_DATA_KEY ||
-		    key.objectid != btrfs_ino(src))
+		    key.objectid != btrfs_ino(BTRFS_I(src)))
 			break;
 
 		if (key.type == BTRFS_EXTENT_DATA_KEY) {
@@ -3659,7 +3659,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 			path->leave_spinning = 0;
 
 			memcpy(&new_key, &key, sizeof(new_key));
-			new_key.objectid = btrfs_ino(inode);
+			new_key.objectid = btrfs_ino(BTRFS_I(inode));
 			if (off <= key.offset)
 				new_key.offset = key.offset + destoff - off;
 			else
@@ -3749,7 +3749,7 @@ static int btrfs_clone(struct inode *src, struct inode *inode,
 							fs_info,
 							disko, diskl, 0,
 							root->root_key.objectid,
-							btrfs_ino(inode),
+							btrfs_ino(BTRFS_I(inode)),
 							new_key.offset - datao);
 					if (ret) {
 						btrfs_abort_transaction(trans,
@@ -5129,7 +5129,7 @@ static long _btrfs_ioctl_set_received_subvol(struct file *file,
 
 	down_write(&fs_info->subvol_sem);
 
-	if (btrfs_ino(inode) != BTRFS_FIRST_FREE_OBJECTID) {
+	if (btrfs_ino(BTRFS_I(inode)) != BTRFS_FIRST_FREE_OBJECTID) {
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index f2621e330954..d6cb155ef7a1 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -279,7 +279,7 @@ static void inode_prop_iterator(void *ctx,
 	if (unlikely(ret))
 		btrfs_warn(root->fs_info,
 			   "error applying prop %s to ino %llu (root %llu): %d",
-			   handler->xattr_name, btrfs_ino(inode),
+			   handler->xattr_name, btrfs_ino(BTRFS_I(inode)),
 			   root->root_key.objectid, ret);
 	else
 		set_bit(BTRFS_INODE_HAS_PROPS, &BTRFS_I(inode)->runtime_flags);
@@ -288,7 +288,7 @@ static void inode_prop_iterator(void *ctx,
 int btrfs_load_inode_props(struct inode *inode, struct btrfs_path *path)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	u64 ino = btrfs_ino(inode);
+	u64 ino = btrfs_ino(BTRFS_I(inode));
 	int ret;
 
 	ret = iterate_object_props(root, path, ino, inode_prop_iterator, inode);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 379711048fb0..7a3fc99e93b7 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1548,9 +1548,9 @@ static struct inode *find_next_inode(struct btrfs_root *root, u64 objectid)
 		prev = node;
 		entry = rb_entry(node, struct btrfs_inode, rb_node);
 
-		if (objectid < btrfs_ino(&entry->vfs_inode))
+		if (objectid < btrfs_ino(entry))
 			node = node->rb_left;
-		else if (objectid > btrfs_ino(&entry->vfs_inode))
+		else if (objectid > btrfs_ino(entry))
 			node = node->rb_right;
 		else
 			break;
@@ -1558,7 +1558,7 @@ static struct inode *find_next_inode(struct btrfs_root *root, u64 objectid)
 	if (!node) {
 		while (prev) {
 			entry = rb_entry(prev, struct btrfs_inode, rb_node);
-			if (objectid <= btrfs_ino(&entry->vfs_inode)) {
+			if (objectid <= btrfs_ino(entry)) {
 				node = prev;
 				break;
 			}
@@ -1573,7 +1573,7 @@ static struct inode *find_next_inode(struct btrfs_root *root, u64 objectid)
 			return inode;
 		}
 
-		objectid = btrfs_ino(&entry->vfs_inode) + 1;
+		objectid = btrfs_ino(entry) + 1;
 		if (cond_resched_lock(&root->inode_lock))
 			goto again;
 
@@ -1609,7 +1609,7 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
 		return -ENOMEM;
 
 	bytenr -= BTRFS_I(reloc_inode)->index_cnt;
-	ret = btrfs_lookup_file_extent(NULL, root, path, btrfs_ino(reloc_inode),
+	ret = btrfs_lookup_file_extent(NULL, root, path, btrfs_ino(BTRFS_I(reloc_inode)),
 				       bytenr, 0);
 	if (ret < 0)
 		goto out;
@@ -1698,11 +1698,11 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 			if (first) {
 				inode = find_next_inode(root, key.objectid);
 				first = 0;
-			} else if (inode && btrfs_ino(inode) < key.objectid) {
+			} else if (inode && btrfs_ino(BTRFS_I(inode)) < key.objectid) {
 				btrfs_add_delayed_iput(inode);
 				inode = find_next_inode(root, key.objectid);
 			}
-			if (inode && btrfs_ino(inode) == key.objectid) {
+			if (inode && btrfs_ino(BTRFS_I(inode)) == key.objectid) {
 				end = key.offset +
 				      btrfs_file_extent_num_bytes(leaf, fi);
 				WARN_ON(!IS_ALIGNED(key.offset,
@@ -2088,7 +2088,7 @@ static int invalidate_extent_cache(struct btrfs_root *root,
 		inode = find_next_inode(root, objectid);
 		if (!inode)
 			break;
-		ino = btrfs_ino(inode);
+		ino = btrfs_ino(BTRFS_I(inode));
 
 		if (ino > max_key->objectid) {
 			iput(inode);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 0e0508f488b2..76f5b5af2678 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1504,7 +1504,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 
 	/* check if there is a file/dir which has the same name. */
 	dir_item = btrfs_lookup_dir_item(NULL, parent_root, path,
-					 btrfs_ino(parent_inode),
+					 btrfs_ino(BTRFS_I(parent_inode)),
 					 dentry->d_name.name,
 					 dentry->d_name.len, 0);
 	if (dir_item != NULL && !IS_ERR(dir_item)) {
@@ -1598,7 +1598,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	 */
 	ret = btrfs_add_root_ref(trans, fs_info, objectid,
 				 parent_root->root_key.objectid,
-				 btrfs_ino(parent_inode), index,
+				 btrfs_ino(BTRFS_I(parent_inode)), index,
 				 dentry->d_name.name, dentry->d_name.len);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f10bf5213ed8..0ad6da8b194b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -630,7 +630,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 	 * file.  This must be done before the btrfs_drop_extents run
 	 * so we don't try to drop this extent.
 	 */
-	ret = btrfs_lookup_file_extent(trans, root, path, btrfs_ino(inode),
+	ret = btrfs_lookup_file_extent(trans, root, path, btrfs_ino(BTRFS_I(inode)),
 				       start, 0);
 
 	if (ret == 0 &&
@@ -1147,7 +1147,7 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 
 	/* look for a conflicting sequence number */
-	di = btrfs_lookup_dir_index_item(trans, root, path, btrfs_ino(dir),
+	di = btrfs_lookup_dir_index_item(trans, root, path, btrfs_ino(BTRFS_I(dir)),
 					 ref_index, name, namelen, 0);
 	if (di && !IS_ERR(di)) {
 		ret = drop_one_dir_item(trans, root, path, dir, di);
@@ -1157,7 +1157,7 @@ static inline int __add_inode_ref(struct btrfs_trans_handle *trans,
 	btrfs_release_path(path);
 
 	/* look for a conflicing name */
-	di = btrfs_lookup_dir_item(trans, root, path, btrfs_ino(dir),
+	di = btrfs_lookup_dir_item(trans, root, path, btrfs_ino(BTRFS_I(dir)),
 				   name, namelen, 0);
 	if (di && !IS_ERR(di)) {
 		ret = drop_one_dir_item(trans, root, path, dir, di);
@@ -1294,7 +1294,7 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
 			goto out;
 
 		/* if we already have a perfect match, we're done */
-		if (!inode_in_dir(root, path, btrfs_ino(dir), btrfs_ino(inode),
+		if (!inode_in_dir(root, path, btrfs_ino(BTRFS_I(dir)), btrfs_ino(BTRFS_I(inode)),
 				  ref_index, name, namelen)) {
 			/*
 			 * look for a conflicting back reference in the
@@ -1366,7 +1366,7 @@ static int count_inode_extrefs(struct btrfs_root *root,
 	unsigned int nlink = 0;
 	u32 item_size;
 	u32 cur_offset = 0;
-	u64 inode_objectid = btrfs_ino(inode);
+	u64 inode_objectid = btrfs_ino(BTRFS_I(inode));
 	u64 offset = 0;
 	unsigned long ptr;
 	struct btrfs_inode_extref *extref;
@@ -1411,7 +1411,7 @@ static int count_inode_refs(struct btrfs_root *root,
 	unsigned long ptr;
 	unsigned long ptr_end;
 	int name_len;
-	u64 ino = btrfs_ino(inode);
+	u64 ino = btrfs_ino(BTRFS_I(inode));
 
 	key.objectid = ino;
 	key.type = BTRFS_INODE_REF_KEY;
@@ -1476,7 +1476,7 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 	int ret;
 	u64 nlink = 0;
-	u64 ino = btrfs_ino(inode);
+	u64 ino = btrfs_ino(BTRFS_I(inode));
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -3091,7 +3091,7 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 	int ret;
 	int err = 0;
 	int bytes_del = 0;
-	u64 dir_ino = btrfs_ino(dir);
+	u64 dir_ino = btrfs_ino(BTRFS_I(dir));
 
 	if (BTRFS_I(dir)->logged_trans < trans->transid)
 		return 0;
@@ -3207,7 +3207,7 @@ int btrfs_del_inode_ref_in_log(struct btrfs_trans_handle *trans,
 	log = root->log_root;
 	mutex_lock(&BTRFS_I(inode)->log_mutex);
 
-	ret = btrfs_del_inode_ref(trans, log, name, name_len, btrfs_ino(inode),
+	ret = btrfs_del_inode_ref(trans, log, name, name_len, btrfs_ino(BTRFS_I(inode)),
 				  dirid, &index);
 	mutex_unlock(&BTRFS_I(inode)->log_mutex);
 	if (ret == -ENOSPC) {
@@ -3274,7 +3274,7 @@ static noinline int log_dir_items(struct btrfs_trans_handle *trans,
 	int nritems;
 	u64 first_offset = min_offset;
 	u64 last_offset = (u64)-1;
-	u64 ino = btrfs_ino(inode);
+	u64 ino = btrfs_ino(BTRFS_I(inode));
 
 	log = root->log_root;
 
@@ -3791,7 +3791,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 			src_path->slots[0]--;
 		src = src_path->nodes[0];
 		btrfs_item_key_to_cpu(src, &key, src_path->slots[0]);
-		if (key.objectid != btrfs_ino(inode) ||
+		if (key.objectid != btrfs_ino(BTRFS_I(inode)) ||
 		    key.type != BTRFS_EXTENT_DATA_KEY)
 			goto fill_holes;
 		extent = btrfs_item_ptr(src, src_path->slots[0],
@@ -3856,7 +3856,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 		btrfs_item_key_to_cpu(src, &key, i);
 		if (!btrfs_comp_cpu_keys(&key, &last_key))
 			done = true;
-		if (key.objectid != btrfs_ino(inode) ||
+		if (key.objectid != btrfs_ino(BTRFS_I(inode)) ||
 		    key.type != BTRFS_EXTENT_DATA_KEY) {
 			i++;
 			continue;
@@ -3879,7 +3879,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 		}
 		offset = *last_extent;
 		len = key.offset - *last_extent;
-		ret = btrfs_insert_file_extent(trans, log, btrfs_ino(inode),
+		ret = btrfs_insert_file_extent(trans, log, btrfs_ino(BTRFS_I(inode)),
 					       offset, 0, 0, len, 0, len, 0,
 					       0, 0);
 		if (ret)
@@ -4090,7 +4090,7 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 		return ret;
 
 	if (!extent_inserted) {
-		key.objectid = btrfs_ino(inode);
+		key.objectid = btrfs_ino(BTRFS_I(inode));
 		key.type = BTRFS_EXTENT_DATA_KEY;
 		key.offset = em->start;
 
@@ -4246,7 +4246,7 @@ static int logged_inode_size(struct btrfs_root *log, struct inode *inode,
 	struct btrfs_key key;
 	int ret;
 
-	key.objectid = btrfs_ino(inode);
+	key.objectid = btrfs_ino(BTRFS_I(inode));
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
 
@@ -4284,7 +4284,7 @@ static int btrfs_log_all_xattrs(struct btrfs_trans_handle *trans,
 {
 	int ret;
 	struct btrfs_key key;
-	const u64 ino = btrfs_ino(inode);
+	const u64 ino = btrfs_ino(BTRFS_I(inode));
 	int ins_nr = 0;
 	int start_slot = 0;
 
@@ -4383,7 +4383,7 @@ static int btrfs_log_trailing_hole(struct btrfs_trans_handle *trans,
 	u64 hole_size;
 	struct extent_buffer *leaf;
 	struct btrfs_root *log = root->log_root;
-	const u64 ino = btrfs_ino(inode);
+	const u64 ino = btrfs_ino(BTRFS_I(inode));
 	const u64 i_size = i_size_read(inode);
 
 	if (!btrfs_fs_incompat(fs_info, NO_HOLES))
@@ -4616,7 +4616,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 	int ins_start_slot = 0;
 	int ins_nr;
 	bool fast_search = false;
-	u64 ino = btrfs_ino(inode);
+	u64 ino = btrfs_ino(BTRFS_I(inode));
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	u64 logged_isize = 0;
 	bool need_log_inode_item = true;
@@ -4768,7 +4768,7 @@ static int btrfs_log_inode(struct btrfs_trans_handle *trans,
 				err = ret;
 				goto out_unlock;
 			} else if (ret > 0 && ctx &&
-				   other_ino != btrfs_ino(ctx->inode)) {
+				   other_ino != btrfs_ino(BTRFS_I(ctx->inode))) {
 				struct btrfs_key inode_key;
 				struct inode *other_inode;
 
@@ -5171,7 +5171,7 @@ static int log_new_dir_dentries(struct btrfs_trans_handle *trans,
 		btrfs_free_path(path);
 		return -ENOMEM;
 	}
-	dir_elem->ino = btrfs_ino(start_inode);
+	dir_elem->ino = btrfs_ino(BTRFS_I(start_inode));
 	list_add_tail(&dir_elem->list, &dir_list);
 
 	while (!list_empty(&dir_list)) {
@@ -5290,7 +5290,7 @@ static int btrfs_log_all_parents(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 	struct btrfs_key key;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-	const u64 ino = btrfs_ino(inode);
+	const u64 ino = btrfs_ino(BTRFS_I(inode));
 
 	path = btrfs_alloc_path();
 	if (!path)
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 9621c7f2503e..6cf3b0f1bef6 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -47,7 +47,7 @@ ssize_t __btrfs_getxattr(struct inode *inode, const char *name,
 		return -ENOMEM;
 
 	/* lookup the xattr by name */
-	di = btrfs_lookup_xattr(NULL, root, path, btrfs_ino(inode), name,
+	di = btrfs_lookup_xattr(NULL, root, path, btrfs_ino(BTRFS_I(inode)), name,
 				strlen(name), 0);
 	if (!di) {
 		ret = -ENODATA;
@@ -108,7 +108,7 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 	path->skip_release_on_error = 1;
 
 	if (!value) {
-		di = btrfs_lookup_xattr(trans, root, path, btrfs_ino(inode),
+		di = btrfs_lookup_xattr(trans, root, path, btrfs_ino(BTRFS_I(inode)),
 					name, name_len, -1);
 		if (!di && (flags & XATTR_REPLACE))
 			ret = -ENODATA;
@@ -128,7 +128,7 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 	 */
 	if (flags & XATTR_REPLACE) {
 		ASSERT(inode_is_locked(inode));
-		di = btrfs_lookup_xattr(NULL, root, path, btrfs_ino(inode),
+		di = btrfs_lookup_xattr(NULL, root, path, btrfs_ino(BTRFS_I(inode)),
 					name, name_len, 0);
 		if (!di)
 			ret = -ENODATA;
@@ -140,7 +140,7 @@ static int do_setxattr(struct btrfs_trans_handle *trans,
 		di = NULL;
 	}
 
-	ret = btrfs_insert_xattr_item(trans, root, path, btrfs_ino(inode),
+	ret = btrfs_insert_xattr_item(trans, root, path, btrfs_ino(BTRFS_I(inode)),
 				      name, name_len, value, size);
 	if (ret == -EOVERFLOW) {
 		/*
@@ -278,7 +278,7 @@ ssize_t btrfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
 	 * NOTE: we set key.offset = 0; because we want to start with the
 	 * first xattr that we find and walk forward
 	 */
-	key.objectid = btrfs_ino(inode);
+	key.objectid = btrfs_ino(BTRFS_I(inode));
 	key.type = BTRFS_XATTR_ITEM_KEY;
 	key.offset = 0;
 
-- 
2.7.4

