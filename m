Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:51096 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752498AbeDLKAI (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 12 Apr 2018 06:00:08 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH for 4.7-rc 1/2] btrfs: Remove first key verification since it's causing false alerts
Date: Thu, 12 Apr 2018 18:00:02 +0800
Message-Id: <20180412100003.31907-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When looping btrfs/074 with many cpus (>= 8), it's possible to trigger
kernel warning due to first key verification:

[ 4239.523446] WARNING: CPU: 5 PID: 2381 at fs/btrfs/disk-io.c:460 btree_read_extent_buffer_pages+0x1ad/0x210
[ 4239.523830] Modules linked in:
[ 4239.524630] RIP: 0010:btree_read_extent_buffer_pages+0x1ad/0x210
[ 4239.527101] Call Trace:
[ 4239.527251]  read_tree_block+0x42/0x70
[ 4239.527434]  read_node_slot+0xd2/0x110
[ 4239.527632]  push_leaf_right+0xad/0x1b0
[ 4239.527809]  split_leaf+0x4ea/0x700
[ 4239.527988]  ? leaf_space_used+0xbc/0xe0
[ 4239.528192]  ? btrfs_set_lock_blocking_rw+0x99/0xb0
[ 4239.528416]  btrfs_search_slot+0x8cc/0xa40
[ 4239.528605]  btrfs_insert_empty_items+0x71/0xc0
[ 4239.528798]  __btrfs_run_delayed_refs+0xa98/0x1680
[ 4239.529013]  btrfs_run_delayed_refs+0x10b/0x1b0
[ 4239.529205]  btrfs_commit_transaction+0x33/0xaf0
[ 4239.529445]  ? start_transaction+0xa8/0x4f0
[ 4239.529630]  btrfs_alloc_data_chunk_ondemand+0x1b0/0x4e0
[ 4239.529833]  btrfs_check_data_free_space+0x54/0xa0
[ 4239.530045]  btrfs_delalloc_reserve_space+0x25/0x70
[ 4239.531907]  btrfs_direct_IO+0x233/0x3d0
[ 4239.532098]  generic_file_direct_write+0xcb/0x170
[ 4239.532296]  btrfs_file_write_iter+0x2bb/0x5f4
[ 4239.532491]  aio_write+0xe2/0x180
[ 4239.532669]  ? lock_acquire+0xac/0x1e0
[ 4239.532839]  ? __might_fault+0x3e/0x90
[ 4239.533032]  do_io_submit+0x594/0x860
[ 4239.533223]  ? do_io_submit+0x594/0x860
[ 4239.533398]  SyS_io_submit+0x10/0x20
[ 4239.533560]  ? SyS_io_submit+0x10/0x20
[ 4239.533729]  do_syscall_64+0x75/0x1d0
[ 4239.533979]  entry_SYSCALL_64_after_hwframe+0x42/0xb7
[ 4239.534182] RIP: 0033:0x7f8519741697

The possibility is low, around 4~7/128 runs with 8 cores.
The problem here is, at btree_read_extent_buffer_pages() we don't have
acquired read/write lock on that extent buffer, only basic info like
level/bytenr is reliable.

To get correct first key, we must require at least read lock for that
extent buffer, which can't be done in btree_read_extent_buffer_pages(),
but deep into core btree operation code.

This patch will remove the unreliable first key check to avoid false
alerts, and allow later patch to re-implement first key check correctly.

