Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:15129 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab2KOIOa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Nov 2012 03:14:30 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qAF8ES1m018322
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2012 16:14:28 +0800
Message-ID: <50A4A477.8010404@cn.fujitsu.com>
Date: Thu, 15 Nov 2012 16:14:47 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] Btrfs: use common work instead of delayed work
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we do not want to delay the async transaction commit, we should
use common work, not delayed work.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 9930888..a367df6 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1296,13 +1296,13 @@ static void wait_current_trans_commit_start_and_unblock(struct btrfs_root *root,
 struct btrfs_async_commit {
 	struct btrfs_trans_handle *newtrans;
 	struct btrfs_root *root;
-	struct delayed_work work;
+	struct work_struct work;
 };
 
 static void do_async_commit(struct work_struct *work)
 {
 	struct btrfs_async_commit *ac =
-		container_of(work, struct btrfs_async_commit, work.work);
+		container_of(work, struct btrfs_async_commit, work);
 
 	/*
 	 * We've got freeze protection passed with the transaction.
@@ -1329,7 +1329,7 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 	if (!ac)
 		return -ENOMEM;
 
-	INIT_DELAYED_WORK(&ac->work, do_async_commit);
+	INIT_WORK(&ac->work, do_async_commit);
 	ac->root = root;
 	ac->newtrans = btrfs_join_transaction(root);
 	if (IS_ERR(ac->newtrans)) {
@@ -1351,7 +1351,7 @@ int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 	rwsem_release(&root->fs_info->sb->s_writers.lock_map[SB_FREEZE_FS-1],
 		      1, _THIS_IP_);
 
-	schedule_delayed_work(&ac->work, 0);
+	schedule_work(&ac->work);
 
 	/* wait for transaction to start and unblock */
 	if (wait_for_unblock)
-- 
1.7.11.7
