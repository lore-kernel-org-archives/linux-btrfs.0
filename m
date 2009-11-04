From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 07/10] btrfs: handle kmalloc call path failures
Date: Wed, 04 Nov 2009 14:03:53 -0500
Message-ID: <20091104190434.038152541@suse.com>
References: <20091104190346.971762946@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds checks to ensure that kmalloc or kmem_cache_alloc has
succeeded before using the memory.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/compression.c |    3 ++-
 fs/btrfs/disk-io.c     |    5 ++++-
 fs/btrfs/extent-tree.c |   28 +++++++++++++++++++---------
 fs/btrfs/file.c        |    5 ++++-
 fs/btrfs/inode.c       |   17 +++++++++++------
 fs/btrfs/relocation.c  |   12 ++++++++----
 fs/btrfs/transaction.c |   10 +++++++---
 fs/btrfs/tree-log.c    |   25 +++++++++++++++----------
 fs/btrfs/volumes.c     |    5 ++++-
 9 files changed, 74 insertions(+), 36 deletions(-)

--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -351,7 +351,8 @@ int btrfs_submit_compressed_write(struct
 
 	WARN_ON(start & ((u64)PAGE_CACHE_SIZE - 1));
 	cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
-	BTRFS_UERROR(!cb);
+	if (!cb)
+		return -ENOMEM;
 	atomic_set(&cb->pending_bios, 0);
 	cb->errors = 0;
 	cb->inode = inode;
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1958,7 +1958,10 @@ struct btrfs_root *open_ctree(struct sup
 
 		log_tree_root = kzalloc(sizeof(struct btrfs_root),
 						      GFP_NOFS);
-		BTRFS_UERROR(!log_tree_root);
+		if (!log_tree_root) {
+			err = -EIO;
+			goto fail_trans_kthread;
+		}
 
 		__setup_root(nodesize, leafsize, sectorsize, stripesize,
 			     log_tree_root, fs_info, BTRFS_TREE_LOG_OBJECTID);
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -414,7 +414,8 @@ static int cache_block_group(struct btrf
 		return 0;
 
 	caching_ctl = kzalloc(sizeof(*caching_ctl), GFP_KERNEL);
-	BTRFS_UERROR(!caching_ctl);
+	if (!caching_ctl)
+		return -ENOMEM;
 
 	INIT_LIST_HEAD(&caching_ctl->list);
 	mutex_init(&caching_ctl->mutex);
@@ -4217,7 +4218,7 @@ have_block_group:
 			if (loop > LOOP_CACHING_NOWAIT ||
 			    atomic_read(&space_info->caching_threads) < 2) {
 				ret = cache_block_group(block_group);
-				BUG_ON(ret);
+				BTRFS_UERROR(ret);
 			}
 		}
 
@@ -4743,7 +4744,8 @@ int btrfs_alloc_logged_file_extent(struc
 	u64 num_bytes = ins->offset;
 
 	block_group = btrfs_lookup_block_group(root->fs_info, ins->objectid);
-	cache_block_group(block_group);
+	ret = cache_block_group(block_group);
+	BTRFS_UERROR(ret);
 	caching_ctl = get_caching_control(block_group);
 
 	if (!caching_ctl) {
@@ -5388,7 +5390,10 @@ int btrfs_drop_snapshot(struct btrfs_roo
 	BUG_ON(!path);
 
 	wc = kzalloc(sizeof(*wc), GFP_NOFS);
-	BTRFS_UERROR(!wc);
+	if (!wc) {
+		btrfs_free_path(path);
+		return -ENOMEM;
+	}
 
 	trans = btrfs_start_transaction(tree_root, 1);
 
@@ -5550,7 +5555,10 @@ int btrfs_drop_subtree(struct btrfs_tran
 	BUG_ON(!path);
 
 	wc = kzalloc(sizeof(*wc), GFP_NOFS);
-	BTRFS_UERROR(!wc);
+	if (!wc) {
+		btrfs_free_path(path);
+		return -ENOMEM;
+	}
 
 	btrfs_assert_tree_locked(parent);
 	parent_level = btrfs_header_level(parent);
@@ -6528,7 +6536,8 @@ static noinline int replace_extents_in_l
 	int ret;
 
 	new_extent = kmalloc(sizeof(*new_extent), GFP_NOFS);
-	BTRFS_UERROR(!new_extent)
+	if (!new_extent)
+		return -ENOMEM;
 
 	ref = btrfs_lookup_leaf_ref(root, leaf->start);
 	BUG_ON(!ref);
@@ -6732,7 +6741,8 @@ static noinline int init_reloc_tree(stru
 		return 0;
 
 	root_item = kmalloc(sizeof(*root_item), GFP_NOFS);
-	BTRFS_UERROR(!root_item);
+	if (!root_item)
+		return -ENOMEM;
 
 	ret = btrfs_copy_root(trans, root, root->commit_root,
 			      &eb, BTRFS_TREE_RELOC_OBJECTID);
@@ -6816,7 +6826,7 @@ static noinline int relocate_one_path(st
 
 	mutex_lock(&root->fs_info->tree_reloc_mutex);
 	ret = init_reloc_tree(trans, root);
-	BUG_ON(ret);
+	BTRFS_UERROR(ret);
 	reloc_root = root->reloc_root;
 
 	shared_level = ref_path->shared_level;
@@ -6849,7 +6859,7 @@ static noinline int relocate_one_path(st
 			eb = path->nodes[0];
 			ret = replace_extents_in_leaf(trans, reloc_root, eb,
 						      group, reloc_inode);
-			BUG_ON(ret);
+			BTRFS_UERROR(ret);
 		}
 		btrfs_release_path(reloc_root, path);
 	} else {
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -946,7 +946,10 @@ static ssize_t btrfs_file_write(struct f
 	file_update_time(file);
 
 	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
-	BTRFS_UERROR(!pages);
+	if (!pages) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	/* generic_write_checks can change our pos */
 	start_pos = pos;
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -273,7 +273,8 @@ static noinline int add_async_extent(str
 	struct async_extent *async_extent;
 
 	async_extent = kmalloc(sizeof(*async_extent), GFP_NOFS);
-	BTRFS_UERROR(!async_extent);
+	if (!async_extent)
+		return -ENOMEM;
 	async_extent->start = start;
 	async_extent->ram_size = ram_size;
 	async_extent->compressed_size = compressed_size;
@@ -483,8 +484,9 @@ again:
 		 * allocation on disk for these compressed pages,
 		 * and will submit them to the elevator.
 		 */
-		add_async_extent(async_cow, start, num_bytes,
-				 total_compressed, pages, nr_pages_ret);
+		ret = add_async_extent(async_cow, start, num_bytes,
+				       total_compressed, pages, nr_pages_ret);
+		BTRFS_UERROR(ret);
 
 		if (start + num_bytes < end && start + num_bytes < actual_end) {
 			start += num_bytes;
@@ -506,7 +508,9 @@ cleanup_and_bail_uncompressed:
 			__set_page_dirty_nobuffers(locked_page);
 			/* unlocked later on in the async handlers */
 		}
-		add_async_extent(async_cow, start, end - start + 1, 0, NULL, 0);
+		ret = add_async_extent(async_cow, start,
+				       end - start + 1, 0, NULL, 0);
+		BTRFS_UERROR(ret);
 		*num_added += 1;
 	}
 
@@ -4450,7 +4454,8 @@ static noinline int uncompress_inline(st
 	inline_size = btrfs_file_extent_inline_item_len(leaf,
 					btrfs_item_nr(leaf, path->slots[0]));
 	tmp = kmalloc(inline_size, GFP_NOFS);
-	BTRFS_UERROR(!tmp);
+	if (!tmp)
+		return -ENOMEM;
 	ptr = btrfs_file_extent_inline_start(item);
 
 	read_extent_buffer(leaf, tmp, ptr, inline_size);
@@ -4648,7 +4653,7 @@ again:
 				ret = uncompress_inline(path, inode, page,
 							pg_offset,
 							extent_offset, item);
-				BUG_ON(ret);
+				BTRFS_UERROR(ret);
 			} else {
 				map = kmap(page);
 				read_extent_buffer(leaf, map + pg_offset, ptr,
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -850,7 +850,8 @@ static int __add_reloc_root(struct btrfs
 	struct reloc_control *rc = root->fs_info->reloc_ctl;
 
 	node = kmalloc(sizeof(*node), GFP_NOFS);
-	BTRFS_UERROR(!node);
+	if (!node)
+		return -ENOMEM;
 
 	node->bytenr = root->node->start;
 	node->data = root;
@@ -925,7 +926,8 @@ int btrfs_init_reloc_root(struct btrfs_t
 		return 0;
 
 	root_item = kmalloc(sizeof(*root_item), GFP_NOFS);
-	BTRFS_UERROR(!root_item);
+	if (!root_item)
+		return -ENOMEM;
 
 	root_key.objectid = BTRFS_TREE_RELOC_OBJECTID;
 	root_key.type = BTRFS_ROOT_ITEM_KEY;
@@ -957,7 +959,8 @@ int btrfs_init_reloc_root(struct btrfs_t
 	BUG_ON(IS_ERR(reloc_root));
 	reloc_root->last_trans = trans->transid;
 
-	__add_reloc_root(reloc_root);
+	ret = __add_reloc_root(reloc_root);
+	BTRFS_UERROR(ret);
 	root->reloc_root = reloc_root;
 	return 0;
 }
@@ -3721,7 +3724,8 @@ int btrfs_recover_relocation(struct btrf
 				       reloc_root->root_key.offset);
 		BUG_ON(IS_ERR(fs_root));
 
-		__add_reloc_root(reloc_root);
+		err = __add_reloc_root(reloc_root);
+		BTRFS_UERROR(err);
 		fs_root->reloc_root = reloc_root;
 	}
 
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -56,7 +56,8 @@ static noinline int join_transaction(str
 	if (!cur_trans) {
 		cur_trans = kmem_cache_alloc(btrfs_transaction_cachep,
 					     GFP_NOFS);
-		BTRFS_UERROR(!cur_trans);
+		if (!cur_trans)
+			return -ENOMEM;
 		root->fs_info->generation++;
 		cur_trans->num_writers = 1;
 		cur_trans->num_joined = 0;
@@ -102,6 +103,7 @@ static noinline int join_transaction(str
 static noinline int record_root_in_trans(struct btrfs_trans_handle *trans,
 					 struct btrfs_root *root)
 {
+	int ret;
 	if (root->ref_cows && root->last_trans < trans->transid) {
 		WARN_ON(root == root->fs_info->extent_root);
 		WARN_ON(root->commit_root != root->node);
@@ -110,7 +112,8 @@ static noinline int record_root_in_trans
 			   (unsigned long)root->root_key.objectid,
 			   BTRFS_ROOT_TRANS_TAG);
 		root->last_trans = trans->transid;
-		btrfs_init_reloc_root(trans, root);
+		ret = btrfs_init_reloc_root(trans, root);
+		BTRFS_UERROR(ret);
 	}
 	return 0;
 }
@@ -170,7 +173,8 @@ static struct btrfs_trans_handle *start_
 		kmem_cache_alloc(btrfs_trans_handle_cachep, GFP_NOFS);
 	int ret;
 
-	BTRFS_UERROR(!h);
+	if (!h)
+		return ERR_PTR(-ENOMEM);
 
 	mutex_lock(&root->fs_info->trans_mutex);
 	if (!root->fs_info->log_root_recovering &&
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -663,7 +663,8 @@ static noinline int drop_one_dir_item(st
 	btrfs_dir_item_key_to_cpu(leaf, di, &location);
 	name_len = btrfs_dir_name_len(leaf, di);
 	name = kmalloc(name_len, GFP_NOFS);
-	BTRFS_UERROR(!name);
+	if (!name)
+		return -ENOMEM;
 	read_extent_buffer(leaf, name, (unsigned long)(di + 1), name_len);
 	btrfs_release_path(root, path);
 
@@ -895,7 +896,7 @@ conflict_again:
 					 name, namelen, 0);
 	if (di && !IS_ERR(di)) {
 		ret = drop_one_dir_item(trans, root, path, dir, di);
-		BUG_ON(ret);
+		BTRFS_UERROR(ret);
 	}
 	btrfs_release_path(root, path);
 
@@ -905,7 +906,7 @@ conflict_again:
 				   name, namelen, 0);
 	if (di && !IS_ERR(di)) {
 		ret = drop_one_dir_item(trans, root, path, dir, di);
-		BUG_ON(ret);
+		BTRFS_UERROR(ret);
 	}
 	btrfs_release_path(root, path);
 
@@ -1167,7 +1168,10 @@ static noinline int replay_one_name(stru
 
 	name_len = btrfs_dir_name_len(eb, di);
 	name = kmalloc(name_len, GFP_NOFS);
-	BTRFS_UERROR(!name);
+	if (!name) {
+		iput(dir);
+		return -ENOMEM;
+	}
 	log_type = btrfs_dir_type(eb, di);
 	read_extent_buffer(eb, name, (unsigned long)(di + 1),
 		   name_len);
@@ -1217,7 +1221,7 @@ static noinline int replay_one_name(stru
 		goto out;
 
 	ret = drop_one_dir_item(trans, root, path, dir, dst_di);
-	BUG_ON(ret);
+	BTRFS_UERROR(ret);
 
 	if (key->type == BTRFS_DIR_INDEX_KEY)
 		goto insert;
@@ -1261,7 +1265,7 @@ static noinline int replay_one_dir_item(
 		di = (struct btrfs_dir_item *)ptr;
 		name_len = btrfs_dir_name_len(eb, di);
 		ret = replay_one_name(trans, root, path, eb, di, key);
-		BUG_ON(ret);
+		BTRFS_UERROR(ret);
 		ptr = (unsigned long)(di + 1);
 		ptr += name_len;
 	}
@@ -2575,7 +2579,8 @@ static noinline int copy_items(struct bt
 
 	ins_data = kmalloc(nr * sizeof(struct btrfs_key) +
 			   nr * sizeof(u32), GFP_NOFS);
-	BTRFS_UERROR(!ins_data);
+	if (!ins_data)
+		return -ENOMEM;
 	ins_sizes = (u32 *)ins_data;
 	ins_keys = (struct btrfs_key *)(ins_data + nr * sizeof(u32));
 
@@ -2766,7 +2771,7 @@ again:
 
 		ret = copy_items(trans, log, dst_path, src, ins_start_slot,
 				 ins_nr, inode_only);
-		BUG_ON(ret);
+		BTRFS_UERROR(ret);
 		ins_nr = 1;
 		ins_start_slot = path->slots[0];
 next_slot:
@@ -2782,7 +2787,7 @@ next_slot:
 			ret = copy_items(trans, log, dst_path, src,
 					 ins_start_slot,
 					 ins_nr, inode_only);
-			BUG_ON(ret);
+			BTRFS_UERROR(ret);
 			ins_nr = 0;
 		}
 		btrfs_release_path(root, path);
@@ -2800,7 +2805,7 @@ next_slot:
 		ret = copy_items(trans, log, dst_path, src,
 				 ins_start_slot,
 				 ins_nr, inode_only);
-		BUG_ON(ret);
+		BTRFS_UERROR(ret);
 		ins_nr = 0;
 	}
 	WARN_ON(ins_nr);
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2819,7 +2819,10 @@ int btrfs_rmap_block(struct btrfs_mappin
 		do_div(length, map->num_stripes);
 
 	buf = kzalloc(sizeof(u64) * map->num_stripes, GFP_NOFS);
-	BTRFS_UERROR(!buf);
+	if (!buf) {
+		free_extent_map(em);
+		return -ENOMEM;
+	}
 
 	for (i = 0; i < map->num_stripes; i++) {
 		if (devid && map->stripes[i].dev->devid != devid)

