Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:19870 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751363AbdJFBFS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Oct 2017 21:05:18 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id E4F5DAC041D
        for <linux-btrfs@vger.kernel.org>; Fri,  6 Oct 2017 10:05:13 +0900 (JST)
Received: from G01JPEXCHKW13.g01.fujitsu.local (G01JPEXCHKW13.g01.fujitsu.local [10.0.194.52])
        by g01jpfmpwkw01.exch.g01.fujitsu.local (Postfix) with ESMTP id 3BB1F692503
        for <linux-btrfs@vger.kernel.org>; Fri,  6 Oct 2017 10:05:13 +0900 (JST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Subject: [PATCH v3] btrfs-progs: change subvol set-default to also accept
 subvol path
Message-ID: <ff364376-54d3-d0e2-fbae-eb45a92029ed@jp.fujitsu.com>
Date: Fri, 6 Oct 2017 10:05:08 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch changes "subvol set-default" to also accept the subvolume path
for convenience.

This is the one of the issue on github: 
https://github.com/kdave/btrfs-progs/issues/35

If there are two args, they are assumed as subvol id and path to the fs
(the same as current behavior), and if there is only one arg, it is assumed
as the path to the subvolume.

subvol id is resolved by test_issubvolume() + lookup_path_rootid().
Empty subvol (ino==2) will get error on test_issubvolume() which checks
whether inode num is 256 or not.

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
changelog
 v1 -> v2 : revert
 v1 -> v3 : use test_issubvolume() + lookup_path_rootid() instead of
            get_subvol_info() for getting subvol id of path.

 Documentation/btrfs-subvolume.asciidoc | 10 ++++----
 cmds-subvolume.c                       | 46 +++++++++++++++++++++++++++-------
 2 files changed, 42 insertions(+), 14 deletions(-)

diff --git a/Documentation/btrfs-subvolume.asciidoc b/Documentation/btrfs-subvolume.asciidoc
index 5cfe885..df27460 100644
--- a/Documentation/btrfs-subvolume.asciidoc
+++ b/Documentation/btrfs-subvolume.asciidoc
@@ -142,12 +142,12 @@ you can add \'\+' or \'-' in front of each items, \'+' means ascending,
 for --sort you can combine some items together by \',', just like
 --sort=+ogen,-gen,path,rootid.
 
-*set-default* <id> <path>::
-Set the subvolume of the filesystem <path> which is mounted as
-default.
+*set-default* [<subvolume>|<id> <path>]::
+Set the subvolume of the filesystem which is mounted as default.
 +
-The subvolume is identified by <id>, which is returned by the *subvolume list*
-command.
+If <id> and <path> is given, the subvolume is identified by <id>,
+which is returned by the *subvolume list* command. The filesystem
+is specified by <path>.
 
 *show* <path>::
 Show information of a given subvolume in the <path>.
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 666f6e0..2e3860a 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -803,8 +803,10 @@ out:
 }
 
 static const char * const cmd_subvol_set_default_usage[] = {
-	"btrfs subvolume set-default <subvolid> <path>",
-	"Set the default subvolume of a filesystem",
+	"btrfs subvolume set-default [<subvolume>|<subvolid> <path>]",
+	"Set the default subvolume of the filesystem mounted as default.",
+	"The subvolume can be specified by its path,",
+	"or the pair of subvolume id and path to the filesystem.",
 	NULL
 };
 
@@ -818,17 +820,43 @@ static int cmd_subvol_set_default(int argc, char **argv)
 
 	clean_args_no_options(argc, argv, cmd_subvol_set_default_usage);
 
-	if (check_argc_exact(argc - optind, 2))
+	if (check_argc_min(argc - optind, 1) ||
+			check_argc_max(argc - optind, 2))
 		usage(cmd_subvol_set_default_usage);
 
-	subvolid = argv[optind];
-	path = argv[optind + 1];
+	if (argc - optind == 1) {
+		/* path to the subvolume is specified */
+		path = argv[optind];
 
-	objectid = arg_strtou64(subvolid);
+		ret = test_issubvolume(path);
+		if (ret < 0) {
+			error("stat error: %s", strerror(-ret));
+			return 1;
+		} else if (!ret) {
+			error("'%s' is not a subvolume", path);
+			return 1;
+		}
 
-	fd = btrfs_open_dir(path, &dirstream, 1);
-	if (fd < 0)
-		return 1;
+		fd = btrfs_open_dir(path, &dirstream, 1);
+		if (fd < 0)
+			return 1;
+
+		ret = lookup_path_rootid(fd, &objectid);
+		if (ret) {
+			error("unable to get subvol id: %s", strerror(-ret));
+			close_file_or_dir(fd, dirstream);
+			return 1;
+		}
+	} else {
+		/* subvol id and path to the filesystem are specified */
+		subvolid = argv[optind];
+		path = argv[optind + 1];
+		objectid = arg_strtou64(subvolid);
+
+		fd = btrfs_open_dir(path, &dirstream, 1);
+		if (fd < 0)
+			return 1;
+	}
 
 	ret = ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
 	e = errno;
-- 
2.9.5

