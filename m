From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH 5/6] btrfs: Add per subvolume cached inode tree #2
Date: Tue, 26 May 2009 20:57:13 +0800
Message-ID: <4A1BE729.6090408@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds per subvolume red-black tree to keep trace of cached
inodes. The red-black tree helps the balancing code to find cached
inodes whose inode numbers within a given range.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urpN 5/fs/btrfs/btrfs_inode.h 6/fs/btrfs/btrfs_inode.h
--- 5/fs/btrfs/btrfs_inode.h	2009-04-16 21:13:24.000000000 +0800
+++ 6/fs/btrfs/btrfs_inode.h	2009-05-26 16:00:10.000000000 +0800
@@ -72,6 +72,9 @@ struct btrfs_inode {
 	 */
 	struct list_head ordered_operations;
 
+	/* node for the red-black tree that links inodes in subvolume root */
+	struct rb_node rb_node;
+
 	/* the space_info for where this inode's data allocations are done */
 	struct btrfs_space_info *space_info;
 
diff -urpN 5/fs/btrfs/ctree.h 6/fs/btrfs/ctree.h
--- 5/fs/btrfs/ctree.h	2009-05-26 15:59:06.000000000 +0800
+++ 6/fs/btrfs/ctree.h	2009-05-26 16:00:10.000000000 +0800
@@ -2241,7 +2241,6 @@ int btrfs_page_mkwrite(struct vm_area_st
 int btrfs_readpage(struct file *file, struct page *page);
 void btrfs_delete_inode(struct inode *inode);
 void btrfs_put_inode(struct inode *inode);
-void btrfs_read_locked_inode(struct inode *inode);
 int btrfs_write_inode(struct inode *inode, int wait);
 void btrfs_dirty_inode(struct inode *inode);
 struct inode *btrfs_alloc_inode(struct super_block *sb);
@@ -2249,12 +2248,8 @@ void btrfs_destroy_inode(struct inode *i
 int btrfs_init_cachep(void);
 void btrfs_destroy_cachep(void);
 long btrfs_ioctl_trans_end(struct file *file);
-struct inode *btrfs_ilookup(struct super_block *s, u64 objectid,
-			    struct btrfs_root *root, int wait);
-struct inode *btrfs_iget_locked(struct super_block *s, u64 objectid,
-				struct btrfs_root *root);
 struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
-			 struct btrfs_root *root, int *is_new);
+			 struct btrfs_root *root);
 int btrfs_commit_write(struct file *file, struct page *page,
 		       unsigned from, unsigned to);
 struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
diff -urpN 5/fs/btrfs/export.c 6/fs/btrfs/export.c
--- 5/fs/btrfs/export.c	2009-03-19 11:04:54.000000000 +0800
+++ 6/fs/btrfs/export.c	2009-05-26 16:00:10.000000000 +0800
@@ -78,7 +78,7 @@ static struct dentry *btrfs_get_dentry(s
 	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
 	key.offset = 0;
 
-	inode = btrfs_iget(sb, &key, root, NULL);
+	inode = btrfs_iget(sb, &key, root);
 	if (IS_ERR(inode))
 		return (void *)inode;
 
@@ -192,7 +192,7 @@ static struct dentry *btrfs_get_parent(s
 	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
 	key.offset = 0;
 
-	return d_obtain_alias(btrfs_iget(root->fs_info->sb, &key, root, NULL));
+	return d_obtain_alias(btrfs_iget(root->fs_info->sb, &key, root));
 }
 
 const struct export_operations btrfs_export_ops = {
diff -urpN 5/fs/btrfs/inode.c 6/fs/btrfs/inode.c
--- 5/fs/btrfs/inode.c	2009-05-26 15:59:44.000000000 +0800
+++ 6/fs/btrfs/inode.c	2009-05-26 16:00:10.000000000 +0800
@@ -1958,23 +1958,13 @@ void btrfs_orphan_cleanup(struct btrfs_r
 		 * crossing root thing.  we store the inode number in the
 		 * offset of the orphan item.
 		 */
-		inode = btrfs_iget_locked(root->fs_info->sb,
-					  found_key.offset, root);
-		if (!inode)
+		found_key.objectid = found_key.offset;
+		found_key.type = BTRFS_INODE_ITEM_KEY;
+		found_key.offset = 0;
+		inode = btrfs_iget(root->fs_info->sb, &found_key, root);
+		if (IS_ERR(inode))
 			break;
 
-		if (inode->i_state & I_NEW) {
-			BTRFS_I(inode)->root = root;
-
-			/* have to set the location manually */
-			BTRFS_I(inode)->location.objectid = inode->i_ino;
-			BTRFS_I(inode)->location.type = BTRFS_INODE_ITEM_KEY;
-			BTRFS_I(inode)->location.offset = 0;
-
-			btrfs_read_locked_inode(inode);
-			unlock_new_inode(inode);
-		}
-
 		/*
 		 * add this inode to the orphan list so btrfs_orphan_del does
 		 * the proper thing when we hit it
@@ -2071,7 +2061,7 @@ static noinline int acls_after_inode_ite
 /*
  * read an inode from the btree into the in-memory inode
  */
-void btrfs_read_locked_inode(struct inode *inode)
+static void btrfs_read_locked_inode(struct inode *inode)
 {
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
@@ -3107,6 +3097,45 @@ static int fixup_tree_root_location(stru
 	return 0;
 }
 
+static void inode_tree_add(struct inode *inode)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_inode *entry;
+	struct rb_node **p = &root->inode_tree.rb_node;
+	struct rb_node *parent = NULL;
+
+	spin_lock(&root->inode_lock);
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct btrfs_inode, rb_node);
+
+		if (inode->i_ino < entry->vfs_inode.i_ino)
+			p = &(*p)->rb_left;
+		else if (inode->i_ino > entry->vfs_inode.i_ino)
+			p = &(*p)->rb_right;
+		else {
+			WARN_ON(!(entry->vfs_inode.i_state &
+				  (I_WILL_FREE | I_FREEING | I_CLEAR)));
+			break;
+		}
+	}
+	rb_link_node(&BTRFS_I(inode)->rb_node, parent, p);
+	rb_insert_color(&BTRFS_I(inode)->rb_node, &root->inode_tree);
+	spin_unlock(&root->inode_lock);
+}
+
+static void inode_tree_del(struct inode *inode)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+
+	if (!RB_EMPTY_NODE(&BTRFS_I(inode)->rb_node)) {
+		spin_lock(&root->inode_lock);
+		rb_erase(&BTRFS_I(inode)->rb_node, &root->inode_tree);
+		spin_unlock(&root->inode_lock);
+		RB_CLEAR_NODE(&BTRFS_I(inode)->rb_node);
+	}
+}
+
 static noinline void init_btrfs_i(struct inode *inode)
 {
 	struct btrfs_inode *bi = BTRFS_I(inode);
@@ -3132,6 +3161,7 @@ static noinline void init_btrfs_i(struct
 			     inode->i_mapping, GFP_NOFS);
 	INIT_LIST_HEAD(&BTRFS_I(inode)->delalloc_inodes);
 	INIT_LIST_HEAD(&BTRFS_I(inode)->ordered_operations);
+	RB_CLEAR_NODE(&BTRFS_I(inode)->rb_node);
 	btrfs_ordered_inode_tree_init(&BTRFS_I(inode)->ordered_tree);
 	mutex_init(&BTRFS_I(inode)->extent_mutex);
 	mutex_init(&BTRFS_I(inode)->log_mutex);
@@ -3154,26 +3184,9 @@ static int btrfs_find_actor(struct inode
 		args->root == BTRFS_I(inode)->root;
 }
 
-struct inode *btrfs_ilookup(struct super_block *s, u64 objectid,
-			    struct btrfs_root *root, int wait)
-{
-	struct inode *inode;
-	struct btrfs_iget_args args;
-	args.ino = objectid;
-	args.root = root;
-
-	if (wait) {
-		inode = ilookup5(s, objectid, btrfs_find_actor,
-				 (void *)&args);
-	} else {
-		inode = ilookup5_nowait(s, objectid, btrfs_find_actor,
-					(void *)&args);
-	}
-	return inode;
-}
-
-struct inode *btrfs_iget_locked(struct super_block *s, u64 objectid,
-				struct btrfs_root *root)
+static struct inode *btrfs_iget_locked(struct super_block *s,
+				       u64 objectid,
+				       struct btrfs_root *root)
 {
 	struct inode *inode;
 	struct btrfs_iget_args args;
@@ -3190,24 +3203,21 @@ struct inode *btrfs_iget_locked(struct s
  * Returns in *is_new if the inode was read from disk
  */
 struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
-			 struct btrfs_root *root, int *is_new)
+			 struct btrfs_root *root)
 {
 	struct inode *inode;
 
 	inode = btrfs_iget_locked(s, location->objectid, root);
 	if (!inode)
-		return ERR_PTR(-EACCES);
+		return ERR_PTR(-ENOMEM);
 
 	if (inode->i_state & I_NEW) {
 		BTRFS_I(inode)->root = root;
 		memcpy(&BTRFS_I(inode)->location, location, sizeof(*location));
 		btrfs_read_locked_inode(inode);
+
+		inode_tree_add(inode);
 		unlock_new_inode(inode);
-		if (is_new)
-			*is_new = 1;
-	} else {
-		if (is_new)
-			*is_new = 0;
 	}
 
 	return inode;
@@ -3220,7 +3230,7 @@ struct inode *btrfs_lookup_dentry(struct
 	struct btrfs_root *root = bi->root;
 	struct btrfs_root *sub_root = root;
 	struct btrfs_key location;
-	int ret, new;
+	int ret;
 
 	if (dentry->d_name.len > BTRFS_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -3238,7 +3248,7 @@ struct inode *btrfs_lookup_dentry(struct
 			return ERR_PTR(ret);
 		if (ret > 0)
 			return ERR_PTR(-ENOENT);
-		inode = btrfs_iget(dir->i_sb, &location, sub_root, &new);
+		inode = btrfs_iget(dir->i_sb, &location, sub_root);
 		if (IS_ERR(inode))
 			return ERR_CAST(inode);
 	}
@@ -3633,6 +3643,7 @@ static struct inode *btrfs_new_inode(str
 	btrfs_set_key_type(location, BTRFS_INODE_ITEM_KEY);
 
 	insert_inode_hash(inode);
+	inode_tree_add(inode);
 	return inode;
 fail:
 	if (dir)
@@ -4685,6 +4696,7 @@ void btrfs_destroy_inode(struct inode *i
 			btrfs_put_ordered_extent(ordered);
 		}
 	}
+	inode_tree_del(inode);
 	btrfs_drop_extent_cache(inode, 0, (u64)-1, 0);
 	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
 }
diff -urpN 5/fs/btrfs/super.c 6/fs/btrfs/super.c
--- 5/fs/btrfs/super.c	2009-05-26 07:53:57.000000000 +0800
+++ 6/fs/btrfs/super.c	2009-05-26 16:00:10.000000000 +0800
@@ -52,7 +52,6 @@
 #include "export.h"
 #include "compression.h"
 
-
 static struct super_operations btrfs_super_ops;
 
 static void btrfs_put_super(struct super_block *sb)
@@ -322,7 +321,7 @@ static int btrfs_fill_super(struct super
 	struct dentry *root_dentry;
 	struct btrfs_super_block *disk_super;
 	struct btrfs_root *tree_root;
-	struct btrfs_inode *bi;
+	struct btrfs_key key;
 	int err;
 
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
@@ -341,23 +340,15 @@ static int btrfs_fill_super(struct super
 	}
 	sb->s_fs_info = tree_root;
 	disk_super = &tree_root->fs_info->super_copy;
-	inode = btrfs_iget_locked(sb, BTRFS_FIRST_FREE_OBJECTID,
-				  tree_root->fs_info->fs_root);
-	bi = BTRFS_I(inode);
-	bi->location.objectid = inode->i_ino;
-	bi->location.offset = 0;
-	bi->root = tree_root->fs_info->fs_root;
-
-	btrfs_set_key_type(&bi->location, BTRFS_INODE_ITEM_KEY);
 
-	if (!inode) {
-		err = -ENOMEM;
+	key.objectid = BTRFS_FIRST_FREE_OBJECTID;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+	inode = btrfs_iget(sb, &key, tree_root->fs_info->fs_root);
+	if (IS_ERR(inode)) {
+		err = PTR_ERR(inode);
 		goto fail_close;
 	}
-	if (inode->i_state & I_NEW) {
-		btrfs_read_locked_inode(inode);
-		unlock_new_inode(inode);
-	}
 
 	root_dentry = d_alloc_root(inode);
 	if (!root_dentry) {
@@ -588,7 +579,8 @@ static int btrfs_remount(struct super_bl
 		if (btrfs_super_log_root(&root->fs_info->super_copy) != 0)
 			return -EINVAL;
 
-		ret = btrfs_cleanup_reloc_trees(root);
+		/* recover relocation */
+		ret = btrfs_recover_relocation(root);
 		WARN_ON(ret);
 
 		ret = btrfs_cleanup_fs_roots(root->fs_info);


