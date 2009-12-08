From: Sage Weil <sage@newdream.net>
Subject: Re: committing new snapshots
Date: Tue, 8 Dec 2009 09:03:49 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0912080856370.1307@cobra.newdream.net>
References: <Pine.LNX.4.64.0912071411560.31714@cobra.newdream.net>
 <20091208160507.GA3374@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091208160507.GA3374@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 8 Dec 2009, Josef Bacik wrote:

> On Mon, Dec 07, 2009 at 02:25:50PM -0800, Sage Weil wrote:
> > When you create a new snap or subvol, first a new ROOT_ITEM is created 
> > while everything commits, and then the referring directory entry is set up 
> > (with a correspond ROOT_BACKREF).  
> > 
> > First, if you say 'btrfsctl -s foo .' and then 'reboot -f -n' before the 
> > next regularly scheduled commit, the snap is created, but lost.. there's 
> > no reference.  Second, the unreferenced ROOT_ITEM is never cleaned up.
> > 
> > Are there any existing plans for this?  It would be nice if the reference 
> > could be committed as well the first time around.  That probably requires 
> > a bit of futzing to determine what the root objectid is going to be 
> > beforehand, then adding the link in the namespace, then flushing things 
> > out and updating the root item in the right order?
> > 
> 
> We could probably use the orphan code for this.  Just create an orphan item for
> the snapshot and then delete it when the snapshot is fully created that way if
> somebody does reboot -fn we cleanup the root item and such.  Thanks,

That'd clean up the lost root... but it would be nice to avoid making it 
in the first place by committing the dir item with it.  Is there any 
reason something like the below won't work?  It seems to work.  btrfsck 
spits out some errors, but it seems to make the same complaints using the 
existing method as well.

256 was created using the current code, 257 using the patch below 
(cd /mnt/foo ; btrfsctl -s snap1 .).

# btrfsck /dev/sdd 
fs tree 256 refs 2 
        unresolved ref root 257 dir 256 index 3 namelen 5 name snap1 error 600
fs tree 257 refs 2 
        unresolved ref root 257 dir 256 index 5 namelen 5 name snap2 error 600
found 36864 bytes used err is 1
total csum bytes: 0
total tree bytes: 36864
total fs tree bytes: 16384
btree space waste bytes: 28374
file data blocks allocated: 0
 referenced 0
Btrfs v0.19-3-g6f3cf25

Thanks-
sage


>From ae23b9542d03266f132b0c8c9070940974f4bb0f Mon Sep 17 00:00:00 2001
From: Sage Weil <sage@newdream.net>
Date: Tue, 8 Dec 2009 08:55:34 -0800
Subject: [PATCH] Btrfs: commit snapshot ref with new root item

---
 fs/btrfs/transaction.c |   69 +++++++++++++++++++++++------------------------
 1 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c207e8c..747d481 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -756,6 +756,9 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	struct extent_buffer *old;
 	int ret;
 	u64 objectid;
+	struct inode *parent_inode;
+	int namelen;
+	u64 index = 0;
 
 	new_root_item = kmalloc(sizeof(*new_root_item), GFP_NOFS);
 	if (!new_root_item) {
@@ -775,6 +778,29 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	key.offset = trans->transid;
 	btrfs_set_key_type(&key, BTRFS_ROOT_ITEM_KEY);
 
+	memcpy(&pending->root_key, &key, sizeof(key));
+	pending->root_key.offset = (u64)-1;
+
+	parent_inode = pending->dentry->d_parent->d_inode;
+	/*
+	 * insert the directory item
+	 */
+	namelen = strlen(pending->name);
+	ret = btrfs_set_inode_index(parent_inode, &index);
+	ret = btrfs_insert_dir_item(trans, root,
+			    pending->name, namelen,
+			    parent_inode->i_ino,
+			    &pending->root_key, BTRFS_FT_DIR, index);
+
+	if (ret)
+		goto fail;
+
+	btrfs_i_size_write(parent_inode, parent_inode->i_size + namelen * 2);
+	ret = btrfs_update_inode(trans, root, parent_inode);
+	BUG_ON(ret);
+
+	
+
 	old = btrfs_lock_root_node(root);
 	btrfs_cow_block(trans, root, old, NULL, 0, &old);
 	btrfs_set_lock_blocking(old);
@@ -791,8 +817,13 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto fail;
 
-	key.offset = (u64)-1;
-	memcpy(&pending->root_key, &key, sizeof(key));
+	ret = btrfs_add_root_ref(trans, root->fs_info->tree_root,
+				 pending->root_key.objectid,
+				 root->root_key.objectid,
+				 parent_inode->i_ino, index, pending->name,
+				 namelen);
+	BUG_ON(ret);
+
 fail:
 	kfree(new_root_item);
 	btrfs_unreserve_metadata_space(root, 6);
@@ -802,48 +833,16 @@ fail:
 static noinline int finish_pending_snapshot(struct btrfs_fs_info *fs_info,
 				   struct btrfs_pending_snapshot *pending)
 {
-	int ret;
-	int namelen;
-	u64 index = 0;
-	struct btrfs_trans_handle *trans;
 	struct inode *parent_inode;
 	struct inode *inode;
 	struct btrfs_root *parent_root;
 
 	parent_inode = pending->dentry->d_parent->d_inode;
 	parent_root = BTRFS_I(parent_inode)->root;
-	trans = btrfs_join_transaction(parent_root, 1);
-
-	/*
-	 * insert the directory item
-	 */
-	namelen = strlen(pending->name);
-	ret = btrfs_set_inode_index(parent_inode, &index);
-	ret = btrfs_insert_dir_item(trans, parent_root,
-			    pending->name, namelen,
-			    parent_inode->i_ino,
-			    &pending->root_key, BTRFS_FT_DIR, index);
-
-	if (ret)
-		goto fail;
-
-	btrfs_i_size_write(parent_inode, parent_inode->i_size + namelen * 2);
-	ret = btrfs_update_inode(trans, parent_root, parent_inode);
-	BUG_ON(ret);
-
-	ret = btrfs_add_root_ref(trans, parent_root->fs_info->tree_root,
-				 pending->root_key.objectid,
-				 parent_root->root_key.objectid,
-				 parent_inode->i_ino, index, pending->name,
-				 namelen);
-
-	BUG_ON(ret);
 
 	inode = btrfs_lookup_dentry(parent_inode, pending->dentry);
 	d_instantiate(pending->dentry, inode);
-fail:
-	btrfs_end_transaction(trans, fs_info->fs_root);
-	return ret;
+	return 0;
 }
 
 /*
-- 
1.5.6.5

