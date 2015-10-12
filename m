Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38274 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752320AbbJLNYx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 09:24:53 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9CDOMkW026212
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 21:24:22 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 09/11] btrfs-progs: use btrfs_open_dir in open_path_or_dev_mnt
Date: Mon, 12 Oct 2015 21:23:02 +0800
Message-ID: <729b148c1e02fae951fb6bd46d3f3ec1450d9599.1444655800.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1444655800.git.zhaolei@cn.fujitsu.com>
References: <cover.1444655800.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use btrfs_open_dir() in open_path_or_dev_mnt() to make the function
return error when target is neither block device nor btrfs mount point.

Also add "verbose" argument to let function output common error
message instead of putting duplicated lines in caller.

Before patch:
  # ./btrfs device stats /mnt/tmp1
  ERROR: getting dev info for devstats failed: Inappropriate ioctl for device
  # ./btrfs replace start /dev/vdd /dev/vde /mnt/tmp1
  ERROR: ioctl(DEV_REPLACE_STATUS) failed on "/mnt/tmp1": Inappropriate ioctl for device

After patch:
  # ./btrfs device stats /mnt/tmp1
  ERROR: not a btrfs filesystem: /mnt/tmp1
  # ./btrfs replace start /dev/vdd /dev/vde /mnt/tmp1
  ERROR: not a btrfs filesystem: /mnt/tmp1

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-device.c  | 13 ++-----------
 cmds-replace.c | 13 ++-----------
 cmds-scrub.c   | 28 +++++-----------------------
 utils.c        | 21 +++++++++++----------
 utils.h        |  2 +-
 5 files changed, 21 insertions(+), 56 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 5f2b952..a9354f5 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -385,18 +385,9 @@ static int cmd_device_stats(int argc, char **argv)
 
 	dev_path = argv[optind];
 
-	fdmnt = open_path_or_dev_mnt(dev_path, &dirstream);
-
-	if (fdmnt < 0) {
-		if (errno == EINVAL)
-			fprintf(stderr,
-				"ERROR: '%s' is not a mounted btrfs device\n",
-				dev_path);
-		else
-			fprintf(stderr, "ERROR: can't access '%s': %s\n",
-				dev_path, strerror(errno));
+	fdmnt = open_path_or_dev_mnt(dev_path, &dirstream, 1);
+	if (fdmnt < 0)
 		return 1;
-	}
 
 	ret = get_fs_info(dev_path, &fi_args, &di_args);
 	if (ret) {
diff --git a/cmds-replace.c b/cmds-replace.c
index 9ab8438..385b764 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -170,18 +170,9 @@ static int cmd_replace_start(int argc, char **argv)
 		usage(cmd_replace_start_usage);
 	path = argv[optind + 2];
 
-	fdmnt = open_path_or_dev_mnt(path, &dirstream);
-
-	if (fdmnt < 0) {
-		if (errno == EINVAL)
-			fprintf(stderr,
-				"ERROR: '%s' is not a mounted btrfs device\n",
-				path);
-		else
-			fprintf(stderr, "ERROR: can't access '%s': %s\n",
-				path, strerror(errno));
+	fdmnt = open_path_or_dev_mnt(path, &dirstream, 1);
+	if (fdmnt < 0)
 		goto leave_with_error;
-	}
 
 	/* check for possible errors before backgrounding */
 	status_args.cmd = BTRFS_IOCTL_DEV_REPLACE_CMD_STATUS;
diff --git a/cmds-scrub.c b/cmds-scrub.c
index ea6ffc9..da614f2 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1198,17 +1198,9 @@ static int scrub_start(int argc, char **argv, int resume)
 
 	path = argv[optind];
 
-	fdmnt = open_path_or_dev_mnt(path, &dirstream);
-
-	if (fdmnt < 0) {
-		if (errno == EINVAL)
-			error_on(!do_quiet, "'%s' is not a mounted btrfs device",
-				path);
-		else
-			error_on(!do_quiet, "can't access '%s': %s",
-				path, strerror(errno));
+	fdmnt = open_path_or_dev_mnt(path, &dirstream, !do_quiet);
+	if (fdmnt < 0)
 		return 1;
-	}
 
 	ret = get_fs_info(path, &fi_args, &di_args);
 	if (ret) {
@@ -1604,12 +1596,8 @@ static int cmd_scrub_cancel(int argc, char **argv)
 
 	path = argv[1];
 
-	fdmnt = open_path_or_dev_mnt(path, &dirstream);
+	fdmnt = open_path_or_dev_mnt(path, &dirstream, 1);
 	if (fdmnt < 0) {
-		if (errno == EINVAL)
-			error("'%s' is not a mounted btrfs device", path);
-		else
-			error("can't access '%s': %s", path, strerror(errno));
 		ret = 1;
 		goto out;
 	}
@@ -1705,15 +1693,9 @@ static int cmd_scrub_status(int argc, char **argv)
 
 	path = argv[optind];
 
-	fdmnt = open_path_or_dev_mnt(path, &dirstream);
-
-	if (fdmnt < 0) {
-		if (errno == EINVAL)
-			error("'%s' is not a mounted btrfs device", path);
-		else
-			error("can't access '%s': %s", path, strerror(errno));
+	fdmnt = open_path_or_dev_mnt(path, &dirstream, 1);
+	if (fdmnt < 0)
 		return 1;
-	}
 
 	ret = get_fs_info(path, &fi_args, &di_args);
 	if (ret) {
diff --git a/utils.c b/utils.c
index f1e3248..6f5df23 100644
--- a/utils.c
+++ b/utils.c
@@ -1081,27 +1081,28 @@ out:
  *
  * On error, return -1, errno should be set.
  */
-int open_path_or_dev_mnt(const char *path, DIR **dirstream)
+int open_path_or_dev_mnt(const char *path, DIR **dirstream, int verbose)
 {
 	char mp[PATH_MAX];
-	int fdmnt;
-
-	fdmnt = is_block_device(path);
-	if (fdmnt == 1) {
-		int ret;
+	int ret;
 
+	if (is_block_device(path)) {
 		ret = get_btrfs_mount(path, mp, sizeof(mp));
 		if (ret < 0) {
 			/* not a mounted btrfs dev */
+			error_on(verbose, "'%s' is not a mounted btrfs device",
+				 path);
 			errno = EINVAL;
 			return -1;
 		}
-		fdmnt = open_file_or_dir(mp, dirstream);
-	} else if (fdmnt == 0) {
-		fdmnt = open_file_or_dir(path, dirstream);
+		ret = open_file_or_dir(mp, dirstream);
+		error_on(verbose && ret < 0, "can't access '%s': %s",
+			 path, strerror(errno));
+	} else {
+		ret = btrfs_open_dir(path, dirstream, 1);
 	}
 
-	return fdmnt;
+	return ret;
 }
 
 /*
diff --git a/utils.h b/utils.h
index 044ea15..1dc12ec 100644
--- a/utils.h
+++ b/utils.h
@@ -158,7 +158,7 @@ char *__strncpy__null(char *dest, const char *src, size_t n);
 int is_block_device(const char *file);
 int is_mount_point(const char *file);
 int check_arg_type(const char *input);
-int open_path_or_dev_mnt(const char *path, DIR **dirstream);
+int open_path_or_dev_mnt(const char *path, DIR **dirstream, int verbose);
 int btrfs_open_dir(const char *path, DIR **dirstream, int verbose);
 u64 btrfs_device_size(int fd, struct stat *st);
 /* Helper to always get proper size of the destination string */
-- 
1.8.5.1

