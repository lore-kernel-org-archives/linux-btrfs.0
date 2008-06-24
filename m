From: Josef Bacik <jbacik@redhat.com>
Subject: [RFC][PATCH] btrfs orphan code
Date: Tue, 24 Jun 2008 14:04:50 -0400
Message-ID: <20080624180450.GA9813@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I want to throw this out here now that I've got most of the heavy lifting done
for this code to make sure what I'm doing is ok for now.  I've added an
ORPHAN_DIR item key to have a hidden dir per root.  Right now it just does it
for whatever the default root is on mount, but I'm going to fix that to do the
orphan dir check/creation on lookup of a subvolume root.  I also changed
btrfs_insert_dir_item to take an index flag to indicate whether or not we want
to add a DIR_INDEX item along with the dir item.  Let me know if there are any
glaring design problems with what I've done.  Thanks much,

Josef


diff -r 99b12e2db0f8 btrfs_inode.h
--- a/btrfs_inode.h	Wed Jun 18 20:50:41 2008 -0400
+++ b/btrfs_inode.h	Tue Jun 24 21:04:39 2008 -0400
@@ -36,6 +36,9 @@ struct btrfs_inode {
 	struct posix_acl *i_acl;
 	struct posix_acl *i_default_acl;
 
+	/* for keeping track of orphaned inodes */
+	struct list_head i_orphan;
+
 	u64 ordered_trans;
 	/*
 	 * transid of the trans_handle that last modified this inode
diff -r 99b12e2db0f8 ctree.h
--- a/ctree.h	Wed Jun 18 20:50:41 2008 -0400
+++ b/ctree.h	Tue Jun 24 21:04:39 2008 -0400
@@ -103,7 +103,8 @@ extern struct kmem_cache *btrfs_path_cac
 #define BTRFS_FT_SOCK		6
 #define BTRFS_FT_SYMLINK	7
 #define BTRFS_FT_XATTR		8
-#define BTRFS_FT_MAX		9
+#define BTRFS_FT_ORPHAN_DIR	9
+#define BTRFS_FT_MAX		10
 
 /*
  * the key defines the order in the tree, and so it also defines (optimal)
@@ -613,6 +614,10 @@ struct btrfs_root {
 
 	/* the dirty list is only used by non-reference counted roots */
 	struct list_head dirty_list;
+
+	/* orphan crap */
+	struct inode *orphan_dir;
+	struct list_head orphan_list;
 };
 
 /*
@@ -624,6 +629,7 @@ struct btrfs_root {
 #define BTRFS_INODE_ITEM_KEY		1
 #define BTRFS_INODE_REF_KEY		2
 #define BTRFS_XATTR_ITEM_KEY		8
+#define BTRFS_ORPHAN_DIR_ITEM_KEY	9
 /* reserve 2-15 close to the inode for later flexibility */
 
 /*
@@ -1485,7 +1491,7 @@ int btrfs_find_dead_roots(struct btrfs_r
 /* dir-item.c */
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 			  *root, const char *name, int name_len, u64 dir,
-			  struct btrfs_key *location, u8 type);
+			  struct btrfs_key *location, u8 type, int index);
 struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
 					     struct btrfs_path *path, u64 dir,
@@ -1513,6 +1519,15 @@ struct btrfs_dir_item *btrfs_lookup_xatt
 					  struct btrfs_path *path, u64 dir,
 					  const char *name, u16 name_len,
 					  int mod);
