Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19752 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752010AbbJLNYu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Oct 2015 09:24:50 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9CDOGAh026186
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2015 21:24:16 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 01/11] btrfs-progs: subvolume: use btrfs_open_dir for btrfs subvolume command
Date: Mon, 12 Oct 2015 21:22:54 +0800
Message-ID: <603fb3f6409c0dc5bfb53a7865eb4595dd2235a1.1444655800.git.zhaolei@cn.fujitsu.com>
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
  # btrfs subvolume create /mnt/tmp/123
  Create subvolume '/mnt/tmp/123'
  ERROR: cannot create subvolume - Inappropriate ioctl for device
  #

After patch:
  # btrfs subvolume create /mnt/tmp/123
  ERROR: not btrfs filesystem: /mnt/tmp
  #

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 cmds-subvolume.c | 56 +++++++++++++++++++-------------------------------------
 1 file changed, 19 insertions(+), 37 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index c40330a..be1a54a 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -181,11 +181,9 @@ static int cmd_subvol_create(int argc, char **argv)
 		goto out;
 	}
 
-	fddst = open_file_or_dir(dstdir, &dirstream);
-	if (fddst < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", dstdir);
+	fddst = btrfs_open_dir(dstdir, &dirstream, 1);
+	if (fddst < 0)
 		goto out;
-	}
 
 	printf("Create subvolume '%s/%s'\n", dstdir, newname);
 	if (inherit) {
@@ -348,9 +346,8 @@ again:
 	vname = basename(dupvname);
 	free(cpath);
 
-	fd = open_file_or_dir(dname, &dirstream);
+	fd = btrfs_open_dir(dname, &dirstream, 1);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", dname);
 		ret = 1;
 		goto out;
 	}
@@ -564,7 +561,7 @@ static int cmd_subvol_list(int argc, char **argv)
 	}
 
 	subvol = argv[optind];
-	fd = open_file_or_dir(subvol, &dirstream);
+	fd = btrfs_open_dir(subvol, &dirstream, 1);
 	if (fd < 0) {
 		ret = -1;
 		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
@@ -723,17 +720,13 @@ static int cmd_subvol_snapshot(int argc, char **argv)
 		goto out;
 	}
 
-	fddst = open_file_or_dir(dstdir, &dirstream1);
-	if (fddst < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", dstdir);
+	fddst = btrfs_open_dir(dstdir, &dirstream1, 1);
+	if (fddst < 0)
 		goto out;
-	}
 
-	fd = open_file_or_dir(subvol, &dirstream2);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", dstdir);
+	fd = btrfs_open_dir(subvol, &dirstream2, 1);
+	if (fd < 0)
 		goto out;
-	}
 
 	if (readonly) {
 		args.flags |= BTRFS_SUBVOL_RDONLY;
@@ -791,11 +784,9 @@ static int cmd_subvol_get_default(int argc, char **argv)
 		usage(cmd_subvol_get_default_usage);
 
 	subvol = argv[1];
-	fd = open_file_or_dir(subvol, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
+	fd = btrfs_open_dir(subvol, &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
 
 	ret = btrfs_list_get_default_subvolume(fd, &default_id);
 	if (ret) {
@@ -859,11 +850,9 @@ static int cmd_subvol_set_default(int argc, char **argv)
 
 	objectid = arg_strtou64(subvolid);
 
-	fd = open_file_or_dir(path, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", path);
+	fd = btrfs_open_dir(path, &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
 
 	ret = ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
 	e = errno;
@@ -906,11 +895,9 @@ static int cmd_subvol_find_new(int argc, char **argv)
 		return 1;
 	}
 
-	fd = open_file_or_dir(subvol, &dirstream);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
+	fd = btrfs_open_dir(subvol, &dirstream, 1);
+	if (fd < 0)
 		return 1;
-	}
 
 	ret = ioctl(fd, BTRFS_IOC_SYNC);
 	if (ret < 0) {
@@ -980,11 +967,9 @@ static int cmd_subvol_show(int argc, char **argv)
 	ret = 1;
 	svpath = get_subvol_name(mnt, fullpath);
 
-	fd = open_file_or_dir(fullpath, &dirstream1);
-	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", fullpath);
+	fd = btrfs_open_dir(fullpath, &dirstream1, 1);
+	if (fd < 0)
 		goto out;
-	}
 
 	ret = btrfs_list_get_path_rootid(fd, &sv_id);
 	if (ret) {
@@ -993,11 +978,9 @@ static int cmd_subvol_show(int argc, char **argv)
 		goto out;
 	}
 
-	mntfd = open_file_or_dir(mnt, &dirstream2);
-	if (mntfd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", mnt);
+	mntfd = btrfs_open_dir(mnt, &dirstream2, 1);
+	if (mntfd < 0)
 		goto out;
-	}
 
 	if (sv_id == BTRFS_FS_TREE_OBJECTID) {
 		printf("%s is btrfs root\n", fullpath);
@@ -1271,9 +1254,8 @@ static int cmd_subvol_sync(int argc, char **argv)
 	if (check_argc_min(argc - optind, 1))
 		usage(cmd_subvol_sync_usage);
 
-	fd = open_file_or_dir(argv[optind], &dirstream);
+	fd = btrfs_open_dir(argv[optind], &dirstream, 1);
 	if (fd < 0) {
-		fprintf(stderr, "ERROR: can't access '%s'\n", argv[optind]);
 		ret = 1;
 		goto out;
 	}
-- 
1.8.5.1

