Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24555 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750969AbdEBHgT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 May 2017 03:36:19 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id C7DF047E6344
        for <linux-btrfs@vger.kernel.org>; Tue,  2 May 2017 15:36:12 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Fix fuzz-test for bko-161821.raw.txt
Date: Tue, 2 May 2017 15:36:09 +0800
Message-ID: <20170502073609.23559-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fuzzed image bko-161821.raw cause btrfs check to get segmentation fault.

The function check_owner_ref attempts to access a non-exist quota tree
when dealing with extent_item [4198400 4096] in the corrupted filesystem.

The function btrfs_new_fs_info always allocate memory for
fs_info->quota_root regardless of whether quota_tree exists or not.
Additionally, the function btrfs_read_fs_root will directly return
fs_info->quota_root if location->objectid == BTRFS_QUOTA_TREE_OBJECTID.

This patch does the following things:
1. Do extra check and return ENOENT if quota tree does not exist in the
function btrfs_read_fs_root.
2. Free useless fs_info->quota_root in the function btrfs_setup_all_roots
to reduce confusion.
3. free_extent_buffer even if check_child_node failed in the function
walk_down_tree.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 cmds-check.c |  1 +
 disk-io.c    | 13 ++++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 17b7efbf..4c7532d0 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2185,6 +2185,7 @@ static int walk_down_tree(struct btrfs_root *root, struct btrfs_path *path,
 
 		ret = check_child_node(cur, path->slots[*level], next);
 		if (ret) {
+			free_extent_buffer(next);
 			err = ret;
 			goto out;
 		}
diff --git a/disk-io.c b/disk-io.c
index 985c4a9f..6aa6d98a 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -815,7 +815,8 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 	if (location->objectid == BTRFS_CSUM_TREE_OBJECTID)
 		return fs_info->csum_root;
 	if (location->objectid == BTRFS_QUOTA_TREE_OBJECTID)
-		return fs_info->quota_root;
+		return fs_info->quota_enabled ? fs_info->quota_root :
+				ERR_PTR(-ENOENT);
 
 	BUG_ON(location->objectid == BTRFS_TREE_RELOC_OBJECTID ||
 	       location->offset != (u64)-1);
@@ -837,12 +838,14 @@ struct btrfs_root *btrfs_read_fs_root(struct btrfs_fs_info *fs_info,
 
 void btrfs_free_fs_info(struct btrfs_fs_info *fs_info)
 {
+	if (fs_info->quota_root)
+		free(fs_info->quota_root);
+
 	free(fs_info->tree_root);
 	free(fs_info->extent_root);
 	free(fs_info->chunk_root);
 	free(fs_info->dev_root);
 	free(fs_info->csum_root);
-	free(fs_info->quota_root);
 	free(fs_info->free_space_root);
 	free(fs_info->super_copy);
 	free(fs_info->log_root_tree);
@@ -1057,8 +1060,12 @@ int btrfs_setup_all_roots(struct btrfs_fs_info *fs_info, u64 root_tree_bytenr,
 
 	ret = find_and_setup_root(root, fs_info, BTRFS_QUOTA_TREE_OBJECTID,
 				  fs_info->quota_root);
-	if (ret == 0)
+	if (ret) {
+		free(fs_info->quota_root);
+		fs_info->quota_root = NULL;
+	} else {
 		fs_info->quota_enabled = 1;
+	}
 
 	if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE)) {
 		ret = find_and_setup_root(root, fs_info, BTRFS_FREE_SPACE_TREE_OBJECTID,
-- 
2.12.2



