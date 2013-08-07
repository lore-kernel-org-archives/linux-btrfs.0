Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52270 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757055Ab3HGF4C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 01:56:02 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [v2 7/8] Btrfs-progs: add missing man page information for btrfs-zero-log
Date: Wed, 7 Aug 2013 13:54:08 +0800
Message-Id: <1375854849-15224-7-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1375854849-15224-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1375854849-15224-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
V1->V2: GPLv3->GPLv2
---
 man/Makefile            |  2 +-
 man/btrfs-zero-log.8.in | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 1 deletion(-)
 create mode 100644 man/btrfs-zero-log.8.in

diff --git a/man/Makefile b/man/Makefile
index e1246db..5ccb60a 100644
--- a/man/Makefile
+++ b/man/Makefile
@@ -13,7 +13,7 @@ man8dir = $(mandir)/man8
 
 MANPAGES = mkfs.btrfs.8.gz btrfsck.8.gz btrfs-image.8.gz btrfs.8.gz \
 	   btrfs-debug-tree.8.gz btrfs-show-super.8.gz btrfs-find-root.8.gz \
-	   btrfs-convert.8.gz btrfstune.8.gz
+	   btrfs-convert.8.gz btrfstune.8.gz btrfs-zero-log.8.gz
 INFILES = ${MANPAGES:.in=.gz}
 
 all: $(MANPAGES)
diff --git a/man/btrfs-zero-log.8.in b/man/btrfs-zero-log.8.in
new file mode 100644
index 0000000..9bdf34b
--- /dev/null
+++ b/man/btrfs-zero-log.8.in
@@ -0,0 +1,29 @@
+.TH BTRFS-ZERO-LOG 8
+.SH NAME
+btrfs-zero-log \- clear out log tree.
+.SH SYNOPSIS
+.B btrfs-zero-log \fI <dev>\fP
+.SH DESCRIPTION
+\fBbtrfs-zero-log\fP will remove the log tree if log tree is corrupt, which will allow you to mount the filesystem again. The common case where this
+happens has been fixed a long time ago, so it is unlikely that you will see this particular problem.
+
+.SH EXIT CODE
+\fBbtrfs-zero-log\fR will return 0 exit code if no error happened.
+Other exit code means some problems happened.
+
+.SH AUTHOR
+Written by Shilong Wang and Wenruo Qu.
+
+.SH COPYRIGHT
+Copyright \(co 2013 Fujitsu, Inc.
+License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
+.br
+This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
+.SH AVAILABILITY
+.B btrfs-zero-log
+is part of btrfs-progs. Btrfs is currently under heavy development,
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+.SH SEE ALSO
+.BR mkfs.btrfs (8)
-- 
1.8.0.1

