Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:40351 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbaHNLkt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 07:40:49 -0400
Received: by mail-pd0-f180.google.com with SMTP id v10so1430129pde.39
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Aug 2014 04:40:48 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH 1/2 RFC] btrfs-progs: scan devices for specific fsid in btrfs_scan_for_fsid
Date: Thu, 14 Aug 2014 19:40:19 +0800
Message-Id: <1408016420-29221-1-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The function name "btrfs_scan_for_fsid" suggests to me that it should
look for btrfs devices with specific fsid value, it doesn't make sense
to scan all devices.

So adding a new parameter to btrfs_scan_for_fsid and related functions
to specify the target fsid, if fsid is NULL then scan all devices.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---

I'm not so sure if this is the expected behavior, any comments are welcomed!

 cmds-device.c     |  2 +-
 cmds-filesystem.c |  2 +-
 disk-io.c         |  2 +-
 utils.c           | 43 +++++++++++++++++++++++++++++--------------
 utils.h           | 10 +++++-----
 5 files changed, 37 insertions(+), 22 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index c8586a0..f028fc0 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -226,7 +226,7 @@ static int cmd_scan_dev(int argc, char **argv)
 
 	if (all || argc == 1) {
 		printf("Scanning for Btrfs filesystems\n");
-		ret = scan_for_btrfs(where, BTRFS_UPDATE_KERNEL);
+		ret = scan_for_btrfs(where, NULL, BTRFS_UPDATE_KERNEL);
 		if (ret)
 			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
 		goto out;
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 306f715..7077ef8 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -633,7 +633,7 @@ static int cmd_show(int argc, char **argv)
 		goto out;
 
 devs_only:
-	ret = scan_for_btrfs(where, !BTRFS_UPDATE_KERNEL);
+	ret = scan_for_btrfs(where, NULL, !BTRFS_UPDATE_KERNEL);
 
 	if (ret) {
 		fprintf(stderr, "ERROR: %d while scanning\n", ret);
diff --git a/disk-io.c b/disk-io.c
index 8db0335..1a90ac7 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -995,7 +995,7 @@ int btrfs_scan_fs_devices(int fd, const char *path,
 	}
 
 	if (total_devs != 1) {
-		ret = btrfs_scan_for_fsid(run_ioctl);
+		ret = btrfs_scan_for_fsid((*fs_devices)->fsid, run_ioctl);
 		if (ret)
 			return ret;
 	}
diff --git a/utils.c b/utils.c
index e130849..f54e749 100644
--- a/utils.c
+++ b/utils.c
@@ -1022,7 +1022,9 @@ int check_mounted_where(int fd, const char *file, char *where, int size,
 
 	/* scan other devices */
 	if (is_btrfs && total_devs > 1) {
-		if ((ret = btrfs_scan_for_fsid(!BTRFS_UPDATE_KERNEL)))
+		ret = btrfs_scan_for_fsid(fs_devices_mnt->fsid,
+					  !BTRFS_UPDATE_KERNEL);
+		if (ret)
 			return ret;
 	}
 
@@ -1099,7 +1101,7 @@ void btrfs_register_one_device(char *fname)
 	close(fd);
 }
 
-int btrfs_scan_one_dir(char *dirname, int run_ioctl)
+int btrfs_scan_one_dir(char *dirname, u8 *fsid, int run_ioctl)
 {
 	DIR *dirp = NULL;
 	struct dirent *dirent;
@@ -1180,7 +1182,13 @@ again:
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
 					    BTRFS_SUPER_INFO_OFFSET);
-		if (ret == 0 && run_ioctl > 0) {
+		close(fd);
+		if (ret)
+			continue;
+
+		if (fsid && memcmp(fsid, tmp_devices->fsid, BTRFS_FSID_SIZE))
+			continue;
+		if (run_ioctl > 0) {
 			btrfs_register_one_device(fullpath);
 		}
 		close(fd);
@@ -1210,13 +1218,13 @@ fail:
 	return ret;
 }
 
-int btrfs_scan_for_fsid(int run_ioctls)
+int btrfs_scan_for_fsid(u8 *fsid, int run_ioctls)
 {
 	int ret;
 
-	ret = scan_for_btrfs(BTRFS_SCAN_PROC, run_ioctls);
+	ret = scan_for_btrfs(BTRFS_SCAN_PROC, fsid, run_ioctls);
 	if (ret)
-		ret = scan_for_btrfs(BTRFS_SCAN_DEV, run_ioctls);
+		ret = scan_for_btrfs(BTRFS_SCAN_DEV, fsid, run_ioctls);
 	return ret;
 }
 
@@ -1455,7 +1463,7 @@ int set_label(const char *btrfs_dev, const char *label)
 		set_label_mounted(btrfs_dev, label);
 }
 
-int btrfs_scan_block_devices(int run_ioctl)
+int btrfs_scan_block_devices(u8 *fsid, int run_ioctl)
 {
 
 	struct stat st;
@@ -1523,10 +1531,15 @@ scan_again:
 		ret = btrfs_scan_one_device(fd, fullpath, &tmp_devices,
 					    &num_devices,
 					    BTRFS_SUPER_INFO_OFFSET);
-		if (ret == 0 && run_ioctl > 0) {
+		close(fd);
+		if (ret)
+			continue;
+
+		if (fsid && memcmp(fsid, tmp_devices->fsid, BTRFS_FSID_SIZE))
+			continue;
+		if (run_ioctl > 0) {
 			btrfs_register_one_device(fullpath);
 		}
-		close(fd);
 	}
 
 	fclose(proc_partitions);
@@ -2014,7 +2027,7 @@ int test_dev_for_mkfs(char *file, int force_overwrite, char *estr)
 	return 0;
 }
 
-int btrfs_scan_lblkid(int update_kernel)
+int btrfs_scan_lblkid(u8 *fsid, int update_kernel)
 {
 	int fd = -1;
 	int ret;
@@ -2053,6 +2066,8 @@ int btrfs_scan_lblkid(int update_kernel)
 		}
 
 		close(fd);
+		if (fsid && memcmp(fsid, tmp_devices->fsid, BTRFS_FSID_SIZE))
+			continue;
 		if (update_kernel)
 			btrfs_register_one_device(path);
 	}
