From: Sage Weil <sage@newdream.net>
Subject: [PATCH] Btrfs: fix sync subvol/snapshot creation
Date: Thu,  9 Dec 2010 16:36:28 -0800
Message-ID: <1291941388-17050-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We were incorrectly taking the async path even for the sync ioctls by
passing in &transid unconditionally.

There's ample room for further cleanup here, but this keeps the fix simple.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 41614c3..4c2d7c4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -970,6 +970,15 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 		name = async_vol_args->name;
 		fd = async_vol_args->fd;
 		async_vol_args->name[BTRFS_SNAPSHOT_NAME_MAX] = '\0';
+
+		ret = btrfs_ioctl_snap_create_transid(file, name, fd,
+						      subvol, &transid);
+
+		if (ret == 0 &&
+		    copy_to_user(arg +
+				 offsetof(struct btrfs_ioctl_async_vol_args,
+					  transid), &transid, sizeof(transid)))
+			ret = -EFAULT;
 	} else {
 		vol_args = memdup_user(arg, sizeof(*vol_args));
 		if (IS_ERR(vol_args))
@@ -977,16 +986,9 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 		name = vol_args->name;
 		fd = vol_args->fd;
 		vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
-	}
-
-	ret = btrfs_ioctl_snap_create_transid(file, name, fd,
-					      subvol, &transid);
 
-	if (!ret && async) {
-		if (copy_to_user(arg +
-				offsetof(struct btrfs_ioctl_async_vol_args,
-				transid), &transid, sizeof(transid)))
-			return -EFAULT;
+		ret = btrfs_ioctl_snap_create_transid(file, name, fd,
+						      subvol, NULL);
 	}
 
 	kfree(vol_args);
-- 
1.6.6.1

