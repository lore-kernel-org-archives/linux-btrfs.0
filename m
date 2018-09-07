Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50660 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727856AbeIGTgz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 15:36:55 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 846C0AC1F
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 14:55:36 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 09/11] btrfs: dev-replace: swich locking to rw semaphore
Date: Fri,  7 Sep 2018 16:55:20 +0200
Message-Id: <c8aea5a8bd2da36e1e4c31b07207f4ee4aed78a0.1536331604.git.dsterba@suse.com>
In-Reply-To: <cover.1536331604.git.dsterba@suse.com>
References: <cover.1536331604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The this is first part of removing the custom locking and waiting scheme
used for device replace. It was probably copied from extent buffer
locking, but there's nothing that would require more than is provided by
the common locking primitives.

The rw spinlock protects waiting tasks counter in case of incompatible
locks and the waitqueue. Same as rw semaphore.

This patch only switches the locking primitive, for better
bisectability.  There should be no functional change other than the
overhead of the locking and potential sleeping instead of spinning when
the lock is contended.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/dev-replace.c | 12 ++++++------
 fs/btrfs/disk-io.c     |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 89fc90eafb0a..02b5372a42d7 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -366,7 +366,7 @@ struct btrfs_dev_replace {
 	struct btrfs_device *tgtdev;
 
 	struct mutex lock_finishing_cancel_unmount;
-	rwlock_t lock;
+	struct rw_semaphore rwsem;
 	atomic_t blocking_readers;
 	wait_queue_head_t read_lock_wq;
 
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index ba1cbedaa422..ddaa9dcf8284 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -955,12 +955,12 @@ int btrfs_dev_replace_is_ongoing(struct btrfs_dev_replace *dev_replace)
 
 void btrfs_dev_replace_read_lock(struct btrfs_dev_replace *dev_replace)
 {
-	read_lock(&dev_replace->lock);
+	down_read(&dev_replace->rwsem);
 }
 
 void btrfs_dev_replace_read_unlock(struct btrfs_dev_replace *dev_replace)
 {
-	read_unlock(&dev_replace->lock);
+	up_read(&dev_replace->rwsem);
 }
 
 void btrfs_dev_replace_write_lock(struct btrfs_dev_replace *dev_replace)
@@ -968,16 +968,16 @@ void btrfs_dev_replace_write_lock(struct btrfs_dev_replace *dev_replace)
 again:
 	wait_event(dev_replace->read_lock_wq,
 		   atomic_read(&dev_replace->blocking_readers) == 0);
-	write_lock(&dev_replace->lock);
+	down_write(&dev_replace->rwsem);
 	if (atomic_read(&dev_replace->blocking_readers)) {
-		write_unlock(&dev_replace->lock);
+		up_write(&dev_replace->rwsem);
 		goto again;
 	}
 }
 
 void btrfs_dev_replace_write_unlock(struct btrfs_dev_replace *dev_replace)
 {
-	write_unlock(&dev_replace->lock);
+	up_write(&dev_replace->rwsem);
 }
 
 /* inc blocking cnt and release read lock */
@@ -986,7 +986,7 @@ void btrfs_dev_replace_set_lock_blocking(
 {
 	/* only set blocking for read lock */
 	atomic_inc(&dev_replace->blocking_readers);
-	read_unlock(&dev_replace->lock);
+	up_read(&dev_replace->rwsem);
 }
 
 void btrfs_bio_counter_inc_noblocked(struct btrfs_fs_info *fs_info)
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3b3906589d12..3f73f2a3d67b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2154,7 +2154,7 @@ static void btrfs_init_btree_inode(struct btrfs_fs_info *fs_info)
 static void btrfs_init_dev_replace_locks(struct btrfs_fs_info *fs_info)
 {
 	mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
-	rwlock_init(&fs_info->dev_replace.lock);
+	init_rwsem(&fs_info->dev_replace.rwsem);
 	atomic_set(&fs_info->dev_replace.blocking_readers, 0);
 	init_waitqueue_head(&fs_info->dev_replace.replace_wait);
 	init_waitqueue_head(&fs_info->dev_replace.read_lock_wq);
-- 
2.18.0
