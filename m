From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v2 1/5] Btrfs: Make async snapshot ioctl more generic
Date: Thu, 09 Dec 2010 17:10:00 +0800
Message-ID: <4D009CE8.6030208@cn.fujitsu.com>
References: <4D009CD2.3060805@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D009CD2.3060805@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

So we don't have to add new structures as we create more ioctls
for snapshots/subvolumes.

Now to create async snapshot, set BTRFS_SUBVOL_CREATE_SNAP_ASYNC bit
of vol_arg_v2->flags, and then call ioctl(BTRFS_IOCT_SNAP_CREATE_V2).

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |   34 +++++++++++++++++++++-------------
 fs/btrfs/ioctl.h |   14 +++++++++-----
 2 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f1c9bb4..dc953bc 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -947,23 +947,31 @@ out:
 
 static noinline int btrfs_ioctl_snap_create(struct file *file,
 					    void __user *arg, int subvol,
-					    int async)
+					    bool v2)
 {
 	struct btrfs_ioctl_vol_args *vol_args = NULL;
-	struct btrfs_ioctl_async_vol_args *async_vol_args = NULL;
+	struct btrfs_ioctl_vol_args_v2 *vol_args_v2 = NULL;
 	char *name;
 	u64 fd;
 	u64 transid = 0;
+	bool async = false;
 	int ret;
 
-	if (async) {
-		async_vol_args = memdup_user(arg, sizeof(*async_vol_args));
-		if (IS_ERR(async_vol_args))
-			return PTR_ERR(async_vol_args);
+	if (v2) {
+		vol_args_v2 = memdup_user(arg, sizeof(*vol_args_v2));
+		if (IS_ERR(vol_args_v2))
+			return PTR_ERR(vol_args_v2);
 
-		name = async_vol_args->name;
-		fd = async_vol_args->fd;
-		async_vol_args->name[BTRFS_SNAPSHOT_NAME_MAX] = '\0';
+		if (vol_args_v2->flags & ~BTRFS_SUBVOL_CREATE_SNAP_ASYNC) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		name = vol_args_v2->name;
+		fd = vol_args_v2->fd;
+		vol_args_v2->name[BTRFS_SUBVOL_NAME_MAX] = '\0';
+		if (vol_args_v2->flags & BTRFS_SUBVOL_CREATE_SNAP_ASYNC)
+			async = true;
 	} else {
 		vol_args = memdup_user(arg, sizeof(*vol_args));
 		if (IS_ERR(vol_args))
@@ -978,13 +986,13 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 
 	if (!ret && async) {
 		if (copy_to_user(arg +
-				offsetof(struct btrfs_ioctl_async_vol_args,
+				offsetof(struct btrfs_ioctl_vol_args_v2,
 				transid), &transid, sizeof(transid)))
 			return -EFAULT;
 	}
-
+out:
 	kfree(vol_args);
-	kfree(async_vol_args);
+	kfree(vol_args_v2);
 
 	return ret;
 }
@@ -2246,7 +2254,7 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_getversion(file, argp);
 	case BTRFS_IOC_SNAP_CREATE:
 		return btrfs_ioctl_snap_create(file, argp, 0, 0);
-	case BTRFS_IOC_SNAP_CREATE_ASYNC:
+	case BTRFS_IOC_SNAP_CREATE_V2:
 		return btrfs_ioctl_snap_create(file, argp, 0, 1);
 	case BTRFS_IOC_SUBVOL_CREATE:
 		return btrfs_ioctl_snap_create(file, argp, 1, 0);
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 17c99eb..9affc49 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -30,11 +30,15 @@ struct btrfs_ioctl_vol_args {
 	char name[BTRFS_PATH_NAME_MAX + 1];
 };
 
-#define BTRFS_SNAPSHOT_NAME_MAX 4079
-struct btrfs_ioctl_async_vol_args {
+#define BTRFS_SUBVOL_CREATE_SNAP_ASYNC	(1ULL << 0)
+
+#define BTRFS_SUBVOL_NAME_MAX 4039
+struct btrfs_ioctl_vol_args_v2 {
 	__s64 fd;
 	__u64 transid;
-	char name[BTRFS_SNAPSHOT_NAME_MAX + 1];
+	__u64 flags;
+	__u64 unused[4];
+	char name[BTRFS_SUBVOL_NAME_MAX + 1];
 };
 
 #define BTRFS_INO_LOOKUP_PATH_MAX 4080
@@ -187,6 +191,6 @@ struct btrfs_ioctl_space_args {
 				    struct btrfs_ioctl_space_args)
 #define BTRFS_IOC_START_SYNC _IOR(BTRFS_IOCTL_MAGIC, 24, __u64)
 #define BTRFS_IOC_WAIT_SYNC  _IOW(BTRFS_IOCTL_MAGIC, 22, __u64)
-#define BTRFS_IOC_SNAP_CREATE_ASYNC _IOW(BTRFS_IOCTL_MAGIC, 23, \
-				   struct btrfs_ioctl_async_vol_args)
+#define BTRFS_IOC_SNAP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 23, \
+				   struct btrfs_ioctl_vol_args_v2)
 #endif
-- 
1.6.3

