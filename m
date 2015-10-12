Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31025 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752262AbbJLNYw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 09:24:52 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9CDOLUZ026209
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 21:24:21 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 08/11] btrfs-progs: quota: use btrfs_open_dir for btrfs quota command
Date: Mon, 12 Oct 2015 21:23:01 +0800
Message-ID: <cfac267670bd35514bfe4eaf25192b467d3b41ce.1444655800.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1444655800.git.zhaolei@cn.fujitsu.com>
References: <cover.1444655800.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can use btrfs_open_dir() to check whether target dir is
in btrfs's mount point before open, instead of checking it in
kernel space of ioctl, and return fuzzy error message.

Before patch:
  # ./btrfs quota enable /mnt/tmp1
  ERROR: quota command failed: Inappropriate ioctl for device
  # ./btrfs quota disable /mnt/tmp1
  ERROR: quota command failed: Inappropriate ioctl for device
  # ./btrfs quota rescan /mnt/tmp1
  ERROR: quota rescan failed: Inappropriate ioctl for device
  #

After patch:
  # ./btrfs quota enable /mnt/tmp1
  ERROR: not a btrfs filesystem: /mnt/tmp1
  # ./btrfs quota disable /mnt/tmp1
  ERROR: not a btrfs filesystem: /mnt/tmp1
  # ./btrfs quota rescan /mnt/tmp1
  ERROR: not a btrfs filesystem: /mnt/tmp1
  #

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-quota.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/cmds-quota.c b/cmds-quota.c
index 8adc1bf..efbc3ef 100644
--- a/cmds-quota.c
+++ b/cmds-quota.c
@@ -45,11 +45,9 @@ static int quota_ctl(int cmd, int argc, char **argv)
 	memset(&args, 0, sizeof(args));
 	args.cmd = cmd;
 
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
 
 	ret = ioctl(fd, BTRFS_IOC_QUOTA_CTL, &args);
 	e = errno;
@@ -141,11 +139,9 @@ static int cmd_quota_rescan(int argc, char **argv)
 	memset(&args, 0, sizeof(args));
 
 	path = argv[optind];
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
 
 	ret = ioctl(fd, ioctlnum, &args);
 	e = errno;
-- 
1.8.5.1

