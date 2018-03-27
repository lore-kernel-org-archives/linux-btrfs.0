Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:60731 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751347AbeC0Mo1 (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 27 Mar 2018 08:44:27 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/2] btrfs: Validate child tree block's level and first key
Date: Tue, 27 Mar 2018 20:44:19 +0800
Message-Id: <20180327124419.28398-2-wqu@suse.com>
In-Reply-To: <20180327124419.28398-1-wqu@suse.com>
References: <20180327124419.28398-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have several reports about node pointer points to incorrect child
tree blocks, which could have even wrong owner and level but still with
valid generation and checksum.

Although btrfs check could handle it and print error message like:
leaf parent key incorrect 60670574592

Kernel doesn't have enough check on this type of corruption correctly.
At least add such check to read_tree_block() and btrfs_read_buffer(),
where we need two new parameters @level and @first_key to verify the
child tree block.

The new @level check is mandatory and all call sites are already
modified to extract expected level from its call chain.

While @first_key is optional, the following call sites are skipping such
check:
1) Root node/leaf
   As ROOT_ITEM doesn't contain the first key, skip @first_key check.
2) Direct backref
   Only parent bytenr and level is known and we need to resolve the key
   all by ourselves, skip @first_key check.

Another note of this verification is, it needs extra info from nodeptr
or ROOT_ITEM, so it can't fit into current tree-checker framework, which
is limited to node/leaf boundary.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
  Make @level check mandatory, suggesed by Jeff and Nikolay.
  Change parameter order as @level is now mandatory, put it in front of
  @first_key.
  Change verify_parent_level() to verify_key_level() to avoid confusion
  on the @level parameter.
  Add btrfs_error() output for CONFIG_BTRFS_DEBUG to help debugging.
