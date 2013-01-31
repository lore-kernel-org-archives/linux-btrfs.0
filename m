Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49768 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab3AaFhP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 00:37:15 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] Btrfs-progs: man btrfs: subcommands must be grouped together
Date: Thu, 31 Jan 2013 13:35:31 +0800
Message-Id: <1359610531-22279-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1359610531-22279-1-git-send-email-anand.jain@oracle.com>
References: <1359610531-22279-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 man/btrfs.8.in | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index c8fdc15..8d3ecba 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -19,6 +19,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBsubvolume show\fP\fI <path>\fP
 .PP
+\fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
+.PP
 \fBbtrfs\fP \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] \
 [-s \fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> \
 [<\fIfile\fR>|<\fIdir\fR>...]
@@ -29,8 +31,6 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
-\fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
-.PP
 \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
 .PP
 \fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|<device> [<device>...]]\fP
@@ -172,6 +172,10 @@ is similar to \fBsubvolume list\fR command.
 Show information of a given subvolume in the \fI<path>\fR.
 .TP
 
+\fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
+List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
+.TP
+
 \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] [-s \fIstart\fR] \
 [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> [<\fIfile\fR>|<\fIdir\fR>...]
 
@@ -201,10 +205,6 @@ don't use it if you use snapshots, have de-duplicated your data or made
 copies with \fBcp --reflink\fP.
 .TP
 
-\fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
-List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
-.TP
-
 \fBfilesystem sync\fR\fI <path> \fR
 Force a sync for the filesystem identified by \fI<path>\fR.
 .TP
-- 
1.8.1.227.g44fe835

