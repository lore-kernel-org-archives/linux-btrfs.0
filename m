Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:22396 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932107AbeAKHba (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 02:31:30 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id DA30648AEA11
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jan 2018 15:31:26 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 17/17] btrfs-progs: lowmem check: end of removing parameters @trans in lowmem
Date: Thu, 11 Jan 2018 15:35:11 +0800
Message-ID: <20180111073511.25288-18-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
References: <20180111073511.25288-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove @trans in check_chunks_and_extents.

After this patch, Lowmem repair should work again.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 4d6245fa909b..4884d78681ab 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -13804,7 +13804,6 @@ static int repair_block_accounting(struct btrfs_fs_info *fs_info)
  */
 static int check_chunks_and_extents_v2(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_path path;
 	struct btrfs_key old_key;
 	struct btrfs_key key;
@@ -13816,14 +13815,6 @@ static int check_chunks_and_extents_v2(struct btrfs_fs_info *fs_info)
 
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
@@ -13892,9 +13883,6 @@ out:
 			err &= ~BG_ACCOUNTING_ERROR;
 	}
 
-	if (trans)
-		btrfs_commit_transaction(trans, root->fs_info->extent_root);
-
 	btrfs_release_path(&path);
 	return err;
 }
-- 
2.15.1



