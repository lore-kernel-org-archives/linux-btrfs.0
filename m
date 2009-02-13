From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 3/5] Btrfs: handle path alloc failures
Date: Fri, 13 Feb 2009 17:17:41 -0500
Message-ID: <1234563463-7585-3-git-send-email-jeffm@suse.com>
References: <1234563463-7585-1-git-send-email-jeffm@suse.com>
 <1234563463-7585-2-git-send-email-jeffm@suse.com>
Cc: Jeff Mahoney <jeffm@suse.com>
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1234563463-7585-2-git-send-email-jeffm@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

 This patch checks the returns from btrfs_path_alloc, and acts accordingly.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/acl.c         |    3 ++
 fs/btrfs/compression.c |   11 ++++--
 fs/btrfs/ctree.c       |   13 ++++++--
 fs/btrfs/dir-item.c    |    4 ++
 fs/btrfs/disk-io.c     |    9 ++++-
 fs/btrfs/export.c      |    2 +
 fs/btrfs/extent-tree.c |   73 ++++++++++++++++++++++++++++++++++-------------
 fs/btrfs/file-item.c   |   15 ++++++++--
 fs/btrfs/file.c        |    5 ++-
 fs/btrfs/inode-map.c   |    8 ++++-
 fs/btrfs/inode.c       |   63 +++++++++++++++++++++++-----------------
 fs/btrfs/ioctl.c       |   11 ++++++-
 fs/btrfs/root-tree.c   |   16 ++++++++--
 fs/btrfs/transaction.c |    9 ++++-
 fs/btrfs/tree-log.c    |   36 +++++++++++++++++++----
 fs/btrfs/volumes.c     |    4 ++-
 16 files changed, 205 insertions(+), 77 deletions(-)

diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
index 1d53b62..fa99211 100644
--- a/fs/btrfs/acl.c
+++ b/fs/btrfs/acl.c
@@ -85,6 +85,9 @@ static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
 		btrfs_update_cached_acl(inode, p_acl, acl);
 	}
 
+	if (!acl && size < 0 && size != -ENODATA)
+		acl = ERR_PTR(size);
+
 	return acl;
 }
 
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ab07627..3ec7c0b 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -671,8 +671,9 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 			atomic_inc(&cb->pending_bios);
 
 			if (!btrfs_test_flag(inode, NODATASUM)) {
-				btrfs_lookup_bio_sums(root, inode, comp_bio,
-						      sums);
+				ret = btrfs_lookup_bio_sums(root, inode,
+							    comp_bio, sums);
+				BUG_ON(ret);
 			}
 			sums += (comp_bio->bi_size + root->sectorsize - 1) /
 				root->sectorsize;
@@ -697,8 +698,10 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	ret = btrfs_bio_wq_end_io(root->fs_info, comp_bio, 0);
 	BUG_ON(ret);
 
