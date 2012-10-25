Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1304 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S964801Ab2JYItk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 04:49:40 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q9P8nc5g026607
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 16:49:38 +0800
From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] Btrfs-progs: Introduce another form of btrfs subvolume set-default command
Date: Thu, 25 Oct 2012 16:49:22 +0800
Message-Id: <1351154962-7273-1-git-send-email-chenyang.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch introduces another form of btrfs subvolume set-default command.
In command "btrfs subvolume set-default", we used subvolume <id> and <path>
to set the default subvolume of a filesystem.
By the new form, we can use subvolume path to set the default subvolume.

The new form:
	subvolume set-default [-p] [-f] <path>

For example:
	If <path> is a subvolume, no option needed.
		#btrfs subvolume set-default /mnt/subvol

	If <path> is not a subvolume, -p option makes btrfs enter interactive mode
		# btrfs subvolume set-default -p /mnt/subvol/dir
		'/mnt/subvol/dir' is not a subvolume, use parent tree instead? (y or n)y

	If interactive is not expected, -f option makes btrfs skip it and 'yes' will be choose
		# btrfs subvolume set-default -p -f /mnt/subvol/dir

Signed-off-by: Cheng Yang <chenyang.fnst@cn.fujitsu.com>
---
 Makefile         |    2 +-
 cmds-subvolume.c |  107 +++++++++++++++++++++++++++++++++++++++++++++++-------
 man/btrfs.8.in   |   17 +++++++++
 yesno.c          |   56 ++++++++++++++++++++++++++++
 yesno.h          |   24 ++++++++++++
 5 files changed, 191 insertions(+), 15 deletions(-)
 create mode 100644 yesno.c
 create mode 100644 yesno.h

diff --git a/Makefile b/Makefile
index 4894903..433dc32 100644
--- a/Makefile
+++ b/Makefile
@@ -4,7 +4,7 @@ CFLAGS = -g -O1
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o \
 	  inode-map.o crc32c.o rbtree.o extent-cache.o extent_io.o \
-	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o \
+	  volumes.o utils.o btrfs-list.o btrfslabel.o repair.o yesno.o\
 	  send-stream.o send-utils.o qgroup.o
 cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
 	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ac39f7b..e35fdd4 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -32,6 +32,7 @@
 #include "ctree.h"
 #include "commands.h"
 #include "btrfs-list.h"
