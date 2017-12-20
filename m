Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:24084 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754485AbdLTExu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 23:53:50 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>, <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v2 13/17] btrfs-progs: lowmem check: remove parameter @trans of check_leaf_items()
Date: Wed, 20 Dec 2017 12:57:27 +0800
Message-ID: <20171220045731.19343-14-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch removes parameter @trans of check_leaf_items().

Note: This patch and next patches cause error in lowmem repair like:
"Error: Commit_root already set when starting transaction".
This error will disappear after removing @trans finished.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 2c77afe25edc..a601ffdc5cd9 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2680,8 +2680,7 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
 static int check_tree_block_ref(struct btrfs_root *root,
 				struct extent_buffer *eb, u64 bytenr,
 				int level, u64 owner, struct node_refs *nrefs);
-static int check_leaf_items(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, struct btrfs_path *path,
+static int check_leaf_items(struct btrfs_root *root, struct btrfs_path *path,
 			    struct node_refs *nrefs, int account_bytes);
 
 /*
@@ -2770,8 +2769,8 @@ static int walk_down_tree_v2(struct btrfs_trans_handle *trans,
 				ret = process_one_leaf_v2(root, path, nrefs,
 							  level, ext_ref);
 			else
-				ret = check_leaf_items(trans, root, path,
-					       nrefs, account_file_data);
+				ret = check_leaf_items(root, path, nrefs,
+						       account_file_data);
 			err |= ret;
 			break;
 		} else {
@@ -13468,8 +13467,7 @@ out:
 /*
  * Main entry function to check known items and update related accounting info
  */
-static int check_leaf_items(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, struct btrfs_path *path,
+static int check_leaf_items(struct btrfs_root *root, struct btrfs_path *path,
 			    struct node_refs *nrefs, int account_bytes)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
-- 
2.15.1



