From: David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/8] btrfs: no need to mask out GFP_HIGHMEM in radix preload
Date: Wed,  5 Oct 2011 12:22:05 +0200
Message-ID: <9defff14fc5aae8bc877b6e44536e46a7618a86d.1317746378.git.dsterba@suse.cz>
References: <cover.1317746377.git.dsterba@suse.cz>
Cc: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1317746377.git.dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

GFP_NOFS does not have the GFP_HIGHMEM bit set.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/delayed-inode.c |    2 +-
 fs/btrfs/disk-io.c       |    2 +-
 fs/btrfs/extent_io.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index b52c672..63b1e2c 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -137,7 +137,7 @@ again:
 	atomic_inc(&node->refs);	/* cached in the btrfs inode */
 	atomic_inc(&node->refs);	/* can be accessed */
 
-	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
+	ret = radix_tree_preload(GFP_NOFS);
 	if (ret) {
 		kmem_cache_free(delayed_node_cache, node);
 		return ERR_PTR(ret);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6cb5d4e..a56c1e0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1354,7 +1354,7 @@ again:
 	if (ret == 0)
 		root->orphan_item_inserted = 1;
 
-	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
+	ret = radix_tree_preload(GFP_NOFS);
 	if (ret)
 		goto fail;
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0e206ff..597686e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3297,7 +3297,7 @@ struct extent_buffer *alloc_extent_buffer(struct extent_io_tree *tree,
 	if (uptodate)
 		set_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags);
 
-	ret = radix_tree_preload(GFP_NOFS & ~__GFP_HIGHMEM);
+	ret = radix_tree_preload(GFP_NOFS);
 	if (ret)
 		goto free_eb;
 
-- 
1.7.6

