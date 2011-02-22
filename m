From: Chris Mason <chris.mason@oracle.com>
Subject: [PATCH] rework btrfs fiemap (please review)
Date: Mon, 21 Feb 2011 22:19:09 -0500
Message-ID: <1298344202-sup-6780@think>
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

Looks like the latest versions of cp use fiemap to decide if a file is
sparse, which is a great way to avoid doing memcmp, but only if your
fiemap is really accurate about which ranges in the file have holes.

Our fiemap tends to return holes for delalloc bytes, and has a few other
bugs along the way.  The end result is a bunch of zeros instead of good
data when you copy the file.

This reworks the code a lot more than I had planned.  The goal was a
simple patch that checks for delalloc ranges after calling the
get_extent() code.  But I hit some problems, mostly because the
btrfs_get_extent code needed to be reordered a little.  It was
intermixing use of the saved values from the previous extent with tests
on the new extent.

I think this is right, but I'd love some extra eyes on the code.  I'm
hoping to fix this before .38 goes out.

It uses a modified count_range-bits() which looks for contiguous ranges,
and then adds a new btrfs_get_extent_fiemap which looks for delalloc
ranges.

-chris

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 92ac519..1a0ebe0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1433,12 +1433,13 @@ int extent_clear_unlock_delalloc(struct inode *inode,
  */
 u64 count_range_bits(struct extent_io_tree *tree,
 		     u64 *start, u64 search_end, u64 max_bytes,
-		     unsigned long bits)
+		     unsigned long bits, int contig)
 {
 	struct rb_node *node;
 	struct extent_state *state;
 	u64 cur_start = *start;
 	u64 total_bytes = 0;
+	u64 last = 0;
 	int found = 0;
 
 	if (search_end <= cur_start) {
@@ -1463,7 +1464,9 @@ u64 count_range_bits(struct extent_io_tree *tree,
 		state = rb_entry(node, struct extent_state, rb_node);
 		if (state->start > search_end)
 			break;
-		if (state->end >= cur_start && (state->state & bits)) {
+		if (contig && found && state->start > last + 1)
+			break;
+		if (state->end >= cur_start && (state->state & bits) == bits) {
 			total_bytes += min(search_end, state->end) + 1 -
 				       max(cur_start, state->start);
 			if (total_bytes >= max_bytes)
@@ -1472,6 +1475,9 @@ u64 count_range_bits(struct extent_io_tree *tree,
 				*start = state->start;
 				found = 1;
 			}
+			last = state->end;
+		} else if (contig && found) {
+			break;
 		}
 		node = rb_next(node);
 		if (!node)
@@ -2922,6 +2928,7 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	u32 found_type;
 	u64 last;
 	u64 disko = 0;
+	u64 isize = i_size_read(inode);
 	struct btrfs_key found_key;
 	struct extent_map *em = NULL;
 	struct extent_state *cached_state = NULL;
@@ -2940,6 +2947,10 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		return -ENOMEM;
 	path->leave_spinning = 1;
 
+	/*
+	 * lookup the last file extent.  We're not using i_size here
+	 * because there might be preallocation past i_size
+	 */
 	ret = btrfs_lookup_file_extent(NULL, BTRFS_I(inode)->root,
 				       path, inode->i_ino, -1, 0);
 	if (ret < 0) {
@@ -2953,15 +2964,28 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	btrfs_item_key_to_cpu(path->nodes[0], &found_key, path->slots[0]);
 	found_type = btrfs_key_type(&found_key);
 
-	/* No extents, just return */
+	/* No extents, but there might be delalloc bits */
 	if (found_key.objectid != inode->i_ino ||
 	    found_type != BTRFS_EXTENT_DATA_KEY) {
-		btrfs_free_path(path);
-		return 0;
+		/* have to trust i_size as the end */
+		last = (u64)-1;
+	} else {
+		/*
+		 * remember the start of the last extent.  There are a
+		 * bunch of different factors that go into the length of the
+		 * extent, so its much less complex to remember where it started
+		 */
+		last = found_key.offset;
 	}
-	last = found_key.offset;
 	btrfs_free_path(path);
 
+	/*
+	 * we might have some extents allocated but more delalloc past those extents.
+	 * so, we trust isize unless the start of the last extent is beyond isize
+	 */
+	if (last < isize)
+		last = (u64)-1;
+
 	lock_extent_bits(&BTRFS_I(inode)->io_tree, start, start + len, 0,
 			 &cached_state, GFP_NOFS);
 	em = get_extent(inode, NULL, 0, off, max - off, 0);
@@ -2978,18 +3002,15 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		if (off >= max)
 			end = 1;
 
-		if (em->block_start == EXTENT_MAP_HOLE) {
-			hole = 1;
-			goto next;
-		}
-
 		em_start = em->start;
 		em_len = em->len;
-
+		emflags = em->flags;
 		disko = 0;
 		flags = 0;
 
-		if (em->block_start == EXTENT_MAP_LAST_BYTE) {
+		if (em->block_start == EXTENT_MAP_HOLE) {
+			hole = 1;
+		} else if (em->block_start == EXTENT_MAP_LAST_BYTE) {
 			end = 1;
 			flags |= FIEMAP_EXTENT_LAST;
 		} else if (em->block_start == EXTENT_MAP_INLINE) {
@@ -3004,37 +3025,29 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags))
 			flags |= FIEMAP_EXTENT_ENCODED;
 
-next:
-		emflags = em->flags;
 		free_extent_map(em);
 		em = NULL;
-		if (!end) {
-			em = get_extent(inode, NULL, 0, off, max - off, 0);
-			if (!em)
-				goto out;
-			if (IS_ERR(em)) {
-				ret = PTR_ERR(em);
-				goto out;
-			}
-			emflags = em->flags;
-		}
-
-		if (test_bit(EXTENT_FLAG_VACANCY, &emflags)) {
-			flags |= FIEMAP_EXTENT_LAST;
-			end = 1;
-		}
-
-		if (em_start == last) {
+		if (test_bit(EXTENT_FLAG_VACANCY, &emflags) ||
+		   (em_start == last) || em_len == (u64)-1 ||
+		   (last == (u64)-1 && isize <= em_start + em_len)) {
 			flags |= FIEMAP_EXTENT_LAST;
 			end = 1;
 		}
-
 		if (!hole) {
 			ret = fiemap_fill_next_extent(fieinfo, em_start, disko,
 						em_len, flags);
 			if (ret)
 				goto out_free;
 		}
+		if (!end) {
+			em = get_extent(inode, NULL, 0, off, max - off, 0);
+			if (!em)
+				goto out;
+			if (IS_ERR(em)) {
+				ret = PTR_ERR(em);
+				goto out;
+			}
+		}
 	}
 out_free:
 	free_extent_map(em);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 7083cfa..9318dfe 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -191,7 +191,7 @@ void extent_io_exit(void);
 
 u64 count_range_bits(struct extent_io_tree *tree,
 		     u64 *start, u64 search_end,
-		     u64 max_bytes, unsigned long bits);
+		     u64 max_bytes, unsigned long bits, int contig);
 
 void free_extent_state(struct extent_state *state);
 int test_range_bit(struct extent_io_tree *tree, u64 start, u64 end,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index fb9bd78..0efdb65 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1913,7 +1913,7 @@ static int btrfs_clean_io_failures(struct inode *inode, u64 start)
 
 	private = 0;
 	if (count_range_bits(&BTRFS_I(inode)->io_failure_tree, &private,
-			     (u64)-1, 1, EXTENT_DIRTY)) {
+			     (u64)-1, 1, EXTENT_DIRTY, 0)) {
 		ret = get_state_private(&BTRFS_I(inode)->io_failure_tree,
 					start, &private_failure);
 		if (ret == 0) {
@@ -5280,6 +5280,128 @@ out:
 	return em;
 }
 
+struct extent_map *btrfs_get_extent_fiemap(struct inode *inode, struct page *page,
+					   size_t pg_offset, u64 start, u64 len,
+					   int create)
+{
+	struct extent_map *em;
+	struct extent_map *hole_em = NULL;
+	u64 range_start = start;
+	u64 end;
+	u64 found;
+	u64 found_end;
+	int err = 0;
+
+	em = btrfs_get_extent(inode, page, pg_offset, start, len, create);
+	if (IS_ERR(em))
+		return em;
+	if (em) {
+		/*
+		 * if our em maps to a hole, there might
+		 * actually be delalloc bytes behind it
+		 */
+		if (em->block_start != EXTENT_MAP_HOLE)
+			return em;
+		else
+			hole_em = em;
+	}
+
+	/* check to see if we've wrapped (len == -1 or similar) */
+	end = start + len;
+	if (end < start)
+		end = (u64)-1;
+	else
+		end -= 1;
+
+	em = NULL;
+
+	/* ok, we didn't find anything, lets look for delalloc */
+	found = count_range_bits(&BTRFS_I(inode)->io_tree, &range_start,
+				 end, len, EXTENT_DELALLOC, 1);
+	found_end = range_start + found;
+	if (found_end < range_start)
+		found_end = (u64)-1;
+
+	/*
+	 * we didn't find anything useful, return
+	 * the original results from get_extent()
+	 */
+	if (range_start > end || found_end <= start) {
+		em = hole_em;
+		hole_em = NULL;
+		goto out;
+	}
+
+	/* adjust the range_start to make sure it doesn't
+	 * go backwards from the start they passed in
+	 */
+	range_start = max(start,range_start);
+	found = found_end - range_start;
+
+	if (found > 0) {
+		u64 hole_start = start;
+		u64 hole_len = len;
+
+		em = alloc_extent_map(GFP_NOFS);
+		if (!em) {
+			err = -ENOMEM;
+			goto out;
+		}
+		/*
+		 * when btrfs_get_extent can't find anything it
+		 * returns one huge hole
+		 *
+		 * make sure what it found really fits our range, and
+		 * adjust to make sure it is based on the start from
+		 * the caller
+		 */
+		if (hole_em) {
+			u64 calc_end = extent_map_end(hole_em);
+
+			if (calc_end <= start || (hole_em->start > end)) {
+				free_extent_map(hole_em);
+				hole_em = NULL;
+			} else {
+				hole_start = max(hole_em->start, start);
+				hole_len = calc_end - hole_start;
+			}
+		}
+		em->bdev = NULL;
+		if (hole_em && range_start > hole_start) {
+			/* our hole starts before our delalloc, so we
+			 * have to return just the parts of the hole
+			 * that go until  the delalloc starts
+			 */
+			em->len = min(hole_len,
+				      range_start - hole_start);
+			em->start = hole_start;
+			em->orig_start = hole_start;
+			/*
+			 * don't adjust block start at all,
+			 * it is fixed at EXTENT_MAP_HOLE
+			 */
+			em->block_start = hole_em->block_start;
+			em->block_len = hole_len;
+		} else {
+			em->start = range_start;
+			em->len = found;
+			em->orig_start = range_start;
+			em->block_start = EXTENT_MAP_DELALLOC;
+			em->block_len = found;
+		}
+	} else if (hole_em) {
+		return hole_em;
+	}
+out:
+
+	free_extent_map(hole_em);
+	if (err) {
+		free_extent_map(em);
+		return ERR_PTR(err);
+	}
+	return em;
+}
+
 static struct extent_map *btrfs_new_extent_direct(struct inode *inode,
 						  u64 start, u64 len)
 {
@@ -6102,7 +6224,7 @@ out:
 static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len)
 {
-	return extent_fiemap(inode, fieinfo, start, len, btrfs_get_extent);
+	return extent_fiemap(inode, fieinfo, start, len, btrfs_get_extent_fiemap);
 }
 
 int btrfs_readpage(struct file *file, struct page *page)
