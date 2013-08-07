Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64482 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756836Ab3HGFz6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 01:55:58 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [v2 1/8] Btrfs-progs: add missing man page information for btrfsck
Date: Wed, 7 Aug 2013 13:54:02 +0800
Message-Id: <1375854849-15224-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
V1->V2: remove wrong copyright information
---
 man/btrfsck.8.in | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/man/btrfsck.8.in b/man/btrfsck.8.in
index 5004ba0..37b9cf6 100644
--- a/man/btrfsck.8.in
+++ b/man/btrfsck.8.in
@@ -1,11 +1,29 @@
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
 .SH AVAILABILITY
 .B btrfsck
 is part of btrfs-progs. Btrfs is currently under heavy development,
@@ -13,4 +31,5 @@ and not suitable for any uses other than benchmarking and review.
 Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
 further details.
 .SH SEE ALSO
-.BR mkfs.btrfs (8)
+.BR mkfs.btrfs (8),
+.BR btrfs (8)
-- 
1.8.0.1

