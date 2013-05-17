Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27168 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab3EQKvz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 May 2013 06:51:55 -0400
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4HApqZp023563
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:51:53 GMT
Received: from userz7022.oracle.com (userz7022.oracle.com [156.151.31.86])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4HApraA005172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:51:54 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by userz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4HAprm0009330
	for <linux-btrfs@vger.kernel.org>; Fri, 17 May 2013 10:51:53 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/4] btrfs-progs: label option in btrfs filesystem show is not coded
Date: Fri, 17 May 2013 18:54:40 +0800
Message-Id: <1368788082-12090-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
References: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So update the usage and man page

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 2 +-
 man/btrfs.8.in    | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 6ba27ad..470de31 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -232,7 +232,7 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 }
 
 static const char * const cmd_show_usage[] = {
-	"btrfs filesystem show [-d] [<uuid>|<label>]",
+	"btrfs filesystem show [-d] [<uuid>]",
 	"Show the structure of a filesystem",
 	"If no argument is given, structure of all present filesystems is shown.",
 	NULL
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 3d05862..8105019 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -31,7 +31,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
-\fBbtrfs\fP \fBfilesystem show\fP\fI [-d] [<uuid>|<label>]\fP
+\fBbtrfs\fP \fBfilesystem show\fP\fI [-d] [<uuid>]\fP
 .PP
 \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
 .PP
@@ -282,9 +282,9 @@ NOTE: Currently there are the following limitations:
 - the filesystem should not have more than one device.
 .TP
 
-\fBfilesystem show\fR [-d] [<uuid>|<label>]\fR
-Show the btrfs filesystem with some additional info. If no \fIUUID\fP or 
-\fIlabel\fP is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
+\fBfilesystem show\fR [-d] [<uuid>]\fR
+Show the btrfs filesystem with some additional info. If no \fIUUID\fP
+is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
 If \fB-d\fP is passed, all the devices under /dev are scanned;
 otherwise the devices list is extracted from the /proc/partitions file.
 .TP
-- 
1.8.1.227.g44fe835

