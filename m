From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] add btrfs-image man page
Date: Mon, 30 Mar 2009 21:43:52 +0800
Message-ID: <1238420632-17695-1-git-send-email-bergwolf@gmail.com>
Cc: Peng Tao <bergwolf@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

add man/btrfs-image.8.in

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 man/Makefile         |    5 ++++-
 man/btrfs-image.8.in |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 1 deletions(-)
 create mode 100644 man/btrfs-image.8.in

diff --git a/man/Makefile b/man/Makefile
index 2665dd1..b7a7340 100644
--- a/man/Makefile
+++ b/man/Makefile
@@ -6,7 +6,7 @@ bindir = $(prefix)/bin
 mandir = $(prefix)/man
 man8dir = $(mandir)/man8
 
-MANPAGES = mkfs.btrfs.8.gz btrfsctl.8.gz btrfsck.8.gz
+MANPAGES = mkfs.btrfs.8.gz btrfsctl.8.gz btrfsck.8.gz btrfs-image.8.gz
 
 all: $(MANPAGES)
 
@@ -19,6 +19,9 @@ btrfsctl.8.gz: btrfsctl.8.in
 btrfsck.8.gz: btrfsck.8.in
 	$(GZIP) -n -c btrfsck.8.in > btrfsck.8.gz
 
+btrfs-image.8.gz: btrfs-image.8.in
+	$(GZIP) -n -c btrfs-image.8.in > btrfs-image.8.gz
+
 clean :
 	rm -f $(MANPAGES)
 
diff --git a/man/btrfs-image.8.in b/man/btrfs-image.8.in
new file mode 100644
index 0000000..722c433
--- /dev/null
+++ b/man/btrfs-image.8.in
@@ -0,0 +1,34 @@
+.TH MKFS.BTRFS 8
+.SH NAME
+btrfs-image \- create/restore an image of the filesystem
+.SH SYNOPSIS
+.B btrfs-image
+[options] \fIsource\fP \fItarget\fP
+.SH DESCRIPTION
+.B btrfs-image
+is used to create an image of a btrfs filesystem. All data will be zeroed,
+but metadata and the like is preserved.
+.I source
+is the special file corresponding to the device containing a btrfs filesystem.
+(e.g \fI/dev/sdXX\fP).
+.I target
+is the image file that btrfs-image creates. When used with \fB-r\fP option,
+\fBbtrfs-image\fP restores the image file from source into target.
+.SH OPTIONS
+.TP
+\fB\-r\fP
+restore metadump image.
+.TP
+\fB\-c\fR \fIvalue\fP
+compression level (0 ~ 9).
+.TP
+\fB\-t\fR \fIvalue\fP
+number of threads (1 ~ 32) to be used to process the image dump or restore.
+.SH AVAILABILITY
+.B btrfs-image
+is part of btrfs-progs. Btrfs is currently under heavy development,
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki
+http://btrfs.wiki.kernel.org for further details.
+.SH SEE ALSO
+.BR btrfsck (8), btrfsctl (8), mkfs.btrfs (8)
-- 
1.6.2-rc2.GIT

