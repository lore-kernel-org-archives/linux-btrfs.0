From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v2 2/5] Btrfs: Refactor btrfs_ioctl_snap_create()
Date: Thu, 09 Dec 2010 17:10:17 +0800
Message-ID: <4D009CF9.1070208@cn.fujitsu.com>
References: <4D009CD2.3060805@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D009CD2.3060805@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Split it into two functions for two different ioctls, since they
share no common code.

Also fix a memory leak in a failure path.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   71 +++++++++++++++++++++++++++--------------------------
 1 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index dc953bc..5ecd532 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -946,54 +946,55 @@ out:
 }
 
 static noinline int btrfs_ioctl_snap_create(struct file *file,
-					    void __user *arg, int subvol,
-					    bool v2)
+					    void __user *arg, int subvol)
 {
-	struct btrfs_ioctl_vol_args *vol_args = NULL;
-	struct btrfs_ioctl_vol_args_v2 *vol_args_v2 = NULL;
-	char *name;
-	u64 fd;
+	struct btrfs_ioctl_vol_args *vol_args;
+	int ret;
+
+	vol_args = memdup_user(arg, sizeof(*vol_args));
+	if (IS_ERR(vol_args))
+		return PTR_ERR(vol_args);
+	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
+
+	ret = btrfs_ioctl_snap_create_transid(file, vol_args->name,
+					      vol_args->fd, subvol, NULL);
+
+	kfree(vol_args);
+	return ret;
+}
+
+static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
+					       void __user *arg, int subvol)
+{
+	struct btrfs_ioctl_vol_args_v2 *vol_args;
 	u64 transid = 0;
 	bool async = false;
 	int ret;
 
-	if (v2) {
-		vol_args_v2 = memdup_user(arg, sizeof(*vol_args_v2));
-		if (IS_ERR(vol_args_v2))
-			return PTR_ERR(vol_args_v2);
-
-		if (vol_args_v2->flags & ~BTRFS_SUBVOL_CREATE_SNAP_ASYNC) {
-			ret = -EINVAL;
-			goto out;
-		}
+	vol_args = memdup_user(arg, sizeof(*vol_args));
+	if (IS_ERR(vol_args))
+		return PTR_ERR(vol_args);
 
-		name = vol_args_v2->name;
-		fd = vol_args_v2->fd;
-		vol_args_v2->name[BTRFS_SUBVOL_NAME_MAX] = '\0';
-		if (vol_args_v2->flags & BTRFS_SUBVOL_CREATE_SNAP_ASYNC)
-			async = true;
-	} else {
-		vol_args = memdup_user(arg, sizeof(*vol_args));
-		if (IS_ERR(vol_args))
-			return PTR_ERR(vol_args);
-		name = vol_args->name;
-		fd = vol_args->fd;
-		vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
+	if (vol_args->flags & ~BTRFS_SUBVOL_CREATE_SNAP_ASYNC) {
+		ret = -EINVAL;
+		goto out;
 	}
 
-	ret = btrfs_ioctl_snap_create_transid(file, name, fd,
-					      subvol, &transid);
+	vol_args->name[BTRFS_SUBVOL_NAME_MAX] = '\0';
+	if (vol_args->flags & BTRFS_SUBVOL_CREATE_SNAP_ASYNC)
+		async = true;
+
+	ret = btrfs_ioctl_snap_create_transid(file, vol_args->name,
+					      vol_args->fd, subvol, &transid);
 
 	if (!ret && async) {
 		if (copy_to_user(arg +
 				offsetof(struct btrfs_ioctl_vol_args_v2,
 				transid), &transid, sizeof(transid)))
-			return -EFAULT;
+			ret = -EFAULT;
 	}
 out:
 	kfree(vol_args);
-	kfree(vol_args_v2);
-
 	return ret;
 }
 
@@ -2253,11 +2254,11 @@ long btrfs_ioctl(struct file *file, unsigned int
 	case FS_IOC_GETVERSION:
 		return btrfs_ioctl_getversion(file, argp);
 	case BTRFS_IOC_SNAP_CREATE:
-		return btrfs_ioctl_snap_create(file, argp, 0, 0);
+		return btrfs_ioctl_snap_create(file, argp, 0);
 	case BTRFS_IOC_SNAP_CREATE_V2:
-		return btrfs_ioctl_snap_create(file, argp, 0, 1);
+		return btrfs_ioctl_snap_create_v2(file, argp, 0);
 	case BTRFS_IOC_SUBVOL_CREATE:
-		return btrfs_ioctl_snap_create(file, argp, 1, 0);
+		return btrfs_ioctl_snap_create(file, argp, 1);
 	case BTRFS_IOC_SNAP_DESTROY:
 		return btrfs_ioctl_snap_destroy(file, argp);
 	case BTRFS_IOC_DEFAULT_SUBVOL:
-- 
1.6.3

