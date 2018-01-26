Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36741 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751613AbeAZSlq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 13:41:46 -0500
Received: by mail-pf0-f196.google.com with SMTP id 23so821978pfp.3
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 10:41:46 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 23/26] btrfs-progs: replace test_issubvolume() with btrfs_util_is_subvolume()
Date: Fri, 26 Jan 2018 10:41:11 -0800
Message-Id: <f64e3fccdab1d0967f943720bd4e149748236449.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
In-Reply-To: <cover.1516991902.git.osandov@fb.com>
References: <cover.1516991902.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

This gets the remaining occurrences that weren't covered by previous
conversions.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 cmds-qgroup.c    | 13 ++++++-------
 cmds-subvolume.c | 11 ++++-------
 utils.c          | 34 +++++-----------------------------
 utils.h          |  1 -
 4 files changed, 15 insertions(+), 44 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index fac692d4..16ba6f86 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -20,6 +20,8 @@
 #include <unistd.h>
 #include <getopt.h>
 
+#include <btrfsutil.h>
+
 #include "ctree.h"
 #include "ioctl.h"
 
@@ -431,6 +433,7 @@ static int cmd_qgroup_limit(int argc, char **argv)
 	int compressed = 0;
 	int exclusive = 0;
 	DIR *dirstream = NULL;
+	enum btrfs_util_error err;
 
 	while (1) {
 		int c = getopt(argc, argv, "ce");
@@ -471,13 +474,9 @@ static int cmd_qgroup_limit(int argc, char **argv)
 	if (argc - optind == 2) {
 		args.qgroupid = 0;
 		path = argv[optind + 1];
-		ret = test_issubvolume(path);
-		if (ret < 0) {
-			error("cannot access '%s': %s", path, strerror(-ret));
-			return 1;
-		}
-		if (!ret) {
-			error("'%s' is not a subvolume", path);
+		err = btrfs_util_is_subvolume(path);
+		if (err) {
+			error_btrfs_util(err);
 			return 1;
 		}
 		/*
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 8dbb3e49..5c75799c 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -748,6 +748,7 @@ static int cmd_subvol_find_new(int argc, char **argv)
 	char *subvol;
 	u64 last_gen;
 	DIR *dirstream = NULL;
+	enum btrfs_util_error err;
 
 	clean_args_no_options(argc, argv, cmd_subvol_find_new_usage);
 
@@ -757,13 +758,9 @@ static int cmd_subvol_find_new(int argc, char **argv)
 	subvol = argv[optind];
 	last_gen = arg_strtou64(argv[optind + 1]);
 
-	ret = test_issubvolume(subvol);
-	if (ret < 0) {
-		error("cannot access subvolume %s: %s", subvol, strerror(-ret));
-		return 1;
-	}
-	if (!ret) {
-		error("not a subvolume: %s", subvol);
+	err = btrfs_util_is_subvolume(subvol);
+	if (err) {
+		error_btrfs_util(err);
 		return 1;
 	}
 
diff --git a/utils.c b/utils.c
index 6a667907..bdb389cf 100644
--- a/utils.c
+++ b/utils.c
@@ -40,6 +40,8 @@
 #include <linux/magic.h>
 #include <getopt.h>
 
+#include <btrfsutil.h>
+
 #include "kerncompat.h"
 #include "radix-tree.h"
 #include "ctree.h"
@@ -1451,6 +1453,7 @@ u64 parse_qgroupid(const char *p)
 	char *s = strchr(p, '/');
 	const char *ptr_src_end = p + strlen(p);
 	char *ptr_parse_end = NULL;
+	enum btrfs_util_error err;
 	u64 level;
 	u64 id;
 	int fd;
@@ -1478,8 +1481,8 @@ u64 parse_qgroupid(const char *p)
 
 path:
 	/* Path format like subv at 'my_subvol' is the fallback case */
-	ret = test_issubvolume(p);
-	if (ret < 0 || !ret)
+	err = btrfs_util_is_subvolume(p);
+	if (err)
 		goto err;
 	fd = open(p, O_RDONLY);
 	if (fd < 0)
@@ -2443,33 +2446,6 @@ int test_issubvolname(const char *name)
 		strcmp(name, ".") && strcmp(name, "..");
 }
 
-/*
- * Test if path is a subvolume
- * Returns:
- *   0 - path exists but it is not a subvolume
- *   1 - path exists and it is  a subvolume
- * < 0 - error
- */
-int test_issubvolume(const char *path)
-{
-	struct stat	st;
-	struct statfs stfs;
-	int		res;
-
-	res = stat(path, &st);
-	if (res < 0)
-		return -errno;
-
-	if (st.st_ino != BTRFS_FIRST_FREE_OBJECTID || !S_ISDIR(st.st_mode))
-		return 0;
-
-	res = statfs(path, &stfs);
-	if (res < 0)
-		return -errno;
-
-	return (int)stfs.f_type == BTRFS_SUPER_MAGIC;
-}
-
 const char *subvol_strip_mountpoint(const char *mnt, const char *full_path)
 {
 	int len = strlen(mnt);
diff --git a/utils.h b/utils.h
index 4a95bfb5..4bfbf63e 100644
--- a/utils.h
+++ b/utils.h
@@ -147,7 +147,6 @@ u64 disk_size(const char *path);
 u64 get_partition_size(const char *dev);
 
 int test_issubvolname(const char *name);
-int test_issubvolume(const char *path);
 int test_isdir(const char *path);
 
 const char *subvol_strip_mountpoint(const char *mnt, const char *full_path);
-- 
2.16.1

