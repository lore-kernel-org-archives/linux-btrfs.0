From: Mingming <cmm@us.ibm.com>
Subject: [RFC][PATCH]btrfs delete ordered inode handling fix
Date: Wed, 21 May 2008 15:29:56 -0700
Message-ID: <1211408996.8596.1.camel@BVR-FS.beaverton.ibm.com>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
	 <200805211402.26648.chris.mason@oracle.com>
	 <1211395516.5571.31.camel@BVR-FS.beaverton.ibm.com>
	 <200805211452.34891.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200805211452.34891.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,  I thought I spotted a few bugs, While looking at how to
properly remove inode from ordered tree, let me know if I got it right.

* inode->i_count accounting issue
- remove extra i_count_decrease after calling
filemap_file_write_and_wait() in btrfs_write_ordered_inodes()

- Remove extra i_count decrease after each call
btrfs_del_ordered_inode(), it decrease the i_count again. I couldn't
find the where the i_count being increased. The tree_lock should
protecting it races with btrfs_write_ordered_inodes(), no? 

* There is possible race with inode delete and
btrfs_find_first_ordered_inode(). The inode could possibly in the
process of freeing while we are trying to get hold of it during commit
transaction. The fix is using igrab() instead, and search for next inode
in the tree if the found one is in the middle of being released.

* get rid of btrfs_put_inode(), and move the functionality under the
btrfs_del_ordered_inode() directly.

* Remove the inode from ordered tree at last iput(). Did not do it at
file release() time, as it may remove the inode from the ordered tree
before ensure the ordering of write to the same inode from other
process.

Perhaps calling btrfs_del_ordered_inode() under unlink() is enough, but
it would not be hurt to do it again at delete_inode() time.


Here is the patch trying to address above issues... compiled, but not
tested. Is ordered mode on by default?

Regards,
Mingming

diff -r c3290d51e5f9 inode.c
--- a/inode.c	Fri May 16 13:30:15 2008 -0400
+++ b/inode.c	Wed May 21 14:51:22 2008 -0700
@@ -857,15 +857,11 @@ static int btrfs_unlink(struct inode *di
 	nr = trans->blocks_used;
 
 	if (inode->i_nlink == 0) {
-		int found;
 		/* if the inode isn't linked anywhere,
 		 * we don't need to worry about
 		 * data=ordered
 		 */
-		found = btrfs_del_ordered_inode(inode);
-		if (found == 1) {
-			atomic_dec(&inode->i_count);
-		}
+		btrfs_del_ordered_inode(inode);
 	}
 
 	btrfs_end_transaction(trans, root);
@@ -1271,24 +1267,6 @@ fail:
 	return err;
 }
 
