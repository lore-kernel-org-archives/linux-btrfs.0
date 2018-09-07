Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50608 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727856AbeIGTgs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 15:36:48 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B1803ADE7
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 14:55:29 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 06/11] btrfs: dev-replace: move replace members out of fs_info
Date: Fri,  7 Sep 2018 16:55:13 +0200
Message-Id: <b990783799ffa2cdcccd262cacdf4ce23ba36502.1536331604.git.dsterba@suse.com>
In-Reply-To: <cover.1536331604.git.dsterba@suse.com>
References: <cover.1536331604.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The replace_wait and bio_counter were mistakenly added to fs_info in
commit c404e0dc2c843b154f ("Btrfs: fix use-after-free in the finishing
procedure of the device replace"), but they logically belong to
fs_info::dev_replace. Besides, bio_counter is a very generic name and is
confusing in bare fs_info context.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h       |  6 +++---
 fs/btrfs/dev-replace.c | 16 ++++++++--------
 fs/btrfs/disk-io.c     |  9 +++++----
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 31f7a58add7e..89fc90eafb0a 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -371,6 +371,9 @@ struct btrfs_dev_replace {
 	wait_queue_head_t read_lock_wq;
 
 	struct btrfs_scrub_progress scrub_progress;
+
+	struct percpu_counter bio_counter;
+	wait_queue_head_t replace_wait;
 };
 
 /* For raid type sysfs entries */
@@ -1093,9 +1096,6 @@ struct btrfs_fs_info {
 	/* device replace state */
 	struct btrfs_dev_replace dev_replace;
 
-	struct percpu_counter bio_counter;
-	wait_queue_head_t replace_wait;
-
 	struct semaphore uuid_tree_rescan_sem;
 
 	/* Used to reclaim the metadata space in the background. */
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 0a49843b2ee6..c0e9b2c229d5 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -540,8 +540,8 @@ int btrfs_dev_replace_by_ioctl(struct btrfs_fs_info *fs_info,
 static void btrfs_rm_dev_replace_blocked(struct btrfs_fs_info *fs_info)
 {
 	set_bit(BTRFS_FS_STATE_DEV_REPLACING, &fs_info->fs_state);
-	wait_event(fs_info->replace_wait, !percpu_counter_sum(
-		   &fs_info->bio_counter));
+	wait_event(fs_info->dev_replace.replace_wait, !percpu_counter_sum(
+		   &fs_info->dev_replace.bio_counter));
 }
 
 /*
@@ -550,7 +550,7 @@ static void btrfs_rm_dev_replace_blocked(struct btrfs_fs_info *fs_info)
 static void btrfs_rm_dev_replace_unblocked(struct btrfs_fs_info *fs_info)
 {
 	clear_bit(BTRFS_FS_STATE_DEV_REPLACING, &fs_info->fs_state);
-	wake_up(&fs_info->replace_wait);
+	wake_up(&fs_info->dev_replace.replace_wait);
 }
 
 static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
@@ -992,25 +992,25 @@ void btrfs_dev_replace_set_lock_blocking(
 
 void btrfs_bio_counter_inc_noblocked(struct btrfs_fs_info *fs_info)
 {
-	percpu_counter_inc(&fs_info->bio_counter);
+	percpu_counter_inc(&fs_info->dev_replace.bio_counter);
 }
 
 void btrfs_bio_counter_sub(struct btrfs_fs_info *fs_info, s64 amount)
 {
-	percpu_counter_sub(&fs_info->bio_counter, amount);
-	cond_wake_up_nomb(&fs_info->replace_wait);
+	percpu_counter_sub(&fs_info->dev_replace.bio_counter, amount);
+	cond_wake_up_nomb(&fs_info->dev_replace.replace_wait);
 }
 
 void btrfs_bio_counter_inc_blocked(struct btrfs_fs_info *fs_info)
 {
 	while (1) {
-		percpu_counter_inc(&fs_info->bio_counter);
+		percpu_counter_inc(&fs_info->dev_replace.bio_counter);
 		if (likely(!test_bit(BTRFS_FS_STATE_DEV_REPLACING,
 				     &fs_info->fs_state)))
 			break;
 
 		btrfs_bio_counter_dec(fs_info);
-		wait_event(fs_info->replace_wait,
+		wait_event(fs_info->dev_replace.replace_wait,
 			   !test_bit(BTRFS_FS_STATE_DEV_REPLACING,
 				     &fs_info->fs_state));
 	}
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index acd0cbc5a6b9..3b3906589d12 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2156,7 +2156,7 @@ static void btrfs_init_dev_replace_locks(struct btrfs_fs_info *fs_info)
 	mutex_init(&fs_info->dev_replace.lock_finishing_cancel_unmount);
 	rwlock_init(&fs_info->dev_replace.lock);
 	atomic_set(&fs_info->dev_replace.blocking_readers, 0);
-	init_waitqueue_head(&fs_info->replace_wait);
+	init_waitqueue_head(&fs_info->dev_replace.replace_wait);
 	init_waitqueue_head(&fs_info->dev_replace.read_lock_wq);
 }
 
@@ -2646,7 +2646,8 @@ int open_ctree(struct super_block *sb,
 		goto fail_dirty_metadata_bytes;
 	}
 
-	ret = percpu_counter_init(&fs_info->bio_counter, 0, GFP_KERNEL);
+	ret = percpu_counter_init(&fs_info->dev_replace.bio_counter, 0,
+			GFP_KERNEL);
 	if (ret) {
 		err = ret;
 		goto fail_delalloc_bytes;
@@ -3307,7 +3308,7 @@ int open_ctree(struct super_block *sb,
 
 	iput(fs_info->btree_inode);
 fail_bio_counter:
-	percpu_counter_destroy(&fs_info->bio_counter);
+	percpu_counter_destroy(&fs_info->dev_replace.bio_counter);
 fail_delalloc_bytes:
 	percpu_counter_destroy(&fs_info->delalloc_bytes);
 fail_dirty_metadata_bytes:
@@ -4016,7 +4017,7 @@ void close_ctree(struct btrfs_fs_info *fs_info)
 
 	percpu_counter_destroy(&fs_info->dirty_metadata_bytes);
 	percpu_counter_destroy(&fs_info->delalloc_bytes);
-	percpu_counter_destroy(&fs_info->bio_counter);
+	percpu_counter_destroy(&fs_info->dev_replace.bio_counter);
 	cleanup_srcu_struct(&fs_info->subvol_srcu);
 
 	btrfs_free_stripe_hash_table(fs_info);
-- 
2.18.0
