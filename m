From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: create a unique inode number for all subvol entries
Date: Mon,  6 Dec 2010 15:48:42 -0500
Message-ID: <1291668522-7759-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently BTRFS has a problem where any subvol's will have the same inode
numbers as other files in the parent subvol.  This can cause problems with
userspace apps that depend on inode numbers being unique across a volume.  So in
order to solve this problem we need to do the following

1) Create an empty key with the fake inode number for the subvol.  This is a
place holder, since we determine which inode number to start with by searching
for the largest objectid in the subvolume, we need to make sure our fake inode
number isn't reused by somebody else.

2) Save our fake inode number in our dir item.  We can already store data in dir
items, so just store the inode number.  This is future proof since I explicitly
check for data_len == sizeof(u64), that way if we change what data gets put in
the dir item in the future, older kernels will be able to deal with it properly.
Also if an older kernel mounts with this change it will be ok.

Since subvols have their own st_dev it is ok for them to continue to have an
inode number of 256, but the inode returned by readdir needs to be unique to the
subvolume, so our fake inode number will be used for d_ino with readdir.  I
tested this with a program that Bruce Fields wrote to spit out the actual inode
numbers and the inode number returned by readdir

root@test1244 ~]# touch /mnt/btrfs-test/foo
[root@test1244 ~]# touch /mnt/btrfs-test/bar
[root@test1244 ~]# touch /mnt/btrfs-test/baz
[root@test1244 ~]# ./btrfs-progs-unstable/btrfs subvol create
/mnt/btrfs-test/subvol
Create subvolume '/mnt/btrfs-test/subvol'
[root@test1244 ~]# ./readdir-test /mnt/btrfs-test/
. 256 256
.. 256 139265
foo 257 257
bar 258 258
baz 259 259
subvol 260 256

Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/ctree.h       |    6 +++
 fs/btrfs/dir-item.c    |  113 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/inode.c       |   58 ++++++++++++++++++++++++-
 fs/btrfs/ioctl.c       |   13 ++++-
 fs/btrfs/transaction.c |   22 +++++++--
 5 files changed, 202 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 54e4252..ea0662e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -1161,6 +1161,8 @@ struct btrfs_root {
 #define BTRFS_DIR_LOG_INDEX_KEY 72
 #define BTRFS_DIR_ITEM_KEY	84
 #define BTRFS_DIR_INDEX_KEY	96
+#define BTRFS_DIR_SUBVOL_KEY	97
+
 /*
  * extent data is for file data
  */
@@ -2320,6 +2322,10 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root, const char *name,
 			  int name_len, u64 dir,
 			  struct btrfs_key *location, u8 type, u64 index);
