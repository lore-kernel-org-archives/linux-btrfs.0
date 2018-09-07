Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50554 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728823AbeIGTgg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 15:36:36 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 28418AC1F
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 14:55:18 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 01/11] btrfs: remove btrfs_dev_replace::read_locks
Date: Fri,  7 Sep 2018 16:55:02 +0200
Message-Id: <8787a706839a04a736f389d9d24ab215f15467d5.1536331604.git.dsterba@suse.com>
In-Reply-To: <cover.1536331604.git.dsterba@suse.com>
References: <cover.1536331604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This member seems to be copied from the extent_buffer locking scheme and
is at least used to assert that the read lock/unlock is properly nested.
In some way. While the _inc/_dec are called inside the read lock
section, the asserts are both inside and outside, so the ordering is not
guaranteed and we can see read/inc/dec ordered in any way
(theoretically).

A missing call of btrfs_dev_replace_clear_lock_blocking could cause
unexpected read_locks count, so this at least looks like a valid
assertion, but this will become unnecessary with later updates.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h       | 1 -
 fs/btrfs/dev-replace.c | 5 -----
 fs/btrfs/disk-io.c     | 1 -
 3 files changed, 7 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 441610de9908..31f7a58add7e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -367,7 +367,6 @@ struct btrfs_dev_replace {
 
 	struct mutex lock_finishing_cancel_unmount;
 	rwlock_t lock;
-	atomic_t read_locks;
 	atomic_t blocking_readers;
 	wait_queue_head_t read_lock_wq;
 
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index dec01970d8c5..24529d2c723a 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -961,13 +961,10 @@ int btrfs_dev_replace_is_ongoing(struct btrfs_dev_replace *dev_replace)
 void btrfs_dev_replace_read_lock(struct btrfs_dev_replace *dev_replace)
 {
 	read_lock(&dev_replace->lock);
-	atomic_inc(&dev_replace->read_locks);
 }
 
 void btrfs_dev_replace_read_unlock(struct btrfs_dev_replace *dev_replace)
 {
-	ASSERT(atomic_read(&dev_replace->read_locks) > 0);
-	atomic_dec(&dev_replace->read_locks);
 	read_unlock(&dev_replace->lock);
 }
 
@@ -994,7 +991,6 @@ void btrfs_dev_replace_set_lock_blocking(
 					struct btrfs_dev_replace *dev_replace)
 {
 	/* only set blocking for read lock */
-	ASSERT(atomic_read(&dev_replace->read_locks) > 0);
 	atomic_inc(&dev_replace->blocking_readers);
 	read_unlock(&dev_replace->lock);
 }
@@ -1004,7 +1000,6 @@ void btrfs_dev_replace_clear_lock_blocking(
 					struct btrfs_dev_replace *dev_replace)
 {
 	/* only set blocking for read lock */
-	ASSERT(atomic_read(&dev_replace->read_locks) > 0);
 	ASSERT(atomic_read(&dev_replace->blocking_readers) > 0);
 	read_lock(&dev_replace->lock);
 	/* Barrier implied by atomic_dec_and_test */
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3611df2ce5c1..acd0cbc5a6b9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2155,7 +2155,6 @@ static void btrfs_init_dev_replace_locks(struct btrfs_fs_info *fs_info)
 {
 	mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
 	rwlock_init(&fs_info->dev_replace.lock);
-	atomic_set(&fs_info->dev_replace.read_locks, 0);
 	atomic_set(&fs_info->dev_replace.blocking_readers, 0);
 	init_waitqueue_head(&fs_info->replace_wait);
 	init_waitqueue_head(&fs_info->dev_replace.read_lock_wq);
-- 
2.18.0
