Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:46630 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161045AbeBOTFq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:46 -0500
Received: by mail-pg0-f68.google.com with SMTP id a11so485563pgu.13
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:46 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 17/27] btrfs-progs: use libbtrfsutil for sync ioctls
Date: Thu, 15 Feb 2018 11:05:02 -0800
Message-Id: <04c8e9a17db4aff5b00509fb83420e3075f7aaf6.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 cmds-filesystem.c | 19 ++++++-------------
 cmds-qgroup.c     | 10 +++++++---
 cmds-subvolume.c  | 25 +++++++++++++++++--------
 3 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 467aff11..225df421 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -28,6 +28,8 @@
 #include <linux/limits.h>
 #include <getopt.h>
 
+#include <btrfsutil.h>
+
 #include "kerncompat.h"
 #include "ctree.h"
 #include "utils.h"
@@ -813,25 +815,16 @@ static const char * const cmd_filesystem_sync_usage[] = {
 
 static int cmd_filesystem_sync(int argc, char **argv)
 {
-	int 	fd, res;
-	char	*path;
-	DIR	*dirstream = NULL;
+	enum btrfs_util_error err;
 
 	clean_args_no_options(argc, argv, cmd_filesystem_sync_usage);
 
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_filesystem_sync_usage);
 
-	path = argv[optind];
-
-	fd = btrfs_open_dir(path, &dirstream, 1);
-	if (fd < 0)
-		return 1;
-
-	res = ioctl(fd, BTRFS_IOC_SYNC);
-	close_file_or_dir(fd, dirstream);
-	if( res < 0 ){
-		error("sync ioctl failed on '%s': %m", path);
+	err = btrfs_util_sync(argv[optind]);
+	if (err) {
+		error_btrfs_util(err);
 		return 1;
 	}
 
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 4f99e419..f9a52fa8 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -20,6 +20,8 @@
 #include <unistd.h>
 #include <getopt.h>
 
+#include <btrfsutil.h>
+
 #include "ctree.h"
 #include "ioctl.h"
 
@@ -299,6 +301,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 	int filter_flag = 0;
 	unsigned unit_mode;
 	int sync = 0;
+	enum btrfs_util_error err;
 
 	struct btrfs_qgroup_comparer_set *comparer_set;
 	struct btrfs_qgroup_filter_set *filter_set;
@@ -372,9 +375,10 @@ static int cmd_qgroup_show(int argc, char **argv)
 	}
 
 	if (sync) {
-		ret = ioctl(fd, BTRFS_IOC_SYNC);
-		if (ret < 0)
-			warning("sync ioctl failed on '%s': %m", path);
+		err = btrfs_util_sync_fd(fd);
+		if (err)
+			warning("sync ioctl failed on '%s': %s", path,
+				strerror(errno));
 	}
 
 	if (filter_flag) {
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index edcb4f11..6006a278 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -28,6 +28,8 @@
 #include <uuid/uuid.h>
 #include <linux/magic.h>
 
+#include <btrfsutil.h>
+
 #include "kerncompat.h"
 #include "ioctl.h"
 #include "qgroup.h"
@@ -219,12 +221,18 @@ out:
 
 static int wait_for_commit(int fd)
 {
-	int ret;
+	enum btrfs_util_error err;
+	uint64_t transid;
 
-	ret = ioctl(fd, BTRFS_IOC_START_SYNC, NULL);
-	if (ret < 0)
-		return ret;
-	return ioctl(fd, BTRFS_IOC_WAIT_SYNC, NULL);
+	err = btrfs_util_start_sync_fd(fd, &transid);
+	if (err)
+		return -1;
+
+	err = btrfs_util_wait_sync_fd(fd, transid);
+	if (err)
+		return -1;
+
+	return 0;
 }
 
 static const char * const cmd_subvol_delete_usage[] = {
@@ -911,6 +919,7 @@ static int cmd_subvol_find_new(int argc, char **argv)
 	char *subvol;
 	u64 last_gen;
 	DIR *dirstream = NULL;
+	enum btrfs_util_error err;
 
 	clean_args_no_options(argc, argv, cmd_subvol_find_new_usage);
 
@@ -934,9 +943,9 @@ static int cmd_subvol_find_new(int argc, char **argv)
 	if (fd < 0)
 		return 1;
 
-	ret = ioctl(fd, BTRFS_IOC_SYNC);
-	if (ret < 0) {
-		error("sync ioctl failed on '%s': %m", subvol);
+	err = btrfs_util_sync_fd(fd);
+	if (err) {
+		error_btrfs_util(err);
 		close_file_or_dir(fd, dirstream);
 		return 1;
 	}
-- 
2.16.1

