Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:48598 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaBMTT5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Feb 2014 14:19:57 -0500
Received: from venice.bhome (151.28.65.181) by outrelay08.libero.it (8.6.033) (authenticated as kreijack@libero.it)
        id 52EA6A190310324C for linux-btrfs@vger.kernel.org; Thu, 13 Feb 2014 20:19:57 +0100
Message-ID: <52FD1AE2.8000001@libero.it>
Date: Thu, 13 Feb 2014 20:20:02 +0100
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/8] Create entry in man page for btrfs filesystem disk-usage
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <52FD1A72.5060307@libero.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 man/btrfs.8.in | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 4acf16d..4b7e771 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -35,6 +35,9 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem label\fP [\fI<device>\fP|\fI<mount_point>\fP] [\fI<newlabel>\fP]
 .PP
+\fBbtrfs\fP \fBfilesystem filesystem disk-usage [-t][-b]\fP\fI <path> 
+[path..]\fP
+.PP
 \fBbtrfs\fP \fBfilesystem df\fP\fI [-b] \fIpath [path..]\fR\fP
 .PP
 \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
@@ -341,6 +344,17 @@ the same starting disk cylinder as before.
 \fBfilesystem label\fP [\fI<dev>\fP|\fI<mount_point>\fP] [\fInewlabel\fP]\fP
 Show or update the label of a filesystem. \fI[<device>|<mountpoint>]\fR is used
 to identify the filesystem. 
+.TP
+\fBfilesystem disk-usage\fP [-t][-b] \fIpath [path..]\fR
+
+Show in which disk the chunks are allocated.
+
+\fB-b\fP Set byte as unit
+
+\fB-t\fP Show data in tabular format
+
+.TP
+
 If a \fInewlabel\fR optional argument is passed, the label is changed. The
 following constraints exist for a label:
 .IP
-- 
1.8.5.3



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
