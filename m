Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31549 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753631AbbBDHUH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 02:20:07 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t147IHB5020236
	for <linux-btrfs@vger.kernel.org>; Wed, 4 Feb 2015 15:18:17 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/5] btrfs-progs: Introduce new function reset_(one_root/roots)_csum() to reset one/all tree's csum in tree root.
Date: Wed, 4 Feb 2015 15:16:50 +0800
Message-ID: <1423034213-14018-7-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1423034213-14018-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1423034213-14018-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

New function reset_one_root_csum() will reset all csum in one root.
And reset_roots_csum() will reset all csum of all trees in tree root.
which provides the basis for later dangerous options.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 157 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 157 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index e4b4f4a..2cdd3d9 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9193,6 +9193,163 @@ out:
 	return ret;
 }
 
+static int reset_one_root_csum(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root)
+{
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct extent_buffer *node;
+	u32 sectorsize = root->sectorsize;
+	int max_level = btrfs_root_level(&root->root_item);
+	int slot;
+	int i;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	path->reada = 0;
+
+	/* Iterate all levels except level 0 */
+	for (i = 0; i < max_level; i++) {
+		int cur_level = max_level - i;
+
+		path->lowest_level = cur_level;
+		key.offset = 0;
+		key.objectid = 0;
+		key.type = 0;
+
+		ret = btrfs_search_slot(trans, root, &key, path, 1, 1);
+		if (ret < 0)
+			goto out;
+
+		/* Iterate all node slots in this level */
+		while (1) {
+			u64 bytenr;
+
+			node = path->nodes[0];
+			slot = path->slots[0];
+			bytenr = btrfs_node_blockptr(node, slot);
+
+			if (bytenr != round_down(bytenr, sectorsize)) {
+				bytenr = round_down(bytenr, sectorsize);
+				btrfs_set_node_blockptr(node, slot, bytenr);
+				btrfs_mark_buffer_dirty(node);
+			}
+			ret = reset_tree_block_csum(fs_info, bytenr,
+						    root->nodesize);
+			if (ret < 0) {
+				fprintf(stderr,
+					"Fail to reset csum for tree block at %llu\n",
+					bytenr);
+				goto next_slot;
+			}
+next_slot:
+			ret = btrfs_next_slot(root, path, cur_level);
+			/*
+			 * Error should not happen since higher level iteration
+			 * has already reset the csum of this level.
+			 * Either way, goto next level should be OK.
+			 */
+			if (ret)
+				break;
+		}
+		btrfs_release_path(path);
+	}
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int reset_roots_csum(struct btrfs_trans_handle *trans,
+			    struct btrfs_root *tree_root)
+{
+	struct btrfs_fs_info *fs_info = tree_root->fs_info;
+	struct btrfs_key key;
+	struct btrfs_path *path;
+	struct btrfs_root_item *ri;
+	struct btrfs_root *root;
+	struct extent_buffer *node;
+	u32 nodesize = tree_root->nodesize;
+	u32 sectorsize = tree_root->sectorsize;
+	u64 bytenr;
+	int slot;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = 0;
+	key.offset = 0;
+	key.type = 0;
+
+	ret = btrfs_search_slot(trans, tree_root, &key, path, 1, 0);
+	if (ret < 0)
+		goto out;
+	while (1) {
+		slot = path->slots[0];
+		node = path->nodes[0];
+		btrfs_item_key_to_cpu(node, &key, slot);
+		if (key.type != BTRFS_ROOT_ITEM_KEY)
+			goto next;
+
+		/*
+		 * skip tree reloc tree, it's not support by
+		 * btrfs_read_fs_root() yet.
+		 */
+		if (key.objectid == BTRFS_TREE_RELOC_OBJECTID)
+			goto next;
+
+		ri = btrfs_item_ptr(node, slot, struct btrfs_root_item);
+		bytenr = btrfs_disk_root_bytenr(node, ri);
+
+		/*
+		 * Check if the bytenr is aligned.
+		 * If the error bit is only in the low 12bits, no real damage
+		 * will happen since we will align it.
+		 */
+		if (round_down(bytenr, sectorsize) != bytenr) {
+			bytenr = round_down(bytenr, sectorsize);
+			btrfs_set_disk_root_bytenr(node, ri, bytenr);
+			btrfs_mark_buffer_dirty(node);
+		}
+
+		ret = reset_tree_block_csum(fs_info, bytenr, nodesize);
+		if (ret < 0) {
+			fprintf(stderr,
+				"Failed to reset root for tree %llu, skip it\n",
+				key.objectid);
+			goto next;
+		}
+		key.offset = (u64)-1;
+		root = btrfs_read_fs_root(fs_info, &key);
+		if (!root || IS_ERR(root) ||
+		    !extent_buffer_uptodate(root->node)) {
+			fprintf(stderr,
+				"Root of tree %lld is still corrupted, skip it\n",
+				key.objectid);
+			goto next;
+		}
+		ret = reset_one_root_csum(trans, root);
+		if (ret < 0)
+			goto next;
+
+next:
+		ret = btrfs_next_item(tree_root, path);
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
+
 const char * const cmd_check_usage[] = {
 	"btrfs check [options] <device>",
 	"Check an unmounted btrfs filesystem.",
-- 
2.2.2

