From: "Yan, Zheng" <zheng.yan@oracle.com>
Subject: [PATCH 3/4] do not reuse objectid of deleted snapshot/subvol
Date: Tue, 25 Aug 2009 22:39:48 +0800
Message-ID: <4A93F7B4.2030500@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The new back refernece format does not allow reusing objectid of
deleted snapshot/subvol. So use ++highest_objectid to allocate
objectid for new snapshot/subvol.

Since we use ++highest_objectid to allocate objectid for both
new inode and new snapshot/subvol, This patch also removes
'find hole' code in btrfs_find_free_objectid.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 3/fs/btrfs/ctree.h 4/fs/btrfs/ctree.h
--- 3/fs/btrfs/ctree.h	2009-08-24 10:38:34.280386024 +0800
+++ 4/fs/btrfs/ctree.h	2009-08-24 10:39:12.200349458 +0800
@@ -998,8 +998,8 @@ struct btrfs_root {
 	u32 stripesize;
 
 	u32 type;
-	u64 highest_inode;
-	u64 last_inode_alloc;
+
+	u64 highest_objectid;
 	int ref_cows;
 	int track_dirty;
 	u64 defrag_trans_start;
diff -urp 3/fs/btrfs/disk-io.c 4/fs/btrfs/disk-io.c
--- 3/fs/btrfs/disk-io.c	2009-08-24 10:36:43.009349000 +0800
+++ 4/fs/btrfs/disk-io.c	2009-08-24 10:39:12.202348481 +0800
@@ -893,8 +893,7 @@ static int __setup_root(u32 nodesize, u3
 	root->fs_info = fs_info;
 	root->objectid = objectid;
 	root->last_trans = 0;
-	root->highest_inode = 0;
-	root->last_inode_alloc = 0;
+	root->highest_objectid = 0;
 	root->name = NULL;
 	root->in_sysfs = 0;
 	root->inode_tree.rb_node = NULL;
@@ -1093,7 +1092,6 @@ struct btrfs_root *btrfs_read_fs_root_no
 	struct btrfs_fs_info *fs_info = tree_root->fs_info;
 	struct btrfs_path *path;
 	struct extent_buffer *l;
-	u64 highest_inode;
 	u64 generation;
 	u32 blocksize;
 	int ret = 0;
@@ -1108,7 +1106,7 @@ struct btrfs_root *btrfs_read_fs_root_no
 			kfree(root);
 			return ERR_PTR(ret);
 		}
-		goto insert;
+		goto out;
 	}
 
 	__setup_root(tree_root->nodesize, tree_root->leafsize,
@@ -1118,39 +1116,30 @@ struct btrfs_root *btrfs_read_fs_root_no
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 	ret = btrfs_search_slot(NULL, tree_root, location, path, 0, 0);
-	if (ret != 0) {
-		if (ret > 0)
-			ret = -ENOENT;
-		goto out;
+	if (ret == 0) {
+		l = path->nodes[0];
+		read_extent_buffer(l, &root->root_item,
+				btrfs_item_ptr_offset(l, path->slots[0]),
+				sizeof(root->root_item));
+		memcpy(&root->root_key, location, sizeof(*location));
 	}
-	l = path->nodes[0];
-	read_extent_buffer(l, &root->root_item,
-	       btrfs_item_ptr_offset(l, path->slots[0]),
-	       sizeof(root->root_item));
-	memcpy(&root->root_key, location, sizeof(*location));
-	ret = 0;
-out:
-	btrfs_release_path(root, path);
 	btrfs_free_path(path);
 	if (ret) {
-		kfree(root);
+		if (ret > 0)
+			ret = -ENOENT;
 		return ERR_PTR(ret);
 	}
+
 	generation = btrfs_root_generation(&root->root_item);
 	blocksize = btrfs_level_size(root, btrfs_root_level(&root->root_item));
 	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
 				     blocksize, generation);
 	root->commit_root = btrfs_root_node(root);
 	BUG_ON(!root->node);
-insert:
-	if (location->objectid != BTRFS_TREE_LOG_OBJECTID) {
+out:
+	if (location->objectid != BTRFS_TREE_LOG_OBJECTID)
 		root->ref_cows = 1;
-		ret = btrfs_find_highest_inode(root, &highest_inode);
-		if (ret == 0) {
-			root->highest_inode = highest_inode;
-			root->last_inode_alloc = highest_inode;
-		}
-	}
+
 	return root;
 }
 
