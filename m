Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50404 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab3FJOwv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 10:52:51 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r5AEqmcc027929
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:52:48 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5AEqn1W015042
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:52:50 GMT
Received: from abhmt112.oracle.com (abhmt112.oracle.com [141.146.116.64])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r5AEqnkO015704
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 14:52:49 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/9 v2] btrfs-progs: label option in btrfs filesystem show is not coded
Date: Mon, 10 Jun 2013 22:56:23 +0800
Message-Id: <1370876190-16520-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
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

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
