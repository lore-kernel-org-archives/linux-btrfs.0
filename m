From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: cleanup some BUG_ON()
Date: Wed, 23 Mar 2011 17:14:16 +0900
Message-ID: <201103230814.AA00010@T-ITOH1.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch changes some BUG_ON() to the error return.
(but, most callers still use BUG_ON())

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/ctree.c       |    3 ++-
 fs/btrfs/disk-io.c     |    5 ++++-
 fs/btrfs/extent-tree.c |   25 ++++++++++++++++++-------
 fs/btrfs/file-item.c   |    3 ++-
 fs/btrfs/inode-map.c   |    3 ++-
 fs/btrfs/ioctl.c       |    5 ++++-
 fs/btrfs/root-tree.c   |    6 ++++--
 fs/btrfs/transaction.c |   12 +++++++++---
 fs/btrfs/tree-log.c    |   15 +++++++++------
 9 files changed, 54 insertions(+), 23 deletions(-)

diff -urNp linux-2.6.38/fs/btrfs/ctree.c linux-2.6.38.new/fs/btrfs/ctree.c
--- linux-2.6.38/fs/btrfs/ctree.c	2011-03-15 10:20:32.000000000 +0900
+++ linux-2.6.38.new/fs/btrfs/ctree.c	2011-03-23 11:28:09.000000000 +0900
@@ -3840,7 +3840,8 @@ int btrfs_insert_item(struct btrfs_trans
 	unsigned long ptr;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 	ret = btrfs_insert_empty_item(trans, root, path, cpu_key, data_size);
 	if (!ret) {
 		leaf = path->nodes[0];
diff -urNp linux-2.6.38/fs/btrfs/disk-io.c linux-2.6.38.new/fs/btrfs/disk-io.c
--- linux-2.6.38/fs/btrfs/disk-io.c	2011-03-15 10:20:32.000000000 +0900
+++ linux-2.6.38.new/fs/btrfs/disk-io.c	2011-03-23 11:44:39.000000000 +0900
@@ -1160,7 +1160,10 @@ struct btrfs_root *btrfs_read_fs_root_no
 		     root, fs_info, location->objectid);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path) {
+		kfree(root);
+		return ERR_PTR(-ENOMEM);
+	}
 	ret = btrfs_search_slot(NULL, tree_root, location, path, 0, 0);
 	if (ret == 0) {
 		l = path->nodes[0];
diff -urNp linux-2.6.38/fs/btrfs/extent-tree.c linux-2.6.38.new/fs/btrfs/extent-tree.c
--- linux-2.6.38/fs/btrfs/extent-tree.c	2011-03-15 10:20:32.000000000 +0900
+++ linux-2.6.38.new/fs/btrfs/extent-tree.c	2011-03-23 11:28:09.000000000 +0900
@@ -5444,7 +5444,8 @@ static int alloc_reserved_file_extent(st
 	size = sizeof(*extent_item) + btrfs_extent_inline_ref_size(type);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
@@ -6438,10 +6439,14 @@ int btrfs_drop_subtree(struct btrfs_tran
 	BUG_ON(root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	wc = kzalloc(sizeof(*wc), GFP_NOFS);
-	BUG_ON(!wc);
+	if (!wc) {
+		btrfs_free_path(path);
+		return -ENOMEM;
+	}
 
 	btrfs_assert_tree_locked(parent);
 	parent_level = btrfs_header_level(parent);
@@ -6899,7 +6904,11 @@ static noinline int get_new_locations(st
 	}
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path) {
+		if (exts != *extents)
+			kfree(exts);
+		return -ENOMEM;
+	}
 
 	cur_pos = extent_key->objectid - offset;
 	last_byte = extent_key->objectid + extent_key->offset;
@@ -7423,7 +7432,8 @@ static noinline int replace_extents_in_l
 	int ret;
 
 	new_extent = kmalloc(sizeof(*new_extent), GFP_NOFS);
-	BUG_ON(!new_extent);
+	if (!new_extent)
+		return -ENOMEM;
 
 	ref = btrfs_lookup_leaf_ref(root, leaf->start);
 	BUG_ON(!ref);
@@ -7627,7 +7637,8 @@ static noinline int init_reloc_tree(stru
 		return 0;
 
 	root_item = kmalloc(sizeof(*root_item), GFP_NOFS);
-	BUG_ON(!root_item);
+	if (!root_item)
+		return -ENOMEM;
 
 	ret = btrfs_copy_root(trans, root, root->commit_root,
 			      &eb, BTRFS_TREE_RELOC_OBJECTID);
@@ -7653,7 +7664,7 @@ static noinline int init_reloc_tree(stru
 
 	reloc_root = btrfs_read_fs_root_no_radix(root->fs_info->tree_root,
 						 &root_key);
-	BUG_ON(!reloc_root);
+	BUG_ON(IS_ERR(reloc_root));
 	reloc_root->last_trans = trans->transid;
 	reloc_root->commit_root = NULL;
 	reloc_root->ref_tree = &root->fs_info->reloc_ref_tree;
diff -urNp linux-2.6.38/fs/btrfs/file-item.c linux-2.6.38.new/fs/btrfs/file-item.c
--- linux-2.6.38/fs/btrfs/file-item.c	2011-03-15 10:20:32.000000000 +0900
+++ linux-2.6.38.new/fs/btrfs/file-item.c	2011-03-23 11:28:09.000000000 +0900
@@ -48,7 +48,8 @@ int btrfs_insert_file_extent(struct btrf
 	struct extent_buffer *leaf;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 	file_key.objectid = objectid;
 	file_key.offset = pos;
 	btrfs_set_key_type(&file_key, BTRFS_EXTENT_DATA_KEY);
diff -urNp linux-2.6.38/fs/btrfs/inode-map.c linux-2.6.38.new/fs/btrfs/inode-map.c
--- linux-2.6.38/fs/btrfs/inode-map.c	2011-03-15 10:20:32.000000000 +0900
+++ linux-2.6.38.new/fs/btrfs/inode-map.c	2011-03-23 11:28:09.000000000 +0900
@@ -30,7 +30,8 @@ int btrfs_find_highest_inode(struct btrf
 	int slot;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	search_key.objectid = BTRFS_LAST_FREE_OBJECTID;
 	search_key.type = -1;
diff -urNp linux-2.6.38/fs/btrfs/ioctl.c linux-2.6.38.new/fs/btrfs/ioctl.c
--- linux-2.6.38/fs/btrfs/ioctl.c	2011-03-15 10:20:32.000000000 +0900
+++ linux-2.6.38.new/fs/btrfs/ioctl.c	2011-03-23 11:28:09.000000000 +0900
@@ -2348,12 +2348,15 @@ static noinline long btrfs_ioctl_start_s
 	struct btrfs_root *root = BTRFS_I(file->f_dentry->d_inode)->root;
 	struct btrfs_trans_handle *trans;
 	u64 transid;
+	int ret;
 
 	trans = btrfs_start_transaction(root, 0);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
 	transid = trans->transid;
-	btrfs_commit_transaction_async(trans, root, 0);
+	ret = btrfs_commit_transaction_async(trans, root, 0);
+	if (ret)
+		return ret;
 
 	if (argp)
 		if (copy_to_user(argp, &transid, sizeof(transid)))
diff -urNp linux-2.6.38/fs/btrfs/root-tree.c linux-2.6.38.new/fs/btrfs/root-tree.c
--- linux-2.6.38/fs/btrfs/root-tree.c	2011-03-15 10:20:32.000000000 +0900
+++ linux-2.6.38.new/fs/btrfs/root-tree.c	2011-03-23 11:28:09.000000000 +0900
@@ -88,7 +88,8 @@ int btrfs_find_last_root(struct btrfs_ro
 	search_key.offset = (u64)-1;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
 	if (ret < 0)
 		goto out;
@@ -332,7 +333,8 @@ int btrfs_del_root(struct btrfs_trans_ha
 	struct extent_buffer *leaf;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 	ret = btrfs_search_slot(trans, root, key, path, -1, 1);
 	if (ret < 0)
 		goto out;
diff -urNp linux-2.6.38/fs/btrfs/transaction.c linux-2.6.38.new/fs/btrfs/transaction.c
--- linux-2.6.38/fs/btrfs/transaction.c	2011-03-15 10:20:32.000000000 +0900
+++ linux-2.6.38.new/fs/btrfs/transaction.c	2011-03-23 11:28:09.000000000 +0900
@@ -57,7 +57,8 @@ static noinline int join_transaction(str
 	if (!cur_trans) {
 		cur_trans = kmem_cache_alloc(btrfs_transaction_cachep,
 					     GFP_NOFS);
-		BUG_ON(!cur_trans);
+		if (!cur_trans)
+			return -ENOMEM;
 		root->fs_info->generation++;
 		cur_trans->num_writers = 1;
 		cur_trans->num_joined = 0;
@@ -195,7 +196,11 @@ again:
 		wait_current_trans(root);
 
 	ret = join_transaction(root);
-	BUG_ON(ret);
+	if (ret < 0) {
+		if (type != TRANS_JOIN_NOLOCK)
+			mutex_unlock(&root->fs_info->trans_mutex);
+		return ERR_PTR(ret);
+	}
 
 	cur_trans = root->fs_info->running_transaction;
 	cur_trans->use_count++;
@@ -1156,7 +1161,8 @@ int btrfs_commit_transaction_async(struc
 	struct btrfs_transaction *cur_trans;
 
 	ac = kmalloc(sizeof(*ac), GFP_NOFS);
-	BUG_ON(!ac);
+	if (!ac)
+		return -ENOMEM;
 
 	INIT_DELAYED_WORK(&ac->work, do_async_commit);
 	ac->root = root;
diff -urNp linux-2.6.38/fs/btrfs/tree-log.c linux-2.6.38.new/fs/btrfs/tree-log.c
--- linux-2.6.38/fs/btrfs/tree-log.c	2011-03-15 10:20:32.000000000 +0900
+++ linux-2.6.38.new/fs/btrfs/tree-log.c	2011-03-23 11:28:09.000000000 +0900
@@ -1821,7 +1821,8 @@ static int walk_log_tree(struct btrfs_tr
 	int orig_level;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	level = btrfs_header_level(log->node);
 	orig_level = level;
@@ -3107,9 +3108,11 @@ int btrfs_recover_log_trees(struct btrfs
 		.stage = 0,
 	};
 
-	fs_info->log_root_recovering = 1;
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
+
+	fs_info->log_root_recovering = 1;
 
 	trans = btrfs_start_transaction(fs_info->tree_root, 0);
 	BUG_ON(IS_ERR(trans));
@@ -3117,7 +3120,8 @@ int btrfs_recover_log_trees(struct btrfs
 	wc.trans = trans;
 	wc.pin = 1;
 
-	walk_log_tree(trans, log_root_tree, &wc);
+	ret = walk_log_tree(trans, log_root_tree, &wc);
+	BUG_ON(ret);
 
 again:
 	key.objectid = BTRFS_TREE_LOG_OBJECTID;
@@ -3141,8 +3145,7 @@ again:
 
 		log = btrfs_read_fs_root_no_radix(log_root_tree,
 						  &found_key);
-		BUG_ON(!log);
-
+		BUG_ON(IS_ERR(log));
 
 		tmp_key.objectid = found_key.offset;
 		tmp_key.type = BTRFS_ROOT_ITEM_KEY;


