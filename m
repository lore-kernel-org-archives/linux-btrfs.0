Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56462 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab3HNEbc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 00:31:32 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 8/8] Btrfs-progs: add missing man page for btrfs-map-logical
Date: Wed, 14 Aug 2013 12:29:17 +0800
Message-Id: <1376454557-3041-8-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1376454557-3041-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1376454557-3041-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2->v3: remove 'AVAILIABLE' parts.
v1->v2: GPLv3->GPLv2
---
 man/Makefile               |  2 +-
 man/btrfs-map-logical.8.in | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 1 deletion(-)
 create mode 100644 man/btrfs-map-logical.8.in

diff --git a/man/Makefile b/man/Makefile
index 5ccb60a..690fa65 100644
--- a/man/Makefile
+++ b/man/Makefile
@@ -13,7 +13,7 @@ man8dir = $(mandir)/man8
 
 MANPAGES = mkfs.btrfs.8.gz btrfsck.8.gz btrfs-image.8.gz btrfs.8.gz \
 	   btrfs-debug-tree.8.gz btrfs-show-super.8.gz btrfs-find-root.8.gz \
-	   btrfs-convert.8.gz btrfstune.8.gz btrfs-zero-log.8.gz
+	   btrfs-convert.8.gz btrfstune.8.gz btrfs-zero-log.8.gz btrfs-map-logical.8.gz
 INFILES = ${MANPAGES:.in=.gz}
 
 all: $(MANPAGES)
diff --git a/man/btrfs-map-logical.8.in b/man/btrfs-map-logical.8.in
new file mode 100644
index 0000000..d50ac96
--- /dev/null
+++ b/man/btrfs-map-logical.8.in
@@ -0,0 +1,33 @@
+.TH BTRFS-MAP-LOGICAL 8
+.SH NAME
+btrfs-map-logical \- map btrfs logical extent to physical extent
+.SH SYNOPSIS
+.B btrfs-map-logical [\fIoptions\fP] \fI<device>\fP
+.SH DESCRIPTION
+\fBbtrfs-map-logical\fP can be used to find out what the physical offsets are
+on the mirrors, the result is dumped into stdout in default.
+
+\fIOptions\fP
+.IP "\fB-l|--logical \fI<logical_num>\fP" 5
+Logical extent to map.
+.IP "\fB-c|--copy \fI<copy>\fP" 5
+Copy of the extent to read(usually 1 or 2).
+.IP "\fB-o|--output \fI<filename>\fP" 5
+Output file to hold the extent.
+.IP "\fB-b|--bytes \fI<bytes>\fP" 5
+Number of bytes to read.
+
+.SH EXIT CODE
+\fBbtrfs-map-logical\fP will return 0 if no error happened.
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
+.SH SEE ALSO
+.BR mkfs.btrfs (8)
-- 
1.8.0.1

