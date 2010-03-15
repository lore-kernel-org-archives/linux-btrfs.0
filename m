From: Sage Weil <sage@newdream.net>
Subject: [PATCH] Btrfs: create snapshot references in same commit as snapshot
Date: Mon, 15 Mar 2010 10:27:13 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1003151025230.21714@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This creates the reference to a new snapshot in the same commit as the
snapshot itself.  This avoids the need for a second commit in order for a
snapshot to be persistent, and also avoids the problem of "leaking" a
new snapshot tree root if the host crashes before the second commit takes
place.

It is not at all clear to me why it wasn't always done this way.  If there
is still a reason for the two-stage {create,finish}_pending_snapshots()
approach I'm missing something!  :)

I've been running this for a couple weeks under pretty heavy usage (a few 
snapshots per minute) without obvious problems.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/transaction.c |   97 +++++++++++++++--------------------------------
 1 files changed, 31 insertions(+), 66 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 2d654c1..e75cc84 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -760,10 +760,17 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	struct btrfs_root_item *new_root_item;
 	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_root *root = pending->root;
+	struct btrfs_root *parent_root;
+	struct inode *parent_inode;
 	struct extent_buffer *tmp;
 	struct extent_buffer *old;
 	int ret;
 	u64 objectid;
+	int namelen;
+	u64 index = 0;
+
+	parent_inode = pending->dentry->d_parent->d_inode;
+	parent_root = BTRFS_I(parent_inode)->root;
 
 	new_root_item = kmalloc(sizeof(*new_root_item), GFP_NOFS);
 	if (!new_root_item) {
@@ -774,79 +781,59 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto fail;
 
-	record_root_in_trans(trans, root);
-	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
-	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
-
 	key.objectid = objectid;
 	/* record when the snapshot was created in key.offset */
 	key.offset = trans->transid;
 	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
 
-	old = btrfs_lock_root_node(root);
-	btrfs_cow_block(trans, root, old, NULL, 0, &old);
-	btrfs_set_lock_blocking(old);
-
-	btrfs_copy_root(trans, root, old, &tmp, objectid);
-	btrfs_tree_unlock(old);
-	free_extent_buffer(old);
-
-	btrfs_set_root_node(new_root_item, tmp);
-	ret = btrfs_insert_root(trans, root->fs_info->tree_root, &key,
-				new_root_item);
-	btrfs_tree_unlock(tmp);
-	free_extent_buffer(tmp);
-	if (ret)
-		goto fail;
-
-	key.offset = (u64)-1;
 	memcpy(&pending->root_key, &key, sizeof(key));
-fail:
-	kfree(new_root_item);
-	return ret;
-}
-
-static noinline int finish_pending_snapshot(struct btrfs_fs_info *fs_info,
-				   struct btrfs_pending_snapshot *pending)
-{
-	int ret;
-	int namelen;
-	u64 index = 0;
-	struct btrfs_trans_handle *trans;
-	struct inode *parent_inode;
-	struct btrfs_root *parent_root;
-
-	parent_inode = pending->dentry->d_parent->d_inode;
-	parent_root = BTRFS_I(parent_inode)->root;
-	trans = btrfs_join_transaction(parent_root, 1);
+	pending->root_key.offset = (u64)-1;
 
+	record_root_in_trans(trans, parent_root);
 	/*
 	 * insert the directory item
 	 */
 	namelen = strlen(pending->name);
 	ret = btrfs_set_inode_index(parent_inode, &index);
+	BUG_ON(ret);
 	ret = btrfs_insert_dir_item(trans, parent_root,
 			    pending->name, namelen,
 			    parent_inode->i_ino,
 			    &pending->root_key, BTRFS_FT_DIR, index);
-
-	if (ret)
-		goto fail;
+	BUG_ON(ret);
 
 	btrfs_i_size_write(parent_inode, parent_inode->i_size + namelen * 2);
 	ret = btrfs_update_inode(trans, parent_root, parent_inode);
 	BUG_ON(ret);
 
+	record_root_in_trans(trans, root);
+	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
+	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
+
+	old = btrfs_lock_root_node(root);
+	btrfs_cow_block(trans, root, old, NULL, 0, &old);
+	btrfs_set_lock_blocking(old);
+
+	btrfs_copy_root(trans, root, old, &tmp, objectid);
+	btrfs_tree_unlock(old);
+	free_extent_buffer(old);
+
+	btrfs_set_root_node(new_root_item, tmp);
+	ret = btrfs_insert_root(trans, root->fs_info->tree_root, &key,
+				new_root_item);
+	BUG_ON(ret);
+	btrfs_tree_unlock(tmp);
+	free_extent_buffer(tmp);
+
 	ret = btrfs_add_root_ref(trans, parent_root->fs_info->tree_root,
 				 pending->root_key.objectid,
 				 parent_root->root_key.objectid,
 				 parent_inode->i_ino, index, pending->name,
 				 namelen);
-
 	BUG_ON(ret);
 
 fail:
-	btrfs_end_transaction(trans, fs_info->fs_root);
+	kfree(new_root_item);
 	return ret;
 }
 
@@ -867,25 +854,6 @@ static noinline int create_pending_snapshots(struct btrfs_trans_handle *trans,
 	return 0;
 }
 
-static noinline int finish_pending_snapshots(struct btrfs_trans_handle *trans,
-					     struct btrfs_fs_info *fs_info)
-{
-	struct btrfs_pending_snapshot *pending;
-	struct list_head *head = &trans->transaction->pending_snapshots;
-	int ret;
-
-	while (!list_empty(head)) {
-		pending = list_entry(head->next,
-				     struct btrfs_pending_snapshot, list);
-		ret = finish_pending_snapshot(fs_info, pending);
-		BUG_ON(ret);
-		list_del(&pending->list);
-		kfree(pending->name);
-		kfree(pending);
-	}
-	return 0;
-}
-
 static void update_super_roots(struct btrfs_root *root)
 {
 	struct btrfs_root_item *root_item;
@@ -1097,9 +1065,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_finish_extent_commit(trans, root);
 
-	/* do the directory inserts of any pending snapshot creations */
-	finish_pending_snapshots(trans, root->fs_info);
-
 	mutex_lock(&root->fs_info->trans_mutex);
 
 	cur_trans->commit_done = 1;
-- 
1.7.0

