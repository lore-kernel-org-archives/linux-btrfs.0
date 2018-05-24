Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:43093 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S971632AbeEXVlo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 May 2018 17:41:44 -0400
Received: by mail-pl0-f65.google.com with SMTP id c41-v6so1822318plj.10
        for <linux-btrfs@vger.kernel.org>; Thu, 24 May 2018 14:41:43 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [RFC PATCH v4 3/6] Btrfs: push EXCL_OP set into btrfs_rm_device()
Date: Thu, 24 May 2018 14:41:27 -0700
Message-Id: <d87c19f340768141b564cec3af1deda6e921eaa5.1527197312.git.osandov@fb.com>
In-Reply-To: <cover.1527197312.git.osandov@fb.com>
References: <cover.1527197312.git.osandov@fb.com>
In-Reply-To: <cover.1527197312.git.osandov@fb.com>
References: <cover.1527197312.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

btrfs_ioctl_rm_dev() and btrfs_ioctl_rm_dev_v2() both manipulate this
bit. Let's move it into the common btrfs_rm_device(), which also makes
the following change to deal with swap files easier.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/ioctl.c   | 13 -------------
 fs/btrfs/volumes.c |  4 ++++
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9af3be96099f..82be4a94334b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3091,18 +3091,12 @@ static long btrfs_ioctl_rm_dev_v2(struct file *file, void __user *arg)
 		goto out;
 	}
 
-	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
-		ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
-		goto out;
-	}
-
 	if (vol_args->flags & BTRFS_DEVICE_SPEC_BY_ID) {
 		ret = btrfs_rm_device(fs_info, NULL, vol_args->devid);
 	} else {
 		vol_args->name[BTRFS_SUBVOL_NAME_MAX] = '\0';
 		ret = btrfs_rm_device(fs_info, vol_args->name, 0);
 	}
-	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 
 	if (!ret) {
 		if (vol_args->flags & BTRFS_DEVICE_SPEC_BY_ID)
@@ -3133,11 +3127,6 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 	if (ret)
 		return ret;
 
-	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
-		ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
-		goto out_drop_write;
-	}
-
 	vol_args = memdup_user(arg, sizeof(*vol_args));
 	if (IS_ERR(vol_args)) {
 		ret = PTR_ERR(vol_args);
@@ -3151,8 +3140,6 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
 		btrfs_info(fs_info, "disk deleted %s", vol_args->name);
 	kfree(vol_args);
 out:
-	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
-out_drop_write:
 	mnt_drop_write_file(file);
 
 	return ret;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index b6757b53c297..9cfac177214f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1951,6 +1951,9 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 	u64 num_devices;
 	int ret = 0;
 
+	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags))
+		return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
+
 	mutex_lock(&uuid_mutex);
 
 	num_devices = fs_devices->num_devices;
@@ -2069,6 +2072,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 
 out:
 	mutex_unlock(&uuid_mutex);
+	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
 	return ret;
 
 error_undo:
-- 
2.17.0

