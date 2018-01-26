Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:40277 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751678AbeAZSli (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 13:41:38 -0500
Received: by mail-pg0-f68.google.com with SMTP id g16so785367pgn.7
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 10:41:38 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 16/26] btrfs-progs: use libbtrfsutil for sync ioctls
Date: Fri, 26 Jan 2018 10:41:04 -0800
Message-Id: <90551f6ebfff5d6601d91ee618a0504c9f6aeb23.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 cmds-filesystem.c | 20 ++++++--------------
 cmds-qgroup.c     |  7 ++++---
 cmds-subvolume.c  | 23 ++++++++++++++---------
 3 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 17d399d5..2353fdb0 100644
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
@@ -815,26 +817,16 @@ static const char * const cmd_filesystem_sync_usage[] = {
 
 static int cmd_filesystem_sync(int argc, char **argv)
 {
-	int 	fd, res, e;
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
-	e = errno;
-	close_file_or_dir(fd, dirstream);
-	if( res < 0 ){
-		error("sync ioctl failed on '%s': %s", path, strerror(e));
+	err = btrfs_util_sync(argv[optind]);
+	if (err) {
+		error_btrfs_util(err);
 		return 1;
 	}
 
diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index 38382ea9..fac692d4 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -302,6 +302,7 @@ static int cmd_qgroup_show(int argc, char **argv)
 	int filter_flag = 0;
 	unsigned unit_mode;
 	int sync = 0;
+	enum btrfs_util_error err;
 
 	struct btrfs_qgroup_comparer_set *comparer_set;
 	struct btrfs_qgroup_filter_set *filter_set;
@@ -375,10 +376,10 @@ static int cmd_qgroup_show(int argc, char **argv)
 	}
 
 	if (sync) {
-		ret = ioctl(fd, BTRFS_IOC_SYNC);
-		if (ret < 0)
+		err = btrfs_util_f_sync(fd);
+		if (err)
 			warning("sync ioctl failed on '%s': %s", path,
-			      strerror(errno));
+				strerror(errno));
 	}
 
 	if (filter_flag) {
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index f8e34bc8..89a4ebb0 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -219,12 +219,18 @@ out:
 
 static int wait_for_commit(int fd)
 {
-	int ret;
+	enum btrfs_util_error err;
+	uint64_t transid;
 
-	ret = ioctl(fd, BTRFS_IOC_START_SYNC, NULL);
-	if (ret < 0)
-		return ret;
-	return ioctl(fd, BTRFS_IOC_WAIT_SYNC, NULL);
+	err = btrfs_util_f_start_sync(fd, &transid);
+	if (err)
+		return -1;
+
+	err = btrfs_util_f_wait_sync(fd, transid);
+	if (err)
+		return -1;
+
+	return 0;
 }
 
 static const char * const cmd_subvol_delete_usage[] = {
@@ -940,10 +946,9 @@ static int cmd_subvol_find_new(int argc, char **argv)
 	if (fd < 0)
 		return 1;
 
-	ret = ioctl(fd, BTRFS_IOC_SYNC);
-	if (ret < 0) {
-		error("sync ioctl failed on '%s': %s",
-			subvol, strerror(errno));
+	err = btrfs_util_f_sync(fd);
+	if (err) {
+		error_btrfs_util(err);
 		close_file_or_dir(fd, dirstream);
 		return 1;
 	}
-- 
2.16.1

