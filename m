Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33381 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2EZR6M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 May 2012 13:58:12 -0400
Received: by obbtb18 with SMTP id tb18so2918292obb.19
        for <linux-btrfs@vger.kernel.org>; Sat, 26 May 2012 10:58:12 -0700 (PDT)
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-btrfs@vger.kernel.org, Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH] btrfs-progs: Update resize documentation
Date: Sat, 26 May 2012 12:57:55 -0500
Message-Id: <1338055075-19030-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The btrfs filesystem resize command defaults to only resizing the
filesystem for devid 1, and must have a devid passed in to resize the
filesystem for the other devices in the filesystem.

Additionally the documentation lacked information on how to actually
resize the underlying partition so this provides a little more detail.

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 cmds-filesystem.c |    4 ++--
 man/btrfs.8.in    |   17 +++++++++++------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 1f53d1c..00e4310 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -456,10 +456,10 @@ static int cmd_defrag(int argc, char **argv)
 }
 
 static const char * const cmd_resize_usage[] = {
-	"btrfs filesystem resize [+/-]<newsize>[gkm]|max <path>",
+	"btrfs filesystem resize [devid:][+/-]<newsize>[gkm]|[devid:]max <path>",
 	"Resize a filesystem",
 	"If 'max' is passed, the filesystem will occupy all available space",
-	"on the device.",
+	"on the device 'devid'.",
 	NULL
 };
 
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index be478e0..8066039 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -19,7 +19,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
 .PP
-\fBbtrfs\fP \fBfilesystem resize\fP\fI [+/\-]<size>[gkm]|max <filesystem>\fP
+\fBbtrfs\fP \fBfilesystem resize\fP\fI [devid:][+/\-]<size>[gkm]|[devid:]max <filesystem>\fP
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
@@ -166,23 +166,28 @@ Force a sync for the filesystem identified by \fI<path>\fR.
 .\" Some wording are extracted by the resize2fs man page
 .\"
 
-\fBfilesystem resize\fR\fI [+/\-]<size>[gkm]|max <path>\fR
-Resize a filesystem identified by \fI<path>\fR.
+\fBfilesystem resize\fR\fI [devid:][+/\-]<size>[gkm]|[devid:]max <path>\fR
+Resize a filesystem identified by \fI<path>\fR for the underlying device
+\fIdevid\fR.  The \fIdevid\fR can be found with \fBbtrfs filesystem show\fR and
+defaults to 1 if not specified.
 The \fI<size>\fR parameter specifies the new size of the filesystem.
 If the prefix \fI+\fR or \fI\-\fR is present the size is increased or decreased
 by the quantity \fI<size>\fR.
 If no units are specified, the unit of the \fI<size>\fR parameter defaults to
 bytes. Optionally, the size parameter may be suffixed by one of the following
-the units designators: 'K', 'M', or 'G', kilobytes, megabytes, or gigabytes,
+the unit designators: 'K', 'M', or 'G', kilobytes, megabytes, or gigabytes,
 respectively.
 
 If 'max' is passed, the filesystem will occupy all available space on the
-volume(s).
+device \fIdevid\fR.
 
 The \fBresize\fR command \fBdoes not\fR manipulate the size of underlying
 partition.  If you wish to enlarge/reduce a filesystem, you must make sure you
 can expand the partition before enlarging the filesystem and shrink the
-partition after reducing the size of the filesystem.
+partition after reducing the size of the filesystem.  This can done using
+\fBfdisk(8)\fR or \fBparted(8)\fR to delete the existing partition and recreate
+it with the new desired size.  When recreating the partition make sure to use
+the same starting disk cylinder as before.
 .TP
 
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
-- 
1.7.7.6

