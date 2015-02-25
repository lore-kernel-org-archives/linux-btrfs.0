Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbbBYSYj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Feb 2015 13:24:39 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 851FFAAC8
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Feb 2015 18:24:38 +0000 (UTC)
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 02/11] btrfs: use cond_resched_lock where possible
Date: Wed, 25 Feb 2015 19:24:38 +0100
Message-Id: <14cc5298649a1fee36a8ff2a99cac4ef28dc8be5.1424880058.git.dsterba@suse.cz>
In-Reply-To: <cover.1424880058.git.dsterba@suse.cz>
References: <cover.1424880058.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Clean the opencoded variant, cond_resched_lock also checks the lock for
contention so it might help in some cases that were not covered by
simple need_resched().

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/file.c             |  6 +-----
 fs/btrfs/free-space-cache.c | 14 ++++----------
 fs/btrfs/transaction.c      |  7 ++-----
 3 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e4090259569b..1e34bc00249f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -273,11 +273,7 @@ void btrfs_cleanup_defrag_inodes(struct btrfs_fs_info *fs_info)
 		defrag = rb_entry(node, struct inode_defrag, rb_node);
 		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
 
-		if (need_resched()) {
-			spin_unlock(&fs_info->defrag_inodes_lock);
-			cond_resched();
-			spin_lock(&fs_info->defrag_inodes_lock);
-		}
+		cond_resched_lock(&fs_info->defrag_inodes_lock);
 
 		node = rb_first(&fs_info->defrag_inodes);
 	}
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index a71978578fa7..96611fed552f 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2402,11 +2402,8 @@ static void __btrfs_remove_free_space_cache_locked(
 		} else {
 			free_bitmap(ctl, info);
 		}
-		if (need_resched()) {
-			spin_unlock(&ctl->tree_lock);
-			cond_resched();
-			spin_lock(&ctl->tree_lock);
-		}
+
+		cond_resched_lock(&ctl->tree_lock);
 	}
 }
 
@@ -2431,11 +2428,8 @@ void btrfs_remove_free_space_cache(struct btrfs_block_group_cache *block_group)
 
 		WARN_ON(cluster->block_group != block_group);
 		__btrfs_return_cluster_to_free_space(block_group, cluster);
-		if (need_resched()) {
-			spin_unlock(&ctl->tree_lock);
-			cond_resched();
-			spin_lock(&ctl->tree_lock);
-		}
+
+		cond_resched_lock(&ctl->tree_lock);
 	}
 	__btrfs_remove_free_space_cache_locked(ctl);
 	spin_unlock(&ctl->tree_lock);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 038fcf6051e0..efc5ebffa7ea 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -93,11 +93,8 @@ static void clear_btree_io_tree(struct extent_io_tree *tree)
 		 */
 		ASSERT(!waitqueue_active(&state->wq));
 		free_extent_state(state);
-		if (need_resched()) {
-			spin_unlock(&tree->lock);
-			cond_resched();
-			spin_lock(&tree->lock);
-		}
+
+		cond_resched_lock(&tree->lock);
 	}
 	spin_unlock(&tree->lock);
 }
-- 
2.1.3

