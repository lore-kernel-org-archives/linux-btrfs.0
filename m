From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH v2] Btrfs: avoid stack bloat in btrfs_ioctl_fs_info()
Date: Wed, 08 Jun 2011 16:27:56 +0800
Message-ID: <4DEF328C.4040801@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Arne Jansen <sensille@gmx.net>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The size of struct btrfs_ioctl_fs_info_args is as big as 1KB, so
don't declare the variable on stack.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

v2: fixed to pass the right size to copy_to_user().

---
 fs/btrfs/ioctl.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index ac37040..b793d11 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2054,29 +2054,34 @@ static long btrfs_ioctl_rm_dev(struct btrfs_root *root, void __user *arg)
 
 static long btrfs_ioctl_fs_info(struct btrfs_root *root, void __user *arg)
 {
-	struct btrfs_ioctl_fs_info_args fi_args;
+	struct btrfs_ioctl_fs_info_args *fi_args;
 	struct btrfs_device *device;
 	struct btrfs_device *next;
 	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
+	int ret = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	fi_args.num_devices = fs_devices->num_devices;
-	fi_args.max_id = 0;
-	memcpy(&fi_args.fsid, root->fs_info->fsid, sizeof(fi_args.fsid));
+	fi_args = kzalloc(sizeof(*fi_args), GFP_KERNEL);
+	if (!fi_args)
+		return -ENOMEM;
+
+	fi_args->num_devices = fs_devices->num_devices;
+	memcpy(&fi_args->fsid, root->fs_info->fsid, sizeof(fi_args->fsid));
 
 	mutex_lock(&fs_devices->device_list_mutex);
 	list_for_each_entry_safe(device, next, &fs_devices->devices, dev_list) {
-		if (device->devid > fi_args.max_id)
-			fi_args.max_id = device->devid;
+		if (device->devid > fi_args->max_id)
+			fi_args->max_id = device->devid;
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
 
-	if (copy_to_user(arg, &fi_args, sizeof(fi_args)))
-		return -EFAULT;
+	if (copy_to_user(arg, fi_args, sizeof(*fi_args)))
+		ret = -EFAULT;
 
-	return 0;
+	kfree(fi_args);
+	return ret;
 }
 
 static long btrfs_ioctl_dev_info(struct btrfs_root *root, void __user *arg)
-- 
1.7.3.1
