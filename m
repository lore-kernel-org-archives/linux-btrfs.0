Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:47785 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbaC0CzR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Mar 2014 22:55:17 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2R2tBvo021461
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Mar 2014 10:55:12 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: update manpage for btrfs resize support size unit t/p/e
Date: Thu, 27 Mar 2014 10:51:13 +0800
Message-Id: <1395888673-28433-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1395888673-28433-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1395888673-28433-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs resize now support size unit parse of k/m/g/t/p/e in kernel space,
adopt the changes in userspace manpage.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-filesystem.c | 2 +-
 man/btrfs.8.in    | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 7eb6e9d..a400315 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -922,7 +922,7 @@ static int cmd_defrag(int argc, char **argv)
 }
 
 static const char * const cmd_resize_usage[] = {
-	"btrfs filesystem resize [devid:][+/-]<newsize>[gkm]|[devid:]max <path>",
+	"btrfs filesystem resize [devid:][+/-]<newsize>[kKmMgGtTpPeE]|[devid:]max <path>",
 	"Resize a filesystem",
 	"If 'max' is passed, the filesystem will occupy all available space",
 	"on the device 'devid'.",
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 7fbde82..76c9d4d 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -31,7 +31,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem defragment\fP [\fIoptions\fP] \fI<file>\fP|\fI<dir>\fP [\fI<file>\fP|\fI<dir>...\fP]\fP
 .PP
-\fBbtrfs\fP \fBfilesystem resize\fP [\fIdevid\fP:][+/\-]\fI<size>\fP[gkm]|[\fIdevid\fP:]\fImax <path>\fP
+\fBbtrfs\fP \fBfilesystem resize\fP [\fIdevid\fP:][+/\-]\fI<size>\fP[kKmMgGtTpPeE]|[\fIdevid\fP:]\fImax <path>\fP
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP [\fI<device>\fP|\fI<mount_point>\fP] [\fI<newlabel>\fP]
 .PP
@@ -343,7 +343,7 @@ copies with \fBcp --reflink\fP.
 .\"
 .\" Some wording are extracted by the resize2fs man page
 .\"
-\fBfilesystem resize\fP [\fIdevid\fP:][+/\-]\fI<size>\fP[gkm]|[\fIdevid\fP:]\fImax <path>\fR
+\fBfilesystem resize\fP [\fIdevid\fP:][+/\-]\fI<size>\fP[kKmMgGtTpPeE]|[\fIdevid\fP:]\fImax <path>\fR
 Resize a filesystem identified by \fI<path>\fR for the underlying device
 \fIdevid\fR.  The \fIdevid\fR can be found with \fBbtrfs filesystem show\fR and
 defaults to 1 if not specified.
@@ -352,7 +352,8 @@ If the prefix \fI+\fR or \fI\-\fR is present the size is increased or decreased
 by the quantity \fI<size>\fR.
 If no units are specified, the unit of the \fI<size>\fR parameter defaults to
 bytes. Optionally, the size parameter may be suffixed by one of the following
-units designators: 'K', 'M', or 'G', kilobytes, megabytes, or gigabytes,
+units designators: 'K', 'M', 'G', 'T', 'P', 'E', kilobytes, megabytes, gigabytes,
+terabytes, petabytes, exabytes
 respectively.
 
 If 'max' is passed, the filesystem will occupy all available space on the
-- 
1.8.1.4

