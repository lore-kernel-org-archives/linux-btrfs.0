Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52312 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab3HAFhC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Aug 2013 01:37:02 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r715avKS009257
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Aug 2013 13:36:58 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 05/10] Btrfs-progs: add man page information for btrfs-convert
Date: Thu, 1 Aug 2013 13:35:29 +0800
Message-Id: <1375335334-32540-5-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1375335334-32540-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1375335334-32540-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 man/Makefile           |  3 ++-
 man/btrfs-convert.8.in | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletion(-)
 create mode 100644 man/btrfs-convert.8.in

diff --git a/man/Makefile b/man/Makefile
index 3d2e3ba..a2201e8 100644
--- a/man/Makefile
+++ b/man/Makefile
@@ -12,7 +12,8 @@ man8dir = $(mandir)/man8
 .SUFFIXES: .in .gz
 
 MANPAGES = mkfs.btrfs.8.gz btrfsck.8.gz btrfs-image.8.gz btrfs.8.gz \
-	   btrfs-debug-tree.8.gz btrfs-show-super.8.gz btrfs-find-root.8.gz
+	   btrfs-debug-tree.8.gz btrfs-show-super.8.gz btrfs-find-root.8.gz \
+	   btrfs-convert.8.gz
 INFILES = ${MANPAGES:.in=.gz}
 
 all: $(MANPAGES)
diff --git a/man/btrfs-convert.8.in b/man/btrfs-convert.8.in
new file mode 100644
index 0000000..1183977
--- /dev/null
+++ b/man/btrfs-convert.8.in
@@ -0,0 +1,39 @@
+.TH BTRFS-CONVERT 8
+.SH NAME
+btrfs-convert \- convert ext2/3/4 to btrfs.
+.SH SYNOPSIS
+.B btrfs-convert [\fIoptions\fP] \fI<dev>\fP
+.SH DESCRIPTION
+\fBbtrfs-convert\fP is used to convert existed ext2/3/4 to btrfs filesystem, and the original filesystem image is accessible as from separate subvolume named ext2_subvol as file image.
+
+\fIOptions\fP
+.IP "\fB-d\fP" 5
+disable data checksum.
+.IP "\fB-i\fP" 5
+ignore xattrs and ACLs.
+.IP "\fB-n\fP" 5
+disable packing of small files.
+.IP "\fB-r\fP" 5
+roll back to ext2fs.
+
+.SH EXIT CODE
+\fBbtrfs-convert\fP will return 0 if no error happened.
+If any problems happened, 1 will be returned.
+
+.SH AUTHOR
+Written by Shilong Wang and Wenruo Qu.
+
+.SH COPYRIGHT
+Copyright \(co 2013 Fujitsu, Inc.
+License GPLv3: GNU GPL version 3 <http://gnu.org/licenses/gpl.html>.
+.br
+This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
+
+.SH AVAILABILITY
+.B btrfs-convert
+is part of btrfs-progs. Btrfs is currently under heavy development,
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+.SH SEE ALSO
+.BR mkfs.btrfs (8)
-- 
1.8.0.1

