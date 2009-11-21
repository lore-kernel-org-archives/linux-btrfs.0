From: Andi Drebes <lists-receive@programmierforen.de>
Subject: [PATCH 1/2] btrfs-progs: multidevice support for check_mounted
Date: Sat, 21 Nov 2009 15:38:38 +0100
Message-ID: <200911211538.38351.lists-receive@programmierforen.de>
References: <200911211533.25878.lists-receive@programmierforen.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Cc: Chris Mason <chris.mason@oracle.com>,
	"Yan, Zheng" <yanzheng@21cn.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200911211533.25878.lists-receive@programmierforen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Check_mount() should also work with multi device filesystems. This patch adds checks that allow to detect if a file is a device file used by a mounted single or multi device btrfs or if it is a regular file used by a loopback device that is part of a mounted single or multi device btrfs.

The single device checks also work for non-btrfs filesystems. This might be helpful to prevent users from running btrfs programs (e.g. mkfs.btrfs) accidentally on a filesystem used somewhere else.

Signed-off-by: Andi Drebes <lists-receive@programmierforen.de>
---
diff --git a/kerncompat.h b/kerncompat.h
index e4c8ce0..46236cd 100644
--- a/kerncompat.h
+++ b/kerncompat.h
@@ -42,7 +42,11 @@
 #define GFP_NOFS 0
 #define __read_mostly
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+
+#ifndef ULONG_MAX
 #define ULONG_MAX       (~0UL)
+#endif
+
 #define BUG() abort()
 #ifdef __CHECKER__
 #define __force    __attribute__((force))
diff --git a/utils.c b/utils.c
index 2f4c6e1..8114217 100644
--- a/utils.c
+++ b/utils.c
@@ -31,6 +31,10 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <mntent.h>
+#include <linux/loop.h>
+#include <linux/major.h>
+#include <linux/kdev_t.h>
+#include <limits.h>
 #include "kerncompat.h"
 #include "radix-tree.h"
 #include "ctree.h"
@@ -586,55 +590,224 @@ error:
 	return ret;
 }
 
+/* checks if a device is a loop device */
+int is_loop_device (const char* device) {
+	struct stat statbuf;
+
+	if(stat(device, &statbuf) < 0)
+		return -errno;
+
+	return (S_ISBLK(statbuf.st_mode) &&
+		MAJOR(statbuf.st_rdev) == LOOP_MAJOR);
+}
+
+
+/* Takes a loop device path (e.g. /dev/loop0) and returns
+ * the associated file (e.g. /images/my_btrfs.img) */
+int resolve_loop_device(const char* loop_dev, char* loop_file, int max_len)
+{
+	int loop_fd;
+	int ret_ioctl;
+	struct loop_info loopinfo;
+
+	if ((loop_fd = open(loop_dev, O_RDONLY)) < 0)
+		return -errno;
+
+	ret_ioctl = ioctl(loop_fd, LOOP_GET_STATUS, &loopinfo);
+	close(loop_fd);
+
+	if (ret_ioctl == 0)
+		strncpy(loop_file, loopinfo.lo_name, max_len);
+	else
+		return -errno;
+
+	return 0;
+}
+
+/* Checks whether a and b are identical or device
+ * files associated with the same block device
+ */
+int is_same_blk_file(const char* a, const char* b)
+{
+	struct stat st_buf_a, st_buf_b;
+	char real_a[PATH_MAX];
+	char real_b[PATH_MAX];
+
+	if(!realpath(a, real_a) ||
+	   !realpath(b, real_b))
+	{
+		return -errno;
+	}
+
+	/* Identical path? */
+	if(strcmp(real_a, real_b) == 0)
+		return 1;
+
+	if(stat(a, &st_buf_a) < 0 ||
+	   stat(b, &st_buf_b) < 0)
+	{
+		return -errno;
+	}
+
+	/* Same blockdevice? */
+	if(S_ISBLK(st_buf_a.st_mode) &&
+	   S_ISBLK(st_buf_b.st_mode) &&
+	   st_buf_a.st_rdev == st_buf_b.st_rdev)
+	{
+		return 1;
+	}
+
+	/* Hardlink? */
+	if (st_buf_a.st_dev == st_buf_b.st_dev &&
+	    st_buf_a.st_ino == st_buf_b.st_ino)
+	{
+		return 1;
+	}
+
+	return 0;
+}
+
+/* checks if a and b are identical or device
+ * files associated with the same block device or
+ * if one file is a loop device that uses the other
+ * file.
+ */
+int is_same_loop_file(const char* a, const char* b)
+{
+	char res_a[PATH_MAX];
+	char res_b[PATH_MAX];
+	const char* final_a;
+	const char* final_b;
+	int ret;
+
+	/* Resolve a if it is a loop device */
+	if((ret = is_loop_device(a)) < 0) {
+	   return ret;
+	} else if(ret) {
+		if((ret = resolve_loop_device(a, res_a, sizeof(res_a))) < 0)
+			return ret;
+
+		final_a = res_a;
+	} else {
+		final_a = a;
+	}
+
+	/* Resolve b if it is a loop device */
+	if((ret = is_loop_device(b)) < 0) {
+	   return ret;
+	} else if(ret) {
+		if((ret = resolve_loop_device(b, res_b, sizeof(res_b))) < 0)
+			return ret;
+
+		final_b = res_b;
+	} else {
+		final_b = b;
+	}
+
+	return is_same_blk_file(final_a, final_b);
+}
+
+/* Checks if an mntentry represents a pseudo FS */
+int is_pseudo_fs(const struct mntent* mnt)
+{
+	struct stat st_buf;
+
+	if(stat(mnt->mnt_fsname, &st_buf) < 0) {
+		if(errno == ENOENT)
+			return 1;
+		else
+			return -errno;
+	}
+
+	return 0;
+}
+
+/* Checks if a file is used (directly or indirectly via a loop device)
+ * by a device in fs_devices
+ */
+int blk_file_in_dev_list(struct btrfs_fs_devices* fs_devices, const char* file)
+{
+	int ret;
+	struct list_head *head;
+	struct list_head *cur;
+	struct btrfs_device *device;
+
+	head = &fs_devices->devices;
+	list_for_each(cur, head) {
+		device = list_entry(cur, struct btrfs_device, dev_list);
+
+		if((ret = is_same_loop_file(device->name, file)))
+			return ret;
+	}
+
+	return 0;
+}
+
 /*
  * returns 1 if the device was mounted, < 0 on error or 0 if everything
- * is safe to continue.  TODO, this should also scan multi-device filesystems
+ * is safe to continue.
  */
