Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm7.bullet.mail.ird.yahoo.com ([77.238.189.21]:27567 "HELO
	nm7.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751987Ab3CJMQi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 08:16:38 -0400
From: Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Zach Brown <zab@zabbo.net>, Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 6/8] Create entry in man page for btrfs filesystem disk-usage
Date: Sun, 10 Mar 2013 13:17:37 +0100
Message-Id: <1362917859-18824-7-git-send-email-goffredo.baroncelli@yahoo.com>
In-Reply-To: <1362917859-18824-1-git-send-email-goffredo.baroncelli@yahoo.com>
References: <1362917859-18824-1-git-send-email-goffredo.baroncelli@yahoo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 man/btrfs.8.in |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index e2f86ea..50dc510 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -29,6 +29,9 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem resize\fP\fI [devid:][+/\-]<size>[gkm]|[devid:]max <filesystem>\fP
 .PP
+\fBbtrfs\fP \fBfilesystem filesystem disk-usage [-t][-b]\fP\fI <path> 
+[path..]\fP
+.PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
 \fBbtrfs\fP \fBfilesystem df\fP\fI [-b] \fIpath [path..]\fR\fP
@@ -251,6 +254,16 @@ it with the new desired size.  When recreating the partition make sure to use
 the same starting disk cylinder as before.
 .TP
 
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
 \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 Show or update the label of a filesystem. \fI<dev>\fR is used to identify the
 filesystem. 
-- 
1.7.10.4

