Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38064 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab3HAFhG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Aug 2013 01:37:06 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r715avKT009257
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Aug 2013 13:36:59 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 06/10] Btrfs-progs: add missing man page for btrfstune
Date: Thu, 1 Aug 2013 13:35:30 +0800
Message-Id: <1375335334-32540-6-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1375335334-32540-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1375335334-32540-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 man/Makefile       |  2 +-
 man/btrfstune.8.in | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 1 deletion(-)
 create mode 100644 man/btrfstune.8.in

diff --git a/man/Makefile b/man/Makefile
index a2201e8..e1246db 100644
--- a/man/Makefile
+++ b/man/Makefile
@@ -13,7 +13,7 @@ man8dir = $(mandir)/man8
 
 MANPAGES = mkfs.btrfs.8.gz btrfsck.8.gz btrfs-image.8.gz btrfs.8.gz \
 	   btrfs-debug-tree.8.gz btrfs-show-super.8.gz btrfs-find-root.8.gz \
-	   btrfs-convert.8.gz
+	   btrfs-convert.8.gz btrfstune.8.gz
 INFILES = ${MANPAGES:.in=.gz}
 
 all: $(MANPAGES)
diff --git a/man/btrfstune.8.in b/man/btrfstune.8.in
new file mode 100644
index 0000000..e0fb1fd
--- /dev/null
+++ b/man/btrfstune.8.in
@@ -0,0 +1,37 @@
+.TH BTRFSTUNE 8
+.SH NAME
+btrfstune \- tune various filesystem parameters.
+.SH SYNOPSIS
+.B btrfstune [\fIoptions\fP] \fI<mnt>\fP
+.SH DESCRIPTION
+\fBbtrfstune\fP is used to tune various filesystem parameters,you can
+enable/disable some extended features for btrfs.
+
+\fIOptions\fP
+.IP "\fB-S \fI<value>\fP" 5
+updates the seeding value, it forces a fs readonly so that you can use it to build other filesystems.
+.IP "\fB-r\fP" 5
+enable extended inode refs.
+.IP "\fB-x\fP" 5
+enable skinny metadata extent refs.
+
+.SH EXIT CODE
+\fBbtrfstune\fP will return 0 if no error happened.
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
+.SH AVAILABILITY
+.B btrfstune
+is part of btrfs-progs. Btrfs is currently under heavy development,
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+.SH SEE ALSO
+.BR mkfs.btrfs (8)
-- 
1.8.0.1