-	if (!btrfs_test_flag(inode, NODATASUM))
-		btrfs_lookup_bio_sums(root, inode, comp_bio, sums);
+	if (!btrfs_test_flag(inode, NODATASUM)) {
+		ret = btrfs_lookup_bio_sums(root, inode, comp_bio, sums);
+		BUG_ON(ret);
+	}
 
 	ret = btrfs_map_bio(root, READ, comp_bio, mirror_num, 0);
 	BUG_ON(ret);
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 42491d7..2259b6d 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -99,8 +99,10 @@ noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
 /* this also releases the path */
 void btrfs_free_path(struct btrfs_path *p)
 {
-	btrfs_release_path(NULL, p);
-	kmem_cache_free(btrfs_path_cachep, p);
+	if (p) {
+		btrfs_release_path(NULL, p);
+		kmem_cache_free(btrfs_path_cachep, p);
+	}
 }
 
 /*
@@ -113,6 +115,9 @@ noinline void btrfs_release_path(struct btrfs_root *root, struct btrfs_path *p)
 {
 	int i;
 
+	if (!p)
+		return;
+
 	for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
 		p->slots[i] = 0;
 		if (!p->nodes[i])
@@ -3579,7 +3584,9 @@ int btrfs_insert_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	unsigned long ptr;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
+
 	ret = btrfs_insert_empty_item(trans, root, path, cpu_key, data_size);
 	if (!ret) {
 		leaf = path->nodes[0];
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 926a0b2..2b36b44 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -145,7 +145,11 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	key.objectid = dir;
 	btrfs_set_key_type(&key, BTRFS_DIR_ITEM_KEY);
 	key.offset = btrfs_name_hash(name, name_len);
+
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
 	data_size = sizeof(*dir_item) + name_len;
 	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
 					name, name_len);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c7d4136..3e2688b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1111,7 +1111,10 @@ struct btrfs_root *btrfs_read_fs_root_no_radix(struct btrfs_root *tree_root,
 		     root, fs_info, location->objectid);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	ret = btrfs_search_slot(NULL, tree_root, location, path, 0, 0);
 	if (ret != 0) {
 		if (ret > 0)
@@ -1834,7 +1837,9 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 	csum_root->track_dirty = 1;
 
-	btrfs_read_block_groups(extent_root);
+	ret = btrfs_read_block_groups(extent_root);
+	if (ret)
+		goto fail_csum_root;
 
 	fs_info->generation = generation;
 	fs_info->last_trans_committed = generation;
diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 85315d2..3d3984b 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -148,6 +148,8 @@ static struct dentry *btrfs_get_parent(struct dentry *child)
 	int ret;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return ERR_PTR(-ENOMEM);
 
 	key.objectid = dir->i_ino;
 	btrfs_set_key_type(&key, BTRFS_INODE_REF_KEY);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ad699c2..ceef5be 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -399,7 +399,8 @@ int btrfs_lookup_extent(struct btrfs_root *root, u64 start, u64 len)
 	struct btrfs_path *path;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 	key.objectid = start;
 	key.offset = len;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
@@ -1218,7 +1219,8 @@ static int __btrfs_update_extent_ref(struct btrfs_trans_handle *trans,
 				    parent, ref_root, ref_generation,
 				    owner_objectid);
 	BUG_ON(ret);
-	finish_current_insert(trans, extent_root, 0);
+	ret = finish_current_insert(trans, extent_root, 0);
+	BUG_ON(ret);
 	del_pending_extents(trans, extent_root, 0);
 out:
 	btrfs_free_path(path);
@@ -1297,7 +1299,8 @@ static int __btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
 				    ref_root, ref_generation,
 				    owner_objectid);
 	BUG_ON(ret);
-	finish_current_insert(trans, root->fs_info->extent_root, 0);
+	ret = finish_current_insert(trans, root->fs_info->extent_root, 0);
+	BUG_ON(ret);
 	del_pending_extents(trans, root->fs_info->extent_root, 0);
 
 	btrfs_free_path(path);
@@ -1325,10 +1328,11 @@ int btrfs_extent_post_op(struct btrfs_trans_handle *trans,
 {
 	u64 start;
 	u64 end;
-	int ret;
 
 	while(1) {
-		finish_current_insert(trans, root->fs_info->extent_root, 1);
+		int ret = finish_current_insert(trans,
+						root->fs_info->extent_root, 1);
+		BUG_ON(ret);
 		del_pending_extents(trans, root->fs_info->extent_root, 1);
 
 		/* is there more work to do? */
