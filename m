Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29176 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967432Ab3E3DhL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 May 2013 23:37:11 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r4U3b7KR029326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:07 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4U3b8e0006724
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:09 GMT
Received: from abhmt118.oracle.com (abhmt118.oracle.com [141.146.116.70])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r4U3b8Ko021459
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 03:37:08 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6 v2] btrfs-progs: label option in btrfs filesystem show is not coded
Date: Thu, 30 May 2013 11:40:22 +0800
Message-Id: <1369885226-3640-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1369885226-3640-1-git-send-email-anand.jain@oracle.com>
References: <1368788082-12090-1-git-send-email-anand.jain@oracle.com>
 <1369885226-3640-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

appears to be a cut and paste error

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c | 2 +-
 man/btrfs.8.in    | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index f41a72a..c6a7100 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -232,7 +232,7 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 }
 
 static const char * const cmd_show_usage[] = {
-	"btrfs filesystem show [--all-devices] [<uuid>|<label>]",
+	"btrfs filesystem show [--all-devices|<uuid>]",
 	"Show the structure of a filesystem",
 	"If no argument is given, structure of all present filesystems is shown.",
 	NULL
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 9b1f294..ae984f8 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -31,7 +31,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
-\fBbtrfs\fP \fBfilesystem show\fP\fI [--all-devices|<uuid>|<label>]\fP
+\fBbtrfs\fP \fBfilesystem show\fP\fI [--all-devices|<uuid>]\fP
 .PP
 \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
 .PP
@@ -282,9 +282,9 @@ NOTE: Currently there are the following limitations:
 - the filesystem should not have more than one device.
 .TP
 
-\fBfilesystem show\fR [--all-devices|<uuid>|<label>]\fR
-Show the btrfs filesystem with some additional info. If no \fIUUID\fP or 
-\fIlabel\fP is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
+\fBfilesystem show\fR [--all-devices|<uuid>]\fR
+Show the btrfs filesystem with some additional info. If no \fIUUID\fP
+is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
 If \fB--all-devices\fP is passed, all the devices under /dev are scanned;
 otherwise the devices list is extracted from the /proc/partitions file.
 .TP
-- 
1.8.1.227.g44fe835

