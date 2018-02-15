Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:34350 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161634AbeBOTFr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Feb 2018 14:05:47 -0500
Received: by mail-pl0-f67.google.com with SMTP id bd10so360893plb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Feb 2018 11:05:47 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH v2 18/27] btrfs-progs: use libbtrfsutil for set-default
Date: Thu, 15 Feb 2018 11:05:03 -0800
Message-Id: <c3478546696001ebc2763ff0d6f9807870c4beeb.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
In-Reply-To: <cover.1518720598.git.osandov@fb.com>
References: <cover.1518720598.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 cmds-subvolume.c | 43 ++++++++-----------------------------------
 1 file changed, 8 insertions(+), 35 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 6006a278..700e822c 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -851,11 +851,9 @@ static const char * const cmd_subvol_set_default_usage[] = {
 
 static int cmd_subvol_set_default(int argc, char **argv)
 {
-	int	ret=0, fd;
-	u64	objectid;
-	char	*path;
-	char	*subvolid;
-	DIR	*dirstream = NULL;
+	u64 objectid;
+	char *path;
+	enum btrfs_util_error err;
 
 	clean_args_no_options(argc, argv, cmd_subvol_set_default_usage);
 
@@ -865,42 +863,17 @@ static int cmd_subvol_set_default(int argc, char **argv)
 
 	if (argc - optind == 1) {
 		/* path to the subvolume is specified */
+		objectid = 0;
 		path = argv[optind];
-
-		ret = test_issubvolume(path);
-		if (ret < 0) {
-			error("stat error: %s", strerror(-ret));
-			return 1;
-		} else if (!ret) {
-			error("'%s' is not a subvolume", path);
-			return 1;
-		}
-
-		fd = btrfs_open_dir(path, &dirstream, 1);
-		if (fd < 0)
-			return 1;
-
-		ret = lookup_path_rootid(fd, &objectid);
-		if (ret) {
-			error("unable to get subvol id: %s", strerror(-ret));
-			close_file_or_dir(fd, dirstream);
-			return 1;
-		}
 	} else {
 		/* subvol id and path to the filesystem are specified */
-		subvolid = argv[optind];
+		objectid = arg_strtou64(argv[optind]);
 		path = argv[optind + 1];
-		objectid = arg_strtou64(subvolid);
-
-		fd = btrfs_open_dir(path, &dirstream, 1);
-		if (fd < 0)
-			return 1;
 	}
 
-	ret = ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
-	close_file_or_dir(fd, dirstream);
-	if (ret < 0) {
-		error("unable to set a new default subvolume: %m");
+	err = btrfs_util_set_default_subvolume(path, objectid);
+	if (err) {
+		error_btrfs_util(err);
 		return 1;
 	}
 	return 0;
-- 
2.16.1

