Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24427 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab3BYFbi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 00:31:38 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r1P5VaRW029581
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 05:31:37 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r1P5VaMG013449
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 05:31:36 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r1P5Vaug014965
	for <linux-btrfs@vger.kernel.org>; Sun, 24 Feb 2013 23:31:36 -0600
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2 v4] Btrfs-progs: cmd option to show or set the subvol label
Date: Mon, 25 Feb 2013 13:31:29 +0800
Message-Id: <1361770289-1165-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1361770289-1165-1-git-send-email-anand.jain@oracle.com>
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
 <1361770289-1165-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds the command option label to the subvol sub-command,
this is a generic patch which will stay irrespective of which
approach we take, that is the ioctl-way or the attributes.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-subvolume.c | 37 +++++++++++++++++++++++++++++++++++++
 man/btrfs.8.in   |  6 ++++++
 2 files changed, 43 insertions(+)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index ea128fc..1951c51 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -35,12 +35,48 @@
 #include "utils.h"
 #include "btrfs-list.h"
 #include "utils.h"
+#include "btrfslabel.h"
 
 static const char * const subvolume_cmd_group_usage[] = {
 	"btrfs subvolume <command> <args>",
 	NULL
 };
 
+static const char * const cmd_subvol_label_usage[] = {
+	"btrfs subvolume label <path> [label]",
+	"Show or set label for the subvol or snapshot",
+	NULL
+};
+
+static int cmd_subvol_label(int argc, char **argv)
+{
+	struct stat st;
+	char label[BTRFS_SUBVOL_LABEL_SIZE+1];
+	int ret;
+
+	if (check_argc_min(argc, 2) || check_argc_max(argc, 3))
+		usage(cmd_subvol_label_usage);
+
+	if (stat(argv[1], &st) < 0) {
+		fprintf(stderr, "Error: %s\n",strerror(errno));
+		return -errno;
+	}
+	if (!S_ISDIR(st.st_mode)) {
+		fprintf(stderr, "Error: Not a dir\n");
+		return -1;
+	}
+	if (argc > 2)
+		return set_subvol_label(argv[1], argv[2]);
+	else {
+		ret = get_subvol_label(argv[1], label);
+		if (ret)
+			return ret;
+		label[BTRFS_SUBVOL_LABEL_SIZE]=0;
+		printf("%s\n",label);
+	}
+	return 0;
+}
+
 /*
  * test if path is a directory
  * this function return
@@ -933,6 +969,7 @@ const struct cmd_group subvolume_cmd_group = {
 			cmd_subvol_set_default_usage, NULL, 0 },
 		{ "find-new", cmd_find_new, cmd_find_new_usage, NULL, 0 },
 		{ "show", cmd_subvol_show, cmd_subvol_show_usage, NULL, 0 },
+		{ "label", cmd_subvol_label, cmd_subvol_label_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
 	}
 };
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 94f4ffe..cd2e4e5 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -17,6 +17,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume get-default\fP\fI <path>\fP
 .PP
+\fBbtrfs\fP \fBsubvolume label\fP\fI <path> [label]\fP
+.PP
 \fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
 .PP
 \fBbtrfs\fP \fBsubvolume show\fP\fI <path>\fP
@@ -177,6 +179,10 @@ Get the default subvolume of the filesystem \fI<path>\fR. The output format
 is similar to \fBsubvolume list\fR command.
 .TP
 
+\fBsubvolume label\fR\fI <path> [label]\fR
+Show or set \fI[label]\fR for the subvolume or the snapshot \fI<path>\fR.
+.TP
+
 \fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
 List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
 .TP
-- 
1.8.1.227.g44fe835

