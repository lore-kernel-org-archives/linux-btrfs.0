Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38274 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752111AbbJLNYt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 09:24:49 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9CDOH1Q026190
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 21:24:17 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 02/11] btrfs-progs: filesystem: use btrfs_open_dir for btrfs filesystem command
Date: Mon, 12 Oct 2015 21:22:55 +0800
Message-ID: <7c63fe4764710e398157c5ba112e2fc6c52a622b.1444655800.git.zhaolei@cn.fujitsu.com>
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
  # (/mnt/tmp is not btrfs mountpoint)
  #
  # btrfs filesystem df /mnt/tmp
  ERROR: couldn't get space info - Inappropriate ioctl for device
  ERROR: get_df failed Inappropriate ioctl for device
  #

After patch:
  # ./btrfs filesystem df /mnt/tmp
  ERROR: not btrfs filesystem: /mnt/tmp
  #

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-fi-usage.c   |  4 +---
 cmds-filesystem.c | 19 +++++++------------
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/cmds-fi-usage.c b/cmds-fi-usage.c
index 50d6333..5fefed4 100644
--- a/cmds-fi-usage.c
+++ b/cmds-fi-usage.c
@@ -901,10 +901,8 @@ int cmd_filesystem_usage(int argc, char **argv)
 		int chunkcount = 0;
 		int devcount = 0;
 
-		fd = open_file_or_dir(argv[i], &dirstream);
+		fd = btrfs_open_dir(argv[i], &dirstream, 1);
 		if (fd < 0) {
-			fprintf(stderr, "ERROR: can't access '%s'\n",
-				argv[i]);
 			ret = 1;
 			goto out;
 		}
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 3663734..91bf1fa 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -205,11 +205,10 @@ static int cmd_filesystem_df(int argc, char **argv)
 
 	path = argv[1];
 
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
+
 	ret = get_df(fd, &sargs);
 
 	if (ret == 0) {
@@ -939,11 +938,9 @@ static int cmd_filesystem_sync(int argc, char **argv)
 
 	path = argv[1];
 
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
 
 	printf("FSSync '%s'\n", path);
 	res = ioctl(fd, BTRFS_IOC_SYNC);
@@ -1229,11 +1226,9 @@ static int cmd_filesystem_resize(int argc, char **argv)
 		return 1;
 	}
 
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
 
 	printf("Resize '%s' of '%s'\n", path, amount);
 	memset(&args, 0, sizeof(args));
-- 
1.8.5.1

