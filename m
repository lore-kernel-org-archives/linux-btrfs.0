Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19752 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752342AbbJLNYy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 09:24:54 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9CDONjx026216
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 21:24:23 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 10/11] btrfs-progs: replace: use btrfs_open_dir for btrfs replace command
Date: Mon, 12 Oct 2015 21:23:03 +0800
Message-ID: <4eb5c0f11f4eac93a66e38f114c72bf07ef49704.1444655800.git.zhaolei@cn.fujitsu.com>
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
  # ./btrfs replace cancel /mnt/tmp1
  ERROR: ioctl(DEV_REPLACE_CANCEL) failed on "/mnt/tmp1": Inappropriate ioctl for device
  # ./btrfs replace status /mnt/tmp1
  ERROR: ioctl(DEV_REPLACE_STATUS) failed on "/mnt/tmp1": Inappropriate ioctl for device

After patch:
  # ./btrfs replace cancel /mnt/tmp1
  ERROR: not a btrfs filesystem: /mnt/tmp1
  # ./btrfs replace status /mnt/tmp1
  ERROR: not a btrfs filesystem: /mnt/tmp1

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-replace.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/cmds-replace.c b/cmds-replace.c
index 385b764..9596f2a 100644
--- a/cmds-replace.c
+++ b/cmds-replace.c
@@ -348,7 +348,6 @@ static const char *const cmd_replace_status_usage[] = {
 static int cmd_replace_status(int argc, char **argv)
 {
 	int fd;
-	int e;
 	int c;
 	char *path;
 	int once = 0;
@@ -370,13 +369,9 @@ static int cmd_replace_status(int argc, char **argv)
 		usage(cmd_replace_status_usage);
 
 	path = argv[optind];
-	fd = open_file_or_dir(path, &dirstream);
-	e = errno;
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access \"%s\": %s\n",
-			path, strerror(e));
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
 
 	ret = print_replace_status(fd, path, once);
 	close_file_or_dir(fd, dirstream);
@@ -541,12 +536,9 @@ static int cmd_replace_cancel(int argc, char **argv)
 		usage(cmd_replace_cancel_usage);
 
 	path = argv[optind];
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access \"%s\": %s\n",
-			path, strerror(errno));
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
 
 	args.cmd = BTRFS_IOCTL_DEV_REPLACE_CMD_CANCEL;
 	args.result = BTRFS_IOCTL_DEV_REPLACE_RESULT_NO_RESULT;
-- 
1.8.5.1