-void btrfs_put_inode(struct inode *inode)
-{
-	int ret;
-
-	if (!BTRFS_I(inode)->ordered_trans) {
-		return;
-	}
-
-	if (mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY) ||
-	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK))
-		return;
-
-	ret = btrfs_del_ordered_inode(inode);
-	if (ret == 1) {
-		atomic_dec(&inode->i_count);
-	}
-}
-
 void btrfs_delete_inode(struct inode *inode)
 {
 	struct btrfs_trans_handle *trans;
@@ -1311,6 +1289,7 @@ void btrfs_delete_inode(struct inode *in
 		goto no_delete_lock;
 
 	nr = trans->blocks_used;
+	btrfs_del_ordered_inode(inode);
 	clear_inode(inode);
 
 	btrfs_end_transaction(trans, root);
diff -r c3290d51e5f9 ordered-data.c
--- a/ordered-data.c	Fri May 16 13:30:15 2008 -0400
+++ b/ordered-data.c	Wed May 21 14:55:25 2008 -0700
@@ -166,7 +166,7 @@ int btrfs_find_first_ordered_inode(struc
 				   struct inode **inode)
 {
 	struct tree_entry *entry;
-	struct rb_node *node;
+	struct rb_node *node, *next;
 
 	write_lock(&tree->lock);
 	node = tree_search(&tree->tree, *root_objectid, *objectid);
@@ -174,6 +174,7 @@ int btrfs_find_first_ordered_inode(struc
 		write_unlock(&tree->lock);
 		return 0;
 	}
+again:
 	entry = rb_entry(node, struct tree_entry, rb_node);
 
 	while(comp_entry(entry, *root_objectid, *objectid) >= 0) {
@@ -187,9 +188,20 @@ int btrfs_find_first_ordered_inode(struc
 		return 0;
 	}
 
+	*inode = igrab(entry->inode);
+	if (!*inode) {
+		next = rb_next(node);
+		rb_erase(node, &tree->tree);
+		kfree(entry);
+		if (!next) {
+			write_unlock(&tree->lock);
+			return 0;
+		}
+		node = next;
+		goto again;
+	}
+
 	*root_objectid = entry->root_objectid;
-	*inode = entry->inode;
-	atomic_inc(&entry->inode->i_count);
 	*objectid = entry->objectid;
 	write_unlock(&tree->lock);
 	return 1;
@@ -200,7 +212,7 @@ int btrfs_find_del_first_ordered_inode(s
 				       struct inode **inode)
 {
 	struct tree_entry *entry;
-	struct rb_node *node;
+	struct rb_node *node, *next;
 
 	write_lock(&tree->lock);
 	node = tree_search(&tree->tree, *root_objectid, *objectid);
@@ -208,7 +220,7 @@ int btrfs_find_del_first_ordered_inode(s
 		write_unlock(&tree->lock);
 		return 0;
 	}
-
+retry:
 	entry = rb_entry(node, struct tree_entry, rb_node);
 	while(comp_entry(entry, *root_objectid, *objectid) >= 0) {
 		node = rb_next(node);
@@ -220,11 +232,21 @@ int btrfs_find_del_first_ordered_inode(s
 		write_unlock(&tree->lock);
 		return 0;
 	}
+	*inode = igrab(entry->inode);
+	if (!*inode) {
+		next = rb_next(node);
+		rb_erase(node, &tree->tree);
+		kfree(entry);
+		if (!next) {
+			write_unlock(&tree->lock);
+			return 0;
+		}
+		node = next;
+		goto retry;
+	}
 
 	*root_objectid = entry->root_objectid;
 	*objectid = entry->objectid;
-	*inode = entry->inode;
-	atomic_inc(&entry->inode->i_count);
 	rb_erase(node, &tree->tree);
 	write_unlock(&tree->lock);
 	kfree(entry);
@@ -253,11 +275,19 @@ static int __btrfs_del_ordered_inode(str
 	return 1;
 }
 
-int btrfs_del_ordered_inode(struct inode *inode)
+void btrfs_del_ordered_inode(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 root_objectid = root->root_key.objectid;
 	int ret = 0;
+
+	if (!BTRFS_I(inode)->ordered_trans) {
+		return;
+	}
+
+	if (mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY) ||
+		mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK))
+		return;
 
 	spin_lock(&root->fs_info->new_trans_lock);
 	if (root->fs_info->running_transaction) {
@@ -267,7 +297,7 @@ int btrfs_del_ordered_inode(struct inode
 						inode->i_ino);
 	}
 	spin_unlock(&root->fs_info->new_trans_lock);
-	return ret;
+	return;
 }
 
 int btrfs_ordered_throttle(struct btrfs_root *root, struct inode *inode)
diff -r c3290d51e5f9 ordered-data.h
--- a/ordered-data.h	Fri May 16 13:30:15 2008 -0400
+++ b/ordered-data.h	Wed May 21 14:56:49 2008 -0700
@@ -38,6 +38,6 @@ int btrfs_find_first_ordered_inode(struc
 int btrfs_find_first_ordered_inode(struct btrfs_ordered_inode_tree *tree,
 				       u64 *root_objectid, u64 *objectid,
 				       struct inode **inode);
-int btrfs_del_ordered_inode(struct inode *inode);
+void btrfs_del_ordered_inode(struct inode *inode);
 int btrfs_ordered_throttle(struct btrfs_root *root, struct inode *inode);
 #endif
diff -r c3290d51e5f9 super.c
--- a/super.c	Fri May 16 13:30:15 2008 -0400
+++ b/super.c	Wed May 21 12:54:48 2008 -0700
@@ -487,7 +487,6 @@ static void btrfs_unlockfs(struct super_
 
 static struct super_operations btrfs_super_ops = {
 	.delete_inode	= btrfs_delete_inode,
-	.put_inode	= btrfs_put_inode,
 	.put_super	= btrfs_put_super,
 	.write_super	= btrfs_write_super,
 	.sync_fs	= btrfs_sync_fs,
diff -r c3290d51e5f9 transaction.c
--- a/transaction.c	Fri May 16 13:30:15 2008 -0400
+++ b/transaction.c	Wed May 21 14:18:34 2008 -0700
@@ -538,7 +538,6 @@ int btrfs_write_ordered_inodes(struct bt
 			filemap_write_and_wait(inode->i_mapping);
 			atomic_dec(&BTRFS_I(inode)->ordered_writeback);
 		}
-		atomic_dec(&inode->i_count);
 		iput(inode);
 
 		mutex_lock(&root->fs_info->fs_mutex);


