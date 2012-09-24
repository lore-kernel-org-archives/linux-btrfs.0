Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:14688 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab2IXGnx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 02:43:53 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q8O6hpXG028099
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Sep 2012 14:43:51 +0800
From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Subject: [PATCH] Btrfs-progs: introduce '-p' option and <fullpath> into subvolume set-default command
Date: Mon, 24 Sep 2012 14:42:13 +0800
Message-Id: <1348468933-14839-1-git-send-email-chenyang.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In command "btrfs subvolume set-default", we used subvolume <id> and <path>
to set the default subvolume of a filesystem. It's not easy for a common
user, so I improved it and the <fullpath> of a subvolume can be used to
set the default subvolume of a filesystem.

Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
---
 cmds-subvolume.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++--------
 man/btrfs.8.in   |    6 ++--
 2 files changed, 79 insertions(+), 16 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 8399e72..827234c 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -26,6 +26,7 @@
 #include <getopt.h>
 
 #include "kerncompat.h"
+#include "ctree.h"
 #include "ioctl.h"
 #include "qgroup.h"
 
@@ -601,23 +602,66 @@ static int cmd_subvol_get_default(int argc, char **argv)
 }
 
 static const char * const cmd_subvol_set_default_usage[] = {
-	"btrfs subvolume set-default <subvolid> <path>",
+	"btrfs subvolume set-default [-p] [<subvolid>] <path>",
 	"Set the default subvolume of a filesystem",
+	"-p    Set the parent tree(subvolume) of the PATH",
+	"      as the default subvolume, if PATH is not a subvolume",
 	NULL
 };
 
 static int cmd_subvol_set_default(int argc, char **argv)
 {
-	int	ret=0, fd, e;
-	u64	objectid;
+	int	ret = 0, fd = -1, e;
+	int	parent = 0;
+	u64	objectid = -1;
 	char	*path;
-	char	*subvolid;
+	char	*subvolid, *inv;
 
-	if (check_argc_exact(argc, 3))
+	optind = 1;
+	while (1) {
+		int c = getopt(argc, argv, "p");
+		if (c < 0)
+			break;
+
+		switch (c) {
+		case 'p':
+			parent = 1;
+			break;
+		default:
+			usage(cmd_subvol_set_default_usage);
+		}
+	}
+
+	if (check_argc_min(argc - optind, 1) ||
+		check_argc_max(argc - optind, 2))
 		usage(cmd_subvol_set_default_usage);
 
-	subvolid = argv[1];
-	path = argv[2];
+	if (argc - optind == 2) {
+		subvolid = argv[optind];
+		path = argv[optind + 1];
+
+		objectid = (unsigned long long)strtoll(subvolid, &inv, 0);
+		if (errno == ERANGE || subvolid == inv) {
+			fprintf(stderr,
+				"ERROR: invalid tree id (%s)\n", subvolid);
+			return 30;
+		}
+	} else {
+		path = argv[optind];
+
+		ret = test_issubvolume(path);
+		if (ret < 0) {
+			fprintf(stderr,
+				"ERROR: error accessing '%s'\n", path);
+			return 12;
+		}
+		if (!ret && !parent) {
+			fprintf(stderr,
+				"ERROR: '%s' is not a subvolume\n",
+				path);
+			return 13;
+		}
+	}
 
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
@@ -625,16 +669,35 @@ static int cmd_subvol_set_default(int argc, char **argv)
 		return 12;
 	}
 
-	objectid = (unsigned long long)strtoll(subvolid, NULL, 0);
-	if (errno == ERANGE) {
-		fprintf(stderr, "ERROR: invalid tree id (%s)\n",subvolid);
-		return 30;
+	/*
+	  When objectid is -1, it means that
+	  subvolume id is not specified by user.
+	  We will set default subvolume by <path>.
+	*/
+	if (objectid == -1) {
+		struct btrfs_ioctl_ino_lookup_args args;
+
+		memset(&args, 0, sizeof(args));
+		args.treeid = 0;
+		args.objectid = BTRFS_FIRST_FREE_OBJECTID;
+
+		ret = ioctl(fd, BTRFS_IOC_INO_LOOKUP, &args);
+		if (ret) {
+			fprintf(stderr,
+				"ERROR: can't perform the search - %s\n",
+				strerror(errno));
+			return ret;
+		}
+
+		objectid = args.treeid;
 	}
+
 	ret = ioctl(fd, BTRFS_IOC_DEFAULT_SUBVOL, &objectid);
 	e = errno;
 	close(fd);
-	if( ret < 0 ){
-		fprintf(stderr, "ERROR: unable to set a new default subvolume - %s\n",
+	if (ret < 0) {
+		fprintf(stderr,
+			"ERROR: unable to set a new default subvolume - %s\n",
 			strerror(e));
 		return 30;
 	}
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 3f7765d..2bc1d97 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -13,7 +13,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume list\fP\fI [-pr] [-s 0|1] [-g [+|-]value] [-c [+|-]value] [--rootid=rootid,gen,ogen,path] <path>\fP
 .PP
-\fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
+\fBbtrfs\fP \fBsubvolume set-default\fP\fI [-p] [<id>] <path>\fP
 .PP
 \fBbtrfs\fP \fBsubvolume get-default\fP\fI <path>\fP
 .PP
@@ -147,9 +147,9 @@ for \fB--sort\fP you can combine some items together by ',', just like
 .RE
 .TP
 
-\fBsubvolume set-default\fR\fI <id> <path>\fR
+\fBsubvolume set-default\fR\fI [-p] [<id>] <path>\fR
 Set the subvolume of the filesystem \fI<path>\fR which is mounted as 
-\fIdefault\fR. The subvolume is identified by \fI<id>\fR, which 
+\fIdefault\fR. The subvolume is identified by \fI<path>\fR or by \fI<id>\fR, which
 is returned by the \fBsubvolume list\fR command.
 .TP
 
-- 
1.7.7.6

