Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39542 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbcDZDto (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 23:49:44 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH RFC 15/16] btrfs-progs: fsck: Introduce traversal function for fsck
Date: Tue, 26 Apr 2016 11:49:02 +0800
Message-Id: <1461642543-4621-16-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce a new function traversal_tree_block() to do pre-order
traversal, to co-operate with new fs/subvolume tree skip function.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 92f8aa1..85d6cf4 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9644,6 +9644,83 @@ need_check:
 	return 1;
 }
 
+/*
+ * Traversal function for tree block.
+ * We will do
+ * 1) Skip shared fs/subvolume tree blocks
+ * 2) Update related bytes accounting
+ * 3) Pre-order traversal
+ */
+static int traversal_tree_block(struct btrfs_root *root,
+				struct extent_buffer *node)
+{
+	struct extent_buffer *eb;
+	int level;
+	u64 nr;
+	int i;
+	int err = 0;
+	int ret;
+
+	/*
+	 * Skip shared fs/subvolume tree block, in that case they will
+	 * be checked by referencer with lowest rootid
+	 */
+	if (is_fstree(root->objectid) && !should_check(root, node))
+		return 0;
+
+	/* Update bytes accounting */
+	total_btree_bytes += node->len;
+	if (fs_root_objectid(btrfs_header_owner(node)))
+		total_fs_tree_bytes += node->len;
+	if (btrfs_header_owner(node) == BTRFS_EXTENT_TREE_OBJECTID)
+		total_extent_tree_bytes += node->len;
+	if (!found_old_backref &&
+	    btrfs_header_owner(node) == BTRFS_TREE_RELOC_OBJECTID &&
+	    btrfs_header_backref_rev(node) == BTRFS_MIXED_BACKREF_REV &&
+	    !btrfs_header_flag(node, BTRFS_HEADER_FLAG_RELOC))
+		found_old_backref = 1;
+
+	/* pre-order tranversal, check itself first */
+	level = btrfs_header_level(node);
+	ret = check_tree_block_ref(root, node, btrfs_header_bytenr(node),
+				   btrfs_header_level(node),
+				   btrfs_header_owner(node));
+	err |= -ret;
+	if (err)
+		error("check %s failed root %llu bytenr %llu level %d, force continue check",
+		      level ? "node":"leaf", root->objectid,
+		      btrfs_header_bytenr(node), btrfs_header_level(node));
+
+	if (!level) {
+		btree_space_waste += btrfs_leaf_free_space(root, node);
+		ret = check_leaf_items(root, node);
+		err |= -ret;
+		return -err;
+	}
+
+	nr = btrfs_header_nritems(node);
+	btree_space_waste += (BTRFS_NODEPTRS_PER_BLOCK(root) - nr) *
+		sizeof(struct btrfs_key_ptr);
+
+	/* Then check all its children */
+	for (i = 0; i < nr; i++) {
+		u64 blocknr = btrfs_node_blockptr(node, i);
+
+		/*
+		 * As a btrfs tree has most 8 levels(0~7), so it's quite
+		 * safe to call the function itself.
+		 */
+		eb = read_tree_block(root, blocknr, root->nodesize, 0);
+		if (extent_buffer_uptodate(eb)) {
+			ret = traversal_tree_block(root, eb);
+			err |= -ret;
+		}
+		free_extent_buffer(eb);
+	}
+
+	return -err;
+}
+
 static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, int overwrite)
 {
-- 
2.8.0



