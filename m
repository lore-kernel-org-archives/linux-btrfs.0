From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 1/2] Btrfs: kill location key of in-memory inode
Date: Thu, 16 Jun 2011 17:22:59 +0800
Message-ID: <1308216180-13132-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <t-itoh@jp.fujitsu.com>, <mfedyk@mikefedyk.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs's in-memory inode, there is a btrfs_key which has the structure:
- key.objectid : inode id
- key.type: BTRFS_INODE_ITEM_KEY
- key.offset: 0 or -1ULL

however, we only use key.objectid to search, to check or something else,
and to reduce in-memory inode size I just keep what is valuable.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h |   10 ++++------
 fs/btrfs/disk-io.c     |    3 +--
 fs/btrfs/export.c      |    2 +-
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/inode.c       |   48 +++++++++++++++++++++++++++++-------------------
 5 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 52d7eca..31337df 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -29,11 +29,6 @@ struct btrfs_inode {
 	/* which subvolume this inode belongs to */
 	struct btrfs_root *root;
 
-	/* key used to find this inode on disk.  This is used by the code
-	 * to read in roots of subvolumes
-	 */
-	struct btrfs_key location;
-
 	/* the extent_tree has caches of all the extent mappings to disk */
 	struct extent_map_tree extent_tree;
 
@@ -72,6 +67,9 @@ struct btrfs_inode {
 	/* the space_info for where this inode's data allocations are done */
 	struct btrfs_space_info *space_info;
 
+	/* full 64 bit inode number */
+	u64 inode_id;
+
 	/* full 64 bit generation number, struct vfs_inode doesn't have a big
 	 * enough field for this.
 	 */
@@ -171,7 +169,7 @@ static inline struct btrfs_inode *BTRFS_I(struct inode *inode)
 
 static inline u64 btrfs_ino(struct inode *inode)
 {
-	u64 ino = BTRFS_I(inode)->location.objectid;
+	u64 ino = BTRFS_I(inode)->inode_id;
 
 	if (ino <= BTRFS_FIRST_FREE_OBJECTID)
 		ino = inode->i_ino;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a203d36..5d6bbb9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1693,9 +1693,8 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	BTRFS_I(fs_info->btree_inode)->io_tree.ops = &btree_extent_io_ops;
 
+	BTRFS_I(fs_info->btree_inode)->inode_id = BTRFS_BTREE_INODE_OBJECTID;
 	BTRFS_I(fs_info->btree_inode)->root = tree_root;
-	memset(&BTRFS_I(fs_info->btree_inode)->location, 0,
-	       sizeof(struct btrfs_key));
 	BTRFS_I(fs_info->btree_inode)->dummy_inode = 1;
 	insert_inode_hash(fs_info->btree_inode);
 
diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 1b8dc33..cdd3a84 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -43,7 +43,7 @@ static int btrfs_encode_fh(struct dentry *dentry, u32 *fh, int *max_len,
 		spin_lock(&dentry->d_lock);
 
 		parent = dentry->d_parent->d_inode;
-		fid->parent_objectid = BTRFS_I(parent)->location.objectid;
+		fid->parent_objectid = btrfs_ino(parent);
 		fid->parent_gen = parent->i_generation;
 		parent_root_id = BTRFS_I(parent)->root->objectid;
 
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5b9b6b6..3a1f8ee 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3037,7 +3037,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 	bytes = (bytes + root->sectorsize - 1) & ~((u64)root->sectorsize - 1);
 
 	if (root == root->fs_info->tree_root ||
-	    BTRFS_I(inode)->location.objectid == BTRFS_FREE_INO_OBJECTID) {
+	    BTRFS_I(inode)->inode_id == BTRFS_FREE_INO_OBJECTID) {
 		alloc_chunk = 0;
 		committed = 1;
 	}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 02ff4a1..e01a084 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -754,7 +754,7 @@ static inline bool is_free_space_inode(struct btrfs_root *root,
 				       struct inode *inode)
 {
 	if (root == root->fs_info->tree_root ||
-	    BTRFS_I(inode)->location.objectid == BTRFS_FREE_INO_OBJECTID)
+	    BTRFS_I(inode)->inode_id == BTRFS_FREE_INO_OBJECTID)
 		return true;
 	return false;
 }
@@ -2513,7 +2513,10 @@ static void btrfs_read_locked_inode(struct inode *inode)
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 	path->leave_spinning = 1;
-	memcpy(&location, &BTRFS_I(inode)->location, sizeof(location));
+
+	location.objectid = btrfs_ino(inode);
+	location.offset = 0;
+	btrfs_set_key_type(&location, BTRFS_INODE_ITEM_KEY);
 
 	ret = btrfs_lookup_inode(NULL, root, path, &location, 0);
 	if (ret)
@@ -2667,6 +2670,7 @@ noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
 	struct btrfs_inode_item *inode_item;
 	struct btrfs_path *path;
 	struct extent_buffer *leaf;
+	struct btrfs_key location;
 	int ret;
 
 	/*
@@ -2687,8 +2691,12 @@ noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	path->leave_spinning = 1;
-	ret = btrfs_lookup_inode(trans, root, path, &BTRFS_I(inode)->location,
-				 1);
+
+	location.objectid = btrfs_ino(inode);
+	location.offset = 0;
+	btrfs_set_key_type(&location, BTRFS_INODE_ITEM_KEY);
+
+	ret = btrfs_lookup_inode(trans, root, path, &location, 1);
 	if (ret) {
 		if (ret > 0)
 			ret = -ENOENT;
@@ -2839,6 +2847,7 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	struct btrfs_path *path;
 	struct btrfs_inode_ref *ref;
 	struct btrfs_dir_item *di;
+	struct btrfs_key location;
 	struct inode *inode = dentry->d_inode;
 	u64 index;
 	int check_link = 1;
@@ -2880,8 +2889,11 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	path->skip_locking = 1;
 	path->search_commit_root = 1;
 
-	ret = btrfs_lookup_inode(trans, root, path,
-				&BTRFS_I(dir)->location, 0);
+	location.objectid = btrfs_ino(dir);
+	location.offset = 0;
+	btrfs_set_key_type(&location, BTRFS_INODE_ITEM_KEY);
+
+	ret = btrfs_lookup_inode(trans, root, path, &location, 0);
 	if (ret < 0) {
 		err = ret;
 		goto out;
@@ -2894,8 +2906,11 @@ static struct btrfs_trans_handle *__unlink_start_trans(struct inode *dir,
 	}
 	btrfs_release_path(path);
 
-	ret = btrfs_lookup_inode(trans, root, path,
-				&BTRFS_I(inode)->location, 0);
+	location.objectid = btrfs_ino(inode);
+	location.offset = 0;
+	btrfs_set_key_type(&location, BTRFS_INODE_ITEM_KEY);
+
+	ret = btrfs_lookup_inode(trans, root, path, &location, 0);
 	if (ret < 0) {
 		err = ret;
 		goto out;
@@ -3097,7 +3112,7 @@ static int btrfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	if (unlikely(btrfs_ino(inode) == BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
 		err = btrfs_unlink_subvol(trans, root, dir,
-					  BTRFS_I(inode)->location.objectid,
+					  BTRFS_I(inode)->inode_id,
 					  dentry->d_name.name,
 					  dentry->d_name.len);
 		goto out;
@@ -3331,7 +3346,7 @@ delete:
 		if (path->slots[0] == 0 ||
 		    path->slots[0] != pending_del_slot) {
 			if (root->ref_cows &&
-			    BTRFS_I(inode)->location.objectid !=
+			    BTRFS_I(inode)->inode_id !=
 						BTRFS_FREE_INO_OBJECTID) {
 				err = -EAGAIN;
 				goto out;
@@ -3965,7 +3980,7 @@ struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 
 	if (inode->i_state & I_NEW) {
 		BTRFS_I(inode)->root = root;
-		memcpy(&BTRFS_I(inode)->location, location, sizeof(*location));
+		BTRFS_I(inode)->inode_id = location->objectid;
 		btrfs_read_locked_inode(inode);
 		inode_tree_add(inode);
 		unlock_new_inode(inode);
@@ -3986,7 +4001,7 @@ static struct inode *new_simple_dir(struct super_block *s,
 		return ERR_PTR(-ENOMEM);
 
 	BTRFS_I(inode)->root = root;
-	memcpy(&BTRFS_I(inode)->location, key, sizeof(*key));
+	BTRFS_I(inode)->inode_id = key->objectid;
 	BTRFS_I(inode)->dummy_inode = 1;
 
 	inode->i_ino = BTRFS_EMPTY_SUBVOL_DIR_OBJECTID;
@@ -4417,7 +4432,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 {
 	struct inode *inode;
 	struct btrfs_inode_item *inode_item;
-	struct btrfs_key *location;
 	struct btrfs_path *path;
 	struct btrfs_inode_ref *ref;
 	struct btrfs_key key[2];
@@ -4461,6 +4475,7 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	BTRFS_I(inode)->generation = trans->transid;
 	inode->i_generation = BTRFS_I(inode)->generation;
 	btrfs_set_inode_space_info(root, inode);
+	BTRFS_I(inode)->inode_id = objectid;
 
 	if (mode & S_IFDIR)
 		owner = 0;
@@ -4500,11 +4515,6 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	btrfs_free_path(path);
 
-	location = &BTRFS_I(inode)->location;
-	location->objectid = objectid;
-	location->offset = 0;
-	btrfs_set_key_type(location, BTRFS_INODE_ITEM_KEY);
-
 	btrfs_inherit_iflags(inode, dir);
 
 	if ((mode & S_IFREG)) {
@@ -7029,7 +7039,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 		new_inode->i_ctime = CURRENT_TIME;
 		if (unlikely(btrfs_ino(new_inode) ==
 			     BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
-			root_objectid = BTRFS_I(new_inode)->location.objectid;
+			root_objectid = BTRFS_I(new_inode)->inode_id;
 			ret = btrfs_unlink_subvol(trans, dest, new_dir,
 						root_objectid,
 						new_dentry->d_name.name,
-- 
1.6.5.2

