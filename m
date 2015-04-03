Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26665 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751221AbbDCMNl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Apr 2015 08:13:41 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t33CCYMP020601
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Apr 2015 20:12:34 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/9] btrfs: fix condition of commit transaction
Date: Fri, 3 Apr 2015 20:11:56 +0800
Message-ID: <032d070b599b2138f600024d335594393423b618.1428062473.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1428062473.git.zhaolei@cn.fujitsu.com>
References: <cover.1428062473.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Old code bypass commit transaction when we don't have enough
pinned space, but another case is there exist freed bgs in current
transction, it have possibility to make alloc_chunk success.

This patch modify the condition to:
if (have_free_bg || have_pinned_space) commit_transaction()

Confirmed above action by printk before and after patch.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8b353ad..ebeedb4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3641,7 +3641,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 used;
-	int ret = 0, committed = 0, alloc_chunk = 1;
+	int ret = 0, committed = 0, have_pinned_space = 1, alloc_chunk = 1;
 
 	/* make sure bytes are sectorsize aligned */
 	bytes = ALIGN(bytes, root->sectorsize);
@@ -3709,11 +3709,12 @@ alloc:
 
 		/*
 		 * If we don't have enough pinned space to deal with this
-		 * allocation don't bother committing the transaction.
+		 * allocation, and no removed chunk in current transaction,
+		 * don't bother committing the transaction.
 		 */
 		if (percpu_counter_compare(&data_sinfo->total_bytes_pinned,
 					   bytes) < 0)
-			committed = 1;
+			have_pinned_space = 0;
 		spin_unlock(&data_sinfo->lock);
 
 		/* commit the current transaction and try again */
@@ -3725,10 +3726,15 @@ commit_trans:
 			trans = btrfs_join_transaction(root);
 			if (IS_ERR(trans))
 				return PTR_ERR(trans);
-			ret = btrfs_commit_transaction(trans, root);
-			if (ret)
-				return ret;
-			goto again;
+			if (have_pinned_space ||
+			    trans->transaction->have_free_bgs) {
+				ret = btrfs_commit_transaction(trans, root);
+				if (ret)
+					return ret;
+				goto again;
+			} else {
+				btrfs_end_transaction(trans, root);
+			}
 		}
 
 		trace_btrfs_space_reservation(root->fs_info,
-- 
1.8.5.1

