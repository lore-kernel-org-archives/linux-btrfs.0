Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38982 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3GOF0J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 01:26:09 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH 02/11] btrfs-progs: label option in btrfs filesystem show is not coded
Date: Mon, 15 Jul 2013 13:30:48 +0800
Message-Id: <1373866257-10519-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1373866257-10519-1-git-send-email-anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 cmds-filesystem.c |    2 +-
 man/btrfs.8.in    |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 222e458..a1a8830 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -223,7 +223,7 @@ static void print_one_uuid(struct btrfs_fs_devices *fs_devices)
 }
 
 static const char * const cmd_show_usage[] = {
-	"btrfs filesystem show [--all-devices] [<uuid>|<label>]",
+	"btrfs filesystem show [--all-devices|<uuid>]",
 	"Show the structure of a filesystem",
 	"If no argument is given, structure of all present filesystems is shown.",
 	NULL
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 7df2ead..bc94579 100644
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
@@ -273,9 +273,9 @@ following constraints exist for a label:
 .IP
 - the maximum allowable length shall be less than 256 chars
 
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
1.7.7.6

