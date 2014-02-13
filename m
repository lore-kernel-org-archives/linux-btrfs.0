Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay07.libero.it ([212.52.84.111]:45480 "EHLO
	outrelay07.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaBMTUR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 14:20:17 -0500
Received: from venice.bhome (151.28.65.181) by outrelay07.libero.it (8.6.033) (authenticated as kreijack@libero.it)
        id 52EA696D03090E04 for linux-btrfs@vger.kernel.org; Thu, 13 Feb 2014 20:20:16 +0100
Message-ID: <52FD1AF5.1080701@libero.it>
Date: Thu, 13 Feb 2014 20:20:21 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 8/8] Create a new entry in btrfs man page for btrfs device
 disk-usage.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <52FD1A72.5060307@libero.it>


Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 man/btrfs.8.in | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 4b7e771..0984504 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -59,6 +59,9 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice scan\fP [\fI--all-devices\fP|\fI<device> \P[\fI<device>...\fP]
 .PP
+\fBbtrfs\fP \fBdevice disk-usage\fP\fI [-b] <path> [<path>...] \fP
+.PP
+.PP
 \fBbtrfs\fP \fBdevice ready\fP\fI <device>\fP
 .PP
 \fBbtrfs\fP \fBdevice stats\fP [-z] {\fI<path>\fP|\fI<device>\fP}
@@ -474,6 +477,14 @@ Remove device(s) from a filesystem identified by \fI<path>\fR.
 .TP
 
 \fBdevice scan\fR [--all-devices|\fI<device> \fP[\fI<device>...\fP]\fR
+.TP
+
+\fBdevice disk-usage\fR\fI [-b] <path> [<path>..] <path>\fR
+Show which chunks are in a device.
+
+\fB-b\fP set byte as unit.
+.TP
+
 If one or more devices are passed, these are scanned for a btrfs filesystem. 
 If no devices are passed, \fBbtrfs\fR uses block devices containing btrfs
 filesystem as listed by blkid.
-- 
1.8.5.3



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
