Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10173 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751057AbaDAKFS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Apr 2014 06:05:18 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s31A5Al3012582
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Apr 2014 18:05:10 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH v2] btrfs-progs: update manpage for btrfs resize support size unit t/p/e
Date: Tue, 1 Apr 2014 18:01:10 +0800
Message-ID: <1396346470-2832-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs resize now support size unit parse of k/m/g/t/p/e in kernel space,
adopt the changes in userspace manpage.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
changelog
	v1->v2: replace kilobyte with kibibyte, and others
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
index 7fbde82..9fad64a 100644
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
+units designators: 'K', 'M', 'G', 'T', 'P', 'E', kibibytes, mebibytes, gibibytes,
+tebibytes, pebibytes, exbibytes respectively.
+K means KiB, which denotes 1KiB = 1024B, 1MiB = 1024KiB, etc..
 
 If 'max' is passed, the filesystem will occupy all available space on the
 device \fIdevid\fR.
-- 
1.8.1.4

