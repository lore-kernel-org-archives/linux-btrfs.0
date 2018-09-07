Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50560 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728823AbeIGTgi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 15:36:38 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 70207AC1F
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 14:55:20 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 02/11] btrfs: open code btrfs_dev_replace_clear_lock_blocking
Date: Fri,  7 Sep 2018 16:55:04 +0200
Message-Id: <cc720651386dd5cc37697460f6dd7312a0498d4c.1536331604.git.dsterba@suse.com>
In-Reply-To: <cover.1536331604.git.dsterba@suse.com>
References: <cover.1536331604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There's a single caller and the function name does not say it's actually
taking the lock, so open coding makes it more explicit.

For now, btrfs_dev_replace_read_lock is used instead of read_lock so
it's paired with the unlocking wrapper in the same block.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/dev-replace.c | 12 ------------
 fs/btrfs/dev-replace.h |  2 --
 fs/btrfs/volumes.c     |  6 +++++-
 3 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 24529d2c723a..004e8d380a11 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -995,18 +995,6 @@ void btrfs_dev_replace_set_lock_blocking(
 	read_unlock(&dev_replace->lock);
 }
 
-/* acquire read lock and dec blocking cnt */
-void btrfs_dev_replace_clear_lock_blocking(
-					struct btrfs_dev_replace *dev_replace)
-{
-	/* only set blocking for read lock */
-	ASSERT(atomic_read(&dev_replace->blocking_readers) > 0);
-	read_lock(&dev_replace->lock);
-	/* Barrier implied by atomic_dec_and_test */
-	if (atomic_dec_and_test(&dev_replace->blocking_readers))
-		cond_wake_up_nomb(&dev_replace->read_lock_wq);
-}
-
 void btrfs_bio_counter_inc_noblocked(struct btrfs_fs_info *fs_info)
 {
 	percpu_counter_inc(&fs_info->bio_counter);
diff --git a/fs/btrfs/dev-replace.h b/fs/btrfs/dev-replace.h
index b6d4206188bb..39f022c457ff 100644
--- a/fs/btrfs/dev-replace.h
+++ b/fs/btrfs/dev-replace.h
@@ -28,8 +28,6 @@ void btrfs_dev_replace_read_unlock(struct btrfs_dev_replace *dev_replace);
 void btrfs_dev_replace_write_lock(struct btrfs_dev_replace *dev_replace);
 void btrfs_dev_replace_write_unlock(struct btrfs_dev_replace *dev_replace);
 void btrfs_dev_replace_set_lock_blocking(struct btrfs_dev_replace *dev_replace);
-void btrfs_dev_replace_clear_lock_blocking(
-					struct btrfs_dev_replace *dev_replace);
 
 static inline void btrfs_dev_replace_stats_inc(atomic64_t *stat_value)
 {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ea9845a5e601..762a4499d00a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5904,7 +5904,11 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info,
 	}
 out:
 	if (dev_replace_is_ongoing) {
-		btrfs_dev_replace_clear_lock_blocking(dev_replace);
+		ASSERT(atomic_read(&dev_replace->blocking_readers) > 0);
+		btrfs_dev_replace_read_lock(dev_replace);
+		/* Barrier implied by atomic_dec_and_test */
+		if (atomic_dec_and_test(&dev_replace->blocking_readers))
+			cond_wake_up_nomb(&dev_replace->read_lock_wq);
 		btrfs_dev_replace_read_unlock(dev_replace);
 	}
 	free_extent_map(em);
-- 
2.18.0
