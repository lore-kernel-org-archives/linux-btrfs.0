From: Diego Calleja <diegocg@gmail.com>
Subject: [PATCH] always check btrfs_alloc_path() failure
Date: Mon, 29 Dec 2008 21:56:27 +0100
Message-ID: <20081229215627.2ad54639@diego-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

There are some places that don't check at all btrfs_alloc_path() failures,
I added BUG_ON's for all of them, as many other codepaths that don't know
how to handle the failures seem to do.

In case of not applying this patch, I must notice that there's one real
bugfix that should be applied, it's a null pointer dereference on inode.c:

2506:	path = btrfs_alloc_path();
2507:	path->reada = -1;
2508:	BUG_ON(!path);



Index: btrfs-unstable-standalone/dir-item.c
===================================================================
--- btrfs-unstable-standalone.orig/dir-item.c	2008-12-29 21:23:16.940588725 +0100
+++ btrfs-unstable-standalone/dir-item.c	2008-12-29 21:30:13.654588510 +0100
@@ -146,6 +146,7 @@
 	btrfs_set_key_type(&key, BTRFS_DIR_ITEM_KEY);
 	key.offset = btrfs_name_hash(name, name_len);
 	path = btrfs_alloc_path();
+	BUG_ON(!path);
 	data_size = sizeof(*dir_item) + name_len;
 	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
 					name, name_len);
Index: btrfs-unstable-standalone/export.c
===================================================================
--- btrfs-unstable-standalone.orig/export.c	2008-12-29 21:25:33.317589186 +0100
+++ btrfs-unstable-standalone/export.c	2008-12-29 21:26:46.658692859 +0100
@@ -146,6 +146,7 @@
 	int ret;
 
 	path = btrfs_alloc_path();
+	BUG_ON(!path);
 
 	key.objectid = dir->i_ino;
 	btrfs_set_key_type(&key, BTRFS_INODE_REF_KEY);
Index: btrfs-unstable-standalone/extent-tree.c
===================================================================
--- btrfs-unstable-standalone.orig/extent-tree.c	2008-12-29 21:26:52.133589589 +0100
+++ btrfs-unstable-standalone/extent-tree.c	2008-12-29 21:29:33.000589414 +0100
@@ -1337,6 +1337,7 @@
 
 	WARN_ON(num_bytes < root->sectorsize);
 	path = btrfs_alloc_path();
+	BUG_ON(!path);
 	path->reada = 1;
 	key.objectid = bytenr;
 	key.offset = num_bytes;
@@ -1377,6 +1378,7 @@
 	key.type = BTRFS_EXTENT_ITEM_KEY;
 
 	path = btrfs_alloc_path();
+	BUG_ON(!path);
 	ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
@@ -2132,6 +2134,7 @@
 	int num_inserts = 0, max_inserts;
 
 	path = btrfs_alloc_path();
+	BUG_ON(!path);
 	INIT_LIST_HEAD(&insert_list);
 	INIT_LIST_HEAD(&update_list);
 
Index: btrfs-unstable-standalone/file-item.c
===================================================================
--- btrfs-unstable-standalone.orig/file-item.c	2008-12-29 21:30:59.441588913 +0100
+++ btrfs-unstable-standalone/file-item.c	2008-12-29 21:31:58.836588923 +0100
@@ -160,6 +160,7 @@
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 
 	path = btrfs_alloc_path();
+	BUG_ON(!path);
 	if (bio->bi_size > PAGE_CACHE_SIZE * 8)
 		path->reada = 2;
 
@@ -506,6 +507,7 @@
 	root = root->fs_info->csum_root;
 
 	path = btrfs_alloc_path();
