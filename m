Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50564 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab2EQL7L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 07:59:11 -0400
Received: from mailserver.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q4HBx8Wa005987
	for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2012 19:59:09 +0800
Message-ID: <4FB4E7B4.7060006@cn.fujitsu.com>
Date: Thu, 17 May 2012 19:57:40 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/5] Btrfs: pause/recover the space balance when doing remount
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

pause the space balance threads when remounting the fs to be readonly,
and recover it when remounting it from r/o to r/w

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/super.c   |    9 ++++++++-
 fs/btrfs/volumes.c |    8 +++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 7deb00e..ea17f0a 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1148,6 +1148,9 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 	if (*flags & MS_RDONLY) {
 		sb->s_flags |= MS_RDONLY;
 
+		/* pause restriper - we want to resume on remount to r/w */
+		btrfs_pause_balance(root->fs_info);
+
 		ret = btrfs_commit_super(root);
 		if (ret)
 			goto restore;
@@ -1174,7 +1177,10 @@ static int btrfs_remount(struct super_block *sb, int *flags, char *data)
 		if (ret)
 			goto restore;
 
-		sb->s_flags &= ~MS_RDONLY;
+		if (sb->s_flags & MS_RDONLY) {
+			sb->s_flags &= ~MS_RDONLY;
+			btrfs_recover_balance(fs_info->tree_root);
+		}
 	}
 
 	return 0;
@@ -1190,6 +1196,7 @@ restore:
 	fs_info->alloc_start = old_alloc_start;
 	fs_info->thread_pool_size = old_thread_pool_size;
 	fs_info->metadata_ratio = old_metadata_ratio;
+
 	return ret;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 91da8a2..c536d52 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2833,7 +2833,13 @@ static int balance_kthread(void *data)
 	mutex_lock(&fs_info->volume_mutex);
 	mutex_lock(&fs_info->balance_mutex);
 
-	set_balance_control(bctl);
+	if (fs_info->balance_ctl) {
+		kfree(bctl);
+		bctl = fs_info->balance_ctl;
+		bctl->flags = bctl->flags | BTRFS_BALANCE_RESUME;
+	} else {
+		set_balance_control(bctl);
+	}
 
 	if (btrfs_test_opt(fs_info->tree_root, SKIP_BALANCE)) {
 		printk(KERN_INFO "btrfs: force skipping balance\n");
-- 
1.7.6.5
