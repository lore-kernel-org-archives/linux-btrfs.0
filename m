Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:42400 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933111AbeEHIYe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 04:24:34 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>, <dsterba@suse.cz>
Subject: [PATCH v5 11/16] btrfs-progs: lowmem: remove parameter @trans of check_leaf_items()
Date: Tue, 8 May 2018 16:30:07 +0800
Message-ID: <20180508083012.12090-12-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
References: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch removes parameter @trans of check_leaf_items().

Note: This patch and next patches cause error in lowmem repair like:
"Error: Commit_root already set when starting transaction".
Such error will disappear after removing @trans finished.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 0e3bca76d901..ed7b125208a1 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4200,8 +4200,7 @@ out:
 /*
  * Main entry function to check known items and update related accounting info
  */
-static int check_leaf_items(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, struct btrfs_path *path,
+static int check_leaf_items(struct btrfs_root *root, struct btrfs_path *path,
 			    struct node_refs *nrefs, int account_bytes)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -4397,7 +4396,7 @@ static int walk_down_tree(struct btrfs_trans_handle *trans,
 				ret = process_one_leaf(root, path, nrefs,
 						       level, ext_ref);
 			else
-				ret = check_leaf_items(trans, root, path,
+				ret = check_leaf_items(root, path,
 					       nrefs, account_file_data);
 			err |= ret;
 			break;
-- 
2.17.0



