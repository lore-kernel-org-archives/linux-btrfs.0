Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48646 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906Ab2KBKPF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2012 06:15:05 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so1719880eek.19
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2012 03:15:04 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 6/8] Create entry in man page for btrfs filesystem disk-usage
Date: Fri,  2 Nov 2012 11:15:37 +0100
Message-Id: <1351851339-19150-7-git-send-email-kreijack@inwind.it>
In-Reply-To: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
References: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 man/btrfs.8.in |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 27d0160..eabf0a8 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -25,6 +25,9 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem resize\fP\fI [devid:][+/\-]<size>[gkm]|[devid:]max <filesystem>\fP
 .PP
+\fBbtrfs\fP \fBfilesystem filesystem disk-usage [-t][-b]\fP\fI <path> 
+[path..]\fP
+.PP
 \fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
 .PP
 \fBbtrfs\fP \fBfilesystem df\fP\fI [-b] \fIpath [path..]\fR\fP
@@ -227,6 +230,16 @@ it with the new desired size.  When recreating the partition make sure to use
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

