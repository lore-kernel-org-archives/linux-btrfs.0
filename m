Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm23-vm2.bullet.mail.ird.yahoo.com ([212.82.109.231]:31671 "HELO
	nm23-vm2.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759122Ab3BWNpY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Feb 2013 08:45:24 -0500
From: Goffredo Baroncelli <goffredo.baroncelli@yahoo.com>
To: linux-btrfs@vger.kernel.org
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Michael =?utf-8?q?Kj=C3=B6rling?= <michael@kjorling.se>,
        Martin Steigerwald <Martin@lichtvoll.de>, cwillu <cwillu@cwillu.com>,
        Chris Murphy <lists@colorremedies.com>, David Sterba <dsterba@suse.cz>,
        Zach Brown <zab@zabbo.net>, Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 8/8] Create a new entry in btrfs man page for btrfs device disk-usage.
Date: Sat, 23 Feb 2013 14:46:11 +0100
Message-Id: <1361627171-8246-9-git-send-email-goffredo.baroncelli@yahoo.com>
In-Reply-To: <1361627171-8246-1-git-send-email-goffredo.baroncelli@yahoo.com>
References: <1361627171-8246-1-git-send-email-goffredo.baroncelli@yahoo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 man/btrfs.8.in |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 50dc510..e60c81f 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -46,6 +46,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP
 .PP
+\fBbtrfs\fP \fBdevice disk-usage\fP\fI [-b] <path> [<path>...] \fP
+.PP
 \fBbtrfs\fP \fBreplace start\fP \fI[-Bfr] <srcdev>|<devid> <targetdev> <path>\fP
 .PP
 \fBbtrfs\fP \fBreplace status\fP \fI[-1] <path>\fP
@@ -360,6 +362,12 @@ Add device(s) to the filesystem identified by \fI<path>\fR.
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

