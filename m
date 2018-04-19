Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55279 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753903AbeDSQfx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Apr 2018 12:35:53 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 689BDAC76
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Apr 2018 16:35:52 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2 05/16] btrfs: move volume_mutex to callers of btrfs_rm_device
Date: Thu, 19 Apr 2018 18:33:21 +0200
Message-Id: <708d4919296684fbb7528ec0dc1bf146c1d763be.1524146555.git.dsterba@suse.com>
In-Reply-To: <cover.1524146555.git.dsterba@suse.com>
References: <cover.1524146555.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move locking and unlocking next to the BTRFS_FS_EXCL_OP bit manipulation
so it's obvious that the two happen at the same time.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ioctl.c   | 4 ++++
 fs/btrfs/volumes.c | 2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ac85e07f567b..b93dea445802 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2674,6 +2674,7 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 		ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
 		goto out;
 	}
+	mutex_lock(&fs_info->volume_mutex);
 
 	if (vol_args->flags & BTRFS_DEVICE_SPEC_BY_ID) {
 		ret = btrfs_rm_device(fs_info, NULL, vol_args->devid);
@@ -2681,6 +2682,7 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 		vol_args->name[BTRFS_SUBVOL_NAME_MAX] = '\0';
 		ret = btrfs_rm_device(fs_info, vol_args->name, 0);
 	}
+	mutex_unlock(&fs_info->volume_mutex);
 	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 
 	if (!ret) {
@@ -2716,6 +2718,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 		ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
 		goto out_drop_write;
 	}
+	mutex_lock(&fs_info->volume_mutex);
 
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args)) {
@@ -2730,6 +2733,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 		btrfs_info(fs_info, "disk deleted %s", vol_args->name);
 	kfree(vol_args);
 out:
+	mutex_unlock(&fs_info->volume_mutex);
 	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 out_drop_write:
 	mnt_drop_write_file(file);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index df2d6d06e014..e0bd181dc9e0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1932,7 +1932,6 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	u64 num_devices;
 	int ret = 0;
 
-	mutex_lock(&fs_info->volume_mutex);
 	mutex_lock(&uuid_mutex);
 
 	num_devices = fs_info->fs_devices->num_devices;
@@ -2048,7 +2047,6 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 
 out:
 	mutex_unlock(&uuid_mutex);
-	mutex_unlock(&fs_info->volume_mutex);
 	return ret;
 
 error_undo:
-- 
2.16.2

