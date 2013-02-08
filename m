Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20762 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755091Ab3BHGzL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Feb 2013 01:55:11 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r186t58U028479
	for <linux-btrfs@vger.kernel.org>; Fri, 8 Feb 2013 14:55:05 +0800
Message-ID: <5114A177.5020604@cn.fujitsu.com>
Date: Fri, 08 Feb 2013 14:55:51 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix the deadlock between the transaction attach and
 commit
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here is the whole story:
	Trans_Attach_Task		Trans_Commit_Task
					btrfs_commit_transaction()
					 |->wait writers to be 1
	btrfs_attach_transaction()	 |
	btrfs_commit_transaction()	 |
	 |				 |->set trans_no_join to 1
	 |				 |  (close join transaction)
	 |->btrfs_run_ordered_operations |
	    (Those ordered operations	 |
	     are added when releasing	 |
	     file)			 |
	     |->btrfs_join_transaction() |
		|->wait_commit()	 |
					 |->wait writers to be 1

Then these two tasks waited for each other.

As we know, btrfs_attach_transaction() is used to catch the current
transaction, and commit it, so if someone has committed the transaction,
it is unnecessary to join it and commit it, wait is the best choice
for it. In this way, we can fix the above problem.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f154946..7be9d5e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -285,6 +285,14 @@ static int may_wait_transaction(struct btrfs_root *root, int type)
 	if (type == TRANS_USERSPACE)
 		return 1;
 
+	/*
+	 * If we are ATTACH, it means we just want to catch the current
+	 * transaction and commit it. So if someone is committing the
+	 * current transaction now, it is very glad to wait it.
+	 */
+	if (type == TRANS_ATTACH)
+		return 1;
+
 	if (type == TRANS_START &&
 	    !atomic_read(&root->fs_info->open_ioctl_trans))
 		return 1;
-- 
1.6.5.2
