Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3218 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab3LKLXM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Dec 2013 06:23:12 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBBBMYPn008593
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Dec 2013 19:22:34 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: make sure we are not opening a block device in open_file_or_dir()
Date: Wed, 11 Dec 2013 19:22:06 +0800
Message-Id: <1386760926-4181-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now, open_file_or_dir() will return successfully if we pass a block device
for it, this is wrong, we should check if it is a block device before trying
to open it.

Before this patch:
 # btrfs sub list /dev/sda8

It will output the following message:
ERROR: can't perform the search -Inappropriate ioctl for device
ERROR: can't get rootid for '/dev/sda8

After applying the patch, it will output:
ERROR: can't access '/dev/sda8'

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 utils.c | 50 ++++++++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff --git a/utils.c b/utils.c
index f499023..1c168e2 100644
--- a/utils.c
+++ b/utils.c
@@ -755,6 +755,31 @@ out:
 	return ret;
 }
 
+static int __open_file_or_dir(const char *fname, DIR **dirstream)
+{
+	int ret;
+	struct stat st;
+	int fd;
+
+	ret = stat(fname, &st);
+	if (ret < 0)
+		return -1;
+	if (S_ISDIR(st.st_mode)) {
+		*dirstream = opendir(fname);
+		if (!*dirstream)
+			return -2;
+		fd = dirfd(*dirstream);
+	} else {
+		fd = open(fname, O_RDWR);
+	}
+	if (fd < 0) {
+		fd = -3;
+		if (*dirstream)
+			closedir(*dirstream);
+	}
+	return fd;
+}
+
 /*
  * Given a pathname, return a filehandle to:
  * 	the original pathname or,
@@ -776,7 +801,7 @@ int open_path_or_dev_mnt(const char *path, DIR **dirstream)
 			errno = EINVAL;
 			return -1;
 		}
-		fdmnt = open_file_or_dir(mp, dirstream);
+		fdmnt = __open_file_or_dir(mp, dirstream);
 	} else {
 		fdmnt = open_file_or_dir(path, dirstream);
 	}
@@ -1557,28 +1582,9 @@ u64 parse_size(char *s)
 
 int open_file_or_dir(const char *fname, DIR **dirstream)
 {
-	int ret;
-	struct stat st;
-	int fd;
-
-	ret = stat(fname, &st);
-	if (ret < 0) {
+	if (is_block_device(fname))
 		return -1;
-	}
-	if (S_ISDIR(st.st_mode)) {
-		*dirstream = opendir(fname);
-		if (!*dirstream)
-			return -2;
-		fd = dirfd(*dirstream);
-	} else {
-		fd = open(fname, O_RDWR);
-	}
-	if (fd < 0) {
-		fd = -3;
-		if (*dirstream)
-			closedir(*dirstream);
-	}
-	return fd;
+	return __open_file_or_dir(fname, dirstream);
 }
 
 void close_file_or_dir(int fd, DIR *dirstream)
-- 
1.8.3.1

