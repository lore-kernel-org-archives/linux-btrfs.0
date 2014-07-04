Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52757 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751729AbaGDIhu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 04:37:50 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s648blA1001909
	for <linux-btrfs@vger.kernel.org>; Fri, 4 Jul 2014 16:37:47 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: Add mount point check for 'btrfs fi df' command
Date: Fri, 4 Jul 2014 16:38:49 +0800
Message-ID: <1404463129-28350-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1404463129-28350-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1404463129-28350-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

'btrfs fi df' command is currently able to be executed on any file/dir
inside btrfs since it uses btrfs ioctl to get disk usage info.

However it is somewhat confusing for some end users since normally such
command should only be executed on a mount point.

This patch add mount point check in 'btrfs fi df' and if a file/dir
inside a btrfs is given, a warning message will be printed and still
output the disk usage info to keep the old behavior.

Reported-by: Vikram Goyal <vikigoyal@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-filesystem.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 4b2d27e..bce882f 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -187,6 +187,8 @@ static int cmd_filesystem_df(int argc, char **argv)
        int ret;
        int fd;
        char *path;
+       char *real_path = NULL;
+       char *mount_point = NULL;
        DIR *dirstream = NULL;
 
        if (check_argc_exact(argc, 2))
@@ -194,9 +196,30 @@ static int cmd_filesystem_df(int argc, char **argv)
 
        path = argv[1];
 
+       ret = find_mount_root(path, &mount_point);
+       if (ret < 0) {
+	       fprintf(stderr, "ERROR: fail to find mount root of %s: %s\n",
+		       path, strerror(-ret));
+	       return 1;
+       }
+       real_path = realpath(path, NULL);
+       if (!real_path) {
+	       fprintf(stderr, "ERROR: failed to find realpath of %s: %s\n",
+		       path, strerror(errno));
+	       free(mount_point);
+	       return 1;
+       }
+       if (strcmp(real_path, mount_point)) {
+	       fprintf(stderr, "WARNING: %s is not a mount point\n", path);
+	       fprintf(stderr, "WARNING: report disk usage of %s instead\n",
+		       mount_point);
+       }
+       free(real_path);
+       path = mount_point;
        fd = open_file_or_dir(path, &dirstream);
        if (fd < 0) {
                fprintf(stderr, "ERROR: can't access '%s'\n", path);
+	       free(mount_point);
                return 1;
        }
        ret = get_df(fd, &sargs);
@@ -209,6 +232,7 @@ static int cmd_filesystem_df(int argc, char **argv)
        }
 
        close_file_or_dir(fd, dirstream);
+       free(mount_point);
        return !!ret;
 }
 
-- 
2.0.1

