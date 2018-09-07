Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53924 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725843AbeIGOM6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 10:12:58 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 92457AFC8
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 09:32:50 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/5] btrfs: qgroup: Use generation aware subtree swap to mark dirty extents
Date: Fri,  7 Sep 2018 17:32:34 +0800
Message-Id: <20180907093235.28254-5-wqu@suse.com>
In-Reply-To: <20180907093235.28254-1-wqu@suse.com>
References: <20180907093235.28254-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, for quota enabled balance, btrfs needs to mark the
whole subtree dirty for quota.

E.g.
OO = Old tree blocks (from file tree)
NN = New tree blocks (from reloc tree)

        File tree (src)		          Reloc tree (dst)
            OO (a)                              NN (a)
           /  \                                /  \
     (b) OO    OO (c)                    (b) NN    NN (c)
        /  \  /  \                          /  \  /  \
       OO  OO OO OO (d)                    OO  OO OO NN (d)

For old balance + quota case, quota will mark the whole src and dst tree
dirty, including all the 3 old tree blocks in reloc tree.

It's doable for small file tree or new tree blocks are all
located at lower level.

But for large file tree or new tree blocks are all located at higher
level, this will lead to mark the whole tree dirty, and be unbelievably
slow.

This patch will change how we handle such balance with quota enabled
case.

Now we will search from (b) and (c) for any new tree blocks whose generation
is equal to @last_snapshot, and only mark them dirty.

In above case, we only need to trace tree blocks NN(b), NN(c) and NN(d).
(NN(a) will be traced when CoW happens for nodeptr modification).
And also for tree blocks OO(b), OO(c), OO(d). (OO(a) will be traced when
CoW happens for nodeptr modification)

For above case, we could skip 3 tree blocks, but for larger tree, we can
skip tons of unmodified tree blocks, and hugely speed up balance.

This patch will introduce a new function,
btrfs_qgroup_trace_subtree_swap(), which will do the following main
work:

1) Read out real root eb
   And setup basic dst_path for later calls
2) Call qgroup_trace_new_subtree_blocks()
   To trace all new tree blocks in reloc tree and their counter
   parts in file tree.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c     | 94 +++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/qgroup.h     | 10 +++++
 fs/btrfs/relocation.c | 11 ++---
 3 files changed, 107 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 0702953d70a7..a94027b2620e 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1953,6 +1953,100 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
 	return ret;
 }
 
