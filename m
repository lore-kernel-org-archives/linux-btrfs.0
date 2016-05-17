Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18565 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbcEQJjM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 05:39:12 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jbacik@fb.com
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [RFC PATCH v2.1 04/16] btrfs-progs: fsck: Introduce function to check referencer of a backref
Date: Tue, 17 May 2016 17:38:38 +0800
Message-Id: <1463477930-3925-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce a new function check_tree_block_backref() to check if a
backref points to correct referencer.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 95 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index c301ea1..443b337 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -322,6 +322,8 @@ struct root_item_info {
 #define BACKREF_MISSING		(1 << 0) /* Backref missing in extent tree */
 #define BACKREF_MISMATCH	(1 << 1) /* Backref exists but mismatch */
 #define BYTES_UNALIGNED		(1 << 2) /* Some bytes are not aligned */
+#define REFERENCER_MISSING	(1 << 3) /* Referencer not found */
+#define REFERENCER_MISMATCH	(1 << 4) /* Referenceer found but mismatch */
 
 static void *print_status_check(void *p)
 {
@@ -8791,6 +8793,99 @@ release_out:
 	return ret;
 }
 
+/*
+ * Check if a tree block backref is valid (points to valid tree block)
+ * if level == -1, level will be resolved
+ * Return >0 for any error found and output error message
+ */
+static int check_tree_block_backref(struct btrfs_fs_info *fs_info, u64 root_id,
+				    u64 bytenr, int level)
+{
+	struct btrfs_root *root;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	struct extent_buffer *eb;
+	struct extent_buffer *node;
+	u32 nodesize = btrfs_super_nodesize(fs_info->super_copy);
+	int err = 0;
+	int ret;
+
+	/* Query level for level == -1 special case */
+	if (level == -1)
+		level = query_tree_block_level(fs_info, bytenr);
+	if (level < 0) {
+		err |= REFERENCER_MISSING;
+		goto out;
+	}
+
+	key.objectid = root_id;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	root = btrfs_read_fs_root(fs_info, &key);
+	if (IS_ERR(root)) {
+		err |= REFERENCER_MISSING;
+		goto out;
+	}
+
+	/* Read out the tree block to get item/node key */
+	eb = read_tree_block(root, bytenr, root->nodesize, 0);
+	if (!extent_buffer_uptodate(eb)) {
+		err |= REFERENCER_MISSING;
+		free_extent_buffer(eb);
+		goto out;
+	}
+
+	/* Empty tree, no need to check key */
+	if (!btrfs_header_nritems(eb) && !level) {
+		free_extent_buffer(eb);
+		goto out;
+	}
+
+	if (level)
+		btrfs_node_key_to_cpu(eb, &key, 0);
+	else
+		btrfs_item_key_to_cpu(eb, &key, 0);
+
+	free_extent_buffer(eb);
+
+	btrfs_init_path(&path);
+	/* Search with the first key, to ensure we can reach it */
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret) {
+		err |= REFERENCER_MISSING;
+		goto release_out;
+	}
+
+	node = path.nodes[level];
+	if (btrfs_header_bytenr(node) != bytenr) {
+		error("Extent [%llu %d] referencer bytenr mismatch, wanted: %llu, have: %llu",
+		      bytenr, nodesize, bytenr,
+		      btrfs_header_bytenr(node));
+		err |= REFERENCER_MISMATCH;
+	}
+	if (btrfs_header_level(node) != level) {
+		error("Extent [%llu %d] referencer level mismatch, wanted: %d, have: %d",
+		      bytenr, nodesize, level,
+		      btrfs_header_level(node));
+		err |= REFERENCER_MISMATCH;
+	}
+
+release_out:
+	btrfs_release_path(&path);
+out:
+	if (err & REFERENCER_MISSING) {
+		if (level < 0)
+			error("Extent [%llu %d] lost referencer(owner: %llu)",
+			       bytenr, nodesize, root_id);
+		else
+			error("Extent [%llu %d] lost referencer(owner: %llu, level: %u)",
+			       bytenr, nodesize, root_id, level);
+	}
+
+	return err;
+}
+
 static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, int overwrite)
 {
-- 
2.8.2