Reported-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/backref.c     |  4 +--
 fs/btrfs/ctree.c       | 20 +++++----------
 fs/btrfs/disk-io.c     | 56 ++++++++++--------------------------------
 fs/btrfs/disk-io.h     |  6 ++---
 fs/btrfs/extent-tree.c |  6 +----
 fs/btrfs/print-tree.c  |  4 +--
 fs/btrfs/qgroup.c      |  6 ++---
 fs/btrfs/ref-verify.c  |  6 +----
 fs/btrfs/relocation.c  | 17 +++----------
 fs/btrfs/tree-log.c    | 11 +++------
 10 files changed, 36 insertions(+), 100 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 571024bc632e..a0a3ccf922e8 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -739,7 +739,7 @@ static int add_missing_keys(struct btrfs_fs_info *fs_info,
 		BUG_ON(!ref->wanted_disk_byte);
 
 		eb = read_tree_block(fs_info, ref->wanted_disk_byte, 0,
-				     ref->level - 1, NULL);
+				     ref->level - 1);
 		if (IS_ERR(eb)) {
 			free_pref(ref);
 			return PTR_ERR(eb);
@@ -1290,7 +1290,7 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 				struct extent_buffer *eb;
 
 				eb = read_tree_block(fs_info, ref->parent, 0,
-						     ref->level, NULL);
+						     ref->level);
 				if (IS_ERR(eb)) {
 					ret = PTR_ERR(eb);
 					goto out;
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index a2c9d21176e2..e044b51a2789 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1375,7 +1375,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 	if (old_root && tm && tm->op != MOD_LOG_KEY_REMOVE_WHILE_FREEING) {
 		btrfs_tree_read_unlock(eb_root);
 		free_extent_buffer(eb_root);
-		old = read_tree_block(fs_info, logical, 0, level, NULL);
+		old = read_tree_block(fs_info, logical, 0, level);
 		if (WARN_ON(IS_ERR(old) || !extent_buffer_uptodate(old))) {
 			if (!IS_ERR(old))
 				free_extent_buffer(old);
@@ -1595,7 +1595,6 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 	btrfs_set_lock_blocking(parent);
 
 	for (i = start_slot; i <= end_slot; i++) {
-		struct btrfs_key first_key;
 		int close = 1;
 
 		btrfs_node_key(parent, &disk_key, i);
@@ -1605,7 +1604,6 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 		progress_passed = 1;
 		blocknr = btrfs_node_blockptr(parent, i);
 		gen = btrfs_node_ptr_generation(parent, i);
-		btrfs_node_key_to_cpu(parent, &first_key, i);
 		if (last_block == 0)
 			last_block = blocknr;
 
@@ -1630,8 +1628,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 		if (!cur || !uptodate) {
 			if (!cur) {
 				cur = read_tree_block(fs_info, blocknr, gen,
-						      parent_level - 1,
-						      &first_key);
+						      parent_level - 1);
 				if (IS_ERR(cur)) {
 					return PTR_ERR(cur);
 				} else if (!extent_buffer_uptodate(cur)) {
@@ -1640,7 +1637,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 				}
 			} else if (!uptodate) {
 				err = btrfs_read_buffer(cur, gen,
-						parent_level - 1,&first_key);
+						parent_level - 1);
 				if (err) {
 					free_extent_buffer(cur);
 					return err;
@@ -1793,17 +1790,15 @@ read_node_slot(struct btrfs_fs_info *fs_info, struct extent_buffer *parent,
 {
 	int level = btrfs_header_level(parent);
 	struct extent_buffer *eb;
-	struct btrfs_key first_key;
 
 	if (slot < 0 || slot >= btrfs_header_nritems(parent))
 		return ERR_PTR(-ENOENT);
 
 	BUG_ON(level == 0);
 
-	btrfs_node_key_to_cpu(parent, &first_key, slot);
 	eb = read_tree_block(fs_info, btrfs_node_blockptr(parent, slot),
 			     btrfs_node_ptr_generation(parent, slot),
-			     level - 1, &first_key);
+			     level - 1);
 	if (!IS_ERR(eb) && !extent_buffer_uptodate(eb)) {
 		free_extent_buffer(eb);
 		eb = ERR_PTR(-EIO);
@@ -2399,14 +2394,12 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
 	u64 gen;
 	struct extent_buffer *b = *eb_ret;
 	struct extent_buffer *tmp;
-	struct btrfs_key first_key;
 	int ret;
 	int parent_level;
 
 	blocknr = btrfs_node_blockptr(b, slot);
 	gen = btrfs_node_ptr_generation(b, slot);
 	parent_level = btrfs_header_level(b);
-	btrfs_node_key_to_cpu(b, &first_key, slot);
 
 	tmp = find_extent_buffer(fs_info, blocknr);
 	if (tmp) {
@@ -2425,7 +2418,7 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
 		btrfs_set_path_blocking(p);
 
 		/* now we're allowed to do a blocking uptodate check */
-		ret = btrfs_read_buffer(tmp, gen, parent_level - 1, &first_key);
+		ret = btrfs_read_buffer(tmp, gen, parent_level - 1);
 		if (!ret) {
 			*eb_ret = tmp;
 			return 0;
@@ -2452,8 +2445,7 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
 	btrfs_release_path(p);
 
 	ret = -EAGAIN;
-	tmp = read_tree_block(fs_info, blocknr, 0, parent_level - 1,
-			      &first_key);
+	tmp = read_tree_block(fs_info, blocknr, 0, parent_level - 1);
 	if (!IS_ERR(tmp)) {
 		/*
 		 * If the read above didn't mark this buffer up to date,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index bb38f4098e9c..4c84a46a9fe7 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -427,13 +427,10 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
-static int verify_level_key(struct btrfs_fs_info *fs_info,
-			    struct extent_buffer *eb, int level,
-			    struct btrfs_key *first_key)
+static int verify_level(struct btrfs_fs_info *fs_info,
+			struct extent_buffer *eb, int level)
 {
 	int found_level;
-	struct btrfs_key found_key;
-	int ret;
 
 	found_level = btrfs_header_level(eb);
 	if (found_level != level) {
@@ -445,27 +442,7 @@ static int verify_level_key(struct btrfs_fs_info *fs_info,
 #endif
 		return -EIO;
 	}
-
-	if (!first_key)
-		return 0;
-
-	if (found_level)
-		btrfs_node_key_to_cpu(eb, &found_key, 0);
-	else
-		btrfs_item_key_to_cpu(eb, &found_key, 0);
-	ret = btrfs_comp_cpu_keys(first_key, &found_key);
-
-#ifdef CONFIG_BTRFS_DEBUG
-	if (ret) {
-		WARN_ON(1);
-		btrfs_err(fs_info,
-"tree first key mismatch detected, bytenr=%llu key expected=(%llu, %u, %llu) has=(%llu, %u, %llu)",
-			  eb->start, first_key->objectid, first_key->type,
-			  first_key->offset, found_key.objectid,
-			  found_key.type, found_key.offset);
-	}
-#endif
-	return ret;
+	return 0;
 }
 
 /*
@@ -474,12 +451,10 @@ static int verify_level_key(struct btrfs_fs_info *fs_info,
  *
  * @parent_transid:	expected transid, skip check if 0
  * @level:		expected level, mandatory check
- * @first_key:		expected key of first slot, skip check if NULL
  */
 static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_info,
 					  struct extent_buffer *eb,
-					  u64 parent_transid, int level,
-					  struct btrfs_key *first_key)
+					  u64 parent_transid, int level)
 {
 	struct extent_io_tree *io_tree;
 	int failed = 0;
@@ -497,8 +472,7 @@ static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_info,
 			if (verify_parent_transid(io_tree, eb,
 						   parent_transid, 0))
 				ret = -EIO;
-			else if (verify_level_key(fs_info, eb, level,
-						  first_key))
+			else if (verify_level(fs_info, eb, level))
 				ret = -EUCLEAN;
 			else
 				break;
@@ -1105,11 +1079,9 @@ void btrfs_wait_tree_block_writeback(struct extent_buffer *buf)
  *
  * @parent_transid:	expected transid of this tree block, skip check if 0
  * @level:		expected level, mandatory check
- * @first_key:		expected key in slot 0, skip check if NULL
  */
 struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
-				      u64 parent_transid, int level,
-				      struct btrfs_key *first_key)
+				      u64 parent_transid, int level)
 {
 	struct extent_buffer *buf = NULL;
 	int ret;
@@ -1119,7 +1091,7 @@ struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 		return buf;
 
 	ret = btree_read_extent_buffer_pages(fs_info, buf, parent_transid,
-					     level, first_key);
+					     level);
 	if (ret) {
 		free_extent_buffer(buf);
 		return ERR_PTR(ret);
@@ -1474,7 +1446,7 @@ static struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
 	level = btrfs_root_level(&root->root_item);
 	root->node = read_tree_block(fs_info,
 				     btrfs_root_bytenr(&root->root_item),
-				     generation, level, NULL);
+				     generation, level);
 	if (IS_ERR(root->node)) {
 		ret = PTR_ERR(root->node);
 		goto find_fail;
@@ -2337,8 +2309,7 @@ static int btrfs_replay_log(struct btrfs_fs_info *fs_info,
 	__setup_root(log_tree_root, fs_info, BTRFS_TREE_LOG_OBJECTID);
 
 	log_tree_root->node = read_tree_block(fs_info, bytenr,
-					      fs_info->generation + 1,
-					      level, NULL);
+					      fs_info->generation + 1, level);
 	if (IS_ERR(log_tree_root->node)) {
 		btrfs_warn(fs_info, "failed to read log tree");
 		ret = PTR_ERR(log_tree_root->node);
@@ -2808,7 +2779,7 @@ int open_ctree(struct super_block *sb,
 
 	chunk_root->node = read_tree_block(fs_info,
 					   btrfs_super_chunk_root(disk_super),
-					   generation, level, NULL);
+					   generation, level);
 	if (IS_ERR(chunk_root->node) ||
 	    !extent_buffer_uptodate(chunk_root->node)) {
 		btrfs_err(fs_info, "failed to read chunk root");
@@ -2846,7 +2817,7 @@ int open_ctree(struct super_block *sb,
 
 	tree_root->node = read_tree_block(fs_info,
 					  btrfs_super_root(disk_super),
-					  generation, level, NULL);
+					  generation, level);
 	if (IS_ERR(tree_root->node) ||
 	    !extent_buffer_uptodate(tree_root->node)) {
 		btrfs_warn(fs_info, "failed to read tree root");
@@ -3968,14 +3939,13 @@ void btrfs_btree_balance_dirty_nodelay(struct btrfs_fs_info *fs_info)
 	__btrfs_btree_balance_dirty(fs_info, 0);
 }
 
-int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid, int level,
-		      struct btrfs_key *first_key)
+int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid, int level)
 {
 	struct btrfs_root *root = BTRFS_I(buf->pages[0]->mapping->host)->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
 	return btree_read_extent_buffer_pages(fs_info, buf, parent_transid,
-					      level, first_key);
+					      level);
 }
 
 static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 453ea9f5d4e9..7dbd19eea410 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -53,8 +53,7 @@ struct btrfs_device;
 struct btrfs_fs_devices;
 
 struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
-				      u64 parent_transid, int level,
-				      struct btrfs_key *first_key);
+				      u64 parent_transid, int level);
 void readahead_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr);
 int reada_tree_block_flagged(struct btrfs_fs_info *fs_info, u64 bytenr,
 			 int mirror_num, struct extent_buffer **eb);
@@ -124,8 +123,7 @@ static inline void btrfs_put_fs_root(struct btrfs_root *root)
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
 			  int atomic);
-int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid, int level,
-		      struct btrfs_key *first_key);
+int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid, int level);
 u32 btrfs_csum_data(const char *data, u32 seed, size_t len);
 void btrfs_csum_final(u32 crc, u8 *result);
 blk_status_t btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d83d449e749a..f080834e4dd0 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8714,7 +8714,6 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	u64 parent;
 	u32 blocksize;
 	struct btrfs_key key;
-	struct btrfs_key first_key;
 	struct extent_buffer *next;
 	int level = wc->level;
 	int reada = 0;
@@ -8735,8 +8734,6 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	}
 
 	bytenr = btrfs_node_blockptr(path->nodes[level], path->slots[level]);
