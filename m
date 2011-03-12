From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH v3 6/6] btrfs: new ioctls for scrub
Date: Sat, 12 Mar 2011 15:50:45 +0100
Message-ID: <18529483c1d60c721bfb1375fbf324913acb6d78.1299941055.git.sensille@gmx.net>
References: <cover.1299941055.git.sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1299941055.git.sensille@gmx.net>
In-Reply-To: <cover.1299941055.git.sensille@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

From: Jan Schmidt <list.btrfs@jan-o-sch.net>

adds ioctls necessary to start and cancel scrubs, to get current
progress and to get info about devices to be scrubbed.
Note that the scrub is done per-device and that the ioctl only
returns after the scrub for this devices is finished or has been
canceled.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/ctree.h |    2 -
 fs/btrfs/ioctl.c |  131 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/ioctl.h |   38 ++++++++++++++++
 3 files changed, 169 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 888125e..2a48838 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -189,7 +189,6 @@ struct btrfs_mapping_tree {
 	struct extent_map_tree map_tree;
 };
 
-#define BTRFS_UUID_SIZE 16
 struct btrfs_dev_item {
 	/* the internal btrfs device id */
 	__le64 devid;
@@ -296,7 +295,6 @@ static inline unsigned long btrfs_chunk_item_size(int num_stripes)
 		sizeof(struct btrfs_stripe) * (num_stripes - 1);
 }
 
-#define BTRFS_FSID_SIZE 16
 #define BTRFS_HEADER_FLAG_WRITTEN	(1ULL << 0)
 #define BTRFS_HEADER_FLAG_RELOC		(1ULL << 1)
 
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5fdb2ab..534e87e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1718,6 +1718,75 @@ static long btrfs_ioctl_rm_dev(struct btrfs_root *root, void __user *arg)
 	return ret;
 }
 
