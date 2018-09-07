Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53918 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728406AbeIGOMy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 10:12:54 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BA5D8AFC8
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 09:32:47 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/5] btrfs: qgroup: Introduce function to find all new tree blocks of reloc tree
Date: Fri,  7 Sep 2018 17:32:33 +0800
Message-Id: <20180907093235.28254-4-wqu@suse.com>
In-Reply-To: <20180907093235.28254-1-wqu@suse.com>
References: <20180907093235.28254-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce new function, qgroup_trace_new_subtree_blocks(), to iterate
all new tree blocks in a reloc tree.
So that qgroup could skip unrelated tree blocks during balance, which
should hugely speedup balance speed when quota is enabled.

The function qgroup_trace_new_subtree_blocks() itself only cares about
new tree blocks in reloc tree.

All its main works are:

1) Read out tree blocks according to parent pointers

2) Do recursive depth-first search
   Will call the same function on all its children tree blocks, with
   search level set to current level -1.
   And will also skip all children whose generation is smaller than
   @last_snapshot.

3) Call qgroup_trace_extent_swap() to trace tree blocks

So although we have parameter list related to source file tree, it's not
used at all, but only passed to qgroup_trace_extent_swap().
Thus despite the tree read code, the core should be pretty short and all
about recursive depth-first search.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 5155fb42ce79..0702953d70a7 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1839,6 +1839,120 @@ static int qgroup_trace_extent_swap(struct btrfs_trans_handle* trans,
 	return ret;
 }
 
+/*
+ * Helper function to do recursive generation aware depth-first search, to
+ * locate all new tree blocks in a subtree of tree reloc tree.
+ *
+ * E.g. (OO = Old tree blocks, NN = New tree blocks, whose gen == last_snapshot)
+ *       Tree reloc tree
+ * L2         NN (a)
+ *          /    \
+ * L1    OO        NN (b)
+ *      /  \      /  \
+ * L0  OO  OO    OO  NN
+ *               (c) (d)
+ * If we pass:
+ * @dst_path = [ nodes[1] = NN(b), nodes[0] = NULL ],
+ * @cur_level = 1
+ * @root_level = 1
+ *
+ * We will iterate through tree blocks NN(b), NN(d) and info qgroup to trace
+ * above tree blocks along with their counter parts in file tree.
+ * While during search, old tree blocsk OO(c) will be skiped as tree block swap
+ * won't affect OO(c).
+ */
+static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
+					   struct extent_buffer *src_eb,
+					   struct btrfs_path *dst_path,
+					   int cur_level, int root_level,
+					   u64 last_snapshot)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct extent_buffer *eb;
+	bool need_cleanup = false;
+	int ret = 0;
+	int i;
+
+	/* Read the tree block if needed */
+	if (dst_path->nodes[cur_level] == NULL) {
+		struct btrfs_key first_key;
+		int parent_slot;
+		u64 child_gen;
+		u64 child_bytenr;
+
+		/*
+		 * We need to get child blockptr/gen from parent before
+		 * we can read it.
+		  */
+		eb = dst_path->nodes[cur_level + 1];
+		parent_slot = dst_path->slots[cur_level + 1];
+		child_bytenr = btrfs_node_blockptr(eb, parent_slot);
+		child_gen = btrfs_node_ptr_generation(eb, parent_slot);
+		btrfs_node_key_to_cpu(eb, &first_key, parent_slot);
+
+		/* This node is old, no need to trace */
+		if (child_gen < last_snapshot)
+			goto out;
+
+		eb = read_tree_block(fs_info, child_bytenr, child_gen,
+				     cur_level, &first_key);
+		if (IS_ERR(eb)) {
+			ret = PTR_ERR(eb);
+			goto out;
+		} else if (!extent_buffer_uptodate(eb)) {
+			free_extent_buffer(eb);
+			ret = -EIO;
+			goto out;
+		}
+
+		dst_path->nodes[cur_level] = eb;
+		dst_path->slots[cur_level] = 0;
+
+		btrfs_tree_read_lock(eb);
+		btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
+		dst_path->locks[cur_level] = BTRFS_READ_LOCK_BLOCKING;
+		need_cleanup = true;
+	}
+
+	/* Now record this tree block and its counter part for qgroups */
+	ret = qgroup_trace_extent_swap(trans, src_eb, dst_path, cur_level,
+				       root_level);
+	if (ret < 0)
+		goto cleanup;
+
+	eb = dst_path->nodes[cur_level];
+
+	if (cur_level > 0) {
+		/* Iterate all children tree blocks */
+		for (i = 0; i < btrfs_header_nritems(eb); i++) {
+			/* Skip old tree blocks as they won't be swapped */
+			if (btrfs_node_ptr_generation(eb, i) < last_snapshot)
+				continue;
+			dst_path->slots[cur_level] = i;
+
+			/* Recursive call (at most 7 times) */
+			ret = qgroup_trace_new_subtree_blocks(trans, src_eb,
+					dst_path, cur_level - 1, root_level,
+					last_snapshot);
+			if (ret < 0)
+				goto cleanup;
+		}
+	}
+
+cleanup:
+	if (need_cleanup) {
+		/* Clean up */
+		btrfs_tree_unlock_rw(dst_path->nodes[cur_level],
+				     dst_path->locks[cur_level]);
+		free_extent_buffer(dst_path->nodes[cur_level]);
+		dst_path->nodes[cur_level] = NULL;
+		dst_path->slots[cur_level] = 0;
+		dst_path->locks[cur_level] = 0;
+	}
+out:
+	return ret;
+}
+
 int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
 			       struct extent_buffer *root_eb,
 			       u64 root_gen, int root_level)
-- 
2.18.0
