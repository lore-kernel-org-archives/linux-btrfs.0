Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56462 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab3HNEbf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 00:31:35 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 4/8] Btrfs-progs: add man page information for btrfs-find-root
Date: Wed, 14 Aug 2013 12:29:13 +0800
Message-Id: <1376454557-3041-4-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1376454557-3041-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1376454557-3041-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2->v3: remove 'AVAILIABLE' parts
v1->v2: GPLv3->GPLv2
---
 man/Makefile             |  2 +-
 man/btrfs-find-root.8.in | 30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)
 create mode 100644 man/btrfs-find-root.8.in

diff --git a/man/Makefile b/man/Makefile
index b1d3645..3d2e3ba 100644
--- a/man/Makefile
+++ b/man/Makefile
@@ -12,7 +12,7 @@ man8dir = $(mandir)/man8
 .SUFFIXES: .in .gz
 
 MANPAGES = mkfs.btrfs.8.gz btrfsck.8.gz btrfs-image.8.gz btrfs.8.gz \
-	   btrfs-debug-tree.8.gz btrfs-show-super.8.gz
+	   btrfs-debug-tree.8.gz btrfs-show-super.8.gz btrfs-find-root.8.gz
 INFILES = ${MANPAGES:.in=.gz}
 
 all: $(MANPAGES)
diff --git a/man/btrfs-find-root.8.in b/man/btrfs-find-root.8.in
new file mode 100644
index 0000000..398aa41
--- /dev/null
+++ b/man/btrfs-find-root.8.in
@@ -0,0 +1,30 @@
+.TH BTRFS-FIND-ROOT 8
+.SH NAME
+btrfs-find-root \- filter to find btrfs root.
+.SH SYNOPSIS
+.B btrfs-find-root [\fIoptions\fP] \fI<dev>\fP
+.SH DESCRIPTION
+\fBbtrfs-find-root\fP is used to find the satisfied root, you can filter by root tree's objectid, generation, level.
+
+\fIOptions\fP
+.IP "\fB-g \fI<generation>\fP" 5
+filter root tree by it's original transaction id, tree root's generation in default.
+.IP "\fB-o \fI<objectid>\fP" 5
+filter root tree by it's objectid,tree root's objectid in default.
+.IP "\fB-l \fI<level>\fP" 5
+filter root tree by B-+ tree's level, level 0 in default.
+
+.SH EXIT CODE
+\fBbtrfs-find-root\fP will return 0 if no error happened.
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

