Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751201AbcLBFHr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Dec 2016 00:07:47 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DBB17ABD3
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Dec 2016 05:07:45 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 03/18] btrfs: btrfs_init_new_device should use fs_info->dev_root
Date: Fri,  2 Dec 2016 00:07:23 -0500
Message-Id: <1480655258-15400-4-git-send-email-jeffm@suse.com>
In-Reply-To: <1480655258-15400-1-git-send-email-jeffm@suse.com>
References: <1480655258-15400-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

btrfs_init_new_device only uses the root passed in via the ioctl to
start the transaction.  Nothing else that happens is related to whatever
root the user used to initiate the ioctl.  We can drop the root requirement
and just use fs_info->dev_root instead.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/ioctl.c   | 2 +-
 fs/btrfs/volumes.c | 3 ++-
 fs/btrfs/volumes.h | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 67c37fd..5b21a9b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2672,7 +2672,7 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
 	}
 
 	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
-	ret = btrfs_init_new_device(root, vol_args->name);
+	ret = btrfs_init_new_device(root->fs_info, vol_args->name);
 
 	if (!ret)
 		btrfs_info(root->fs_info, "disk added %s",vol_args->name);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ed868a0..f336f07 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2310,8 +2310,9 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
+int btrfs_init_new_device(struct btrfs_fs_info *fs_info, char *device_path)
 {
+	struct btrfs_root *root = fs_info->dev_root;
 	struct request_queue *q;
 	struct btrfs_trans_handle *trans;
 	struct btrfs_device *device;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 471a619..0c8e77b 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -439,7 +439,7 @@ int btrfs_grow_device(struct btrfs_trans_handle *trans,
 struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 				       u8 *uuid, u8 *fsid);
 int btrfs_shrink_device(struct btrfs_device *device, u64 new_size);
-int btrfs_init_new_device(struct btrfs_root *root, char *path);
+int btrfs_init_new_device(struct btrfs_fs_info *fs_info, char *path);
 int btrfs_init_dev_replace_tgtdev(struct btrfs_root *root, char *device_path,
 				  struct btrfs_device *srcdev,
 				  struct btrfs_device **device_out);
-- 
2.7.1