+#include "yesno.h"
 
 static const char * const subvolume_cmd_group_usage[] = {
 	"btrfs subvolume <command> <args>",
@@ -620,22 +621,81 @@ static int cmd_subvol_get_default(int argc, char **argv)
 
 static const char * const cmd_subvol_set_default_usage[] = {
 	"btrfs subvolume set-default <subvolid> <path>",
+	"btrfs subvolume set-default [-p] [-f] <path>",
 	"Set the default subvolume of a filesystem",
+	"-p	If <path> is not a subvolume, it will enter",
+	"	interactive mode, then you can choose to set",
+	"	the parent tree of the <path> as default or not.",
+	"-f	This option must be used with -p. The interactive",
+	"	mode will be skipped and 'yes' will be set.",
 	NULL
 };
 
 static int cmd_subvol_set_default(int argc, char **argv)
 {
-	int	ret=0, fd, e;
-	u64	objectid;
+	int	ret = 0, fd = -1, e;
+	int	parent = 0, force = 0;
+	u64	objectid = -1;
 	char	*path;
-	char	*subvolid;
+	char	*subvolid, *inv;
 
-	if (check_argc_exact(argc, 3))
-		usage(cmd_subvol_set_default_usage);
+	optind = 1;
+	while (1) {
+		int c = getopt(argc, argv, "pf");
+		if (c < 0)
+			break;
+
+		switch (c) {
+		case 'p':
+			parent = 1;
+			break;
+		case 'f':
+			force = 1;
+			break;
+		default:
+			usage_lines(cmd_subvol_set_default_usage, 1);
+		}
+	}
+
+	if (check_argc_min(argc - optind, 1) ||
+		check_argc_max(argc - optind, 3))
+		usage_lines(cmd_subvol_set_default_usage, 1);
+
+	if (force && !parent)
+		usage_lines(cmd_subvol_set_default_usage, 1);
 
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
+		if (!ret) {
+			fprintf(stderr,
+				"'%s' is not a subvolume, use parent tree instead",
+				path);
+			if (force)
+				fprintf(stderr, "!\n");
+			else {
+				fprintf(stderr, "? (y or n)");
+				if (!yesno())
+					return 13;
+			}
+		}
+	}
 
 	fd = open_file_or_dir(path);
 	if (fd < 0) {
@@ -643,16 +703,35 @@ static int cmd_subvol_set_default(int argc, char **argv)
 		return 12;
 	}
 
-	objectid = (unsigned long long)strtoll(subvolid, NULL, 0);
-	if (errno == ERANGE) {
-		fprintf(stderr, "ERROR: invalid tree id (%s)\n",subvolid);
-		return 30;
+	/*
+	  * When objectid is -1, it means that
+	  * subvolume id is not specified by user.
+	  * We will set default subvolume by <path>.
+	  */
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
@@ -708,7 +787,7 @@ const struct cmd_group subvolume_cmd_group = {
 		{ "get-default", cmd_subvol_get_default,
 			cmd_subvol_get_default_usage, NULL, 0 },
 		{ "set-default", cmd_subvol_set_default,
-			cmd_subvol_set_default_usage, NULL, 0 },
+			cmd_subvol_set_default_usage, NULL, 0 , 1 },
 		{ "find-new", cmd_find_new, cmd_find_new_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
 	}
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 9222580..0a52688 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -15,6 +15,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
 .PP
+\fBbtrfs\fP \fBsubvolume set-default\fP\fI [-p] [-f] <subvolume>\fP
+.PP
 \fBbtrfs\fP \fBsubvolume get-default\fP\fI <path>\fP
 .PP
 \fBbtrfs\fP \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] \
@@ -155,6 +157,21 @@ Set the subvolume of the filesystem \fI<path>\fR which is mounted as
 is returned by the \fBsubvolume list\fR command.
 .TP
 
+\fBsubvolume set-default\fR\fI [-p] [-f] <path>\fR
+Set the subvolume of the filesystem as default. The subvolume is identified
+by \fI<path>\fR. By default(no option is given), it should be a path to
+subvolume, or btrfs returns an error.
+
+\fB-p\fR If \fB-p\fR is given, and \fI<path>\fR is a subvolume, btrfs is the
+same as default. And if <path> is not a subvolume, btrfs enters
+interactive mode, then you can choose to set the parent tree of \fI<path>\fR
+as default or not.
+
+\fB-f\fR \fB-f\fR must be used with \fB-p\fR, and the interactive mode
+will be skipped and 'yes' will be chosen. Given \fB-f\fR option without
+\fB-p\fR, btrfs returns an error.
+.TP
+
 \fBsubvolume get-default\fR\fI <path>\fR
 Get the default subvolume of the filesystem \fI<path>\fR. The output format
 is similar to \fBsubvolume list\fR command.
diff --git a/yesno.c b/yesno.c
new file mode 100644
index 0000000..ef0c0db
--- /dev/null
+++ b/yesno.c
@@ -0,0 +1,56 @@
+/* yesno.c -- read a yes/no response from stdin
+
+   Copyright (C) 1990, 1998, 2001, 2003-2012 Free Software Foundation, Inc.
+
+   This program is free software: you can redistribute it and/or modify
+   it under the terms of the GNU General Public License as published by
+   the Free Software Foundation; either version 3 of the License, or
+   (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */
+
+#include "yesno.h"
+
+#include <stdlib.h>
+#include <stdio.h>
+
+/* Return true if we read an affirmative line from standard input.
+
+   Since this function uses stdin, it is suggested that the caller not
+   use STDIN_FILENO directly, and also that the line
+   atexit(close_stdin) be added to main().  */
+
+bool yesno(void)
+{
+	bool yes;
+
+#if ENABLE_NLS
+	char *response = NULL;
+	size_t response_size = 0;
+	ssize_t response_len = getline(&response, &response_size, stdin);
+
+	if (response_len <= 0)
+		yes = false;
+	else{
+			response[response_len - 1] = '\0';
+			yes = (0 < rpmatch(response));
+	}
+
+	free(response);
+#else
+	/* Test against "^[yY]", hardcoded to avoid requiring getline,
+		 regex, and rpmatch.	*/
+	int c = getchar();
+	yes = (c == 'y' || c == 'Y');
+	while (c != '\n' && c != EOF)
+		c = getchar();
+#endif
+
+	return yes;
+}
diff --git a/yesno.h b/yesno.h
new file mode 100644
index 0000000..6f5c43f
--- /dev/null
+++ b/yesno.h
@@ -0,0 +1,24 @@
+/* declare yesno
+   Copyright (C) 2004, 2009-2012 Free Software Foundation, Inc.
+
+   This program is free software: you can redistribute it and/or modify
+   it under the terms of the GNU General Public License as published by
+   the Free Software Foundation; either version 3 of the License, or
+   (at your option) any later version.
+
+   This program is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+   GNU General Public License for more details.
+
+   You should have received a copy of the GNU General Public License
+   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */
+
+#ifndef YESNO_H_
+# define YESNO_H_
+
+# include <stdbool.h>
+
+bool yesno(void);
+
+#endif
-- 
1.7.7.6

