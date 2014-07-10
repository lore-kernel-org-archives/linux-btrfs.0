Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38118 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755481AbaGJDFS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jul 2014 23:05:18 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6A35FQm026114
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Jul 2014 11:05:15 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 RESEND 4/4] btrfs-progs: Add mount point output for 'btrfs fi df'
Date: Thu, 10 Jul 2014 11:05:13 +0800
Message-ID: <1404961513-14614-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1404961513-14614-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1404961513-14614-1-git-send-email-quwenruo@cn.fujitsu.com>
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
 cmds-filesystem.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 0a9b62a..d76a1a5 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -187,12 +187,28 @@ static int cmd_filesystem_df(int argc, char **argv)
 	int ret;
 	int fd;
 	char *path;
+	char *real_path = NULL;
+	char *mount_point = NULL;
 	DIR *dirstream = NULL;
 
 	if (check_argc_exact(argc, 2))
 		usage(cmd_filesystem_df_usage);
 
 	path = argv[1];
+	real_path = realpath(path, NULL);
+	if (!real_path) {
+		fprintf(stderr, "ERROR: Failed to resolve real path for %s: %s\n",
+			path, strerror(errno));
+		return 1;
+	}
+	ret = find_mount_root(real_path, &mount_point);
+	if (ret < 0) {
+		free(real_path);
+		return 1;
+	}
+	printf("Mounted on: %s\n", mount_point);
+	free(real_path);
+	free(mount_point);
 
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
-- 
2.0.1

