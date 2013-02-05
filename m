Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab3BEWnO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Feb 2013 17:43:14 -0500
Message-ID: <511180E4.2020600@redhat.com>
Date: Tue, 05 Feb 2013 16:00:04 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
CC: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH] btrfs: add delayed_iput list head to btrfs inode
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Following the lead from Jeff Mahoney's comment in the code:

/* JDM: If this is fs-wide, why can't we add a pointer to
 * btrfs_inode instead and avoid the allocation? */

Remove the NOFAIL kmalloc in btrfs_add_delayed_iput(), and just
use a list head in the btrfs inode.

This does grow the btrfs inode by 16 bytes, but doesn't change
slab cache utilization on my machine.  Rearranging the btrfs
inode could get back 8 bytes or so if people are worried about it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Jeff Mahoney <jeffm@suse.com>
---

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 2a8c242..3024006 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -86,6 +86,8 @@ struct btrfs_inode {
 	 */
 	struct list_head ordered_operations;
 
+	struct list_head delayed_iput;
+
 	/* node for the red-black tree that links inodes in subvolume root */
 	struct rb_node rb_node;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index cc93b23..cac7f43 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2119,34 +2119,24 @@ zeroit:
 	return -EIO;
 }
 
-struct delayed_iput {
-	struct list_head list;
-	struct inode *inode;
-};
-
-/* JDM: If this is fs-wide, why can't we add a pointer to
- * btrfs_inode instead and avoid the allocation? */
 void btrfs_add_delayed_iput(struct inode *inode)
 {
-	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
-	struct delayed_iput *delayed;
+	struct btrfs_inode *b_inode = BTRFS_I(inode);
+	struct btrfs_fs_info *fs_info = b_inode->root->fs_info;
 
 	if (atomic_add_unless(&inode->i_count, -1, 1))
 		return;
 
-	delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);
-	delayed->inode = inode;
-
 	spin_lock(&fs_info->delayed_iput_lock);
-	list_add_tail(&delayed->list, &fs_info->delayed_iputs);
+	list_add_tail(&b_inode->delayed_iput, &fs_info->delayed_iputs);
 	spin_unlock(&fs_info->delayed_iput_lock);
 }
 
 void btrfs_run_delayed_iputs(struct btrfs_root *root)
 {
 	LIST_HEAD(list);
+	struct btrfs_inode *b_inode;
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct delayed_iput *delayed;
 	int empty;
 
 	spin_lock(&fs_info->delayed_iput_lock);
@@ -2160,10 +2150,9 @@ void btrfs_run_delayed_iputs(struct btrfs_root *root)
 	spin_unlock(&fs_info->delayed_iput_lock);
 
 	while (!list_empty(&list)) {
-		delayed = list_entry(list.next, struct delayed_iput, list);
-		list_del(&delayed->list);
-		iput(delayed->inode);
-		kfree(delayed);
+		b_inode = list_entry(list.next, struct btrfs_inode, delayed_iput);
+		list_del(&b_inode->delayed_iput);
+		iput(&b_inode->vfs_inode);
 	}
 }
 
@@ -7142,6 +7131,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	btrfs_ordered_inode_tree_init(&ei->ordered_tree);
 	INIT_LIST_HEAD(&ei->delalloc_inodes);
 	INIT_LIST_HEAD(&ei->ordered_operations);
+	INIT_LIST_HEAD(&ei->delayed_iput);
 	RB_CLEAR_NODE(&ei->rb_node);
 
 	return inode;

