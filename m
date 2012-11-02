Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35822 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933795Ab2KBKPD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2012 06:15:03 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so1312463eaa.19
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2012 03:15:01 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 4/8] Move scrub_fs_info() and scrub_dev_info() in utils.c
Date: Fri,  2 Nov 2012 11:15:35 +0100
Message-Id: <1351851339-19150-5-git-send-email-kreijack@inwind.it>
In-Reply-To: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
References: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Move scrub_fs_info() and scrub_dev_info() in utils.c because these
will be used by the command "btrfs filesystem disk-usage" and
"btrfs device disk-usage".

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 cmds-scrub.c |   87 ++--------------------------------------------------------
 utils.c      |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h      |    5 ++++
 3 files changed, 90 insertions(+), 85 deletions(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 24be20f..8a5bf83 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -967,89 +967,6 @@ static struct scrub_file_record *last_dev_scrub(
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
-static int scrub_fs_info(char *path,
-				struct btrfs_ioctl_fs_info_args *fi_args,
-				struct btrfs_ioctl_dev_info_args **di_ret)
-{
-	int ret = 0;
-	int ndevs = 0;
-	int i = 1;
-	int fd;
-	struct btrfs_fs_devices *fs_devices_mnt = NULL;
-	struct btrfs_ioctl_dev_info_args *di_args;
-	char mp[BTRFS_PATH_NAME_MAX + 1];
-
-	memset(fi_args, 0, sizeof(*fi_args));
-
-	fd  = open_file_or_dir(path);
-	if (fd < 0) {
-	       fprintf(stderr, "ERROR: can't access to '%s'\n", path);
-	       return -1;
-	}
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
-		close(fd);
-		return -errno;
-	}
-
-	if (!fi_args->num_devices) {
-		close(fd);
-		return 0;
-	}
-
-	di_args = *di_ret = malloc(fi_args->num_devices * sizeof(*di_args));
-	if (!di_args) {
-		close(fd);
-		return -errno;
-	}
-
-	for (; i <= fi_args->max_id; ++i) {
-		BUG_ON(ndevs >= fi_args->num_devices);
-		ret = scrub_device_info(fd, i, &di_args[ndevs]);
-		if (ret == -ENODEV)
-			continue;
-		if (ret) {
-			close(fd);
-			return ret;
-		}
-		++ndevs;
-	}
-
-	BUG_ON(ndevs == 0);
-
-	close(fd);
-	return 0;
-}
-
 int mkdir_p(char *path)
 {
 	int i;
@@ -1170,7 +1087,7 @@ static int scrub_start(int argc, char **argv, int resume)
 		return 12;
 	}
 
-	ret = scrub_fs_info(path, &fi_args, &di_args);
+	ret = get_fs_info(path, &fi_args, &di_args);
 	if (ret) {
 		ERR(!do_quiet, "ERROR: getting dev info for scrub failed: "
 		    "%s\n", strerror(-ret));
@@ -1629,7 +1546,7 @@ static int cmd_scrub_status(int argc, char **argv)
 
 	path = argv[optind];
 
-	ret = scrub_fs_info(path, &fi_args, &di_args);
+	ret = get_fs_info(path, &fi_args, &di_args);
 	if (ret) {
 		fprintf(stderr, "ERROR: getting dev info for scrub failed: "
 				"%s\n", strerror(-ret));
diff --git a/utils.c b/utils.c
index f29745f..023fbca 100644
--- a/utils.c
+++ b/utils.c
@@ -1142,6 +1142,89 @@ int open_file_or_dir(const char *fname)
 	return fd;
 }
 
+int get_device_info(int fd, u64 devid,
+		     struct btrfs_ioctl_dev_info_args *di_args)
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
+int get_fs_info(char *path,
+		struct btrfs_ioctl_fs_info_args *fi_args,
+		struct btrfs_ioctl_dev_info_args **di_ret)
+{
+	int ret = 0;
+	int ndevs = 0;
+	int i = 1;
+	int fd;
+	struct btrfs_fs_devices *fs_devices_mnt = NULL;
+	struct btrfs_ioctl_dev_info_args *di_args;
+	char mp[BTRFS_PATH_NAME_MAX + 1];
+
+	memset(fi_args, 0, sizeof(*fi_args));
+
+	fd  = open_file_or_dir(path);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
+		return -1;
+	}
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
+		close(fd);
+		return -errno;
+	}
+
+	if (!fi_args->num_devices) {
+		close(fd);
+		return 0;
+	}
+
+	di_args = *di_ret = malloc(fi_args->num_devices * sizeof(*di_args));
+	if (!di_args) {
+		close(fd);
+		return -errno;
+	}
+
+	for (; i <= fi_args->max_id; ++i) {
+		BUG_ON(ndevs >= fi_args->num_devices);
+		ret = get_device_info(fd, i, &di_args[ndevs]);
+		if (ret == -ENODEV)
+			continue;
+		if (ret) {
+			close(fd);
+			return ret;
+		}
+		++ndevs;
+	}
+
+	BUG_ON(ndevs == 0);
+
+	close(fd);
+	return 0;
+}
+
 /*
  * Checks to make sure that the label matches our requirements.
  * Returns:
diff --git a/utils.h b/utils.h
index f0100c2..34a814d 100644
--- a/utils.h
+++ b/utils.h
@@ -46,6 +46,11 @@ int btrfs_device_already_in_root(struct btrfs_root *root, int fd,
 				 int super_offset);
 char *pretty_sizes(u64 size);
 int open_file_or_dir(const char *fname);
+int get_device_info(int fd, u64 devid,
+			struct btrfs_ioctl_dev_info_args *di_args);
+int get_fs_info(char *path,
+		struct btrfs_ioctl_fs_info_args *fi_args,
+		struct btrfs_ioctl_dev_info_args **di_ret);
 int check_label(char *input);
 int get_mountpt(char *dev, char *mntpt, size_t size);
 
-- 
1.7.10.4