+static long btrfs_ioctl_fs_info(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_ioctl_fs_info_args fi_args;
+	struct btrfs_device *device;
+	struct btrfs_device *next;
+	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	fi_args.num_devices = fs_devices->num_devices;
+	fi_args.max_id = 0;
+	memcpy(&fi_args.fsid, root->fs_info->fsid, sizeof(fi_args.fsid));
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
+		if (device->devid > fi_args.max_id)
+			fi_args.max_id = device->devid;
+	}
+	mutex_unlock(&fs_devices->device_list_mutex);
+
+	if (copy_to_user(arg, &fi_args, sizeof(fi_args)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
+{
+	struct btrfs_ioctl_dev_info_args *di_args;
+	struct btrfs_device *dev;
+	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
+	int ret = 0;
+	char *s_uuid = NULL;
+	char empty_uuid[BTRFS_UUID_SIZE] = {0};
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	di_args = memdup_user(arg, sizeof(*di_args));
+	if (IS_ERR(di_args))
+		return PTR_ERR(di_args);
+
+	if (memcmp(empty_uuid, di_args->uuid, BTRFS_UUID_SIZE) != 0)
+		s_uuid = di_args->uuid;
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	dev = btrfs_find_device(root, di_args->devid, s_uuid, NULL);
+	mutex_unlock(&fs_devices->device_list_mutex);
+
+	if (!dev) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	di_args->devid = dev->devid;
+	di_args->bytes_used = dev->bytes_used;
+	di_args->total_bytes = dev->total_bytes;
+	memcpy(di_args->uuid, dev->uuid, sizeof(di_args->uuid));
+	strncpy(di_args->path, dev->name, sizeof(di_args->path));
+
+out:
+	if (ret == 0 && copy_to_user(arg, di_args, sizeof(*di_args)))
+		ret = -EFAULT;
+
+	kfree(di_args);
+	return ret;
+}
+
 static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 				       u64 off, u64 olen, u64 destoff)
 {
@@ -2375,6 +2444,58 @@ static noinline long btrfs_ioctl_wait_sync(struct file *file, void __user *argp)
 	return btrfs_wait_for_commit(root, transid);
 }
 
+static long btrfs_ioctl_scrub(struct btrfs_root *root, void __user *arg)
+{
+	int ret;
+	struct btrfs_ioctl_scrub_args *sa;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	sa = memdup_user(arg, sizeof(*sa));
+	if (IS_ERR(sa))
+		return PTR_ERR(sa);
+
+	ret = btrfs_scrub_dev(root, sa->devid, sa->start, sa->end,
+	                      &sa->progress);
+
+	if (copy_to_user(arg, sa, sizeof(*sa)))
+		ret = -EFAULT;
+
+	kfree(sa);
+	return ret;
+}
+
+static long btrfs_ioctl_scrub_cancel(struct btrfs_root *root, void __user *arg)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	return btrfs_scrub_cancel(root);
+}
+
+static long btrfs_ioctl_scrub_progress(struct btrfs_root *root,
+                                       void __user *arg)
+{
+	struct btrfs_ioctl_scrub_args *sa;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	sa = memdup_user(arg, sizeof(*sa));
+	if (IS_ERR(sa))
+		return PTR_ERR(sa);
+
+	ret = btrfs_scrub_progress(root, sa->devid, &sa->progress);
+
+	if (copy_to_user(arg, sa, sizeof(*sa)))
+		ret = -EFAULT;
+
+	kfree(sa);
+	return ret;
+}
+
 long btrfs_ioctl(struct file *file, unsigned int
 		cmd, unsigned long arg)
 {
@@ -2412,6 +2533,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_add_dev(root, argp);
 	case BTRFS_IOC_RM_DEV:
 		return btrfs_ioctl_rm_dev(root, argp);
+	case BTRFS_IOC_FS_INFO:
+		return btrfs_ioctl_fs_info(root, argp);
+	case BTRFS_IOC_DEV_INFO:
+		return btrfs_ioctl_dev_info(root, argp);
 	case BTRFS_IOC_BALANCE:
 		return btrfs_balance(root->fs_info->dev_root);
 	case BTRFS_IOC_CLONE:
@@ -2435,6 +2560,12 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_start_sync(file, argp);
 	case BTRFS_IOC_WAIT_SYNC:
 		return btrfs_ioctl_wait_sync(file, argp);
+	case BTRFS_IOC_SCRUB:
+		return btrfs_ioctl_scrub(root, argp);
+	case BTRFS_IOC_SCRUB_CANCEL:
+		return btrfs_ioctl_scrub_cancel(root, argp);
+	case BTRFS_IOC_SCRUB_PROGRESS:
+		return btrfs_ioctl_scrub_progress(root, argp);
 	}
 
 	return -ENOTTY;
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 973e7c8..52bcd02 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -32,6 +32,8 @@ struct btrfs_ioctl_vol_args {
 
 #define BTRFS_SUBVOL_CREATE_ASYNC	(1ULL << 0)
 #define BTRFS_SUBVOL_RDONLY		(1ULL << 1)
+#define BTRFS_FSID_SIZE 16
+#define BTRFS_UUID_SIZE 16
 
 #define BTRFS_SUBVOL_NAME_MAX 4039
 struct btrfs_ioctl_vol_args_v2 {
@@ -59,6 +61,33 @@ struct btrfs_scrub_progress {
 	__u64 last_physical;
 };
 
+struct btrfs_ioctl_scrub_args {
+	__u64 devid;				/* in */
+	__u64 start;				/* in */
+	__u64 end;				/* in */
+	__u64 flags;				/* in */
+	struct btrfs_scrub_progress progress;	/* out */
+	/* pad to 1k */
+	__u64 unused[(1024-32-sizeof(struct btrfs_scrub_progress))/8];
+};
+
+#define BTRFS_DEVICE_PATH_NAME_MAX 1024
+struct btrfs_ioctl_dev_info_args {
+	__u64 devid;				/* in/out */
+	__u8 uuid[BTRFS_UUID_SIZE];		/* in/out */
+	__u64 bytes_used;			/* out */
+	__u64 total_bytes;			/* out */
+	__u64 unused[379];			/* pad to 4k */
+	__u8 path[BTRFS_DEVICE_PATH_NAME_MAX];	/* out */
+};
+
+struct btrfs_ioctl_fs_info_args {
+	__u64 max_id;				/* out */
+	__u64 num_devices;			/* out */
+	__u8 fsid[BTRFS_FSID_SIZE];		/* out */
+	__u64 reserved[124];			/* pad to 1k */
+};
+
 #define BTRFS_INO_LOOKUP_PATH_MAX 4080
 struct btrfs_ioctl_ino_lookup_args {
 	__u64 treeid;
@@ -220,4 +249,13 @@ struct btrfs_ioctl_space_args {
 				   struct btrfs_ioctl_vol_args_v2)
 #define BTRFS_IOC_SUBVOL_GETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 25, __u64)
 #define BTRFS_IOC_SUBVOL_SETFLAGS _IOW(BTRFS_IOCTL_MAGIC, 26, __u64)
+#define BTRFS_IOC_SCRUB _IOWR(BTRFS_IOCTL_MAGIC, 27, \
+                             struct btrfs_ioctl_scrub_args)
+#define BTRFS_IOC_SCRUB_CANCEL _IO(BTRFS_IOCTL_MAGIC, 28)
+#define BTRFS_IOC_SCRUB_PROGRESS _IOWR(BTRFS_IOCTL_MAGIC, 29, \
+                             struct btrfs_ioctl_scrub_args)
+#define BTRFS_IOC_DEV_INFO _IOWR(BTRFS_IOCTL_MAGIC, 30, \
+                                 struct btrfs_ioctl_dev_info_args)
+#define BTRFS_IOC_FS_INFO _IOR(BTRFS_IOCTL_MAGIC, 31, \
+                                 struct btrfs_ioctl_fs_info_args)
 #endif
-- 
1.7.3.4

