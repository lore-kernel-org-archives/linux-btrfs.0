Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:52270 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab3HGF4B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 01:56:01 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [v2 3/8] Btrfs-progs: add missing man page for btrfs-show-super
Date: Wed, 7 Aug 2013 13:54:04 +0800
Message-Id: <1375854849-15224-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1375854849-15224-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1375854849-15224-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
V1->V2: GPLv3->GPLv2
---
 man/Makefile              |  2 +-
 man/btrfs-show-super.8.in | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 1 deletion(-)
 create mode 100644 man/btrfs-show-super.8.in

diff --git a/man/Makefile b/man/Makefile
index e5c1f7c..b1d3645 100644
--- a/man/Makefile
+++ b/man/Makefile
@@ -12,7 +12,7 @@ man8dir = $(mandir)/man8
 .SUFFIXES: .in .gz
 
 MANPAGES = mkfs.btrfs.8.gz btrfsck.8.gz btrfs-image.8.gz btrfs.8.gz \
-	   btrfs-debug-tree.8.gz
+	   btrfs-debug-tree.8.gz btrfs-show-super.8.gz
 INFILES = ${MANPAGES:.in=.gz}
 
 all: $(MANPAGES)
diff --git a/man/btrfs-show-super.8.in b/man/btrfs-show-super.8.in
new file mode 100644
index 0000000..6588d46
--- /dev/null
+++ b/man/btrfs-show-super.8.in
@@ -0,0 +1,36 @@
+.TH BTRFS-SHOW-SUPER 8
+.SH NAME
+btrfs-show-super \- show btrfs superblock information stored in devices
+.SH SYNOPSIS
+.B btrfs-show-super [\fIoptions\fP] \fI<dev>\fP [\fI<dev>...\fP]
+.SH DESCRIPTION
+\fBbtrfs-show-super\fP is used to print the information of superblock,
+you can specify which mirror to print out. In default, every device's
+first superblock will be printed out.
+
+\fIOptions\fP
+.IP "\fB-a\fP" 5
+print all the superblock information, if this option is given, '\fB-i\fP' option will be ignored.
+.IP "\fB-i \fI<super_mirror>\fP" 5
+specify which mirror to print out. \fI<super_mirror>\fP is between 0 and 2. if several '\fB-i \fI<super_mirror>\fP'\fR are given, only the last one is valid.
+
+.SH EXIT CODE
+\fBbtrfs-show-super\fR will return 0 exit code if no error happened.
+If any problems happened, 1 will be returned.
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
+.B btrfs-show-super
+is part of btrfs-progs. Btrfs is currently under heavy development,
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+.SH SEE ALSO
+.BR mkfs.btrfs (8)
-- 
1.8.0.1

