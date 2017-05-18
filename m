Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22220 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932161AbdERDjd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 23:39:33 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH 31/32] btrfs-progs: Refactor read_tree_block to get rid of btrfs_root
Date: Thu, 18 May 2017 11:38:56 +0800
Message-ID: <20170518033857.15002-32-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
References: <20170518033857.15002-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The only reasom read_tree_block() needs a btrfs_root parameter is to get
its node/sector size.

And long ago, I have already introduced a compactible interface,
read_tree_block_fs_info() to pass btrfs_fs_info instead of btrfs_root.

Since we have cleaned up all root->sector/node/stripesize users, we
should be OK to refactor read_tree_block() function.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 backref.c                 |  6 +++---
 btrfs-corrupt-block.c     |  9 +++++----
 btrfstune.c               |  2 +-
 cmds-check.c              | 24 ++++++++++++------------
 cmds-inspect-dump-tree.c  | 10 +++++-----
 cmds-inspect-tree-stats.c |  2 +-
 cmds-restore.c            |  4 ++--
 ctree.c                   |  2 +-
 disk-io.c                 | 18 ++++++++++--------
 disk-io.h                 |  9 +--------
 find-root.c               |  3 +--
 image/main.c              | 14 ++++++++------
 print-tree.c              |  3 ++-
 qgroup-verify.c           |  2 +-
 14 files changed, 53 insertions(+), 55 deletions(-)

