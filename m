Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:35822 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934600Ab2KBKPI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Nov 2012 06:15:08 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so1312463eaa.19
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2012 03:15:07 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 8/8] Create a new entry in btrfs man page for btrfs device disk-usage.
Date: Fri,  2 Nov 2012 11:15:39 +0100
Message-Id: <1351851339-19150-9-git-send-email-kreijack@inwind.it>
In-Reply-To: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
References: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 man/btrfs.8.in |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index eabf0a8..a411ff8 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -44,6 +44,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP
 .PP
+\fBbtrfs\fP \fBdevice disk-usage\fP\fI [-b] <path> [<path>...] \fP
+.PP
 \fBbtrfs\fP \fBscrub start\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
 .PP
 \fBbtrfs\fP \fBscrub cancel\fP {\fI<path>\fP|\fI<device>\fP}
@@ -324,6 +326,12 @@ Add device(s) to the filesystem identified by \fI<path>\fR.
 Remove device(s) from a filesystem identified by \fI<path>\fR.
 .TP
 
+\fBdevice disk-usage\fR\fI [-b] <path> [<path>..] <path>\fR
+Show which chunks are in a device.
+
+\fB-b\fP set byte as unit.
+.TP
+
 \fBdevice scan\fR \fI[--all-devices|<device> [<device>...]\fR
 If one or more devices are passed, these are scanned for a btrfs filesystem. 
 If no devices are passed, \fBbtrfs\fR scans all the block devices listed
-- 
1.7.10.4