-	btrfs_node_key_to_cpu(path->nodes[level], &first_key,
-			      path->slots[level]);
 	blocksize = fs_info->nodesize;
 
 	next = find_extent_buffer(fs_info, bytenr);
@@ -8801,8 +8798,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	if (!next) {
 		if (reada && level == 1)
 			reada_walk_down(trans, root, wc, path);
-		next = read_tree_block(fs_info, bytenr, generation, level - 1,
-				       &first_key);
+		next = read_tree_block(fs_info, bytenr, generation, level - 1);
 		if (IS_ERR(next)) {
 			return PTR_ERR(next);
 		} else if (!extent_buffer_uptodate(next)) {
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 4a8770485f77..0731b0ff4d66 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -365,13 +365,11 @@ void btrfs_print_tree(struct extent_buffer *c)
 		       btrfs_node_blockptr(c, i));
 	}
 	for (i = 0; i < nr; i++) {
-		struct btrfs_key first_key;
 		struct extent_buffer *next;
 
-		btrfs_node_key_to_cpu(c, &first_key, i);
 		next = read_tree_block(fs_info, btrfs_node_blockptr(c, i),
 				       btrfs_node_ptr_generation(c, i),
-				       level - 1, &first_key);
+				       level - 1);
 		if (IS_ERR(next)) {
 			continue;
 		} else if (!extent_buffer_uptodate(next)) {
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index f583f13ff26e..c7f129356966 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1684,7 +1684,7 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 		return 0;
 
 	if (!extent_buffer_uptodate(root_eb)) {
-		ret = btrfs_read_buffer(root_eb, root_gen, root_level, NULL);
+		ret = btrfs_read_buffer(root_eb, root_gen, root_level);
 		if (ret)
 			goto out;
 	}
@@ -1715,7 +1715,6 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 	level = root_level;
 	while (level >= 0) {
 		if (path->nodes[level] == NULL) {
-			struct btrfs_key first_key;
 			int parent_slot;
 			u64 child_gen;
 			u64 child_bytenr;
@@ -1728,10 +1727,9 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 			parent_slot = path->slots[level + 1];
 			child_bytenr = btrfs_node_blockptr(eb, parent_slot);
 			child_gen = btrfs_node_ptr_generation(eb, parent_slot);
-			btrfs_node_key_to_cpu(eb, &first_key, parent_slot);
 
 			eb = read_tree_block(fs_info, child_bytenr, child_gen,
-					     level, &first_key);
+					     level);
 			if (IS_ERR(eb)) {
 				ret = PTR_ERR(eb);
 				goto out;
diff --git a/fs/btrfs/ref-verify.c b/fs/btrfs/ref-verify.c
index 35fab67dcbe8..6d856eabf34a 100644
--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -579,16 +579,12 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 
 	while (level >= 0) {
 		if (level) {
-			struct btrfs_key first_key;
-
 			block_bytenr = btrfs_node_blockptr(path->nodes[level],
 							   path->slots[level]);
 			gen = btrfs_node_ptr_generation(path->nodes[level],
 							path->slots[level]);
-			btrfs_node_key_to_cpu(path->nodes[level], &first_key,
-					      path->slots[level]);
 			eb = read_tree_block(fs_info, block_bytenr, gen,
-					     level - 1, &first_key);
+					     level - 1);
 			if (IS_ERR(eb))
 				return PTR_ERR(eb);
 			if (!extent_buffer_uptodate(eb)) {
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 4874c09f6d3c..74db4694d776 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1839,8 +1839,6 @@ int replace_path(struct btrfs_trans_handle *trans,
 
 	parent = eb;
 	while (1) {
-		struct btrfs_key first_key;
-
 		level = btrfs_header_level(parent);
 		BUG_ON(level < lowest_level);
 
@@ -1880,7 +1878,7 @@ int replace_path(struct btrfs_trans_handle *trans,
 			}
 
 			eb = read_tree_block(fs_info, old_bytenr, old_ptr_gen,
-					     level - 1, &first_key);
+					     level - 1);
 			if (IS_ERR(eb)) {
 				ret = PTR_ERR(eb);
 				break;
@@ -2040,8 +2038,6 @@ int walk_down_reloc_tree(struct btrfs_root *root, struct btrfs_path *path,
 	last_snapshot = btrfs_root_last_snapshot(&root->root_item);
 
 	for (i = *level; i > 0; i--) {
-		struct btrfs_key first_key;
-
 		eb = path->nodes[i];
 		nritems = btrfs_header_nritems(eb);
 		while (path->slots[i] < nritems) {
@@ -2062,9 +2058,7 @@ int walk_down_reloc_tree(struct btrfs_root *root, struct btrfs_path *path,
 		}
 
 		bytenr = btrfs_node_blockptr(eb, path->slots[i]);
-		btrfs_node_key_to_cpu(eb, &first_key, path->slots[i]);
-		eb = read_tree_block(fs_info, bytenr, ptr_gen, i - 1,
-				     &first_key);
+		eb = read_tree_block(fs_info, bytenr, ptr_gen, i - 1);
 		if (IS_ERR(eb)) {
 			return PTR_ERR(eb);
 		} else if (!extent_buffer_uptodate(eb)) {
@@ -2722,8 +2716,6 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 	path->lowest_level = node->level + 1;
 	rc->backref_cache.path[node->level] = node;
 	list_for_each_entry(edge, &node->upper, list[LOWER]) {
-		struct btrfs_key first_key;
-
 		cond_resched();
 
 		upper = edge->node[UPPER];
@@ -2789,9 +2781,8 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 
 		blocksize = root->fs_info->nodesize;
 		generation = btrfs_node_ptr_generation(upper->eb, slot);
-		btrfs_node_key_to_cpu(upper->eb, &first_key, slot);
 		eb = read_tree_block(fs_info, bytenr, generation,
-				     upper->level - 1, &first_key);
+				     upper->level - 1);
 		if (IS_ERR(eb)) {
 			err = PTR_ERR(eb);
 			goto next;
@@ -2957,7 +2948,7 @@ static int get_tree_block_key(struct btrfs_fs_info *fs_info,
 
 	BUG_ON(block->key_ready);
 	eb = read_tree_block(fs_info, block->bytenr, block->key.offset,
-			     block->level, NULL);
+			     block->level);
 	if (IS_ERR(eb)) {
 		return PTR_ERR(eb);
 	} else if (!extent_buffer_uptodate(eb)) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 678154d4b78f..89c6b7cf4533 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -304,7 +304,7 @@ static int process_one_buffer(struct btrfs_root *log,
 	 * pin down any logged extents, so we have to read the block.
 	 */
 	if (btrfs_fs_incompat(fs_info, MIXED_GROUPS)) {
-		ret = btrfs_read_buffer(eb, gen, level, NULL);
+		ret = btrfs_read_buffer(eb, gen, level);
 		if (ret)
 			return ret;
 	}
@@ -2417,7 +2417,7 @@ static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
 	int i;
 	int ret;
 
-	ret = btrfs_read_buffer(eb, gen, level, NULL);
+	ret = btrfs_read_buffer(eb, gen, level);
 	if (ret)
 		return ret;
 
@@ -2534,8 +2534,6 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 	WARN_ON(*level >= BTRFS_MAX_LEVEL);
 
 	while (*level > 0) {
-		struct btrfs_key first_key;
-
 		WARN_ON(*level < 0);
 		WARN_ON(*level >= BTRFS_MAX_LEVEL);
 		cur = path->nodes[*level];
@@ -2548,7 +2546,6 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 
 		bytenr = btrfs_node_blockptr(cur, path->slots[*level]);
 		ptr_gen = btrfs_node_ptr_generation(cur, path->slots[*level]);
-		btrfs_node_key_to_cpu(cur, &first_key, path->slots[*level]);
 		blocksize = fs_info->nodesize;
 
 		parent = path->nodes[*level];
@@ -2569,7 +2566,7 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 			path->slots[*level]++;
 			if (wc->free) {
 				ret = btrfs_read_buffer(next, ptr_gen,
-							*level - 1, &first_key);
+							*level - 1);
 				if (ret) {
 					free_extent_buffer(next);
 					return ret;
@@ -2599,7 +2596,7 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 			free_extent_buffer(next);
 			continue;
 		}
-		ret = btrfs_read_buffer(next, ptr_gen, *level - 1, &first_key);
+		ret = btrfs_read_buffer(next, ptr_gen, *level - 1);
 		if (ret) {
 			free_extent_buffer(next);
 			return ret;
-- 
2.17.0

