Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:36960 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3CKURb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 16:17:31 -0400
From: Hugo Mills <hugo@carfax.org.uk>
To: linux-btrfs@vger.kernel.org, Goffredo Baroncelli <kreijack@gmail.com>,
        Harald Glatt <mail@hachre.de>, Roger Binns <rogerb@rogerbinns.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Diego Calleja <diegocg@gmail.com>, sam tygier <samtygier@yahoo.co.uk>,
        David Sterba <dsterba@suse.cz>
Subject: [PATCH v2 5/5] Add man page description for NcMsPp replication levels
Date: Mon, 11 Mar 2013 20:17:28 +0000
Message-Id: <1363033048-17481-6-git-send-email-hugo@carfax.org.uk>
In-Reply-To: <1363033048-17481-1-git-send-email-hugo@carfax.org.uk>
References: <1363033048-17481-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Hugo Mills <hugo@carfax.org.uk>
---
 man/btrfs.8.in      |   16 ++++++++++++++++
 man/mkfs.btrfs.8.in |   24 +++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 94f4ffe..4072510 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -25,6 +25,8 @@ btrfs \- control a btrfs filesystem
 [-s \fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> \
 [<\fIfile\fR>|<\fIdir\fR>...]
 .PP
+\fBbtrfs\fP \fBfilesystem df\fP [-r|-e]\fI <path> \fP
+.PP
 \fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
 .PP
 \fBbtrfs\fP \fBfilesystem resize\fP\fI [devid:][+/\-]<size>[gkm]|[devid:]max <filesystem>\fP
@@ -217,6 +219,20 @@ don't use it if you use snapshots, have de-duplicated your data or made
 copies with \fBcp --reflink\fP.
 .TP
 
+\fBfilesystem df\fR [-r|-e] \fI<path>\fR
+Show usage information for the filesystem identified by \fI<path>\fR.
+
+\fB-r, --raid\fP Use old-style "RAID-n" terminology to show replication types
+
+\fB-e, --explain\fP Explain the new-style NcMsPp terminology in more
+detail: Nc shows the number of copies of data; a trailing "d"
+indicates reduced device redundancy (e.g. more than one of the copies
+may live on a single device), Ms shows the number of data stripes per
+copy (with "Xs" indicating as many as will fit across the available
+devices), and Pp shows the number of parity stripes.
+
+.TP
+
 \fBfilesystem sync\fR\fI <path> \fR
 Force a sync for the filesystem identified by \fI<path>\fR.
 .TP
diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index 41163e0..6d1f5d0 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -37,7 +37,29 @@ mkfs.btrfs uses all the available storage for the filesystem.
 .TP
 \fB\-d\fR, \fB\-\-data \fItype\fR
 Specify how the data must be spanned across the devices specified. Valid
-values are raid0, raid1, raid10 or single.
+values are of the form <n>c[d][<m>s[<p>p]], where <n> is the number of copies
+of data, <m> is the number of stripes per copy, and <p> is the number of parity
+stripes. The <m> parameter must (currently) be a literal "X", indicating that
+as many stripes as possible will be used. The letter "d" may be added to the
+number of copies, to indicate non-redundant copies (e.g. on the same device).
+
+The following deprecated values may also be used:
+.RS 16
+.P
+single	1c
+.P
+raid0	1cXs
+.P
+raid1	2c
+.P
+dup		2cd
+.P
+raid10	2cXsS
+.P
+raid5	1cXs1p
+.P
+raid6	1cXs2p
+.RS -16
 .TP
 \fB\-f\fR
 Force overwrite when an existing filesystem is detected on the device.
-- 
1.7.10.4

