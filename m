From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH V6 3/3] btrfs: delay to insert the initial inode
Date: Fri, 22 Apr 2011 18:12:24 +0800
Message-ID: <4DB15488.50005@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Since we have implemented the delayed update of the inode, we can also
delayed to insert the initial inode, then we can merge the inode update
and the initial inode insertions to one insertion.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/delayed-inode.c |   18 +++++++++--
 fs/btrfs/delayed-inode.h |    8 ++++-
 fs/btrfs/inode.c         |   74 +++++++++++++++++++++++++++++++--------------
 3 files changed, 72 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 9548531..dd62b7b 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -979,12 +979,20 @@ static int btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 	key.objectid = node->inode_id;
 	btrfs_set_key_type(&key, BTRFS_INODE_ITEM_KEY);
 	key.offset = 0;
-	ret = btrfs_lookup_inode(trans, root, path, &key, 1);
+	if (node->inode_dirty == BTRFS_INODE_UPDATE) {
+		ret = btrfs_lookup_inode(trans, root, path, &key, 1);
+	} else if (node->inode_dirty == BTRFS_INODE_NEW)
+		ret = btrfs_insert_empty_item(trans, root, path, &key,
+					      sizeof(*inode_item));
+	else
+		BUG();
 	if (ret > 0) {
 		btrfs_release_path(root, path);
 		mutex_unlock(&node->mutex);
 		return -ENOENT;
 	} else if (ret < 0) {
+		WARN_ON(ret == -EEXIST && node->inode_dirty == BTRFS_INODE_NEW);
+		btrfs_release_path(root, path);
 		mutex_unlock(&node->mutex);
 		return ret;
 	}
@@ -1591,7 +1599,8 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 }
 
 int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root, struct inode *inode)
+			       struct btrfs_root *root, struct inode *inode,
+			       bool new_ino)
 {
 	struct btrfs_delayed_node *delayed_node;
 	int ret;
@@ -1614,7 +1623,10 @@ int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
 	BUG_ON(ret);
 
 	fill_stack_inode_item(trans, &delayed_node->inode_item, inode);
-	delayed_node->inode_dirty = 1;
+	if (new_ino)
+		delayed_node->inode_dirty = BTRFS_INODE_NEW;
+	else
+		delayed_node->inode_dirty = BTRFS_INODE_UPDATE;
 	delayed_node->count++;
 	atomic_inc(&root->fs_info->delayed_root->items);
 release_node:
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index eb7d240..79b009f 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -33,6 +33,9 @@
 #define BTRFS_DELAYED_INSERTION_ITEM	1
 #define BTRFS_DELAYED_DELETION_ITEM	2
 
+#define BTRFS_INODE_NEW		1
+#define BTRFS_INODE_UPDATE	2
+
 struct btrfs_delayed_root {
 	spinlock_t lock;
 	struct list_head node_list;
@@ -64,8 +67,8 @@ struct btrfs_delayed_node {
 	struct btrfs_inode_item inode_item;
 	atomic_t refs;
 	u64 index_cnt;
+	u8 inode_dirty;
 	bool in_list;
-	bool inode_dirty;
 	int count;
 };
 
@@ -119,7 +122,8 @@ void btrfs_kill_delayed_inode_items(struct inode *inode);
 
 
 int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
-			       struct btrfs_root *root, struct inode *inode);
+			       struct btrfs_root *root, struct inode *inode,
+			       bool new_ino);
 
 /* Used for drop dead root */
 void btrfs_kill_all_delayed_nodes(struct btrfs_root *root);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a79ff72..29671f3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2648,11 +2648,11 @@ noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
 	/*
 	 * If root is tree root, it means this inode is used to
 	 * store free space information. And these inodes are updated
-	 * when committing the transaction, so they needn't delaye to
+	 * when committing the transaction, so they needn't delayed to
 	 * be updated, or deadlock will occured.
 	 */
 	if (likely(root != root->fs_info->tree_root)) {
-		ret = btrfs_delayed_update_inode(trans, root, inode);
+		ret = btrfs_delayed_update_inode(trans, root, inode, false);
 		if (!ret)
 			btrfs_set_inode_last_trans(trans, inode);
 		return ret;
@@ -4578,6 +4578,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	BUG_ON(!path);
 
+	path->leave_spinning = 1;
+
 	inode = new_inode(root->fs_info->sb);
 	if (!inode) {
 		btrfs_free_path(path);
@@ -4612,32 +4614,58 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	BTRFS_I(inode)->block_group =
 			btrfs_find_block_group(root, 0, alloc_hint, owner);
 
-	key[0].objectid = objectid;
-	btrfs_set_key_type(&key[0], BTRFS_INODE_ITEM_KEY);
-	key[0].offset = 0;
-
-	key[1].objectid = objectid;
-	btrfs_set_key_type(&key[1], BTRFS_INODE_REF_KEY);
-	key[1].offset = ref_objectid;
-
-	sizes[0] = sizeof(struct btrfs_inode_item);
-	sizes[1] = name_len + sizeof(*ref);
-
-	path->leave_spinning = 1;
-	ret = btrfs_insert_empty_items(trans, root, path, key, sizes, 2);
-	if (ret != 0)
-		goto fail;
-
 	inode_init_owner(inode, dir, mode);
 	inode->i_ino = objectid;
 	inode_set_bytes(inode, 0);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
-	inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
-				  struct btrfs_inode_item);
-	fill_inode_item(trans, path->nodes[0], inode_item, inode);
+	/*
+	 * If root is not tree root, the inode is a inode of file or directory,
+	 * which we can delay to insert.
+	 */
+	if (root == root->fs_info->tree_root) {
+		key[0].objectid = objectid;
+		btrfs_set_key_type(&key[0], BTRFS_INODE_ITEM_KEY);
+		key[0].offset = 0;
+
+		key[1].objectid = objectid;
+		btrfs_set_key_type(&key[1], BTRFS_INODE_REF_KEY);
+		key[1].offset = ref_objectid;
+
+		sizes[0] = sizeof(struct btrfs_inode_item);
+		sizes[1] = name_len + sizeof(*ref);
+
+		ret = btrfs_insert_empty_items(trans, root, path, key, sizes,
+					       2);
+		if (ret != 0)
+			goto fail;
+
+		inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+					    struct btrfs_inode_item);
+		fill_inode_item(trans, path->nodes[0], inode_item, inode);
+
+		ref = btrfs_item_ptr(path->nodes[0], path->slots[0] + 1,
+				     struct btrfs_inode_ref);
+	} else {
+		ret = btrfs_delayed_update_inode(trans, root, inode, true);
+		if (ret)
+			goto fail;
+
+		key[0].objectid = objectid;
+		btrfs_set_key_type(&key[0], BTRFS_INODE_REF_KEY);
+		key[0].offset = ref_objectid;
+
+		sizes[0] = name_len + sizeof(*ref);
+
+		ret = btrfs_insert_empty_item(trans, root, path, key, sizes[0]);
+		if (ret) {
+			btrfs_kill_delayed_inode_items(inode);
+			goto fail;
+		}
+
+		ref = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				     struct btrfs_inode_ref);
+	}
 
-	ref = btrfs_item_ptr(path->nodes[0], path->slots[0] + 1,
-			     struct btrfs_inode_ref);
 	btrfs_set_inode_ref_name_len(path->nodes[0], ref, name_len);
 	btrfs_set_inode_ref_index(path->nodes[0], ref, *index);
 	ptr = (unsigned long)(ref + 1);
-- 
1.7.4
