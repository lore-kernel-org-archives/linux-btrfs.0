Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:24837 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757198Ab3EOHsq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 May 2013 03:48:46 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: alex.btrfs@zadarastorage.com
Subject: [PATCH 11/17] Btrfs: cleanup unnecessary assignment when cleaning up all the residual transaction
Date: Wed, 15 May 2013 15:48:25 +0800
Message-Id: <1368604111-25073-12-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368604111-25073-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we umount a fs with serious errors, we will invoke btrfs_cleanup_transactions()
to clean up the residual transaction. At this time, It is impossible to start a new
transaction, so we needn't assign trans_no_join to 1, and also needn't clear running
transaction every time we destroy a residual transaction.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 44d5a86..6bb3f3d 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3992,7 +3992,7 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
 
 	spin_lock(&root->fs_info->trans_lock);
 	list_splice_init(&root->fs_info->trans_list, &list);
-	root->fs_info->trans_no_join = 1;
+	root->fs_info->running_transaction = NULL;
 	spin_unlock(&root->fs_info->trans_lock);
 
 	while (!list_empty(&list)) {
@@ -4028,10 +4028,6 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
 
 		btrfs_destroy_all_delalloc_inodes(root->fs_info);
 
-		spin_lock(&root->fs_info->trans_lock);
-		root->fs_info->running_transaction = NULL;
-		spin_unlock(&root->fs_info->trans_lock);
-
 		btrfs_destroy_marked_extents(root, &t->dirty_pages,
 					     EXTENT_DIRTY);
 
@@ -4044,9 +4040,6 @@ static int btrfs_cleanup_transaction(struct btrfs_root *root)
 		kmem_cache_free(btrfs_transaction_cachep, t);
 	}
 
-	spin_lock(&root->fs_info->trans_lock);
-	root->fs_info->trans_no_join = 0;
-	spin_unlock(&root->fs_info->trans_lock);
 	mutex_unlock(&root->fs_info->transaction_kthread_mutex);
 
 	return 0;
-- 
1.8.1.4

