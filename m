From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: fix free space cache when there are pinned extents and clusters V2
Date: Fri,  1 Apr 2011 10:55:00 -0400
Message-ID: <1301669700-11078-1-git-send-email-josef@redhat.com>
References: <1301601548-14612-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1301601548-14612-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

I noticed a huge problem with the free space cache that was presenting as an
early ENOSPC.  Turns out when writing the free space cache out I forgot to take
into account pinned extents and more importantly clusters.  This would result in
us leaking free space everytime we unmounted the filesystem and remounted it.  I
fix this by making sure to check and see if the current block group has a
cluster and writing out any entries that are in the cluster to the cache, as
well as writing any pinned extents we currently have to the cache since those
will be available for us to use the next time the fs mounts.  This patch also
adds a check to the end of load_free_space_cache to make sure we got the right
amount of free space cache, and if not make sure to clear the cache and re-cache
the old fashioned way.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
V1->V2:
- use block_group->free_space instead of
  btrfs_block_group_free_space(block_group)

 fs/btrfs/free-space-cache.c |   82 ++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 78 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index f03ef97..74bc432 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -24,6 +24,7 @@
 #include "free-space-cache.h"
 #include "transaction.h"
 #include "disk-io.h"
+#include "extent_io.h"
 
 #define BITS_PER_BITMAP		(PAGE_CACHE_SIZE * 8)
 #define MAX_CACHE_BYTES_PER_GIG	(32 * 1024)
@@ -222,6 +223,7 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 	u64 num_entries;
 	u64 num_bitmaps;
 	u64 generation;
+	u64 used = btrfs_block_group_used(&block_group->item);
 	u32 cur_crc = ~(u32)0;
 	pgoff_t index = 0;
 	unsigned long first_page_offset;
@@ -467,6 +469,17 @@ next:
 		index++;
 	}
 
+	spin_lock(&block_group->tree_lock);
+	if (block_group->free_space != (block_group->key.offset - used -
+					block_group->bytes_super)) {
+		spin_unlock(&block_group->tree_lock);
+		printk(KERN_ERR "block group %llu has an wrong amount of free "
+		       "space\n", block_group->key.objectid);
+		ret = 0;
+		goto free_cache;
+	}
+	spin_unlock(&block_group->tree_lock);
+
 	ret = 1;
 out:
 	kfree(checksums);
@@ -495,8 +508,11 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 	struct list_head *pos, *n;
 	struct page *page;
 	struct extent_state *cached_state = NULL;
+	struct btrfs_free_cluster *cluster = NULL;
+	struct extent_io_tree *unpin = NULL;
 	struct list_head bitmap_list;
 	struct btrfs_key key;
+	u64 start, end, len;
 	u64 bytes = 0;
 	u32 *crc, *checksums;
 	pgoff_t index = 0, last_index = 0;
@@ -505,6 +521,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 	int entries = 0;
 	int bitmaps = 0;
 	int ret = 0;
+	bool next_page = false;
 
 	root = root->fs_info->tree_root;
 
@@ -551,6 +568,18 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 	 */
 	first_page_offset = (sizeof(u32) * num_checksums) + sizeof(u64);
 
+	/* Get the cluster for this block_group if it exists */
+	if (!list_empty(&block_group->cluster_list))
+		cluster = list_entry(block_group->cluster_list.next,
+				     struct btrfs_free_cluster,
+				     block_group_list);
+
+	/*
+	 * We shouldn't have switched the pinned extents yet so this is the
+	 * right one
+	 */
+	unpin = root->fs_info->pinned_extents;
+
 	/*
 	 * Lock all pages first so we can lock the extent safely.
 	 *
@@ -580,6 +609,12 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 	lock_extent_bits(&BTRFS_I(inode)->io_tree, 0, i_size_read(inode) - 1,
 			 0, &cached_state, GFP_NOFS);
 
+	/*
+	 * When searching for pinned extents, we need to start at our start
+	 * offset.
+	 */
+	start = block_group->key.objectid;
+
 	/* Write out the extent entries */
 	do {
 		struct btrfs_free_space_entry *entry;
@@ -587,6 +622,8 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 		unsigned long offset = 0;
 		unsigned long start_offset = 0;
 
+		next_page = false;
+
 		if (index == 0) {
 			start_offset = first_page_offset;
 			offset = start_offset;
@@ -598,7 +635,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 		entry = addr + start_offset;
 
 		memset(addr, 0, PAGE_CACHE_SIZE);
-		while (1) {
+		while (node && !next_page) {
 			struct btrfs_free_space *e;
 
 			e = rb_entry(node, struct btrfs_free_space, offset_index);
@@ -614,12 +651,49 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 				entry->type = BTRFS_FREE_SPACE_EXTENT;
 			}
 			node = rb_next(node);
-			if (!node)
-				break;
+			if (!node && cluster) {
+				node = rb_first(&cluster->root);
+				cluster = NULL;
+			}
 			offset += sizeof(struct btrfs_free_space_entry);
 			if (offset + sizeof(struct btrfs_free_space_entry) >=
 			    PAGE_CACHE_SIZE)
+				next_page = true;
+			entry++;
+		}
+
+		/*
+		 * We want to add any pinned extents to our free space cache
+		 * so we don't leak the space
+		 */
+		while (!next_page && (start < block_group->key.objectid +
+				      block_group->key.offset)) {
+			ret = find_first_extent_bit(unpin, start, &start, &end,
+						    EXTENT_DIRTY);
+			if (ret) {
+				ret = 0;
 				break;
+			}
+
+			/* This pinned extent is out of our range */
+			if (start >= block_group->key.objectid +
+			    block_group->key.offset)
+				break;
+
+			len = block_group->key.objectid +
+				block_group->key.offset - start;
+			len = min(len, end + 1 - start);
+
+			entries++;
+			entry->offset = cpu_to_le64(start);
+			entry->bytes = cpu_to_le64(len);
+			entry->type = BTRFS_FREE_SPACE_EXTENT;
+
+			start = end + 1;
+			offset += sizeof(struct btrfs_free_space_entry);
+			if (offset + sizeof(struct btrfs_free_space_entry) >=
+			    PAGE_CACHE_SIZE)
+				next_page = true;
 			entry++;
 		}
 		*crc = ~(u32)0;
@@ -650,7 +724,7 @@ int btrfs_write_out_cache(struct btrfs_root *root,
 		page_cache_release(page);
 
 		index++;
-	} while (node);
+	} while (node || next_page);
 
 	/* Write out the bitmaps */
 	list_for_each_safe(pos, n, &bitmap_list) {
-- 
1.7.2.3