@@ -2064,19 +2079,19 @@ int btrfs_scan_lblkid(int update_kernel)
 /*
  * scans devs for the btrfs
 */
-int scan_for_btrfs(int where, int update_kernel)
+int scan_for_btrfs(int where, u8 *fsid, int update_kernel)
 {
 	int ret = 0;
 
 	switch (where) {
 	case BTRFS_SCAN_PROC:
-		ret = btrfs_scan_block_devices(update_kernel);
+		ret = btrfs_scan_block_devices(fsid, update_kernel);
 		break;
 	case BTRFS_SCAN_DEV:
-		ret = btrfs_scan_one_dir("/dev", update_kernel);
+		ret = btrfs_scan_one_dir("/dev", fsid, update_kernel);
 		break;
 	case BTRFS_SCAN_LBLKID:
-		ret = btrfs_scan_lblkid(update_kernel);
+		ret = btrfs_scan_lblkid(fsid, update_kernel);
 		break;
 	}
 	return ret;
diff --git a/utils.h b/utils.h
index db8d63c..e7f850b 100644
--- a/utils.h
+++ b/utils.h
@@ -50,9 +50,9 @@ int btrfs_add_to_fsid(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int fd, char *path,
 		      u64 block_count, u32 io_width, u32 io_align,
 		      u32 sectorsize);
-int btrfs_scan_for_fsid(int run_ioctls);
+int btrfs_scan_for_fsid(u8 *fsid, int run_ioctls);
 void btrfs_register_one_device(char *fname);
-int btrfs_scan_one_dir(char *dirname, int run_ioctl);
+int btrfs_scan_one_dir(char *dirname, u8 *fsid, int run_ioctl);
 int check_mounted(const char *devicename);
 int check_mounted_where(int fd, const char *file, char *where, int size,
 			struct btrfs_fs_devices **fs_devices_mnt);
@@ -68,7 +68,7 @@ int pretty_size_snprintf(u64 size, char *str, size_t str_bytes);
 	})
 
 int get_mountpt(char *dev, char *mntpt, size_t size);
-int btrfs_scan_block_devices(int run_ioctl);
+int btrfs_scan_block_devices(u8 *fsid, int run_ioctl);
 u64 parse_size(char *s);
 u64 arg_strtou64(const char *str);
 int open_file_or_dir(const char *fname, DIR **dirstream);
@@ -87,7 +87,7 @@ u64 btrfs_device_size(int fd, struct stat *st);
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
 int test_dev_for_mkfs(char *file, int force_overwrite, char *estr);
-int scan_for_btrfs(int where, int update_kernel);
+int scan_for_btrfs(int where, u8 *fsid, int update_kernel);
 int get_label_mounted(const char *mount_path, char *labelp);
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 	u64 dev_cnt, int mixed, char *estr);
@@ -96,7 +96,7 @@ int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
 			   int verify);
 int ask_user(char *question);
 int lookup_ino_rootid(int fd, u64 *rootid);
-int btrfs_scan_lblkid(int update_kernel);
+int btrfs_scan_lblkid(u8 *fsid, int update_kernel);
 int get_btrfs_mount(const char *dev, char *mp, size_t mp_size);
 int find_mount_root(const char *path, char **mount_root);
 int get_device_info(int fd, u64 devid,
-- 
1.8.3.1