@@ -1357,6 +1361,8 @@ int btrfs_lookup_extent_ref(struct btrfs_trans_handle *trans,
 
 	WARN_ON(num_bytes < root->sectorsize);
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	path->reada = 1;
 	key.objectid = bytenr;
 	key.offset = num_bytes;
@@ -1398,6 +1404,9 @@ int btrfs_cross_ref_exist(struct btrfs_trans_handle *trans,
 	key.type = BTRFS_EXTENT_ITEM_KEY;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
 	ret = btrfs_search_slot(NULL, extent_root, &key, path, 0, 0);
 	if (ret < 0)
 		goto out;
@@ -1806,7 +1815,8 @@ static int write_one_cache_group(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_release_path(extent_root, path);
 fail:
-	finish_current_insert(trans, extent_root, 0);
+	pending_ret = finish_current_insert(trans, extent_root, 0);
+	BUG_ON(pending_ret);
 	pending_ret = del_pending_extents(trans, extent_root, 0);
 	if (ret)
 		return ret;
@@ -2013,7 +2023,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	spin_unlock(&space_info->lock);
 
 	ret = btrfs_alloc_chunk(trans, extent_root, flags);
-	if (ret)
+	if (ret == -ENOSPC)
 		space_info->full = 1;
 out:
 	mutex_unlock(&extent_root->fs_info->chunk_mutex);
@@ -2236,6 +2246,8 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 	int num_inserts = 0, max_inserts, restart = 0;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	INIT_LIST_HEAD(&insert_list);
 	INIT_LIST_HEAD(&update_list);
 
@@ -2597,7 +2609,8 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 		BUG_ON(ret);
 	}
 	btrfs_free_path(path);
-	finish_current_insert(trans, extent_root, 0);
+	ret = finish_current_insert(trans, extent_root, 0);
+	BUG_ON(ret);
 	return ret;
 }
 
@@ -2805,8 +2818,11 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 	ret = __free_extent(trans, root, bytenr, num_bytes, parent,
 			    root_objectid, ref_generation,
 			    owner_objectid, pin, pin == 0);
+	/* JDM: Can this actually handle a failure? */
 
-	finish_current_insert(trans, root->fs_info->extent_root, 0);
+	pending_ret = finish_current_insert(trans,
+					    root->fs_info->extent_root, 0);
+	BUG_ON(pending_ret);
 	pending_ret = del_pending_extents(trans, root->fs_info->extent_root, 0);
 	return ret ? ret : pending_ret;
 }
@@ -3160,6 +3176,7 @@ again:
 				     BTRFS_BLOCK_GROUP_METADATA |
 				     (info->metadata_alloc_profile &
 				      info->avail_metadata_alloc_bits), 0);
+			/* JDM: Unhandled error */
 		}
 		ret = do_chunk_alloc(trans, root->fs_info->extent_root,
 				     num_bytes + 2 * 1024 * 1024, data, 0);
@@ -3175,8 +3192,9 @@ again:
 		num_bytes = num_bytes >> 1;
 		num_bytes = num_bytes & ~(root->sectorsize - 1);
 		num_bytes = max(num_bytes, min_alloc_size);
