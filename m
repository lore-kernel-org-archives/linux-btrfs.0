From: Mingming <cmm@us.ibm.com>
Subject: Re: [RFC][PATCH]btrfs delete ordered inode handling fix
Date: Thu, 22 May 2008 13:39:19 -0700
Message-ID: <1211488759.8596.54.camel@BVR-FS.beaverton.ibm.com>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
	 <200805221011.19568.chris.mason@oracle.com>
	 <1211478194.8596.28.camel@BVR-FS.beaverton.ibm.com>
	 <200805221347.22421.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200805221347.22421.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Thu, 2008-05-22 at 13:47 -0400, Chris Mason wrote:
> On Thursday 22 May 2008, Mingming wrote:
> > On Thu, 2008-05-22 at 10:11 -0400, Chris Mason wrote:
> > > On Wednesday 21 May 2008, Mingming wrote:
> > > > Hi Chris,  I thought I spotted a few bugs, While looking at how to
> > > > properly remove inode from ordered tree, let me know if I got it right.
> > >
> > > Hi Mingming, thanks for going through this code.  The i_count rules in
> > > the current code should work like this:
> >
> > Hi Chris, thanks for your detailed clarification.
> >
> > > * btrfs_add_ordered_inode calls igrab when the inode is inserted into the
> > > list.  The whole time the inode is on the list, there's an extra
> > > reference on i_count.  There will be no final iput while the inode is on
> > > the list.
> >
> > Ah I missed that. That explains all my confusion of the i_count accounting.
> >
> > > > * There is possible race with inode delete and
> > > > btrfs_find_first_ordered_inode(). The inode could possibly in the
> > > > process of freeing while we are trying to get hold of it during commit
> > > > transaction. The fix is using igrab() instead, and search for next
> > > > inode in the tree if the found one is in the middle of being released.
> > >
> > > These kinds of races where the main reason why I had the list take a
> > > reference on the inode.  delete_inode won't be called while i_count is
> > > increased.
> > >
> > > Over the long term I'd prefer to move the ordered-data list to a model
> > > where the list doesn't have a reference and it is magically removed after
> > > all the dirty pages are gone (by the end_io_hook handlers in inode.c). 
> > > The end_io hooks in inode.c may be sufficient for this.
> >
> > Make sense.
> >
> > > > * get rid of btrfs_put_inode(), and move the functionality under the
> > > > btrfs_del_ordered_inode() directly.
> > >
> > > I like this change, thanks.
> > >
> > > > * Remove the inode from ordered tree at last iput(). Did not do it at
> > > > file release() time, as it may remove the inode from the ordered tree
> > > > before ensure the ordering of write to the same inode from other
> > > > process.
> > > >
> > > > Perhaps calling btrfs_del_ordered_inode() under unlink() is enough, but
> > > > it would not be hurt to do it again at delete_inode() time.
> > >
> > > I'm afraid we'll have to do it at file_release time, at least until the
> > > ordered list is changed not to keep a reference.
> >
> > Yes with the i_count logic delete_inode() is not the right place to call
> > btrfs_del_ordered_inode.
> >
> > But I am still not quite sure whether it is safe to remove the inode
> > from the ordered tree at the file_release() time. i.e. whether the dirty
> > data already being flushed to disk at last file_close()/file_release()
> > time and when two process open and write to the same inode ...
> 
> I get around this by testing for dirty/writeback pages before removing the 
> inode from the ordered list.  If another writer allocates blocks to the file, 
> it will be added back to the list.
> 

I see.:) How about patch below?

Mingming

diff -r c3290d51e5f9 file.c
--- a/file.c	Fri May 16 13:30:15 2008 -0400
+++ b/file.c	Thu May 22 13:29:42 2008 -0700
@@ -978,6 +978,12 @@ out_nolock:
 	return num_written ? num_written : err;
 }
 
+static int btrfs_release_file (struct inode * inode, struct file * filp)
+{
+	btrfs_del_ordered_inode(inode);
+	return 0;
+}
+
 static int btrfs_sync_file(struct file *file,
 			   struct dentry *dentry, int datasync)
 {
@@ -1044,6 +1050,7 @@ struct file_operations btrfs_file_operat
 	.write		= btrfs_file_write,
 	.mmap		= btrfs_file_mmap,
 	.open		= generic_file_open,
+	.release	= btrfs_release_file,
 	.fsync		= btrfs_sync_file,
 	.unlocked_ioctl	= btrfs_ioctl,
 #ifdef CONFIG_COMPAT
diff -r c3290d51e5f9 inode.c
--- a/inode.c	Fri May 16 13:30:15 2008 -0400
+++ b/inode.c	Thu May 22 13:31:14 2008 -0700
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
diff -r c3290d51e5f9 ordered-data.c
--- a/ordered-data.c	Fri May 16 13:30:15 2008 -0400
+++ b/ordered-data.c	Thu May 22 13:24:56 2008 -0700
@@ -231,7 +231,7 @@ int btrfs_find_del_first_ordered_inode(s
 	return 1;
 }
 
-static int __btrfs_del_ordered_inode(struct btrfs_ordered_inode_tree *tree,
+static void __btrfs_del_ordered_inode(struct btrfs_ordered_inode_tree *tree,
 				     struct inode *inode,
 				     u64 root_objectid, u64 objectid)
 {
@@ -243,31 +243,38 @@ static int __btrfs_del_ordered_inode(str
 	node = __tree_search(&tree->tree, root_objectid, objectid, &prev);
 	if (!node) {
 		write_unlock(&tree->lock);
-		return 0;
+		return;
 	}
 	rb_erase(node, &tree->tree);
 	BTRFS_I(inode)->ordered_trans = 0;
 	write_unlock(&tree->lock);
+	atomic_dec(&inode->i_count);
 	entry = rb_entry(node, struct tree_entry, rb_node);
 	kfree(entry);
-	return 1;
-}
-
-int btrfs_del_ordered_inode(struct inode *inode)
+	return;
+}
+
+void btrfs_del_ordered_inode(struct inode *inode)
 {
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 root_objectid = root->root_key.objectid;
-	int ret = 0;
+
+	if (!BTRFS_I(inode)->ordered_trans) {
+		return;
+	}
+
+	if (mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY) ||
+	    mapping_tagged(inode->i_mapping, PAGECACHE_TAG_WRITEBACK))
+		return;
 
 	spin_lock(&root->fs_info->new_trans_lock);
 	if (root->fs_info->running_transaction) {
 		struct btrfs_ordered_inode_tree *tree;
 		tree = &root->fs_info->running_transaction->ordered_inode_tree;
-		ret = __btrfs_del_ordered_inode(tree, inode, root_objectid,
+		 __btrfs_del_ordered_inode(tree, inode, root_objectid,
 						inode->i_ino);
 	}
 	spin_unlock(&root->fs_info->new_trans_lock);
-	return ret;
 }
 
 int btrfs_ordered_throttle(struct btrfs_root *root, struct inode *inode)
diff -r c3290d51e5f9 ordered-data.h
--- a/ordered-data.h	Fri May 16 13:30:15 2008 -0400
+++ b/ordered-data.h	Thu May 22 13:25:09 2008 -0700
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
+++ b/super.c	Thu May 22 13:30:44 2008 -0700
@@ -487,7 +487,6 @@ static void btrfs_unlockfs(struct super_
 
 static struct super_operations btrfs_super_ops = {
 	.delete_inode	= btrfs_delete_inode,
-	.put_inode	= btrfs_put_inode,
 	.put_super	= btrfs_put_super,
 	.write_super	= btrfs_write_super,
 	.sync_fs	= btrfs_sync_fs,


