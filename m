Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28045 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab2L1DHC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Dec 2012 22:07:02 -0500
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qBS370Pd010160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 03:07:01 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qBS370JB013357
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 03:07:00 GMT
Received: from abhmt116.oracle.com (abhmt116.oracle.com [141.146.116.68])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qBS36xo4023121
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Dec 2012 21:06:59 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 8/8] Btrfs-progs: add show command to display detailed information about the subvol
Date: Fri, 28 Dec 2012 11:13:02 +0800
Message-Id: <1356664382-24423-9-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1356664382-24423-1-git-send-email-Anand.Jain@oracle.com>
References: <1356664382-24423-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-subvolume.c |  122 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/btrfs.8.in   |    6 +++
 2 files changed, 128 insertions(+), 0 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ee36463..d5c45db 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -24,6 +24,7 @@
 #include <libgen.h>
 #include <limits.h>
 #include <getopt.h>
+#include <uuid/uuid.h>
 
 #include "kerncompat.h"
 #include "ioctl.h"
@@ -704,6 +705,126 @@ static int cmd_find_new(int argc, char **argv)
 	return 0;
 }
 
+static const char * const cmd_subvol_show_usage[] = {
+	"btrfs subvolume show <subvol-path>",
+	"Show more information of the subvolume",
+	NULL
+};
+
+static int cmd_subvol_show(int argc, char **argv)
+{
+	int ret, fd;
+	char *subvol, *mnt = NULL;
+	struct root_info get_ri;
+	char tstr[256];
+	char uuidparse[37];
+
+	if (check_argc_exact(argc, 2))
+		usage(cmd_subvol_show_usage);
+
+	subvol = realpath(argv[1],0);
+	if(!subvol) {
+		fprintf(stderr, "ERROR: finding real path for '%s', %s\n",
+			argv[1], strerror(errno));
+		return 12;
+	}
+
+	ret = test_issubvolume(subvol);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
+		free(subvol);
+		return 12;
+	}
+	if (!ret) {
+		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
+		free(subvol);
+		return 13;
+	}
+
+	ret = find_mount_root(subvol, &mnt);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: find_mount_root failed on %s: "
+				"%s\n", subvol, strerror(-ret));
+		free(subvol);
+		return 12;
+	}
+	if (!strcmp(subvol, mnt))
+		return 0;
+
+	/* this will point to after the mnt/" */
+	get_ri.full_path = subvol+strlen(mnt)+1;
+
+	if (!strcmp(get_ri.full_path, ""))
+		return 0;
+
+	fd = open_file_or_dir(mnt);
+	if (fd < 0) {
+		fprintf(stderr, "ERROR: can't access '%s'\n", subvol);
+		return 12;
+	}
+
+	if (btrfs_get_subvol(fd, &get_ri)) {
+		fprintf(stderr, "ERROR: can't find '%s'\n",
+			get_ri.full_path);
+		close(fd);
+		return 13;
+	}
+
+	/* print the info */
+	printf("%s/%s", mnt, get_ri.full_path);
+	printf("\n");
+
+	if (uuid_is_null(get_ri.uuid))
+		strcpy(uuidparse, "-");
+	else
+		uuid_unparse(get_ri.uuid, uuidparse);
+	printf("\t");
+	printf("uuid: \t\t\t%s", uuidparse);
+	printf("\n");
+
+	if (get_ri.otime)
+		strftime(tstr, 256, "%Y-%m-%d %X",
+			 localtime(&get_ri.otime));
+	else
+		strcpy(tstr, "-");
+	printf("\t");
+	printf("Creation time: \t\t%s", tstr);
+	printf("\n");
+
+	printf("\t");
+	printf("Object ID: \t\t%llu", get_ri.root_id);
+	printf("\n");
+
+	printf("\t");
+	printf("Generation (Gen): \t%llu", get_ri.gen);
+	printf("\n");
+
+	printf("\t");
+	printf("Gen at creation: \t%llu", get_ri.ogen);
+	printf("\n");
+
+	printf("\t");
+	printf("Parent: \t\t%llu", get_ri.ref_tree);
+	printf("\n");
+
+	printf("\t");
+	printf("Top Level: \t\t%llu", get_ri.top_id);
+	printf("\n");
+
+	/* clean up */
+	if (get_ri.path)
+		free(get_ri.path);
+	if (get_ri.name)
+		free(get_ri.name);
+	if (get_ri.full_path)
+		free(get_ri.full_path);
+
+	close(fd);
+	free(mnt);
+	free(subvol);
+	return 0;
+}
+
 const struct cmd_group subvolume_cmd_group = {
 	subvolume_cmd_group_usage, NULL, {
 		{ "create", cmd_subvol_create, cmd_subvol_create_usage, NULL, 0 },
@@ -715,6 +836,7 @@ const struct cmd_group subvolume_cmd_group = {
 		{ "set-default", cmd_subvol_set_default,
 			cmd_subvol_set_default_usage, NULL, 0 },
 		{ "find-new", cmd_find_new, cmd_find_new_usage, NULL, 0 },
+		{ "show", cmd_subvol_show, cmd_subvol_show_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
 	}
 };
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 9222580..57c25b0 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -17,6 +17,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume get-default\fP\fI <path>\fP
 .PP
+\fBbtrfs\fP \fBsubvolume show\fP\fI <path>\fP
+.PP
 \fBbtrfs\fP \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] \
 [-s \fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> \
 [<\fIfile\fR>|<\fIdir\fR>...]
@@ -160,6 +162,10 @@ Get the default subvolume of the filesystem \fI<path>\fR. The output format
 is similar to \fBsubvolume list\fR command.
 .TP
 
+\fBsubvolume show\fR\fI <path>\fR
+Show information of a given subvolume in the \fI<path>\fR.
+.TP
+
 \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] [-s \fIstart\fR] \
 [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> [<\fIfile\fR>|<\fIdir\fR>...]
 
-- 
1.7.1

