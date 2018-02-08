Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:17766 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752223AbeBHDXa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Feb 2018 22:23:30 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id B0AF948AE763
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Feb 2018 11:23:22 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v4 17/18] btrfs-progs: lowmem check: end of removing parameters @trans in lowmem
Date: Thu, 8 Feb 2018 11:27:36 +0800
Message-ID: <20180208032737.31561-18-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
References: <20180208032737.31561-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove @trans in check_chunks_and_extents().

This patch let lowmem repair work again.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 40a179f75319..4aad69fc9eb1 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4872,7 +4872,6 @@ out:
  */
 int check_chunks_and_extents_lowmem(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_path path;
 	struct btrfs_key old_key;
 	struct btrfs_key key;
@@ -4884,14 +4883,6 @@ int check_chunks_and_extents_lowmem(struct btrfs_fs_info *fs_info)
 
 	root = fs_info->fs_root;
 
-	if (repair) {
-		trans = btrfs_start_transaction(fs_info->extent_root, 1);
-		if (IS_ERR(trans)) {
-			error("failed to start transaction before check");
-			return PTR_ERR(trans);
-		}
-	}
-
 	root1 = root->fs_info->chunk_root;
 	ret = check_btrfs_root(root1, 0, 1);
 	err |= ret;
@@ -4961,10 +4952,6 @@ out:
 			err &= ~BG_ACCOUNTING_ERROR;
 	}
 
-	if (trans)
-		btrfs_commit_transaction(trans, root->fs_info->extent_root);
-
 	btrfs_release_path(&path);
-
 	return err;
 }
-- 
2.16.1



