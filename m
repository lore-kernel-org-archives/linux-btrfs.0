Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64127 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab3ENKUy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 06:20:54 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 4/4] Btrfs: make the snap/subv deletion end more early when the fs is R/O
Date: Tue, 14 May 2013 18:20:43 +0800
Message-Id: <1368526843-18000-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368526843-18000-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368526843-18000-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The snapshot/subvolume deletion might spend lots of time, it would make
the remount task wait for a long time. This patch improve this problem,
we will break the deletion if the fs is remounted to be R/O. It will make
the users happy.

Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h       | 12 ++++++++++++
 fs/btrfs/disk-io.c     | 15 ++-------------
 fs/btrfs/extent-tree.c |  2 +-
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index df9824b..067233f 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3318,6 +3318,18 @@ static inline int btrfs_fs_closing(struct btrfs_fs_info *fs_info)
 	smp_mb();
 	return fs_info->closing;
 }
+
+/*
+ * If we remount the fs to be R/O or umount the fs, the cleaner needn't do
+ * anything except sleeping. This function is used to check the status of
+ * the fs.
+ */
+static inline int btrfs_need_cleaner_sleep(struct btrfs_root *root)
+{
+	return (root->fs_info->sb->s_flags & MS_RDONLY ||
+		btrfs_fs_closing(root->fs_info));
+}
+
 static inline void free_fs_info(struct btrfs_fs_info *fs_info)
 {
 	kfree(fs_info->balance_ctl);
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c69ff46..78e2dfb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1676,17 +1676,6 @@ static void end_workqueue_fn(struct btrfs_work *work)
 	bio_endio(bio, error);
 }
 
-/*
- * If we remount the fs to be R/O or umount the fs, the cleaner needn't do
- * anything except sleeping. This function is used to check the status of
- * the fs.
- */
-static inline int need_cleaner_sleep(struct btrfs_root *root)
-{
-	return (root->fs_info->sb->s_flags & MS_RDONLY ||
-		btrfs_fs_closing(root->fs_info));
-}
-
 static int cleaner_kthread(void *arg)
 {
 	struct btrfs_root *root = arg;
@@ -1696,7 +1685,7 @@ static int cleaner_kthread(void *arg)
 		again = 0;
 
 		/* Make the cleaner go to sleep early. */
-		if (need_cleaner_sleep(root))
+		if (btrfs_need_cleaner_sleep(root))
 			goto sleep;
 
 		if (!mutex_trylock(&root->fs_info->cleaner_mutex))
@@ -1706,7 +1695,7 @@ static int cleaner_kthread(void *arg)
 		 * Avoid the problem that we change the status of the fs
 		 * during the above check and trylock.
 		 */
-		if (need_cleaner_sleep(root)) {
+		if (btrfs_need_cleaner_sleep(root)) {
 			mutex_unlock(&root->fs_info->cleaner_mutex);
 			goto sleep;
 		}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fbeb0c0..455117a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7378,7 +7378,7 @@ int btrfs_drop_snapshot(struct btrfs_root *root,
 	wc->reada_count = BTRFS_NODEPTRS_PER_BLOCK(root);
 
 	while (1) {
-		if (!for_reloc && btrfs_fs_closing(root->fs_info)) {
+		if (!for_reloc && btrfs_need_cleaner_sleep(root)) {
 			pr_debug("btrfs: drop snapshot early exit\n");
 			err = -EAGAIN;
 			goto out_end_trans;
-- 
1.8.1.4

