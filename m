Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38064 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753165Ab3HAFhC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Aug 2013 01:37:02 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r715avKR009257
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Aug 2013 13:36:58 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 04/10] Btrfs-progs: add man page information for btrfs-find-root
Date: Thu, 1 Aug 2013 13:35:28 +0800
Message-Id: <1375335334-32540-4-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1375335334-32540-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1375335334-32540-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 man/Makefile              |  2 +-
 man/btrfs-find-root.8.in  | 36 ++++++++++++++++++++++++++++++++++++
 man/btrfs-show-super.8.in |  4 ++--
 3 files changed, 39 insertions(+), 3 deletions(-)
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
index 0000000..b98cc53
--- /dev/null
+++ b/man/btrfs-find-root.8.in
@@ -0,0 +1,36 @@
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
+License GPLv3: GNU GPL version 3 <http://gnu.org/licenses/gpl.html>.
+.br
+This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
+.SH AVAILABILITY
+.B btrfs-find-root
+is part of btrfs-progs. Btrfs is currently under heavy development,
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+.SH SEE ALSO
+.BR mkfs.btrfs (8)
diff --git a/man/btrfs-show-super.8.in b/man/btrfs-show-super.8.in
index 6588d46..f7af33c 100644
--- a/man/btrfs-show-super.8.in
+++ b/man/btrfs-show-super.8.in
@@ -1,6 +1,6 @@
 .TH BTRFS-SHOW-SUPER 8
 .SH NAME
-btrfs-show-super \- show btrfs superblock information stored in devices
+btrfs-show-super \- show Btrfs superblock information stored in devices
 .SH SYNOPSIS
 .B btrfs-show-super [\fIoptions\fP] \fI<dev>\fP [\fI<dev>...\fP]
 .SH DESCRIPTION
@@ -23,7 +23,7 @@ Written by Shilong Wang and Wenruo Qu.
 
 .SH COPYRIGHT
 Copyright \(co 2013 Fujitsu, Inc.
-License GPLv2: GNU GPL version 2 <http://gnu.org/licenses/gpl.html>.
+License GPLv3: GNU GPL version 3 <http://gnu.org/licenses/gpl.html>.
 .br
 This is free software: you are free  to  change  and  redistribute  it. There is NO WARRANTY, to the extent permitted by law.
 .SH AVAILABILITY
-- 
1.8.0.1

