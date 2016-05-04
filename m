Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbcEDMLH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 May 2016 08:11:07 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@gmail.com, David Sterba <dsterba@suse.cz>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH v2] btrfs: ioctl: reorder exclusive op check in RM_DEV
Date: Wed,  4 May 2016 14:10:47 +0200
Message-Id: <1462363847-25665-1-git-send-email-dsterba@suse.com>
In-Reply-To: <1462354346-17654-1-git-send-email-dsterba@suse.com>
References: <1462354346-17654-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: David Sterba <dsterba@suse.cz>

Move the op exclusivity check before the other code (same as in
ADD_DEV).

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5a23806ae418..70e9687f1d59 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2680,32 +2680,31 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 	if (ret)
 		return ret;
 
-	vol_args = memdup_user(arg, sizeof(*vol_args));
-	if (IS_ERR(vol_args)) {
-		ret = PTR_ERR(vol_args);
-		goto err_drop;
-	}
-
-	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
-
 	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
 			1)) {
 		ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
+		goto out_drop_write;
+	}
+
+	vol_args = memdup_user(arg, sizeof(*vol_args));
+	if (IS_ERR(vol_args)) {
+		ret = PTR_ERR(vol_args);
 		goto out;
 	}
 
+	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 	mutex_lock(&root->fs_info->volume_mutex);
 	ret = btrfs_rm_device(root, vol_args->name);
 	mutex_unlock(&root->fs_info->volume_mutex);
-	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
 
 	if (!ret)
 		btrfs_info(root->fs_info, "disk deleted %s",vol_args->name);
-
-out:
 	kfree(vol_args);
-err_drop:
+out:
+	atomic_set(&root->fs_info->mutually_exclusive_operation_running, 0);
+out_drop_write:
 	mnt_drop_write_file(file);
+
 	return ret;
 }
 
-- 
2.7.1

