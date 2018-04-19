Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55369 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754010AbeDSQgO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 12:36:14 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 442C2AC76
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 16:36:13 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2 14/16] btrfs: drop lock parameter from update_ioctl_balance_args and rename
Date: Thu, 19 Apr 2018 18:33:41 +0200
Message-Id: <afbad2279a57354e0b71fa20fdcb4e35d0ca0211.1524146556.git.dsterba@suse.com>
In-Reply-To: <cover.1524146555.git.dsterba@suse.com>
References: <cover.1524146555.git.dsterba@suse.com>
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
index 3dfd5ab2807b..b85d2a71136d 100644
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
index 9e48a4654d3a..1abe0fc5c105 100644
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

