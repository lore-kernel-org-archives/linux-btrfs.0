Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:44722 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751925AbeAZSlj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 13:41:39 -0500
Received: by mail-pf0-f193.google.com with SMTP id m26so813007pfj.11
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 10:41:39 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 17/26] btrfs-progs: use libbtrfsutil for set-default
Date: Fri, 26 Jan 2018 10:41:05 -0800
Message-Id: <11eb6c489a7f2e0b7512003cd4035d00af1a9ad0.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 cmds-subvolume.c | 47 ++++++++++-------------------------------------
 messages.h       | 14 ++++++++++++++
 2 files changed, 24 insertions(+), 37 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 89a4ebb0..aaf88af8 100644
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
@@ -853,11 +855,9 @@ static const char * const cmd_subvol_set_default_usage[] = {
 
 static int cmd_subvol_set_default(int argc, char **argv)
 {
-	int	ret=0, fd, e;
-	u64	objectid;
-	char	*path;
-	char	*subvolid;
-	DIR	*dirstream = NULL;
+	u64 objectid;
+	char *path;
+	enum btrfs_util_error err;
 
 	clean_args_no_options(argc, argv, cmd_subvol_set_default_usage);
 
@@ -867,44 +867,17 @@ static int cmd_subvol_set_default(int argc, char **argv)
 
 	if (argc - optind == 1) {
 		/* path to the subvolume is specified */
+		objectid = 0;
 		path = argv[optind];
-
-		ret = test_issubvolume(path);
-		if (ret < 0) {
-			error("stat error: %s", strerror(-ret));
-			return 1;
-		} else if (!ret) {
-			error("'%s' is not a subvolume", path);
-			return 1;
-		}
-
-		fd = btrfs_open_dir(path, &dirstream, 1);
-		if (fd < 0)
-			return 1;
-
-		ret = lookup_path_rootid(fd, &objectid);
-		if (ret) {
-			error("unable to get subvol id: %s", strerror(-ret));
-			close_file_or_dir(fd, dirstream);
-			return 1;
-		}
 	} else {
 		/* subvol id and path to the filesystem are specified */
-		subvolid = argv[optind];
+		objectid = arg_strtou64(argv[optind]);
 		path = argv[optind + 1];
-		objectid = arg_strtou64(subvolid);
-
-		fd = btrfs_open_dir(path, &dirstream, 1);
-		if (fd < 0)
-			return 1;
 	}
 
-	ret = ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
-	e = errno;
-	close_file_or_dir(fd, dirstream);
-	if (ret < 0) {
-		error("unable to set a new default subvolume: %s",
-			strerror(e));
+	err = btrfs_util_set_default_subvolume(path, objectid);
+	if (err) {
+		error_btrfs_util(err);
 		return 1;
 	}
 	return 0;
diff --git a/messages.h b/messages.h
index 4999c7b9..cfabb86f 100644
--- a/messages.h
+++ b/messages.h
@@ -54,6 +54,20 @@
 			DO_ABORT_ON_ERROR;				\
 	} while (0)
 
+#define error_btrfs_util(err)						\
+	do {								\
+		const char *errno_str = strerror(errno);		\
+		const char *lib_str = btrfs_util_strerror(err)		\
+		PRINT_TRACE_ON_ERROR;					\
+		PRINT_VERBOSE_ERROR;					\
+		if (lib_str && strcmp(errno_str, lib_str) != 0)		\
+			__btrfs_error("%s: %s", lib_str, errno_str);	\
+		else							\
+			__btrfs_error("%s", errno_str);			\
+		DO_ABORT_ON_ERROR;					\
+	} while (0)
+
+
 #define warning(fmt, ...)						\
 	do {								\
 		PRINT_TRACE_ON_ERROR;					\
-- 
2.16.1

