Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64755 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753191AbbAMCE5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Jan 2015 21:04:57 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0D24IvX025918
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Jan 2015 10:04:18 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/4] btrfs-progs: Remove all csum extents for init_csum
Date: Tue, 13 Jan 2015 10:04:47 +0800
Message-ID: <1421114687-6084-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1421114687-6084-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1421114687-6084-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The original csum tree init codes will only rebuild the csum tree, but
don't remove the tree block extents in extent tree, and let extent tree
repair to repair all the mismatch extents.
This is OK if calling --init-csum manually, but it's confusing if
csum tree build it executed automatically, and csum tree corruption will
be reported twice.

This patch removes the csum extents in csum tree rebuild routine, which
will make the check result clean after automatically csum tree rebuild.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c  |   5 +++
 ctree.h       |   2 ++
 extent-tree.c | 108 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 115 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 7d8d9d1..45d3468 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9182,6 +9182,11 @@ again:
 
 		if (init_csum_tree) {
 			fprintf(stderr, "Reinit crc root\n");
+			ret = remove_csum_extents(trans, info->extent_root);
+			if (ret < 0) {
+				fprintf(stderr, "crc extents removing failed\n");
+				goto close_out;
+			}
 			ret = btrfs_fsck_reinit_root(trans, info->csum_root, 0);
 			if (ret) {
 				fprintf(stderr, "crc root initialization failed\n");
diff --git a/ctree.h b/ctree.h
index 48fa492..a088554 100644
--- a/ctree.h
+++ b/ctree.h
@@ -2249,6 +2249,8 @@ int btrfs_record_file_extent(struct btrfs_trans_handle *trans,
 			      struct btrfs_inode_item *inode,
 			      u64 file_pos, u64 disk_bytenr,
 			      u64 num_bytes);
+int remove_csum_extents(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root);
 /* ctree.c */
 int btrfs_comp_cpu_keys(struct btrfs_key *k1, struct btrfs_key *k2);
 int btrfs_del_ptr(struct btrfs_trans_handle *trans, struct btrfs_root *root,
diff --git a/extent-tree.c b/extent-tree.c
index 080f30d..d614e7e 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3555,3 +3555,111 @@ fail:
 	btrfs_release_path(&path);
 	return ret;
 }
+
+/*
+ * Remove all the extents belong to csum tree and update blockgroup info
+ *
+ * Only used in csum tree rebuilding. Since the whole csum tree root
+ * will be a new one, no backref needs to be updated
+ */
+int remove_csum_extents(struct btrfs_trans_handle *trans,
+			struct btrfs_root *root)
+{
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	struct btrfs_extent_item *ei;
+	int skinny_metadata = btrfs_fs_incompat(root->fs_info,
+			BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
+	int ret = 0;
+
+	/* Extent tree root not exists, no need to remove csum extents */
+	if (!root)
+		return 0;
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = 0;
+	key.type = 0;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
+	if (ret < 0)
+		goto out;
+	while (1) {
+		struct extent_buffer *node;
+		int slot;
+
+		slot = path->slots[0];
+		node = path->nodes[0];
+		
+		btrfs_item_key_to_cpu(node, &key, slot);
+		if (key.type != BTRFS_METADATA_ITEM_KEY &&
+		    key.type != BTRFS_EXTENT_ITEM_KEY)
+			goto next;
+		ei = btrfs_item_ptr(node, slot,
+				    struct btrfs_extent_item);
+		/*
+		 * refs to csum tree extent must be 1
+		 * if not 1, it must be a fs tree extent.
+		 */
+		if (btrfs_extent_refs(node, ei) != 1)
+			goto next;
+
+		if (skinny_metadata) {
+			struct btrfs_extent_inline_ref *iref;
+
+			if (key.type != BTRFS_METADATA_ITEM_KEY)
+				goto next;
+
+			iref = (struct btrfs_extent_inline_ref *)(ei + 1);
+
+			if (btrfs_extent_inline_ref_offset(node, iref) !=
+			    BTRFS_CSUM_TREE_OBJECTID)
+				goto next;
+		} else {
+			struct btrfs_tree_block_info *tref;
+			struct btrfs_disk_key disk_key;
+			struct btrfs_key tree_key;
+
+			if (!(btrfs_extent_flags(node, ei) &
+			      BTRFS_EXTENT_FLAG_TREE_BLOCK))
+				goto next;
+			tref = (struct btrfs_tree_block_info *)(ei + 1);
+			btrfs_tree_block_key(node, tref, &disk_key);
+			btrfs_disk_key_to_cpu(&tree_key, &disk_key);
+			if (tree_key.type != BTRFS_EXTENT_CSUM_KEY)
+				goto next;
+		}
+		/* Now we are sure it's a extent of csum tree */
+		ret = btrfs_del_item(trans, root, path);
+		if (ret < 0)
+			goto out;
+
+		ret = update_block_group(trans, root, key.objectid,
+					 root->leafsize, 0, 1);
+		if (ret < 0)
+			goto out;
+
+		/* We are at the next block, check slot and continue */
+		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret > 0) {
+				ret = 0;
+				goto out;
+			}
+		}
+		continue;
+next:
+		ret = btrfs_next_item(root, path);
+		if (ret < 0)
+			goto out;
+		if (ret > 0) {
+			ret = 0;
+			goto out;
+		}
+	}
+out:
+	btrfs_free_path(path);
+	return ret;
+}
-- 
2.2.1

