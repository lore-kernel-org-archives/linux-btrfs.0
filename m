From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Subject: [btrfs-progs 3/4] Add man/btrfsck.8.in and Makefile for man pages
Date: Tue, 13 Jan 2009 18:20:03 +0530
Message-ID: <20090113125003.GA15217@baloo.junglebook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Goldwyn Rodrigues <rgoldwyn@gmail.com>
---
 man/Makefile     |   27 +++++++++++++++++++++++++++
 man/btrfsck.8.in |   17 +++++++++++++++++
 2 files changed, 44 insertions(+), 0 deletions(-)
 create mode 100644 man/Makefile
 create mode 100644 man/btrfsck.8.in

diff --git a/man/Makefile b/man/Makefile
new file mode 100644
index 0000000..2665dd1
--- /dev/null
+++ b/man/Makefile
@@ -0,0 +1,27 @@
+GZIP=gzip
+INSTALL= install
+
+prefix ?= /usr/local
+bindir = $(prefix)/bin
+mandir = $(prefix)/man
+man8dir = $(mandir)/man8
+
+MANPAGES = mkfs.btrfs.8.gz btrfsctl.8.gz btrfsck.8.gz
+
+all: $(MANPAGES)
+
+mkfs.btrfs.8.gz: mkfs.btrfs.8.in
+	$(GZIP) -n -c mkfs.btrfs.8.in > mkfs.btrfs.8.gz
+
+btrfsctl.8.gz: btrfsctl.8.in
+	$(GZIP) -n -c btrfsctl.8.in > btrfsctl.8.gz
+
+btrfsck.8.gz: btrfsck.8.in
+	$(GZIP) -n -c btrfsck.8.in > btrfsck.8.gz
+
+clean :
+	rm -f $(MANPAGES)
+
+install: $(MANPAGES)
+	$(INSTALL) -m755 -d $(DESTDIR)$(man8dir)
+	$(INSTALL) -m 644 $(MANPAGES) $(DESTDIR)$(man8dir)
diff --git a/man/btrfsck.8.in b/man/btrfsck.8.in
new file mode 100644
index 0000000..63a0039
--- /dev/null
+++ b/man/btrfsck.8.in
@@ -0,0 +1,17 @@
+.TH BTRFSCK 8 
+.SH NAME
+btrfsck \- check a btrfs filesystem
+.SH SYNOPSIS
+.B btrfsck \fI device\fP
+.SH DESCRIPTION
+\fBbtrfsck\fP is used to check a btrfs filesystem.
+\fIdevice\fP is the device file where the filesystem is stored.
+.SH AVAILABILITY
+.B btrfsck
+is part of btrfs-progs. Btrfs is currently under heavy development, 
+and not suitable for for any uses other than benchmarking and review. 
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for 
+further details.
+.SH SEE ALSO
+.BR mkfs.btrfs (8)
+.BR btrfsctl (8)
-- 
1.6.0.2


-- 
Goldwyn
