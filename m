Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31219 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756417AbbHZJGF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 05:06:05 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7Q95tTu016064
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 17:05:55 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 2/2] btrfs-progs: use open_btrfs_dir for btrfs device command
Date: Wed, 26 Aug 2015 17:04:23 +0800
Message-ID: <88fb97835205d1faa824e695128eeff5927eeda1.1440579753.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1440579753.git.zhaolei@cn.fujitsu.com>
References: <cover.1440579753.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can use open_btrfs_dir() to check whether target dir is
in btrfs's mount point before open, instead of checking it in kernel
space of ioctl, and return fuzzy error message.

Before patch:
  # (/mnt/tmp is not btrfs mountpoint)
  #
  # btrfs device add -f /dev/sda13 /mnt/tmp
  ERROR: error adding the device '/dev/sda13' - Inappropriate ioctl for device
  #

After patch:
  # btrfs device add -f /dev/sda13 /mnt/tmp
  ERROR: not btrfs filesystem: /mnt/tmp
  #

Similar fix for device remove and device usage.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-device.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/cmds-device.c b/cmds-device.c
index 00e362a..2dba050 100644
--- a/cmds-device.c
+++ b/cmds-device.c
@@ -84,11 +84,9 @@ static int cmd_device_add(int argc, char **argv)
 
 	mntpnt = argv[optind + argc - 1];
 
-	fdmnt = open_file_or_dir(mntpnt, &dirstream);
-	if (fdmnt < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", mntpnt);
+	fdmnt = open_btrfs_dir(mntpnt, &dirstream, 1);
+	if (fdmnt < 0)
 		return 1;
-	}
 
 	for (i = optind; i < optind + argc - 1; i++){
 		struct btrfs_ioctl_vol_args ioctl_args;
@@ -157,11 +155,9 @@ static int _cmd_device_remove(int argc, char **argv,
 
 	mntpnt = argv[argc - 1];
 
-	fdmnt = open_file_or_dir(mntpnt, &dirstream);
-	if (fdmnt < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", mntpnt);
+	fdmnt = open_btrfs_dir(mntpnt, &dirstream, 1);
+	if (fdmnt < 0)
 		return 1;
-	}
 
 	for(i=1 ; i < argc - 1; i++ ){
 		struct	btrfs_ioctl_vol_args arg;
@@ -586,10 +582,8 @@ int cmd_device_usage(int argc, char **argv)
 		if (more_than_one)
 			printf("\n");
 
-		fd = open_file_or_dir(argv[i], &dirstream);
+		fd = open_btrfs_dir(argv[i], &dirstream, 1);
 		if (fd < 0) {
-			fprintf(stderr, "ERROR: can't access '%s'\n",
-				argv[1]);
 			ret = 1;
 			goto out;
 		}
-- 
1.8.5.1

