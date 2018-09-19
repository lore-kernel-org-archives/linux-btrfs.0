Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35154 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727605AbeISMgj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Sep 2018 08:36:39 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 51215AEBA
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2018 07:00:06 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] btrfs: delayed-inode: Use spinlock to protect btrfs_inode::delayed_node
Date: Wed, 19 Sep 2018 14:59:58 +0800
Message-Id: <20180919065958.21153-1-wqu@suse.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the following case, we could trigger a use-after-free bug:

         CPU0                    |               CPU1
-------------------------------------------------------------------------
btrfs_remove_delayed_node        | btrfs_get_delayed_node
|- delayed_node =                | |- node = btrfs_inode->delayed_node;
|    btrfs_inode->delayed_node   | |
|- btrfs_release_delaedy_node()  | |
   |- ref_count_dev_and_test()   | |
   |- kmem_cache_free()          | |
      Now delayed node is freed  | |
                                 | |- refcount_inc(&node->refs)

In that case sine delayed_node is using kmem cache, such use-after-free
bug won't directly cause problem, but could leads to corrupted data
structure of other kmem cache user.

Fix it by adding btrfs_inode::delayed_node_lock to protect such
operation.

Reported-by: sunny.s.zhang <sunny.s.zhang@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Please don't merge this patch yet.

The patch caused random slow down for a lot of quick test cases.
Old tests can be executed in 1s or so now randomly needs near 20s.

It looks like the spin_lock() with root->inode_lock hold is causing the
problem but I can't see what's going wrong.
As the operation done with @delayed_node_lock hold is literatly tiny.

Any comment on this is welcomed.
---
 fs/btrfs/btrfs_inode.h   |  2 ++
 fs/btrfs/delayed-inode.c | 18 +++++++++++++++---
 fs/btrfs/inode.c         |  1 +
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 1343ac57b438..c2f054223588 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -175,6 +175,8 @@ struct btrfs_inode {
 	 */
 	unsigned defrag_compress;
 
+	/* lock for grabbing/freeing @delayed_node */
+	spinlock_t delayed_node_lock;
 	struct btrfs_delayed_node *delayed_node;
 
 	/* File creation time. */
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index f51b509f2d9b..16c405e54930 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -68,19 +68,24 @@ static struct btrfs_delayed_node *btrfs_get_delayed_node(
 	u64 ino = btrfs_ino(btrfs_inode);
 	struct btrfs_delayed_node *node;
 
-	node = READ_ONCE(btrfs_inode->delayed_node);
+	spin_lock(&btrfs_inode->delayed_node_lock);
+	node = btrfs_inode->delayed_node;
 	if (node) {
 		refcount_inc(&node->refs);
+		spin_unlock(&btrfs_inode->delayed_node_lock);
 		return node;
 	}
+	spin_unlock(&btrfs_inode->delayed_node_lock);
 
 	spin_lock(&root->inode_lock);
 	node = radix_tree_lookup(&root->delayed_nodes_tree, ino);
 
 	if (node) {
+		spin_lock(&btrfs_inode->delayed_node_lock);
 		if (btrfs_inode->delayed_node) {
 			refcount_inc(&node->refs);	/* can be accessed */
 			BUG_ON(btrfs_inode->delayed_node != node);
+			spin_unlock(&btrfs_inode->delayed_node_lock);
 			spin_unlock(&root->inode_lock);
 			return node;
 		}
@@ -108,6 +113,7 @@ static struct btrfs_delayed_node *btrfs_get_delayed_node(
 			node = NULL;
 		}
 
+		spin_unlock(&btrfs_inode->delayed_node_lock);
 		spin_unlock(&root->inode_lock);
 		return node;
 	}
@@ -152,7 +158,9 @@ static struct btrfs_delayed_node *btrfs_get_or_create_delayed_node(
 		radix_tree_preload_end();
 		goto again;
 	}
+	spin_lock(&btrfs_inode->delayed_node_lock);
 	btrfs_inode->delayed_node = node;
+	spin_unlock(&btrfs_inode->delayed_node_lock);
 	spin_unlock(&root->inode_lock);
 	radix_tree_preload_end();
 
@@ -1279,11 +1287,15 @@ void btrfs_remove_delayed_node(struct btrfs_inode *inode)
 {
 	struct btrfs_delayed_node *delayed_node;
 
-	delayed_node = READ_ONCE(inode->delayed_node);
-	if (!delayed_node)
+	spin_lock(&inode->delayed_node_lock);
+	delayed_node = inode->delayed_node;
+	if (!delayed_node) {
+		spin_unlock(&inode->delayed_node_lock);
 		return;
+	}
 
 	inode->delayed_node = NULL;
+	spin_unlock(&inode->delayed_node_lock);
 	btrfs_release_delayed_node(delayed_node);
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9357a19d2bff..f438be5fecaf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9177,6 +9177,7 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 	ei->last_log_commit = 0;
 
 	spin_lock_init(&ei->lock);
+	spin_lock_init(&ei->delayed_node_lock);
 	ei->outstanding_extents = 0;
 	if (sb->s_magic != BTRFS_TEST_MAGIC)
 		btrfs_init_metadata_block_rsv(fs_info, &ei->block_rsv,
-- 
2.19.0
