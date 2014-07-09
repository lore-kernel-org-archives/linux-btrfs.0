Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51343 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755001AbaGIG5B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jul 2014 02:57:01 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH v2] btrfs-progs: Add mount point output for 'btrfs fi df' command.
Date: Wed, 9 Jul 2014 14:56:57 +0800
Message-ID: <1404889017-31426-1-git-send-email-quwenruo@cn.fujitsu.com>
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
v2:
  Call realpath() before find_mount_root() to deal with relative path
---
 cmds-filesystem.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 4b2d27e..77e1db0 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -187,12 +187,31 @@ static int cmd_filesystem_df(int argc, char **argv)
        int ret;
        int fd;
        char *path;
+       char *real_path = NULL;
+       char *mount_point = NULL;
        DIR *dirstream = NULL;
 
        if (check_argc_exact(argc, 2))
                usage(cmd_filesystem_df_usage);
 
        path = argv[1];
+       real_path = realpath(path, NULL);
+       if (!real_path) {
+	       fprintf(stderr, "ERROR: Failed to resolve real path for %s: %s\n",
+		       path, strerror(errno));
+	       return 1;
+       }
+       ret = find_mount_root(real_path, &mount_point);
+       if (ret < 0) {
+	       free(real_path);
+	       if (ret != -ENOENT)
+		       fprintf(stderr, "ERROR: Failed to find mount root for path %s: %s\n",
+			       path, strerror(-ret));
+		return 1;
+       }
+       free(real_path);
+       printf("Mounted on: %s\n", mount_point);
+       free(mount_point);
 
        fd = open_file_or_dir(path, &dirstream);
        if (fd < 0) {
-- 
2.0.1

