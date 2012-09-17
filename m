Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:8361 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab2IQGec (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 02:34:32 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8H6YTis021540
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2012 14:34:29 +0800
Message-ID: <5056C473.50709@cn.fujitsu.com>
Date: Mon, 17 Sep 2012 14:34:27 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix double decrease of the writer counter
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In __btrfs_end_transaction(), we have invoked sb_end_intwrite(), but if we
need run btrfs_commit_transaction(), we will decrease the writer counter
for two times because btrfs_commit_transaction() also invokes sb_end_intwrite().
Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/transaction.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 27c2600..3134fdc 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -551,8 +551,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 	btrfs_trans_release_metadata(trans, root);
 	trans->block_rsv = NULL;
 
-	sb_end_intwrite(root->fs_info->sb);
-
 	if (lock && !atomic_read(&root->fs_info->open_ioctl_trans) &&
 	    should_end_transaction(trans, root)) {
 		trans->transaction->blocked = 1;
@@ -573,6 +571,8 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 		}
 	}
 
+	sb_end_intwrite(root->fs_info->sb);
+
 	WARN_ON(cur_trans != info->running_transaction);
 	WARN_ON(atomic_read(&cur_trans->num_writers) < 1);
 	atomic_dec(&cur_trans->num_writers);
-- 
1.7.6.5
