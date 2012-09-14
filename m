Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:44528 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758624Ab2INRzM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 13:55:12 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id S1ADEk7J6cZFPIt7 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 11:55:11 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: remove our ->freeze_fs and ->unfreeze_fs
Date: Fri, 14 Sep 2012 14:00:37 -0400
Message-ID: <1347645637-1616-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We do not need to do anything special to freeze or unfreeze, it's all taken
care of by the generic work, and what we currently have is wrong anyway
since we shouldn't be returnning to userspace with mutexes held anyway.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/super.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 5aa3b81..fa80e2d 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1509,22 +1509,6 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 	return ret;
 }
 
-static int btrfs_freeze(struct super_block *sb)
-{
-	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
-	mutex_lock(&fs_info->transaction_kthread_mutex);
-	mutex_lock(&fs_info->cleaner_mutex);
-	return 0;
-}
-
-static int btrfs_unfreeze(struct super_block *sb)
-{
-	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
-	mutex_unlock(&fs_info->cleaner_mutex);
-	mutex_unlock(&fs_info->transaction_kthread_mutex);
-	return 0;
-}
-
 static int btrfs_show_devname(struct seq_file *m, struct dentry *root)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(root->d_sb);
@@ -1570,8 +1554,6 @@ static const struct super_operations btrfs_super_ops = {
 	.destroy_inode	= btrfs_destroy_inode,
 	.statfs		= btrfs_statfs,
 	.remount_fs	= btrfs_remount,
-	.freeze_fs	= btrfs_freeze,
-	.unfreeze_fs	= btrfs_unfreeze,
 };
 
 static const struct file_operations btrfs_ctl_fops = {
-- 
1.7.7.6

