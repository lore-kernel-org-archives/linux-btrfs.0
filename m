Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:40618 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752021AbeBHDXV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 22:23:21 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id AAE5E48AE76B
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 11:23:15 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v4 13/18] btrfs-progs: lowmem check: remove parameter @trans of check_leaf_items()
Date: Thu, 8 Feb 2018 11:27:32 +0800
Message-ID: <20180208032737.31561-14-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
References: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
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
 check/mode-lowmem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 443fa513a13e..a7660a25b844 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4139,8 +4139,7 @@ out:
 /*
  * Main entry function to check known items and update related accounting info
  */
-static int check_leaf_items(struct btrfs_trans_handle *trans,
-			    struct btrfs_root *root, struct btrfs_path *path,
+static int check_leaf_items(struct btrfs_root *root, struct btrfs_path *path,
 			    struct node_refs *nrefs, int account_bytes)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -4336,7 +4335,7 @@ static int walk_down_tree(struct btrfs_trans_handle *trans,
 				ret = process_one_leaf(root, path, nrefs,
 						       level, ext_ref);
 			else
-				ret = check_leaf_items(trans, root, path,
+				ret = check_leaf_items(root, path,
 					       nrefs, account_file_data);
 			err |= ret;
 			break;
-- 
2.16.1



