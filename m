Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36424 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751590AbaLYBS6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 20:18:58 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sBP1IRPc019401
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Dec 2014 09:18:27 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: move check_arg_type() to util.c
Date: Thu, 25 Dec 2014 09:16:34 +0800
Message-ID: <1419470195-2889-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The check_arg_type() function does quite generic thing,
move it to utils.c.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-filesystem.c | 32 --------------------------------
 utils.c           | 32 ++++++++++++++++++++++++++++++++
 utils.h           |  1 +
 3 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 253f105..4d7a797 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -537,38 +537,6 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 	return 0;
 }
 
-/* This function checks if the given input parameter is
- * an uuid or a path
- * return -1: some error in the given input
- * return 0: unknow input
- * return 1: given input is uuid
- * return 2: given input is path
- */
-static int check_arg_type(char *input)
-{
-	uuid_t	out;
-	char path[PATH_MAX];
-
-	if (!input)
-		return -EINVAL;
-
-	if (realpath(input, path)) {
-		if (is_block_device(path) == 1)
-			return BTRFS_ARG_BLKDEV;
-
-		if (is_mount_point(path) == 1)
-			return BTRFS_ARG_MNTPOINT;
-
-		return BTRFS_ARG_UNKNOWN;
-	}
-
-	if (strlen(input) == (BTRFS_UUID_UNPARSED_SIZE - 1) &&
-		!uuid_parse(input, out))
-		return BTRFS_ARG_UUID;
-
-	return BTRFS_ARG_UNKNOWN;
-}
-
 static int btrfs_scan_kernel(void *search)
 {
 	int ret = 0, fd;
diff --git a/utils.c b/utils.c
index 2a92416..80f85e9 100644
--- a/utils.c
+++ b/utils.c
@@ -852,6 +852,38 @@ int is_mount_point(const char *path)
 	return ret;
 }
 
+/* This function checks if the given input parameter is
+ * an uuid or a path
+ * return -1: some error in the given input
+ * return 0: unknow input
+ * return 1: given input is uuid
+ * return 2: given input is path
+ */
+int check_arg_type(const char *input)
+{
+	uuid_t	out;
+	char path[PATH_MAX];
+
+	if (!input)
+		return -EINVAL;
+
+	if (realpath(input, path)) {
+		if (is_block_device(path) == 1)
+			return BTRFS_ARG_BLKDEV;
+
+		if (is_mount_point(path) == 1)
+			return BTRFS_ARG_MNTPOINT;
+
+		return BTRFS_ARG_UNKNOWN;
+	}
+
+	if (strlen(input) == (BTRFS_UUID_UNPARSED_SIZE - 1) &&
+		!uuid_parse(input, out))
+		return BTRFS_ARG_UUID;
+
+	return BTRFS_ARG_UNKNOWN;
+}
+
 /*
  * Find the mount point for a mounted device.
  * On success, returns 0 with mountpoint in *mp.
diff --git a/utils.h b/utils.h
index 289e86b..8d67720 100644
--- a/utils.h
+++ b/utils.h
@@ -115,6 +115,7 @@ int set_label(const char *btrfs_dev, const char *label);
 char *__strncpy__null(char *dest, const char *src, size_t n);
 int is_block_device(const char *file);
 int is_mount_point(const char *file);
+int check_arg_type(const char *input);
 int open_path_or_dev_mnt(const char *path, DIR **dirstream);
 u64 btrfs_device_size(int fd, struct stat *st);
 /* Helper to always get proper size of the destination string */
-- 
1.8.1.4

