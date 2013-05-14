Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64127 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab3ENKUw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 06:20:52 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 1/4] Btrfs: remove unnecessary ->s_umount in cleaner_kthread()
Date: Tue, 14 May 2013 18:20:40 +0800
Message-Id: <1368526843-18000-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In order to avoid the R/O remount, we acquired ->s_umount lock during
we deleted the dead snapshots and subvolumes. But it is unnecessary,
because we have cleaner_mutex.

We use cleaner_mutex to protect the process of the dead snapshots/subvolumes
deletion. And when we remount the fs to be R/O, we also acquire this mutex to
do cleanup after we change the status of the fs. That is this lock can serialize
the above operations, the cleaner can be aware of the status of the fs, and if
the cleaner is deleting the dead snapshots/subvolumes, the remount task will
wait for it. So it is safe to remove ->s_umount in cleaner_kthread().

Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a9df562..cb2bfd1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1676,24 +1676,40 @@ static void end_workqueue_fn(struct btrfs_work *work)
 	bio_endio(bio, error);
 }
 
+/*
+ * If we remount the fs to be R/O, the cleaner needn't do anything except
+ * sleeping. This function is used to check the status of the fs.
+ */
+static inline int need_cleaner_sleep(struct btrfs_root *root)
+{
+	return root->fs_info->sb->s_flags & MS_RDONLY;
+}
+
 static int cleaner_kthread(void *arg)
 {
 	struct btrfs_root *root = arg;
+	int again;
 
 	do {
-		int again = 0;
-
-		if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
-		    down_read_trylock(&root->fs_info->sb->s_umount)) {
-			if (mutex_trylock(&root->fs_info->cleaner_mutex)) {
-				btrfs_run_delayed_iputs(root);
-				again = btrfs_clean_one_deleted_snapshot(root);
-				mutex_unlock(&root->fs_info->cleaner_mutex);
-			}
-			btrfs_run_defrag_inodes(root->fs_info);
-			up_read(&root->fs_info->sb->s_umount);
-		}
+		again = 0;
 
+		/* Make the cleaner go to sleep early. */
+		if (need_cleaner_sleep(root))
+			goto sleep;
+
+		if (!mutex_trylock(&root->fs_info->cleaner_mutex))
+			goto sleep;
+
+		btrfs_run_delayed_iputs(root);
+		again = btrfs_clean_one_deleted_snapshot(root);
+		mutex_unlock(&root->fs_info->cleaner_mutex);
+
+		/*
+		 * The defragger has dealt with the R/O remount, needn't
+		 * do anything special here.
+		 */
+		btrfs_run_defrag_inodes(root->fs_info);
+sleep:
 		if (!try_to_freeze() && !again) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (!kthread_should_stop())
-- 
1.8.1.4

