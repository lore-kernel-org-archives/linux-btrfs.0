Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39221 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab2KZIlp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Nov 2012 03:41:45 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qAQ8fhg6006576
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2012 16:41:44 +0800
Message-ID: <50B32B5F.2040709@cn.fujitsu.com>
Date: Mon, 26 Nov 2012 16:42:07 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/9] Btrfs: fix wrong return value of btrfs_wait_for_commit()
References: <50B32ABF.7040803@cn.fujitsu.com>
In-Reply-To: <50B32ABF.7040803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the id of the existed transaction is more than the one we specified, it
means the specified transaction was commited, so we should return 0, not
EINVAL.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 350e9c4..788e079 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -461,28 +461,31 @@ static noinline void wait_for_commit(struct btrfs_root *root,
 int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid)
 {
 	struct btrfs_transaction *cur_trans = NULL, *t;
-	int ret;
+	int ret = 0;
 
-	ret = 0;
 	if (transid) {
 		if (transid <= root->fs_info->last_trans_committed)
 			goto out;
 
+		ret = -EINVAL;
 		/* find specified transaction */
 		spin_lock(&root->fs_info->trans_lock);
 		list_for_each_entry(t, &root->fs_info->trans_list, list) {
 			if (t->transid == transid) {
 				cur_trans = t;
 				atomic_inc(&cur_trans->use_count);
+				ret = 0;
 				break;
 			}
-			if (t->transid > transid)
+			if (t->transid > transid) {
+				ret = 0;
 				break;
+			}
 		}
 		spin_unlock(&root->fs_info->trans_lock);
-		ret = -EINVAL;
+		/* The specified transaction doesn't exist */
 		if (!cur_trans)
-			goto out;  /* bad transid */
+			goto out;
 	} else {
 		/* find newest transaction that is committing | committed */
 		spin_lock(&root->fs_info->trans_lock);
@@ -502,9 +505,7 @@ int btrfs_wait_for_commit(struct btrfs_root *root, u64 transid)
 	}
 
 	wait_for_commit(root, cur_trans);
-
 	put_transaction(cur_trans);
-	ret = 0;
 out:
 	return ret;
 }
-- 
1.7.11.7

