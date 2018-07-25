Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:45088 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728673AbeGYJ1l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jul 2018 05:27:41 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 3779DAC015F
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2018 17:17:01 +0900 (JST)
Received: from g01jpexchyt33.g01.fujitsu.local (unknown [10.128.193.4])
        by g01jpfmpwyt01.exch.g01.fujitsu.local (Postfix) with ESMTP id 556A06D68F8
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jul 2018 17:17:00 +0900 (JST)
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] btrfs-progs: ins: logical-resolve: Print message when path cannot be resolved
Date: Wed, 25 Jul 2018 17:20:17 +0900
Message-ID: <a5545edbef2d2b1800a5ea83d9c14773b5b1fbe7.1532501096.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1532501096.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1532501096.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since BTRFS_IOC_INO_PATHS requires fd of subvolume, logical-resolve
cannot find the path when mount point is not FS_TREE
(because the subvolume path cannot be opened).

In that case, print message to try -P option instead.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 cmds-inspect.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index ac77a5ee..21aa2903 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -137,16 +137,18 @@ static const char * const cmd_inspect_logical_resolve_usage[] = {
 static int cmd_inspect_logical_resolve(int argc, char **argv)
 {
 	int ret;
-	int fd;
+	int fd = -1;
 	int i;
 	int verbose = 0;
 	int getpath = 1;
 	int bytes_left;
+	u64 rootid;
 	struct btrfs_ioctl_logical_ino_args loi;
 	struct btrfs_data_container *inodes;
 	u64 size = 4096;
 	char full_path[PATH_MAX];
 	char *path_ptr;
+	char *mount_path = NULL;
 	DIR *dirstream = NULL;
 
 	optind = 0;
@@ -178,6 +180,35 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
 	if (!inodes)
 		return 1;
 
+	/* Check if mount root is FS_ROOT */
+	if (getpath) {
+		ret = find_mount_root(argv[optind + 1], &mount_path);
+		if (ret) {
+			error("cannot find mount root: %m");
+			goto out;
+		}
+
+		fd = btrfs_open_file_or_dir(mount_path, &dirstream, 1);
+		if (fd < 0) {
+			ret = 1;
+			goto out;
+		}
+
+		ret = lookup_path_rootid(fd, &rootid);
+		if (ret) {
+			error("failed to lookup root id: %m");
+			goto out;
+		}
+
+		if (rootid != BTRFS_FS_TREE_OBJECTID) {
+			ret = 1;
+printf("cannot resolve path when subvolume is mounted directly. try -P option\n");
+			goto out;
+		}
+
+		close_file_or_dir(fd, dirstream);
+	}
+
 	memset(inodes, 0, sizeof(*inodes));
 	loi.logical = arg_strtou64(argv[optind]);
 	loi.size = size;
@@ -259,6 +290,7 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
 out:
 	close_file_or_dir(fd, dirstream);
 	free(inodes);
+	free(mount_path);
 	return !!ret;
 }
 
-- 
2.14.4


