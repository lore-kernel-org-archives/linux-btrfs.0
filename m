Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56462 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab3HNEb1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 00:31:27 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 5/8] Btrfs-progs: add man page information for btrfs-convert
Date: Wed, 14 Aug 2013 12:29:14 +0800
Message-Id: <1376454557-3041-5-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
 man/Makefile           |  3 ++-
 man/btrfs-convert.8.in | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 1 deletion(-)
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
index 0000000..9d4c642
--- /dev/null
+++ b/man/btrfs-convert.8.in
@@ -0,0 +1,33 @@
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
+License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
+.br
+This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
+
+.SH SEE ALSO
+.BR mkfs.btrfs (8)
-- 
1.8.0.1

