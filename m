Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57389 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab3LLHrc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 02:47:32 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBC7lTsm011376
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Dec 2013 15:47:30 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs-progs: add sanity checks for btrfs device operations
Date: Thu, 12 Dec 2013 15:47:00 +0800
Message-Id: <1386834420-1007-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Make sure we are a block device firstly, this can avoid some
unnecessary ioctls operations.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-device.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/cmds-device.c b/cmds-device.c
index bc4a8dc..ea20919 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -161,6 +161,12 @@ static int cmd_rm_dev(int argc, char **argv)
 		struct	btrfs_ioctl_vol_args arg;
 		int	res;
 
+		if (!is_block_device(argv[i])) {
+			fprintf(stderr,
+				"ERROR: %s is not a block device\n", argv[i]);
+			ret++;
+			continue;
+		}
 		strncpy_null(arg.name, argv[i]);
 		res = ioctl(fdmnt, BTRFS_IOC_RM_DEV, &arg);
 		e = errno;
@@ -222,6 +228,12 @@ static int cmd_scan_dev(int argc, char **argv)
 		struct btrfs_ioctl_vol_args args;
 		int ret;
 
+		if (!is_block_device(argv[i])) {
+			fprintf(stderr,
+				"ERROR: %s is not a block device\n", argv[i]);
+			close(fd);
+			return 1;
+		}
 		printf("Scanning for Btrfs filesystems in '%s'\n", argv[i]);
 
 		strncpy_null(args.name, argv[i]);
@@ -265,6 +277,12 @@ static int cmd_ready_dev(int argc, char **argv)
 		perror("failed to open /dev/btrfs-control");
 		return 1;
 	}
+	if (!is_block_device(argv[1])) {
+		fprintf(stderr,
+			"ERROR: %s is not a block device\n", argv[1]);
+		close(fd);
+		return 1;
+	}
 
 	strncpy(args.name, argv[argc - 1], BTRFS_PATH_NAME_MAX);
 	ret = ioctl(fd, BTRFS_IOC_DEVICES_READY, &args);
-- 
1.8.3.1

