Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:39237 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933168AbeEHIYm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 04:24:42 -0400
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>, <dsterba@suse.cz>
Subject: [PATCH v5 15/16] btrfs-progs: lowmem: end of removing parameters @trans in lowmem
Date: Tue, 8 May 2018 16:30:11 +0800
Message-ID: <20180508083012.12090-16-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
References: <20180508083012.12090-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove @trans in check_chunks_and_extents_lowmem().

After this patch, lowmem repair works again.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 3e81fc16e564..24fb8f09a1f0 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4933,7 +4933,6 @@ out:
  */
 int check_chunks_and_extents_lowmem(struct btrfs_fs_info *fs_info)
 {
-	struct btrfs_trans_handle *trans = NULL;
 	struct btrfs_path path;
 	struct btrfs_key old_key;
 	struct btrfs_key key;
@@ -4945,14 +4944,6 @@ int check_chunks_and_extents_lowmem(struct btrfs_fs_info *fs_info)
 
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
@@ -5022,10 +5013,6 @@ out:
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
2.17.0



