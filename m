Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2817 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab2EaK37 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 May 2012 06:29:59 -0400
Received: from mailserver.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q4VAUO5X021286
	for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2012 18:30:27 +0800
Message-ID: <4FC747CF.2040703@cn.fujitsu.com>
Date: Thu, 31 May 2012 18:28:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: Update mtab if necessary when device was deleted
 in btrfs
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now if we remove the device that is specified when mounting, btrfs will update
the mount information in /proc, such as the information in /proc/mounts. So
in order to guarantee the consistency between /etc/mtab and the mount
information in /proc, we must update /etc/mtab. This patch does it.

This patch need libmount and libmount-devel(version >= 2.19) packages to
compile.

Signed-off-by: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 Makefile      |    2 +-
 cmds-device.c |  404 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 utils.h       |    1 +
 3 files changed, 399 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index 79818e6..8ce415b 100644
--- a/Makefile
+++ b/Makefile
@@ -15,7 +15,7 @@ DEPFLAGS = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 INSTALL = install
 prefix ?= /usr/local
 bindir = $(prefix)/bin
-LIBS=-luuid
+LIBS=-luuid -lmount
 RESTORE_LIBS=-lz
 
 progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
diff --git a/cmds-device.c b/cmds-device.c
index db625a6..bdafebe 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -13,7 +13,7 @@
  * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
  * Boston, MA 021110-1307, USA.
  */
-
+#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -22,6 +22,7 @@
 #include <sys/ioctl.h>
 #include <errno.h>
 #include <sys/stat.h>
+#include <paths.h>
 
 #include "kerncompat.h"
 #include "ctree.h"
@@ -29,6 +30,7 @@
 #include "utils.h"
 
 #include "commands.h"
+#include <libmount/libmount.h>
 
 /* FIXME - imported cruft, fix sparse errors and warnings */
 #ifdef __CHECKER__
@@ -39,6 +41,10 @@ struct btrfs_ioctl_vol_args { char name[BTRFS_VOL_NAME_MAX]; };
 static inline int ioctl(int fd, int define, void *arg) { return 0; }
 #endif
 
