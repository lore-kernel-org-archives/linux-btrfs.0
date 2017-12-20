Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:17266 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754429AbdLTExx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 23:53:53 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>, <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v2 17/17] btrfs-progs: lowmem check: end of removing parameters @trans in lowmem
Date: Wed, 20 Dec 2017 12:57:31 +0800
Message-ID: <20171220045731.19343-18-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
References: <20171220045731.19343-1-suy.fnst@cn.fujitsu.com>
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
index b51fcfd8ffdb..3f409c967f5e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -13710,7 +13710,6 @@ static int repair_block_accounting(struct btrfs_fs_info *fs_info)
  */
 static int check_chunks_and_extents_v2(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_path path;
 	struct btrfs_key old_key;
 	struct btrfs_key key;
@@ -13722,14 +13721,6 @@ static int check_chunks_and_extents_v2(struct btrfs_fs_info *fs_info)
 
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
@@ -13798,9 +13789,6 @@ out:
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



