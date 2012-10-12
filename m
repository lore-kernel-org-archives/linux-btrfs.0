Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:19348 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467Ab2JLFRl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Oct 2012 01:17:41 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by acsinet15.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q9C5Hdcr002069
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 05:17:39 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id q9C5Hcop012351
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 05:17:39 GMT
Received: from abhmt109.oracle.com (abhmt109.oracle.com [141.146.116.61])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id q9C5HcTY015338
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2012 00:17:38 -0500
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 4/4] Btrfs-progs: add btrfs subvol show cli
Date: Fri, 12 Oct 2012 13:20:54 +0800
Message-Id: <1350019254-22036-5-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1350019254-22036-1-git-send-email-Anand.Jain@oracle.com>
References: <1350019254-22036-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

This will add a sub command to show information about a subvol.
eg:
btrfs su show /btrfs/sssv3
/btrfs/sssv3
	uuid: 		c5d646b5-a749-c646-b082-6d9a3ca870be
	Parent uuid: 	34bc8edd-113f-5141-a814-f6dfae069b01
	Creation time: 	2012-10-12 11:37:00

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-subvolume.c |  113 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/btrfs.8.in   |    6 +++
 2 files changed, 119 insertions(+), 0 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index 92b69d1..13defa9 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -24,6 +24,7 @@
 #include <libgen.h>
 #include <limits.h>
 #include <getopt.h>
+#include <uuid/uuid.h>
 
 #include "kerncompat.h"
 #include "ioctl.h"
@@ -703,6 +704,117 @@ static int cmd_find_new(int argc, char **argv)
 	return 0;
 }
 
+static const char * const cmd_subvol_show_usage[] = {
+	"btrfs subvolume show <subvol-path>",
+	"Show information about the given subvolume",
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
+	subvol = argv[1];
+
+	ret = test_issubvolume(subvol);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: error accessing '%s'\n", subvol);
+		return 12;
+	}
+	if (!ret) {
+		fprintf(stderr, "ERROR: '%s' is not a subvolume\n", subvol);
+		return 13;
+	}
+
+	ret = find_mount_root(subvol, &mnt);
+	if (ret < 0) {
+		fprintf(stderr, "ERROR: find_mount_root failed on %s: "
+				"%s\n", subvol, strerror(-ret));
+		return 12;
+	}
+	if (!strcmp(subvol, mnt))
+		return 0;
+
+	/* +1 will point after the "/" */
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
+	if (btrfs_get_a_subvol(fd, &get_ri)) {
+		fprintf(stderr, "ERROR: can't find '%s'\n",
+			get_ri.full_path);
+		close(fd);
+		return 13;
+	}
+
+	/* print the info */
+	printf("%s/%s", mnt, get_ri.full_path);
+	printf("\n");
+	if (uuid_is_null(get_ri.uuid))
+		strcpy(uuidparse, "-");
+	else
+		uuid_unparse(get_ri.uuid, uuidparse);
+	printf("\t");
+	printf("uuid: \t\t%s", uuidparse);
+	printf("\n");
+	if (uuid_is_null(get_ri.puuid))
+		strcpy(uuidparse, "-");
+	else
+		uuid_unparse(get_ri.puuid, uuidparse);
+	printf("\t");
+	printf("Parent uuid: \t%s", uuidparse);
+	printf("\n");
+	if (get_ri.otime)
+		strftime(tstr, 256, "%Y-%m-%d %X",
+			 localtime(&get_ri.otime));
+	else
+		strcpy(tstr, "-");
+	printf("\t");
+	printf("Creation time: \t%s", tstr);
+	printf("\n");
+
+/*	if in case we decide to have more available data
+	to be shown we can use it as below.
+
+	printf("Object ID: %llu", get_ri.root_id);
+	printf("\n");
+	printf("Generation: %llu", get_ri.gen);
+	printf("\n");
+	printf("OGeneration: %llu", get_ri.ogen);
+	printf("\n");
+	printf("Parent: %llu", get_ri.ref_tree);
+	printf("\n");
+	printf("Top Level: %llu", get_ri.top_id);
+	printf("\n");
+*/
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
+	return 0;
+}
+
 const struct cmd_group subvolume_cmd_group = {
 	subvolume_cmd_group_usage, NULL, {
 		{ "create", cmd_subvol_create, cmd_subvol_create_usage, NULL, 0 },
@@ -714,6 +826,7 @@ const struct cmd_group subvolume_cmd_group = {
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

