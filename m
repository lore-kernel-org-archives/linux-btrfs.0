Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64482 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756986Ab3HGFz7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Aug 2013 01:55:59 -0400
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [v2 2/8] Btrfs-progs: add missing man information for btrfs-debug-tree
Date: Wed, 7 Aug 2013 13:54:03 +0800
Message-Id: <1375854849-15224-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1375854849-15224-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1375854849-15224-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
V1->V2: GPLv3->GPLv2
---
 btrfs-debug-tree.c        |  2 +-
 man/Makefile              |  3 ++-
 man/btrfs-debug-tree.8.in | 41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 2 deletions(-)
 create mode 100644 man/btrfs-debug-tree.8.in

diff --git a/btrfs-debug-tree.c b/btrfs-debug-tree.c
index bae7f94..dc912f1 100644
--- a/btrfs-debug-tree.c
+++ b/btrfs-debug-tree.c
@@ -195,7 +195,7 @@ int main(int ac, char **av)
 		if (!leaf) {
 			fprintf(stderr, "failed to read %llu\n",
 				(unsigned long long)block_only);
-			return 0;
+			exit(1);
 		}
 		btrfs_print_tree(root, leaf, 0);
 		return 0;
diff --git a/man/Makefile b/man/Makefile
index 1ba23b5..e5c1f7c 100644
--- a/man/Makefile
+++ b/man/Makefile
@@ -11,7 +11,8 @@ man8dir = $(mandir)/man8
 # list only those we use
 .SUFFIXES: .in .gz
 
-MANPAGES = mkfs.btrfs.8.gz btrfsck.8.gz btrfs-image.8.gz btrfs.8.gz
+MANPAGES = mkfs.btrfs.8.gz btrfsck.8.gz btrfs-image.8.gz btrfs.8.gz \
+	   btrfs-debug-tree.8.gz
 INFILES = ${MANPAGES:.in=.gz}
 
 all: $(MANPAGES)
diff --git a/man/btrfs-debug-tree.8.in b/man/btrfs-debug-tree.8.in
new file mode 100644
index 0000000..281fe98
--- /dev/null
+++ b/man/btrfs-debug-tree.8.in
@@ -0,0 +1,41 @@
+.TH BTRFS-DEBUG-TREE 8
+.SH NAME
+btrfs-debug-tree \- dump Btrfs filesystem metadata into stdout.
+.SH SYNOPSIS
+.B btrfs-debug-tree [\fIoptions\fP] \fI<device>\fP
+.SH DESCRIPTION
+\fBbtrfs-debug-tree\fP is used to dump the whole tree of the given device.
+This is maybe useful for analyzing filesystem state or inconsistence and has
+a positive educational effect on understanding the internal structure.
+\fIdevice\fP is the device file where the filesystem is stored.
+
+\fIOptions\fP
+.IP "\fB-e\fP" 5
+print detailed extents info.
+.IP "\fB-d\fP" 5
+print info of btrfs device and root tree dirs only.
+.IP "\fB-r\fP" 5
+print info of roots only.
+.IP "\fB-b \fI<block_num>\fP" 5
+print info of the specified block only.
+
+.SH EXIT CODE
+\fBbtrfs-debug-tree\fP will return 0 if no error happened.
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
+.B btrfs-debug-tree
+is part of btrfs-progs. Btrfs is currently under heavy development,
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+.SH SEE ALSO
+.BR mkfs.btrfs (8)
-- 
1.8.0.1

