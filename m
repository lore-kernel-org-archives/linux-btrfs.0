Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56462 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3HNEbS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 00:31:18 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 1/8] Btrfs-progs: add missing man page information for btrfsck
Date: Wed, 14 Aug 2013 12:29:10 +0800
Message-Id: <1376454557-3041-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2->v3: availiable parts is not true anymore,remove it.
v1->v2: remove wrong copyrights.
---
 man/btrfsck.8.in | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/man/btrfsck.8.in b/man/btrfsck.8.in
index 5004ba0..bf65e3c 100644
--- a/man/btrfsck.8.in
+++ b/man/btrfsck.8.in
@@ -1,16 +1,29 @@
 .TH BTRFSCK 8
 .SH NAME
-btrfsck \- check a btrfs filesystem
+btrfsck \- check and repair of a Btrfs filesystem
 .SH SYNOPSIS
-.B btrfsck \fI device\fP
+.B btrfsck [\fIoptions\fP] \fI<device>\fP
 .SH DESCRIPTION
-\fBbtrfsck\fP is used to check a btrfs filesystem.
-\fIdevice\fP is the device file where the filesystem is stored.
-.SH AVAILABILITY
-.B btrfsck
-is part of btrfs-progs. Btrfs is currently under heavy development,
-and not suitable for any uses other than benchmarking and review.
-Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
-further details.
+\fBbtrfsck\fP is used to check and optionally repair of a Btrfs filesystem. Now, it can only be run on an unmounted FS. Considering it is not well-tested
+in real-life situations yet. if you have a broken Btrfs filesystem, btrfsck may not repair but cause aditional damages. \fI<device>\fP is the device file
+where the filesystem is stored.
+
+\fIOptions\fP
+.IP "\fB-s,--super \fI<superblock>\fP" 5
+specify which superblock copy that you want to use.
+.IP "\fB--repair\fP" 5
+try to repair the filesystem.
+.IP "\fB--init-csum-tree\fP" 5
+create a new CRC tree.
+.IP "\fB--init-extent-tree\fP" 5
+create a new extent tree.
+
+.SH EXIT CODE
+\fBbtrfsck\fR will return 0 exit code if no error happened.
+Other exit code means some problems happened.
+
+.br
+This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
 .SH SEE ALSO
-.BR mkfs.btrfs (8)
+.BR mkfs.btrfs (8),
+.BR btrfs (8)
-- 
1.8.0.1

