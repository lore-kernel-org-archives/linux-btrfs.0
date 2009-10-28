From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fallback on uncompressed io if compressed io fails
Date: Wed, 28 Oct 2009 16:38:27 -0400
Message-ID: <20091028203827.GC489@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Currently compressed IO does not deal with not having its entire extent able to
be allocated.  So if we have enough free space to allocate for the extent, but
its not contiguous, it will fail spectacularly.  This patch fixes this by
falling back on uncompressed IO which lets us spread the delalloc extent across
multiple extents.  I tested this by making us randomly think the reservation had
failed to make it fallback on the uncompressed io way and it seemed to work
fine.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/inode.c |   31 +++++++++++++++++++++++--------
 1 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 169396d..9c39575 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -538,7 +538,7 @@ static noinline int submit_compressed_extents(struct inode *inode,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
 	struct extent_io_tree *io_tree;
-	int ret;
+	int ret = 0;
 
 	if (list_empty(&async_cow->extents))
 		return 0;
@@ -552,6 +552,7 @@ static noinline int submit_compressed_extents(struct inode *inode,
 
 		io_tree = &BTRFS_I(inode)->io_tree;
 
+retry:
 		/* did the compression code fall back to uncompressed IO? */
 		if (!async_extent->pages) {
 			int page_started = 0;
@@ -562,11 +563,11 @@ static noinline int submit_compressed_extents(struct inode *inode,
 				    async_extent->ram_size - 1, GFP_NOFS);
 
 			/* allocate blocks */
-			cow_file_range(inode, async_cow->locked_page,
-				       async_extent->start,
-				       async_extent->start +
-				       async_extent->ram_size - 1,
-				       &page_started, &nr_written, 0);
+			ret = cow_file_range(inode, async_cow->locked_page,
+					     async_extent->start,
+					     async_extent->start +
+					     async_extent->ram_size - 1,
+					     &page_started, &nr_written, 0);
 
 			/*
 			 * if page_started, cow_file_range inserted an
@@ -574,7 +575,7 @@ static noinline int submit_compressed_extents(struct inode *inode,
 			 * and IO for us.  Otherwise, we need to submit
 			 * all those pages down to the drive.
 			 */
-			if (!page_started)
+			if (!page_started && !ret)
 				extent_write_locked_range(io_tree,
 						  inode, async_extent->start,
 						  async_extent->start +
@@ -602,7 +603,21 @@ static noinline int submit_compressed_extents(struct inode *inode,
 					   async_extent->compressed_size,
 					   0, alloc_hint,
 					   (u64)-1, &ins, 1);
-		BUG_ON(ret);
+		if (ret) {
+			int i;
+			for (i = 0; i < async_extent->nr_pages; i++) {
+				WARN_ON(async_extent->pages[i]->mapping);
+				page_cache_release(async_extent->pages[i]);
+			}
+			kfree(async_extent->pages);
+			async_extent->nr_pages = 0;
+			async_extent->pages = NULL;
+			unlock_extent(io_tree, async_extent->start,
+				      async_extent->start +
+				      async_extent->ram_size - 1, GFP_NOFS);
+			goto retry;
+		}
+
 		em = alloc_extent_map(GFP_NOFS);
 		em->start = async_extent->start;
 		em->len = async_extent->ram_size;
-- 
1.5.4.3

