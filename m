Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53730 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbaCaKHn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 06:07:43 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2VA7UTl028418
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 18:07:32 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: update manpage for btrfs resize support size unit t/p/e
Date: Mon, 31 Mar 2014 18:03:26 +0800
Message-Id: <1396260206-14153-2-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1396260206-14153-1-git-send-email-guihc.fnst@cn.fujitsu.com>
References: <1396260206-14153-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs resize now support size unit parse of k/m/g/t/p/e in kernel space,
adopt the changes in userspace manpage.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 cmds-filesystem.c | 3 ++-
 man/btrfs.8.in    | 9 +++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 7eb6e9d..b81768b 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -922,10 +922,11 @@ static int cmd_defrag(int argc, char **argv)
 }
 
 static const char * const cmd_resize_usage[] = {
-	"btrfs filesystem resize [devid:][+/-]<newsize>[gkm]|[devid:]max <path>",
+	"btrfs filesystem resize [devid:][+/-]<newsize>[kKmMgGtTpPeE]|[devid:]max <path>",
 	"Resize a filesystem",
 	"If 'max' is passed, the filesystem will occupy all available space",
 	"on the device 'devid'.",
+	"[kK] means KiB, which denotes 1KiB = 1024B, 1MiB = 1024KiB, etc.",
 	NULL
 };
 
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 7fbde82..3349d85 100644
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
@@ -352,8 +352,9 @@ If the prefix \fI+\fR or \fI\-\fR is present the size is increased or decreased
 by the quantity \fI<size>\fR.
 If no units are specified, the unit of the \fI<size>\fR parameter defaults to
 bytes. Optionally, the size parameter may be suffixed by one of the following
-units designators: 'K', 'M', or 'G', kilobytes, megabytes, or gigabytes,
-respectively.
+units designators: 'K', 'M', 'G', 'T', 'P', 'E', kilobytes, megabytes, gigabytes,
+terabytes, petabytes, exabytes respectively.
+K means KiB, which denotes 1KiB = 1024B, 1MiB = 1024KiB, etc..
 
 If 'max' is passed, the filesystem will occupy all available space on the
 device \fIdevid\fR.
-- 
1.8.1.4