diff --git a/backref.c b/backref.c
index 31681a85..ce12bbdf 100644
--- a/backref.c
+++ b/backref.c
@@ -450,7 +450,7 @@ static int __add_missing_keys(struct btrfs_fs_info *fs_info,
 		if (ref->key_for_search.type)
 			continue;
 		BUG_ON(!ref->wanted_disk_byte);
-		eb = read_tree_block(fs_info->tree_root, ref->wanted_disk_byte,
+		eb = read_tree_block(fs_info, ref->wanted_disk_byte,
 				     fs_info->nodesize, 0);
 		if (!extent_buffer_uptodate(eb)) {
 			free_extent_buffer(eb);
@@ -805,8 +805,8 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 				u32 bsz;
 				struct extent_buffer *eb;
 				bsz = fs_info->nodesize;
-				eb = read_tree_block(fs_info->extent_root,
-							   ref->parent, bsz, 0);
+				eb = read_tree_block(fs_info,
+						ref->parent, bsz, 0);
 				if (!extent_buffer_uptodate(eb)) {
 					free_extent_buffer(eb);
 					ret = -EIO;
diff --git a/btrfs-corrupt-block.c b/btrfs-corrupt-block.c
index 5649a00e..f29f22d2 100644
--- a/btrfs-corrupt-block.c
+++ b/btrfs-corrupt-block.c
@@ -169,7 +169,7 @@ static int corrupt_keys_in_block(struct btrfs_fs_info *fs_info, u64 bytenr)
 {
 	struct extent_buffer *eb;
 
-	eb = read_tree_block_fs_info(fs_info, bytenr, fs_info->nodesize, 0);
+	eb = read_tree_block(fs_info, bytenr, fs_info->nodesize, 0);
 	if (!extent_buffer_uptodate(eb))
 		return -EIO;;
 
@@ -278,6 +278,7 @@ static void btrfs_corrupt_extent_tree(struct btrfs_trans_handle *trans,
 				      struct btrfs_root *root,
 				      struct extent_buffer *eb)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	int i;
 
 	if (!eb)
@@ -296,8 +297,8 @@ static void btrfs_corrupt_extent_tree(struct btrfs_trans_handle *trans,
 	for (i = 0; i < btrfs_header_nritems(eb); i++) {
 		struct extent_buffer *next;
 
-		next = read_tree_block(root, btrfs_node_blockptr(eb, i),
-				       root->fs_info->nodesize,
+		next = read_tree_block(fs_info, btrfs_node_blockptr(eb, i),
+				       fs_info->nodesize,
 				       btrfs_node_ptr_generation(eb, i));
 		if (!extent_buffer_uptodate(next))
 			continue;
@@ -765,7 +766,7 @@ static int corrupt_metadata_block(struct btrfs_fs_info *fs_info, u64 block,
 		return -EINVAL;
 	}
 
-	eb = read_tree_block_fs_info(fs_info, block, fs_info->nodesize, 0);
+	eb = read_tree_block(fs_info, block, fs_info->nodesize, 0);
 	if (!extent_buffer_uptodate(eb)) {
 		fprintf(stderr, "Couldn't read in tree block %s\n", field);
 		return -EINVAL;
diff --git a/btrfstune.c b/btrfstune.c
index 0a6ad9ca..b5a1c2fe 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -149,7 +149,7 @@ static int change_extents_uuid(struct btrfs_fs_info *fs_info)
 			goto next;
 
 		bytenr = key.objectid;
-		eb = read_tree_block(root, bytenr, root->fs_info->nodesize, 0);
+		eb = read_tree_block(fs_info, bytenr, fs_info->nodesize, 0);
 		if (IS_ERR(eb)) {
 			error("failed to read tree block: %llu", bytenr);
 			ret = PTR_ERR(eb);
diff --git a/cmds-check.c b/cmds-check.c
index ce479855..84148b67 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2183,7 +2183,7 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 		if (!next || !btrfs_buffer_uptodate(next, ptr_gen)) {
 			free_extent_buffer(next);
 			reada_walk_down(root, cur, path->slots[*level]);
-			next = read_tree_block(root, bytenr, blocksize,
+			next = read_tree_block(root->fs_info, bytenr, blocksize,
 					       ptr_gen);
 			if (!extent_buffer_uptodate(next)) {
 				struct btrfs_key node_key;
@@ -2298,7 +2298,7 @@ static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
 		if (!next || !btrfs_buffer_uptodate(next, ptr_gen)) {
 			free_extent_buffer(next);
 			reada_walk_down(root, cur, path->slots[*level]);
-			next = read_tree_block(root, bytenr, blocksize,
+			next = read_tree_block(root->fs_info, bytenr, blocksize,
 					       ptr_gen);
 			if (!extent_buffer_uptodate(next)) {
 				struct btrfs_key node_key;
@@ -7670,7 +7670,7 @@ static int run_next_block(struct btrfs_root *root,
 	}
 
 	/* fixme, get the real parent transid */
-	buf = read_tree_block(root, bytenr, size, gen);
+	buf = read_tree_block(root->fs_info, bytenr, size, gen);
 	if (!extent_buffer_uptodate(buf)) {
 		record_bad_block_io(root->fs_info,
 				    extent_cache, bytenr, size);
@@ -9783,7 +9783,7 @@ static int deal_root_from_list(struct list_head *list,
 		rec = list_entry(list->next,
 				 struct root_item_record, list);
 		last = 0;
-		buf = read_tree_block(root->fs_info->tree_root,
+		buf = read_tree_block(root->fs_info,
 				      rec->bytenr, rec->level_size, 0);
 		if (!extent_buffer_uptodate(buf)) {
 			free_extent_buffer(buf);
@@ -10429,7 +10429,7 @@ static int query_tree_block_level(struct btrfs_fs_info *fs_info, u64 bytenr)
 	btrfs_release_path(&path);
 
 	/* Get level from tree block as an alternative source */
-	eb = read_tree_block_fs_info(fs_info, bytenr, nodesize, transid);
+	eb = read_tree_block(fs_info, bytenr, nodesize, transid);
 	if (!extent_buffer_uptodate(eb)) {
 		free_extent_buffer(eb);
 		return -EIO;
@@ -10482,7 +10482,7 @@ static int check_tree_block_backref(struct btrfs_fs_info *fs_info, u64 root_id,
 	}
 
 	/* Read out the tree block to get item/node key */
-	eb = read_tree_block(root, bytenr, root->fs_info->nodesize, 0);
+	eb = read_tree_block(fs_info, bytenr, root->fs_info->nodesize, 0);
 	if (!extent_buffer_uptodate(eb)) {
 		err |= REFERENCER_MISSING;
 		free_extent_buffer(eb);
@@ -10584,7 +10584,7 @@ static int check_shared_block_backref(struct btrfs_fs_info *fs_info,
 	int found_parent = 0;
 	int i;
 
-	eb = read_tree_block_fs_info(fs_info, parent, nodesize, 0);
+	eb = read_tree_block(fs_info, parent, nodesize, 0);
 	if (!extent_buffer_uptodate(eb))
 		goto out;
 
@@ -10738,7 +10738,7 @@ static int check_shared_data_backref(struct btrfs_fs_info *fs_info,
 	int found_parent = 0;
 	int i;
 
-	eb = read_tree_block_fs_info(fs_info, parent, nodesize, 0);
+	eb = read_tree_block(fs_info, parent, nodesize, 0);
 	if (!extent_buffer_uptodate(eb))
 		goto out;
 
@@ -11505,7 +11505,8 @@ static int traverse_tree_block(struct btrfs_root *root,
 		 * As a btrfs tree has most 8 levels (0..7), so it's quite safe
 		 * to call the function itself.
 		 */
-		eb = read_tree_block(root, blocknr, root->fs_info->nodesize, 0);
+		eb = read_tree_block(root->fs_info, blocknr,
+				root->fs_info->nodesize, 0);
 		if (extent_buffer_uptodate(eb)) {
 			ret = traverse_tree_block(root, eb);
 			err |= ret;
@@ -11691,8 +11692,7 @@ static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
 			 * in, but for now this doesn't actually use the root so
 			 * just pass in extent_root.
 			 */
-			tmp = read_tree_block(fs_info->extent_root, bytenr,
-					      nodesize, 0);
+			tmp = read_tree_block(fs_info, bytenr, nodesize, 0);
 			if (!extent_buffer_uptodate(tmp)) {
 				fprintf(stderr, "Error reading root block\n");
 				return -EIO;
@@ -11710,7 +11710,7 @@ static int pin_down_tree_blocks(struct btrfs_fs_info *fs_info,
 				continue;
 			}
 
-			tmp = read_tree_block(fs_info->extent_root, bytenr,
+			tmp = read_tree_block(fs_info, bytenr,
 					      nodesize, 0);
 			if (!extent_buffer_uptodate(tmp)) {
 				fprintf(stderr, "Error reading tree block\n");
diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 869ad6ba..93dff086 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -52,7 +52,8 @@ static void print_extents(struct btrfs_root *root, struct extent_buffer *eb)
 	size = root->fs_info->nodesize;
 	nr = btrfs_header_nritems(eb);
 	for (i = 0; i < nr; i++) {
-		next = read_tree_block(root, btrfs_node_blockptr(eb, i),
+		next = read_tree_block(root->fs_info,
+				btrfs_node_blockptr(eb, i),
 				size, btrfs_node_ptr_generation(eb, i));
 		if (!extent_buffer_uptodate(next))
 			continue;
@@ -311,7 +312,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	}
 
 	if (block_only) {
-		leaf = read_tree_block(root,
+		leaf = read_tree_block(info,
 				      block_only,
 				      info->nodesize, 0);
 
@@ -322,7 +323,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 		}
 
 		if (!leaf) {
-			leaf = read_tree_block(root,
+			leaf = read_tree_block(info,
 					      block_only,
 					      info->nodesize, 0);
 		}
@@ -439,8 +440,7 @@ again:
 
 			offset = btrfs_item_ptr_offset(leaf, slot);
 			read_extent_buffer(leaf, &ri, offset, sizeof(ri));
-			buf = read_tree_block(tree_root_scan,
-					      btrfs_root_bytenr(&ri),
+			buf = read_tree_block(info, btrfs_root_bytenr(&ri),
 					      info->nodesize, 0);
 			if (!extent_buffer_uptodate(buf))
 				goto next;
diff --git a/cmds-inspect-tree-stats.c b/cmds-inspect-tree-stats.c
index ecb33ce2..05f4f616 100644
--- a/cmds-inspect-tree-stats.c
+++ b/cmds-inspect-tree-stats.c
@@ -153,7 +153,7 @@ static int walk_nodes(struct btrfs_root *root, struct btrfs_path *path,
 
 		path->slots[level] = i;
 		if ((level - 1) > 0 || find_inline) {
-			tmp = read_tree_block(root, cur_blocknr,
+			tmp = read_tree_block(root->fs_info, cur_blocknr,
 					      nodesize,
 					      btrfs_node_ptr_generation(b, i));
 			if (!extent_buffer_uptodate(tmp)) {
diff --git a/cmds-restore.c b/cmds-restore.c
index 09388b29..ae01430c 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1255,7 +1255,7 @@ static struct btrfs_root *open_fs(const char *dev, u64 root_location,
 		if (!root_location)
 			root_location = btrfs_super_root(fs_info->super_copy);
 		generation = btrfs_super_generation(fs_info->super_copy);
-		root->node = read_tree_block(root, root_location,
+		root->node = read_tree_block(fs_info, root_location,
 					     fs_info->nodesize, generation);
 		if (!extent_buffer_uptodate(root->node)) {
 			fprintf(stderr, "Error opening tree root\n");
@@ -1502,7 +1502,7 @@ int cmd_restore(int argc, char **argv)
 
 	if (fs_location != 0) {
 		free_extent_buffer(root->node);
-		root->node = read_tree_block(root, fs_location,
+		root->node = read_tree_block(root->fs_info, fs_location,
 				root->fs_info->nodesize, 0);
 		if (!extent_buffer_uptodate(root->node)) {
 			fprintf(stderr, "Failed to read fs location\n");
diff --git a/ctree.c b/ctree.c
index 266a3cf2..09273818 100644
--- a/ctree.c
+++ b/ctree.c
@@ -649,7 +649,7 @@ struct extent_buffer *read_node_slot(struct btrfs_root *root,
 	if (level == 0)
 		return NULL;
 
-	return read_tree_block(root, btrfs_node_blockptr(parent, slot),
+	return read_tree_block(root->fs_info, btrfs_node_blockptr(parent, slot),
 		       root->fs_info->nodesize,
 		       btrfs_node_ptr_generation(parent, slot));
 }
diff --git a/disk-io.c b/disk-io.c
index 553073a4..ec2f52af 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -306,7 +306,7 @@ int read_whole_eb(struct btrfs_fs_info *info, struct extent_buffer *eb, int mirr
 	return 0;
 }
 
-struct extent_buffer* read_tree_block_fs_info(
+struct extent_buffer* read_tree_block(
 		struct btrfs_fs_info *fs_info, u64 bytenr, u32 blocksize,
 		u64 parent_transid)
 {
@@ -634,8 +634,9 @@ static int find_and_setup_root(struct btrfs_root *tree_root,
 
 	blocksize = fs_info->nodesize;
 	generation = btrfs_root_generation(&root->root_item);
-	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
-				     blocksize, generation);
+	root->node = read_tree_block(fs_info,
+			btrfs_root_bytenr(&root->root_item),
+			blocksize, generation);
 	if (!extent_buffer_uptodate(root->node))
 		return -EIO;
 
@@ -663,7 +664,7 @@ static int find_and_setup_log_root(struct btrfs_root *tree_root,
 	btrfs_setup_root(log_root, fs_info,
 			 BTRFS_TREE_LOG_OBJECTID);
 
-	log_root->node = read_tree_block(tree_root, blocknr,
+	log_root->node = read_tree_block(fs_info, blocknr,
 				     blocksize,
 				     btrfs_super_generation(disk_super) + 1);
 
@@ -752,8 +753,9 @@ out:
 	}
 	generation = btrfs_root_generation(&root->root_item);
 	blocksize = fs_info->nodesize;
-	root->node = read_tree_block(root, btrfs_root_bytenr(&root->root_item),
-				     blocksize, generation);
+	root->node = read_tree_block(fs_info,
+			btrfs_root_bytenr(&root->root_item),
+			blocksize, generation);
 	if (!extent_buffer_uptodate(root->node)) {
 		free(root);
 		return ERR_PTR(-EIO);
@@ -1012,7 +1014,7 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 		generation = btrfs_backup_tree_root_gen(backup);
 	}
 
-	root->node = read_tree_block(root, root_tree_bytenr, blocksize,
+	root->node = read_tree_block(fs_info, root_tree_bytenr, blocksize,
 				     generation);
 	if (!extent_buffer_uptodate(root->node)) {
 		fprintf(stderr, "Couldn't read tree root\n");
@@ -1197,7 +1199,7 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info,
 	else
 		generation = 0;
 
-	fs_info->chunk_root->node = read_tree_block(fs_info->chunk_root,
+	fs_info->chunk_root->node = read_tree_block(fs_info,
 						    chunk_root_bytenr,
 						    fs_info->nodesize,
 						    generation);
diff --git a/disk-io.h b/disk-io.h
index b4d02275..b097785a 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -115,16 +115,9 @@ static inline u64 btrfs_sb_offset(int mirror)
 struct btrfs_device;
 
 int read_whole_eb(struct btrfs_fs_info *info, struct extent_buffer *eb, int mirror);
-struct extent_buffer* read_tree_block_fs_info(
+struct extent_buffer* read_tree_block(
 		struct btrfs_fs_info *fs_info, u64 bytenr, u32 blocksize,
 		u64 parent_transid);
-static inline struct extent_buffer* read_tree_block(
-		struct btrfs_root *root, u64 bytenr, u32 blocksize,
-		u64 parent_transid)
-{
-	return read_tree_block_fs_info(root->fs_info, bytenr, blocksize,
-			parent_transid);
-}
 
 int read_extent_data(struct btrfs_root *root, char *data, u64 logical,
 		     u64 *len, int mirror);
diff --git a/find-root.c b/find-root.c
index 89d36119..1b41b217 100644
--- a/find-root.c
+++ b/find-root.c
@@ -133,8 +133,7 @@ int btrfs_find_root_search(struct btrfs_fs_info *fs_info,
 		for (offset = chunk_offset;
 		     offset < chunk_offset + chunk_size;
 		     offset += nodesize) {
-			eb = read_tree_block_fs_info(fs_info, offset, nodesize,
-						     0);
+			eb = read_tree_block(fs_info, offset, nodesize, 0);
 			if (!eb || IS_ERR(eb))
 				continue;
 			ret = add_eb_to_result(eb, result, nodesize, filter,
diff --git a/image/main.c b/image/main.c
index 6a4ccfaf..b41739cf 100644
--- a/image/main.c
+++ b/image/main.c
@@ -973,7 +973,8 @@ static int flush_pending(struct metadump_struct *md, int done)
 
 		while (!md->data && size > 0) {
 			u64 this_read = min(blocksize, size);
-			eb = read_tree_block(md->root, start, this_read, 0);
+			eb = read_tree_block(md->root->fs_info, start,
+					     this_read, 0);
 			if (!extent_buffer_uptodate(eb)) {
 				free(async->buffer);
 				free(async);
@@ -1077,13 +1078,14 @@ static int copy_tree_blocks(struct btrfs_root *root, struct extent_buffer *eb,
 	struct extent_buffer *tmp;
 	struct btrfs_root_item *ri;
 	struct btrfs_key key;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 bytenr;
 	int level;
 	int nritems = 0;
 	int i = 0;
 	int ret;
 
-	ret = add_extent(btrfs_header_bytenr(eb), root->fs_info->nodesize,
+	ret = add_extent(btrfs_header_bytenr(eb), fs_info->nodesize,
 			 metadump, 0);
 	if (ret) {
 		error("unable to add metadata block %llu: %d",
@@ -1103,8 +1105,8 @@ static int copy_tree_blocks(struct btrfs_root *root, struct extent_buffer *eb,
 				continue;
 			ri = btrfs_item_ptr(eb, i, struct btrfs_root_item);
 			bytenr = btrfs_disk_root_bytenr(eb, ri);
-			tmp = read_tree_block(root, bytenr,
-					      root->fs_info->nodesize, 0);
+			tmp = read_tree_block(fs_info, bytenr,
+					      fs_info->nodesize, 0);
 			if (!extent_buffer_uptodate(tmp)) {
 				error("unable to read log root block");
 				return -EIO;
@@ -1115,8 +1117,8 @@ static int copy_tree_blocks(struct btrfs_root *root, struct extent_buffer *eb,
 				return ret;
 		} else {
 			bytenr = btrfs_node_blockptr(eb, i);
-			tmp = read_tree_block(root, bytenr,
-					      root->fs_info->nodesize, 0);
+			tmp = read_tree_block(fs_info, bytenr,
+					      fs_info->nodesize, 0);
 			if (!extent_buffer_uptodate(tmp)) {
 				error("unable to read log root block");
 				return -EIO;
diff --git a/print-tree.c b/print-tree.c
index 1b15640b..07366e98 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1314,7 +1314,8 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int fol
 		return;
 
 	for (i = 0; i < nr; i++) {
-		next = read_tree_block(root, btrfs_node_blockptr(eb, i), size,
+		next = read_tree_block(root->fs_info,
+				btrfs_node_blockptr(eb, i), size,
 				btrfs_node_ptr_generation(eb, i));
 		if (!extent_buffer_uptodate(next)) {
 			fprintf(stderr, "failed to read %llu in tree %llu\n",
diff --git a/qgroup-verify.c b/qgroup-verify.c
index 2f4b1c66..5162adbb 100644
--- a/qgroup-verify.c
+++ b/qgroup-verify.c
@@ -711,7 +711,7 @@ static int travel_tree(struct btrfs_fs_info *info, struct btrfs_root *root,
 //	printf("travel_tree: bytenr: %llu\tnum_bytes: %llu\tref_parent: %llu\n",
 //	       bytenr, num_bytes, ref_parent);
 
-	eb = read_tree_block(root, bytenr, num_bytes, 0);
+	eb = read_tree_block(info, bytenr, num_bytes, 0);
 	if (!extent_buffer_uptodate(eb))
 		return -EIO;
 
-- 
2.13.0



