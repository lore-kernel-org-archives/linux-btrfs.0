Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50666 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727856AbeIGTg5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 15:36:57 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D64F1ACBB
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 14:55:38 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 10/11] btrfs: dev-replace: remove custom read/write blocking scheme
Date: Fri,  7 Sep 2018 16:55:22 +0200
Message-Id: <e3b6d57cfd31a91299596d517cdb04888e87bdfd.1536331604.git.dsterba@suse.com>
In-Reply-To: <cover.1536331604.git.dsterba@suse.com>
References: <cover.1536331604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After the rw semaphore has been added, the custom blocking using
::blocking_readers and ::read_lock_wq is redundant.

The blocking logic in __btrfs_map_block is replaced by extending the
time the semaphore is held, that has the same blocking effect on writes
as the previous custom scheme that waited until ::blocking_readers was
zero.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h       |  2 --
 fs/btrfs/dev-replace.c | 16 ----------------
 fs/btrfs/dev-replace.h |  1 -
 fs/btrfs/disk-io.c     |  2 --
 fs/btrfs/volumes.c     | 13 ++++++-------
 5 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 02b5372a42d7..2a255d5897f8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -367,8 +367,6 @@ struct btrfs_dev_replace {
 
 	struct mutex lock_finishing_cancel_unmount;
 	struct rw_semaphore rwsem;
-	atomic_t blocking_readers;
-	wait_queue_head_t read_lock_wq;
 
 	struct btrfs_scrub_progress scrub_progress;
 
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index ddaa9dcf8284..e8c2f418b2d7 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -965,14 +965,7 @@ void btrfs_dev_replace_read_unlock(struct btrfs_dev_replace *dev_replace)
 
 void btrfs_dev_replace_write_lock(struct btrfs_dev_replace *dev_replace)
 {
-again:
-	wait_event(dev_replace->read_lock_wq,
-		   atomic_read(&dev_replace->blocking_readers) == 0);
 	down_write(&dev_replace->rwsem);
-	if (atomic_read(&dev_replace->blocking_readers)) {
-		up_write(&dev_replace->rwsem);
-		goto again;
-	}
 }
 
 void btrfs_dev_replace_write_unlock(struct btrfs_dev_replace *dev_replace)
@@ -980,15 +973,6 @@ void btrfs_dev_replace_write_unlock(struct btrfs_dev_replace *dev_replace)
 	up_write(&dev_replace->rwsem);
 }
 
-/* inc blocking cnt and release read lock */
-void btrfs_dev_replace_set_lock_blocking(
-					struct btrfs_dev_replace *dev_replace)
-{
-	/* only set blocking for read lock */
-	atomic_inc(&dev_replace->blocking_readers);
-	up_read(&dev_replace->rwsem);
-}
-
 void btrfs_bio_counter_inc_noblocked(struct btrfs_fs_info *fs_info)
 {
 	percpu_counter_inc(&fs_info->dev_replace.bio_counter);
diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index 795c551f5b5e..eec7289c2618 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -26,6 +26,5 @@ void btrfs_dev_replace_read_lock(struct btrfs_dev_replace *dev_replace);
 void btrfs_dev_replace_read_unlock(struct btrfs_dev_replace *dev_replace);
 void btrfs_dev_replace_write_lock(struct btrfs_dev_replace *dev_replace);
 void btrfs_dev_replace_write_unlock(struct btrfs_dev_replace *dev_replace);
-void btrfs_dev_replace_set_lock_blocking(struct btrfs_dev_replace *dev_replace);
 
 #endif
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3f73f2a3d67b..520b1d6f615f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2155,9 +2155,7 @@ static void btrfs_init_dev_replace_locks(struct btrfs_fs_info *fs_info)
 {
 	mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
 	init_rwsem(&fs_info->dev_replace.rwsem);
-	atomic_set(&fs_info->dev_replace.blocking_readers, 0);
 	init_waitqueue_head(&fs_info->dev_replace.replace_wait);
-	init_waitqueue_head(&fs_info->dev_replace.read_lock_wq);
 }
 
 static void btrfs_init_qgroup(struct btrfs_fs_info *fs_info)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 762a4499d00a..d1f83529ac80 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5706,10 +5706,12 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 
 	btrfs_dev_replace_read_lock(dev_replace);
 	dev_replace_is_ongoing = btrfs_dev_replace_is_ongoing(dev_replace);
+	/*
+	 * Hold the semaphore for read during the whole operation, write is
+	 * requested at commit time but must wait.
+	 */
 	if (!dev_replace_is_ongoing)
 		btrfs_dev_replace_read_unlock(dev_replace);
-	else
-		btrfs_dev_replace_set_lock_blocking(dev_replace);
 
 	if (dev_replace_is_ongoing && mirror_num == map->num_stripes + 1 &&
 	    !need_full_stripe(op) && dev_replace->tgtdev != NULL) {
@@ -5904,11 +5906,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	}
 out:
 	if (dev_replace_is_ongoing) {
-		ASSERT(atomic_read(&dev_replace->blocking_readers) > 0);
-		btrfs_dev_replace_read_lock(dev_replace);
-		/* Barrier implied by atomic_dec_and_test */
-		if (atomic_dec_and_test(&dev_replace->blocking_readers))
-			cond_wake_up_nomb(&dev_replace->read_lock_wq);
+		lockdep_assert_held(&dev_replace->rwsem);
+		/* Unlock and let waiting writers proceed */
 		btrfs_dev_replace_read_unlock(dev_replace);
 	}
 	free_extent_map(em);
-- 
2.18.0
