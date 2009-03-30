From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] add btrfs-show man page
Date: Mon, 30 Mar 2009 22:04:50 +0800
Message-ID: <1238421890-18166-1-git-send-email-bergwolf@gmail.com>
Cc: Peng Tao <bergwolf@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

add man/btrfs-show.8.in

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 man/Makefile        |    6 +++++-
 man/btrfs-show.8.in |   19 +++++++++++++++++++
 2 files changed, 24 insertions(+), 1 deletions(-)
 create mode 100644 man/btrfs-show.8.in

diff --git a/man/Makefile b/man/Makefile
index b7a7340..4e8893b 100644
--- a/man/Makefile
+++ b/man/Makefile
@@ -6,7 +6,8 @@ bindir = $(prefix)/bin
 mandir = $(prefix)/man
 man8dir = $(mandir)/man8
 
-MANPAGES = mkfs.btrfs.8.gz btrfsctl.8.gz btrfsck.8.gz btrfs-image.8.gz
+MANPAGES = mkfs.btrfs.8.gz btrfsctl.8.gz btrfsck.8.gz btrfs-image.8.gz \
+	   btrfs-show.8.gz
 
 all: $(MANPAGES)
 
@@ -22,6 +23,9 @@ btrfsck.8.gz: btrfsck.8.in
 btrfs-image.8.gz: btrfs-image.8.in
 	$(GZIP) -n -c btrfs-image.8.in > btrfs-image.8.gz
 
+btrfs-show.8.gz: btrfs-show.8.in
+	$(GZIP) -n -c btrfs-show.8.in > btrfs-show.8.gz
+
 clean :
 	rm -f $(MANPAGES)
 
diff --git a/man/btrfs-show.8.in b/man/btrfs-show.8.in
new file mode 100644
index 0000000..cd341fc
--- /dev/null
+++ b/man/btrfs-show.8.in
@@ -0,0 +1,19 @@
+.TH MKFS.BTRFS 8
+.SH NAME
+btrfs-show \- scan the /dev directory for btrfs partitions and print results.
+.SH SYNOPSIS
+.B btrfs-show
+.SH DESCRIPTION
+.B btrfs-show
+is used to scan the /dev directory for btrfs partitions and display brief
+information such as lable, uuid, etc of each btrfs partition.
+.SH OPTIONS
+none
+.SH AVAILABILITY
+.B btrfs-show
+is part of btrfs-progs. Btrfs is currently under heavy development,
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki
+http://btrfs.wiki.kernel.org for further details.
+.SH SEE ALSO
+.BR btrfsck (8), btrfsctl (8), mkfs.btrfs (8), btrfs-image (8)
-- 
1.6.2-rc2.GIT

