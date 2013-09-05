Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from xp-ob.rzone.de ([81.169.146.137]:57428 "EHLO xp-ob.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936Ab3IEO6r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Sep 2013 10:58:47 -0400
Received: from pizpot.store ([192.168.43.236])
 by jored.store (RZmta 31.48 OK) with ESMTP id g06805p85CbZlS
 for <linux-btrfs@vger.kernel.org>;
 Thu, 5 Sep 2013 16:58:43 +0200 (CEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: eliminate the exceptional root_tree refs=0
Date: Thu,  5 Sep 2013 16:58:43 +0200
Message-Id: <6864a70d966df33d27a523d944e14f23b6594b7d.1378389401.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The fact that btrfs_root_refs() returned 0 for the tree_root caused
bugs in the past, therefore it is set to 1 with this patch and
(hopefully) all affected code is adapted to this change.

I verified this change by temporarily adding WARN_ON() checks
everywhere where btrfs_root_refs() is used, checking whether the
logic of the code is changed by btrfs_root_refs() returning 1
instead of 0 for root->root_key.objectid == BTRFS_ROOT_TREE_OBJECTID.
With these added checks, I ran the xfstests './check -g auto'.

The two roots chunk_root and log_root_tree that are only referenced
by the superblock and the log_roots below the log_root_tree still
have btrfs_root_refs() == 0, only the tree_root is changed.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/disk-io.c   |  1 +
 fs/btrfs/inode-map.c |  3 +--
 fs/btrfs/inode.c     | 21 ++++++++-------------
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fa8b2c6..ffc3e43 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2667,6 +2667,7 @@ retry_root_backup:
 
 	btrfs_set_root_node(&tree_root->root_item, tree_root->node);
 	tree_root->commit_root = btrfs_root_node(tree_root);
+	btrfs_set_root_refs(&tree_root->root_item, 1);
 
 	location.objectid = BTRFS_EXTENT_TREE_OBJECTID;
 	location.type = BTRFS_ROOT_ITEM_KEY;
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 2c66ddb..d11e1c6 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -412,8 +412,7 @@ int btrfs_save_ino_cache(struct btrfs_root *root,
 		return 0;
 
 	/* Don't save inode cache if we are deleting this root */
-	if (btrfs_root_refs(&root->root_item) == 0 &&
-	    root != root->fs_info->tree_root)
+	if (btrfs_root_refs(&root->root_item) == 0)
 		return 0;
 
 	if (!btrfs_test_opt(root, INODE_MAP_CACHE))
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 26992ee..7d0ef55 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4472,8 +4472,10 @@ void btrfs_evict_inode(struct inode *inode)
 	trace_btrfs_inode_evict(inode);
 
 	truncate_inode_pages(&inode->i_data, 0);
-	if (inode->i_nlink && (btrfs_root_refs(&root->root_item) != 0 ||
-			       btrfs_is_free_space_inode(inode)))
+	if (inode->i_nlink &&
+	    ((btrfs_root_refs(&root->root_item) != 0 &&
+	      root->root_key.objectid != BTRFS_ROOT_TREE_OBJECTID) ||
+	     btrfs_is_free_space_inode(inode)))
 		goto no_delete;
 
 	if (is_bad_inode(inode)) {
@@ -4490,7 +4492,8 @@ void btrfs_evict_inode(struct inode *inode)
 	}
 
 	if (inode->i_nlink > 0) {
-		BUG_ON(btrfs_root_refs(&root->root_item) != 0);
+		BUG_ON(btrfs_root_refs(&root->root_item) != 0 &&
+		       root->root_key.objectid != BTRFS_ROOT_TREE_OBJECTID);
 		goto no_delete;
 	}
 
@@ -4731,14 +4734,7 @@ static void inode_tree_del(struct inode *inode)
 	}
 	spin_unlock(&root->inode_lock);
 
-	/*
-	 * Free space cache has inodes in the tree root, but the tree root has a
-	 * root_refs of 0, so this could end up dropping the tree root as a
-	 * snapshot, so we need the extra !root->fs_info->tree_root check to
-	 * make sure we don't drop it.
-	 */
-	if (empty && btrfs_root_refs(&root->root_item) == 0 &&
-	    root != root->fs_info->tree_root) {
+	if (empty && btrfs_root_refs(&root->root_item) == 0) {
 		synchronize_srcu(&root->fs_info->subvol_srcu);
 		spin_lock(&root->inode_lock);
 		empty = RB_EMPTY_ROOT(&root->inode_tree);
@@ -7872,8 +7868,7 @@ int btrfs_drop_inode(struct inode *inode)
 		return 1;
 
 	/* the snap/subvol tree is on deleting */
-	if (btrfs_root_refs(&root->root_item) == 0 &&
-	    root != root->fs_info->tree_root)
+	if (btrfs_root_refs(&root->root_item) == 0)
 		return 1;
 	else
 		return generic_drop_inode(inode);
-- 
1.8.4

