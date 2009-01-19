From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: [Patch] Btrfs: use BTRFS_VOL_NAME_MAX for struct
	btrfs_ioctl_vol_args
Date: Mon, 19 Jan 2009 20:57:32 +0800
Message-ID: <20090119125732.GA7424@hack.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, Andrew Morton <akpm@osdl.org>
To: linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


I found userspace tool, btrfsctl, uses BTRFS_VOL_NAME_MAX, and
it also looks that this one is more proper.

Kill BTRFS_PATH_NAME_MAX since no one will use it.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Chris Mason <chris.mason@oracle.com>

---
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index c2aa33e..f229950 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -472,7 +472,7 @@ static int btrfs_ioctl_resize(struct btrfs_root *root, void __user *arg)
 		goto out;
 	}
 
-	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
+	vol_args->name[BTRFS_VOL_NAME_MAX] = '\0';
 	namelen = strlen(vol_args->name);
 
 	mutex_lock(&root->fs_info->volume_mutex);
@@ -576,7 +576,7 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 		goto out;
 	}
 
-	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
+	vol_args->name[BTRFS_VOL_NAME_MAX] = '\0';
 	namelen = strlen(vol_args->name);
 	if (strchr(vol_args->name, '/')) {
 		ret = -EINVAL;
@@ -685,7 +685,7 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
 		ret = -EFAULT;
 		goto out;
 	}
-	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
+	vol_args->name[BTRFS_VOL_NAME_MAX] = '\0';
 	ret = btrfs_init_new_device(root, vol_args->name);
 
 out:
@@ -713,7 +713,7 @@ static long btrfs_ioctl_rm_dev(struct btrfs_root *root, void __user *arg)
 		ret = -EFAULT;
 		goto out;
 	}
-	vol_args->name[BTRFS_PATH_NAME_MAX] = '\0';
+	vol_args->name[BTRFS_VOL_NAME_MAX] = '\0';
 	ret = btrfs_rm_device(root, vol_args->name);
 
 out:
diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index b320b10..f5d182a 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -22,12 +22,10 @@
 
 #define BTRFS_IOCTL_MAGIC 0x94
 #define BTRFS_VOL_NAME_MAX 255
-#define BTRFS_PATH_NAME_MAX 4087
 
-/* this should be 4k */
 struct btrfs_ioctl_vol_args {
 	__s64 fd;
-	char name[BTRFS_PATH_NAME_MAX + 1];
+	char name[BTRFS_VOL_NAME_MAX + 1];
 };
 
 struct btrfs_ioctl_clone_range_args {
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index db9fb3b..5facdbf 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -593,7 +593,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 		ret = -EFAULT;
 		goto out;
 	}
-	len = strnlen(vol->name, BTRFS_PATH_NAME_MAX);
+	len = strnlen(vol->name, BTRFS_VOL_NAME_MAX);
 
 	switch (cmd) {
 	case BTRFS_IOC_SCAN_DEV:

