Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:54554 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355Ab2FHTMw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jun 2012 15:12:52 -0400
From: Goffredo Baroncelli <kreijack@inwind.it>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 1/3] Btrfs-progs: make two utility functions globally available
Date: Fri,  8 Jun 2012 21:12:44 +0200
Message-Id: <1339182766-15292-2-git-send-email-kreijack@inwind.it>
In-Reply-To: <1339182766-15292-1-git-send-email-kreijack@inwind.it>
References: <1339182766-15292-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch is ispired by a Stefan Behrens one.
---
 Makefile     |    8 +++----
 cmds-scrub.c |   72 ++--------------------------------------------------------
 utils.c      |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h      |    4 ++++
 4 files changed, 78 insertions(+), 74 deletions(-)

diff --git a/Makefile b/Makefile
index 79818e6..0915021 100644
--- a/Makefile
+++ b/Makefile
@@ -4,7 +4,7 @@ CFLAGS = -g -O0
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
-	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o
+	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o common.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o
 
@@ -39,8 +39,8 @@ all: version $(progs) manpages
 version:
 	bash version.sh
 
-btrfs: $(objects) btrfs.o help.o common.o $(cmds_objects)
-	$(CC) $(CFLAGS) -o btrfs btrfs.o help.o common.o $(cmds_objects) \
+btrfs: $(objects) btrfs.o help.o $(cmds_objects)
+	$(CC) $(CFLAGS) -o btrfs btrfs.o help.o $(cmds_objects) \
 		$(objects) $(LDFLAGS) $(LIBS) -lpthread
 
 calc-size: $(objects) calc-size.o
@@ -52,7 +52,7 @@ btrfs-find-root: $(objects) find-root.o
 btrfs-restore: $(objects) restore.o
 	gcc $(CFLAGS) -o btrfs-restore restore.o $(objects) $(LDFLAGS) $(LIBS) $(RESTORE_LIBS)
 
-btrfsctl: $(objects) btrfsctl.o
+btrfsctl: $(objects) btrfsctl.o 
 	$(CC) $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
 
 btrfs-vol: $(objects) btrfs-vol.o
diff --git a/cmds-scrub.c b/cmds-scrub.c
index c4503f4..37a9890 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -967,74 +967,6 @@ static struct scrub_file_record *last_dev_scrub(
 	return NULL;
 }
 
-static int scrub_device_info(int fd, u64 devid,
-			     struct btrfs_ioctl_dev_info_args *di_args)
-{
-	int ret;
-
-	di_args->devid = devid;
-	memset(&di_args->uuid, '\0', sizeof(di_args->uuid));
-
-	ret = ioctl(fd, BTRFS_IOC_DEV_INFO, di_args);
-	return ret ? -errno : 0;
-}
-
-static int scrub_fs_info(int fd, char *path,
-				struct btrfs_ioctl_fs_info_args *fi_args,
-				struct btrfs_ioctl_dev_info_args **di_ret)
-{
-	int ret = 0;
-	int ndevs = 0;
-	int i = 1;
-	struct btrfs_fs_devices *fs_devices_mnt = NULL;
-	struct btrfs_ioctl_dev_info_args *di_args;
-	char mp[BTRFS_PATH_NAME_MAX + 1];
-
-	memset(fi_args, 0, sizeof(*fi_args));
-
-	ret = ioctl(fd, BTRFS_IOC_FS_INFO, fi_args);
-	if (ret && errno == EINVAL) {
-		/* path is no mounted btrfs. try if it's a device */
-		ret = check_mounted_where(fd, path, mp, sizeof(mp),
-						&fs_devices_mnt);
-		if (!ret)
-			return -EINVAL;
-		if (ret < 0)
-			return ret;
-		fi_args->num_devices = 1;
-		fi_args->max_id = fs_devices_mnt->latest_devid;
-		i = fs_devices_mnt->latest_devid;
-		memcpy(fi_args->fsid, fs_devices_mnt->fsid, BTRFS_FSID_SIZE);
-		close(fd);
-		fd = open_file_or_dir(mp);
-		if (fd < 0)
-			return -errno;
-	} else if (ret) {
-		return -errno;
-	}
-
-	if (!fi_args->num_devices)
-		return 0;
-
-	di_args = *di_ret = malloc(fi_args->num_devices * sizeof(*di_args));
-	if (!di_args)
-		return -errno;
-
-	for (; i <= fi_args->max_id; ++i) {
-		BUG_ON(ndevs >= fi_args->num_devices);
-		ret = scrub_device_info(fd, i, &di_args[ndevs]);
-		if (ret == -ENODEV)
-			continue;
-		if (ret)
-			return ret;
-		++ndevs;
-	}
-
-	BUG_ON(ndevs == 0);
-
-	return 0;
-}
-
 int mkdir_p(char *path)
 {
 	int i;
@@ -1155,7 +1087,7 @@ static int scrub_start(int argc, char **argv, int resume)
 		return 12;
 	}
 
