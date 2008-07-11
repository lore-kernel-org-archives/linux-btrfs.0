From: Josef Bacik <jbacik@redhat.com>
Subject: [PATCH] change how we index files for readdir
Date: Fri, 11 Jul 2008 12:54:37 -0400
Message-ID: <20080711165436.GB5027@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

This patch changes the directory indexing stuff to use an artificial counter
instead of the inode number.  The index for a particular inode is stored
directly in the inode so we can find the directory index item at unlink time and
remove it.  I added an index to the btrfs_inode for the index number, and
index_cnt which is the counter for the directory.  Tested it to make sure it
didn't blow up the box, if everybody is ok with the way I did this I will run
some performance numbers, but I'm sure I did something stupid so I'll wait till
thats pointed out to do perf stuff :).  Thank you,

Signed-off-by: Josef Bacik <jbacik@redhat.com>


diff -r 297d128bb63d btrfs_inode.h
--- a/btrfs_inode.h	Fri Jul 11 15:09:39 2008 -0400
+++ b/btrfs_inode.h	Fri Jul 11 19:52:57 2008 -0400
@@ -47,6 +47,10 @@ struct btrfs_inode {
 	u64 last_trans;
 	u64 delalloc_bytes;
 	u32 flags;
+
+	/* directory indexing stuff */
+	u64 index_cnt;	/* the current index for this particular directory */
+	u64 index;	/* the index for this inode */
 };
 static inline struct btrfs_inode *BTRFS_I(struct inode *inode)
 {
diff -r 297d128bb63d ctree.h
--- a/ctree.h	Fri Jul 11 15:09:39 2008 -0400
+++ b/ctree.h	Fri Jul 11 19:52:57 2008 -0400
@@ -396,6 +396,7 @@ struct btrfs_inode_item {
 	__le64 rdev;
 	__le16 flags;
 	__le16 compat_flags;
+	__le64 index;
 	struct btrfs_timespec atime;
 	struct btrfs_timespec ctime;
 	struct btrfs_timespec mtime;
@@ -901,6 +902,7 @@ BTRFS_SETGET_FUNCS(inode_flags, struct b
 BTRFS_SETGET_FUNCS(inode_flags, struct btrfs_inode_item, flags, 16);
 BTRFS_SETGET_FUNCS(inode_compat_flags, struct btrfs_inode_item,
 		   compat_flags, 16);
+BTRFS_SETGET_FUNCS(inode_index, struct btrfs_inode_item, index, 64);
 
 static inline struct btrfs_timespec *
 btrfs_inode_atime(struct btrfs_inode_item *inode_item)
@@ -1502,7 +1504,7 @@ int btrfs_find_dead_roots(struct btrfs_r
 /* dir-item.c */
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 			  *root, const char *name, int name_len, u64 dir,
-			  struct btrfs_key *location, u8 type);
+			  struct btrfs_key *location, u8 type, u64 index);
 struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
 					     struct btrfs_path *path, u64 dir,
diff -r 297d128bb63d dir-item.c
--- a/dir-item.c	Fri Jul 11 15:09:39 2008 -0400
+++ b/dir-item.c	Fri Jul 11 19:52:57 2008 -0400
@@ -110,7 +110,7 @@ int btrfs_insert_xattr_item(struct btrfs
 
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 			  *root, const char *name, int name_len, u64 dir,
-			  struct btrfs_key *location, u8 type)
+			  struct btrfs_key *location, u8 type, u64 index)
 {
 	int ret = 0;
 	int ret2 = 0;
@@ -156,7 +156,7 @@ second_insert:
 	btrfs_release_path(root, path);
 
 	btrfs_set_key_type(&key, BTRFS_DIR_INDEX_KEY);
-	key.offset = location->objectid;
+	key.offset = index;
 	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
 					name, name_len);
 	if (IS_ERR(dir_item)) {
diff -r 297d128bb63d inode.c
--- a/inode.c	Fri Jul 11 15:09:39 2008 -0400
+++ b/inode.c	Fri Jul 11 19:52:57 2008 -0400
@@ -831,6 +831,9 @@ void btrfs_read_locked_inode(struct inod
 	inode->i_rdev = 0;
 	rdev = btrfs_inode_rdev(leaf, inode_item);
 
+	BTRFS_I(inode)->index_cnt = (u64)-1;
+	BTRFS_I(inode)->index = btrfs_inode_index(leaf, inode_item);
+
 	alloc_group_block = btrfs_inode_block_group(leaf, inode_item);
 	BTRFS_I(inode)->block_group = btrfs_lookup_block_group(root->fs_info,
 						       alloc_group_block);
@@ -903,6 +906,7 @@ static void fill_inode_item(struct exten
 	btrfs_set_inode_generation(leaf, item, inode->i_generation);
 	btrfs_set_inode_rdev(leaf, item, inode->i_rdev);
 	btrfs_set_inode_flags(leaf, item, BTRFS_I(inode)->flags);
+	btrfs_set_inode_index(leaf, item, BTRFS_I(inode)->index);
 	btrfs_set_inode_block_group(leaf, item,
 				    BTRFS_I(inode)->block_group->key.objectid);
 }
@@ -952,6 +956,7 @@ static int btrfs_unlink_trans(struct btr
 	struct extent_buffer *leaf;
 	struct btrfs_dir_item *di;
 	struct btrfs_key key;
+	struct inode *inode = dentry->d_inode;
 
 	path = btrfs_alloc_path();
 	if (!path) {
@@ -977,7 +982,8 @@ static int btrfs_unlink_trans(struct btr
 	btrfs_release_path(root, path);
 
 	di = btrfs_lookup_dir_index_item(trans, root, path, dir->i_ino,
-					 key.objectid, name, name_len, -1);
+					 BTRFS_I(inode)->index, name,
+					 name_len, -1);
 	if (IS_ERR(di)) {
 		ret = PTR_ERR(di);
 		goto err;
@@ -1603,6 +1609,7 @@ static int btrfs_init_locked_inode(struc
 	inode->i_ino = args->ino;
 	BTRFS_I(inode)->root = args->root;
 	BTRFS_I(inode)->delalloc_bytes = 0;
+	BTRFS_I(inode)->index_cnt = (u64)-1;
 	extent_map_tree_init(&BTRFS_I(inode)->extent_tree, GFP_NOFS);
 	extent_io_tree_init(&BTRFS_I(inode)->io_tree,
 			     inode->i_mapping, GFP_NOFS);
@@ -1988,6 +1995,58 @@ static inline u8 btrfs_inode_type(struct
 	return btrfs_type_by_mode[(inode->i_mode & S_IFMT) >> S_SHIFT];
 }
 
+static void btrfs_get_index_count(struct inode *inode)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_key key, found_key;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+
+	int ret;
+
+	key.objectid = inode->i_ino;
+	btrfs_set_key_type(&key, BTRFS_DIR_INDEX_KEY);
+	key.offset = (u64)-1;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret  < 0)
+		goto out;
+
+	/* FIXME: we should be able to handle this */
+	if (ret == 0)
+		goto out;
+
+	/*
+	 * MAGIC NUMBER EXPLANATION:
+	 * since we search a directory based on f_pos we have to start at 2
+	 * since '.' and '..' have f_pos of 0 and 1 respectively, so everybody
+	 * else has to start at 2
+	 */
+	if (path->slots[0] == 0) {
+		BTRFS_I(inode)->index_cnt = 2;
+		goto out;
+	}
+
+	path->slots[0]--;
+
+	leaf = path->nodes[0];
+	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+
+	if (found_key.objectid != inode->i_ino ||
+	    btrfs_key_type(&found_key) != BTRFS_DIR_INDEX_KEY) {
+		BTRFS_I(inode)->index_cnt = 2;
+		goto out;
+	}
+
+	BTRFS_I(inode)->index_cnt = found_key.offset + 1;
+out:
+	btrfs_free_path(path);
+}
+
 static int btrfs_add_link(struct btrfs_trans_handle *trans,
 			    struct dentry *dentry, struct inode *inode,
 			    int add_backref)
@@ -1995,16 +2054,20 @@ static int btrfs_add_link(struct btrfs_t
 	int ret;
 	struct btrfs_key key;
 	struct btrfs_root *root = BTRFS_I(dentry->d_parent->d_inode)->root;
-	struct inode *parent_inode;
+	struct inode *parent_inode = dentry->d_parent->d_inode;
 
 	key.objectid = inode->i_ino;
 	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
 	key.offset = 0;
 
+	if (BTRFS_I(parent_inode)->index_cnt == (u64)-1)
+		btrfs_get_index_count(parent_inode);
+
 	ret = btrfs_insert_dir_item(trans, root,
 				    dentry->d_name.name, dentry->d_name.len,
 				    dentry->d_parent->d_inode->i_ino,
-				    &key, btrfs_inode_type(inode));
+				    &key, btrfs_inode_type(inode),
+				    BTRFS_I(parent_inode)->index_cnt);
 	if (ret == 0) {
 		if (add_backref) {
 			ret = btrfs_insert_inode_ref(trans, root,
@@ -2013,11 +2076,15 @@ static int btrfs_add_link(struct btrfs_t
 					     inode->i_ino,
 					     dentry->d_parent->d_inode->i_ino);
 		}
-		parent_inode = dentry->d_parent->d_inode;
+		BTRFS_I(inode)->index = BTRFS_I(parent_inode)->index_cnt;
+
+		BTRFS_I(parent_inode)->index_cnt++;
 		parent_inode->i_size += dentry->d_name.len * 2;
 		parent_inode->i_mtime = parent_inode->i_ctime = CURRENT_TIME;
 		ret = btrfs_update_inode(trans, root,
 					 dentry->d_parent->d_inode);
+		if (!ret)
+			ret = btrfs_update_inode(trans, root, inode);
 	}
 	return ret;
 }
diff -r 297d128bb63d ioctl.c
--- a/ioctl.c	Fri Jul 11 15:09:39 2008 -0400
+++ b/ioctl.c	Fri Jul 11 19:52:57 2008 -0400
@@ -131,7 +131,7 @@ static noinline int create_subvol(struct
 	dir = root->fs_info->sb->s_root->d_inode;
 	ret = btrfs_insert_dir_item(trans, root->fs_info->tree_root,
 				    name, namelen, dir->i_ino, &key,
-				    BTRFS_FT_DIR);
+				    BTRFS_FT_DIR, 0);
 	if (ret)
 		goto fail;
 
diff -r 297d128bb63d transaction.c
--- a/transaction.c	Fri Jul 11 15:09:39 2008 -0400
+++ b/transaction.c	Fri Jul 11 19:52:57 2008 -0400
@@ -591,7 +591,7 @@ static noinline int create_pending_snaps
 	ret = btrfs_insert_dir_item(trans, root->fs_info->tree_root,
 				    pending->name, namelen,
 				    root->fs_info->sb->s_root->d_inode->i_ino,
-				    &key, BTRFS_FT_DIR);
+				    &key, BTRFS_FT_DIR, 0);
 
 	if (ret)
 		goto fail;