+/*
+ * For balance subtree swap.
+ *
+ * Will go down the tree block pointed by @dst_eb (pointed by @dst_parent and
+ * @dst_slot), and find any tree blocks whose generation is at @last_snapshot,
+ * and then go down @src_eb (pointed by @src_parent and @src_slot) to find
+ * the conterpart of the tree block, then mark both tree blocks as qgroup dirty,
+ * and skip all tree blocks whose generation is smaller than last_snapshot.
+ *
+ * This would skip tons of tree blocks of original btrfs_qgroup_trace_subtree(),
+ * which is the culprit of super slow balance if the file tree is large.
+ *
+ * @src_parent, @src_slot: pointer to src (file tree) eb.
+ * @dst_parent, @dst_slot: pointer to dst (tree reloc tree) eb.
+ */
+int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
+				struct extent_buffer *src_parent, int src_slot,
+				struct extent_buffer *dst_parent, int dst_slot,
+				u64 last_snapshot)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_path *dst_path = NULL;
+	struct btrfs_key first_key;
+	struct extent_buffer *src_eb = NULL;
+	struct extent_buffer *dst_eb = NULL;
+	u64 child_gen;
+	u64 child_bytenr;
+	int level;
+	int ret;
+
+	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags))
+		return 0;
+
+	/* Wrong parameter order */
+	BUG_ON(btrfs_node_ptr_generation(src_parent, src_slot) >
+		btrfs_node_ptr_generation(dst_parent, dst_slot));
+
+	/* Read out real @src_eb, pointed by @src_parent and @src_slot */
+	child_bytenr = btrfs_node_blockptr(src_parent, src_slot);
+	child_gen = btrfs_node_ptr_generation(src_parent, src_slot);
+	btrfs_node_key_to_cpu(src_parent, &first_key, src_slot);
+
+	src_eb = read_tree_block(fs_info, child_bytenr, child_gen,
+			btrfs_header_level(src_parent) - 1, &first_key);
+	if (IS_ERR(src_eb)) {
+		ret = PTR_ERR(src_eb);
+		goto out;
+	}
+
+	/* Read out real @dst_eb, pointed by @src_parent and @src_slot */
+	child_bytenr = btrfs_node_blockptr(dst_parent, dst_slot);
+	child_gen = btrfs_node_ptr_generation(dst_parent, dst_slot);
+	btrfs_node_key_to_cpu(dst_parent, &first_key, dst_slot);
+
+	dst_eb = read_tree_block(fs_info, child_bytenr, child_gen,
+			btrfs_header_level(dst_parent) - 1, &first_key);
+	if (IS_ERR(dst_eb)) {
+		ret = PTR_ERR(dst_eb);
+		goto out;
+	}
+
+	if (!extent_buffer_uptodate(src_eb) || !extent_buffer_uptodate(dst_eb)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	level = btrfs_header_level(dst_eb);
+	dst_path = btrfs_alloc_path();
+	if (!dst_path) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	/* For dst_path */
+	extent_buffer_get(dst_eb);
+	dst_path->nodes[level] = dst_eb;
+	dst_path->slots[level] = 0;
+	dst_path->locks[level] = 0;
+
+	/* Do the generation aware breadth-first search */
+	ret = qgroup_trace_new_subtree_blocks(trans, src_eb, dst_path, level,
+					      level, last_snapshot);
+	if (ret < 0)
+		goto out;
+	ret = 0;
+
+out:
+	free_extent_buffer(src_eb);
+	free_extent_buffer(dst_eb);
+	btrfs_free_path(dst_path);
+	if (ret < 0)
+		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
+	return ret;
+}
+
 int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 			       struct extent_buffer *root_eb,
 			       u64 root_gen, int root_level)
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index 54b8bb282c0e..9f9943dfd493 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -236,6 +236,16 @@ int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
 int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 			       struct extent_buffer *root_eb,
 			       u64 root_gen, int root_level);
+
+/*
+ * Inform qgroup to trace subtree swap used in balance.
+ * Unlike btrfs_qgroup_trace_subtree(), this function will only trace
+ * new tree blocks whose generation is equal to (or larger than) @last_snapshot.
+ */
+int btrfs_qgroup_trace_subtree_swap(struct btrfs_trans_handle *trans,
+				struct extent_buffer *src_parent, int src_slot,
+				struct extent_buffer *dst_parent, int dst_slot,
+				u64 last_snapshot);
 int btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans, u64 bytenr,
 				u64 num_bytes, struct ulist *old_roots,
 				struct ulist *new_roots);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 8783a1776540..07ab61a740ae 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1879,14 +1879,9 @@ int replace_path(struct btrfs_trans_handle *trans,
 		 *    and tree block numbers, if current trans doesn't free
 		 *    data reloc tree inode.
 		 */
-		ret = btrfs_qgroup_trace_subtree(trans, parent,
-				btrfs_header_generation(parent),
-				btrfs_header_level(parent));
-		if (ret < 0)
-			break;
-		ret = btrfs_qgroup_trace_subtree(trans, path->nodes[level],
-				btrfs_header_generation(path->nodes[level]),
-				btrfs_header_level(path->nodes[level]));
+		ret = btrfs_qgroup_trace_subtree_swap(trans, parent, slot,
+				path->nodes[level], path->slots[level],
+				last_snapshot);
 		if (ret < 0)
 			break;
 
-- 
2.18.0
