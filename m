Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49797 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaCJKlf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 06:41:35 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2AAfK4h002516
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Mar 2014 18:41:21 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: fsck: disable --init-extent-tree option when using snapshots
Date: Mon, 10 Mar 2014 18:39:21 +0800
Message-Id: <1394447961-27981-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We haven't supported to rebuild extent tree if there are any *FULL BACKREF*
with broken filesystem, disable this option when detecting snapshots.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index d1cafe1..ddee897 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6143,6 +6143,56 @@ static int reset_block_groups(struct btrfs_fs_info *fs_info)
 	return 0;
 }
 
+static int is_snapshot_exist(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_root *root = fs_info->tree_root;
+	struct btrfs_path *path;
+	struct extent_buffer *leaf;
+	struct btrfs_key key;
+	int ret;
+	int found = 0;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	key.objectid = BTRFS_FIRST_FREE_OBJECTID;
+	key.type = BTRFS_ROOT_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+
+	while (1) {
+		if (path->slots[0] >= btrfs_header_nritems(path->nodes[0])) {
+			ret = btrfs_next_leaf(root, path);
+			if (ret)
+				goto out;
+		}
+		leaf = path->nodes[0];
+		btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
+
+		if (key.type != BTRFS_ROOT_ITEM_KEY ||
+		    key.objectid < BTRFS_FIRST_FREE_OBJECTID) {
+			path->slots[0]++;
+			continue;
+		}
+		if (key.offset > 0) {
+			found = 1;
+			break;
+		}
+		path->slots[0]++;
+	}
+out:
+	btrfs_free_path(path);
+	if (found)
+		return 1;
+	else if (ret >= 0)
+		return 0;
+	return ret;
+}
+
 static int reset_balance(struct btrfs_trans_handle *trans,
 			 struct btrfs_fs_info *fs_info)
 {
@@ -6537,6 +6587,18 @@ int cmd_check(int argc, char **argv)
 		ret = -EIO;
 		goto close_out;
 	}
+	if (init_extent_tree) {
+		ret = is_snapshot_exist(info);
+		if (ret < 0) {
+			fprintf(stderr, "ERROR: fail to check if there are snapshots in btrfs filesystem\n");
+			ret = 1;
+			goto close_out;
+		} else if (ret) {
+			fprintf(stderr, "Snapshots detected, unable to rebuild extent tree for such case.\n");
+			ret = 1;
+			goto close_out;
+		}
+	}
 
 	if (init_extent_tree || init_csum_tree) {
 		struct btrfs_trans_handle *trans;
-- 
1.9.0

