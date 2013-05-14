Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31700 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab3ENKUx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 06:20:53 -0400
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH 2/4] Btrfs: make the cleaner complete early when the fs is going to be umounted
Date: Tue, 14 May 2013 18:20:41 +0800
Message-Id: <1368526843-18000-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1368526843-18000-1-git-send-email-miaox@cn.fujitsu.com>
References: <1368526843-18000-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index cb2bfd1..927da1a 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1677,12 +1677,14 @@ static void end_workqueue_fn(struct btrfs_work *work)
 }
 
 /*
- * If we remount the fs to be R/O, the cleaner needn't do anything except
- * sleeping. This function is used to check the status of the fs.
+ * If we remount the fs to be R/O or umount the fs, the cleaner needn't do
+ * anything except sleeping. This function is used to check the status of
+ * the fs.
  */
 static inline int need_cleaner_sleep(struct btrfs_root *root)
 {
-	return root->fs_info->sb->s_flags & MS_RDONLY;
+	return (root->fs_info->sb->s_flags & MS_RDONLY ||
+		btrfs_fs_closing(root->fs_info));
 }
 
 static int cleaner_kthread(void *arg)
@@ -1705,8 +1707,8 @@ static int cleaner_kthread(void *arg)
 		mutex_unlock(&root->fs_info->cleaner_mutex);
 
 		/*
-		 * The defragger has dealt with the R/O remount, needn't
-		 * do anything special here.
+		 * The defragger has dealt with the R/O remount and umount,
+		 * needn't do anything special here.
 		 */
 		btrfs_run_defrag_inodes(root->fs_info);
 sleep:
-- 
1.8.1.4

