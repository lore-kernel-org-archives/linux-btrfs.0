Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27157 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab3EQKvy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 06:51:54 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4HAppsh023556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:51:52 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4HApqNN018621
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:51:52 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4HAppUl009312
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:51:51 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/4] btrfs-progs: replace filesystem show --all-devices with -d option
Date: Fri, 17 May 2013 18:54:39 +0800
Message-Id: <1368788082-12090-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
References: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs fi show --all-devices is odd man out as compared to the
rest of the command line options with in btrfs-progs. So match it
with the btrfs-progs symantics

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 18 ++++++++++++++----
 man/btrfs.8.in    |  6 +++---
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f41a72a..6ba27ad 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -232,7 +232,7 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 }
 
 static const char * const cmd_show_usage[] = {
-	"btrfs filesystem show [--all-devices] [<uuid>|<label>]",
+	"btrfs filesystem show [-d] [<uuid>|<label>]",
 	"Show the structure of a filesystem",
 	"If no argument is given, structure of all present filesystems is shown.",
 	NULL
@@ -248,9 +248,19 @@ static int cmd_show(int argc, char **argv)
 	int checklist = 1;
 	int searchstart = 1;
 
-	if( argc > 1 && !strcmp(argv[1],"--all-devices")){
-		checklist = 0;
-		searchstart += 1;
+	optind = 1;
+	while(1) {
+		int c = getopt(argc, argv, "d");
+		if (c < 0)
+			break;
+		switch(c) {
+		case 'd':
+			checklist = 0;
+			searchstart += 1;
+			break;
+		default:
+			usage(cmd_show_usage);
+		}
 	}
 
 	if (check_argc_max(argc, searchstart + 1))
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 9b1f294..3d05862 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -31,7 +31,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
-\fBbtrfs\fP \fBfilesystem show\fP\fI [--all-devices|<uuid>|<label>]\fP
+\fBbtrfs\fP \fBfilesystem show\fP\fI [-d] [<uuid>|<label>]\fP
 .PP
 \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
 .PP
@@ -282,10 +282,10 @@ NOTE: Currently there are the following limitations:
 - the filesystem should not have more than one device.
 .TP
 
-\fBfilesystem show\fR [--all-devices|<uuid>|<label>]\fR
+\fBfilesystem show\fR [-d] [<uuid>|<label>]\fR
 Show the btrfs filesystem with some additional info. If no \fIUUID\fP or 
 \fIlabel\fP is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
-If \fB--all-devices\fP is passed, all the devices under /dev are scanned;
+If \fB-d\fP is passed, all the devices under /dev are scanned;
 otherwise the devices list is extracted from the /proc/partitions file.
 .TP
 
-- 
1.8.1.227.g44fe835

