From: Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 1/2] stop using highmem for extent_buffers
Date: Tue, 19 Jul 2011 13:32:35 -0400
Message-ID: <1311096700-sup-8175@shiny>
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I haven't yet tested this on x86-32, if someone is willing to try this
on non-critical test machines I'd appreciate it.

---------------------------------------------------------
The extent_buffers have a very complex interface where
we use HIGHMEM for metadata and try to cache a kmap mapping
to access the memory.

The next commit adds reader/writer locks, and concurrent use
of this kmap cache would make it even more complex.

This commit drops the ability to use HIGHMEM with extent buffers,
and rips out all of the related code.

Signed-off-by: Chris Mason <chris.mason@oracle.com>

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index fbd48e9..8c83c88 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -626,14 +626,6 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 	for (i = start_slot; i < end_slot; i++) {
 		int close = 1;
 
-		if (!parent->map_token) {
-			map_extent_buffer(parent,
-					btrfs_node_key_ptr_offset(i),
-					sizeof(struct btrfs_key_ptr),
-					&parent->map_token, &parent->kaddr,
-					&parent->map_start, &parent->map_len,
-					KM_USER1);
-		}
 		btrfs_node_key(parent, &disk_key, i);
 		if (!progress_passed && comp_keys(&disk_key, progress) < 0)
 			continue;
@@ -656,11 +648,6 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 			last_block = blocknr;
 			continue;
 		}
-		if (parent->map_token) {
-			unmap_extent_buffer(parent, parent->map_token,
-					    KM_USER1);
-			parent->map_token = NULL;
-		}
 
 		cur = btrfs_find_tree_block(root, blocknr, blocksize);
 		if (cur)
@@ -701,11 +688,6 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 		btrfs_tree_unlock(cur);
 		free_extent_buffer(cur);
 	}
-	if (parent->map_token) {
-		unmap_extent_buffer(parent, parent->map_token,
-				    KM_USER1);
-		parent->map_token = NULL;
-	}
 	return err;
 }
 