+int btrfs_insert_orphan_dir_item(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 struct btrfs_key *location);
+struct btrfs_dir_item *btrfs_lookup_orphan_dir_item(struct btrfs_trans_handle
+						    *trans,
+						    struct btrfs_root *root,
+						    struct btrfs_path *path,
+						    int mod);
+
 /* inode-map.c */
 int btrfs_find_free_objectid(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *fs_root,
@@ -1607,7 +1622,7 @@ int btrfs_update_inode(struct btrfs_tran
 int btrfs_update_inode(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct inode *inode);
-
+struct inode *btrfs_lookup_orphan_dir(struct btrfs_root *root);
 /* ioctl.c */
 long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
diff -r 99b12e2db0f8 dir-item.c
--- a/dir-item.c	Wed Jun 18 20:50:41 2008 -0400
+++ b/dir-item.c	Tue Jun 24 21:04:39 2008 -0400
@@ -110,7 +110,7 @@ int btrfs_insert_xattr_item(struct btrfs
 
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 			  *root, const char *name, int name_len, u64 dir,
-			  struct btrfs_key *location, u8 type)
+			  struct btrfs_key *location, u8 type, int index)
 {
 	int ret = 0;
 	int ret2 = 0;
@@ -149,7 +149,7 @@ int btrfs_insert_dir_item(struct btrfs_t
 
 second_insert:
 	/* FIXME, use some real flag for selecting the extra index */
-	if (root == root->fs_info->tree_root) {
+	if (root == root->fs_info->tree_root || !index) {
 		ret = 0;
 		goto out;
 	}
@@ -179,6 +179,87 @@ out:
 	if (ret2)
 		return ret2;
 	return 0;
+}
+
+int btrfs_insert_orphan_dir_item(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root,
+				 struct btrfs_key *location)
+{
+	struct btrfs_disk_key disk_key;
+	struct btrfs_dir_item *dir_item;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	unsigned long name_ptr;
+	const char *name = ".orphandir";
+	int name_len = strlen(name);
+	int ret = 0;
+	u32 data_size;
+
+	key.objectid = root->inode->i_ino;
+	btrfs_set_key_type(&key, BTRFS_ORPHAN_DIR_ITEM_KEY);
+	key.offset = btrfs_name_hash(name, name_len);
+	path = btrfs_alloc_path();
+	data_size = sizeof(*dir_item) + name_len;
+	dir_item = insert_with_overflow(trans, root, path, &key,
+					data_size, name, name_len);
+	if (IS_ERR(dir_item)) {
+		ret = PTR_ERR(dir_item);
+		if (ret == -EEXIST)
+			printk(KERN_ERR "trying to create an orphan dir on a"
+			       " root that already has one\n");
+		goto out;
+	}
+
+	leaf = path->nodes[0];
+	btrfs_cpu_key_to_disk(&disk_key, location);
+	btrfs_set_dir_item_key(leaf, dir_item, &disk_key);
+	btrfs_set_dir_type(leaf, dir_item, BTRFS_FT_ORPHAN_DIR);
+	btrfs_set_dir_name_len(leaf, dir_item, name_len);
+	btrfs_set_dir_data_len(leaf, dir_item, 0);
+	name_ptr = (unsigned long)(dir_item + 1);
+
+	write_extent_buffer(leaf, name, name_ptr, name_len);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+struct btrfs_dir_item *btrfs_lookup_orphan_dir_item(struct btrfs_trans_handle
+						    *trans,
+						    struct btrfs_root *root,
+						    struct btrfs_path *path,
+						    int mod)
+{
+	int ret;
+	struct btrfs_key key;
+	int ins_len = mod < 0 ? -1 : 0;
+	int cow = mod != 0;
+	struct btrfs_key found_key;
+	struct extent_buffer *leaf;
+
+	key.objectid = root->inode->i_ino;
+	btrfs_set_key_type(&key, BTRFS_ORPHAN_DIR_ITEM_KEY);
+	key.offset = 0;
+	ret = btrfs_search_slot(trans, root, &key, path, ins_len, cow);
+	if (ret < 0)
+		return ERR_PTR(ret);
+	if (ret > 0) {
+		if (path->slots[0] == 0)
+			return NULL;
+		path->slots[0]--;
+	}
+
+	leaf = path->nodes[0];
+	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+
+	if (found_key.objectid != root->inode->i_ino ||
+	    btrfs_key_type(&found_key) != BTRFS_ORPHAN_DIR_ITEM_KEY ||
+	    found_key.offset != key.offset)
+		return NULL;
+
+	return btrfs_match_dir_item_name(root, path, ".orphandir", 10);
 }
 
 struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
diff -r 99b12e2db0f8 disk-io.c
--- a/disk-io.c	Wed Jun 18 20:50:41 2008 -0400
+++ b/disk-io.c	Tue Jun 24 21:04:39 2008 -0400
@@ -701,8 +701,10 @@ static int __setup_root(u32 nodesize, u3
 			struct btrfs_fs_info *fs_info,
 			u64 objectid)
 {
+	printk(KERN_ERR "setting up root %p\n", root);
 	root->node = NULL;
 	root->inode = NULL;
+	root->orphan_dir = NULL;
 	root->commit_root = NULL;
 	root->sectorsize = sectorsize;
 	root->nodesize = nodesize;
@@ -720,6 +722,7 @@ static int __setup_root(u32 nodesize, u3
 	root->in_sysfs = 0;
 
 	INIT_LIST_HEAD(&root->dirty_list);
+	INIT_LIST_HEAD(&root->orphan_list);
 	memset(&root->root_key, 0, sizeof(root->root_key));
 	memset(&root->root_item, 0, sizeof(root->root_item));
 	memset(&root->defrag_progress, 0, sizeof(root->defrag_progress));
@@ -1515,6 +1518,8 @@ int btrfs_free_fs_root(struct btrfs_fs_i
 			  (unsigned long)root->root_key.objectid);
 	if (root->in_sysfs)
 		btrfs_sysfs_del_root(root);
+	if (root->orphan_dir)
+		iput(root->orphan_dir);
 	if (root->inode)
 		iput(root->inode);
 	if (root->node)
@@ -1603,6 +1608,7 @@ int close_ctree(struct btrfs_root *root)
 	btrfs_stop_workers(&fs_info->submit_workers);
 
 	iput(fs_info->btree_inode);
+
 #if 0
 	while(!list_empty(&fs_info->hashers)) {
 		struct btrfs_hasher *hasher;
diff -r 99b12e2db0f8 inode.c
--- a/inode.c	Wed Jun 18 20:50:41 2008 -0400
+++ b/inode.c	Tue Jun 24 21:04:39 2008 -0400
@@ -76,6 +76,11 @@ static unsigned char btrfs_type_by_mode[
 	[S_IFSOCK >> S_SHIFT]	= BTRFS_FT_SOCK,
 	[S_IFLNK >> S_SHIFT]	= BTRFS_FT_SYMLINK,
 };
+
+static inline u8 btrfs_inode_type(struct inode *inode)
+{
+	return btrfs_type_by_mode[(inode->i_mode & S_IFMT) >> S_SHIFT];
+}
 
 int btrfs_check_free_space(struct btrfs_root *root, u64 num_required,
 			   int for_del)
@@ -599,6 +604,130 @@ zeroit:
 	return -EIO;
 }
 
+/*
+ * Adds an unlinked/truncating inode to the hidden orphan dir for this root
+ * so that if something happens and the inode deletion/truncate does not
+ * complete we can pick it back up on the next mount or during the fsck
+ */
+int btrfs_orphan_add(struct btrfs_trans_handle *trans, struct inode *inode)
+{
+	struct btrfs_root *root;
+	struct inode *dir;
+	struct btrfs_key key;
+	char *name;
+	int ret = 0, name_len;
+
+	/* already on the orphan list, we're good */
+	if (!list_empty(&BTRFS_I(inode)->i_orphan))
+		goto out;
+
+	/* we're adding the inode to the orphan dir */
+	root = BTRFS_I(inode)->root;
+	dir = root->orphan_dir;
+
+	key.objectid = inode->i_ino;
+	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
+	key.offset = 0;
+
+	name_len = sizeof(u32)*2;
+	name = kzalloc(name_len, GFP_NOFS);
+	if (!name) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	snprintf(name, name_len, "%lx", inode->i_ino);
+
+	/*
+	 * we have to add a link to the orphan dir so we can pull it back up
+	 * on mount if we fail
+	 */
+	ret = btrfs_insert_dir_item(trans, root, name, name_len, dir->i_ino,
+				    &key, btrfs_inode_type(inode), 0);
+	if (ret)
+		goto out_free;
+
+	/* update orphan dir */
+	dir->i_size += name_len * 2;
+	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+	ret = btrfs_update_inode(trans, root, dir);
+	if (ret)
+		goto out_free;
+
+	list_add(&BTRFS_I(inode)->i_orphan, &root->orphan_list);
+
+out_free:
+	kfree(name);
+out:
+	return ret;
+}
+
+/*
+ * We have done the truncate/delete so we can go ahead and remove this inode
+ * from the orphan list.
+ *
+ * If del_backref is 1 we need to remove the inode reference to the orphan dir.
+ * btrfs_delete_inode will remove the inode ref, so we don't need to remove it
+ * here, but truncate doesn't do that so you have to remove the ref.
+ */
+int btrfs_orphan_del(struct btrfs_trans_handle *trans, struct inode *inode)
+{
+	struct btrfs_root *root;
+	struct inode *dir;
+	struct btrfs_path *path;
+	struct btrfs_dir_item *di;
+	struct extent_buffer *leaf;
+	char *name;
+	int ret = 0, name_len;
+
+	if (list_empty(&BTRFS_I(inode)->i_orphan))
+		goto out;
+
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	root = BTRFS_I(inode)->root;
+	dir = root->orphan_dir;
+
+	name_len = sizeof(u32)*2;
+	name = kzalloc(name_len, GFP_NOFS);
+	if (!name) {
+		ret = -ENOMEM;
+		btrfs_free_path(path);
+		goto out;
+	}
+
+	snprintf(name, name_len, "%lx", inode->i_ino);
+
+	di = btrfs_lookup_dir_item(trans, root, path, dir->i_ino, name,
+				   name_len, -1);
+	if (IS_ERR(di)) {
+		ret = PTR_ERR(di);
+		goto out_free;
+	}
+	if (!di) {
+		ret = -ENOENT;
+		printk(KERN_ERR "btrfs: could not find orphan record for inode"
+		       " %lu\n", inode->i_ino);
+		goto out_free;
+	}
+	leaf = path->nodes[0];
+	ret = btrfs_delete_one_dir_name(trans, root, path, di);
+	if (ret)
+		goto out_free;
+
+	list_del_init(&BTRFS_I(inode)->i_orphan);
+
+out_free:
+	kfree(name);
+	btrfs_free_path(path);
+out:
+	return ret;
+}
+
 void btrfs_read_locked_inode(struct inode *inode)
 {
 	struct btrfs_path *path;
@@ -918,6 +1047,9 @@ fail:
  *
  * csum items that cross the new i_size are truncated to the new size
  * as well.
+ *
+ * min_type is the minimum key type to truncate down to.  If set to 0, this
+ * will kill all the items on this inode, including the INODE_ITEM_KEY.
  */
 static int btrfs_truncate_in_trans(struct btrfs_trans_handle *trans,
 				   struct btrfs_root *root,
@@ -1805,11 +1937,6 @@ fail:
 	return ERR_PTR(ret);
 }
 
-static inline u8 btrfs_inode_type(struct inode *inode)
-{
-	return btrfs_type_by_mode[(inode->i_mode & S_IFMT) >> S_SHIFT];
-}
-
 static int btrfs_add_link(struct btrfs_trans_handle *trans,
 			    struct dentry *dentry, struct inode *inode,
 			    int add_backref)
@@ -1826,7 +1953,7 @@ static int btrfs_add_link(struct btrfs_t
 	ret = btrfs_insert_dir_item(trans, root,
 				    dentry->d_name.name, dentry->d_name.len,
 				    dentry->d_parent->d_inode->i_ino,
-				    &key, btrfs_inode_type(inode));
+				    &key, btrfs_inode_type(inode), 1);
 	if (ret == 0) {
 		if (add_backref) {
 			ret = btrfs_insert_inode_ref(trans, root,
@@ -2127,6 +2254,137 @@ out_unlock:
 	btrfs_btree_balance_dirty(root, nr);
 	btrfs_throttle(root);
 	return err;
+}
+
+static struct inode *btrfs_create_orphan_dir(struct btrfs_root *root)
+{
+	struct inode *inode = NULL;
+	struct inode *dir = root->inode;
+	struct btrfs_trans_handle *trans;
+	struct btrfs_key key;
+	int err = 0, drop_on_err = 0;
+	u64 objectid = 0;
+	unsigned long nr = 1;
+
+	mutex_lock(&root->fs_info->fs_mutex);
+	err = btrfs_check_free_space(root, 1, 0);
+	if (err)
+		goto out_unlock;
+
+	trans = btrfs_start_transaction(root, 1);
+	btrfs_set_trans_block_group(trans, dir);
+
+	if (IS_ERR(trans)) {
+		err = PTR_ERR(trans);
+		goto out_unlock;
+	}
+
+	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
+	if (err) {
+		err = -ENOSPC;
+		goto out_unlock;
+	}
+
+	inode = btrfs_new_inode(trans, root, ".orphandir", 10, dir->i_ino,
+				objectid, BTRFS_I(dir)->block_group,
+				S_IFDIR | 700);
+	if (IS_ERR(inode))
+		goto out_fail;
+
+	drop_on_err = 1;
+	btrfs_set_trans_block_group(trans, inode);
+
+	inode->i_size = 0;
+	err = btrfs_update_inode(trans, root, inode);
+	if (err)
+		goto out_fail;
+
+	/*
+	 * since this is a hidden dir we need to do something slightly differnt
+	 * from btrfs_add_link
+	 */
+	key.objectid = inode->i_ino;
+	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
+	key.offset = 0;
+
+	err = btrfs_insert_orphan_dir_item(trans, root, &key);
+	if (err)
+		goto out_fail;
+
+	drop_on_err = 0;
+	dir->i_sb->s_dirt = 1;
+	btrfs_update_inode_block_group(trans, inode);
+	btrfs_update_inode_block_group(trans, dir);
+
+out_fail:
+	nr = trans->blocks_used;
+	btrfs_end_transaction(trans, root);
+
+out_unlock:
+	mutex_unlock(&root->fs_info->fs_mutex);
+	if (drop_on_err)
+		iput(inode);
+	btrfs_btree_balance_dirty(root, nr);
+	btrfs_throttle(root);
+
+	if (err)
+		inode = ERR_PTR(err);
+
+	return inode;
+}
+
+struct inode *btrfs_lookup_orphan_dir(struct btrfs_root *root)
+{
+	struct inode *inode;
+	struct inode *dir = root->inode;
+	struct btrfs_path *path;
+	struct btrfs_dir_item *di;
+	struct btrfs_key location;
+	int err;
+
+	BUG_ON(!root);
+
+	path = btrfs_alloc_path();
+	BUG_ON(!path);
+
+	mutex_lock(&root->fs_info->fs_mutex);
+	di = btrfs_lookup_orphan_dir_item(NULL, root, path, 0);
+
+	if (IS_ERR(di)) {
+		btrfs_free_path(path);
+		mutex_unlock(&root->fs_info->fs_mutex);
+
+		err = PTR_ERR(di);
+
+		if (err == -ENOENT)
+			inode = btrfs_create_orphan_dir(root);
+		else
+			inode = ERR_PTR(err);
+
+		return inode;
+	}
+
+	btrfs_dir_item_key_to_cpu(path->nodes[0], di, &location);
+
+	btrfs_free_path(path);
+	mutex_unlock(&root->fs_info->fs_mutex);
+
+	inode = btrfs_iget_locked(dir->i_sb, location.objectid, root);
+
+	if (!inode) {
+		inode = ERR_PTR(-EACCES);
+		goto out;
+	}
+
+	/* should technically always be true */
+	if (inode->i_state & I_NEW) {
+		BTRFS_I(inode)->root = root;
+		memcpy(&BTRFS_I(inode)->location, &location, sizeof(location));
+		btrfs_read_locked_inode(inode);
+		unlock_new_inode(inode);
+	}
+out:
+	return inode;
 }
 
 static int merge_extent_mapping(struct extent_map_tree *em_tree,
@@ -2737,6 +2995,7 @@ struct inode *btrfs_alloc_inode(struct s
 	ei->ordered_trans = 0;
 	ei->i_acl = BTRFS_ACL_NOT_CACHED;
 	ei->i_default_acl = BTRFS_ACL_NOT_CACHED;
+	INIT_LIST_HEAD(&ei->i_orphan);
 
 	return &ei->vfs_inode;
 }
@@ -2752,6 +3011,12 @@ void btrfs_destroy_inode(struct inode *i
 	if (BTRFS_I(inode)->i_default_acl &&
 	    BTRFS_I(inode)->i_default_acl != BTRFS_ACL_NOT_CACHED)
 		posix_acl_release(BTRFS_I(inode)->i_default_acl);
+
+	if (!list_empty(&BTRFS_I(inode)->i_orphan)) {
+		printk(KERN_ERR "BTRFS: inode %p: inode still on the orphan"
+		       " list\n", BTRFS_I(inode));
+		dump_stack();
+	}
 
 	btrfs_drop_extent_cache(inode, 0, (u64)-1);
 	kmem_cache_free(btrfs_inode_cachep, BTRFS_I(inode));
diff -r 99b12e2db0f8 ioctl.c
--- a/ioctl.c	Wed Jun 18 20:50:41 2008 -0400
+++ b/ioctl.c	Tue Jun 24 21:04:39 2008 -0400
@@ -128,7 +128,7 @@ static noinline int create_subvol(struct
 	dir = root->fs_info->sb->s_root->d_inode;
 	ret = btrfs_insert_dir_item(trans, root->fs_info->tree_root,
 				    name, namelen, dir->i_ino, &key,
-				    BTRFS_FT_DIR);
+				    BTRFS_FT_DIR, 0);
 	if (ret)
 		goto fail;
 
diff -r 99b12e2db0f8 super.c
--- a/super.c	Wed Jun 18 20:50:41 2008 -0400
+++ b/super.c	Tue Jun 24 21:04:39 2008 -0400
@@ -339,6 +339,7 @@ static int btrfs_fill_super(struct super
 		goto fail_close;
 	}
 
+
 	/* this does the super kobj at the same time */
 	err = btrfs_sysfs_add_super(tree_root->fs_info);
 	if (err)
@@ -467,6 +468,22 @@ static int btrfs_get_sb(struct file_syst
 		deactivate_super(s);
 		error = -ENXIO;
 		goto error;
+	}
+
+	/* we don't want to do orphan stuff on a rdonly fs */
+	if (!(s->s_flags & MS_RDONLY)) {
+		struct btrfs_root *tree_root = BTRFS_I(root->d_inode)->root;
+		struct inode *orphan_dir;
+
+		orphan_dir = btrfs_lookup_orphan_dir(tree_root);
+		if (IS_ERR(orphan_dir)) {
+			error = PTR_ERR(orphan_dir);
+			printk(KERN_ERR "error reading orphan dir: %d\n", error);
+			//goto error;
+		} else {
+			printk(KERN_ERR "setting orphan_dir for root %p\n", tree_root);
+			tree_root->orphan_dir = orphan_dir;
+		}
 	}
 
 	mnt->mnt_sb = s;
diff -r 99b12e2db0f8 transaction.c
--- a/transaction.c	Wed Jun 18 20:50:41 2008 -0400
+++ b/transaction.c	Tue Jun 24 21:04:39 2008 -0400
@@ -600,7 +600,7 @@ static noinline int create_pending_snaps
 	ret = btrfs_insert_dir_item(trans, root->fs_info->tree_root,
 				    pending->name, namelen,
 				    root->fs_info->sb->s_root->d_inode->i_ino,
-				    &key, BTRFS_FT_DIR);
+				    &key, BTRFS_FT_DIR, 0);
 
 	if (ret)
 		goto fail;
