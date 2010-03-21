From: jim owens <owens6336@gmail.com>
Subject: [PATCH] Btrfs: change btrfs_get_extent for direct I/O merges.
Date: Sun, 21 Mar 2010 19:36:23 -0400
Message-ID: <4BA6AD77.9050404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Direct I/O passes unaligned start and length values that must
be adjusted to block boundaries for lookup and merging when
an add_extent_mapping fails with EEXIST.

Signed-off-by: jim owens <owens6336@gmail.com>
---
 fs/btrfs/inode.c |   56 ++++++++++++-----------------------------------------
 1 files changed, 13 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index aad29fe..49dfc1a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4573,29 +4573,6 @@ out_unlock:
 	return err;
 }
 
-/* helper for btfs_get_extent.  Given an existing extent in the tree,
- * and an extent that you want to insert, deal with overlap and insert
- * the new extent into the tree.
- */
-static int merge_extent_mapping(struct extent_map_tree *em_tree,
-				struct extent_map *existing,
-				struct extent_map *em,
-				u64 map_start, u64 map_len)
-{
-	u64 start_diff;
-
-	BUG_ON(map_start < em->start || map_start >= extent_map_end(em));
-	start_diff = map_start - em->start;
-	em->start = map_start;
-	em->len = map_len;
-	if (em->block_start < EXTENT_MAP_LAST_BYTE &&
-	    !test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
-		em->block_start += start_diff;
-		em->block_len -= start_diff;
-	}
-	return add_extent_mapping(em_tree, em);
-}
-
 static noinline int uncompress_inline(struct btrfs_path *path,
 				      struct inode *inode, struct page *page,
 				      size_t pg_offset, u64 extent_offset,
@@ -4873,35 +4850,28 @@ insert:
 	if (ret == -EEXIST) {
 		struct extent_map *existing;
 
-		ret = 0;
+		/* start and len might not be block aligned, but extents are */
+		u64 lb_start = start & ~(root->sectorsize - 1);
+		u64 em_tail = em->len - (lb_start - em->start);
 
-		existing = lookup_extent_mapping(em_tree, start, len);
-		if (existing && (existing->start > start ||
-		    existing->start + existing->len <= start)) {
+		existing = lookup_extent_mapping(em_tree, lb_start, em_tail);
+		if (existing && lb_start < existing->start) {
+			em_tail = existing->start - lb_start;
 			free_extent_map(existing);
 			existing = NULL;
 		}
 		if (!existing) {
-			existing = lookup_extent_mapping(em_tree, em->start,
-							 em->len);
-			if (existing) {
-				err = merge_extent_mapping(em_tree, existing,
-							   em, start,
-							   root->sectorsize);
-				free_extent_map(existing);
-				if (err) {
-					free_extent_map(em);
-					em = NULL;
-				}
-			} else {
-				err = -EIO;
-				free_extent_map(em);
-				em = NULL;
+			if (!test_bit(EXTENT_FLAG_COMPRESSED, &em->flags) &&
+			    em->block_start < EXTENT_MAP_LAST_BYTE) {
+				em->block_start += lb_start - em->start;
+				em->block_len -= lb_start - em->start;
 			}
+			em->start = lb_start;
+			em->len = em_tail;
+			err = add_extent_mapping(em_tree, em);
 		} else {
 			free_extent_map(em);
 			em = existing;
-			err = 0;
 		}
 	}
 	write_unlock(&em_tree->lock);
-- 
1.6.3.3