+	BUG_ON(!path);
 
 	while(1) {
 		key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
Index: btrfs-unstable-standalone/file.c
===================================================================
--- btrfs-unstable-standalone.orig/file.c	2008-12-29 21:30:18.940839123 +0100
+++ btrfs-unstable-standalone/file.c	2008-12-29 21:30:38.941774195 +0100
@@ -293,6 +293,7 @@
 	u64 extent_end = 0;
 
 	path = btrfs_alloc_path();
+	BUG_ON(!path);
 	ret = btrfs_lookup_file_extent(NULL, root, path, inode->i_ino,
 				       last_offset, 0);
 	while(1) {
Index: btrfs-unstable-standalone/inode.c
===================================================================
--- btrfs-unstable-standalone.orig/inode.c	2008-12-29 21:32:03.109588918 +0100
+++ btrfs-unstable-standalone/inode.c	2008-12-29 21:35:12.321588484 +0100
@@ -2504,8 +2504,8 @@
 	if (root->ref_cows)
 		btrfs_drop_extent_cache(inode, new_size & (~mask), (u64)-1, 0);
 	path = btrfs_alloc_path();
-	path->reada = -1;
 	BUG_ON(!path);
+	path->reada = -1;
 
 	/* FIXME, add redo link to tree so we don't leak on crash */
 	key.objectid = inode->i_ino;
@@ -3182,6 +3182,7 @@
 		filp->f_pos = 2;
 	}
 	path = btrfs_alloc_path();
+	BUG_ON(!path);
 	path->reada = 2;
 
 	btrfs_set_key_type(&key, key_type);
Index: btrfs-unstable-standalone/ioctl.c
===================================================================
--- btrfs-unstable-standalone.orig/ioctl.c	2008-12-29 21:35:26.854838809 +0100
+++ btrfs-unstable-standalone/ioctl.c	2008-12-29 21:36:27.742591734 +0100
@@ -292,6 +292,7 @@
 		u64 test_oid;
 		u64 parent_oid = BTRFS_I(dir->d_inode)->root->root_key.objectid;
 
+		BUG_ON(!path);
 		test_oid = snap_src->root_key.objectid;
 
 		ret = btrfs_find_root_ref(snap_src->fs_info->tree_root,
Index: btrfs-unstable-standalone/root-tree.c
===================================================================
--- btrfs-unstable-standalone.orig/root-tree.c	2008-12-29 21:36:49.242838916 +0100
+++ btrfs-unstable-standalone/root-tree.c	2008-12-29 21:37:53.940590092 +0100
@@ -286,6 +286,7 @@
 	struct btrfs_path *path;
 
 	path = btrfs_alloc_path();
+	BUG_ON(!path);
 
 	key.objectid = root_id;
 	key.type = type;
@@ -346,6 +347,7 @@
 
 
 	path = btrfs_alloc_path();
+	BUG_ON(!path);
 
 	key.objectid = root_id;
 	key.type = type;
Index: btrfs-unstable-standalone/tree-log.c
===================================================================
--- btrfs-unstable-standalone.orig/tree-log.c	2008-12-29 21:38:05.420838636 +0100
+++ btrfs-unstable-standalone/tree-log.c	2008-12-29 21:40:13.594588854 +0100
@@ -708,6 +708,7 @@
 	int match = 0;
 
 	path = btrfs_alloc_path();
+	BUG_ON(!path);
 	ret = btrfs_search_slot(NULL, log, key, path, 0, 0);
 	if (ret != 0)
 		goto out;
@@ -989,6 +990,7 @@
 	key.offset = (u64)-1;
 
 	path = btrfs_alloc_path();
+	BUG_ON(!path);
 
 	while(1) {
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
@@ -2109,6 +2111,7 @@
 
 	log = root->log_root;
 	path = btrfs_alloc_path();
+	BUG_ON(!path);
 	di = btrfs_lookup_dir_item(trans, log, path, dir->i_ino,
 				   name, name_len, -1);
 	if (di && !IS_ERR(di)) {
@@ -2476,6 +2479,7 @@
 	list_add_tail(&sums->list, list);
 
 	path = btrfs_alloc_path();
+	BUG_ON(!path);
 	while(disk_bytenr < end) {
 		if (!item || disk_bytenr < item_start_offset ||
 		    disk_bytenr >= item_last_offset) {
@@ -2683,7 +2687,9 @@
 	log = root->log_root;
 
 	path = btrfs_alloc_path();
+	BUG_ON(!path);
 	dst_path = btrfs_alloc_path();
+	BUG_ON(!dst_path);
 
 	min_key.objectid = inode->i_ino;
 	min_key.type = BTRFS_INODE_ITEM_KEY;
