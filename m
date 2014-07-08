Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50548 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751852AbaGHFn1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jul 2014 01:43:27 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: Add mount point output for 'btrfs fi df' command.
Date: Tue, 8 Jul 2014 13:43:23 +0800
Message-ID: <1404798203-17122-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add mount point output for 'btrfs fi df'.
Also since the patch uses find_mount_root() to find mount point,
now 'btrfs fi df' can output more meaningful error message when given a
non-btrfs path.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
This patch needs to be merged after the following path:
btrfs-progs: Check fstype in find_mount_root()
---
 cmds-filesystem.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 4b2d27e..d571765 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -187,12 +187,22 @@ static int cmd_filesystem_df(int argc, char **argv)
        int ret;
        int fd;
        char *path;
+       char *mount_point = NULL;
        DIR *dirstream = NULL;
 
        if (check_argc_exact(argc, 2))
                usage(cmd_filesystem_df_usage);
 
        path = argv[1];
+       ret = find_mount_root(path, &mount_point);
+       if (ret < 0) {
+	       if (ret != -ENOENT)
+		       fprintf(stderr, "ERROR: Failed to find mount root for path %s: %s\n",
+			       path, strerror(-ret));
+		return 1;
+       }
+       printf("Mounted on: %s\n", mount_point);
+       free(mount_point);
 
        fd = open_file_or_dir(path, &dirstream);
        if (fd < 0) {
-- 
2.0.1

