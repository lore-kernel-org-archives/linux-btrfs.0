Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48821 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363Ab2K0SYX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Nov 2012 13:24:23 -0500
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id qARIOLDU024890
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2012 18:24:22 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id qARIOLQN028578
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2012 18:24:21 GMT
Received: from abhmt119.oracle.com (abhmt119.oracle.com [141.146.116.71])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id qARIOLrS031355
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2012 12:24:21 -0600
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] Btrfs-progs: cmd option to show or set the subvol label
Date: Wed, 28 Nov 2012 02:29:20 +0800
Message-Id: <1354040960-31522-5-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1354040960-31522-1-git-send-email-Anand.Jain@oracle.com>
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com>
 <1354040960-31522-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-subvolume.c |   37 +++++++++++++++++++++++++++++++++++++
 man/btrfs.8.in   |    6 ++++++
 2 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/cmds-subvolume.c b/cmds-subvolume.c
index e3cdb1e..759eade 100644
--- a/cmds-subvolume.c
+++ b/cmds-subvolume.c
@@ -33,6 +33,7 @@
 #include "commands.h"
 #include "btrfs-list.h"
 #include "utils.h"
+#include "btrfslabel.h"
 
 static const char * const subvolume_cmd_group_usage[] = {
 	"btrfs subvolume <command> <args>",
@@ -700,6 +701,41 @@ static int cmd_find_new(int argc, char **argv)
 	return 0;
 }
 
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
 const struct cmd_group subvolume_cmd_group = {
 	subvolume_cmd_group_usage, NULL, {
 		{ "create", cmd_subvol_create, cmd_subvol_create_usage, NULL, 0 },
@@ -711,6 +747,7 @@ const struct cmd_group subvolume_cmd_group = {
 		{ "set-default", cmd_subvol_set_default,
 			cmd_subvol_set_default_usage, NULL, 0 },
 		{ "find-new", cmd_find_new, cmd_find_new_usage, NULL, 0 },
+		{ "label", cmd_subvol_label, cmd_subvol_label_usage, NULL, 0 },
 		{ 0, 0, 0, 0, 0 }
 	}
 };
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 9222580..aa225d9 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -17,6 +17,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume get-default\fP\fI <path>\fP
 .PP
+\fBbtrfs\fP \fBsubvolume label\fP\fI <path> [label]\fP
+.PP
 \fBbtrfs\fP \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] \
 [-s \fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> \
 [<\fIfile\fR>|<\fIdir\fR>...]
@@ -160,6 +162,10 @@ Get the default subvolume of the filesystem \fI<path>\fR. The output format
 is similar to \fBsubvolume list\fR command.
 .TP
 
+\fBsubvolume label\fR\fI <path> [label]\fR
+Show or set \fI[label]\fR for the subvolume or the snapshot \fI<path>\fR.
+.TP
+
 \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] [-s \fIstart\fR] \
 [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> [<\fIfile\fR>|<\fIdir\fR>...]
 
-- 
1.7.1

