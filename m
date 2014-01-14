Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:26089 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbaANNQQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 08:16:16 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s0ECUO5k015722
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 20:30:25 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 2/4] Btrfs: don't get the lock when adding a csum into a ordered extent
Date: Tue, 14 Jan 2014 20:31:50 +0800
Message-Id: <1389702712-26638-3-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1389702712-26638-1-git-send-email-miaox@cn.fujitsu.com>
References: <1389702712-26638-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We are sure that:
- one ordered extent just has one csum calculation worker, and no one
  access the csum list during the csum calculation except the worker.
- we don't change the list and free the csum until no one reference
  to the ordered extent
So it is safe to add csum without the lock.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ordered-data.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index e4c3d56..396c6d1 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -280,16 +280,11 @@ void btrfs_add_ordered_sum(struct inode *inode,
 			   struct btrfs_ordered_extent *entry,
 			   struct btrfs_ordered_sum *sum)
 {
-	struct btrfs_ordered_inode_tree *tree;
-
-	tree = &BTRFS_I(inode)->ordered_tree;
-	spin_lock_irq(&tree->lock);
 	list_add_tail(&sum->list, &entry->list);
 	WARN_ON(entry->csum_bytes_left < sum->len);
 	entry->csum_bytes_left -= sum->len;
 	if (entry->csum_bytes_left == 0)
 		wake_up(&entry->wait);
-	spin_unlock_irq(&tree->lock);
 }
 
 /*
-- 
1.7.1