diff -urp 3/fs/btrfs/inode.c 4/fs/btrfs/inode.c
--- 3/fs/btrfs/inode.c	2009-08-24 10:38:34.284098975 +0800
+++ 4/fs/btrfs/inode.c	2009-08-24 10:39:12.205349181 +0800
@@ -3675,9 +3675,6 @@ static struct inode *btrfs_new_inode(str
 	if (ret != 0)
 		goto fail;
 
-	if (objectid > root->highest_inode)
-		root->highest_inode = objectid;
-
 	inode->i_uid = current_fsuid();
 
 	if (dir && (dir->i_mode & S_ISGID)) {
diff -urp 3/fs/btrfs/inode-item.c 4/fs/btrfs/inode-item.c
--- 3/fs/btrfs/inode-item.c	2009-08-24 10:36:35.733099000 +0800
+++ 4/fs/btrfs/inode-item.c	2009-08-24 10:39:12.206349392 +0800
@@ -177,8 +177,6 @@ int btrfs_insert_empty_inode(struct btrf
 
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
 				      sizeof(struct btrfs_inode_item));
-	if (ret == 0 && objectid > root->highest_inode)
-		root->highest_inode = objectid;
 	return ret;
 }
 
diff -urp 3/fs/btrfs/inode-map.c 4/fs/btrfs/inode-map.c
--- 3/fs/btrfs/inode-map.c	2009-08-24 10:36:35.734100000 +0800
+++ 4/fs/btrfs/inode-map.c	2009-08-25 13:12:02.360309951 +0800
@@ -43,9 +43,10 @@ int btrfs_find_highest_inode(struct btrf
 		slot = path->slots[0] - 1;
 		l = path->nodes[0];
 		btrfs_item_key_to_cpu(l, &found_key, slot);
-		*objectid = found_key.objectid;
+		*objectid = max_t(u64, found_key.objectid,
+				  BTRFS_FIRST_FREE_OBJECTID - 1);
 	} else {
-		*objectid = BTRFS_FIRST_FREE_OBJECTID;
+		*objectid = BTRFS_FIRST_FREE_OBJECTID - 1;
 	}
 	ret = 0;
 error:
@@ -53,91 +54,28 @@ error:
 	return ret;
 }
 
-/*
- * walks the btree of allocated inodes and find a hole.
- */
 int btrfs_find_free_objectid(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     u64 dirid, u64 *objectid)
 {
-	struct btrfs_path *path;
-	struct btrfs_key key;
 	int ret;
-	int slot = 0;
-	u64 last_ino = 0;
-	int start_found;
-	struct extent_buffer *l;
-	struct btrfs_key search_key;
-	u64 search_start = dirid;
-
 	mutex_lock(&root->objectid_mutex);
-	if (root->last_inode_alloc >= BTRFS_FIRST_FREE_OBJECTID &&
-	    root->last_inode_alloc < BTRFS_LAST_FREE_OBJECTID) {
-		*objectid = ++root->last_inode_alloc;
-		mutex_unlock(&root->objectid_mutex);
-		return 0;
-	}
-	path = btrfs_alloc_path();
-	BUG_ON(!path);
-	search_start = max(search_start, (u64)BTRFS_FIRST_FREE_OBJECTID);
-	search_key.objectid = search_start;
-	search_key.type = 0;
-	search_key.offset = 0;
-
-	start_found = 0;
-	ret = btrfs_search_slot(trans, root, &search_key, path, 0, 0);
-	if (ret < 0)
-		goto error;
 
-	while (1) {
-		l = path->nodes[0];
-		slot = path->slots[0];
-		if (slot >= btrfs_header_nritems(l)) {
-			ret = btrfs_next_leaf(root, path);
-			if (ret == 0)
-				continue;
-			if (ret < 0)
-				goto error;
-			if (!start_found) {
-				*objectid = search_start;
-				start_found = 1;
-				goto found;
-			}
-			*objectid = last_ino > search_start ?
-				last_ino : search_start;
-			goto found;
-		}
-		btrfs_item_key_to_cpu(l, &key, slot);
-		if (key.objectid >= search_start) {
-			if (start_found) {
-				if (last_ino < search_start)
-					last_ino = search_start;
-				if (key.objectid > last_ino) {
-					*objectid = last_ino;
-					goto found;
-				}
-			} else if (key.objectid > search_start) {
-				*objectid = search_start;
-				goto found;
-			}
-		}
-		if (key.objectid >= BTRFS_LAST_FREE_OBJECTID)
-			break;
+	if (unlikely(root->highest_objectid < BTRFS_FIRST_FREE_OBJECTID)) {
+		ret = btrfs_find_highest_inode(root, &root->highest_objectid);
+		if (ret)
+			goto out;
+	}
 
-		start_found = 1;
-		last_ino = key.objectid + 1;
-		path->slots[0]++;
+	if (unlikely(root->highest_objectid >= BTRFS_LAST_FREE_OBJECTID)) {
+		ret = -ENOSPC;
+		goto out;
 	}
-	BUG_ON(1);
-found:
-	btrfs_release_path(root, path);
-	btrfs_free_path(path);
-	BUG_ON(*objectid < search_start);
-	mutex_unlock(&root->objectid_mutex);
-	return 0;
-error:
-	btrfs_release_path(root, path);
-	btrfs_free_path(path);
+
+	*objectid = ++root->highest_objectid;
+	ret = 0;
+out:
 	mutex_unlock(&root->objectid_mutex);
 	return ret;
 }
+
diff -urp 3/fs/btrfs/tree-log.c 4/fs/btrfs/tree-log.c
--- 3/fs/btrfs/tree-log.c	2009-08-24 10:38:34.290099887 +0800
+++ 4/fs/btrfs/tree-log.c	2009-08-24 10:39:12.209349324 +0800
@@ -2959,7 +2959,6 @@ int btrfs_recover_log_trees(struct btrfs
 	struct btrfs_key tmp_key;
 	struct btrfs_root *log;
 	struct btrfs_fs_info *fs_info = log_root_tree->fs_info;
-	u64 highest_inode;
 	struct walk_control wc = {
 		.process_func = process_one_buffer,
 		.stage = 0,
@@ -3018,11 +3017,6 @@ again:
 						      path);
 			BUG_ON(ret);
 		}
-		ret = btrfs_find_highest_inode(wc.replay_dest, &highest_inode);
-		if (ret == 0) {
-			wc.replay_dest->highest_inode = highest_inode;
-			wc.replay_dest->last_inode_alloc = highest_inode;
-		}
 
 		key.offset = found_key.offset - 1;
 		wc.replay_dest->log_root = NULL;
