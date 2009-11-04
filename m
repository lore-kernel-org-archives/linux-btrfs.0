From: Jeff Mahoney <jeffm@suse.com>
Subject: [patch 10/10] btrfs: annotate btrfs_alloc_path failures
Date: Wed, 04 Nov 2009 14:03:56 -0500
Message-ID: <20091104190434.840598938@suse.com>
References: <20091104190346.971762946@suse.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds checks for btrfs_alloc_path failures and annotates them
with BTRFS_UERROR.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

---
 fs/btrfs/ctree.c       |    2 +-
 fs/btrfs/dir-item.c    |    1 +
 fs/btrfs/disk-io.c     |    2 +-
 fs/btrfs/export.c      |    1 +
 fs/btrfs/extent-tree.c |   14 +++++++-------
 fs/btrfs/file-item.c   |    8 +++++---
 fs/btrfs/file.c        |    2 +-
 fs/btrfs/inode-map.c   |    2 +-
 fs/btrfs/inode.c       |   19 ++++++++++---------
 fs/btrfs/root-tree.c   |    8 ++++----
 fs/btrfs/tree-log.c    |   11 ++++++++---
 fs/btrfs/volumes.c     |    4 ++--
 12 files changed, 42 insertions(+), 32 deletions(-)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3635,7 +3635,7 @@ int btrfs_insert_item(struct btrfs_trans
 	unsigned long ptr;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 	ret = btrfs_insert_empty_item(trans, root, path, cpu_key, data_size);
 	if (!ret) {
 		leaf = path->nodes[0];
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -147,6 +147,7 @@ int btrfs_insert_dir_item(struct btrfs_t
 	key.offset = btrfs_name_hash(name, name_len);
 
 	path = btrfs_alloc_path();
+	BTRFS_UERROR(!path);
 	path->leave_spinning = 1;
 
 	data_size = sizeof(*dir_item) + name_len;
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1123,7 +1123,7 @@ struct btrfs_root *btrfs_read_fs_root_no
 		     root, fs_info, location->objectid);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 	ret = btrfs_search_slot(NULL, tree_root, location, path, 0, 0);
 	if (ret == 0) {
 		l = path->nodes[0];
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -176,6 +176,7 @@ static struct dentry *btrfs_get_parent(s
 	int ret;
 
 	path = btrfs_alloc_path();
+	BTRFS_UERROR(!path);
 
 	if (dir->i_ino == BTRFS_FIRST_FREE_OBJECTID) {
 		key.objectid = root->root_key.objectid;
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -583,7 +583,7 @@ int btrfs_lookup_extent(struct btrfs_roo
 	struct btrfs_path *path;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 	key.objectid = start;
 	key.offset = len;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_ITEM_KEY);
@@ -4607,7 +4607,7 @@ static int alloc_reserved_file_extent(st
 	size = sizeof(*extent_item) + btrfs_extent_inline_ref_size(type);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 
 	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
@@ -4668,7 +4668,7 @@ static int alloc_reserved_tree_block(str
 	u32 size = sizeof(*extent_item) + sizeof(*block_info) + sizeof(*iref);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 
 	path->leave_spinning = 1;
 	ret = btrfs_insert_empty_item(trans, fs_info->extent_root, path,
@@ -5388,7 +5388,7 @@ int btrfs_drop_snapshot(struct btrfs_roo
 	int level;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 
 	wc = kzalloc(sizeof(*wc), GFP_NOFS);
 	if (!wc) {
@@ -5559,7 +5559,7 @@ int btrfs_drop_subtree(struct btrfs_tran
 	BUG_ON(root->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 
 	wc = kzalloc(sizeof(*wc), GFP_NOFS);
 	if (!wc) {
@@ -6021,7 +6021,7 @@ static noinline int get_new_locations(st
 	}
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 
 	cur_pos = extent_key->objectid - offset;
 	last_byte = extent_key->objectid + extent_key->offset;
@@ -7578,7 +7578,7 @@ int btrfs_remove_block_group(struct btrf
 	spin_unlock(&cluster->refill_lock);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 
 	spin_lock(&root->fs_info->block_group_cache_lock);
 	rb_erase(&block_group->cache_node,
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -47,7 +47,7 @@ int btrfs_insert_file_extent(struct btrf
 	struct extent_buffer *leaf;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 	file_key.objectid = objectid;
 	file_key.offset = pos;
 	btrfs_set_key_type(&file_key, BTRFS_EXTENT_DATA_KEY);
@@ -167,6 +167,7 @@ int btrfs_lookup_bio_sums(struct btrfs_r
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 
 	path = btrfs_alloc_path();
+	BTRFS_UERROR(!path);
 	if (bio->bi_size > PAGE_CACHE_SIZE * 8)
 		path->reada = 2;
 
@@ -260,7 +261,7 @@ int btrfs_lookup_csums_range(struct btrf
 	u16 csum_size = btrfs_super_csum_size(&root->fs_info->super_copy);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 
 	key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
 	key.offset = start;
@@ -518,6 +519,7 @@ int btrfs_del_csums(struct btrfs_trans_h
 	root = root->fs_info->csum_root;
 
 	path = btrfs_alloc_path();
+	BTRFS_UERROR(!path);
 
 	while (1) {
 		key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
@@ -639,7 +641,7 @@ int btrfs_csum_file_blocks(struct btrfs_
 		btrfs_super_csum_size(&root->fs_info->super_copy);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 	sector_sum = sums->sums;
 again:
 	next_offset = (u64)-1;
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -642,7 +642,7 @@ int btrfs_mark_extent_written(struct btr
 	btrfs_drop_extent_cache(inode, start, end - 1, 0);
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 again:
 	key.objectid = inode->i_ino;
 	key.type = BTRFS_EXTENT_DATA_KEY;
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -30,7 +30,7 @@ int btrfs_find_highest_inode(struct btrf
 	int slot;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 
 	search_key.objectid = BTRFS_LAST_FREE_OBJECTID;
 	search_key.type = -1;
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -997,7 +997,7 @@ static noinline int run_delalloc_nocow(s
 	int check_prev = 1;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 	trans = btrfs_join_transaction(root, 1);
 	if (IS_ERR(trans))
 		return PTR_ERR(trans);
@@ -1597,7 +1597,7 @@ static int insert_reserved_file_extent(s
 	int ret;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 
 	path->leave_spinning = 1;
 
@@ -2236,7 +2236,7 @@ static void btrfs_read_locked_inode(stru
 	int ret;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 	memcpy(&location, &BTRFS_I(inode)->location, sizeof(location));
 
 	ret = btrfs_lookup_inode(NULL, root, path, &location, 0);
@@ -2374,7 +2374,7 @@ noinline int btrfs_update_inode(struct b
 	int ret;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 	path->leave_spinning = 1;
 	ret = btrfs_lookup_inode(trans, root, path,
 				 &BTRFS_I(inode)->location, 1);
@@ -2834,7 +2834,7 @@ noinline int btrfs_truncate_inode_items(
 	if (root->ref_cows)
 		btrfs_drop_extent_cache(inode, new_size & (~mask), (u64)-1, 0);
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 	path->reada = -1;
 
 	/* FIXME, add redo link to tree so we don't leak on crash */
@@ -3313,7 +3313,7 @@ static int btrfs_inode_by_name(struct in
 	int ret = 0;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 
 	di = btrfs_lookup_dir_item(NULL, root, path, dir->i_ino, name,
 				    namelen, 0);
@@ -3756,6 +3756,7 @@ static int btrfs_real_readdir(struct fil
 		filp->f_pos = 2;
 	}
 	path = btrfs_alloc_path();
+	BTRFS_UERROR(!path);
 	path->reada = 2;
 
 	btrfs_set_key_type(&key, key_type);
@@ -3992,7 +3993,7 @@ static struct inode *btrfs_new_inode(str
 	int owner;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 
 	inode = new_inode(root->fs_info->sb);
 	if (!inode)
@@ -4572,7 +4573,7 @@ again:
 
 	if (!path) {
 		path = btrfs_alloc_path();
-		BUG_ON(!path);
+		BTRFS_UERROR(!path);
 	}
 
 	ret = btrfs_lookup_file_extent(trans, root, path,
@@ -5586,7 +5587,7 @@ static int btrfs_symlink(struct inode *d
 		goto out_unlock;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 	key.objectid = inode->i_ino;
 	key.offset = 0;
 	btrfs_set_key_type(&key, BTRFS_EXTENT_DATA_KEY);
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -40,7 +40,7 @@ int btrfs_search_root(struct btrfs_root
 	search_key.offset = (u64)-1;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 again:
 	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
 	if (ret < 0)
@@ -88,7 +88,7 @@ int btrfs_find_last_root(struct btrfs_ro
 	search_key.offset = (u64)-1;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
 	if (ret < 0)
 		goto out;
@@ -140,7 +140,7 @@ int btrfs_update_root(struct btrfs_trans
 	unsigned long ptr;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
 	if (ret < 0)
 		goto out;
@@ -319,7 +319,7 @@ int btrfs_del_root(struct btrfs_trans_ha
 	struct extent_buffer *leaf;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 	ret = btrfs_search_slot(trans, root, key, path, -1, 1);
 	if (ret < 0)
 		goto out;
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -744,6 +744,7 @@ static noinline int backref_in_log(struc
 	int match = 0;
 
 	path = btrfs_alloc_path();
+	BTRFS_UERROR(!path);
 	ret = btrfs_search_slot(NULL, log, key, path, 0, 0);
 	if (ret != 0)
 		goto out;
@@ -961,6 +962,7 @@ static noinline int fixup_inode_link_cou
 	key.offset = (u64)-1;
 
 	path = btrfs_alloc_path();
+	BTRFS_UERROR(!path);
 
 	while (1) {
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
@@ -1585,7 +1587,7 @@ static int replay_one_buffer(struct btrf
 		return 0;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 
 	nritems = btrfs_header_nritems(eb);
 	for (i = 0; i < nritems; i++) {
@@ -1848,7 +1850,7 @@ static int walk_log_tree(struct btrfs_tr
 	int orig_level;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 
 	level = btrfs_header_level(log->node);
 	orig_level = level;
@@ -2217,6 +2219,7 @@ int btrfs_del_dir_entries_in_log(struct
 
 	log = root->log_root;
 	path = btrfs_alloc_path();
+	BTRFS_UERROR(!path);
 	di = btrfs_lookup_dir_item(trans, log, path, dir->i_ino,
 				   name, name_len, -1);
 	if (di && !IS_ERR(di)) {
@@ -2708,7 +2711,9 @@ static int btrfs_log_inode(struct btrfs_
 	log = root->log_root;
 
 	path = btrfs_alloc_path();
+	BTRFS_UERROR(!path);
 	dst_path = btrfs_alloc_path();
+	BTRFS_UERROR(!dst_path);
 
 	min_key.objectid = inode->i_ino;
 	min_key.type = BTRFS_INODE_ITEM_KEY;
@@ -3021,7 +3026,7 @@ int btrfs_recover_log_trees(struct btrfs
 
 	fs_info->log_root_recovering = 1;
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 
 	trans = btrfs_start_transaction(fs_info->tree_root, 1);
 	if (IS_ERR(trans)) {
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -946,7 +946,7 @@ static noinline int find_next_chunk(stru
 	struct btrfs_key found_key;
 
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 
 	key.objectid = objectid;
 	key.offset = (u64)-1;
@@ -1943,7 +1943,7 @@ int btrfs_balance(struct btrfs_root *dev
 
 	/* step two, relocate all the chunks */
 	path = btrfs_alloc_path();
-	BUG_ON(!path);
+	BTRFS_UERROR(!path);
 
 	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
 	key.offset = (u64)-1;

