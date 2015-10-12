Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31025 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751801AbbJLNYu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 09:24:50 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9CDOHZX026193
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 21:24:17 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 03/11] btrfs-progs: balance: use btrfs_open_dir for btrfs balance command
Date: Mon, 12 Oct 2015 21:22:56 +0800
Message-ID: <15f0b11f8422b65a93f30e4ce6091587e17108da.1444655800.git.zhaolei@cn.fujitsu.com>
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
  # btrfs balance start /mnt/tmp
  ERROR: error during balancing '/mnt/tmp' - Inappropriate ioctl for device
  There may be more info in syslog - try dmesg | tail
  #

After patch:
  # btrfs balance start /mnt/tmp
  ERROR: not btrfs filesystem: /mnt/tmp
  #

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-balance.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/cmds-balance.c b/cmds-balance.c
index 9af218b..b02e40d 100644
--- a/cmds-balance.c
+++ b/cmds-balance.c
@@ -306,11 +306,9 @@ static int do_balance(const char *path, struct btrfs_ioctl_balance_args *args,
 	int e;
 	DIR *dirstream = NULL;
 
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
 
 	ret = ioctl(fd, BTRFS_IOC_BALANCE_V2, args);
 	e = errno;
@@ -503,11 +501,9 @@ static int cmd_balance_pause(int argc, char **argv)
 
 	path = argv[1];
 
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
 
 	ret = ioctl(fd, BTRFS_IOC_BALANCE_CTL, BTRFS_BALANCE_CTL_PAUSE);
 	e = errno;
@@ -544,11 +540,9 @@ static int cmd_balance_cancel(int argc, char **argv)
 
 	path = argv[1];
 
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
 
 	ret = ioctl(fd, BTRFS_IOC_BALANCE_CTL, BTRFS_BALANCE_CTL_CANCEL);
 	e = errno;
@@ -586,11 +580,9 @@ static int cmd_balance_resume(int argc, char **argv)
 
 	path = argv[1];
 
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
 
 	memset(&args, 0, sizeof(args));
 	args.flags |= BTRFS_BALANCE_RESUME;
@@ -679,11 +671,9 @@ static int cmd_balance_status(int argc, char **argv)
 
 	path = argv[optind];
 
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
 		return 2;
-	}
 
 	ret = ioctl(fd, BTRFS_IOC_BALANCE_PROGRESS, &args);
 	e = errno;
-- 
1.8.5.1

