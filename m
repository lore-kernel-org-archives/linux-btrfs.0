Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:48927 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750704AbdIDFFn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Sep 2017 01:05:43 -0400
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 419B1AC00C0
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Sep 2017 14:05:39 +0900 (JST)
Received: from G01JPEXCHYT16.g01.fujitsu.local (G01JPEXCHYT16.g01.fujitsu.local [10.128.194.55])
        by g01jpfmpwyt02.exch.g01.fujitsu.local (Postfix) with ESMTP id 89FDA584290
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Sep 2017 14:05:38 +0900 (JST)
To: <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH] btrfs-progs: inspect-internal rootid: Allow a file to be
 specified
Message-ID: <1d4ee017-33a3-f7dc-7347-a98b099e5f5b@jp.fujitsu.com>
Date: Mon, 4 Sep 2017 14:05:34 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since cmd_inspect_rootid() calls btrfs_open_dir(), it rejects a file to
be spcified. But as the document says, a file should be supported.

This patch introduces btrfs_open_file_or_dir(), which is a counterpart
of btrfs_open_dir(), to safely check and open btrfs file or directory.
The original btrfs_open_dir() codes are moved to btrfs_open() and shared
by both function.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 cmds-inspect.c |  2 +-
 utils.c        | 16 +++++++++++++---
 utils.h        |  2 ++
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index d1a3a0e..885f3ab 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -318,7 +318,7 @@ static int cmd_inspect_rootid(int argc, char **argv)
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_inspect_rootid_usage);
 
-	fd = btrfs_open_dir(argv[optind], &dirstream, 1);
+	fd = btrfs_open_file_or_dir(argv[optind], &dirstream, 1);
 	if (fd < 0) {
 		ret = -ENOENT;
 		goto out;
diff --git a/utils.c b/utils.c
index bb04913..9db39eb 100644
--- a/utils.c
+++ b/utils.c
@@ -568,9 +568,9 @@ int open_path_or_dev_mnt(const char *path, DIR **dirstream, int verbose)
 /*
  * Do the following checks before calling open_file_or_dir():
  * 1: path is in a btrfs filesystem
- * 2: path is a directory
+ * 2: path is a directory if dir_only is 1
  */
-int btrfs_open_dir(const char *path, DIR **dirstream, int verbose)
+int btrfs_open(const char *path, DIR **dirstream, int verbose, int dir_only)
 {
 	struct statfs stfs;
 	struct stat st;
@@ -593,7 +593,7 @@ int btrfs_open_dir(const char *path, DIR **dirstream, int verbose)
 		return -1;
 	}
 
-	if (!S_ISDIR(st.st_mode)) {
+	if (dir_only && !S_ISDIR(st.st_mode)) {
 		error_on(verbose, "not a directory: %s", path);
 		return -3;
 	}
@@ -607,6 +607,16 @@ int btrfs_open_dir(const char *path, DIR **dirstream, int verbose)
 	return ret;
 }
 
+int btrfs_open_dir(const char *path, DIR **dirstream, int verbose)
+{
+	return btrfs_open(path, dirstream, verbose, 1);
+}
+
+int btrfs_open_file_or_dir(const char *path, DIR **dirstream, int verbose)
+{
+	return btrfs_open(path, dirstream, verbose, 0);
+}
+
 /* checks if a device is a loop device */
 static int is_loop_device (const char* device) {
 	struct stat statbuf;
diff --git a/utils.h b/utils.h
index 091f8fa..d28a05a 100644
--- a/utils.h
+++ b/utils.h
@@ -108,7 +108,9 @@ int is_block_device(const char *file);
 int is_mount_point(const char *file);
 int check_arg_type(const char *input);
 int open_path_or_dev_mnt(const char *path, DIR **dirstream, int verbose);
+int btrfs_open(const char *path, DIR **dirstream, int verbose, int dir_only);
 int btrfs_open_dir(const char *path, DIR **dirstream, int verbose);
+int btrfs_open_file_or_dir(const char *path, DIR **dirstream, int verbose);
 u64 btrfs_device_size(int fd, struct stat *st);
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy_null(dest, src, sizeof(dest))
-- 
2.9.5

