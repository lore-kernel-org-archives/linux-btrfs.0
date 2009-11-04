From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 06/10] btrfs: annotate kmalloc failures
Date: Wed, 04 Nov 2009 14:03:52 -0500
Message-ID: <20091104190433.760273479@suse.com>
References: <20091104190346.971762946@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds checks to ensure that kmalloc or kmem_cache_alloc has
succeeded before using the memory.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 fs/btrfs/compression.c |    2 ++
 fs/btrfs/ctree.c       |    1 +
 fs/btrfs/disk-io.c     |    1 +
 fs/btrfs/extent-tree.c |   12 +++++++-----
 fs/btrfs/file-item.c   |    4 ++--
 fs/btrfs/file.c        |    1 +
 fs/btrfs/inode.c       |    4 ++++
 fs/btrfs/relocation.c  |    8 ++++----
 fs/btrfs/transaction.c |    4 +++-
 fs/btrfs/tree-log.c    |    9 +++++++--
 fs/btrfs/volumes.c     |    2 +-
 11 files changed, 33 insertions(+), 15 deletions(-)

--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -351,6 +351,7 @@ int btrfs_submit_compressed_write(struct
 
 	WARN_ON(start & ((u64)PAGE_CACHE_SIZE - 1));
 	cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
+	BTRFS_UERROR(!cb);
 	atomic_set(&cb->pending_bios, 0);
 	cb->errors = 0;
 	cb->inode = inode;
@@ -622,6 +623,7 @@ int btrfs_submit_compressed_read(struct
 				 PAGE_CACHE_SIZE;
 	cb->compressed_pages = kmalloc(sizeof(struct page *) * nr_pages,
 				       GFP_NOFS);
+	BTRFS_UERROR(!cb->compressed_pages);
 	bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
 
 	for (page_index = 0; page_index < nr_pages; page_index++) {
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3073,6 +3073,7 @@ split:
 	item_size = btrfs_item_size(leaf, item);
 
 	buf = kmalloc(item_size, GFP_NOFS);
+	BTRFS_UERROR(!buf);
 	read_extent_buffer(leaf, buf, btrfs_item_ptr_offset(leaf,
 			    path->slots[0]), item_size);
 	slot = path->slots[0] + 1;
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1958,6 +1958,7 @@ struct btrfs_root *open_ctree(struct sup
 
 		log_tree_root = kzalloc(sizeof(struct btrfs_root),
 						      GFP_NOFS);
+		BTRFS_UERROR(!log_tree_root);
 
 		__setup_root(nodesize, leafsize, sectorsize, stripesize,
 			     log_tree_root, fs_info, BTRFS_TREE_LOG_OBJECTID);
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -414,7 +414,7 @@ static int cache_block_group(struct btrf
 		return 0;
 
 	caching_ctl = kzalloc(sizeof(*caching_ctl), GFP_KERNEL);
-	BUG_ON(!caching_ctl);
+	BTRFS_UERROR(!caching_ctl);
 
 	INIT_LIST_HEAD(&caching_ctl->list);
 	mutex_init(&caching_ctl->mutex);
@@ -5388,7 +5388,7 @@ int btrfs_drop_snapshot(struct btrfs_roo
 	BUG_ON(!path);
 
 	wc = kzalloc(sizeof(*wc), GFP_NOFS);
-	BUG_ON(!wc);
+	BTRFS_UERROR(!wc);
 
 	trans = btrfs_start_transaction(tree_root, 1);
 
@@ -5550,7 +5550,7 @@ int btrfs_drop_subtree(struct btrfs_tran
 	BUG_ON(!path);
 
 	wc = kzalloc(sizeof(*wc), GFP_NOFS);
-	BUG_ON(!wc);
+	BTRFS_UERROR(!wc);
 
 	btrfs_assert_tree_locked(parent);
 	parent_level = btrfs_header_level(parent);
@@ -6048,6 +6048,7 @@ static noinline int get_new_locations(st
 			struct disk_extent *old = exts;
 			max *= 2;
 			exts = kzalloc(sizeof(*exts) * max, GFP_NOFS);
+			BTRFS_UERROR(!exts);
 			memcpy(exts, old, sizeof(*exts) * nr);
 			if (old != *extents)
 				kfree(old);
@@ -6527,7 +6528,7 @@ static noinline int replace_extents_in_l
 	int ret;
 
 	new_extent = kmalloc(sizeof(*new_extent), GFP_NOFS);
-	BUG_ON(!new_extent);
+	BTRFS_UERROR(!new_extent)
 
 	ref = btrfs_lookup_leaf_ref(root, leaf->start);
 	BUG_ON(!ref);
@@ -6731,7 +6732,7 @@ static noinline int init_reloc_tree(stru
 		return 0;
 
 	root_item = kmalloc(sizeof(*root_item), GFP_NOFS);
-	BUG_ON(!root_item);
+	BTRFS_UERROR(!root_item);
 
 	ret = btrfs_copy_root(trans, root, root->commit_root,
 			      &eb, BTRFS_TREE_RELOC_OBJECTID);
@@ -7047,6 +7048,7 @@ static noinline int relocate_one_extent(
 				u64 group_start = group->key.objectid;
 				new_extents = kmalloc(sizeof(*new_extents),
 						      GFP_NOFS);
+				BTRFS_UERROR(!new_extents);
 				nr_extents = 1;
 				ret = get_new_locations(reloc_inode,
 							extent_key,
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -320,7 +320,7 @@ int btrfs_lookup_csums_range(struct btrf
 					MAX_ORDERED_SUM_BYTES(root));
 			sums = kzalloc(btrfs_ordered_sum_size(root, size),
 					GFP_NOFS);
-			BUG_ON(!sums);
+			BTRFS_UERROR(!sums);
 
 			sector_sum = sums->sums;
 			sums->bytenr = start;
@@ -401,7 +401,7 @@ int btrfs_csum_one_bio(struct btrfs_root
 
 			sums = kzalloc(btrfs_ordered_sum_size(root, bytes_left),
 				       GFP_NOFS);
-			BUG_ON(!sums);
+			BTRFS_UERROR(!sums);
 			sector_sum = sums->sums;
 			sums->len = bytes_left;
 			ordered = btrfs_lookup_ordered_extent(inode, offset);
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -946,6 +946,7 @@ static ssize_t btrfs_file_write(struct f
 	file_update_time(file);
 
 	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
+	BTRFS_UERROR(!pages);
 
 	/* generic_write_checks can change our pos */
 	start_pos = pos;
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -273,6 +273,7 @@ static noinline int add_async_extent(str
 	struct async_extent *async_extent;
 
 	async_extent = kmalloc(sizeof(*async_extent), GFP_NOFS);
+	BTRFS_UERROR(!async_extent);
 	async_extent->start = start;
 	async_extent->ram_size = ram_size;
 	async_extent->compressed_size = compressed_size;
@@ -372,6 +373,7 @@ again:
 	    btrfs_test_opt(root, COMPRESS)) {
 		WARN_ON(pages);
 		pages = kzalloc(sizeof(struct page *) * nr_pages, GFP_NOFS);
+		BTRFS_UERROR(!pages);
 
 		ret = btrfs_zlib_compress_pages(inode->i_mapping, start,
 						total_compressed, pages,
@@ -885,6 +887,7 @@ static int cow_file_range_async(struct i
 			 1, 0, NULL, GFP_NOFS);
 	while (start < end) {
 		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
+		BTRFS_UERROR(!async_cow);
 		async_cow->inode = inode;
 		async_cow->root = root;
 		async_cow->locked_page = locked_page;
@@ -4447,6 +4450,7 @@ static noinline int uncompress_inline(st
 	inline_size = btrfs_file_extent_inline_item_len(leaf,
 					btrfs_item_nr(leaf, path->slots[0]));
 	tmp = kmalloc(inline_size, GFP_NOFS);
+	BTRFS_UERROR(!tmp);
 	ptr = btrfs_file_extent_inline_start(item);
 
 	read_extent_buffer(leaf, tmp, ptr, inline_size);
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -850,7 +850,7 @@ static int __add_reloc_root(struct btrfs
 	struct reloc_control *rc = root->fs_info->reloc_ctl;
 
 	node = kmalloc(sizeof(*node), GFP_NOFS);
-	BUG_ON(!node);
+	BTRFS_UERROR(!node);
 
 	node->bytenr = root->node->start;
 	node->data = root;
@@ -925,7 +925,7 @@ int btrfs_init_reloc_root(struct btrfs_t
 		return 0;
 
 	root_item = kmalloc(sizeof(*root_item), GFP_NOFS);
-	BUG_ON(!root_item);
+	BTRFS_UERROR(!root_item);
 
 	root_key.objectid = BTRFS_TREE_RELOC_OBJECTID;
 	root_key.type = BTRFS_ROOT_ITEM_KEY;
@@ -1167,7 +1167,7 @@ static int replace_file_extents(struct b
 		if (root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID) {
 			if (!ivec || ivec->nr == INODEVEC_SIZE) {
 				ivec = kmalloc(sizeof(*ivec), GFP_NOFS);
-				BUG_ON(!ivec);
+				BTRFS_UERROR(!ivec);
 				ivec->nr = 0;
 				list_add_tail(&ivec->list, inode_list);
 			}
@@ -1824,7 +1824,7 @@ static int merge_reloc_roots(struct relo
 		list_del_init(&root->root_list);
 
 		async = kmalloc(sizeof(*async), GFP_NOFS);
-		BUG_ON(!async);
+		BTRFS_UERROR(!async);
 		async->work.func = merge_func;
 		async->work.flags = 0;
 		async->rc = rc;
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -56,7 +56,7 @@ static noinline int join_transaction(str
 	if (!cur_trans) {
 		cur_trans = kmem_cache_alloc(btrfs_transaction_cachep,
 					     GFP_NOFS);
-		BUG_ON(!cur_trans);
+		BTRFS_UERROR(!cur_trans);
 		root->fs_info->generation++;
 		cur_trans->num_writers = 1;
 		cur_trans->num_joined = 0;
@@ -170,6 +170,8 @@ static struct btrfs_trans_handle *start_
 		kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
 	int ret;
 
+	BTRFS_UERROR(!h);
+
 	mutex_lock(&root->fs_info->trans_mutex);
 	if (!root->fs_info->log_root_recovering &&
 	    ((wait == 1 && !root->fs_info->open_ioctl_trans) || wait == 2))
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -333,7 +333,9 @@ static noinline int overwrite_item(struc
 			return 0;
 		}
 		dst_copy = kmalloc(item_size, GFP_NOFS);
+		BTRFS_UERROR(!dst_copy);
 		src_copy = kmalloc(item_size, GFP_NOFS);
+		BTRFS_UERROR(!src_copy);
 
 		read_extent_buffer(eb, src_copy, src_ptr, item_size);
 
@@ -661,6 +663,7 @@ static noinline int drop_one_dir_item(st
 	btrfs_dir_item_key_to_cpu(leaf, di, &location);
 	name_len = btrfs_dir_name_len(leaf, di);
 	name = kmalloc(name_len, GFP_NOFS);
+	BTRFS_UERROR(!name);
 	read_extent_buffer(leaf, name, (unsigned long)(di + 1), name_len);
 	btrfs_release_path(root, path);
 
@@ -816,7 +819,7 @@ again:
 
 	namelen = btrfs_inode_ref_name_len(eb, ref);
 	name = kmalloc(namelen, GFP_NOFS);
-	BUG_ON(!name);
+	BTRFS_UERROR(!name);
 
 	read_extent_buffer(eb, name, (unsigned long)(ref + 1), namelen);
 
@@ -861,7 +864,7 @@ conflict_again:
 			victim_name_len = btrfs_inode_ref_name_len(leaf,
 								   victim_ref);
 			victim_name = kmalloc(victim_name_len, GFP_NOFS);
-			BUG_ON(!victim_name);
+			BTRFS_UERROR(!victim_name);
 
 			read_extent_buffer(leaf, victim_name,
 					   (unsigned long)(victim_ref + 1),
@@ -1164,6 +1167,7 @@ static noinline int replay_one_name(stru
 
 	name_len = btrfs_dir_name_len(eb, di);
 	name = kmalloc(name_len, GFP_NOFS);
+	BTRFS_UERROR(!name);
 	log_type = btrfs_dir_type(eb, di);
 	read_extent_buffer(eb, name, (unsigned long)(di + 1),
 		   name_len);
@@ -2571,6 +2575,7 @@ static noinline int copy_items(struct bt
 
 	ins_data = kmalloc(nr * sizeof(struct btrfs_key) +
 			   nr * sizeof(u32), GFP_NOFS);
+	BTRFS_UERROR(!ins_data);
 	ins_sizes = (u32 *)ins_data;
 	ins_keys = (struct btrfs_key *)(ins_data + nr * sizeof(u32));
 
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2819,7 +2819,7 @@ int btrfs_rmap_block(struct btrfs_mappin
 		do_div(length, map->num_stripes);
 
 	buf = kzalloc(sizeof(u64) * map->num_stripes, GFP_NOFS);
-	BUG_ON(!buf);
+	BTRFS_UERROR(!buf);
 
 	for (i = 0; i < map->num_stripes; i++) {
 		if (devid && map->stripes[i].dev->devid != devid)

