From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v3 1/3] Btrfs: Refactor btrfs_ioctl_snap_create()
Date: Thu, 23 Dec 2010 16:15:34 +0800
Message-ID: <4D130526.1010503@cn.fujitsu.com>
References: <4D130514.9080704@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D130514.9080704@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Split it into two functions for two different ioctls, since they
share no common code.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   84 +++++++++++++++++++++++++----------------------------
 1 files changed, 40 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f87552a..02554e1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -946,58 +946,54 @@ out:
 }
 
 static noinline int btrfs_ioctl_snap_create(struct file *file,
-					    void __user *arg, int subvol,
-					    int v2)
+					    void __user *arg, int subvol)
 {
-	struct btrfs_ioctl_vol_args *vol_args = NULL;
-	struct btrfs_ioctl_vol_args_v2 *vol_args_v2 = NULL;
-	char *name;
-	u64 fd;
+	struct btrfs_ioctl_vol_args *vol_args;
 	int ret;
 
-	if (v2) {
-		u64 transid = 0;
-		u64 *ptr = NULL;
+	vol_args = memdup_user(arg, sizeof(*vol_args));
+	if (IS_ERR(vol_args))
+		return PTR_ERR(vol_args);
+	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
 
-		vol_args_v2 = memdup_user(arg, sizeof(*vol_args_v2));
-		if (IS_ERR(vol_args_v2))
-			return PTR_ERR(vol_args_v2);
+	ret = btrfs_ioctl_snap_create_transid(file, vol_args->name,
+					      vol_args->fd, subvol, NULL);
 
-		if (vol_args_v2->flags & ~BTRFS_SUBVOL_CREATE_ASYNC) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		name = vol_args_v2->name;
-		fd = vol_args_v2->fd;
-		vol_args_v2->name[BTRFS_SUBVOL_NAME_MAX] = '\0';
+	kfree(vol_args);
+	return ret;
+}
 
-		if (vol_args_v2->flags & BTRFS_SUBVOL_CREATE_ASYNC)
-			ptr = &transid;
+static noinline int btrfs_ioctl_snap_create_v2(struct file *file,
+					       void __user *arg, int subvol)
+{
+	struct btrfs_ioctl_vol_args_v2 *vol_args;
+	int ret;
+	u64 transid = 0;
+	u64 *ptr = NULL;
 
-		ret = btrfs_ioctl_snap_create_transid(file, name, fd,
-						      subvol, ptr);
+	vol_args = memdup_user(arg, sizeof(*vol_args));
+	if (IS_ERR(vol_args))
+		return PTR_ERR(vol_args);
+	vol_args->name[BTRFS_SUBVOL_NAME_MAX] = '\0';
 
-		if (ret == 0 && ptr &&
-		    copy_to_user(arg +
-				 offsetof(struct btrfs_ioctl_vol_args_v2,
-					  transid), ptr, sizeof(*ptr)))
-			ret = -EFAULT;
-	} else {
-		vol_args = memdup_user(arg, sizeof(*vol_args));
-		if (IS_ERR(vol_args))
-			return PTR_ERR(vol_args);
-		name = vol_args->name;
-		fd = vol_args->fd;
-		vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
-
-		ret = btrfs_ioctl_snap_create_transid(file, name, fd,
-						      subvol, NULL);
+	if (vol_args->flags & ~BTRFS_SUBVOL_CREATE_ASYNC) {
+		ret = -EINVAL;
+		goto out;
 	}
+
+	if (vol_args->flags & BTRFS_SUBVOL_CREATE_ASYNC)
+		ptr = &transid;
+
+	ret = btrfs_ioctl_snap_create_transid(file, vol_args->name,
+					      vol_args->fd, subvol, ptr);
+
+	if (ret == 0 && ptr &&
+	    copy_to_user(arg +
+			 offsetof(struct btrfs_ioctl_vol_args_v2,
+				  transid), ptr, sizeof(*ptr)))
+		ret = -EFAULT;
 out:
 	kfree(vol_args);
-	kfree(vol_args_v2);
-
 	return ret;
 }
 
@@ -2257,11 +2253,11 @@ long btrfs_ioctl(struct file *file, unsigned int
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

