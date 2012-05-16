Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mort.rzone.de ([81.169.144.234]:50808 "EHLO mort.rzone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757905Ab2EPQu7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 May 2012 12:50:59 -0400
Received: from gargravarr.store (gargravarr.store [192.168.42.236])
	by mort.rzone.de (Postfix) with ESMTP id 2C42A23C
	for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2012 18:50:58 +0200 (MEST)
From: Stefan Behrens <sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/3] Btrfs-progs: make two utility functions globally available
Date: Wed, 16 May 2012 18:50:57 +0200
Message-Id: <1337187058-560-3-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1337187058-560-1-git-send-email-sbehrens@giantdisaster.de>
References: <1337187058-560-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Two convenient utility functions that have so far been local to scrub are
moved to utils.c.
They will be used in the device stats code in a following commit.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-scrub.c |   72 ++--------------------------------------------------------
 utils.c      |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h      |    4 ++++
 3 files changed, 72 insertions(+), 70 deletions(-)

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
index 6157115..037f64b 100644
--- a/utils.c
+++ b/utils.c
@@ -1233,3 +1233,69 @@ int open_file_or_dir(const char *fname)
 	return fd;
 }
 
+int get_device_info(int fd, u64 devid,
+		    struct btrfs_ioctl_dev_info_args *di_args)
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
+int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
+		struct btrfs_ioctl_dev_info_args **di_ret)
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
+	if (ret && (errno == EINVAL || errno == ENOTTY)) {
+		/* path is not a mounted btrfs. Try if it's a device */
+		ret = check_mounted_where(fd, path, mp, sizeof(mp),
+					  &fs_devices_mnt);
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
+		ret = get_device_info(fd, i, &di_args[ndevs]);
+		if (ret == -ENODEV)
+			continue;
+		if (ret)
+			return ret;
+		ndevs++;
+	}
+
+	BUG_ON(ndevs == 0);
+
+	return 0;
+}
diff --git a/utils.h b/utils.h
index e281002..e33c231 100644
--- a/utils.h
+++ b/utils.h
@@ -49,4 +49,8 @@ int get_mountpt(char *dev, char *mntpt, size_t size);
 
 int btrfs_scan_block_devices(int run_ioctl);
 int open_file_or_dir(const char *fname);
+int get_device_info(int fd, u64 devid,
+		    struct btrfs_ioctl_dev_info_args *di_args);
+int get_fs_info(int fd, char *path, struct btrfs_ioctl_fs_info_args *fi_args,
+		struct btrfs_ioctl_dev_info_args **di_ret);
 #endif
-- 
1.7.10.2