+int btrfs_insert_subvol_dir_item(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root, const char *name,
+				 int name_len, u64 dir, u64 ino,
+				 struct btrfs_key *location, u64 index);
 struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
 					     struct btrfs_path *path, u64 dir,
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index f0cad5a..95d498f 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -116,6 +116,119 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+/**
+ * btrfs_insert_subvol_dir_item - setup the dir items for a subvol
+ *
+ * @trans: transaction handle
+ * @root: the root of the parent subvol
+ * @name: name of the subvol
+ * @name_len: the length of the name
+ * @dir: the objectid of the parent directory
+ * @ino: the unique inode number for the parent directory
+ * @key: the key that the items will point to
+ * @index: the dir index for readdir purposes
+ *
+ * Creates the dir item/dir index pair for the directory containing the subvol.
+ * This also creates a blank key to hold the made up inode number for the subvol
+ * in order to give us a unique to the parent subvol inode number.
+ */
+int btrfs_insert_subvol_dir_item(struct btrfs_trans_handle *trans,
+				 struct btrfs_root *root, const char *name,
+				 int name_len, u64 dir, u64 ino,
+				 struct btrfs_key *location, u64 index)
+{
+	int ret = 0;
+	int ret2 = 0;
+	struct btrfs_path *path;
+	struct btrfs_dir_item *dir_item;
+	struct extent_buffer *leaf;
+	unsigned long name_ptr;
+	unsigned long ino_ptr;
+	struct btrfs_key key;
+	struct btrfs_disk_key disk_key;
+	u32 data_size;
+	u8 type = BTRFS_FT_DIR;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	path->leave_spinning = 1;
+
+	key.objectid = ino;
+	key.type = BTRFS_DIR_SUBVOL_KEY;
+	key.offset = location->objectid;
+
+	ret = btrfs_insert_empty_item(trans, root, path, &key, 0);
+	if (ret)
+		goto out;
+
+	btrfs_release_path(root, path);
+
+	key.objectid = dir;
+	btrfs_set_key_type(&key, BTRFS_DIR_ITEM_KEY);
+	key.offset = btrfs_name_hash(name, name_len);
+
+	data_size = sizeof(*dir_item) + name_len + sizeof(u64);
+	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
+					name, name_len);
+	if (IS_ERR(dir_item)) {
+		ret = PTR_ERR(dir_item);
+		if (ret == -EEXIST)
+			goto second_insert;
+		goto out;
+	}
+
+	leaf = path->nodes[0];
+	btrfs_cpu_key_to_disk(&disk_key, location);
+	btrfs_set_dir_item_key(leaf, dir_item, &disk_key);
+	btrfs_set_dir_type(leaf, dir_item, type);
+	btrfs_set_dir_data_len(leaf, dir_item, sizeof(u64));
+	btrfs_set_dir_name_len(leaf, dir_item, name_len);
+	btrfs_set_dir_transid(leaf, dir_item, trans->transid);
+	name_ptr = (unsigned long)(dir_item + 1);
+	ino_ptr = name_ptr + name_len;
+
+	write_extent_buffer(leaf, name, name_ptr, name_len);
+	write_extent_buffer(leaf, &ino, ino_ptr, sizeof(u64));
+	btrfs_mark_buffer_dirty(leaf);
+
+second_insert:
+	/* FIXME, use some real flag for selecting the extra index */
+	if (root == root->fs_info->tree_root) {
+		ret = 0;
+		goto out;
+	}
+	btrfs_release_path(root, path);
+
+	btrfs_set_key_type(&key, BTRFS_DIR_INDEX_KEY);
+	key.offset = index;
+	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
+					name, name_len);
+	if (IS_ERR(dir_item)) {
+		ret2 = PTR_ERR(dir_item);
+		goto out;
+	}
+	leaf = path->nodes[0];
+	btrfs_cpu_key_to_disk(&disk_key, location);
+	btrfs_set_dir_item_key(leaf, dir_item, &disk_key);
+	btrfs_set_dir_type(leaf, dir_item, type);
+	btrfs_set_dir_data_len(leaf, dir_item, sizeof(u64));
+	btrfs_set_dir_name_len(leaf, dir_item, name_len);
+	btrfs_set_dir_transid(leaf, dir_item, trans->transid);
+	name_ptr = (unsigned long)(dir_item + 1);
+	ino_ptr = name_ptr + name_len;
+	write_extent_buffer(leaf, name, name_ptr, name_len);
+	write_extent_buffer(leaf, &ino, ino_ptr, sizeof(u64));
+	btrfs_mark_buffer_dirty(leaf);
+out:
+	btrfs_free_path(path);
+	if (ret)
+		return ret;
+	if (ret2)
+		return ret2;
+	return 0;
+}
+
 /*
  * insert a directory item in the tree, doing all the magic for
  * both indexes. 'dir' indicates which objectid to insert it into,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a6a3e2f..463f816 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2917,6 +2917,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	struct btrfs_dir_item *di;
 	struct btrfs_key key;
 	u64 index;
+	u64 parent_root_ino = 0;
 	int ret;
 
 	path = btrfs_alloc_path();
@@ -2928,12 +2929,48 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	BUG_ON(!di || IS_ERR(di));
 
 	leaf = path->nodes[0];
+
+	/*
+	 * This subvol has a fake inode number associated with it, make sure we
+	 * get it and delete it.
+	 */
+	if (btrfs_dir_data_len(leaf, di) == sizeof(u64)) {
+		unsigned long data_ptr;
+
+		data_ptr = (unsigned long)(di + 1) + name_len;
+		read_extent_buffer(leaf, &parent_root_ino, data_ptr,
+				   sizeof(u64));
+	}
+
 	btrfs_dir_item_key_to_cpu(leaf, di, &key);
 	WARN_ON(key.type != BTRFS_ROOT_ITEM_KEY || key.objectid != objectid);
 	ret = btrfs_delete_one_dir_name(trans, root, path, di);
 	BUG_ON(ret);
 	btrfs_release_path(root, path);
 
