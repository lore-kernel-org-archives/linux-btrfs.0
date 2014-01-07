Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26533 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbaAGJ2F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jan 2014 04:28:05 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s079S3sp019601
	for <linux-btrfs@vger.kernel.org>; Tue, 7 Jan 2014 17:28:04 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH v2 3/4] Btrfs: remove unnecessary transaction commit before send
Date: Tue, 7 Jan 2014 17:26:57 +0800
Message-Id: <1389086818-19794-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We will finish orphan cleanups during snapshot, so we don't
have to commit transaction here.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1->v2: none
---
 fs/btrfs/send.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 4e2461b..591063d 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -4776,35 +4776,6 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	WARN_ON(send_root->orphan_cleanup_state != ORPHAN_CLEANUP_DONE);
 
 	/*
-	 * If we just created this root we need to make sure that the orphan
-	 * cleanup has been done and committed since we search the commit root,
-	 * so check its commit root transid with our otransid and if they match
-	 * commit the transaction to make sure everything is updated.
-	 */
-	down_read(&send_root->fs_info->extent_commit_sem);
-	if (btrfs_header_generation(send_root->commit_root) ==
-	    btrfs_root_otransid(&send_root->root_item)) {
-		struct btrfs_trans_handle *trans;
-
-		up_read(&send_root->fs_info->extent_commit_sem);
-
-		trans = btrfs_attach_transaction_barrier(send_root);
-		if (IS_ERR(trans)) {
-			if (PTR_ERR(trans) != -ENOENT) {
-				ret = PTR_ERR(trans);
-				goto out;
-			}
-			/* ENOENT means theres no transaction */
-		} else {
-			ret = btrfs_commit_transaction(trans, send_root);
-			if (ret)
-				goto out;
-		}
-	} else {
-		up_read(&send_root->fs_info->extent_commit_sem);
-	}
-
-	/*
 	 * Userspace tools do the checks and warn the user if it's
 	 * not RO.
 	 */
-- 
1.8.3.1