-	ret = scrub_fs_info(fdmnt, path, &fi_args, &di_args);
+	ret = get_fs_info(fdmnt, path, &fi_args, &di_args);
 	if (ret) {
 		ERR(!do_quiet, "ERROR: getting dev info for scrub failed: "
 		    "%s\n", strerror(-ret));
@@ -1621,7 +1553,7 @@ static int cmd_scrub_status(int argc, char **argv)
 		return 12;
 	}
 
-	ret = scrub_fs_info(fdmnt, path, &fi_args, &di_args);
+	ret = get_fs_info(fdmnt, path, &fi_args, &di_args);
 	if (ret) {
 		fprintf(stderr, "ERROR: getting dev info for scrub failed: "
 				"%s\n", strerror(-ret));
diff --git a/utils.c b/utils.c
index ee7fa1b..d916912 100644
--- a/utils.c
+++ b/utils.c
@@ -44,6 +44,7 @@
 #include "utils.h"
 #include "volumes.h"
 #include "ioctl.h"
+#include "commands.h"
 
 #ifdef __CHECKER__
 #define BLKGETSIZE64 0
@@ -1206,3 +1207,70 @@ scan_again:
 	return 0;
 }
 
+int scrub_device_info(int fd, u64 devid,
+			     struct btrfs_ioctl_dev_info_args *di_args)
+{
+	int ret;
+
+	di_args->devid = devid;
+	memset(&di_args->uuid, '\0', sizeof(di_args->uuid));
+
+	ret = ioctl(fd, BTRFS_IOC_DEV_INFO, di_args);
+	return ret ? -errno : 0;
+}
+
+int get_fs_info(int fd, char *path,
+				struct btrfs_ioctl_fs_info_args *fi_args,
+				struct btrfs_ioctl_dev_info_args **di_ret)
+{
+	int ret = 0;
+	int ndevs = 0;
+	int i = 1;
+	struct btrfs_fs_devices *fs_devices_mnt = NULL;
+	struct btrfs_ioctl_dev_info_args *di_args;
+	char mp[BTRFS_PATH_NAME_MAX + 1];
+
+	memset(fi_args, 0, sizeof(*fi_args));
+
+	ret = ioctl(fd, BTRFS_IOC_FS_INFO, fi_args);
+	if (ret && errno == EINVAL) {
+		/* path is no mounted btrfs. try if it's a device */
+		ret = check_mounted_where(fd, path, mp, sizeof(mp),
+						&fs_devices_mnt);
+		if (!ret)
+			return -EINVAL;
+		if (ret < 0)
+			return ret;
+		fi_args->num_devices = 1;
+		fi_args->max_id = fs_devices_mnt->latest_devid;
+		i = fs_devices_mnt->latest_devid;
+		memcpy(fi_args->fsid, fs_devices_mnt->fsid, BTRFS_FSID_SIZE);
+		close(fd);
+		fd = open_file_or_dir(mp);
+		if (fd < 0)
+			return -errno;
+	} else if (ret) {
+		return -errno;
+	}
+
+	if (!fi_args->num_devices)
+		return 0;
+
+	di_args = *di_ret = malloc(fi_args->num_devices * sizeof(*di_args));
+	if (!di_args)
+		return -errno;
+
+	for (; i <= fi_args->max_id; ++i) {
+		BUG_ON(ndevs >= fi_args->num_devices);
+		ret = scrub_device_info(fd, i, &di_args[ndevs]);
+		if (ret == -ENODEV)
+			continue;
+		if (ret)
+			return ret;
+		++ndevs;
+	}
+
+	BUG_ON(ndevs == 0);
+
+	return 0;
+}
diff --git a/utils.h b/utils.h
index c5f55e1..01220a2 100644
--- a/utils.h
+++ b/utils.h
@@ -46,4 +46,8 @@ int check_label(char *input);
 int get_mountpt(char *dev, char *mntpt, size_t size);
 
 int btrfs_scan_block_devices(int run_ioctl);
+int get_device_info(int fd, u64 devid,
+		    struct btrfs_ioctl_dev_info_args *di_args);
+int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
+		struct btrfs_ioctl_dev_info_args **di_ret);
 #endif
-- 
1.7.10

