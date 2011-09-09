From: jeffm@suse.com
Subject: [patch v3 03/23] btrfs: Push up set_extent_bit errors to callers
Date: Thu, 08 Sep 2011 20:22:43 -0400
Message-ID: <20110909002730.214195743@suse.com>
References: <20110909002240.141223014@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
To: btrfs list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

 In the locking case, set_extent_bit can return -EEXIST but callers
 already handle that.

 In the non-locking case, it can't fail. Memory allocation failures are
 handled by BUG_ON.

 This patch pushes up the BUG_ONs from set_extent_bit to callers, except
 where -ENOMEM can't occur (e.g. __GFP_WAIT && __GFP_NOFAIL).

 Update v2: Changed cases of BUG_ON(ret) to BUG_ON(ret < 0)

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c |   37 +++++++++++++++++++++++-----------
 fs/btrfs/extent_io.c   |   52 ++++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/file-item.c   |    3 +-
 fs/btrfs/inode.c       |   25 ++++++++++++++++-------
 fs/btrfs/ioctl.c       |    5 ++--
 fs/btrfs/relocation.c  |   21 ++++++++++++-------
 6 files changed, 99 insertions(+), 44 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -192,11 +192,14 @@ block_group_cache_tree_search(struct btr
 static int add_excluded_extent(struct btrfs_root *root,
 			       u64 start, u64 num_bytes)
 {
+	int ret;
 	u64 end = start + num_bytes - 1;
-	set_extent_bits(&root->fs_info->freed_extents[0],
-			start, end, EXTENT_UPTODATE, GFP_NOFS);
-	set_extent_bits(&root->fs_info->freed_extents[1],
-			start, end, EXTENT_UPTODATE, GFP_NOFS);
+	ret = set_extent_bits(&root->fs_info->freed_extents[0],
+			      start, end, EXTENT_UPTODATE, GFP_NOFS);
+	BUG_ON(ret < 0);
+	ret = set_extent_bits(&root->fs_info->freed_extents[1],
+			      start, end, EXTENT_UPTODATE, GFP_NOFS);
+	BUG_ON(ret < 0);
 	return 0;
 }
 
@@ -4142,8 +4145,9 @@ static int update_block_group(struct btr
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
 
-			set_extent_dirty(info->pinned_extents,
-					 bytenr, bytenr + num_bytes - 1,
+			/* Can't return -ENOMEM */
+			set_extent_dirty(info->pinned_extents, bytenr,
+					 bytenr + num_bytes - 1,
 					 GFP_NOFS | __GFP_NOFAIL);
 		}
 		btrfs_put_block_group(cache);
@@ -4184,6 +4188,7 @@ static int pin_down_extent(struct btrfs_
 	spin_unlock(&cache->lock);
 	spin_unlock(&cache->space_info->lock);
 
+	/* __GFP_NOFAIL means it can't return -ENOMEM */
 	set_extent_dirty(root->fs_info->pinned_extents, bytenr,
 			 bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
 	return 0;
@@ -5636,6 +5641,7 @@ struct extent_buffer *btrfs_init_new_buf
 					    int level)
 {
 	struct extent_buffer *buf;
+	int ret;
 
 	buf = btrfs_find_create_tree_block(root, bytenr, blocksize);
 	if (!buf)
@@ -5654,14 +5660,21 @@ struct extent_buffer *btrfs_init_new_buf
 		 * EXENT bit to differentiate dirty pages.
 		 */
 		if (root->log_transid % 2 == 0)
-			set_extent_dirty(&root->dirty_log_pages, buf->start,
-					buf->start + buf->len - 1, GFP_NOFS);
+			ret = set_extent_dirty(&root->dirty_log_pages,
+					       buf->start,
+					       buf->start + buf->len - 1,
+					       GFP_NOFS);
 		else
-			set_extent_new(&root->dirty_log_pages, buf->start,
-					buf->start + buf->len - 1, GFP_NOFS);
+			ret = set_extent_new(&root->dirty_log_pages,
+					     buf->start,
+					     buf->start + buf->len - 1,
+					     GFP_NOFS);
+		BUG_ON(ret < 0);
 	} else {
-		set_extent_dirty(&trans->transaction->dirty_pages, buf->start,
-			 buf->start + buf->len - 1, GFP_NOFS);
+		ret = set_extent_dirty(&trans->transaction->dirty_pages,
+				       buf->start, buf->start + buf->len - 1,
+				       GFP_NOFS);
+		BUG_ON(ret < 0);
 	}
 	trans->blocks_used++;
 	/* this returns a buffer locked for blocking */
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -703,6 +703,9 @@ static void uncache_state(struct extent_
  * part of the range already has the desired bits set.  The start of the
  * existing range is returned in failed_start in this case.
  *
+ * It may also fail with -ENOMEM if memory cannot be obtained for extent_state
+ * structures.
+ *
  * [start, end] is inclusive This takes the tree lock.
  */
 
@@ -721,7 +724,8 @@ int set_extent_bit(struct extent_io_tree
 again:
 	if (!prealloc && (mask & __GFP_WAIT)) {
 		prealloc = alloc_extent_state(mask);
-		BUG_ON(!prealloc);
+		if (!prealloc)
+			return -ENOMEM;
 	}
 
 	spin_lock(&tree->lock);
@@ -740,7 +744,11 @@ again:
 	node = tree_search(tree, start);
 	if (!node) {
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc) {
+			err = -ENOMEM;
+			goto out;
+		}
+
 		err = insert_state(tree, prealloc, start, end, &bits);
 		if (err)
 			btrfs_panic(tree_fs_info(tree), err, "Locking error: "
@@ -810,7 +818,11 @@ hit_next:
 		}
 
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc) {
+			err = -ENOMEM;
+			goto out;
+		}
+
 		err = split_state(tree, state, prealloc, start);
 		if (err)
 			btrfs_panic(tree_fs_info(tree), err, "Locking error: "
@@ -844,7 +856,10 @@ hit_next:
 			this_end = last_start - 1;
 
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc) {
+			err = -ENOMEM;
+			goto out;
+		}
 
 		/*
 		 * Avoid to free 'prealloc' if it can be merged with
@@ -876,7 +891,11 @@ hit_next:
 		}
 
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc) {
+			err = -ENOMEM;
+			goto out;
+		}
+
 		err = split_state(tree, state, prealloc, end + 1);
 		if (err)
 			btrfs_panic(tree_fs_info(tree), err, "Locking error: "
@@ -988,6 +1007,7 @@ int lock_extent_bits(struct extent_io_tr
 		}
 		WARN_ON(start > end);
 	}
+	BUG_ON(err < 0);
 	return err;
 }
 
@@ -1010,6 +1030,7 @@ int try_lock_extent(struct extent_io_tre
 					 EXTENT_LOCKED, 1, 0, NULL, mask);
 		return 0;
 	}
+	BUG_ON(err < 0);
 	return 1;
 }
 
@@ -1757,8 +1778,9 @@ static void end_bio_extent_readpage(stru
 		}
 
 		if (uptodate) {
-			set_extent_uptodate(tree, start, end, &cached,
-					    GFP_ATOMIC);
+			ret = set_extent_uptodate(tree, start, end, &cached,
+						  GFP_ATOMIC);
+			BUG_ON(ret < 0);
 		}
 		unlock_extent_cached(tree, start, end, &cached, GFP_ATOMIC);
 
@@ -1980,8 +2002,9 @@ static int __extent_read_full_page(struc
 			memset(userpage + pg_offset, 0, iosize);
 			flush_dcache_page(page);
 			kunmap_atomic(userpage, KM_USER0);
-			set_extent_uptodate(tree, cur, cur + iosize - 1,
-					    &cached, GFP_NOFS);
+			ret = set_extent_uptodate(tree, cur, cur + iosize - 1,
+						  &cached, GFP_NOFS);
+			BUG_ON(ret < 0);
 			unlock_extent_cached(tree, cur, cur + iosize - 1,
 					     &cached, GFP_NOFS);
 			break;
@@ -2030,8 +2053,9 @@ static int __extent_read_full_page(struc
 			flush_dcache_page(page);
 			kunmap_atomic(userpage, KM_USER0);
 
-			set_extent_uptodate(tree, cur, cur + iosize - 1,
-					    &cached, GFP_NOFS);
+			ret = set_extent_uptodate(tree, cur, cur + iosize - 1,
+						  &cached, GFP_NOFS);
+			BUG_ON(ret < 0);
 			unlock_extent_cached(tree, cur, cur + iosize - 1,
 			                     &cached, GFP_NOFS);
 			cur = cur + iosize;
@@ -3286,8 +3310,10 @@ int set_extent_buffer_uptodate(struct ex
 	num_pages = num_extent_pages(eb->start, eb->len);
 
 	if (eb_straddles_pages(eb)) {
-		set_extent_uptodate(tree, eb->start, eb->start + eb->len - 1,
-				    NULL, GFP_NOFS);
+		int ret = set_extent_uptodate(tree, eb->start,
+					      eb->start + eb->len - 1,
+					      NULL, GFP_NOFS);
+		BUG_ON(ret < 0);
 	}
 	for (i = 0; i < num_pages; i++) {
 		page = extent_buffer_page(eb, i);
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -212,9 +212,10 @@ static int __btrfs_lookup_bio_sums(struc
 				sum = 0;
 				if (BTRFS_I(inode)->root->root_key.objectid ==
 				    BTRFS_DATA_RELOC_TREE_OBJECTID) {
-					set_extent_bits(io_tree, offset,
+					ret = set_extent_bits(io_tree, offset,
 						offset + bvec->bv_len - 1,
 						EXTENT_NODATASUM, GFP_NOFS);
+					BUG_ON(ret < 0);
 				} else {
 					printk(KERN_INFO "btrfs no csum found "
 					       "for inode %llu start %llu\n",
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1548,6 +1548,7 @@ static void btrfs_writepage_fixup_worker
 	struct inode *inode;
 	u64 page_start;
 	u64 page_end;
+	int ret;
 
 	fixup = container_of(work, struct btrfs_writepage_fixup, work);
 	page = fixup->page;
@@ -1579,7 +1580,9 @@ again:
 	}
 
 	BUG();
-	btrfs_set_extent_delalloc(inode, page_start, page_end, &cached_state);
+	ret = btrfs_set_extent_delalloc(inode, page_start, page_end,
+					&cached_state);
+	BUG_ON(ret < 0);
 	ClearPageChecked(page);
 out:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, page_start, page_end,
@@ -1883,8 +1886,11 @@ static int btrfs_io_failed_hook(struct b
 		}
 		failrec->logical = logical;
 		free_extent_map(em);
-		set_extent_bits(failure_tree, start, end, EXTENT_LOCKED |
-				EXTENT_DIRTY, GFP_NOFS);
+
+		/* Doesn't this ignore locking failures? */
+		ret = set_extent_bits(failure_tree, start, end, EXTENT_LOCKED |
+				      EXTENT_DIRTY, GFP_NOFS);
+		BUG_ON(ret < 0);
 		set_state_private(failure_tree, start,
 				 (u64)(unsigned long)failrec);
 	} else {
@@ -5167,8 +5173,10 @@ again:
 			kunmap(page);
 			btrfs_mark_buffer_dirty(leaf);
 		}
-		set_extent_uptodate(io_tree, em->start,
-				    extent_map_end(em) - 1, NULL, GFP_NOFS);
+		ret = set_extent_uptodate(io_tree, em->start,
+					  extent_map_end(em) - 1,
+					  NULL, GFP_NOFS);
+		BUG_ON(ret < 0);
 		goto insert;
 	} else {
 		printk(KERN_ERR "btrfs unknown found_type %d\n", found_type);
@@ -6230,9 +6238,10 @@ static ssize_t btrfs_direct_IO(int rw, s
 	 */
 	if (writing) {
 		write_bits = EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING;
-		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
-				     EXTENT_DELALLOC, 0, NULL, &cached_state,
-				     GFP_NOFS);
+		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
+				     lockend, EXTENT_DELALLOC, 0, NULL,
+				     &cached_state, GFP_NOFS);
+		BUG_ON(ret < 0);
 		if (ret) {
 			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
 					 lockend, EXTENT_LOCKED | write_bits,
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -938,8 +938,9 @@ again:
 	}
 
 
-	btrfs_set_extent_delalloc(inode, page_start, page_end - 1,
-				  &cached_state);
+	ret = btrfs_set_extent_delalloc(inode, page_start, page_end - 1,
+					&cached_state);
+	BUG_ON(ret < 0);
 
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 			     page_start, page_end - 1, &cached_state,
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -2623,11 +2623,11 @@ static int finish_pending_nodes(struct b
 	return err;
 }
 
-static void mark_block_processed(struct reloc_control *rc,
+static int mark_block_processed(struct reloc_control *rc,
 				 u64 bytenr, u32 blocksize)
 {
-	set_extent_bits(&rc->processed_blocks, bytenr, bytenr + blocksize - 1,
-			EXTENT_DIRTY, GFP_NOFS);
+	return set_extent_bits(&rc->processed_blocks, bytenr,
+			       bytenr + blocksize - 1, EXTENT_DIRTY, GFP_NOFS);
 }
 
 static void __mark_block_processed(struct reloc_control *rc,
@@ -2636,8 +2636,10 @@ static void __mark_block_processed(struc
 	u32 blocksize;
 	if (node->level == 0 ||
 	    in_block_group(node->bytenr, rc->block_group)) {
+		int ret;
 		blocksize = btrfs_level_size(rc->extent_root, node->level);
-		mark_block_processed(rc, node->bytenr, blocksize);
+		ret = mark_block_processed(rc, node->bytenr, blocksize);
+		BUG_ON(ret < 0);
 	}
 	node->processed = 1;
 }
@@ -2994,13 +2996,16 @@ static int relocate_file_extent_cluster(
 
 		if (nr < cluster->nr &&
 		    page_start + offset == cluster->boundary[nr]) {
-			set_extent_bits(&BTRFS_I(inode)->io_tree,
-					page_start, page_end,
-					EXTENT_BOUNDARY, GFP_NOFS);
+			ret = set_extent_bits(&BTRFS_I(inode)->io_tree,
+					      page_start, page_end,
+					      EXTENT_BOUNDARY, GFP_NOFS);
+			BUG_ON(ret < 0);
 			nr++;
 		}
 
-		btrfs_set_extent_delalloc(inode, page_start, page_end, NULL);
+		ret = btrfs_set_extent_delalloc(inode, page_start,
+						page_end, NULL);
+		BUG_ON(ret < 0);
 		set_page_dirty(page);
 
 		unlock_extent(&BTRFS_I(inode)->io_tree,