---
 fs/btrfs/backref.c     |  6 ++--
 fs/btrfs/ctree.c       | 28 +++++++++++----
 fs/btrfs/disk-io.c     | 95 +++++++++++++++++++++++++++++++++++++++++++-------
 fs/btrfs/disk-io.h     |  8 +++--
 fs/btrfs/extent-tree.c |  6 +++-
 fs/btrfs/print-tree.c  | 10 ++++--
 fs/btrfs/qgroup.c      |  7 ++--
 fs/btrfs/ref-verify.c  |  7 +++-
 fs/btrfs/relocation.c  | 21 ++++++++---
 fs/btrfs/tree-log.c    | 28 +++++++++------
 10 files changed, 170 insertions(+), 46 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 26484648d090..ec71c7e66cfa 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -738,7 +738,8 @@ static int add_missing_keys(struct btrfs_fs_info *fs_info,
 		BUG_ON(ref->key_for_search.type);
 		BUG_ON(!ref->wanted_disk_byte);
 
-		eb = read_tree_block(fs_info, ref->wanted_disk_byte, 0);
+		eb = read_tree_block(fs_info, ref->wanted_disk_byte, 0,
+				     ref->level - 1, NULL);
 		if (IS_ERR(eb)) {
 			free_pref(ref);
 			return PTR_ERR(eb);
@@ -1291,7 +1292,8 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 			    ref->level == 0) {
 				struct extent_buffer *eb;
 
-				eb = read_tree_block(fs_info, ref->parent, 0);
+				eb = read_tree_block(fs_info, ref->parent, 0,
+						     ref->level, NULL);
 				if (IS_ERR(eb)) {
 					ret = PTR_ERR(eb);
 					goto out;
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index b88a79e69ddf..4f1aefccd34a 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1418,6 +1418,7 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 	struct tree_mod_root *old_root = NULL;
 	u64 old_generation = 0;
 	u64 logical;
+	int level;
 
 	eb_root = btrfs_read_lock_root_node(root);
 	tm = __tree_mod_log_oldest_root(fs_info, eb_root, time_seq);
@@ -1428,15 +1429,17 @@ get_old_root(struct btrfs_root *root, u64 time_seq)
 		old_root = &tm->old_root;
 		old_generation = tm->generation;
 		logical = old_root->logical;
+		level = old_root->level;
 	} else {
 		logical = eb_root->start;
+		level = btrfs_header_level(eb_root);
 	}
 
 	tm = tree_mod_log_search(fs_info, logical, time_seq);
 	if (old_root && tm && tm->op != MOD_LOG_KEY_REMOVE_WHILE_FREEING) {
 		btrfs_tree_read_unlock(eb_root);
 		free_extent_buffer(eb_root);
-		old = read_tree_block(fs_info, logical, 0);
+		old = read_tree_block(fs_info, logical, 0, level, NULL);
 		if (WARN_ON(IS_ERR(old) || !extent_buffer_uptodate(old))) {
 			if (!IS_ERR(old))
 				free_extent_buffer(old);
@@ -1656,6 +1659,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 	btrfs_set_lock_blocking(parent);
 
 	for (i = start_slot; i <= end_slot; i++) {
+		struct btrfs_key first_key;
 		int close = 1;
 
 		btrfs_node_key(parent, &disk_key, i);
@@ -1665,6 +1669,7 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 		progress_passed = 1;
 		blocknr = btrfs_node_blockptr(parent, i);
 		gen = btrfs_node_ptr_generation(parent, i);
+		btrfs_node_key_to_cpu(parent, &first_key, i);
 		if (last_block == 0)
 			last_block = blocknr;
 
@@ -1688,7 +1693,9 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 			uptodate = 0;
 		if (!cur || !uptodate) {
 			if (!cur) {
-				cur = read_tree_block(fs_info, blocknr, gen);
+				cur = read_tree_block(fs_info, blocknr, gen,
+						      parent_level - 1,
+						      &first_key);
 				if (IS_ERR(cur)) {
 					return PTR_ERR(cur);
 				} else if (!extent_buffer_uptodate(cur)) {
@@ -1696,7 +1703,8 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
 					return -EIO;
 				}
 			} else if (!uptodate) {
-				err = btrfs_read_buffer(cur, gen);
+				err = btrfs_read_buffer(cur, gen,
+						parent_level - 1,&first_key);
 				if (err) {
 					free_extent_buffer(cur);
 					return err;
@@ -1849,14 +1857,17 @@ read_node_slot(struct btrfs_fs_info *fs_info, struct extent_buffer *parent,
 {
 	int level = btrfs_header_level(parent);
 	struct extent_buffer *eb;
+	struct btrfs_key first_key;
 
 	if (slot < 0 || slot >= btrfs_header_nritems(parent))
 		return ERR_PTR(-ENOENT);
 
 	BUG_ON(level == 0);
 
+	btrfs_node_key_to_cpu(parent, &first_key, slot);
 	eb = read_tree_block(fs_info, btrfs_node_blockptr(parent, slot),
-			     btrfs_node_ptr_generation(parent, slot));
+			     btrfs_node_ptr_generation(parent, slot),
+			     level - 1, &first_key);
 	if (!IS_ERR(eb) && !extent_buffer_uptodate(eb)) {
 		free_extent_buffer(eb);
 		eb = ERR_PTR(-EIO);
@@ -2445,10 +2456,14 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
 	u64 gen;
 	struct extent_buffer *b = *eb_ret;
 	struct extent_buffer *tmp;
+	struct btrfs_key first_key;
 	int ret;
+	int parent_level;
 
 	blocknr = btrfs_node_blockptr(b, slot);
 	gen = btrfs_node_ptr_generation(b, slot);
+	parent_level = btrfs_header_level(b);
+	btrfs_node_key_to_cpu(b, &first_key, slot);
 
 	tmp = find_extent_buffer(fs_info, blocknr);
 	if (tmp) {
@@ -2467,7 +2482,7 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
 		btrfs_set_path_blocking(p);
 
 		/* now we're allowed to do a blocking uptodate check */
-		ret = btrfs_read_buffer(tmp, gen);
+		ret = btrfs_read_buffer(tmp, gen, parent_level - 1, &first_key);
 		if (!ret) {
 			*eb_ret = tmp;
 			return 0;
@@ -2494,7 +2509,8 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
 	btrfs_release_path(p);
 
 	ret = -EAGAIN;
-	tmp = read_tree_block(fs_info, blocknr, 0);
+	tmp = read_tree_block(fs_info, blocknr, 0, parent_level - 1,
+			      &first_key);
 	if (!IS_ERR(tmp)) {
 		/*
 		 * If the read above didn't mark this buffer up to date,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 21f34ad0d411..b7c937de77be 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -428,13 +428,59 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+static int verify_level_key(struct btrfs_fs_info *fs_info,
+			    struct extent_buffer *eb, int level,
+			    struct btrfs_key *first_key)
+{
+	int found_level;
+	struct btrfs_key found_key;
+	int ret;
+
+	found_level = btrfs_header_level(eb);
+	if (found_level != level) {
+#ifdef CONFIG_BTRFS_DEBUG
+		WARN_ON(1);
+		btrfs_err(fs_info,
+"tree level mismatch detected, bytenr=%llu level expected=%u has=%u",
+			  eb->start, level, found_level);
+#endif
+		return -EIO;
+	}
+
+	if (!first_key)
+		return 0;
+
+	if (found_level)
+		btrfs_node_key_to_cpu(eb, &found_key, 0);
+	else
+		btrfs_item_key_to_cpu(eb, &found_key, 0);
+	ret = btrfs_comp_cpu_keys(first_key, &found_key);
+
+#ifdef CONFIG_BTRFS_DEBUG
+	if (ret) {
+		WARN_ON(1);
+		btrfs_err(fs_info,
+"tree first key mismatch detected, bytenr=%llu key expected=(%llu, %u, %llu) has=(%llu, %u, %llu)",
+			  eb->start, first_key->objectid, first_key->type,
+			  first_key->offset, found_key.objectid,
+			  found_key.type, found_key.offset);
+	}
+#endif
+	return ret;
+}
+
 /*
  * helper to read a given tree block, doing retries as required when
  * the checksums don't match and we have alternate mirrors to try.
+ *
+ * @parent_transid:	expected transid, skip check if 0
+ * @level:		expected level, mandatory check
+ * @first_key:		expected key of first slot, skip check if NULL
  */
 static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_info,
 					  struct extent_buffer *eb,
-					  u64 parent_transid)
+					  u64 parent_transid, int level,
+					  struct btrfs_key *first_key)
 {
 	struct extent_io_tree *io_tree;
 	int failed = 0;
@@ -449,11 +495,14 @@ static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_info,
 		ret = read_extent_buffer_pages(io_tree, eb, WAIT_COMPLETE,
 					       mirror_num);
 		if (!ret) {
-			if (!verify_parent_transid(io_tree, eb,
+			if (verify_parent_transid(io_tree, eb,
 						   parent_transid, 0))
-				break;
-			else
 				ret = -EIO;
+			else if (verify_level_key(fs_info, eb, level,
+						  first_key))
+				ret = -EUCLEAN;
+			else
+				break;
 		}
 
 		/*
@@ -461,7 +510,8 @@ static int btree_read_extent_buffer_pages(struct btrfs_fs_info *fs_info,
 		 * there is no reason to read the other copies, they won't be
 		 * any less wrong.
 		 */
-		if (test_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags))
+		if (test_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags) ||
+		    ret == -EUCLEAN)
 			break;
 
 		num_copies = btrfs_num_copies(fs_info,
@@ -1062,8 +1112,17 @@ void btrfs_wait_tree_block_writeback(struct extent_buffer *buf)
 			        buf->start, buf->start + buf->len - 1);
 }
 
+/*
+ * Read tree block at logical address @bytenr and do variant basic but critical
+ * verification.
+ *
+ * @parent_transid:	expected transid of this tree block, skip check if 0
+ * @level:		expected level, mandatory check
+ * @first_key:		expected key in slot 0, skip check if NULL
+ */
 struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
-				      u64 parent_transid)
+				      u64 parent_transid, int level,
+				      struct btrfs_key *first_key)
 {
 	struct extent_buffer *buf = NULL;
 	int ret;
@@ -1072,7 +1131,8 @@ struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 	if (IS_ERR(buf))
 		return buf;
 
-	ret = btree_read_extent_buffer_pages(fs_info, buf, parent_transid);
+	ret = btree_read_extent_buffer_pages(fs_info, buf, parent_transid,
+					     level, first_key);
 	if (ret) {
 		free_extent_buffer(buf);
 		return ERR_PTR(ret);
@@ -1401,6 +1461,7 @@ static struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
 	struct btrfs_path *path;
 	u64 generation;
 	int ret;
+	int level;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -1423,9 +1484,10 @@ static struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
 	}
 
 	generation = btrfs_root_generation(&root->root_item);
+	level = btrfs_root_level(&root->root_item);
 	root->node = read_tree_block(fs_info,
 				     btrfs_root_bytenr(&root->root_item),
-				     generation);
+				     generation, level, NULL);
 	if (IS_ERR(root->node)) {
 		ret = PTR_ERR(root->node);
 		goto find_fail;
@@ -2276,6 +2338,7 @@ static int btrfs_replay_log(struct btrfs_fs_info *fs_info,
 	struct btrfs_root *log_tree_root;
 	struct btrfs_super_block *disk_super = fs_info->super_copy;
 	u64 bytenr = btrfs_super_log_root(disk_super);
+	int level = btrfs_super_log_root_level(disk_super);
 
 	if (fs_devices->rw_devices == 0) {
 		btrfs_warn(fs_info, "log replay required on RO media");
@@ -2289,7 +2352,8 @@ static int btrfs_replay_log(struct btrfs_fs_info *fs_info,
 	__setup_root(log_tree_root, fs_info, BTRFS_TREE_LOG_OBJECTID);
 
 	log_tree_root->node = read_tree_block(fs_info, bytenr,
-					      fs_info->generation + 1);
+					      fs_info->generation + 1,
+					      level, NULL);
 	if (IS_ERR(log_tree_root->node)) {
 		btrfs_warn(fs_info, "failed to read log tree");
 		ret = PTR_ERR(log_tree_root->node);
@@ -2406,6 +2470,7 @@ int open_ctree(struct super_block *sb,
 	int backup_index = 0;
 	int max_active;
 	int clear_free_space_tree = 0;
+	int level;
 
 	tree_root = fs_info->tree_root = btrfs_alloc_root(fs_info, GFP_KERNEL);
 	chunk_root = fs_info->chunk_root = btrfs_alloc_root(fs_info, GFP_KERNEL);
@@ -2741,12 +2806,13 @@ int open_ctree(struct super_block *sb,
 	}
 
 	generation = btrfs_super_chunk_root_generation(disk_super);
+	level = btrfs_super_chunk_root_level(disk_super);
 
 	__setup_root(chunk_root, fs_info, BTRFS_CHUNK_TREE_OBJECTID);
 
 	chunk_root->node = read_tree_block(fs_info,
 					   btrfs_super_chunk_root(disk_super),
-					   generation);
+					   generation, level, NULL);
 	if (IS_ERR(chunk_root->node) ||
 	    !extent_buffer_uptodate(chunk_root->node)) {
 		btrfs_err(fs_info, "failed to read chunk root");
@@ -2780,10 +2846,11 @@ int open_ctree(struct super_block *sb,
 
 retry_root_backup:
 	generation = btrfs_super_generation(disk_super);
+	level = btrfs_super_root_level(disk_super);
 
 	tree_root->node = read_tree_block(fs_info,
 					  btrfs_super_root(disk_super),
-					  generation);
+					  generation, level, NULL);
 	if (IS_ERR(tree_root->node) ||
 	    !extent_buffer_uptodate(tree_root->node)) {
 		btrfs_warn(fs_info, "failed to read tree root");
@@ -3890,12 +3957,14 @@ void btrfs_btree_balance_dirty_nodelay(struct btrfs_fs_info *fs_info)
 	__btrfs_btree_balance_dirty(fs_info, 0);
 }
 
-int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid)
+int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid, int level,
+		      struct btrfs_key *first_key)
 {
 	struct btrfs_root *root = BTRFS_I(buf->pages[0]->mapping->host)->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 
-	return btree_read_extent_buffer_pages(fs_info, buf, parent_transid);
+	return btree_read_extent_buffer_pages(fs_info, buf, parent_transid,
+					      level, first_key);
 }
 
 static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 301151a50ac1..0e9858925d75 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -52,8 +52,9 @@ static inline u64 btrfs_sb_offset(int mirror)
 struct btrfs_device;
 struct btrfs_fs_devices;
 
-struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info,
-				      u64 bytenr, u64 parent_transid);
+struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
+				      u64 parent_transid, int level,
+				      struct btrfs_key *first_key);
 void readahead_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr);
 int reada_tree_block_flagged(struct btrfs_fs_info *fs_info, u64 bytenr,
 			 int mirror_num, struct extent_buffer **eb);
@@ -123,7 +124,8 @@ static inline void btrfs_put_fs_root(struct btrfs_root *root)
 void btrfs_mark_buffer_dirty(struct extent_buffer *buf);
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid,
 			  int atomic);
-int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid);
+int btrfs_read_buffer(struct extent_buffer *buf, u64 parent_transid, int level,
+		      struct btrfs_key *first_key);
 u32 btrfs_csum_data(const char *data, u32 seed, size_t len);
 void btrfs_csum_final(u32 crc, u8 *result);
 blk_status_t btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c1618ab9fecf..99a044863a03 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8701,6 +8701,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	u64 parent;
 	u32 blocksize;
 	struct btrfs_key key;
+	struct btrfs_key first_key;
 	struct extent_buffer *next;
 	int level = wc->level;
 	int reada = 0;
@@ -8721,6 +8722,8 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	}
 
 	bytenr = btrfs_node_blockptr(path->nodes[level], path->slots[level]);
+	btrfs_node_key_to_cpu(path->nodes[level], &first_key,
+			      path->slots[level]);
 	blocksize = fs_info->nodesize;
 
 	next = find_extent_buffer(fs_info, bytenr);
@@ -8785,7 +8788,8 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 	if (!next) {
 		if (reada && level == 1)
 			reada_walk_down(trans, root, wc, path);
-		next = read_tree_block(fs_info, bytenr, generation);
+		next = read_tree_block(fs_info, bytenr, generation, level - 1,
+				       &first_key);
 		if (IS_ERR(next)) {
 			return PTR_ERR(next);
 		} else if (!extent_buffer_uptodate(next)) {
diff --git a/fs/btrfs/print-tree.c b/fs/btrfs/print-tree.c
index 569205e651c7..4a8770485f77 100644
--- a/fs/btrfs/print-tree.c
+++ b/fs/btrfs/print-tree.c
@@ -365,9 +365,13 @@ void btrfs_print_tree(struct extent_buffer *c)
 		       btrfs_node_blockptr(c, i));
 	}
 	for (i = 0; i < nr; i++) {
-		struct extent_buffer *next = read_tree_block(fs_info,
-					btrfs_node_blockptr(c, i),
-					btrfs_node_ptr_generation(c, i));
+		struct btrfs_key first_key;
+		struct extent_buffer *next;
+
+		btrfs_node_key_to_cpu(c, &first_key, i);
+		next = read_tree_block(fs_info, btrfs_node_blockptr(c, i),
+				       btrfs_node_ptr_generation(c, i),
+				       level - 1, &first_key);
 		if (IS_ERR(next)) {
 			continue;
 		} else if (!extent_buffer_uptodate(next)) {
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index aa259d6986e1..c4d921567038 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1614,7 +1614,7 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 		return 0;
 
 	if (!extent_buffer_uptodate(root_eb)) {
-		ret = btrfs_read_buffer(root_eb, root_gen);
+		ret = btrfs_read_buffer(root_eb, root_gen, root_level, NULL);
 		if (ret)
 			goto out;
 	}
@@ -1645,6 +1645,7 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 	level = root_level;
 	while (level >= 0) {
 		if (path->nodes[level] == NULL) {
+			struct btrfs_key first_key;
 			int parent_slot;
 			u64 child_gen;
 			u64 child_bytenr;
@@ -1657,8 +1658,10 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 			parent_slot = path->slots[level + 1];
 			child_bytenr = btrfs_node_blockptr(eb, parent_slot);
 			child_gen = btrfs_node_ptr_generation(eb, parent_slot);
+			btrfs_node_key_to_cpu(eb, &first_key, parent_slot);
 
-			eb = read_tree_block(fs_info, child_bytenr, child_gen);
+			eb = read_tree_block(fs_info, child_bytenr, child_gen,
+					     level, &first_key);
 			if (IS_ERR(eb)) {
 				ret = PTR_ERR(eb);
 				goto out;
diff --git a/fs/btrfs/ref-verify.c b/fs/btrfs/ref-verify.c
index 171f3cce30e6..35fab67dcbe8 100644
--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -579,11 +579,16 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 
 	while (level >= 0) {
 		if (level) {
+			struct btrfs_key first_key;
+
 			block_bytenr = btrfs_node_blockptr(path->nodes[level],
 							   path->slots[level]);
 			gen = btrfs_node_ptr_generation(path->nodes[level],
 							path->slots[level]);
-			eb = read_tree_block(fs_info, block_bytenr, gen);
+			btrfs_node_key_to_cpu(path->nodes[level], &first_key,
+					      path->slots[level]);
+			eb = read_tree_block(fs_info, block_bytenr, gen,
+					     level - 1, &first_key);
 			if (IS_ERR(eb))
 				return PTR_ERR(eb);
 			if (!extent_buffer_uptodate(eb)) {
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index cd2298d185dd..fc541c9d6680 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1839,6 +1839,8 @@ int replace_path(struct btrfs_trans_handle *trans,
 
 	parent = eb;
 	while (1) {
+		struct btrfs_key first_key;
+
 		level = btrfs_header_level(parent);
 		BUG_ON(level < lowest_level);
 
@@ -1852,6 +1854,7 @@ int replace_path(struct btrfs_trans_handle *trans,
 		old_bytenr = btrfs_node_blockptr(parent, slot);
 		blocksize = fs_info->nodesize;
 		old_ptr_gen = btrfs_node_ptr_generation(parent, slot);
+		btrfs_node_key_to_cpu(parent, &key, slot);
 
 		if (level <= max_level) {
 			eb = path->nodes[level];
@@ -1876,7 +1879,8 @@ int replace_path(struct btrfs_trans_handle *trans,
 				break;
 			}
 
-			eb = read_tree_block(fs_info, old_bytenr, old_ptr_gen);
+			eb = read_tree_block(fs_info, old_bytenr, old_ptr_gen,
+					     level - 1, &first_key);
 			if (IS_ERR(eb)) {
 				ret = PTR_ERR(eb);
 				break;
@@ -2036,6 +2040,8 @@ int walk_down_reloc_tree(struct btrfs_root *root, struct btrfs_path *path,
 	last_snapshot = btrfs_root_last_snapshot(&root->root_item);
 
 	for (i = *level; i > 0; i--) {
+		struct btrfs_key first_key;
+
 		eb = path->nodes[i];
 		nritems = btrfs_header_nritems(eb);
 		while (path->slots[i] < nritems) {
@@ -2056,7 +2062,9 @@ int walk_down_reloc_tree(struct btrfs_root *root, struct btrfs_path *path,
 		}
 
 		bytenr = btrfs_node_blockptr(eb, path->slots[i]);
-		eb = read_tree_block(fs_info, bytenr, ptr_gen);
+		btrfs_node_key_to_cpu(eb, &first_key, path->slots[i]);
+		eb = read_tree_block(fs_info, bytenr, ptr_gen, i - 1,
+				     &first_key);
 		if (IS_ERR(eb)) {
 			return PTR_ERR(eb);
 		} else if (!extent_buffer_uptodate(eb)) {
@@ -2714,6 +2722,8 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 	path->lowest_level = node->level + 1;
 	rc->backref_cache.path[node->level] = node;
 	list_for_each_entry(edge, &node->upper, list[LOWER]) {
+		struct btrfs_key first_key;
+
 		cond_resched();
 
 		upper = edge->node[UPPER];
@@ -2779,7 +2789,9 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 
 		blocksize = root->fs_info->nodesize;
 		generation = btrfs_node_ptr_generation(upper->eb, slot);
-		eb = read_tree_block(fs_info, bytenr, generation);
+		btrfs_node_key_to_cpu(upper->eb, &first_key, slot);
+		eb = read_tree_block(fs_info, bytenr, generation,
+				     upper->level - 1, &first_key);
 		if (IS_ERR(eb)) {
 			err = PTR_ERR(eb);
 			goto next;
@@ -2944,7 +2956,8 @@ static int get_tree_block_key(struct btrfs_fs_info *fs_info,
 	struct extent_buffer *eb;
 
 	BUG_ON(block->key_ready);
-	eb = read_tree_block(fs_info, block->bytenr, block->key.offset);
+	eb = read_tree_block(fs_info, block->bytenr, block->key.offset,
+			     block->level, NULL);
 	if (IS_ERR(eb)) {
 		return PTR_ERR(eb);
 	} else if (!extent_buffer_uptodate(eb)) {
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 434457794c27..f1acef311148 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -286,7 +286,7 @@ struct walk_control {
 	 * inside it
 	 */
 	int (*process_func)(struct btrfs_root *log, struct extent_buffer *eb,
-			    struct walk_control *wc, u64 gen);
+			    struct walk_control *wc, u64 gen, int level);
 };
 
 /*
@@ -294,7 +294,7 @@ struct walk_control {
  */
 static int process_one_buffer(struct btrfs_root *log,
 			      struct extent_buffer *eb,
-			      struct walk_control *wc, u64 gen)
+			      struct walk_control *wc, u64 gen, int level)
 {
 	struct btrfs_fs_info *fs_info = log->fs_info;
 	int ret = 0;
@@ -304,7 +304,7 @@ static int process_one_buffer(struct btrfs_root *log,
 	 * pin down any logged extents, so we have to read the block.
 	 */
 	if (btrfs_fs_incompat(fs_info, MIXED_GROUPS)) {
-		ret = btrfs_read_buffer(eb, gen);
+		ret = btrfs_read_buffer(eb, gen, level, NULL);
 		if (ret)
 			return ret;
 	}
@@ -2410,17 +2410,16 @@ static noinline int replay_dir_deletes(struct btrfs_trans_handle *trans,
  * back refs).
  */
 static int replay_one_buffer(struct btrfs_root *log, struct extent_buffer *eb,
-			     struct walk_control *wc, u64 gen)
+			     struct walk_control *wc, u64 gen, int level)
 {
 	int nritems;
 	struct btrfs_path *path;
 	struct btrfs_root *root = wc->replay_dest;
 	struct btrfs_key key;
-	int level;
 	int i;
 	int ret;
 
-	ret = btrfs_read_buffer(eb, gen);
+	ret = btrfs_read_buffer(eb, gen, level, NULL);
 	if (ret)
 		return ret;
 
@@ -2537,6 +2536,8 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 	WARN_ON(*level >= BTRFS_MAX_LEVEL);
 
 	while (*level > 0) {
+		struct btrfs_key first_key;
+
 		WARN_ON(*level < 0);
 		WARN_ON(*level >= BTRFS_MAX_LEVEL);
 		cur = path->nodes[*level];
@@ -2549,6 +2550,7 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 
 		bytenr = btrfs_node_blockptr(cur, path->slots[*level]);
 		ptr_gen = btrfs_node_ptr_generation(cur, path->slots[*level]);
+		btrfs_node_key_to_cpu(cur, &first_key, path->slots[*level]);
 		blocksize = fs_info->nodesize;
 
 		parent = path->nodes[*level];
@@ -2559,7 +2561,8 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 			return PTR_ERR(next);
 
 		if (*level == 1) {
-			ret = wc->process_func(root, next, wc, ptr_gen);
+			ret = wc->process_func(root, next, wc, ptr_gen,
+					       *level - 1);
 			if (ret) {
 				free_extent_buffer(next);
 				return ret;
@@ -2567,7 +2570,8 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 
 			path->slots[*level]++;
 			if (wc->free) {
-				ret = btrfs_read_buffer(next, ptr_gen);
+				ret = btrfs_read_buffer(next, ptr_gen,
+							*level - 1, &first_key);
 				if (ret) {
 					free_extent_buffer(next);
 					return ret;
@@ -2597,7 +2601,7 @@ static noinline int walk_down_log_tree(struct btrfs_trans_handle *trans,
 			free_extent_buffer(next);
 			continue;
 		}
-		ret = btrfs_read_buffer(next, ptr_gen);
+		ret = btrfs_read_buffer(next, ptr_gen, *level - 1, &first_key);
 		if (ret) {
 			free_extent_buffer(next);
 			return ret;
@@ -2647,7 +2651,8 @@ static noinline int walk_up_log_tree(struct btrfs_trans_handle *trans,
 
 			root_owner = btrfs_header_owner(parent);
 			ret = wc->process_func(root, path->nodes[*level], wc,
-				 btrfs_header_generation(path->nodes[*level]));
+				 btrfs_header_generation(path->nodes[*level]),
+				 *level);
 			if (ret)
 				return ret;
 
@@ -2729,7 +2734,8 @@ static int walk_log_tree(struct btrfs_trans_handle *trans,
 	/* was the root node processed? if not, catch it here */
 	if (path->nodes[orig_level]) {
 		ret = wc->process_func(log, path->nodes[orig_level], wc,
-			 btrfs_header_generation(path->nodes[orig_level]));
+			 btrfs_header_generation(path->nodes[orig_level]),
+			 orig_level);
 		if (ret)
 			goto out;
 		if (wc->free) {
-- 
2.16.2

