From: Colin Watson <cjwatson@ubuntu.com>
Subject: [PATCH] Fix -Wunused-but-set-variable warnings from GCC 4.6
Date: Mon, 22 Aug 2011 13:07:55 +0100
Message-ID: <20110822120755.GG15807@riva.dynamic.greenend.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

GCC 4.6 has a new -Wunused-but-set-variable warning category, enabled by
default by -Wall (http://gcc.gnu.org/gcc-4.6/changes.html), and since
btrfs-tools uses -Werror by default, this causes the build to fail.  The
following patch fixes that.  I believe all the code I removed is
provably a no-op, but of course it would be worth double-checking.

Signed-off-by: Colin Watson <cjwatson@ubuntu.com>
---
 btrfs-map-logical.c |    2 --
 btrfsck.c           |   16 +++++++---------
 ctree.c             |   16 ----------------
 debug-tree.c        |    2 ++
 dir-item.c          |    7 +++----
 disk-io.c           |    4 ----
 extent-cache.c      |    5 +----
 extent-tree.c       |    6 ++++++
 extent_io.c         |    4 ----
 mkfs.c              |    2 --
 print-tree.c        |    3 ---
 utils.c             |    3 +--
 volumes.c           |    4 ----
 13 files changed, 20 insertions(+), 54 deletions(-)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index a109c6a..8a12074 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -41,7 +41,6 @@ struct extent_buffer *debug_read_block(struct btrfs_root *root, u64 bytenr,
 				     u32 blocksize, int copy)
 {
 	int ret;
-	int dev_nr;
 	struct extent_buffer *eb;
 	u64 length;
 	struct btrfs_multi_bio *multi = NULL;
@@ -53,7 +52,6 @@ struct extent_buffer *debug_read_block(struct btrfs_root *root, u64 bytenr,
 	if (!eb)
 		return NULL;
 
-	dev_nr = 0;
 	length = blocksize;
 	while (1) {
 		ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
diff --git a/btrfsck.c b/btrfsck.c
index 63e44d1..0c5f7fe 100644
--- a/btrfsck.c
+++ b/btrfsck.c
@@ -995,7 +995,6 @@ static int process_one_leaf(struct btrfs_root *root, struct extent_buffer *eb,
 	struct btrfs_key key;
 	u32 nritems;
 	int i;
-	int ret;
 	struct cache_tree *inode_cache;
 	struct shared_node *active_node;
 
@@ -1021,17 +1020,17 @@ static int process_one_leaf(struct btrfs_root *root, struct extent_buffer *eb,
 		switch (key.type) {
 		case BTRFS_DIR_ITEM_KEY:
 		case BTRFS_DIR_INDEX_KEY:
-			ret = process_dir_item(eb, i, &key, active_node);
+			process_dir_item(eb, i, &key, active_node);
 			break;
 		case BTRFS_INODE_REF_KEY:
-			ret = process_inode_ref(eb, i, &key, active_node);
+			process_inode_ref(eb, i, &key, active_node);
 			break;
 		case BTRFS_INODE_ITEM_KEY:
-			ret = process_inode_item(eb, i, &key, active_node);
+			process_inode_item(eb, i, &key, active_node);
 			break;
 		case BTRFS_EXTENT_DATA_KEY:
-			ret = process_file_extent(root, eb, i, &key,
-						  active_node);
+			process_file_extent(root, eb, i, &key,
+					    active_node);
 			break;
 		default:
 			break;
@@ -1917,7 +1916,6 @@ static int check_owner_ref(struct btrfs_root *root,
 	struct btrfs_root *ref_root;
 	struct btrfs_key key;
 	struct btrfs_path path;
-	int ret;
 	int level;
 	int found = 0;
 
@@ -1950,7 +1948,7 @@ static int check_owner_ref(struct btrfs_root *root,
 	
 	btrfs_init_path(&path);
 	path.lowest_level = level + 1;
-	ret = btrfs_search_slot(NULL, ref_root, &key, &path, 0, 0);
+	btrfs_search_slot(NULL, ref_root, &key, &path, 0, 0);
 
 	if (buf->start == btrfs_node_blockptr(path.nodes[level + 1],
 					      path.slots[level + 1]))
@@ -2539,10 +2537,10 @@ static int run_next_block(struct btrfs_root *root,
 				continue;
 			}
 			if (key.type == BTRFS_BLOCK_GROUP_ITEM_KEY) {
+#if 0
 				struct btrfs_block_group_item *bi;
 				bi = btrfs_item_ptr(buf, i,
 					    struct btrfs_block_group_item);
-#if 0
 				fprintf(stderr,"block group %Lu %Lu used %Lu ",
 					btrfs_disk_key_objectid(disk_key),
 					btrfs_disk_key_offset(disk_key),
diff --git a/ctree.c b/ctree.c
index f70e10c..12f1a55 100644
--- a/ctree.c
+++ b/ctree.c
@@ -262,7 +262,6 @@ int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 			     struct extent_buffer **cow_ret,
 			     u64 search_start, u64 empty_size)
 {
-	u64 generation;
 	struct extent_buffer *cow;
 	struct btrfs_disk_key disk_key;
 	int level;
@@ -272,7 +271,6 @@ int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 	WARN_ON(root->ref_cows && trans->transid != root->last_trans);
 
 	level = btrfs_header_level(buf);
-	generation = btrfs_header_generation(buf);
 
 	if (level == 0)
 		btrfs_item_key(buf, &disk_key, 0);
@@ -795,7 +793,6 @@ static int balance_level(struct btrfs_trans_handle *trans,
 	int wret;
 	int pslot;
 	int orig_slot = path->slots[level];
-	int err_on_enospc = 0;
 	u64 orig_ptr;
 
 	if (level == 0)
@@ -845,9 +842,6 @@ static int balance_level(struct btrfs_trans_handle *trans,
 	    BTRFS_NODEPTRS_PER_BLOCK(root) / 4)
 		return 0;
 
-	if (btrfs_header_nritems(mid) < 2)
-		err_on_enospc = 1;
-
 	left = read_node_slot(root, parent, pslot - 1);
 	if (left) {
 		wret = btrfs_cow_block(trans, root, left,
@@ -873,8 +867,6 @@ static int balance_level(struct btrfs_trans_handle *trans,
 		wret = push_node_left(trans, root, left, mid, 1);
 		if (wret < 0)
 			ret = wret;
-		if (btrfs_header_nritems(mid) < 2)
-			err_on_enospc = 1;
 	}
 
 	/*
@@ -996,14 +988,12 @@ static int noinline push_nodes_for_insert(struct btrfs_trans_handle *trans,
 	int wret;
 	int pslot;
 	int orig_slot = path->slots[level];
-	u64 orig_ptr;
 
 	if (level == 0)
 		return 1;
 
 	mid = path->nodes[level];
 	WARN_ON(btrfs_header_generation(mid) != trans->transid);
-	orig_ptr = btrfs_node_blockptr(mid, orig_slot);
 
 	if (level < BTRFS_MAX_LEVEL - 1)
 		parent = path->nodes[level + 1];
@@ -2370,7 +2360,6 @@ int btrfs_truncate_item(struct btrfs_trans_handle *trans,
 {
 	int ret = 0;
 	int slot;
-	int slot_orig;
 	struct extent_buffer *leaf;
 	struct btrfs_item *item;
 	u32 nritems;
@@ -2380,7 +2369,6 @@ int btrfs_truncate_item(struct btrfs_trans_handle *trans,
 	unsigned int size_diff;
 	int i;
 
-	slot_orig = path->slots[0];
 	leaf = path->nodes[0];
 	slot = path->slots[0];
 
@@ -2468,7 +2456,6 @@ int btrfs_extend_item(struct btrfs_trans_handle *trans,
 {
 	int ret = 0;
 	int slot;
-	int slot_orig;
 	struct extent_buffer *leaf;
 	struct btrfs_item *item;
 	u32 nritems;
@@ -2477,7 +2464,6 @@ int btrfs_extend_item(struct btrfs_trans_handle *trans,
 	unsigned int old_size;
 	int i;
 
-	slot_orig = path->slots[0];
 	leaf = path->nodes[0];
 
 	nritems = btrfs_header_nritems(leaf);
@@ -2541,7 +2527,6 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 	struct btrfs_item *item;
 	int ret = 0;
 	int slot;
-	int slot_orig;
 	int i;
 	u32 nritems;
 	u32 total_size = 0;
@@ -2565,7 +2550,6 @@ int btrfs_insert_empty_items(struct btrfs_trans_handle *trans,
 	if (ret < 0)
 		goto out;
 
-	slot_orig = path->slots[0];
 	leaf = path->nodes[0];
 
 	nritems = btrfs_header_nritems(leaf);
diff --git a/debug-tree.c b/debug-tree.c
index 0525354..b4d3170 100644
--- a/debug-tree.c
+++ b/debug-tree.c
@@ -37,6 +37,7 @@ static int print_usage(void)
 
 static void print_extent_leaf(struct btrfs_root *root, struct extent_buffer *l)
 {
+#if 0
 	int i;
 	struct btrfs_item *item;
 //	struct btrfs_extent_ref *ref;
@@ -71,6 +72,7 @@ static void print_extent_leaf(struct btrfs_root *root, struct extent_buffer *l)
 		};
 		fflush(stdout);
 	}
+#endif
 }
 
 static void print_extents(struct btrfs_root *root, struct extent_buffer *eb)
diff --git a/dir-item.c b/dir-item.c
index 71373b8..c699977 100644
--- a/dir-item.c
+++ b/dir-item.c
@@ -313,14 +313,13 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 	u32 sub_item_len;
 	u32 item_len;
-	int ret = 0;
 
 	leaf = path->nodes[0];
 	sub_item_len = sizeof(*di) + btrfs_dir_name_len(leaf, di) +
 		btrfs_dir_data_len(leaf, di);
 	item_len = btrfs_item_size_nr(leaf, path->slots[0]);
 	if (sub_item_len == item_len) {
-		ret = btrfs_del_item(trans, root, path);
+		btrfs_del_item(trans, root, path);
 	} else {
 		/* MARKER */
 		unsigned long ptr = (unsigned long)di;
@@ -329,8 +328,8 @@ int btrfs_delete_one_dir_name(struct btrfs_trans_handle *trans,
 		start = btrfs_item_ptr_offset(leaf, path->slots[0]);
 		memmove_extent_buffer(leaf, ptr, ptr + sub_item_len,
 			item_len - (ptr + sub_item_len - start));
-		ret = btrfs_truncate_item(trans, root, path,
-					  item_len - sub_item_len, 1);
+		btrfs_truncate_item(trans, root, path,
+				    item_len - sub_item_len, 1);
 	}
 	return 0;
 }
diff --git a/disk-io.c b/disk-io.c
index a6e1000..2913150 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -123,7 +123,6 @@ int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 			 u64 parent_transid)
 {
 	int ret;
-	int dev_nr;
 	struct extent_buffer *eb;
 	u64 length;
 	struct btrfs_multi_bio *multi = NULL;
@@ -135,7 +134,6 @@ int readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 		return 0;
 	}
 
-	dev_nr = 0;
 	length = blocksize;
 	ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
 			      bytenr, &length, &multi, 0);
@@ -177,7 +175,6 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 				     u32 blocksize, u64 parent_transid)
 {
 	int ret;
-	int dev_nr;
 	struct extent_buffer *eb;
 	u64 length;
 	struct btrfs_multi_bio *multi = NULL;
@@ -192,7 +189,6 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 	if (btrfs_buffer_uptodate(eb, parent_transid))
 		return eb;
 
-	dev_nr = 0;
 	length = blocksize;
 	while (1) {
 		ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
diff --git a/extent-cache.c b/extent-cache.c
index b871e18..4e6d1b2 100644
--- a/extent-cache.c
+++ b/extent-cache.c
@@ -96,13 +96,10 @@ int insert_existing_cache_extent(struct cache_tree *tree,
 				 struct cache_extent *pe)
 {
 	struct rb_node *found;
-	struct cache_extent *entry;
 
 	found = tree_insert(&tree->root, pe->start, pe->size, &pe->rb_node);
-	if (found) {
-		entry = rb_entry(found, struct cache_extent, rb_node);
+	if (found)
 		return -EEXIST;
-	}
 	return 0;
 }
 
diff --git a/extent-tree.c b/extent-tree.c
index b2f9bb2..4033ad8 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1549,7 +1549,9 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	int i;
 	int level;
 	int ret = 0;
+#if 0
 	int faili = 0;
+#endif
 	int (*process_func)(struct btrfs_trans_handle *trans,
 			    struct btrfs_root *root,
 			    u64, u64, u64, u64, u64, u64);
@@ -1592,7 +1594,9 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 					   parent, ref_root, key.objectid,
 					   key.offset);
 			if (ret) {
+#if 0
 				faili = i;
+#endif
 				WARN_ON(1);
 				goto fail;
 			}
@@ -1602,7 +1606,9 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			ret = process_func(trans, root, bytenr, num_bytes,
 					   parent, ref_root, level - 1, 0);
 			if (ret) {
+#if 0
 				faili = i;
+#endif
 				WARN_ON(1);
 				goto fail;
 			}
diff --git a/extent_io.c b/extent_io.c
index 069c199..70fecbb 100644
--- a/extent_io.c
+++ b/extent_io.c
@@ -296,7 +296,6 @@ int set_extent_bits(struct extent_io_tree *tree, u64 start,
 	struct extent_state *prealloc = NULL;
 	struct cache_extent *node;
 	int err = 0;
-	int set;
 	u64 last_start;
 	u64 last_end;
 again:
@@ -327,7 +326,6 @@ again:
 	 * Just lock what we found and keep going
 	 */
 	if (state->start == start && state->end <= end) {
-		set = state->state & bits;
 		state->state |= bits;
 		merge_state(tree, state);
 		if (last_end == (u64)-1)
@@ -352,7 +350,6 @@ again:
 	 * desired bit on it.
 	 */
 	if (state->start < start) {
-		set = state->state & bits;
 		err = split_state(tree, state, prealloc, start);
 		BUG_ON(err == -EEXIST);
 		prealloc = NULL;
@@ -398,7 +395,6 @@ again:
 	 * We need to split the extent, and set the bit
 	 * on the first half
 	 */
-	set = state->state & bits;
 	err = split_state(tree, state, prealloc, end + 1);
 	BUG_ON(err == -EEXIST);
 
diff --git a/mkfs.c b/mkfs.c
index 2e99b95..19c43c8 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -355,7 +355,6 @@ int main(int ac, char **av)
 	int zero_end = 1;
 	int option_index = 0;
 	int fd;
-	int first_fd;
 	int ret;
 	int i;
 
@@ -437,7 +436,6 @@ int main(int ac, char **av)
 		fprintf(stderr, "unable to open %s\n", file);
 		exit(1);
 	}
-	first_fd = fd;
 	first_file = file;
 	ret = btrfs_prepare_device(fd, file, zero_end, &dev_block_count);
 	if (block_count == 0)
diff --git a/print-tree.c b/print-tree.c
index ac575d5..ddcade1 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -444,7 +444,6 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 	struct btrfs_dir_item *di;
 	struct btrfs_inode_item *ii;
 	struct btrfs_file_extent_item *fi;
-	struct btrfs_csum_item *ci;
 	struct btrfs_block_group_item *bi;
 	struct btrfs_extent_data_ref *dref;
 	struct btrfs_shared_data_ref *sref;
@@ -556,11 +555,9 @@ void btrfs_print_leaf(struct btrfs_root *root, struct extent_buffer *l)
 #endif
 			break;
 		case BTRFS_CSUM_ITEM_KEY:
-			ci = btrfs_item_ptr(l, i, struct btrfs_csum_item);
 			printf("\t\tcsum item\n");
 			break;
 		case BTRFS_EXTENT_CSUM_KEY:
-			ci = btrfs_item_ptr(l, i, struct btrfs_csum_item);
 			printf("\t\textent csum item\n");
 			break;
 		case BTRFS_EXTENT_DATA_KEY:
diff --git a/utils.c b/utils.c
index fd894f3..399a662 100644
--- a/utils.c
+++ b/utils.c
@@ -820,7 +820,6 @@ void btrfs_register_one_device(char *fname)
 {
 	struct btrfs_ioctl_vol_args args;
 	int fd;
-	int ret;
 
 	fd = open("/dev/btrfs-control", O_RDONLY);
 	if (fd < 0) {
@@ -829,7 +828,7 @@ void btrfs_register_one_device(char *fname)
 		return;
 	}
 	strcpy(args.name, fname);
-	ret = ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
+	ioctl(fd, BTRFS_IOC_SCAN_DEV, &args);
 	close(fd);
 }
 
diff --git a/volumes.c b/volumes.c
index 7671855..de4a4d3 100644
--- a/volumes.c
+++ b/volumes.c
@@ -643,7 +643,6 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	struct list_head *cur;
 	struct map_lookup *map;
 	int min_stripe_size = 1 * 1024 * 1024;
-	u64 physical;
 	u64 calc_size = 8 * 1024 * 1024;
 	u64 min_free;
 	u64 max_chunk_size = 4 * calc_size;
@@ -811,7 +810,6 @@ again:
 		btrfs_set_stack_stripe_devid(stripe, device->devid);
 		btrfs_set_stack_stripe_offset(stripe, dev_offset);
 		memcpy(stripe->dev_uuid, device->uuid, BTRFS_UUID_SIZE);
-		physical = dev_offset;
 		index++;
 	}
 	BUG_ON(!list_empty(&private_devs));
@@ -867,14 +865,12 @@ int btrfs_num_copies(struct btrfs_mapping_tree *map_tree, u64 logical, u64 len)
 	struct cache_extent *ce;
 	struct map_lookup *map;
 	int ret;
-	u64 offset;
 
 	ce = find_first_cache_extent(&map_tree->cache_tree, logical);
 	BUG_ON(!ce);
 	BUG_ON(ce->start > logical || ce->start + ce->size < logical);
 	map = container_of(ce, struct map_lookup, ce);
 
-	offset = logical - ce->start;
 	if (map->type & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1))
 		ret = map->num_stripes;
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID10)
-- 
1.7.5.4
