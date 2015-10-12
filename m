Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:31025 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752111AbbJLNYv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 09:24:51 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9CDOKOC026203
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 21:24:20 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 06/11] btrfs-progs: inspect: use btrfs_open_dir for btrfs inspect command
Date: Mon, 12 Oct 2015 21:22:59 +0800
Message-ID: <163c84b92016fc8905d80e820414db2dc62ab8d8.1444655800.git.zhaolei@cn.fujitsu.com>
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
  # ./btrfs inspect-internal rootid /mnt/tmp1
  ERROR: Failed to lookup root id - Inappropriate ioctl for device
  btrfs inspect-internal rootid: rootid failed with ret=-1
  # ./btrfs inspect-internal inode-resolve 256 /mnt/tmp1
  ioctl ret=-1, error: Inappropriate ioctl for device
  # ./btrfs inspect-internal min-dev-size /mnt/tmp1
  Error invoking tree search ioctl: Inappropriate ioctl for device

After patch:
  # ./btrfs inspect-internal rootid /mnt/tmp1
  ERROR: not a btrfs filesystem: /mnt/tmp1
  # ./btrfs inspect-internal inode-resolve 256 /mnt/tmp1
  ERROR: not a btrfs filesystem: /mnt/tmp1
  # ./btrfs inspect-internal min-dev-size /mnt/tmp1
  ERROR: not a btrfs filesystem: /mnt/tmp1

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-inspect.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/cmds-inspect.c b/cmds-inspect.c
index a13a170..40ab49b 100644
--- a/cmds-inspect.c
+++ b/cmds-inspect.c
@@ -116,11 +116,9 @@ static int cmd_inspect_inode_resolve(int argc, char **argv)
 	if (check_argc_exact(argc - optind, 2))
 		usage(cmd_inspect_inode_resolve_usage);
 
-	fd = open_file_or_dir(argv[optind+1], &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", argv[optind+1]);
+	fd = btrfs_open_dir(argv[optind + 1], &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
 
 	ret = __ino_to_path_fd(arg_strtou64(argv[optind]), fd, verbose,
 			       argv[optind+1]);
@@ -189,9 +187,8 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
 	loi.size = size;
 	loi.inodes = ptr_to_u64(inodes);
 
-	fd = open_file_or_dir(argv[optind+1], &dirstream);
+	fd = btrfs_open_dir(argv[optind + 1], &dirstream, 1);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", argv[optind+1]);
 		ret = 12;
 		goto out;
 	}
@@ -239,10 +236,8 @@ static int cmd_inspect_logical_resolve(int argc, char **argv)
 						name);
 				BUG_ON(ret >= bytes_left);
 				free(name);
-				path_fd = open_file_or_dir(full_path, &dirs);
+				path_fd = btrfs_open_dir(full_path, &dirs, 1);
 				if (path_fd < 0) {
-					fprintf(stderr, "ERROR: can't access "
-						"'%s'\n", full_path);
 					ret = -ENOENT;
 					goto out;
 				}
@@ -279,9 +274,8 @@ static int cmd_inspect_subvolid_resolve(int argc, char **argv)
 	if (check_argc_exact(argc, 3))
 		usage(cmd_inspect_subvolid_resolve_usage);
 
-	fd = open_file_or_dir(argv[2], &dirstream);
+	fd = btrfs_open_dir(argv[2], &dirstream, 1);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", argv[2]);
 		ret = -ENOENT;
 		goto out;
 	}
@@ -320,9 +314,8 @@ static int cmd_inspect_rootid(int argc, char **argv)
 	if (check_argc_exact(argc, 2))
 		usage(cmd_inspect_rootid_usage);
 
-	fd = open_file_or_dir(argv[1], &dirstream);
+	fd = btrfs_open_dir(argv[1], &dirstream, 1);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", argv[1]);
 		ret = -ENOENT;
 		goto out;
 	}
@@ -619,9 +612,8 @@ static int cmd_inspect_min_dev_size(int argc, char **argv)
 	if (check_argc_exact(argc - optind, 1))
 		usage(cmd_inspect_min_dev_size_usage);
 
-	fd = open_file_or_dir(argv[optind], &dirstream);
+	fd = btrfs_open_dir(argv[optind], &dirstream, 1);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", argv[optind]);
 		ret = -ENOENT;
 		goto out;
 	}
-- 
1.8.5.1

