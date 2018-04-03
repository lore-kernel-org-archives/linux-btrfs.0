Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35633 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753155AbeDCShB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Apr 2018 14:37:01 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B03DBABC9
        for <linux-btrfs@vger.kernel.org>; Tue,  3 Apr 2018 18:37:00 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 14/16] btrfs: drop lock parameter from update_ioctl_balance_args and rename
Date: Tue,  3 Apr 2018 20:34:33 +0200
Message-Id: <e63d2b31be21a19ab340c185b2ec2f0489cd4011.1522780026.git.dsterba@suse.com>
In-Reply-To: <cover.1522780026.git.dsterba@suse.com>
References: <cover.1522780026.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The parameter controls locking of the stats part but we can lock it
unconditionally, as this only happens once when balance starts. This is
not performance critical.

Add the prefix for an exported function.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h   |  2 +-
 fs/btrfs/ioctl.c   | 14 +++++---------
 fs/btrfs/volumes.c |  2 +-
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index fda94a264eb7..7ac2e69bfb03 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3258,7 +3258,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		      u64 newer_than, unsigned long max_pages);
 void btrfs_get_block_group_info(struct list_head *groups_list,
 				struct btrfs_ioctl_space_info *space);
-void update_ioctl_balance_args(struct btrfs_fs_info *fs_info, int lock,
+void btrfs_update_ioctl_balance_args(struct btrfs_fs_info *fs_info,
 			       struct btrfs_ioctl_balance_args *bargs);
 ssize_t btrfs_dedupe_file_range(struct file *src_file, u64 loff, u64 olen,
 			   struct file *dst_file, u64 dst_loff);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e6f21f30416a..45759f1ea438 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4499,7 +4499,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
-void update_ioctl_balance_args(struct btrfs_fs_info *fs_info, int lock,
+void btrfs_update_ioctl_balance_args(struct btrfs_fs_info *fs_info,
 			       struct btrfs_ioctl_balance_args *bargs)
 {
 	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
@@ -4517,13 +4517,9 @@ void update_ioctl_balance_args(struct btrfs_fs_info *fs_info, int lock,
 	memcpy(&bargs->meta, &bctl->meta, sizeof(bargs->meta));
 	memcpy(&bargs->sys, &bctl->sys, sizeof(bargs->sys));
 
-	if (lock) {
-		spin_lock(&fs_info->balance_lock);
-		memcpy(&bargs->stat, &bctl->stat, sizeof(bargs->stat));
-		spin_unlock(&fs_info->balance_lock);
-	} else {
-		memcpy(&bargs->stat, &bctl->stat, sizeof(bargs->stat));
-	}
+	spin_lock(&fs_info->balance_lock);
+	memcpy(&bargs->stat, &bctl->stat, sizeof(bargs->stat));
+	spin_unlock(&fs_info->balance_lock);
 }
 
 static long btrfs_ioctl_balance(struct file *file, void __user *arg)
@@ -4709,7 +4705,7 @@ static long btrfs_ioctl_balance_progress(struct btrfs_fs_info *fs_info,
 		goto out;
 	}
 
-	update_ioctl_balance_args(fs_info, 1, bargs);
+	btrfs_update_ioctl_balance_args(fs_info, bargs);
 
 	if (copy_to_user(arg, bargs, sizeof(*bargs)))
 		ret = -EFAULT;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2956e7b4cb9f..4b7d54abfa34 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3897,7 +3897,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 
 	if (bargs) {
 		memset(bargs, 0, sizeof(*bargs));
-		update_ioctl_balance_args(fs_info, 0, bargs);
+		btrfs_update_ioctl_balance_args(fs_info, bargs);
 	}
 
 	if ((ret && ret != -ECANCELED && ret != -ENOSPC) ||
-- 
2.16.2

