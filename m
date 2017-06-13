Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17180 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752600AbdFMJTw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:52 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 09/19] btrfs-progs: Refactor btrfs_find_tree_block to use btrfs_fs_info
Date: Tue, 13 Jun 2017 17:19:25 +0800
Message-ID: <20170613091935.23277-10-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c  | 16 +++++++++-------
 ctree.c       |  5 +++--
 disk-io.c     |  6 +++---
 disk-io.h     |  2 +-
 extent-tree.c |  2 +-
 5 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index fb4b468d..b9c21553 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2104,6 +2104,7 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 	enum btrfs_tree_block_status status;
 	u64 bytenr;
 	u64 ptr_gen;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *next;
 	struct extent_buffer *cur;
 	u32 blocksize;
@@ -2155,7 +2156,7 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 		}
 		bytenr = btrfs_node_blockptr(cur, path->slots[*level]);
 		ptr_gen = btrfs_node_ptr_generation(cur, path->slots[*level]);
-		blocksize = root->fs_info->nodesize;
+		blocksize = fs_info->nodesize;
 
 		if (bytenr == nrefs->bytenr[*level - 1]) {
 			refs = nrefs->refs[*level - 1];
@@ -2179,7 +2180,7 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 			}
 		}
 
-		next = btrfs_find_tree_block(root, bytenr, blocksize);
+		next = btrfs_find_tree_block(fs_info, bytenr, blocksize);
 		if (!next || !btrfs_buffer_uptodate(next, ptr_gen)) {
 			free_extent_buffer(next);
 			reada_walk_down(root, cur, path->slots[*level]);
@@ -2242,6 +2243,7 @@ static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
 	enum btrfs_tree_block_status status;
 	u64 bytenr;
 	u64 ptr_gen;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *next;
 	struct extent_buffer *cur;
 	u32 blocksize;
@@ -2284,7 +2286,7 @@ static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
 		}
 		bytenr = btrfs_node_blockptr(cur, path->slots[*level]);
 		ptr_gen = btrfs_node_ptr_generation(cur, path->slots[*level]);
-		blocksize = root->fs_info->nodesize;
+		blocksize = fs_info->nodesize;
 
 		ret = update_nodes_refs(root, bytenr, nrefs, *level - 1);
 		if (ret)
@@ -2294,11 +2296,11 @@ static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
 			continue;
 		}
 
-		next = btrfs_find_tree_block(root, bytenr, blocksize);
+		next = btrfs_find_tree_block(fs_info, bytenr, blocksize);
 		if (!next || !btrfs_buffer_uptodate(next, ptr_gen)) {
 			free_extent_buffer(next);
 			reada_walk_down(root, cur, path->slots[*level]);
-			next = read_tree_block(root->fs_info, bytenr, blocksize,
+			next = read_tree_block(fs_info, bytenr, blocksize,
 					       ptr_gen);
 			if (!extent_buffer_uptodate(next)) {
 				struct btrfs_key node_key;
@@ -2306,10 +2308,10 @@ static int walk_down_tree_v2(struct btrfs_root *root, struct btrfs_path *path,
 				btrfs_node_key_to_cpu(path->nodes[*level],
 						      &node_key,
 						      path->slots[*level]);
-				btrfs_add_corrupt_extent_record(root->fs_info,
+				btrfs_add_corrupt_extent_record(fs_info,
 						&node_key,
 						path->nodes[*level]->start,
-						root->fs_info->nodesize,
+						fs_info->nodesize,
 						*level);
 				ret = -EIO;
 				break;
diff --git a/ctree.c b/ctree.c
index a5aae517..a6916b30 100644
--- a/ctree.c
+++ b/ctree.c
@@ -968,6 +968,7 @@ static int noinline push_nodes_for_insert(struct btrfs_trans_handle *trans,
 void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
 			     int level, int slot, u64 objectid)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *node;
 	struct btrfs_disk_key disk_key;
 	u32 nritems;
@@ -989,8 +990,8 @@ void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
 
 	node = path->nodes[level];
 	search = btrfs_node_blockptr(node, slot);
-	blocksize = root->fs_info->nodesize;
-	eb = btrfs_find_tree_block(root, search, blocksize);
+	blocksize = fs_info->nodesize;
+	eb = btrfs_find_tree_block(fs_info, search, blocksize);
 	if (eb) {
 		free_extent_buffer(eb);
 		return;
diff --git a/disk-io.c b/disk-io.c
index 8b5139f5..7addaf61 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -174,10 +174,10 @@ int csum_tree_block(struct btrfs_fs_info *fs_info,
 	return csum_tree_block_size(buf, csum_size, verify);
 }
 
-struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
+struct extent_buffer *btrfs_find_tree_block(struct btrfs_fs_info *fs_info,
 					    u64 bytenr, u32 blocksize)
 {
-	return find_extent_buffer(&root->fs_info->extent_cache,
+	return find_extent_buffer(&fs_info->extent_cache,
 				  bytenr, blocksize);
 }
 
@@ -195,7 +195,7 @@ void readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
 	struct btrfs_multi_bio *multi = NULL;
 	struct btrfs_device *device;
 
-	eb = btrfs_find_tree_block(root, bytenr, blocksize);
+	eb = btrfs_find_tree_block(root->fs_info, bytenr, blocksize);
 	if (!(eb && btrfs_buffer_uptodate(eb, parent_transid)) &&
 	    !btrfs_map_block(root->fs_info, READ, bytenr, &length, &multi, 0,
 			     NULL)) {
diff --git a/disk-io.h b/disk-io.h
index 97a74993..20520e59 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -168,7 +168,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 		unsigned sbflags);
 int btrfs_map_bh_to_logical(struct btrfs_root *root, struct extent_buffer *bh,
 			    u64 logical);
-struct extent_buffer *btrfs_find_tree_block(struct btrfs_root *root,
+struct extent_buffer *btrfs_find_tree_block(struct btrfs_fs_info *fs_info,
 					    u64 bytenr, u32 blocksize);
 struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 				      struct btrfs_key *location);
diff --git a/extent-tree.c b/extent-tree.c
index f252c0ce..9aa47c55 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -2119,7 +2119,7 @@ static int pin_down_bytes(struct btrfs_trans_handle *trans,
 	if (is_data)
 		goto pinit;
 
-	buf = btrfs_find_tree_block(root, bytenr, num_bytes);
+	buf = btrfs_find_tree_block(root->fs_info, bytenr, num_bytes);
 	if (!buf)
 		goto pinit;
 
-- 
2.13.1



