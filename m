From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 4/5] Btrfs: fix up btrfs_start_workers error handling
Date: Fri, 13 Feb 2009 17:17:42 -0500
Message-ID: <1234563463-7585-4-git-send-email-jeffm@suse.com>
References: <1234563463-7585-1-git-send-email-jeffm@suse.com>
 <1234563463-7585-2-git-send-email-jeffm@suse.com>
 <1234563463-7585-3-git-send-email-jeffm@suse.com>
Cc: Jeff Mahoney <jeffm@suse.com>
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1234563463-7585-3-git-send-email-jeffm@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

This patch fixes error handling for worker thread startup.

The way btrfs_start_workers handles an error is to stop all existing
threads in that pool and return an error. This works fine when we're
mounting, but when we're looking to grow the thread pool, that's
not what we want to happen.

This patch uses a temporary btrfs_workers struct to start up the
requested threads and, once they're all created successfully, splices
the idle list into the real struct and updates its count.
On failure, the temporary one is torn down so only the threads created
during that run are cleaned up. Since they were never added to the
worker or idle lists, this should be quick as well.

It also handles startup failures during mount.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/async-thread.c |   17 ++++++++++++-----
 fs/btrfs/disk-io.c      |   40 ++++++++++++++++++++++++++++++++--------
 2 files changed, 44 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index c84ca1f..66def6f 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -259,9 +259,12 @@ void btrfs_init_workers(struct btrfs_workers *workers, char *name, int max)
 int btrfs_start_workers(struct btrfs_workers *workers, int num_workers)
 {
 	struct btrfs_worker_thread *worker;
+	struct btrfs_workers tmp_workers;
 	int ret = 0;
 	int i;
 
+	btrfs_init_workers(&tmp_workers, NULL, num_workers);
+
 	for (i = 0; i < num_workers; i++) {
 		worker = kzalloc(sizeof(*worker), GFP_NOFS);
 		if (!worker) {
@@ -283,15 +286,19 @@ int btrfs_start_workers(struct btrfs_workers *workers, int num_workers)
 			goto fail;
 		}
 
-		spin_lock_irq(&workers->lock);
-		list_add_tail(&worker->worker_list, &workers->idle_list);
+		list_add_tail(&worker->worker_list, &tmp_workers.idle_list);
 		worker->idle = 1;
-		workers->num_workers++;
-		spin_unlock_irq(&workers->lock);
+		tmp_workers.num_workers++;
 	}
+
+	spin_lock_irq(&workers->lock);
+	list_splice_init(&tmp_workers.idle_list, &workers->idle_list);
+	workers->num_workers += tmp_workers.num_workers;
+	spin_unlock_irq(&workers->lock);
+
 	return 0;
 fail:
-	btrfs_stop_workers(workers);
+	btrfs_stop_workers(&tmp_workers);
 	return ret;
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 3e2688b..d066dc6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1737,17 +1737,41 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	fs_info->endio_write_workers.idle_thresh = 64;
 	fs_info->endio_meta_write_workers.idle_thresh = 64;
 
-	btrfs_start_workers(&fs_info->workers, 1);
-	btrfs_start_workers(&fs_info->submit_workers, 1);
-	btrfs_start_workers(&fs_info->delalloc_workers, 1);
-	btrfs_start_workers(&fs_info->fixup_workers, 1);
-	btrfs_start_workers(&fs_info->endio_workers, fs_info->thread_pool_size);
-	btrfs_start_workers(&fs_info->endio_meta_workers,
+	ret = btrfs_start_workers(&fs_info->workers, 1);
+	if (ret)
+		goto fail_sb_buffer;
+
+	ret = btrfs_start_workers(&fs_info->submit_workers, 1);
+	if (ret)
+		goto fail_sb_buffer;
+
+	ret = btrfs_start_workers(&fs_info->delalloc_workers, 1);
+	if (ret)
+		goto fail_sb_buffer;
+
+	ret = btrfs_start_workers(&fs_info->fixup_workers, 1);
+	if (ret)
+		goto fail_sb_buffer;
+
+	ret = btrfs_start_workers(&fs_info->endio_workers,
+				  fs_info->thread_pool_size);
+	if (ret)
+		goto fail_sb_buffer;
+
+	ret = btrfs_start_workers(&fs_info->endio_meta_workers,
 			    fs_info->thread_pool_size);
-	btrfs_start_workers(&fs_info->endio_meta_write_workers,
+	if (ret)
+		goto fail_sb_buffer;
+
+	ret = btrfs_start_workers(&fs_info->endio_meta_write_workers,
 			    fs_info->thread_pool_size);
-	btrfs_start_workers(&fs_info->endio_write_workers,
+	if (ret)
+		goto fail_sb_buffer;
+
+	ret = btrfs_start_workers(&fs_info->endio_write_workers,
 			    fs_info->thread_pool_size);
+	if (ret)
+		goto fail_sb_buffer;
 
 	fs_info->bdi.ra_pages *= btrfs_super_num_devices(disk_super);
 	fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
-- 
1.6.0.2

