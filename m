Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm4.bullet.mail.ird.yahoo.com ([77.238.189.61]:41496 "HELO
	nm4.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755798Ab3BRVEF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Feb 2013 16:04:05 -0500
From: Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>
Subject: [PATCH 6/8] Create entry in man page for btrfs filesystem disk-usage
Date: Mon, 18 Feb 2013 22:04:31 +0100
Message-Id: <1361221473-20347-7-git-send-email-goffredo.baroncelli@yahoo.com>
In-Reply-To: <1361221473-20347-1-git-send-email-goffredo.baroncelli@yahoo.com>
References: <1361221473-20347-1-git-send-email-goffredo.baroncelli@yahoo.com>
Reply-to: kreijack@inwind.it
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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

