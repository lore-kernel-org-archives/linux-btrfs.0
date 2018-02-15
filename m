Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:42397 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1167182AbeBOTFy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:54 -0500
Received: by mail-pg0-f65.google.com with SMTP id y8so494537pgr.9
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:54 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 24/27] btrfs-progs: replace test_issubvolume() with btrfs_util_is_subvolume()
Date: Thu, 15 Feb 2018 11:05:09 -0800
Message-Id: <e663b885b0ff54aa31f5c79841c6d4621a62d41f.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

This gets the remaining occurrences that weren't covered by previous
conversions.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 cmds-qgroup.c    | 11 ++++-------
 cmds-subvolume.c | 10 +++-------
 utils.c          | 34 +++++-----------------------------
 utils.h          |  1 -
 4 files changed, 12 insertions(+), 44 deletions(-)

diff --git a/cmds-qgroup.c b/cmds-qgroup.c
index f9a52fa8..f733565e 100644
--- a/cmds-qgroup.c
+++ b/cmds-qgroup.c
@@ -425,6 +425,7 @@ static int cmd_qgroup_limit(int argc, char **argv)
 	int compressed = 0;
 	int exclusive = 0;
 	DIR *dirstream = NULL;
+	enum btrfs_util_error err;
 
 	while (1) {
 		int c = getopt(argc, argv, "ce");
@@ -465,13 +466,9 @@ static int cmd_qgroup_limit(int argc, char **argv)
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
index 9bab9312..43875c96 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -756,13 +756,9 @@ static int cmd_subvol_find_new(int argc, char **argv)
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
index 6e6f295f..9be91437 100644
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
@@ -1453,6 +1455,7 @@ u64 parse_qgroupid(const char *p)
 	char *s = strchr(p, '/');
 	const char *ptr_src_end = p + strlen(p);
 	char *ptr_parse_end = NULL;
+	enum btrfs_util_error err;
 	u64 level;
 	u64 id;
 	int fd;
@@ -1480,8 +1483,8 @@ u64 parse_qgroupid(const char *p)
 
 path:
 	/* Path format like subv at 'my_subvol' is the fallback case */
-	ret = test_issubvolume(p);
-	if (ret < 0 || !ret)
+	err = btrfs_util_is_subvolume(p);
+	if (err)
 		goto err;
 	fd = open(p, O_RDONLY);
 	if (fd < 0)
@@ -2451,33 +2454,6 @@ int test_issubvolname(const char *name)
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
index eb460e9b..403de481 100644
--- a/utils.h
+++ b/utils.h
@@ -149,7 +149,6 @@ u64 disk_size(const char *path);
 u64 get_partition_size(const char *dev);
 
 int test_issubvolname(const char *name);
-int test_issubvolume(const char *path);
 int test_isdir(const char *path);
 
 const char *subvol_strip_mountpoint(const char *mnt, const char *full_path);
-- 
2.16.1

