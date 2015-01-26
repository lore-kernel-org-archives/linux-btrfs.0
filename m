Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64275 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752622AbbAZFxH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Jan 2015 00:53:07 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t0Q5qOUq013301
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2015 13:52:24 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Make csum tree rebuild works with extent tree rebuild.
Date: Mon, 26 Jan 2015 13:53:02 +0800
Message-ID: <1422251582-23575-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this patch, csum tree rebuild will not work with extent tree
rebuild, since extent tree rebuild will only build up basic block
groups, but csum tree rebuild needs data extents to rebuild.
So if one use btrfsck with --init-csum-tree and --init-extent-tree, csum
tree will be empty and tons of "missing csum" error will be outputted.

This patch allows csum tree rebuild get its data from fs/subvol trees
using regular file extents(which is also the only one using csum tree
currently)

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 158 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 155 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 45d3468..bafa743 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -8534,8 +8534,141 @@ static int populate_csum(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static int fill_csum_tree(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *csum_root)
+static int fill_csum_tree_from_one_fs(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *csum_root,
+				      struct btrfs_root *cur_root)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct extent_buffer *node;
+	struct btrfs_file_extent_item *fi;
+	char *buf = NULL;
+	u64 start = 0;
+	u64 len = 0;
+	int slot = 0;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+	buf = malloc(cur_root->fs_info->csum_root->sectorsize);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	key.objectid = 0;
+	key.offset = 0;
+	key.type = 0;
+
+	ret = btrfs_search_slot(NULL, cur_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	/* Iterate all regular file extents and fill its csum */
+	while (1) {
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
+
+		if (key.type != BTRFS_EXTENT_DATA_KEY)
+			goto next;
+		node = path->nodes[0];
+		slot = path->slots[0];
+		fi = btrfs_item_ptr(node, slot, struct btrfs_file_extent_item);
+		if (btrfs_file_extent_type(node, fi) != BTRFS_FILE_EXTENT_REG)
+			goto next;
+		start = btrfs_file_extent_disk_bytenr(node, fi);
+		len = btrfs_file_extent_disk_num_bytes(node, fi);
+
+		ret = populate_csum(trans, csum_root, buf, start, len);
+		if (ret == -EEXIST)
+			ret = 0;
+		if (ret < 0)
+			goto out;
+next:
+		/*
+		 * TODO: if next leaf is corrupted, jump to nearest next valid
+		 * leaf.
+		 */
+		ret = btrfs_next_item(cur_root, path);
+		if (ret < 0)
+			goto out;
+		if (ret > 0) {
+			ret = 0;
+			goto out;
+		}
+	}
+
+out:
+	btrfs_free_path(path);
+	free(buf);
+	return ret;
+}
+
+static int fill_csum_tree_from_fs(struct btrfs_trans_handle *trans,
+				  struct btrfs_root *csum_root)
+{
+	struct btrfs_fs_info *fs_info = csum_root->fs_info;
+	struct btrfs_path *path;
+	struct btrfs_root *tree_root = fs_info->tree_root;
+	struct btrfs_root *cur_root;
+	struct extent_buffer *node;
+	struct btrfs_key key;
+	int slot = 0;
+	int ret = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = BTRFS_FS_TREE_OBJECTID;
+	key.offset = 0;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+
+	ret = btrfs_search_slot(NULL, tree_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	if (ret > 0) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	while (1) {
+		node = path->nodes[0];
+		slot = path->slots[0];
+		btrfs_item_key_to_cpu(node, &key, slot);
+		if (key.objectid > BTRFS_LAST_FREE_OBJECTID)
+			goto out;
+		if (key.type != BTRFS_ROOT_ITEM_KEY)
+			goto next;
+		if (!is_fstree(key.objectid))
+			goto next;
+		key.offset = (u64)-1;
+
+		cur_root = btrfs_read_fs_root(fs_info, &key);
+		if (IS_ERR(cur_root) || !cur_root) {
+			fprintf(stderr, "Fail to read fs/subvol tree: %lld\n",
+				key.objectid);
+			goto out;
+		}
+		ret = fill_csum_tree_from_one_fs(trans, csum_root, cur_root);
+		if (ret < 0)
+			goto out;
+next:
+		ret = btrfs_next_item(tree_root, path);
+		if (ret > 0) {
+			ret = 0;
+			goto out;
+		}
+		if (ret < 0)
+			goto out;
+	}
+
+out:
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int fill_csum_tree_from_extent(struct btrfs_trans_handle *trans,
+				      struct btrfs_root *csum_root)
 {
 	struct btrfs_root *extent_root = csum_root->fs_info->extent_root;
 	struct btrfs_path *path;
@@ -8603,6 +8736,24 @@ static int fill_csum_tree(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+/*
+ * Recalculate the csum and put it into the csum tree.
+ *
+ * Extent tree init will wipe out all the extent info, so
+ * in that case, we can't depend on extent tree, but use fs tree.
+ * If search_fs_tree is set, we will use fs/subvol trees to
+ * init the csum tree.
+ */
+static int fill_csum_tree(struct btrfs_trans_handle *trans,
+			  struct btrfs_root *csum_root,
+			  int search_fs_tree)
+{
+	if (search_fs_tree)
+		return fill_csum_tree_from_fs(trans, csum_root);
+	else
+		return fill_csum_tree_from_extent(trans, csum_root);
+}
+
 struct root_item_info {
 	/* level of the root */
 	u8 level;
@@ -9194,7 +9345,8 @@ again:
 				goto close_out;
 			}
 
-			ret = fill_csum_tree(trans, info->csum_root);
+			ret = fill_csum_tree(trans, info->csum_root,
+					     init_extent_tree);
 			if (ret) {
 				fprintf(stderr, "crc refilling failed\n");
 				return -EIO;
-- 
2.2.2

