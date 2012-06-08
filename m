Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:54558 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab2FHTMw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jun 2012 15:12:52 -0400
From: Goffredo Baroncelli <kreijack@inwind.it>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: [PATCH 3/3] Add btrfs filesystem info man page.
Date: Fri,  8 Jun 2012 21:12:46 +0200
Message-Id: <1339182766-15292-4-git-send-email-kreijack@inwind.it>
In-Reply-To: <1339182766-15292-1-git-send-email-kreijack@inwind.it>
References: <1339182766-15292-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update the man page to document the "btrfs filesystem info <path>"
command.
---
 man/btrfs.8.in |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index be478e0..6d96bf7 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -25,6 +25,8 @@ btrfs \- control a btrfs filesystem
 .PP
 \fBbtrfs\fP \fBfilesystem defrag\fP\fI [options] <file>|<dir> [<file>|<dir>...]\fP
 .PP
+\fBbtrfs\fP \fBfilesystem info\fP\fI <path>\fP
+.PP
 \fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
 .PP
 \fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
@@ -154,6 +156,12 @@ The start position and the number of bytes to deframention can be specified by \
 NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed copies of data, don't 
 use it if you use snapshots, have de-duplicated your data or made copies with 
 \fBcp --reflink\fP.
+.TP
+
+\fBfilesystem info\fP \fI<path>\fR
+Get filesystem info.
+.TP
+
 \fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
 List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
 .TP
-- 
1.7.10

