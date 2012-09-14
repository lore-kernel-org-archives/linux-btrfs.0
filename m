Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:33224 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab2INGBS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 02:01:18 -0400
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: kreijack@libero.it, chris.mason@fusionio.com, hugo@carfax.org.uk
Subject: [PATCH 1/1] Btrfs-progs: Update btrfs man page to indicate label for a mounted fs can be changed
Date: Fri, 14 Sep 2012 14:03:19 +0800
Message-Id: <1347602599-7541-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <503FB090.6030108@libero.it>
References: <503FB090.6030108@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 man/btrfs.8.in |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 4b0a9f9..0258d87 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -25,7 +25,7 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem resize\fP\fI [devid:][+/\-]<size>[gkm]|[devid:]max <filesystem>\fP
 .PP
-\fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
+\fBbtrfs\fP \fBfilesystem label\fP\fI <dev>|<path> [newlabel]\fP
 .PP
 \fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
 .PP
@@ -197,8 +197,8 @@ it with the new desired size.  When recreating the partition make sure to use
 the same starting disk cylinder as before.
 .TP
 
-\fBfilesystem label\fP\fI <dev> [newlabel]\fP
-Show or update the label of a filesystem. \fI<dev>\fR is used to identify the
+\fBfilesystem label\fP\fI <dev>|<path> [newlabel]\fP
+Show or update the label of a filesystem. \fI<dev>|<path>\fR is used to identify the
 filesystem. 
 If a \fInewlabel\fR optional argument is passed, the label is changed. The
 following constraints exist for a label:
@@ -207,11 +207,9 @@ following constraints exist for a label:
 .IP
 - the label shall not  contain the '/' or '\\' characters.
 
-NOTE: Currently there are the following limitations:
-.IP
-- the filesystem has to be unmounted
-.IP
-- the filesystem should not have more than one device.
+Note: 
+As of now a btrfs filesystem containing more than one device must be
+mounted to change its filesystem label.
 .TP
 
 \fBfilesystem show\fR [--all-devices|<uuid>|<label>]\fR
-- 
1.7.1

