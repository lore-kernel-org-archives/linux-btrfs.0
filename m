From: David Rientjes <rientjes@google.com>
Subject: [patch v2 4/5] btrfs: add nofail variant of set_extent_dirty
Date: Wed, 1 Sep 2010 18:03:17 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1009011800110.24694@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com> <alpine.DEB.2.00.1009011757360.24694@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1009011757360.24694@chino.kir.corp.google.com>
List-ID: <linux-btrfs.vger.kernel.org>

Add set_extent_dirty_nofail().  This function is equivalent to
set_extent_dirty(), except that it will never fail because of allocation
failure and instead loop forever trying to allocate memory.

If the first allocation attempt fails because the page allocator doesn't
implicitly loop, a warning will be emitted, including a call trace.
Subsequent failures will suppress this warning.

This was added as a helper function for documentation and auditability.
No future callers should be added.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/btrfs/extent-tree.c |    8 ++++----
 fs/btrfs/extent_io.c   |   18 ++++++++++++++++++
 fs/btrfs/extent_io.h   |    2 ++
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3831,9 +3831,9 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
 
-			set_extent_dirty(info->pinned_extents,
+			set_extent_dirty_nofail(info->pinned_extents,
 					 bytenr, bytenr + num_bytes - 1,
-					 GFP_NOFS | __GFP_NOFAIL);
+					 GFP_NOFS);
 		}
 		btrfs_put_block_group(cache);
 		total -= num_bytes;
@@ -3872,8 +3872,8 @@ static int pin_down_extent(struct btrfs_root *root,
 	spin_unlock(&cache->lock);
 	spin_unlock(&cache->space_info->lock);
 
-	set_extent_dirty(root->fs_info->pinned_extents, bytenr,
-			 bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
+	set_extent_dirty_nofail(root->fs_info->pinned_extents, bytenr,
+			 bytenr + num_bytes - 1, GFP_NOFS);
 	return 0;
 }
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -940,6 +940,24 @@ int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 			      NULL, mask);
 }
 
+/*
+ * NOTE: no new callers of this function should be implemented!
+ * All memory allocations should be failable whenever possible.
+ */
+int set_extent_dirty_nofail(struct extent_io_tree *tree, u64 start, u64 end,
+		     gfp_t mask)
+{
+	int ret;
+
+	for (;;) {
+		ret = set_extent_dirty(tree, start, end, mask);
+		if (ret != -ENOMEM)
+			return ret;
+		WARN_ON_ONCE(get_order(sizeof(struct extent_state)) >
+						PAGE_ALLOC_COSTLY_ORDER);
+	}
+}
+
 int set_extent_bits(struct extent_io_tree *tree, u64 start, u64 end,
 		    int bits, gfp_t mask)
 {
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -197,6 +197,8 @@ int set_extent_new(struct extent_io_tree *tree, u64 start, u64 end,
 		   gfp_t mask);
 int set_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		     gfp_t mask);
+int set_extent_dirty_nofail(struct extent_io_tree *tree, u64 start, u64 end,
+		     gfp_t mask);
 int clear_extent_dirty(struct extent_io_tree *tree, u64 start, u64 end,
 		       gfp_t mask);
 int clear_extent_ordered(struct extent_io_tree *tree, u64 start, u64 end,
