Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:52384 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab3CIVIT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 Mar 2013 16:08:19 -0500
Received: from ruthven.local ([10.73.18.16] helo=ruthven.carfax.org.uk)
	by frost.carfax.org.uk with esmtp (Exim 4.72)
	(envelope-from <hugo@carfax.org.uk>)
	id 1UEQQD-0007mv-6S
	for linux-btrfs@vger.kernel.org; Sat, 09 Mar 2013 20:31:13 +0000
Received: from [10.0.0.10] (helo=ruthven.carfax.org.uk)
	by ruthven.carfax.org.uk with esmtp (Exim 4.80)
	(envelope-from <hugo@carfax.org.uk>)
	id 1UEQQC-0003Hi-P9
	for linux-btrfs@vger.kernel.org; Sat, 09 Mar 2013 20:31:12 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/5] Add man page description for nCmSpP replication levels
Date: Sat,  9 Mar 2013 20:31:11 +0000
Message-Id: <1362861071-12589-6-git-send-email-hugo@carfax.org.uk>
In-Reply-To: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 man/btrfs.8.in      |    9 +++++++++
 man/mkfs.btrfs.8.in |   24 +++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 94f4ffe..2799ec7 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -25,6 +25,8 @@ btrfs \- control a btrfs filesystem
 [-s \fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> \
 [<\fIfile\fR>|<\fIdir\fR>...]
 .PP
+\fBbtrfs\fP \fBfilesystem df\fP [-r]\fI <path> \fP
+.PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
 .PP
 \fBbtrfs\fP \fBfilesystem resize\fP\fI [devid:][+/\-]<size>[gkm]|[devid:]max <filesystem>\fP
@@ -217,6 +219,13 @@ don't use it if you use snapshots, have de-duplicated your data or made
 copies with \fBcp --reflink\fP.
 .TP
 
+\fBfilesystem df\fR [-r] \fI<path>\fR
+Show usage information for the filesystem identified by \fI<path>\fR.
+
+\fB-r, --raid\fP Use old-style "RAID-n" terminology to show replication types
+
+.TP
+
 \fBfilesystem sync\fR\fI <path> \fR
 Force a sync for the filesystem identified by \fI<path>\fR.
 .TP
diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index 41163e0..2e71e65 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -37,7 +37,29 @@ mkfs.btrfs uses all the available storage for the filesystem.
 .TP
 \fB\-d\fR, \fB\-\-data \fItype\fR
 Specify how the data must be spanned across the devices specified. Valid
-values are raid0, raid1, raid10 or single.
+values are of the form <n>C[D][<m>S[<p>P]], where <n> is the number of copies
+of data, <m> is the number of stripes per copy, and <p> is the number of parity
+stripes. The <m> parameter must (currently) be a literal "m", indicating that
+as many stripes as possible will be used. The letter D may be added to the
+number of copies, to indicate non-redundant copies (e.g. on the same device).
+
+The following deprecated values may also be used:
+.RS 16
+.P
+single	1C
+.P
+raid0	1CmS
+.P
+raid1	2C
+.P
+dup		2CD
+.P
+raid10	2CmS
+.P
+raid5	1CmS1P
+.P
+raid6	1CmS2P
+.RS -16
 .TP
 \fB\-f\fR
 Force overwrite when an existing filesystem is detected on the device.
-- 
1.7.10.4

