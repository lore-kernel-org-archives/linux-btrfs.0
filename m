Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51930 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab2JMT1F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Oct 2012 15:27:05 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2406769eek.19
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Oct 2012 12:27:04 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: kreijack@gmail.com
Cc: Hugo Mills <hugo@carfax.org.uk>, Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dave@jikos.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/3] Document the use of BTRFS_UNIT in man page.
Date: Sat, 13 Oct 2012 21:27:16 +0200
Message-Id: <1350156436-14439-4-git-send-email-kreijack@gmail.com>
In-Reply-To: <1350156436-14439-1-git-send-email-kreijack@gmail.com>
References: <1350156436-14439-1-git-send-email-kreijack@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Goffredo Baroncelli <kreijack@inwind.it>

---
 man/btrfs.8.in |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 9222580..fe7a5e3 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -355,6 +355,20 @@ not enough to read all the resolved results. The max value one can set is 64k.
 \fBbtrfs\fR returns a zero exist status if it succeeds. Non zero is returned in
 case of failure.
 
+.SH ENVIRONMENTAL VARIABLES
+\fBBTRFS_UNIT\fR set the kind of suffix for the number output by \fBbtrfs\fR. 
+Possible values:
+.RS
+.IP BTRFS_UNIT=IEC
+The number have the IEC suffix: e.g. KiB = 1024 bytes, MiB = 1024 KiB...
+.IP BTRFS_UNIT=SI 
+The number have the SI suffix: e.g. KB = 1000 bytes, MB = 1000 KB...
+.IP BTRFS_UNIT=COMPACT
+For compatibility; the number have the SI suffix but the unit is multiply
+of power of two. E.g. KB = 1024 bytes, MB = 1024 KiB...
+There is no space between the number and the suffix.
+.RE
+
 .SH AVAILABILITY
 .B btrfs
 is part of btrfs-progs. Btrfs filesystem is currently under heavy development,
-- 
1.7.10.4

