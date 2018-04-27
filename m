Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59282 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757822AbeD0Lg2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 07:36:28 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BC6CAAEF2
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 11:36:26 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: Unexport and rename btrfs_invalidate_inodes
Date: Fri, 27 Apr 2018 14:36:24 +0300
Message-Id: <1524828984-2797-1-git-send-email-nborisov@suse.com>
In-Reply-To: <1524820914-30864-6-git-send-email-nborisov@suse.com>
References: <1524820914-30864-6-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is no longer used outside of inode.c so just make it
static. At the same time give a more becoming name, since it's not
really invalidating the inodes but just calling d_prune_alias. Last,
but not least - move the function above the sole caller to avoid
introducing yet-another-pointless forward declaration.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

Forgot to rename the function at the actual call site. 
 fs/btrfs/ctree.h |   1 -
 fs/btrfs/inode.c | 130 ++++++++++++++++++++++++++++---------------------------
 2 files changed, 66 insertions(+), 65 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 27aa9b58b001..9536872f2ec4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3231,7 +3231,6 @@ int btrfs_orphan_cleanup(struct btrfs_root *root);
 void btrfs_orphan_commit_root(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root);
 int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size);
-void btrfs_invalidate_inodes(struct btrfs_root *root);
 void btrfs_add_delayed_iput(struct inode *inode);
 void btrfs_run_delayed_iputs(struct btrfs_fs_info *fs_info);
 int btrfs_prealloc_file_range(struct inode *inode, int mode,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d35992b8bb5e..d42cd8e6e8a6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4384,6 +4384,71 @@ static noinline int may_destroy_subvol(struct btrfs_root *root)
 	return ret;
 }
 
+/* Delete all dentries for inodes belonging to the root */
+static void btrfs_prune_dentries(struct btrfs_root *root)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct rb_node *node;
+	struct rb_node *prev;
+	struct btrfs_inode *entry;
+	struct inode *inode;
+	u64 objectid = 0;
+
+	if (!test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
+		WARN_ON(btrfs_root_refs(&root->root_item) != 0);
+
+	spin_lock(&root->inode_lock);
+again:
+	node = root->inode_tree.rb_node;
+	prev = NULL;
+	while (node) {
+		prev = node;
+		entry = rb_entry(node, struct btrfs_inode, rb_node);
+
+		if (objectid < btrfs_ino(BTRFS_I(&entry->vfs_inode)))
+			node = node->rb_left;
+		else if (objectid > btrfs_ino(BTRFS_I(&entry->vfs_inode)))
+			node = node->rb_right;
+		else
+			break;
+	}
+	if (!node) {
+		while (prev) {
+			entry = rb_entry(prev, struct btrfs_inode, rb_node);
+			if (objectid <= btrfs_ino(BTRFS_I(&entry->vfs_inode))) {
+				node = prev;
+				break;
+			}
+			prev = rb_next(prev);
+		}
+	}
+	while (node) {
+		entry = rb_entry(node, struct btrfs_inode, rb_node);
+		objectid = btrfs_ino(BTRFS_I(&entry->vfs_inode)) + 1;
+		inode = igrab(&entry->vfs_inode);
+		if (inode) {
+			spin_unlock(&root->inode_lock);
+			if (atomic_read(&inode->i_count) > 1)
+				d_prune_aliases(inode);
+			/*
+			 * btrfs_drop_inode will have it removed from
+			 * the inode cache when its usage count
+			 * hits zero.
+			 */
+			iput(inode);
+			cond_resched();
+			spin_lock(&root->inode_lock);
+			goto again;
+		}
+
+		if (cond_resched_lock(&root->inode_lock))
+			goto again;
+
+		node = rb_next(node);
+	}
+	spin_unlock(&root->inode_lock);
+}
+
 int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(dentry->d_sb);
@@ -4510,7 +4575,7 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 		spin_unlock(&dest->root_item_lock);
 	} else {
 		d_invalidate(dentry);
-		btrfs_invalidate_inodes(dest);
+		btrfs_prune_dentries(dest);
 		ASSERT(dest->send_in_progress == 0);
 
 		/* the last ref */
@@ -5823,69 +5888,6 @@ static void inode_tree_del(struct inode *inode)
 	}
 }
 
-void btrfs_invalidate_inodes(struct btrfs_root *root)
-{
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct rb_node *node;
-	struct rb_node *prev;
-	struct btrfs_inode *entry;
-	struct inode *inode;
-	u64 objectid = 0;
-
-	if (!test_bit(BTRFS_FS_STATE_ERROR, &fs_info->fs_state))
-		WARN_ON(btrfs_root_refs(&root->root_item) != 0);
-
-	spin_lock(&root->inode_lock);
-again:
-	node = root->inode_tree.rb_node;
-	prev = NULL;
-	while (node) {
-		prev = node;
-		entry = rb_entry(node, struct btrfs_inode, rb_node);
-
-		if (objectid < btrfs_ino(BTRFS_I(&entry->vfs_inode)))
-			node = node->rb_left;
-		else if (objectid > btrfs_ino(BTRFS_I(&entry->vfs_inode)))
-			node = node->rb_right;
-		else
-			break;
-	}
-	if (!node) {
-		while (prev) {
-			entry = rb_entry(prev, struct btrfs_inode, rb_node);
-			if (objectid <= btrfs_ino(BTRFS_I(&entry->vfs_inode))) {
-				node = prev;
-				break;
-			}
-			prev = rb_next(prev);
-		}
-	}
-	while (node) {
-		entry = rb_entry(node, struct btrfs_inode, rb_node);
-		objectid = btrfs_ino(BTRFS_I(&entry->vfs_inode)) + 1;
-		inode = igrab(&entry->vfs_inode);
-		if (inode) {
-			spin_unlock(&root->inode_lock);
-			if (atomic_read(&inode->i_count) > 1)
-				d_prune_aliases(inode);
-			/*
-			 * btrfs_drop_inode will have it removed from
-			 * the inode cache when its usage count
-			 * hits zero.
-			 */
-			iput(inode);
-			cond_resched();
-			spin_lock(&root->inode_lock);
-			goto again;
-		}
-
-		if (cond_resched_lock(&root->inode_lock))
-			goto again;
-
-		node = rb_next(node);
-	}
-	spin_unlock(&root->inode_lock);
-}
 
 static int btrfs_init_locked_inode(struct inode *inode, void *p)
 {
-- 
2.7.4

