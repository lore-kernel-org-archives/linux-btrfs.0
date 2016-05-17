Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18565 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbcEQJjD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 05:39:03 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jbacik@fb.com
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [RFC PATCH v2.1 03/16] btrfs-progs: fsck: Introduce function to query tree block level
Date: Tue, 17 May 2016 17:38:37 +0800
Message-Id: <1463477930-3925-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce function query_tree_block_level() to resolve tree block level
by the following method:
1) tree block backref level
2) tree block header level

And only when header level == backref level, and transid matches, it will
return the tree block level.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 66437f4..c301ea1 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -8715,6 +8715,82 @@ error:
 	return err;
 }
 
+/*
+ * Get real tree block level for case like shared block
+ * Return >= 0 as tree level
+ * Return <0 for error
+ */
+static int query_tree_block_level(struct btrfs_fs_info *fs_info, u64 bytenr)
+{
+	struct extent_buffer *eb;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct btrfs_extent_item *ei;
+	u64 flags;
+	u64 transid;
+	u32 nodesize = btrfs_super_nodesize(fs_info->super_copy);
+	u8 backref_level;
+	u8 header_level;
+	int ret;
+
+	/* Search extent tree for extent generation and level */
+	key.objectid = bytenr;
+	key.type = BTRFS_METADATA_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(NULL, fs_info->extent_root, &key, &path, 0, 0);
+	if (ret < 0)
+		goto release_out;
+	ret = btrfs_previous_extent_item(fs_info->extent_root, &path, bytenr);
+	if (ret < 0)
+		goto release_out;
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto release_out;
+	}
+
+	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+	ei = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			    struct btrfs_extent_item);
+	flags = btrfs_extent_flags(path.nodes[0], ei);
+	if (!(flags & BTRFS_EXTENT_FLAG_TREE_BLOCK)) {
+		ret = -ENOENT;
+		goto release_out;
+	}
+
+	/* Get transid for later read_tree_block() check */
+	transid = btrfs_extent_generation(path.nodes[0], ei);
+
+	/* Get backref level as one source */
+	if (key.type == BTRFS_METADATA_ITEM_KEY) {
+		backref_level = key.offset;
+	} else {
+		struct btrfs_tree_block_info *info;
+
+		info = (struct btrfs_tree_block_info *)(ei + 1);
+		backref_level = btrfs_tree_block_level(path.nodes[0], info);
+	}
+	btrfs_release_path(&path);
+
+	/* Get level from tree block as alternative source */
+	eb = read_tree_block_fs_info(fs_info, bytenr, nodesize, transid);
+	if (!extent_buffer_uptodate(eb)) {
+		free_extent_buffer(eb);
+		return -EIO;
+	}
+	header_level = btrfs_header_level(eb);
+	free_extent_buffer(eb);
+
+	if (header_level != backref_level)
+		return -EIO;
+	return header_level;
+
+release_out:
+	btrfs_release_path(&path);
+	return ret;
+}
+
 static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, int overwrite)
 {
-- 
2.8.2



