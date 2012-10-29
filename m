Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37468 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760060Ab2J2Rwr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 13:52:47 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so2229927eek.19
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Oct 2012 10:52:46 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Wang Sheng-Hui <shhuiw@gmail.com>
Subject: [PATCH 4/4] Update the man page with the new prefixes.
Date: Mon, 29 Oct 2012 18:53:20 +0100
Message-Id: <1351533200-5703-5-git-send-email-kreijack@inwind.it>
In-Reply-To: <1351533200-5703-1-git-send-email-kreijack@inwind.it>
References: <1351533200-5703-1-git-send-email-kreijack@inwind.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 man/btrfs.8.in      |    3 +++
 man/mkfs.btrfs.8.in |    3 +++
 2 files changed, 6 insertions(+)

diff --git a/man/btrfs.8.in b/man/btrfs.8.in
index 9222580..3564e6a 100644
--- a/man/btrfs.8.in
+++ b/man/btrfs.8.in
@@ -184,6 +184,9 @@ defragment operations.
 
 \fB-t size\fP defragment only files at least \fIsize\fR bytes big
 
+For \fBstart\fP, \fBlen\fP, \fBsize\fP it is possible to append a suffix
+like \fBk\fP for 1 KBytes, \fBm\fP for 1 MBytes...
+
 NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed copies of data,
 don't use it if you use snapshots, have de-duplicated your data or made
 copies with \fBcp --reflink\fP.
diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
index 72025ed..6f37cd8 100644
--- a/man/mkfs.btrfs.8.in
+++ b/man/mkfs.btrfs.8.in
@@ -69,6 +69,9 @@ Do not perform whole device TRIM operation by default.
 .TP
 \fB\-V\fR, \fB\-\-version\fR
 Print the \fBmkfs.btrfs\fP version and exit.
+.SH UNIT
+As default the unit is the byte, however it is possible to append a suffix
+to the arguments like \fBk\fP for KBytes, \fBm\fP for MBytes...
 .SH AVAILABILITY
 .B mkfs.btrfs
 is part of btrfs-progs. Btrfs is currently under heavy development,
-- 
1.7.10.4