@@ -746,7 +728,6 @@ static noinline int generic_bin_search(struct extent_buffer *eb,
 	struct btrfs_disk_key *tmp = NULL;
 	struct btrfs_disk_key unaligned;
 	unsigned long offset;
-	char *map_token = NULL;
 	char *kaddr = NULL;
 	unsigned long map_start = 0;
 	unsigned long map_len = 0;
@@ -756,18 +737,13 @@ static noinline int generic_bin_search(struct extent_buffer *eb,
 		mid = (low + high) / 2;
 		offset = p + mid * item_size;
 
-		if (!map_token || offset < map_start ||
+		if (!kaddr || offset < map_start ||
 		    (offset + sizeof(struct btrfs_disk_key)) >
 		    map_start + map_len) {
-			if (map_token) {
-				unmap_extent_buffer(eb, map_token, KM_USER0);
-				map_token = NULL;
-			}
 
 			err = map_private_extent_buffer(eb, offset,
 						sizeof(struct btrfs_disk_key),
-						&map_token, &kaddr,
-						&map_start, &map_len, KM_USER0);
+						&kaddr, &map_start, &map_len);
 
 			if (!err) {
 				tmp = (struct btrfs_disk_key *)(kaddr + offset -
@@ -790,14 +766,10 @@ static noinline int generic_bin_search(struct extent_buffer *eb,
 			high = mid;
 		else {
 			*slot = mid;
-			if (map_token)
-				unmap_extent_buffer(eb, map_token, KM_USER0);
 			return 0;
 		}
 	}
 	*slot = low;
-	if (map_token)
-		unmap_extent_buffer(eb, map_token, KM_USER0);
 	return 1;
 }
 
@@ -1228,7 +1200,6 @@ static void reada_for_search(struct btrfs_root *root,
 	u32 nr;
 	u32 blocksize;
 	u32 nscan = 0;
-	bool map = true;
 
 	if (level != 1)
 		return;
@@ -1250,19 +1221,8 @@ static void reada_for_search(struct btrfs_root *root,
 
 	nritems = btrfs_header_nritems(node);
 	nr = slot;
-	if (node->map_token || path->skip_locking)
-		map = false;
 
 	while (1) {
-		if (map && !node->map_token) {
-			unsigned long offset = btrfs_node_key_ptr_offset(nr);
-			map_private_extent_buffer(node, offset,
-						  sizeof(struct btrfs_key_ptr),
-						  &node->map_token,
-						  &node->kaddr,
-						  &node->map_start,
-						  &node->map_len, KM_USER1);
-		}
 		if (direction < 0) {
 			if (nr == 0)
 				break;
@@ -1281,11 +1241,6 @@ static void reada_for_search(struct btrfs_root *root,
 		if ((search <= target && target - search <= 65536) ||
 		    (search > target && search - target <= 65536)) {
 			gen = btrfs_node_ptr_generation(node, nr);
-			if (map && node->map_token) {
-				unmap_extent_buffer(node, node->map_token,
-						    KM_USER1);
-				node->map_token = NULL;
-			}
 			readahead_tree_block(root, search, blocksize, gen);
 			nread += blocksize;
 		}
@@ -1293,10 +1248,6 @@ static void reada_for_search(struct btrfs_root *root,
 		if ((nread > 65536 || nscan > 32))
 			break;
 	}
-	if (map && node->map_token) {
-		unmap_extent_buffer(node, node->map_token, KM_USER1);
-		node->map_token = NULL;
-	}
 }
 
 /*
@@ -2253,14 +2204,6 @@ static noinline int __push_leaf_right(struct btrfs_trans_handle *trans,
 		if (path->slots[0] == i)
 			push_space += data_size;
 
-		if (!left->map_token) {
-			map_extent_buffer(left, (unsigned long)item,
-					sizeof(struct btrfs_item),
-					&left->map_token, &left->kaddr,
-					&left->map_start, &left->map_len,
-					KM_USER1);
-		}
-
 		this_item_size = btrfs_item_size(left, item);
 		if (this_item_size + sizeof(*item) + push_space > free_space)
 			break;
@@ -2271,10 +2214,6 @@ static noinline int __push_leaf_right(struct btrfs_trans_handle *trans,
 			break;
 		i--;
 	}
-	if (left->map_token) {
-		unmap_extent_buffer(left, left->map_token, KM_USER1);
-		left->map_token = NULL;
-	}
 
 	if (push_items == 0)
 		goto out_unlock;
@@ -2316,21 +2255,10 @@ static noinline int __push_leaf_right(struct btrfs_trans_handle *trans,
 	push_space = BTRFS_LEAF_DATA_SIZE(root);
 	for (i = 0; i < right_nritems; i++) {
 		item = btrfs_item_nr(right, i);
-		if (!right->map_token) {
-			map_extent_buffer(right, (unsigned long)item,
-					sizeof(struct btrfs_item),
-					&right->map_token, &right->kaddr,
-					&right->map_start, &right->map_len,
-					KM_USER1);
-		}
 		push_space -= btrfs_item_size(right, item);
 		btrfs_set_item_offset(right, item, push_space);
 	}
 
-	if (right->map_token) {
-		unmap_extent_buffer(right, right->map_token, KM_USER1);
-		right->map_token = NULL;
-	}
 	left_nritems -= push_items;
 	btrfs_set_header_nritems(left, left_nritems);
 
@@ -2467,13 +2395,6 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 
 	for (i = 0; i < nr; i++) {
 		item = btrfs_item_nr(right, i);
-		if (!right->map_token) {
-			map_extent_buffer(right, (unsigned long)item,
-					sizeof(struct btrfs_item),
-					&right->map_token, &right->kaddr,
-					&right->map_start, &right->map_len,
-					KM_USER1);
-		}
 
 		if (!empty && push_items > 0) {
 			if (path->slots[0] < i)
@@ -2496,11 +2417,6 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 		push_space += this_item_size + sizeof(*item);
 	}
 
-	if (right->map_token) {
-		unmap_extent_buffer(right, right->map_token, KM_USER1);
-		right->map_token = NULL;
-	}
-
 	if (push_items == 0) {
 		ret = 1;
 		goto out;
@@ -2530,23 +2446,12 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 		u32 ioff;
 
 		item = btrfs_item_nr(left, i);
-		if (!left->map_token) {
-			map_extent_buffer(left, (unsigned long)item,
-					sizeof(struct btrfs_item),
-					&left->map_token, &left->kaddr,
-					&left->map_start, &left->map_len,
-					KM_USER1);
-		}
 
 		ioff = btrfs_item_offset(left, item);
 		btrfs_set_item_offset(left, item,
 		      ioff - (BTRFS_LEAF_DATA_SIZE(root) - old_left_item_size));
 	}
 	btrfs_set_header_nritems(left, old_left_nritems + push_items);
-	if (left->map_token) {
-		unmap_extent_buffer(left, left->map_token, KM_USER1);
-		left->map_token = NULL;
-	}
 
 	/* fixup right node */
 	if (push_items > right_nritems) {
@@ -2574,21 +2479,9 @@ static noinline int __push_leaf_left(struct btrfs_trans_handle *trans,
 	for (i = 0; i < right_nritems; i++) {
 		item = btrfs_item_nr(right, i);
 
-		if (!right->map_token) {
-			map_extent_buffer(right, (unsigned long)item,
-					sizeof(struct btrfs_item),
-					&right->map_token, &right->kaddr,
-					&right->map_start, &right->map_len,
-					KM_USER1);
-		}
-
 		push_space = push_space - btrfs_item_size(right, item);
 		btrfs_set_item_offset(right, item, push_space);
 	}
-	if (right->map_token) {
-		unmap_extent_buffer(right, right->map_token, KM_USER1);
-		right->map_token = NULL;
-	}
 
 	btrfs_mark_buffer_dirty(left);
 	if (right_nritems)
@@ -2729,23 +2622,10 @@ static noinline int copy_for_split(struct btrfs_trans_handle *trans,
 		struct btrfs_item *item = btrfs_item_nr(right, i);
 		u32 ioff;
 
-		if (!right->map_token) {
-			map_extent_buffer(right, (unsigned long)item,
-					sizeof(struct btrfs_item),
-					&right->map_token, &right->kaddr,
-					&right->map_start, &right->map_len,
-					KM_USER1);
-		}
-
 		ioff = btrfs_item_offset(right, item);
 		btrfs_set_item_offset(right, item, ioff + rt_data_off);
 	}
 
-	if (right->map_token) {
-		unmap_extent_buffer(right, right->map_token, KM_USER1);
-		right->map_token = NULL;
-	}
-
 	btrfs_set_header_nritems(l, mid);
 	ret = 0;
 	btrfs_item_key(right, &disk_key, 0);
@@ -3264,23 +3144,10 @@ int btrfs_truncate_item(struct btrfs_trans_handle *trans,
 		u32 ioff;
 		item = btrfs_item_nr(leaf, i);
 
-		if (!leaf->map_token) {
-			map_extent_buffer(leaf, (unsigned long)item,
-					sizeof(struct btrfs_item),
-					&leaf->map_token, &leaf->kaddr,
-					&leaf->map_start, &leaf->map_len,
-					KM_USER1);
-		}
-
 		ioff = btrfs_item_offset(leaf, item);
 		btrfs_set_item_offset(leaf, item, ioff + size_diff);
 	}
 
-	if (leaf->map_token) {
-		unmap_extent_buffer(leaf, leaf->map_token, KM_USER1);
-		leaf->map_token = NULL;
-	}
-
 	/* shift the data */
 	if (from_end) {
 		memmove_extent_buffer(leaf, btrfs_leaf_data(leaf) +
@@ -3377,22 +3244,10 @@ int btrfs_extend_item(struct btrfs_trans_handle *trans,
 		u32 ioff;
 		item = btrfs_item_nr(leaf, i);
 
-		if (!leaf->map_token) {
-			map_extent_buffer(leaf, (unsigned long)item,
-					sizeof(struct btrfs_item),
-					&leaf->map_token, &leaf->kaddr,
-					&leaf->map_start, &leaf->map_len,
-					KM_USER1);
-		}
 		ioff = btrfs_item_offset(leaf, item);
 		btrfs_set_item_offset(leaf, item, ioff - data_size);
 	}
 
-	if (leaf->map_token) {
-		unmap_extent_buffer(leaf, leaf->map_token, KM_USER1);
-		leaf->map_token = NULL;
-	}
-
 	/* shift the data */
 	memmove_extent_buffer(leaf, btrfs_leaf_data(leaf) +
 		      data_end - data_size, btrfs_leaf_data(leaf) +
@@ -3494,27 +3349,13 @@ int btrfs_insert_some_items(struct btrfs_trans_handle *trans,
 		 * item0..itemN ... dataN.offset..dataN.size .. data0.size
 		 */
 		/* first correct the data pointers */
-		WARN_ON(leaf->map_token);
 		for (i = slot; i < nritems; i++) {
 			u32 ioff;
 
 			item = btrfs_item_nr(leaf, i);
-			if (!leaf->map_token) {
-				map_extent_buffer(leaf, (unsigned long)item,
-					sizeof(struct btrfs_item),
-					&leaf->map_token, &leaf->kaddr,
-					&leaf->map_start, &leaf->map_len,
-					KM_USER1);
-			}
-
 			ioff = btrfs_item_offset(leaf, item);
 			btrfs_set_item_offset(leaf, item, ioff - total_data);
 		}
-		if (leaf->map_token) {
-			unmap_extent_buffer(leaf, leaf->map_token, KM_USER1);
-			leaf->map_token = NULL;
-		}
-
 		/* shift the items */
 		memmove_extent_buffer(leaf, btrfs_item_nr_offset(slot + nr),
 			      btrfs_item_nr_offset(slot),
@@ -3608,27 +3449,13 @@ int setup_items_for_insert(struct btrfs_trans_handle *trans,
 		 * item0..itemN ... dataN.offset..dataN.size .. data0.size
 		 */
 		/* first correct the data pointers */
-		WARN_ON(leaf->map_token);
 		for (i = slot; i < nritems; i++) {
 			u32 ioff;
 
 			item = btrfs_item_nr(leaf, i);
-			if (!leaf->map_token) {
-				map_extent_buffer(leaf, (unsigned long)item,
-					sizeof(struct btrfs_item),
-					&leaf->map_token, &leaf->kaddr,
-					&leaf->map_start, &leaf->map_len,
-					KM_USER1);
-			}
-
 			ioff = btrfs_item_offset(leaf, item);
 			btrfs_set_item_offset(leaf, item, ioff - total_data);
 		}
-		if (leaf->map_token) {
-			unmap_extent_buffer(leaf, leaf->map_token, KM_USER1);
-			leaf->map_token = NULL;
-		}
-
 		/* shift the items */
 		memmove_extent_buffer(leaf, btrfs_item_nr_offset(slot + nr),
 			      btrfs_item_nr_offset(slot),
@@ -3840,22 +3667,10 @@ int btrfs_del_items(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			u32 ioff;
 
 			item = btrfs_item_nr(leaf, i);
-			if (!leaf->map_token) {
-				map_extent_buffer(leaf, (unsigned long)item,
-					sizeof(struct btrfs_item),
-					&leaf->map_token, &leaf->kaddr,
-					&leaf->map_start, &leaf->map_len,
-					KM_USER1);
-			}
 			ioff = btrfs_item_offset(leaf, item);
 			btrfs_set_item_offset(leaf, item, ioff + dsize);
 		}
 
-		if (leaf->map_token) {
-			unmap_extent_buffer(leaf, leaf->map_token, KM_USER1);
-			leaf->map_token = NULL;
-		}
-
 		memmove_extent_buffer(leaf, btrfs_item_nr_offset(slot),
 			      btrfs_item_nr_offset(slot + nr),
 			      sizeof(struct btrfs_item) *
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0245cad..288d522 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -217,7 +217,6 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 	unsigned long len;
 	unsigned long cur_len;
 	unsigned long offset = BTRFS_CSUM_SIZE;
-	char *map_token = NULL;
 	char *kaddr;
 	unsigned long map_start;
 	unsigned long map_len;
@@ -228,8 +227,7 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 	len = buf->len - offset;
 	while (len > 0) {
 		err = map_private_extent_buffer(buf, offset, 32,
-					&map_token, &kaddr,
-					&map_start, &map_len, KM_USER0);
+					&kaddr, &map_start, &map_len);
 		if (err)
 			return 1;
 		cur_len = min(len, map_len - (offset - map_start));
@@ -237,7 +235,6 @@ static int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 				      crc, cur_len);
 		len -= cur_len;
 		offset += cur_len;
-		unmap_extent_buffer(buf, map_token, KM_USER0);
 	}
 	if (csum_size > sizeof(inline_result)) {
 		result = kzalloc(csum_size * sizeof(char), GFP_NOFS);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 89bbde4..20f24f1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3487,9 +3487,8 @@ void read_extent_buffer(struct extent_buffer *eb, void *dstv,
 		page = extent_buffer_page(eb, i);
 
 		cur = min(len, (PAGE_CACHE_SIZE - offset));
-		kaddr = kmap_atomic(page, KM_USER1);
+		kaddr = page_address(page);
 		memcpy(dst, kaddr + offset, cur);
-		kunmap_atomic(kaddr, KM_USER1);
 
 		dst += cur;
 		len -= cur;
@@ -3499,9 +3498,9 @@ void read_extent_buffer(struct extent_buffer *eb, void *dstv,
 }
 
 int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
-			       unsigned long min_len, char **token, char **map,
+			       unsigned long min_len, char **map,
 			       unsigned long *map_start,
-			       unsigned long *map_len, int km)
+			       unsigned long *map_len)
 {
 	size_t offset = start & (PAGE_CACHE_SIZE - 1);
 	char *kaddr;
@@ -3531,42 +3530,12 @@ int map_private_extent_buffer(struct extent_buffer *eb, unsigned long start,
 	}
 
 	p = extent_buffer_page(eb, i);
-	kaddr = kmap_atomic(p, km);
-	*token = kaddr;
+	kaddr = page_address(p);
 	*map = kaddr + offset;
 	*map_len = PAGE_CACHE_SIZE - offset;
 	return 0;
 }
 
-int map_extent_buffer(struct extent_buffer *eb, unsigned long start,
-		      unsigned long min_len,
-		      char **token, char **map,
-		      unsigned long *map_start,
-		      unsigned long *map_len, int km)
-{
-	int err;
-	int save = 0;
-	if (eb->map_token) {
-		unmap_extent_buffer(eb, eb->map_token, km);
-		eb->map_token = NULL;
-		save = 1;
-	}
-	err = map_private_extent_buffer(eb, start, min_len, token, map,
-				       map_start, map_len, km);
-	if (!err && save) {
-		eb->map_token = *token;
-		eb->kaddr = *map;
-		eb->map_start = *map_start;
-		eb->map_len = *map_len;
-	}
-	return err;
-}
-
-void unmap_extent_buffer(struct extent_buffer *eb, char *token, int km)
-{
-	kunmap_atomic(token, km);
-}
-
 int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
 			  unsigned long start,
 			  unsigned long len)
@@ -3590,9 +3559,8 @@ int memcmp_extent_buffer(struct extent_buffer *eb, const void *ptrv,
 
 		cur = min(len, (PAGE_CACHE_SIZE - offset));
 
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = page_address(page);
 		ret = memcmp(ptr, kaddr + offset, cur);
-		kunmap_atomic(kaddr, KM_USER0);
 		if (ret)
 			break;
 
@@ -3625,9 +3593,8 @@ void write_extent_buffer(struct extent_buffer *eb, const void *srcv,
 		WARN_ON(!PageUptodate(page));
 
 		cur = min(len, PAGE_CACHE_SIZE - offset);
-		kaddr = kmap_atomic(page, KM_USER1);
+		kaddr = page_address(page);
 		memcpy(kaddr + offset, src, cur);
-		kunmap_atomic(kaddr, KM_USER1);
 
 		src += cur;
 		len -= cur;
@@ -3656,9 +3623,8 @@ void memset_extent_buffer(struct extent_buffer *eb, char c,
 		WARN_ON(!PageUptodate(page));
 
 		cur = min(len, PAGE_CACHE_SIZE - offset);
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = page_address(page);
 		memset(kaddr + offset, c, cur);
-		kunmap_atomic(kaddr, KM_USER0);
 
 		len -= cur;
 		offset = 0;
@@ -3689,9 +3655,8 @@ void copy_extent_buffer(struct extent_buffer *dst, struct extent_buffer *src,
 
 		cur = min(len, (unsigned long)(PAGE_CACHE_SIZE - offset));
 
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = page_address(page);
 		read_extent_buffer(src, kaddr + offset, src_offset, cur);
-		kunmap_atomic(kaddr, KM_USER0);
 
 		src_offset += cur;
 		len -= cur;
@@ -3704,20 +3669,17 @@ static void move_pages(struct page *dst_page, struct page *src_page,
 		       unsigned long dst_off, unsigned long src_off,
 		       unsigned long len)
 {
-	char *dst_kaddr = kmap_atomic(dst_page, KM_USER0);
+	char *dst_kaddr = page_address(dst_page);
 	if (dst_page == src_page) {
 		memmove(dst_kaddr + dst_off, dst_kaddr + src_off, len);
 	} else {
-		char *src_kaddr = kmap_atomic(src_page, KM_USER1);
+		char *src_kaddr = page_address(src_page);
 		char *p = dst_kaddr + dst_off + len;
 		char *s = src_kaddr + src_off + len;
 
 		while (len--)
 			*--p = *--s;
-
-		kunmap_atomic(src_kaddr, KM_USER1);
 	}
-	kunmap_atomic(dst_kaddr, KM_USER0);
 }
 
 static inline bool areas_overlap(unsigned long src, unsigned long dst, unsigned long len)
@@ -3730,20 +3692,17 @@ static void copy_pages(struct page *dst_page, struct page *src_page,
 		       unsigned long dst_off, unsigned long src_off,
 		       unsigned long len)
 {
-	char *dst_kaddr = kmap_atomic(dst_page, KM_USER0);
+	char *dst_kaddr = page_address(dst_page);
 	char *src_kaddr;
 
 	if (dst_page != src_page) {
-		src_kaddr = kmap_atomic(src_page, KM_USER1);
+		src_kaddr = page_address(src_page);
 	} else {
 		src_kaddr = dst_kaddr;
 		BUG_ON(areas_overlap(src_off, dst_off, len));
 	}
 
 	memcpy(dst_kaddr + dst_off, src_kaddr + src_off, len);
-	kunmap_atomic(dst_kaddr, KM_USER0);
-	if (dst_page != src_page)
-		kunmap_atomic(src_kaddr, KM_USER1);
 }
 
 void memcpy_extent_buffer(struct extent_buffer *dst, unsigned long dst_offset,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index a11a92e..b5f120c 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -120,8 +120,6 @@ struct extent_state {
 struct extent_buffer {
 	u64 start;
 	unsigned long len;
-	char *map_token;
-	char *kaddr;
 	unsigned long map_start;
 	unsigned long map_len;
 	struct page *first_page;
@@ -279,15 +277,10 @@ int clear_extent_buffer_uptodate(struct extent_io_tree *tree,
 int extent_buffer_uptodate(struct extent_io_tree *tree,
 			   struct extent_buffer *eb,
 			   struct extent_state *cached_state);
-int map_extent_buffer(struct extent_buffer *eb, unsigned long offset,
-		      unsigned long min_len, char **token, char **map,
-		      unsigned long *map_start,
-		      unsigned long *map_len, int km);
 int map_private_extent_buffer(struct extent_buffer *eb, unsigned long offset,
-		      unsigned long min_len, char **token, char **map,
+		      unsigned long min_len, char **map,
 		      unsigned long *map_start,
-		      unsigned long *map_len, int km);
-void unmap_extent_buffer(struct extent_buffer *eb, char *token, int km);
+		      unsigned long *map_len);
 int extent_range_uptodate(struct extent_io_tree *tree,
 			  u64 start, u64 end);
 int extent_clear_unlock_delalloc(struct inode *inode,
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 90d4ee5..bb22a44 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -664,10 +664,6 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 	struct btrfs_sector_sum *sector_sum;
 	u32 nritems;
 	u32 ins_size;
-	char *eb_map;
-	char *eb_token;
-	unsigned long map_len;
-	unsigned long map_start;
 	u16 csum_size =
 		btrfs_super_csum_size(&root->fs_info->super_copy);
 
@@ -814,30 +810,9 @@ found:
 	item_end = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_csum_item);
 	item_end = (struct btrfs_csum_item *)((unsigned char *)item_end +
 				      btrfs_item_size_nr(leaf, path->slots[0]));
-	eb_token = NULL;
 next_sector:
 
-	if (!eb_token ||
-	   (unsigned long)item + csum_size >= map_start + map_len) {
-		int err;
-
-		if (eb_token)
-			unmap_extent_buffer(leaf, eb_token, KM_USER1);
-		eb_token = NULL;
-		err = map_private_extent_buffer(leaf, (unsigned long)item,
-						csum_size,
-						&eb_token, &eb_map,
-						&map_start, &map_len, KM_USER1);
-		if (err)
-			eb_token = NULL;
-	}
-	if (eb_token) {
-		memcpy(eb_token + ((unsigned long)item & (PAGE_CACHE_SIZE - 1)),
-		       &sector_sum->sum, csum_size);
-	} else {
-		write_extent_buffer(leaf, &sector_sum->sum,
-				    (unsigned long)item, csum_size);
-	}
+	write_extent_buffer(leaf, &sector_sum->sum, (unsigned long)item, csum_size);
 
 	total_bytes += root->sectorsize;
 	sector_sum++;
@@ -850,10 +825,7 @@ next_sector:
 			goto next_sector;
 		}
 	}
-	if (eb_token) {
-		unmap_extent_buffer(leaf, eb_token, KM_USER1);
-		eb_token = NULL;
-	}
+
 	btrfs_mark_buffer_dirty(path->nodes[0]);
 	if (total_bytes < sums->len) {
 		btrfs_release_path(path);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 55d68ea..3b5763a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2541,13 +2541,6 @@ static void btrfs_read_locked_inode(struct inode *inode)
 
 	inode_item = btrfs_item_ptr(leaf, path->slots[0],
 				    struct btrfs_inode_item);
-	if (!leaf->map_token)
-		map_private_extent_buffer(leaf, (unsigned long)inode_item,
-					  sizeof(struct btrfs_inode_item),
-					  &leaf->map_token, &leaf->kaddr,
-					  &leaf->map_start, &leaf->map_len,
-					  KM_USER1);
-
 	inode->i_mode = btrfs_inode_mode(leaf, inode_item);
 	inode->i_nlink = btrfs_inode_nlink(leaf, inode_item);
 	inode->i_uid = btrfs_inode_uid(leaf, inode_item);
@@ -2585,11 +2578,6 @@ cache_acl:
 	if (!maybe_acls)
 		cache_no_acl(inode);
 
-	if (leaf->map_token) {
-		unmap_extent_buffer(leaf, leaf->map_token, KM_USER1);
-		leaf->map_token = NULL;
-	}
-
 	btrfs_free_path(path);
 
 	switch (inode->i_mode & S_IFMT) {
@@ -2634,13 +2622,6 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_inode_item *item,
 			    struct inode *inode)
 {
-	if (!leaf->map_token)
-		map_private_extent_buffer(leaf, (unsigned long)item,
-					  sizeof(struct btrfs_inode_item),
-					  &leaf->map_token, &leaf->kaddr,
-					  &leaf->map_start, &leaf->map_len,
-					  KM_USER1);
-
 	btrfs_set_inode_uid(leaf, item, inode->i_uid);
 	btrfs_set_inode_gid(leaf, item, inode->i_gid);
 	btrfs_set_inode_size(leaf, item, BTRFS_I(inode)->disk_i_size);
@@ -2669,11 +2650,6 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_inode_rdev(leaf, item, inode->i_rdev);
 	btrfs_set_inode_flags(leaf, item, BTRFS_I(inode)->flags);
 	btrfs_set_inode_block_group(leaf, item, 0);
-
-	if (leaf->map_token) {
-		unmap_extent_buffer(leaf, leaf->map_token, KM_USER1);
-		leaf->map_token = NULL;
-	}
 }
 
 /*
diff --git a/fs/btrfs/struct-funcs.c b/fs/btrfs/struct-funcs.c
index c0f7eca..bc1f6ad 100644
--- a/fs/btrfs/struct-funcs.c
+++ b/fs/btrfs/struct-funcs.c
@@ -50,36 +50,22 @@ u##bits btrfs_##name(struct extent_buffer *eb,				\
 	unsigned long part_offset = (unsigned long)s;			\
 	unsigned long offset = part_offset + offsetof(type, member);	\
 	type *p;							\
-	/* ugly, but we want the fast path here */			\
-	if (eb->map_token && offset >= eb->map_start &&			\
-	    offset + sizeof(((type *)0)->member) <= eb->map_start +	\
-	    eb->map_len) {						\
-		p = (type *)(eb->kaddr + part_offset - eb->map_start);	\
-		return le##bits##_to_cpu(p->member);			\
-	}								\
-	{								\
-		int err;						\
-		char *map_token;					\
-		char *kaddr;						\
-		int unmap_on_exit = (eb->map_token == NULL);		\
-		unsigned long map_start;				\
-		unsigned long map_len;					\
-		u##bits res;						\
-		err = map_extent_buffer(eb, offset,			\
-				sizeof(((type *)0)->member),		\
-				&map_token, &kaddr,			\
-				&map_start, &map_len, KM_USER1);	\
-		if (err) {						\
-			__le##bits leres;				\
-			read_eb_member(eb, s, type, member, &leres);	\
-			return le##bits##_to_cpu(leres);		\
-		}							\
-		p = (type *)(kaddr + part_offset - map_start);		\
-		res = le##bits##_to_cpu(p->member);			\
-		if (unmap_on_exit)					\
-			unmap_extent_buffer(eb, map_token, KM_USER1);	\
-		return res;						\
-	}								\
+	int err;						\
+	char *kaddr;						\
+	unsigned long map_start;				\
+	unsigned long map_len;					\
+	u##bits res;						\
+	err = map_private_extent_buffer(eb, offset,		\
+			sizeof(((type *)0)->member),		\
+			&kaddr, &map_start, &map_len);		\
+	if (err) {						\
+		__le##bits leres;				\
+		read_eb_member(eb, s, type, member, &leres);	\
+		return le##bits##_to_cpu(leres);		\
+	}							\
+	p = (type *)(kaddr + part_offset - map_start);		\
+	res = le##bits##_to_cpu(p->member);			\
+	return res;						\
 }									\
 void btrfs_set_##name(struct extent_buffer *eb,				\
 				    type *s, u##bits val)		\
@@ -87,36 +73,21 @@ void btrfs_set_##name(struct extent_buffer *eb,				\
 	unsigned long part_offset = (unsigned long)s;			\
 	unsigned long offset = part_offset + offsetof(type, member);	\
 	type *p;							\
-	/* ugly, but we want the fast path here */			\
-	if (eb->map_token && offset >= eb->map_start &&			\
-	    offset + sizeof(((type *)0)->member) <= eb->map_start +	\
-	    eb->map_len) {						\
-		p = (type *)(eb->kaddr + part_offset - eb->map_start);	\
-		p->member = cpu_to_le##bits(val);			\
-		return;							\
-	}								\
-	{								\
-		int err;						\
-		char *map_token;					\
-		char *kaddr;						\
-		int unmap_on_exit = (eb->map_token == NULL);		\
-		unsigned long map_start;				\
-		unsigned long map_len;					\
-		err = map_extent_buffer(eb, offset,			\
-				sizeof(((type *)0)->member),		\
-				&map_token, &kaddr,			\
-				&map_start, &map_len, KM_USER1);	\
-		if (err) {						\
-			__le##bits val2;				\
-			val2 = cpu_to_le##bits(val);			\
-			write_eb_member(eb, s, type, member, &val2);	\
-			return;						\
-		}							\
-		p = (type *)(kaddr + part_offset - map_start);		\
-		p->member = cpu_to_le##bits(val);			\
-		if (unmap_on_exit)					\
-			unmap_extent_buffer(eb, map_token, KM_USER1);	\
-	}								\
+	int err;						\
+	char *kaddr;						\
+	unsigned long map_start;				\
+	unsigned long map_len;					\
+	err = map_private_extent_buffer(eb, offset,		\
+			sizeof(((type *)0)->member),		\
+			&kaddr, &map_start, &map_len);		\
+	if (err) {						\
+		__le##bits val2;				\
+		val2 = cpu_to_le##bits(val);			\
+		write_eb_member(eb, s, type, member, &val2);	\
+		return;						\
+	}							\
+	p = (type *)(kaddr + part_offset - map_start);		\
+	p->member = cpu_to_le##bits(val);			\
 }
 
 #include "ctree.h"
@@ -125,15 +96,6 @@ void btrfs_node_key(struct extent_buffer *eb,
 		    struct btrfs_disk_key *disk_key, int nr)
 {
 	unsigned long ptr = btrfs_node_key_ptr_offset(nr);
-	if (eb->map_token && ptr >= eb->map_start &&
-	    ptr + sizeof(*disk_key) <= eb->map_start + eb->map_len) {
-		memcpy(disk_key, eb->kaddr + ptr - eb->map_start,
-			sizeof(*disk_key));
-		return;
-	} else if (eb->map_token) {
-		unmap_extent_buffer(eb, eb->map_token, KM_USER1);
-		eb->map_token = NULL;
-	}
 	read_eb_member(eb, (struct btrfs_key_ptr *)ptr,
 		       struct btrfs_key_ptr, key, disk_key);
 }