+	/* Delete the fake ino place holder */
+	if (parent_root_ino != 0) {
+		key.objectid = parent_root_ino;
+		key.type = BTRFS_DIR_SUBVOL_KEY;
+		key.offset = objectid;
+
+		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+		if (ret < 0) {
+			btrfs_free_path(path);
+			return ret;
+		} else if (ret > 0) {
+			WARN_ON(1);
+			btrfs_free_path(path);
+			return -ENOENT;
+		}
+		ret = btrfs_del_item(trans, root, path);
+		if (ret) {
+			btrfs_free_path(path);
+			return ret;
+		}
+		btrfs_release_path(root, path);
+	}
+
 	ret = btrfs_del_root_ref(trans, root->fs_info->tree_root,
 				 objectid, root->root_key.objectid,
 				 dir->i_ino, &index, name, name_len);
@@ -4254,6 +4291,7 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 
 		while (di_cur < di_total) {
 			struct btrfs_key location;
+			u64 ino;
 
 			name_len = btrfs_dir_name_len(leaf, di);
 			if (name_len <= sizeof(tmp_name)) {
@@ -4279,9 +4317,25 @@ static int btrfs_real_readdir(struct file *filp, void *dirent,
 				over = 0;
 				goto skip;
 			}
+
+			ino = location.objectid;
+
+			/*
+			 * If this is a subvol, check to see if the data len is
+			 * the size of u64, if so it means we have a unique
+			 * inode number for this subvol and we need to use that
+			 * instead.
+			 */
+			if (location.type == BTRFS_ROOT_ITEM_KEY &&
+			    btrfs_dir_data_len(leaf, di) == sizeof(u64)) {
+				unsigned long data_ptr;
+
+				data_ptr = (unsigned long)(di + 1) + name_len;
+				read_extent_buffer(leaf, &ino, data_ptr,
+						   sizeof(u64));
+			}
 			over = filldir(dirent, name_ptr, name_len,
-				       found_key.offset, location.objectid,
-				       d_type);
+				       found_key.offset, ino, d_type);
 
 skip:
 			if (name_ptr != tmp_name)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f1c9bb4..460ac1e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -238,6 +238,7 @@ static noinline int create_subvol(struct btrfs_root *root,
 	int ret;
 	int err;
 	u64 objectid;
+	u64 parent_subvol_ino;
 	u64 new_dirid = BTRFS_FIRST_FREE_OBJECTID;
 	u64 index = 0;
 
@@ -248,6 +249,12 @@ static noinline int create_subvol(struct btrfs_root *root,
 		return ret;
 	}
 
+	ret = btrfs_find_free_objectid(NULL, root, 0, &parent_subvol_ino);
+	if (ret) {
+		dput(parent);
+		return ret;
+	}
+
 	dir = parent->d_inode;
 
 	/*
@@ -329,9 +336,9 @@ static noinline int create_subvol(struct btrfs_root *root,
 	ret = btrfs_set_inode_index(dir, &index);
 	BUG_ON(ret);
 
-	ret = btrfs_insert_dir_item(trans, root,
-				    name, namelen, dir->i_ino, &key,
-				    BTRFS_FT_DIR, index);
+	ret = btrfs_insert_subvol_dir_item(trans, root, name, namelen,
+					   dir->i_ino, parent_subvol_ino,
+					   &key, index);
 	if (ret)
 		goto fail;
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f50e931..50b1335 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -910,6 +910,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	u64 to_reserve = 0;
 	u64 index = 0;
 	u64 objectid;
+	u64 parent_subvol_ino;
 
 	new_root_item = kmalloc(sizeof(*new_root_item), GFP_NOFS);
 	if (!new_root_item) {
@@ -947,16 +948,27 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	parent_root = BTRFS_I(parent_inode)->root;
 	record_root_in_trans(trans, parent_root);
 
+	ret = btrfs_find_free_objectid(trans, parent_root, 0,
+				       &parent_subvol_ino);
+	if (ret) {
+		pending->error = ret;
+		goto fail;
+	}
+
 	/*
 	 * insert the directory item
 	 */
 	ret = btrfs_set_inode_index(parent_inode, &index);
 	BUG_ON(ret);
-	ret = btrfs_insert_dir_item(trans, parent_root,
-				dentry->d_name.name, dentry->d_name.len,
-				parent_inode->i_ino, &key,
-				BTRFS_FT_DIR, index);
-	BUG_ON(ret);
+	ret = btrfs_insert_subvol_dir_item(trans, parent_root,
+					   dentry->d_name.name,
+					   dentry->d_name.len,
+					   parent_inode->i_ino,
+					   parent_subvol_ino, &key, index);
+	if (ret) {
+		pending->error = ret;
+		goto fail;
+	}
 
 	btrfs_i_size_write(parent_inode, parent_inode->i_size +
 					 dentry->d_name.len * 2);
-- 
1.6.6.1

