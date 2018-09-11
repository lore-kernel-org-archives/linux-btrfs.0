Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55308 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726274AbeIKKgz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 06:36:55 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 39ED3B08D
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 05:39:18 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 7/7] btrfs: qgroup: Only trace data extents in leaves if we're relocating data block group
Date: Tue, 11 Sep 2018 13:38:18 +0800
Message-Id: <20180911053818.10191-8-wqu@suse.com>
In-Reply-To: <20180911053818.10191-1-wqu@suse.com>
References: <20180911053818.10191-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For qgroup_trace_extent_swap(), if we find one leaf needs to be traced,
btrfs will also iterate all file extents and trace them.

This is OK if we're relocating data block groups, but if we're
relocating metadata block groups, balance code itself has ensured that
both subtree of file tree and reloc tree contain the same contents.

That's to say, if we're relocating metadata block groups, all file
extents in reloc and file tree should match, thus no need to trace them.
This should reduce the total number of dirty extents processed in metadata
block group balance.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c     | 21 +++++++++++++++------
 fs/btrfs/qgroup.h     |  1 +
 fs/btrfs/relocation.c | 10 +++++-----
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a94027b2620e..f58350a37c2d 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1725,7 +1725,8 @@ static int adjust_slots_upwards(struct btrfs_path *path, int root_level)
 static int qgroup_trace_extent_swap(struct btrfs_trans_handle* trans,
 				    struct extent_buffer *src_eb,
 				    struct btrfs_path *dst_path,
-				    int dst_level, int root_level)
+				    int dst_level, int root_level,
+				    bool trace_leaf)
 {
 	struct btrfs_key key;
 	struct btrfs_path *src_path;
@@ -1828,7 +1829,7 @@ static int qgroup_trace_extent_swap(struct btrfs_trans_handle* trans,
 		goto out;
 
 	/* Record leaf file extents */
-	if (dst_level == 0) {
+	if (dst_level == 0 && trace_leaf) {
 		ret = btrfs_qgroup_trace_leaf_items(trans, src_path->nodes[0]);
 		if (ret < 0)
 			goto out;
@@ -1865,7 +1866,7 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 					   struct extent_buffer *src_eb,
 					   struct btrfs_path *dst_path,
 					   int cur_level, int root_level,
-					   u64 last_snapshot)
+					   u64 last_snapshot, bool trace_leaf)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct extent_buffer *eb;
@@ -1916,7 +1917,7 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 
 	/* Now record this tree block and its counter part for qgroups */
 	ret = qgroup_trace_extent_swap(trans, src_eb, dst_path, cur_level,
-				       root_level);
+				       root_level, trace_leaf);
 	if (ret < 0)
 		goto cleanup;
 
@@ -1933,7 +1934,7 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 			/* Recursive call (at most 7 times) */
 			ret = qgroup_trace_new_subtree_blocks(trans, src_eb,
 					dst_path, cur_level - 1, root_level,
-					last_snapshot);
+					last_snapshot, trace_leaf);
 			if (ret < 0)
 				goto cleanup;
 		}
@@ -1969,6 +1970,7 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
  * @dst_parent, @dst_slot: pointer to dst (tree reloc tree) eb.
  */
 int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
+				struct btrfs_block_group_cache *bg_cache,
 				struct extent_buffer *src_parent, int src_slot,
 				struct extent_buffer *dst_parent, int dst_slot,
 				u64 last_snapshot)
@@ -1978,6 +1980,7 @@ int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
 	struct btrfs_key first_key;
 	struct extent_buffer *src_eb = NULL;
 	struct extent_buffer *dst_eb = NULL;
+	bool trace_leaf = false;
 	u64 child_gen;
 	u64 child_bytenr;
 	int level;
@@ -1990,6 +1993,12 @@ int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
 	BUG_ON(btrfs_node_ptr_generation(src_parent, src_slot) >
 		btrfs_node_ptr_generation(dst_parent, dst_slot));
 
+	/*
+	 * Only trace leaf if we're relocating data block groups, this could
+	 * reduce tons of data extents tracing for meta/sys bg relocation.
+	 */
+	if (bg_cache->flags & BTRFS_BLOCK_GROUP_DATA)
+		trace_leaf = true;
 	/* Read out real @src_eb, pointed by @src_parent and @src_slot */
 	child_bytenr = btrfs_node_blockptr(src_parent, src_slot);
 	child_gen = btrfs_node_ptr_generation(src_parent, src_slot);
@@ -2033,7 +2042,7 @@ int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
 
 	/* Do the generation aware breadth-first search */
 	ret = qgroup_trace_new_subtree_blocks(trans, src_eb, dst_path, level,
-					      level, last_snapshot);
+					      level, last_snapshot, trace_leaf);
 	if (ret < 0)
 		goto out;
 	ret = 0;
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 9f9943dfd493..5289cf0e5e6b 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -243,6 +243,7 @@ int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
  * new tree blocks whose generation is equal to (or larger than) @last_snapshot.
  */
 int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
+				struct btrfs_block_group_cache *bg_cache,
 				struct extent_buffer *src_parent, int src_slot,
 				struct extent_buffer *dst_parent, int dst_slot,
 				u64 last_snapshot);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 07ab61a740ae..44efde9886fc 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1735,7 +1735,7 @@ int memcmp_node_keys(struct extent_buffer *eb, int slot,
  * errors, a negative error number is returned.
  */
 static noinline_for_stack
-int replace_path(struct btrfs_trans_handle *trans,
+int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 		 struct btrfs_root *dest, struct btrfs_root *src,
 		 struct btrfs_path *path, struct btrfs_key *next_key,
 		 int lowest_level, int max_level)
@@ -1879,9 +1879,9 @@ int replace_path(struct btrfs_trans_handle *trans,
 		 *    and tree block numbers, if current trans doesn't free
 		 *    data reloc tree inode.
 		 */
-		ret = btrfs_qgroup_trace_subtree_swap(trans, parent, slot,
-				path->nodes[level], path->slots[level],
-				last_snapshot);
+		ret = btrfs_qgroup_trace_subtree_swap(trans, rc->block_group,
+				parent, slot, path->nodes[level],
+				path->slots[level], last_snapshot);
 		if (ret < 0)
 			break;
 
@@ -2200,7 +2200,7 @@ static noinline_for_stack int merge_reloc_root(struct reloc_control *rc,
 		    btrfs_comp_cpu_keys(&next_key, &key) >= 0) {
 			ret = 0;
 		} else {
-			ret = replace_path(trans, root, reloc_root, path,
+			ret = replace_path(trans, rc, root, reloc_root, path,
 					   &next_key, level, max_level);
 		}
 		if (ret < 0) {
-- 
2.18.0