+#define PROC_MOUNTS_PATH	"/proc/mounts"
+int mtab_is_regular;
+struct libmnt_lock *volatile mtab_lock;
+
 static const char * const device_cmd_group_usage[] = {
 	"btrfs device <command> [<args>]",
 	NULL
@@ -50,10 +56,312 @@ static const char * const cmd_add_dev_usage[] = {
 	NULL
 };
 
+static int mtab_fprintf_fs(FILE *f, struct libmnt_fs *fs)
+{
+	const char *src, *fstype;
+	char *o;
+	char *m1, *m2, *m3, *m4;
+	int ret;
+
+	assert(fs);
+	assert(f);
+
+	src = mnt_fs_get_source(fs);
+	fstype = mnt_fs_get_fstype(fs);
+	o = mnt_fs_strdup_options(fs);
+	if (!o)
+		return -ENOMEM;
+
+	m1 = src ? mnt_mangle(src) : "none";
+	m2 = mnt_mangle(mnt_fs_get_target(fs));
+	m3 = fstype ? mnt_mangle(fstype) : "none";
+	m4 = o ? mnt_mangle(o) : "rw";
+
+	if (m1 && m2 && m3 && m4) {
+		ret = fprintf(f, "%s %s %s %s %d %d\n",
+				m1, m2, m3, m4,
+				mnt_fs_get_freq(fs),
+				mnt_fs_get_passno(fs));
+		if (ret > 0)
+			ret = 0;
+	} else
+		ret = -ENOMEM;
+
+	if (src)
+		mnt_unmangle(m1);
+	mnt_unmangle(m2);
+	if (fstype)
+		mnt_unmangle(m3);
+	if (o)
+		mnt_unmangle(m4);
+	free(o);
+
+	return ret;
+}
+
+static int mtab_open_uniq_filename(const char *filename, char **name)
+{
+	int fd;
+	char *n;
+	int ret;
+
+	assert(filename);
+
+	if (name)
+		*name = NULL;
+
+	ret = asprintf(&n, "%s.XXXXXX", filename);
+	if (ret <= 0)
+		return -errno;
+
+	fd = mkstemp(n);
+	if (fd >= 0 && name)
+		*name = n;
+	else
+		free(n);
+
+	return fd < 0 ? -errno : fd;
+}
+
+static int mtab_update_table(struct libmnt_table *tb)
+{
+	FILE *f;
+	int fd;
+	char *uq = NULL;
+	int ret;
+
+	if (!tb)
+		return -EINVAL;
+
+	fd = mtab_open_uniq_filename(_PATH_MOUNTED, &uq);
+	if (fd < 0)
+		return fd;	/* error */
+
+	f = fdopen(fd, "w");
+	if (f) {
+		struct stat st;
+		struct libmnt_iter *itr;
+		struct libmnt_fs *fs;
+		int fd;
+
+		itr = mnt_new_iter(MNT_ITER_FORWARD);
+		if (!itr) {
+			ret = -ENOMEM;
+			goto leave;
+		}
+
+		while (mnt_table_next_fs(tb, itr, &fs) == 0) {
+			ret = mtab_fprintf_fs(f, fs);
+			if (ret) {
+				mnt_free_iter(itr);
+				goto leave;
+			}
+		}
+		mnt_free_iter(itr);
+
+		if (fflush(f) != 0) {
+			ret = -errno;
+			goto leave;
+		}
+
+		fd = fileno(f);
+		ret = fchmod(fd, S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH) ? -errno : 0;
+
+		if (!ret && stat(_PATH_MOUNTED, &st) == 0)
+			ret = fchown(fd, st.st_uid, st.st_gid) ? -errno : 0;
+
+		fclose(f);
+		ret = rename(uq, _PATH_MOUNTED) ? -errno : 0;
+	} else {
+		ret = -errno;
+		close(fd);
+	}
+
+leave:
+	unlink(uq);	/* be paranoid */
+	free(uq);
+	return ret;
+}
+
+static int btrfs_get_all_devices(const char *devname,
+				 struct btrfs_fs_devices **fs_devices_ret)
+{
+	int fd;
+	int ret;
+
+	fd = open(devname, O_RDONLY);
+	if (fd < 0) {
+		fprintf(stderr,
+			"Error: btrfs_get_all_devices() Could not open %s\n",
+			devname);
+		return -errno;
+	}
+
+	ret = check_mounted_where(fd, devname, NULL, 0, fs_devices_ret);
+	close(fd);
+	if (ret == 0) {
+		fprintf(stderr,
+			"Error: This device(%s) is not in this fs.\n", devname);
+		return -EINVAL;
+	} else if (ret > 0)
+		ret = 0;
+
+	return ret;
+}
+
+void clean_lock(void)
+{
+	if (!mtab_lock)
+		return;
+	mnt_unlock_file(mtab_lock);
+	mnt_free_lock(mtab_lock);
+}
+
+static int mtab_prepare_update(void)
+{
+	mtab_is_regular = mnt_has_regular_mtab(NULL, NULL);
+	if (!mtab_is_regular)
+		return 0;
+
+	mtab_lock = mnt_new_lock(_PATH_MOUNTED, 0);
+	if (!mtab_lock)
+		return -errno;
+
+	atexit(clean_lock);
+	mnt_lock_block_signals(mtab_lock, 1);
+
+	if (mnt_lock_file(mtab_lock) != 0) {
+		fprintf(stderr, "Error: prepare lock mtab failed.\n");
+		mnt_free_lock(mtab_lock);
+		mtab_lock = NULL;
+		return -1;
+	}
+
+	return 0;
+}
+
+struct match_data {
+	struct btrfs_fs_devices *fs_devices;
+	const char *target;
+};
+
+static int match_mounts_fs(struct libmnt_fs *fs, void *data)
+{
+	struct match_data *match_data = data;
+	int ret;
+
+	ret = blk_file_in_dev_list(match_data->fs_devices,
+				   mnt_fs_get_source(fs));
+	if (!ret)
+		return 0;
+
+	ret = strcmp(match_data->target, mnt_fs_get_target(fs));
+	if (ret)
+		return 0;
+
+	return 1;
+}
+
+static int match_mtab_fs(struct libmnt_fs *fs, void *data)
+{
+	struct btrfs_fs_devices *fs_devices = data;
+	int ret;
+
+	ret = blk_file_in_dev_list(fs_devices, mnt_fs_get_source(fs));
+
+	return ret;
+}
+
+static int mtab_do_update(struct btrfs_fs_devices *fs_devices)
+{
+	struct libmnt_table *mounts_tb = NULL, *mtab_tb = NULL;
+	struct libmnt_fs *mounts_fs = NULL, *mtab_fs = NULL;
+	struct libmnt_iter *mounts_itr = NULL, *mtab_itr = NULL;
+	struct match_data data;
+	const char *type;
+	int ret;
+
+	if (!mtab_is_regular)
+		return 0;
+
+	mounts_tb = mnt_new_table_from_file(PROC_MOUNTS_PATH);
+	if (!mounts_tb)
+		return -ENOMEM;
+
+	mtab_tb = mnt_new_table_from_file(_PATH_MOUNTED);
+	if (!mtab_tb) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	mtab_itr = mnt_new_iter(MNT_ITER_FORWARD);
+	if (!mtab_itr) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	mounts_itr = mnt_new_iter(MNT_ITER_FORWARD);
+	if (!mounts_itr) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	data.fs_devices = fs_devices;
+
+	ret = mnt_table_find_next_fs(mtab_tb, mtab_itr, match_mtab_fs,
+				     fs_devices, &mtab_fs);
+	while (!ret) {
+		type = mnt_fs_get_fstype(mtab_fs);
+		if (strcmp(type, "btrfs"))
+			BUG();
+
+		data.target = mnt_fs_get_target(mtab_fs);
+		ret = mnt_table_find_next_fs(mounts_tb, mounts_itr,
+					     match_mounts_fs,
+					     &data, &mounts_fs);
+		/*
+		 * It is impossble that we can not find the relative fs
+		 * in /proc/mounts.
+		*/
+		if (ret)
+			BUG();
+
+		ret = mnt_fs_set_source(mtab_fs, mnt_fs_get_source(mounts_fs));
+		if (ret)
+			goto out;
+
+		mnt_reset_iter(mounts_itr, MNT_ITER_FORWARD);
+		ret = mnt_table_find_next_fs(mtab_tb, mtab_itr, match_mtab_fs,
+					     fs_devices, &mtab_fs);
+	}
+
+	ret = mtab_update_table(mtab_tb);
+out:
+	mnt_free_iter(mtab_itr);
+	mnt_free_iter(mounts_itr);
+	mnt_free_table(mtab_tb);
+	mnt_free_table(mounts_tb);
+
+	return ret;
+}
+
+static void mtab_end_update(void)
+{
+	if (!mtab_is_regular)
+		return;
+
+	mnt_unlock_file(mtab_lock);
+	mnt_free_lock(mtab_lock);
+	mtab_lock = NULL;
+}
+
 static int cmd_add_dev(int argc, char **argv)
 {
+	struct btrfs_fs_devices *fs_devices = NULL;
 	char	*mntpnt;
 	int	i, fdmnt, ret=0, e;
+	/* the index of the device that is successful to be add into fs */
+	int	index = 0;
 
 	if (check_argc_min(argc, 3))
 		usage(cmd_add_dev_usage);
@@ -66,6 +374,13 @@ static int cmd_add_dev(int argc, char **argv)
 		return 12;
 	}
 
+	ret = mtab_prepare_update();
+	if (ret) {
+		fprintf(stderr, "Error: prepare update failed.\n");
+		ret = 12;
+		goto out;
+	}
+
 	for (i = 1; i < argc - 1; i++ ){
 		struct btrfs_ioctl_vol_args ioctl_args;
 		int	devfd, res;
@@ -119,14 +434,45 @@ static int cmd_add_dev(int argc, char **argv)
 		strncpy(ioctl_args.name, argv[i], BTRFS_PATH_NAME_MAX);
 		res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
 		e = errno;
-		if(res<0){
+		if (res < 0) {
 			fprintf(stderr, "ERROR: error adding the device '%s' - %s\n",
 				argv[i], strerror(e));
 			ret++;
+		} else if (!index) {
+			index = i;
 		}
+	}
 
+	/* There is no device which is add into fs. */
+	if (!index)
+		goto end_update;
+
+	/*
+	 * index indicates the device that is successful to be add into the
+	 * specified fs. And we will get all devices in the specified fs by
+	 * this device, then we will use this device information to check if
+	 * the item in mtab or /proc/mounts is relative to the specified fs
+	 * or not. This is tricky.
+	 */
+	e = btrfs_get_all_devices(argv[index], &fs_devices);
+	if (e) {
+		fprintf(stderr, "ERROR: Get all the devices failed - %s\n",
+			strerror(e));
+		if (!ret)
+			ret = 12;
+		goto end_update;
 	}
 
+	e = mtab_do_update(fs_devices);
+	if (e) {
+		fprintf(stderr, "ERROR: update /etc/mtab failed - %s\n",
+			strerror(e));
+		if (!ret)
+			ret = 12;
+	}
+end_update:
+	mtab_end_update();
+out:
 	close(fdmnt);
 	if (ret)
 		return ret+20;
@@ -142,8 +488,11 @@ static const char * const cmd_rm_dev_usage[] = {
 
 static int cmd_rm_dev(int argc, char **argv)
 {
+	struct btrfs_fs_devices *fs_devices = NULL;
 	char	*mntpnt;
 	int	i, fdmnt, ret=0, e;
+	/* The index of the device that is removed from fs. */
+	int	index = 0;
 
 	if (check_argc_min(argc, 3))
 		usage(cmd_rm_dev_usage);
@@ -156,23 +505,65 @@ static int cmd_rm_dev(int argc, char **argv)
 		return 12;
 	}
 
+	ret = mtab_prepare_update();
+	if (ret) {
+		fprintf(stderr, "Error: prepare update failed.\n");
+		ret = 12;
+		goto out;
+	}
+
 	for(i=1 ; i < argc - 1; i++ ){
 		struct	btrfs_ioctl_vol_args arg;
 		int	res;
 
+		/*
+		 * We need the device information to check the item in mtab
+		 * or /proc/mounts is relative to the specified fs or not.
+		 * But it is a little hard to get it because we doesn't have
+		 * a suitable interface in the kernel.
+		 *
+		 * Fortunately, there is a tricky way to achieve it. That is
+		 * reusing the function check_mounted_where(). If one device
+		 * is in the specified fs, we can get all the devices by this
+		 * function and this device.
+		 */
+		if (!index) {
+			e = btrfs_get_all_devices(argv[i], &fs_devices);
+			if (e) {
+				ret++;
+				continue;
+			}
+		}
+
 		strncpy(arg.name, argv[i], BTRFS_PATH_NAME_MAX);
 		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
 		e = errno;
-		if(res<0){
-			fprintf(stderr, "ERROR: error removing the device '%s' - %s\n",
+		if (res < 0) {
+			fprintf(stderr,
+				"ERROR: error removing the device '%s' - %s\n",
 				argv[i], strerror(e));
 			ret++;
+		} else if (!index) {
+			index = i;
 		}
 	}
 
+	if (!index)
+		goto end_update;
+
+	e = mtab_do_update(fs_devices);
+	if (e) {
+		fprintf(stderr, "ERROR: update /etc/mtab failed - %s\n",
+			strerror(e));
+		if (!ret)
+			ret = 12;
+	}
+end_update:
+	mtab_end_update();
+out:
 	close(fdmnt);
-	if( ret)
-		return ret+20;
+	if (ret)
+		return ret + 20;
 	else
 		return 0;
 }
@@ -198,7 +589,6 @@ static int cmd_scan_dev(int argc, char **argv)
 	}
 
 	if(argc<=devstart){
-
 		int ret;
 
 		printf("Scanning for Btrfs filesystems\n");
diff --git a/utils.h b/utils.h
index c5f55e1..5a0b9e9 100644
--- a/utils.h
+++ b/utils.h
@@ -39,6 +39,7 @@ int btrfs_scan_one_dir(char *dirname, int run_ioctl);
 int check_mounted(const char *devicename);
 int check_mounted_where(int fd, const char *file, char *where, int size,
 			struct btrfs_fs_devices **fs_devices_mnt);
+int blk_file_in_dev_list(struct btrfs_fs_devices *fs_devices, const char *file);
 int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 char *pretty_sizes(u64 size);
-- 
1.7.6.5
