Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15263 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756236AbbHZJGD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 05:06:03 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7Q95sJo016061
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 17:05:54 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 1/2] btrfs-progs: Introduce open_btrfs_dir wrapper
Date: Wed, 26 Aug 2015 17:04:22 +0800
Message-ID: <f1ac41c81d460158be008fa8a02a06b22495a221.1440579753.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1440579753.git.zhaolei@cn.fujitsu.com>
References: <cover.1440579753.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduce open_btrfs_dir() to open a dir in btrfs
filesystem.

It can be used for several tools in btrfs-progs.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 utils.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils.h |  1 +
 2 files changed, 57 insertions(+)

diff --git a/utils.c b/utils.c
index 1dfcc2d..eb9a605 100644
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
@@ -1081,6 +1083,60 @@ int open_path_or_dev_mnt(const char *path, DIR **dirstream)
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
+	int ret;
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
+	ret = open_file_or_dir(path, dirstream);
+	if (ret < 0) {
+		if (output)
+			fprintf(stderr,
+				"ERROR: can't access '%s', %s\n",
+				path, strerror(errno));
+	}
+
+	return ret;
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