-		do_chunk_alloc(trans, root->fs_info->extent_root,
-			       num_bytes, data, 1);
+		ret = do_chunk_alloc(trans, root->fs_info->extent_root,
+				     num_bytes, data, 1);
+		/* JDM: Lost error */
 		goto again;
 	}
 	if (ret) {
@@ -3317,7 +3335,8 @@ static int __btrfs_alloc_reserved_extent(struct btrfs_trans_handle *trans,
 	trans->alloc_exclude_start = 0;
 	trans->alloc_exclude_nr = 0;
 	btrfs_free_path(path);
-	finish_current_insert(trans, extent_root, 0);
+	pending_ret = finish_current_insert(trans, extent_root, 0);
+	BUG_ON(pending_ret);
 	pending_ret = del_pending_extents(trans, extent_root, 0);
 
 	if (ret)
@@ -3370,8 +3389,9 @@ int btrfs_alloc_logged_extent(struct btrfs_trans_handle *trans,
 
 	block_group = btrfs_lookup_block_group(root->fs_info, ins->objectid);
 	mutex_lock(&block_group->cache_mutex);
-	cache_block_group(root, block_group);
+	ret = cache_block_group(root, block_group);
 	mutex_unlock(&block_group->cache_mutex);
+	BUG_ON(ret);
 
 	ret = btrfs_remove_free_space(block_group, ins->objectid,
 				      ins->offset);
@@ -4115,7 +4135,8 @@ int btrfs_drop_snapshot(struct btrfs_trans_handle *trans, struct btrfs_root
 
 	WARN_ON(!mutex_is_locked(&root->fs_info->drop_mutex));
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	level = btrfs_header_level(root->node);
 	orig_level = level;
@@ -4194,7 +4215,8 @@ int btrfs_drop_subtree(struct btrfs_trans_handle *trans,
 	int wret;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	BUG_ON(!btrfs_tree_locked(parent));
 	parent_level = btrfs_header_level(parent);
@@ -4639,7 +4661,10 @@ static noinline int get_new_locations(struct inode *reloc_inode,
 	}
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path) {
+		kfree(exts);
+		return -ENOMEM;
+	}
 
 	cur_pos = extent_key->objectid - offset;
 	last_byte = extent_key->objectid + extent_key->offset;
@@ -5262,7 +5287,7 @@ int btrfs_drop_dead_reloc_roots(struct btrfs_root *root)
 	struct btrfs_root *reloc_root;
 	struct btrfs_root *prev_root = NULL;
 	struct list_head dead_roots;
-	int ret;
+	int ret = 0;
 	unsigned long nr;
 
 	INIT_LIST_HEAD(&dead_roots);
@@ -5289,6 +5314,7 @@ int btrfs_drop_dead_reloc_roots(struct btrfs_root *root)
 			BUG_ON(ret);
 			btrfs_btree_balance_dirty(root, nr);
 		}
+		BUG_ON(ret);
 
 		free_extent_buffer(reloc_root->node);
 
@@ -5778,6 +5804,7 @@ static int __alloc_chunk_for_shrink(struct btrfs_root *root,
 
 		do_chunk_alloc(trans, root->fs_info->extent_root,
 			       calc + 2 * 1024 * 1024, new_alloc_flags, force);
+		/* JDM: Lost error */
 
 		btrfs_end_transaction(trans, root);
 	} else
@@ -5894,6 +5921,7 @@ int btrfs_reloc_clone_csums(struct inode *inode, u64 file_pos, u64 len)
 	disk_bytenr = file_pos + BTRFS_I(inode)->index_cnt;
 	ret = btrfs_lookup_csums_range(root->fs_info->csum_root, disk_bytenr,
 				       disk_bytenr + len - 1, &list);
+	BUG_ON(ret);
 
 	while (!list_empty(&list)) {
 		sums = list_entry(list.next, struct btrfs_ordered_sum, list);
@@ -5942,7 +5970,8 @@ int btrfs_relocate_block_group(struct btrfs_root *root, u64 group_start)
 	       (unsigned long long)block_group->flags);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	reloc_inode = create_reloc_inode(info, block_group);
 	BUG_ON(IS_ERR(reloc_inode));
@@ -6251,7 +6280,8 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 				sizeof(cache->item));
 	BUG_ON(ret);
 
-	finish_current_insert(trans, extent_root, 0);
+	ret = finish_current_insert(trans, extent_root, 0);
+	BUG_ON(ret);
 	ret = del_pending_extents(trans, extent_root, 0);
 	BUG_ON(ret);
 	set_avail_alloc_bits(extent_root->fs_info, type);
@@ -6276,7 +6306,10 @@ int btrfs_remove_block_group(struct btrfs_trans_handle *trans,
 	memcpy(&key, &block_group->key, sizeof(key));
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path) {
+		put_block_group(block_group);
+		return -ENOMEM;
+	}
 
 	spin_lock(&root->fs_info->block_group_cache_lock);
 	rb_erase(&block_group->cache_node,
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 9646524..f2f14f2 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -47,7 +47,9 @@ int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 	struct extent_buffer *leaf;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
+
 	file_key.objectid = objectid;
 	file_key.offset = pos;
 	btrfs_set_key_type(&file_key, BTRFS_EXTENT_DATA_KEY);
@@ -166,6 +168,9 @@ int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
 	if (bio->bi_size > PAGE_CACHE_SIZE * 8)
 		path->reada = 2;
 
@@ -259,7 +264,8 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 	u16 csum_size = btrfs_super_csum_size(&root->fs_info->super_copy);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
 	key.offset = start;
@@ -517,6 +523,8 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 	root = root->fs_info->csum_root;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 
 	while (1) {
 		key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
@@ -637,7 +645,8 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 		btrfs_super_csum_size(&root->fs_info->super_copy);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 	sector_sum = sums->sums;
 again:
 	next_offset = (u64)-1;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index c5419a4..2ecf07b 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -289,6 +289,8 @@ int btrfs_check_file(struct btrfs_root *root, struct inode *inode)
 	u64 extent_end = 0;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	ret = btrfs_lookup_file_extent(NULL, root, path, inode->i_ino,
 				       last_offset, 0);
 	while (1) {
@@ -748,7 +750,8 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 	btrfs_drop_extent_cache(inode, start, end - 1, 0);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 again:
 	key.objectid = inode->i_ino;
 	key.type = BTRFS_EXTENT_DATA_KEY;
diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index cc7334d..fad09ae 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -30,7 +30,8 @@ int btrfs_find_highest_inode(struct btrfs_root *root, u64 *objectid)
 	int slot;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	search_key.objectid = BTRFS_LAST_FREE_OBJECTID;
 	search_key.type = -1;
@@ -78,7 +79,10 @@ int btrfs_find_free_objectid(struct btrfs_trans_handle *trans,
 		return 0;
 	}
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path) {
+		ret = -ENOMEM;
+		goto error;
+	}
 	search_start = max(search_start, BTRFS_FIRST_FREE_OBJECTID);
 	search_key.objectid = search_start;
 	search_key.type = 0;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 18a65f6..67caee2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -987,7 +987,8 @@ static int run_delalloc_nocow(struct inode *inode, struct page *locked_page,
 	int check_prev = 1;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 	trans = btrfs_join_transaction(root, 1);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
@@ -1325,8 +1326,10 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 		if (bio_flags & EXTENT_BIO_COMPRESSED) {
 			return btrfs_submit_compressed_read(inode, bio,
 						    mirror_num, bio_flags);
-		} else if (!skip_sum)
-			btrfs_lookup_bio_sums(root, inode, bio, NULL);
+		} else if (!skip_sum) {
+			ret = btrfs_lookup_bio_sums(root, inode, bio, NULL);
+			BUG_ON(ret);
+		}
 		goto mapit;
 	} else if (!skip_sum) {
 		/* csum items have already been cloned */
@@ -1352,14 +1355,17 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
 			     struct list_head *list)
 {
 	struct btrfs_ordered_sum *sum;
+	int err = 0;
 
 	btrfs_set_trans_block_group(trans, inode);
 
 	list_for_each_entry(sum, list, list) {
-		btrfs_csum_file_blocks(trans,
+		err = btrfs_csum_file_blocks(trans,
 		       BTRFS_I(inode)->root->fs_info->csum_root, sum);
+		if (err)
+			break;
 	}
-	return 0;
+	return err;
 }
 
 int btrfs_set_extent_delalloc(struct inode *inode, u64 start, u64 end)
@@ -1478,7 +1484,8 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 	int ret;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	ret = btrfs_drop_extents(trans, root, inode, file_pos,
 				 file_pos + num_bytes, file_pos, &hint);
@@ -1571,8 +1578,9 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 		    ordered_extent->file_offset + ordered_extent->len - 1,
 		    GFP_NOFS);
 nocow:
-	add_pending_csums(trans, inode, ordered_extent->file_offset,
-			  &ordered_extent->list);
+	ret = add_pending_csums(trans, inode, ordered_extent->file_offset,
+				&ordered_extent->list);
+	BUG_ON(ret);
 
 	mutex_lock(&BTRFS_I(inode)->extent_mutex);
 	btrfs_ordered_update_i_size(inode, ordered_extent);
@@ -2000,7 +2008,10 @@ void btrfs_read_locked_inode(struct inode *inode)
 	int ret;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path) {
+		ret = -ENOMEM;
+		goto make_bad;
+	}
 	memcpy(&location, &BTRFS_I(inode)->location, sizeof(location));
 
 	ret = btrfs_lookup_inode(NULL, root, path, &location, 0);
@@ -2128,7 +2139,9 @@ noinline int btrfs_update_inode(struct btrfs_trans_handle *trans,
 	int ret;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
+
 	ret = btrfs_lookup_inode(trans, root, path,
 				 &BTRFS_I(inode)->location, 1);
 	if (ret) {
@@ -2263,7 +2276,7 @@ static int btrfs_unlink(struct inode *dir, struct dentry *dentry)
 	ret = btrfs_unlink_inode(trans, root, dir, dentry->d_inode,
 				 dentry->d_name.name, dentry->d_name.len);
 
-	if (inode->i_nlink == 0)
+	if (!ret && inode->i_nlink == 0) /* JDM: Check this */
 		ret = btrfs_orphan_add(trans, inode);
 
 	nr = trans->blocks_used;
@@ -2535,8 +2548,9 @@ noinline int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 	if (root->ref_cows)
 		btrfs_drop_extent_cache(inode, new_size & (~mask), (u64)-1, 0);
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	path->reada = -1;
-	BUG_ON(!path);
 
 	/* FIXME, add redo link to tree so we don't leak on crash */
 	key.objectid = inode->i_ino;
@@ -2969,7 +2983,8 @@ static int btrfs_inode_by_name(struct inode *dir, struct dentry *dentry,
 	int ret = 0;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	di = btrfs_lookup_dir_item(NULL, root, path, dir->i_ino, name,
 				    namelen, 0);
@@ -3452,7 +3467,8 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 	int owner;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return ERR_PTR(-ENOMEM);
 
 	inode = new_inode(root->fs_info->sb);
 	if (!inode)
@@ -3631,10 +3647,8 @@ static int btrfs_mknod(struct inode *dir, struct dentry *dentry,
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
-	if (err) {
-		err = -ENOSPC;
+	if (err)
 		goto out_unlock;
-	}
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len,
@@ -3697,10 +3711,8 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
-	if (err) {
-		err = -ENOSPC;
+	if (err)
 		goto out_unlock;
-	}
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len,
@@ -3822,10 +3834,8 @@ static int btrfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
-	if (err) {
-		err = -ENOSPC;
+	if (err)
 		goto out_unlock;
-	}
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len,
@@ -4453,6 +4463,7 @@ static void btrfs_truncate(struct inode *inode)
 	/* FIXME, add redo link to tree so we don't leak on crash */
 	ret = btrfs_truncate_inode_items(trans, root, inode, inode->i_size,
 				      BTRFS_EXTENT_DATA_KEY);
+	/* JDM: Check error */
 	btrfs_update_inode(trans, root, inode);
 
 	ret = btrfs_orphan_del(trans, inode);
@@ -4794,10 +4805,8 @@ static int btrfs_symlink(struct inode *dir, struct dentry *dentry,
 	btrfs_set_trans_block_group(trans, dir);
 
 	err = btrfs_find_free_objectid(trans, root, dir->i_ino, &objectid);
-	if (err) {
-		err = -ENOSPC;
+	if (err)
 		goto out_unlock;
-	}
 
 	inode = btrfs_new_inode(trans, root, dir, dentry->d_name.name,
 				dentry->d_name.len,
@@ -4977,7 +4986,7 @@ static long btrfs_fallocate(struct inode *inode, int mode,
 	while (1) {
 		em = btrfs_get_extent(inode, NULL, 0, cur_offset,
 				      alloc_end - cur_offset, 0);
-		BUG_ON(IS_ERR(em) || !em);
+		BUG_ON(IS_ERR(em));
 		last_byte = min(extent_map_end(em), alloc_end);
 		last_byte = (last_byte + mask) & ~mask;
 		if (em->block_start == EXTENT_MAP_HOLE) {
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4b62868..11afb1a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -302,11 +302,15 @@ static noinline int btrfs_mksubvol(struct path *parent, char *name,
 	if (snap_src) {
 		struct dentry *dir = dentry->d_parent;
 		struct dentry *test = dir->d_parent;
-		struct btrfs_path *path = btrfs_alloc_path();
+		struct btrfs_path *path;
 		int ret;
 		u64 test_oid;
 		u64 parent_oid = BTRFS_I(dir->d_inode)->root->root_key.objectid;
 
+		path = btrfs_alloc_path();
+		if (!path)
+			return -ENOMEM;
+
 		test_oid = snap_src->root_key.objectid;
 
 		ret = btrfs_find_root_ref(snap_src->fs_info->tree_root,
@@ -852,7 +856,10 @@ static long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	}
 
 	/* punch hole in destination first */
-	btrfs_drop_extents(trans, root, inode, off, off+len, 0, &hint_byte);
+	ret = btrfs_drop_extents(trans, root, inode, off, off+len, 0,
+				 &hint_byte);
+	if (ret)
+		goto out;
 
 	/* clone data */
 	key.objectid = src->i_ino;
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index b48650d..1d8669d 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -40,7 +40,8 @@ int btrfs_search_root(struct btrfs_root *root, u64 search_start,
 	search_key.offset = (u64)-1;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 again:
 	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
 	if (ret < 0)
@@ -88,7 +89,8 @@ int btrfs_find_last_root(struct btrfs_root *root, u64 objectid,
 	search_key.offset = (u64)-1;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
 	if (ret < 0)
 		goto out;
@@ -125,7 +127,8 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 	unsigned long ptr;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
 	if (ret < 0)
 		goto out;
@@ -255,7 +258,8 @@ int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	struct extent_buffer *leaf;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 	ret = btrfs_search_slot(trans, root, key, path, -1, 1);
 	if (ret < 0)
 		goto out;
@@ -283,6 +287,8 @@ int btrfs_del_root_ref(struct btrfs_trans_handle *trans,
 	struct btrfs_path *path;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 
 	key.objectid = root_id;
 	key.type = type;
@@ -343,6 +349,8 @@ int btrfs_add_root_ref(struct btrfs_trans_handle *trans,
 
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 
 	key.objectid = root_id;
 	key.type = type;
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index fa07264..508d764 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -433,7 +433,8 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
 	struct btrfs_root *tree_root = root->fs_info->tree_root;
 
 	btrfs_extent_post_op(trans, root);
-	btrfs_write_dirty_block_groups(trans, root);
+	ret = btrfs_write_dirty_block_groups(trans, root);
+	BUG_ON(ret);
 	btrfs_extent_post_op(trans, root);
 
 	while (1) {
@@ -452,7 +453,8 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
 					&root->root_key,
 					&root->root_item);
 		BUG_ON(ret);
-		btrfs_write_dirty_block_groups(trans, root);
+		ret = btrfs_write_dirty_block_groups(trans, root);
+		BUG_ON(ret);
 		btrfs_extent_post_op(trans, root);
 	}
 	return 0;
@@ -567,6 +569,7 @@ static noinline int add_dirty_roots(struct btrfs_trans_handle *trans,
 						root->fs_info->tree_root,
 						&root->root_key,
 						&root->root_item);
+				/* JDM: Check error */
 				continue;
 			}
 
@@ -629,6 +632,7 @@ int btrfs_defrag_root(struct btrfs_root *root, int cacheonly)
 	while (1) {
 		root->defrag_running = 1;
 		ret = btrfs_defrag_leaves(trans, root, cacheonly);
+		/* JDM: unhandled error */
 		nr = trans->blocks_used;
 		btrfs_end_transaction(trans, root);
 		btrfs_btree_balance_dirty(info->tree_root, nr);
@@ -693,6 +697,7 @@ static noinline int drop_dirty_roots(struct btrfs_root *tree_root,
 					&dirty->root->root_item);
 			if (err)
 				ret = err;
+			/* JDM: Lost error */
 			nr = trans->blocks_used;
 			ret = btrfs_end_transaction(trans, tree_root);
 			BUG_ON(ret);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index b161e63..32704dd 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -512,7 +512,9 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 						path->nodes[0]->start,
 						root->root_key.objectid,
 						trans->transid, key->objectid);
+				BUG_ON(ret < 0);
 			} else {
+				BUG_ON(ret < 0);
 				/*
 				 * insert the extent pointer in the extent
 				 * allocation tree
@@ -673,6 +675,9 @@ static noinline int backref_in_log(struct btrfs_root *log,
 	int match = 0;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
 	ret = btrfs_search_slot(NULL, log, key, path, 0, 0);
 	if (ret != 0)
 		goto out;
@@ -800,8 +805,9 @@ conflict_again:
 					   (unsigned long)(victim_ref + 1),
 					   victim_name_len);
 
-			if (!backref_in_log(log, key, victim_name,
-					    victim_name_len)) {
+			ret = backref_in_log(log, key, victim_name,
+					    victim_name_len);
+			if (!ret) {
 				btrfs_inc_nlink(inode);
 				btrfs_release_path(root, path);
 				ret = btrfs_unlink_inode(trans, root, dir,
@@ -811,6 +817,7 @@ conflict_again:
 				btrfs_release_path(root, path);
 				goto conflict_again;
 			}
+			BUG_ON(ret < 0);
 			kfree(victim_name);
 			ptr = (unsigned long)(victim_ref + 1) + victim_name_len;
 		}
@@ -889,6 +896,8 @@ static noinline int fixup_inode_link_count(struct btrfs_trans_handle *trans,
 	key.offset = (u64)-1;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 
 	while (1) {
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
@@ -1495,7 +1504,8 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 		return 0;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	nritems = btrfs_header_nritems(eb);
 	for (i = 0; i < nritems; i++) {
@@ -1760,7 +1770,8 @@ static int walk_log_tree(struct btrfs_trans_handle *trans,
 	int orig_level;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	level = btrfs_header_level(log->node);
 	orig_level = level;
@@ -2084,6 +2095,11 @@ int btrfs_del_dir_entries_in_log(struct btrfs_trans_handle *trans,
 
 	log = root->log_root;
 	path = btrfs_alloc_path();
+	if (!path) {
+		mutex_unlock(&BTRFS_I(dir)->log_mutex);
+		return -ENOMEM;
+	}
+
 	di = btrfs_lookup_dir_item(trans, log, path, dir->i_ino,
 				   name, name_len, -1);
 	if (di && !IS_ERR(di)) {
@@ -2578,7 +2594,13 @@ static int __btrfs_log_inode(struct btrfs_trans_handle *trans,
 	log = root->log_root;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	dst_path = btrfs_alloc_path();
+	if (!dst_path) {
+		btrfs_free_path(path);
+		return -ENOMEM;
+	}
 
 	min_key.objectid = inode->i_ino;
 	min_key.type = BTRFS_INODE_ITEM_KEY;
@@ -2790,7 +2812,8 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
 
 	fs_info->log_root_recovering = 1;
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	trans = btrfs_start_transaction(fs_info->tree_root, 1);
 	if (IS_ERR(trans)) {
@@ -2801,7 +2824,8 @@ int btrfs_recover_log_trees(struct btrfs_root *log_root_tree)
 	wc.trans = trans;
 	wc.pin = 1;
 
-	walk_log_tree(trans, log_root_tree, &wc);
+	ret = walk_log_tree(trans, log_root_tree, &wc);
+	BUG_ON(ret);
 
 again:
 	key.objectid = BTRFS_TREE_LOG_OBJECTID;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1b35ae0..9bcf290 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -807,7 +807,8 @@ static noinline int find_next_chunk(struct btrfs_root *root,
 	struct btrfs_key found_key;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	if (!path)
+		return -ENOMEM;
 
 	key.objectid = objectid;
 	key.offset = (u64)-1;
@@ -1381,6 +1382,7 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 		BUG_ON(ret);
 	} else {
 		ret = btrfs_add_device(trans, root, device);
+		BUG_ON(ret);
 	}
 
 	unlock_chunks(root);
-- 
1.6.0.2

