From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] rework btrfs fiemap (please review)
Date: Tue, 22 Feb 2011 22:29:17 -0500
Message-ID: <1298431616-sup-9316@think>
References: <1298344202-sup-6780@think>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1298344202-sup-6780@think>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Chris Mason's message of 2011-02-21 22:19:09 -0500:
> Hi everyone,
> 
> Looks like the latest versions of cp use fiemap to decide if a file is
> sparse, which is a great way to avoid doing memcmp, but only if your
> fiemap is really accurate about which ranges in the file have holes.

Josef and I were talking this over today, and I wasn't quite handling
the last extent in the file correctly.  The fiemap interface expects us
to mark the last extent, but it doesn't want to know about holes.

This means we need to search forward when we find a hole and see if
there are any extents past it.

So, here's a slightly bigger patch that makes things less complex.  It
adds a helper to search forward through holes.

-chris

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 92ac519..fd3f172 100644
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
@@ -2912,6 +2918,46 @@ out:
 	return sector;
 }
 
+/*
+ * helper function for fiemap, which doesn't want to see any holes.
+ * This maps until we find something past 'last'
+ */
+static struct extent_map *get_extent_skip_holes(struct inode *inode,
+						u64 offset,
+						u64 last,
+						get_extent_t *get_extent)
+{
+	u64 sectorsize = BTRFS_I(inode)->root->sectorsize;
+	struct extent_map *em;
+	u64 len;
+
+	if (offset >= last)
+		return NULL;
+
+	while(1) {
+		len = last - offset;
+		if (len == 0)
+			break;
+		len = (len + sectorsize - 1) & ~(sectorsize - 1);
+		em = get_extent(inode, NULL, 0, offset, len, 0);
+		if (!em || IS_ERR(em))
+			return em;
+
+		/* if this isn't a hole return it */
+		if (!test_bit(EXTENT_FLAG_VACANCY, &em->flags) &&
+		    em->block_start != EXTENT_MAP_HOLE) {
+			return em;
+		}
+
+		/* this is a hole, advance to the next extent */
+		offset = extent_map_end(em);
+		free_extent_map(em);
+		if (offset >= last)
+			break;
+	}
+	return NULL;
+}
+
 int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len, get_extent_t *get_extent)
 {
@@ -2921,16 +2967,19 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	u32 flags = 0;
 	u32 found_type;
 	u64 last;
+	u64 last_for_get_extent = 0;
 	u64 disko = 0;
+	u64 isize = i_size_read(inode);
 	struct btrfs_key found_key;
 	struct extent_map *em = NULL;
 	struct extent_state *cached_state = NULL;
 	struct btrfs_path *path;
 	struct btrfs_file_extent_item *item;
 	int end = 0;
-	u64 em_start = 0, em_len = 0;
+	u64 em_start = 0;
+	u64 em_len = 0;
+	u64 em_end = 0;
 	unsigned long emflags;
-	int hole = 0;
 
 	if (len == 0)
 		return -EINVAL;
@@ -2940,6 +2989,10 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		return -ENOMEM;
 	path->leave_spinning = 1;
 
+	/*
+	 * lookup the last file extent.  We're not using i_size here
+	 * because there might be preallocation past i_size
+	 */
 	ret = btrfs_lookup_file_extent(NULL, BTRFS_I(inode)->root,
 				       path, inode->i_ino, -1, 0);
 	if (ret < 0) {
@@ -2953,18 +3006,38 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
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
+		last_for_get_extent = isize;
+	} else {
+		/*
+		 * remember the start of the last extent.  There are a
+		 * bunch of different factors that go into the length of the
+		 * extent, so its much less complex to remember where it started
+		 */
+		last = found_key.offset;
+		last_for_get_extent = last + 1;
 	}
-	last = found_key.offset;
 	btrfs_free_path(path);
 
+	/*
+	 * we might have some extents allocated but more delalloc past those
+	 * extents.  so, we trust isize unless the start of the last extent is
+	 * beyond isize
+	 */
+	if (last < isize) {
+		last = (u64)-1;
+		last_for_get_extent = isize;
+	}
+
 	lock_extent_bits(&BTRFS_I(inode)->io_tree, start, start + len, 0,
 			 &cached_state, GFP_NOFS);
-	em = get_extent(inode, NULL, 0, off, max - off, 0);
+
+	em = get_extent_skip_holes(inode, off, last_for_get_extent,
+				   get_extent);
 	if (!em)
 		goto out;
 	if (IS_ERR(em)) {
@@ -2973,19 +3046,14 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	}
 
 	while (!end) {
-		hole = 0;
-		off = em->start + em->len;
+		off = extent_map_end(em);
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
+		em_end = extent_map_end(em);
+		emflags = em->flags;
 		disko = 0;
 		flags = 0;
 
@@ -3004,37 +3072,29 @@ int extent_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
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
+		if ((em_start >= last) || em_len == (u64)-1 ||
+		   (last == (u64)-1 && isize <= em_end)) {
 			flags |= FIEMAP_EXTENT_LAST;
 			end = 1;
 		}
 
-		if (em_start == last) {
+		/* now scan forward to see if this is really the last extent. */
+		em = get_extent_skip_holes(inode, off, last_for_get_extent,
+					   get_extent);
+		if (IS_ERR(em)) {
+			ret = PTR_ERR(em);
+			goto out;
+		}
+		if (!em) {
 			flags |= FIEMAP_EXTENT_LAST;
 			end = 1;
 		}
-
-		if (!hole) {
-			ret = fiemap_fill_next_extent(fieinfo, em_start, disko,
-						em_len, flags);
-			if (ret)
-				goto out_free;
-		}
+		ret = fiemap_fill_next_extent(fieinfo, em_start, disko,
+					      em_len, flags);
+		if (ret)
+			goto out_free;
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
