Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:34462 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbaBGHAL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 02:00:11 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 1/2] btrfs-progs: Add missing devices check for mounted btrfs.
Date: Fri, 7 Feb 2014 14:45:59 +0800
Message-Id: <1391755560-4721-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs/003 of xfstest, it will check whether btrfs fi show can find
missing devices.

But before the patch, btrfs-progs will not check whether device missing
if given a mounted btrfs mountpoint/block device.
This patch fixes the bug and will pass btrfs/003.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 384d1b9..4c9933d 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -363,6 +363,8 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 		char *label, char *path)
 {
 	int i;
+	int fd;
+	int missing;
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
 	struct btrfs_ioctl_dev_info_args *tmp_dev_info;
 	int ret;
@@ -385,6 +387,14 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 
 	for (i = 0; i < fs_info->num_devices; i++) {
 		tmp_dev_info = (struct btrfs_ioctl_dev_info_args *)&dev_info[i];
+
+		/* Add check for missing devices even mounted */
+		fd = open((char *)tmp_dev_info->path, O_RDONLY);
+		if (fd < 0) {
+			missing = 1;
+			continue;
+		}
+		close(fd);
 		printf("\tdevid %4llu size %s used %s path %s\n",
 			tmp_dev_info->devid,
 			pretty_size(tmp_dev_info->total_bytes),
@@ -392,6 +402,8 @@ static int print_one_fs(struct btrfs_ioctl_fs_info_args *fs_info,
 			tmp_dev_info->path);
 	}
 
+	if (missing)
+		printf("\t*** Some devices missing\n");
 	printf("\n");
 	return 0;
 }
-- 
1.8.5.4

