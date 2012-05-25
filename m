Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370Ab2EYDJn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 May 2012 23:09:43 -0400
From: Asias He <asias@redhat.com>
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Asias He <asias@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] btrfs: Drop unused function btrfs_abort_devices()
Date: Fri, 25 May 2012 11:10:21 +0800
Message-Id: <1337915422-24988-1-git-send-email-asias@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1) This function is not used anywhere.

2) Using the blk_abort_queue() to abort the queue seems not correct.
blk_abort_queue() is used for timeout handling (block/blk-timeout.c).

Cc: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Asias He <asias@redhat.com>
---
 fs/btrfs/disk-io.c |   13 -------------
 fs/btrfs/disk-io.h |    1 -
 2 files changed, 14 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e1fe74a..3521866 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2902,19 +2902,6 @@ int write_ctree_super(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-/* Kill all outstanding I/O */
-void btrfs_abort_devices(struct btrfs_root *root)
-{
-	struct list_head *head;
-	struct btrfs_device *dev;
-	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
-	head = &root->fs_info->fs_devices->devices;
-	list_for_each_entry_rcu(dev, head, dev_list) {
-		blk_abort_queue(dev->bdev->bd_disk->queue);
-	}
-	mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
-}
-
 void btrfs_free_fs_root(struct btrfs_fs_info *fs_info, struct btrfs_root *root)
 {
 	spin_lock(&fs_info->fs_roots_radix_lock);
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index ab1830a..05b3fab 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -89,7 +89,6 @@ int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
 int btrfs_cleanup_transaction(struct btrfs_root *root);
 void btrfs_cleanup_one_transaction(struct btrfs_transaction *trans,
 				  struct btrfs_root *root);
-void btrfs_abort_devices(struct btrfs_root *root);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 void btrfs_init_lockdep(void);
-- 
1.7.10.2

