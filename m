Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23303 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758482AbaGXD1q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 23:27:46 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6O3RiA0016910
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 11:27:44 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs-progs: fix improper output msg for btrfs-fi-usage
Date: Thu, 24 Jul 2014 11:21:54 +0800
Message-ID: <1406172114-10793-3-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1406172114-10793-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1406172114-10793-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Even if run as root:
	# su
	# btrfs file usage <path> <== path exits outside the mnt point
We get the output:
	WARNING: ..., run as root
	WARNING: ..., run as root
	ERROR:...

It is because in load_chunk_info, the errno of ioctl is not judged
but rather the ret value of ioctl is judged. And the ret value of
ioctl is -1 which happens to match -EPERM exactly.
So the outer warning is printed.

Just judge the errno of ioctl and prevent the ret value of load_chunk_info
to be -1 in other error conditions.

For load_device_info, the problem and fix is the same.
After the fix, the 'run as root' WARNINGs will not show up in this condition.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-fi-disk_usage.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/cmds-fi-disk_usage.c b/cmds-fi-disk_usage.c
index 1f4c88e..7c5c0cc 100644
--- a/cmds-fi-disk_usage.c
+++ b/cmds-fi-disk_usage.c
@@ -156,14 +156,14 @@ static int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count
 	while (1) {
 		ret = ioctl(fd, BTRFS_IOC_TREE_SEARCH, &args);
 		e = errno;
-		if (ret == -EPERM)
-			return ret;
+		if (e == EPERM)
+			return -e;
 
 		if (ret < 0) {
 			fprintf(stderr,
 				"ERROR: can't perform the search - %s\n",
 				strerror(e));
-			return ret;
+			return 1;
 		}
 		/* the ioctl returns the number of item it found in nr_items */
 
@@ -182,7 +182,7 @@ static int load_chunk_info(int fd, struct chunk_info **info_ptr, int *info_count
 			ret = add_info_to_list(info_ptr, info_count, item);
 			if (ret) {
 				*info_ptr = 0;
-				return ret;
+				return 1;
 			}
 
 			off += sh->len;
@@ -442,7 +442,7 @@ static int cmp_device_info(const void *a, const void *b)
 static int load_device_info(int fd, struct device_info **device_info_ptr,
 			   int *device_info_count)
 {
-	int ret, i, ndevs;
+	int ret, i, ndevs, e;
 	struct btrfs_ioctl_fs_info_args fi_args;
 	struct btrfs_ioctl_dev_info_args dev_info;
 	struct device_info *info;
@@ -451,17 +451,19 @@ static int load_device_info(int fd, struct device_info **device_info_ptr,
 	*device_info_ptr = 0;
 
 	ret = ioctl(fd, BTRFS_IOC_FS_INFO, &fi_args);
-	if (ret == -EPERM)
-		return ret;
+	e = errno;
+	if (e == EPERM)
+		return -e;
 	if (ret < 0) {
-		fprintf(stderr, "ERROR: cannot get filesystem info\n");
-		return ret;
+		fprintf(stderr, "ERROR: cannot get filesystem info - %s\n",
+				strerror(e));
+		return 1;
 	}
 
 	info = calloc(fi_args.num_devices, sizeof(struct device_info));
 	if (!info) {
 		fprintf(stderr, "ERROR: not enough memory\n");
-		return ret;
+		return 1;
 	}
 
 	for (i = 0, ndevs = 0 ; i <= fi_args.max_id ; i++) {
-- 
1.8.1.4

