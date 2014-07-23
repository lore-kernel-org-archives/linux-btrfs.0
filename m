Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26807 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751299AbaGWFro (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 01:47:44 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6N5ldko029309
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Jul 2014 13:47:39 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 4/4] btrfs-progs: Add mount point output for 'btrfs fi df'
Date: Wed, 23 Jul 2014 13:47:37 +0800
Message-ID: <1406094457-3100-4-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1406094457-3100-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1406094457-3100-1-git-send-email-quwenruo@cn.fujitsu.com>
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
changelog:
v2:
  Call realpath() before find_mount_root() to deal with relative path
v3:
  Only output mount point when get_df() successed.
---

 cmds-filesystem.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 108d9b7..ca6bcad 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -187,6 +187,8 @@ static int cmd_filesystem_df(int argc, char **argv)
 	int ret;
 	int fd;
 	char *path;
+	char *real_path = NULL;
+	char *mount_point = NULL;
 	DIR *dirstream = NULL;
 
 	if (check_argc_exact(argc, 2))
@@ -194,6 +196,29 @@ static int cmd_filesystem_df(int argc, char **argv)
 
 	path = argv[1];
 
+	real_path = realpath(path, NULL);
+	if (!real_path) {
+		fprintf(stderr,
+			"ERROR: Failed to resolve real path for %s: %s\n",
+			path, strerror(errno));
+		return 1;
+	}
+	ret = find_mount_root(real_path, &mount_point);
+	if (ret < 0) {
+		fprintf(stderr,
+			"ERROR: failed to determine mount point for %s: %s\n",
+			path, strerror(-ret));
+		free(real_path);
+		return 1;
+	}
+	if (ret > 0) {
+		fprintf(stderr,
+			"ERROR: %s does not belong to a btrfs mount point\n",
+			path);
+		free(real_path);
+		return 1;
+	}
+
 	fd = open_file_or_dir(path, &dirstream);
 	if (fd < 0) {
 		fprintf(stderr, "ERROR: can't access '%s'\n", path);
@@ -201,12 +226,15 @@ static int cmd_filesystem_df(int argc, char **argv)
 	}
 	ret = get_df(fd, &sargs);
 	if (!ret && sargs) {
+		printf("Mounted on: %s\n", mount_point);
 		print_df(sargs);
 		free(sargs);
 	} else {
 		fprintf(stderr, "ERROR: get_df failed %s\n", strerror(-ret));
 	}
 
+	free(real_path);
+	free(mount_point);
 	close_file_or_dir(fd, dirstream);
 	return !!ret;
 }
-- 
2.0.2

