Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21034 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756405AbbHZGRI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 02:17:08 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7Q6GxJN004414
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 14:16:59 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: Introduce open_btrfs_dir wrapper
Date: Wed, 26 Aug 2015 14:15:27 +0800
Message-ID: <5378c4862f34d6459665448b437d79d5847ce2b5.1440569707.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduce open_btrfs_dir() to open a dir in btrfs
filesystem.

It can be used for several tools in btrfs-progs.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 utils.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 utils.h |  1 +
 2 files changed, 48 insertions(+)

diff --git a/utils.c b/utils.c
index 1dfcc2d..d849929 100644
--- a/utils.c
+++ b/utils.c
@@ -36,6 +36,8 @@
 #include <limits.h>
 #include <blkid/blkid.h>
 #include <sys/vfs.h>
+#include <sys/statfs.h>
+#include <linux/magic.h>
 
 #include "kerncompat.h"
 #include "radix-tree.h"
@@ -1081,6 +1083,51 @@ int open_path_or_dev_mnt(const char *path, DIR **dirstream)
 	return fdmnt;
 }
 
+/*
+ * Do following check before open_file_or_dir():
+ * 1: path is in a btrfs filesystem
+ * 2: path is a dir
+ */
+int open_btrfs_dir(const char *path, DIR **dirstream, int output)
+{
+	struct statfs stfs;
+	struct stat st;
+
+	if (statfs(path, &stfs) != 0) {
+		if (output)
+			fprintf(stderr,
+				"ERROR: can't access '%s', %s\n",
+				path, strerror(errno));
+		return -1;
+	}
+
+	if (stfs.f_type != BTRFS_SUPER_MAGIC) {
+		if (output)
+			fprintf(stderr,
+				"ERROR: not btrfs filesystem: %s\n",
+				path);
+		return -2;
+	}
+
+	if (stat(path, &st) != 0) {
+		if (output)
+			fprintf(stderr,
+				"ERROR: can't access '%s', %s\n",
+				path, strerror(errno));
+		return -1;
+	}
+
+	if (!S_ISDIR(st.st_mode)) {
+		if (output)
+			fprintf(stderr,
+				"ERROR: not directory: %s\n",
+				path);
+		return -3;
+	}
+
+	return open_file_or_dir(path, dirstream);
+}
+
 /* checks if a device is a loop device */
 static int is_loop_device (const char* device) {
 	struct stat statbuf;
diff --git a/utils.h b/utils.h
index 8ec23c9..87c0d08 100644
--- a/utils.h
+++ b/utils.h
@@ -158,6 +158,7 @@ int is_block_device(const char *file);
 int is_mount_point(const char *file);
 int check_arg_type(const char *input);
 int open_path_or_dev_mnt(const char *path, DIR **dirstream);
+int open_btrfs_dir(const char *path, DIR **dirstream, int output);
 u64 btrfs_device_size(int fd, struct stat *st);
 /* Helper to always get proper size of the destination string */
 #define strncpy_null(dest, src) __strncpy__null(dest, src, sizeof(dest))
-- 
1.8.5.1