-int check_mounted(char *file)
+int check_mounted(const char* file)
 {
-	struct mntent *mnt;
-	struct stat st_buf;
-	dev_t file_dev = 0;
-	dev_t file_rdev = 0;
-	ino_t file_ino = 0;
+	int ret;
+	int fd;
+	u64 total_devs = 1;
+	int is_btrfs;
+	struct btrfs_fs_devices* fs_devices_mnt = NULL;
 	FILE *f;
-	int ret = 0;
+	struct mntent *mnt;
 
-	if ((f = setmntent ("/proc/mounts", "r")) == NULL)
+	fd = open(file, O_RDONLY);
+	if (fd < 0) {
+		fprintf (stderr, "check_mounted(): Could not open %s\n", file);
 		return -errno;
+	}
 
-	if (stat(file, &st_buf) < 0) {
-		return -errno;
-	} else {
-		if (S_ISBLK(st_buf.st_mode)) {
-			file_rdev = st_buf.st_rdev;
-		} else {
-			file_dev = st_buf.st_dev;
-			file_ino = st_buf.st_ino;
-		}
+	/* scan the initial device */
+	ret = btrfs_scan_one_device(fd, file, &fs_devices_mnt,
+				    &total_devs, BTRFS_SUPER_INFO_OFFSET);
+	is_btrfs = (ret >= 0);
+	close(fd);
+
+	/* scan other devices */
+	if (is_btrfs && total_devs > 1) {
+		if((ret = btrfs_scan_for_fsid(fs_devices_mnt, total_devs, 1)))
+			return ret;
 	}
 
+	/* iterate over the list of currently mountes filesystems */
+	if ((f = setmntent ("/proc/mounts", "r")) == NULL)
+		return -errno;
+
 	while ((mnt = getmntent (f)) != NULL) {
-		if (strcmp(file, mnt->mnt_fsname) == 0)
-			break;
+		/* Only check btrfs filesystems */
+		if(is_btrfs && strcmp(mnt->mnt_type, "btrfs") != 0)
+			continue;
 
-		if (stat(mnt->mnt_fsname, &st_buf) == 0) {
-			if (S_ISBLK(st_buf.st_mode)) {
-				if (file_rdev && (file_rdev == st_buf.st_rdev))
-					break;
-			} else if (file_dev && ((file_dev == st_buf.st_dev) &&
-						(file_ino == st_buf.st_ino))) {
-					break;
-			}
-		}
-	}
+		/* ignore pseudo filesystems */
+		if(!is_btrfs && (ret = is_pseudo_fs(mnt)) < 0)
+			goto out_mntloop_err;
+		else if(ret)
+			continue;
 
-	if (mnt) {
-		/* found an entry in mnt table */
-		ret = 1;
+		/* perform the check */
+		if(is_btrfs)
+			ret = blk_file_in_dev_list(fs_devices_mnt, mnt->mnt_fsname);
+		else
+			ret = is_same_loop_file(file, mnt->mnt_fsname);
+
+		if(ret < 0)
+			goto out_mntloop_err;
+		else if(ret)
+			break;
 	}
 
+	/* Did we find an entry in mnt table? */
+	ret = (mnt != NULL);
+
+out_mntloop_err:
 	endmntent (f);
+
 	return ret;
 }
 
diff --git a/utils.h b/utils.h
index 7ff542b..9dce5b0 100644
--- a/utils.h
+++ b/utils.h
@@ -36,7 +36,7 @@ int btrfs_scan_for_fsid(struct btrfs_fs_devices *fs_devices, u64 total_devs,
 			int run_ioctls);
 void btrfs_register_one_device(char *fname);
 int btrfs_scan_one_dir(char *dirname, int run_ioctl);
-int check_mounted(char *devicename);
+int check_mounted(const char *devicename);
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 char *pretty_sizes(u64 size);
