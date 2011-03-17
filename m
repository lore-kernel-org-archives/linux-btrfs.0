From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] Btrfs scrub: revised locking scheme
Date: Thu, 17 Mar 2011 19:56:55 +0100
Message-ID: <1300388215-10930-1-git-send-email-sensille@gmx.net>
Cc: andi@firstfloor.org
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This patch removes unnecessary mutex locks around
scrubs_running.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/scrub.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index ee7671f..85a4d4b 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -249,10 +249,10 @@ static void scrub_recheck_error(struct scrub_bio *sbio, int ix)
 	 * while we're in here we do not want the transaction to commit.
 	 * To prevent it, we increment scrubs_running. scrub_pause will
 	 * have to wait until we're finished
+	 * we can safely increment scrubs_running here, because we're
+	 * in the context of the original bio which is still marked in_flight
 	 */
-	mutex_lock(&fs_info->scrub_lock);
 	atomic_inc(&fs_info->scrubs_running);
-	mutex_unlock(&fs_info->scrub_lock);
 
 	fixup = kzalloc(sizeof(*fixup), GFP_NOFS);
 	if (!fixup)
@@ -311,9 +311,7 @@ malloc_error:
 	spin_lock(&sdev->stat_lock);
 	++sdev->stat.malloc_errors;
 	spin_unlock(&sdev->stat_lock);
-	mutex_lock(&fs_info->scrub_lock);
 	atomic_dec(&fs_info->scrubs_running);
-	mutex_unlock(&fs_info->scrub_lock);
 	wake_up(&fs_info->scrub_pause_wait);
 }
 
@@ -371,9 +369,7 @@ static void scrub_fixup_worker(scrub_work_t *work)
 	__free_page(fixup->bio->bi_io_vec[0].bv_page);
 	bio_put(fixup->bio);
 
-	mutex_lock(&fs_info->scrub_lock);
 	atomic_dec(&fs_info->scrubs_running);
-	mutex_unlock(&fs_info->scrub_lock);
 	wake_up(&fs_info->scrub_pause_wait);
 
 	kfree(fixup);
@@ -1328,7 +1324,7 @@ int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
 
 	mutex_lock(&root->fs_info->fs_devices->device_list_mutex);
 	dev = btrfs_find_device(root, devid, NULL, NULL);
-	if (!dev || dev->missing) {
+	if (!dev || dev->missing || !dev->in_fs_metadata) {
 		mutex_unlock(&root->fs_info->fs_devices->device_list_mutex);
 		scrub_workers_put(root);
 		return -ENODEV;
@@ -1361,9 +1357,7 @@ int btrfs_scrub_dev(struct btrfs_root *root, u64 devid, u64 start, u64 end,
 
 	wait_event(sdev->list_wait, atomic_read(&sdev->in_flight) == 0);
 
-	mutex_lock(&fs_info->scrub_lock);
 	atomic_dec(&fs_info->scrubs_running);
-	mutex_unlock(&fs_info->scrub_lock);
 	wake_up(&fs_info->scrub_pause_wait);
 
 	if (progress)
-- 
1.7.3.4

