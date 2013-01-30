Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42757 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757231Ab3A3Wuf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 17:50:35 -0500
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, Anand.Jain@oracle.com, aschnell@suse.de,
        jeffm@suse.com, Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 5/5] btrfs-progs: use autotools for building
Date: Wed, 30 Jan 2013 14:50:27 -0800
Message-Id: <1359586227-19762-6-git-send-email-mfasheh@suse.de>
In-Reply-To: <1359586227-19762-1-git-send-email-mfasheh@suse.de>
References: <1359586227-19762-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Since we're building shared libraries now, let's not reinvent the wheel.
This also makes packaging libbtrfs much easier. The following (empty) files
are added to satisfy autoconf: AUTHORS ChangeLog NEWS INSTALL.

Changes by Mark Fasheh:
- Fixes to make this patch work with upstream
- I moved the previous contents of INSTALL to README since that seems
  to make more sense now)

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 INSTALL              |   59 --------
 Makefile             |  146 --------------------
 Makefile.am          |   53 ++++++++
 README               |   59 ++++++++
 autogen.sh           |    5 +
 configure.ac         |    6 +
 man/Makefile         |   37 -----
 man/Makefile.am      |    2 +
 man/btrfs-image.8    |   34 +++++
 man/btrfs-image.8.in |   34 -----
 man/btrfs-show.8     |   22 +++
 man/btrfs-show.8.in  |   22 ---
 man/btrfs.8          |  365 ++++++++++++++++++++++++++++++++++++++++++++++++++
 man/btrfs.8.in       |  365 --------------------------------------------------
 man/btrfsck.8        |   17 +++
 man/btrfsck.8.in     |   17 ---
 man/btrfsctl.8       |   48 +++++++
 man/btrfsctl.8.in    |   48 -------
 man/mkfs.btrfs.8     |   79 +++++++++++
 man/mkfs.btrfs.8.in  |   79 -----------
 20 files changed, 690 insertions(+), 807 deletions(-)
 create mode 100644 AUTHORS
 create mode 100644 ChangeLog
 delete mode 100644 Makefile
 create mode 100644 Makefile.am
 create mode 100644 NEWS
 create mode 100644 README
 create mode 100755 autogen.sh
 create mode 100644 configure.ac
 delete mode 100644 man/Makefile
 create mode 100644 man/Makefile.am
 create mode 100644 man/btrfs-image.8
 delete mode 100644 man/btrfs-image.8.in
 create mode 100644 man/btrfs-show.8
 delete mode 100644 man/btrfs-show.8.in
 create mode 100644 man/btrfs.8
 delete mode 100644 man/btrfs.8.in
 create mode 100644 man/btrfsck.8
 delete mode 100644 man/btrfsck.8.in
 create mode 100644 man/btrfsctl.8
 delete mode 100644 man/btrfsctl.8.in
 create mode 100644 man/mkfs.btrfs.8
 delete mode 100644 man/mkfs.btrfs.8.in

diff --git a/AUTHORS b/AUTHORS
new file mode 100644
index 0000000..e69de29
diff --git a/ChangeLog b/ChangeLog
new file mode 100644
index 0000000..e69de29
diff --git a/INSTALL b/INSTALL
index 6afbd90..e69de29 100644
--- a/INSTALL
+++ b/INSTALL
@@ -1,59 +0,0 @@
-Install Instructions
-
-Btrfs puts snapshots and subvolumes into the root directory of the FS.  This
-directory can only be changed by btrfsctl right now, and normal filesystem
-operations do not work on it.  The default subvolume is called 'default',
-and you can create files and directories in mount_point/default
-
-Btrfs uses libcrc32c in the kernel for file and metadata checksums.  You need
-to compile the kernel with:
-
-CONFIG_LIBCRC32C=m
-
-libcrc32c can be static as well.  Once your kernel is setup, typing make in the
-btrfs module sources will build against the running kernel.  When the build is
-complete:
-
-modprobe libcrc32c
-insmod btrfs.ko
-
-The Btrfs utility programs require libuuid to build.  This can be found
-in the e2fsprogs sources, and is usually available as libuuid or
-e2fsprogs-devel from various distros.
-
-Building the utilities is just make ; make install.  The programs go
-into /usr/local/bin.  The mains commands available are:
-
-mkfs.btrfs: create a filesystem
-
-btrfs: control program to create snapshots and subvolumes:
-	# mount a btrfs filesystem
-	mount /dev/sda2 /mnt
-
-	# create a subvolume
-	btrfs subvolume create /mnt/new_subvol_name
-
-	# snapshot of a subvolume
-	btrfs subvolume snapshot /mnt/default /mnt/snapshot_of_default 
-	btrfs subvolume snapshot /mnt/snapshot_of_default \
-		/mnt/snapshot_of_a_snapshot
-
-	# list of the subvolumes
-	ls /mnt
-	default snapshot_of_a_snapshot snapshot_of_new_subvol
-	new_subvol_name snapshot_of_default
-
-	# removal of a subvolume or a snapshot
-	btrfs subvolume delete /mn/snapshot_of_a_snapshot
-
-	# look a the btrfs man page for further information
-	man btrfs
-
-btrfsck: do a limited check of the FS extent trees.</li>
-
-btrfs-debug-tree: print all of the FS metadata in text form.  Example:
-
-	btrfs-debug-tree /dev/sda2 >& big_output_file
-
-
-
diff --git a/Makefile b/Makefile
deleted file mode 100644
index 27d62c0..0000000
--- a/Makefile
+++ /dev/null
@@ -1,146 +0,0 @@
-CC = gcc
-AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 -DBTRFS_FLAT_INCLUDES -fPIC
-CFLAGS = -g -O1
-objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
-	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
-	  extent-cache.o extent_io.o volumes.o utils.o btrfslabel.o repair.o \
-	  qgroup.o
-cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
-	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
-	       cmds-quota.o cmds-qgroup.o
-libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o
-libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
-	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
-	       extent_io.h ioctl.h ctree.h
-
-CHECKFLAGS= -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise \
-	    -Wuninitialized -Wshadow -Wundef
-DEPFLAGS = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
-
-INSTALL = install
-prefix ?= /usr/local
-bindir = $(prefix)/bin
-libdir = $(prefix)/lib
-incdir = $(prefix)/include/btrfs
-lib_LIBS=-luuid -lm -L.
-LIBS=$(lib_LIBS) -lbtrfs
-RESTORE_LIBS=-lz
-
-progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
-	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
-	btrfs-find-root btrfs-restore btrfstune
-
-libs = libbtrfs.so.1.0
-lib_links = libbtrfs.so.1 libbtrfs.so
-headers = $(libbtrfs_headers)
-
-# make C=1 to enable sparse
-ifdef C
-	check = sparse $(CHECKFLAGS)
-else
-	check = ls
-endif
-
-.c.o:
-	$(check) $<
-	$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
-
-
-all: version $(libs) $(progs) manpages
-
-version:
-	bash version.sh
-
-$(libs): $(libbtrfs_objects) $(lib_links) send.h
-	$(CC) $(CFLAGS) $(libbtrfs_objects) $(lib_LIBS) -shared -Wl,-soname,libbtrfs.so.1 -o libbtrfs.so.1.0
-
-$(lib_links):
-	ln -sf libbtrfs.so.1.0 libbtrfs.so.1
-	ln -sf libbtrfs.so.1.0 libbtrfs.so
-
-btrfs: $(objects) btrfs.o help.o common.o $(cmds_objects) $(libs)
-	$(CC) $(CFLAGS) -o btrfs btrfs.o help.o common.o $(cmds_objects) \
-		$(objects) $(LDFLAGS) $(LIBS) -lpthread
-
-calc-size: $(objects) $(libs) calc-size.o
-	$(CC) $(CFLAGS) -o calc-size calc-size.o $(objects) $(LDFLAGS) $(LIBS)
-
-btrfs-find-root: $(objects) $(libs) find-root.o
-	$(CC) $(CFLAGS) -o btrfs-find-root find-root.o $(objects) $(LDFLAGS) $(LIBS)
-
-btrfs-restore: $(objects) $(libs) restore.o
-	$(CC) $(CFLAGS) -o btrfs-restore restore.o $(objects) $(LDFLAGS) $(LIBS) $(RESTORE_LIBS)
-
-btrfsctl: $(objects) $(libs) btrfsctl.o
-	$(CC) $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
-
-btrfs-vol: $(objects) $(libs) btrfs-vol.o
-	$(CC) $(CFLAGS) -o btrfs-vol btrfs-vol.o $(objects) $(LDFLAGS) $(LIBS)
-
-btrfs-show: $(objects) $(libs) btrfs-show.o
-	$(CC) $(CFLAGS) -o btrfs-show btrfs-show.o $(objects) $(LDFLAGS) $(LIBS)
-
-btrfsck: $(objects) $(libs) btrfsck.o
-	$(CC) $(CFLAGS) -o btrfsck btrfsck.o $(objects) $(LDFLAGS) $(LIBS)
-
-mkfs.btrfs: $(objects) $(libs) mkfs.o
-	$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
-
-btrfs-debug-tree: $(objects) $(libs) debug-tree.o
-	$(CC) $(CFLAGS) -o btrfs-debug-tree $(objects) debug-tree.o $(LDFLAGS) $(LIBS)
-
-btrfs-zero-log: $(objects) $(libs) btrfs-zero-log.o
-	$(CC) $(CFLAGS) -o btrfs-zero-log $(objects) btrfs-zero-log.o $(LDFLAGS) $(LIBS)
-
-btrfs-select-super: $(objects) $(libs) btrfs-select-super.o
-	$(CC) $(CFLAGS) -o btrfs-select-super $(objects) btrfs-select-super.o $(LDFLAGS) $(LIBS)
-
-btrfstune: $(objects) $(libs) btrfstune.o
-	$(CC) $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
-
-btrfs-map-logical: $(objects) $(libs) btrfs-map-logical.o
-	$(CC) $(CFLAGS) -o btrfs-map-logical $(objects) btrfs-map-logical.o $(LDFLAGS) $(LIBS)
-
-btrfs-corrupt-block: $(objects) $(libs) btrfs-corrupt-block.o
-	$(CC) $(CFLAGS) -o btrfs-corrupt-block $(objects) btrfs-corrupt-block.o $(LDFLAGS) $(LIBS)
-
-btrfs-image: $(objects) $(libs) btrfs-image.o
-	$(CC) $(CFLAGS) -o btrfs-image $(objects) btrfs-image.o -lpthread -lz $(LDFLAGS) $(LIBS)
-
-dir-test: $(objects) $(libs) dir-test.o
-	$(CC) $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
-
-quick-test: $(objects) $(libs) quick-test.o
-	$(CC) $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
-
-btrfs-convert: $(objects) $(libs) convert.o
-	$(CC) $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs -lcom_err $(LDFLAGS) $(LIBS)
-
-ioctl-test: $(objects) $(libs) ioctl-test.o
-	$(CC) $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)
-
-send-test: $(objects) send-test.o
-	$(CC) $(CFLAGS) -o send-test send-test.o $(LDFLAGS) $(LIBS) -lpthread
-
-manpages:
-	cd man; $(MAKE)
-
-install-man:
-	cd man; $(MAKE) install
-
-clean :
-	rm -f $(progs) $(libs) cscope.out *.o .*.d btrfs-convert btrfs-image \
-	      btrfs-select-super btrfs-zero-log btrfstune dir-test ioctl-test \
-	      quick-test send-test version.h
-	cd man; $(MAKE) clean
-
-install: $(libs) $(progs) install-man
-	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
-	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
-	$(INSTALL) -m755 -d $(DESTDIR)$(libdir)
-	$(INSTALL) $(libs) $(DESTDIR)$(libdir)
-	cp -a $(lib_links) $(DESTDIR)$(libdir)
-	$(INSTALL) -m755 -d $(DESTDIR)$(incdir)
-	$(INSTALL) $(headers) $(DESTDIR)$(incdir)
-
--include .*.d
diff --git a/Makefile.am b/Makefile.am
new file mode 100644
index 0000000..0a25838
--- /dev/null
+++ b/Makefile.am
@@ -0,0 +1,53 @@
+SUBDIRS = man
+
+AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 \
+	    -DBTRFS_FLAT_INCLUDES
+
+version.h : version.sh
+	sh $(top_srcdir)/version.sh
+
+noinst_LTLIBRARIES = libbtrfs_static.la
+lib_LTLIBRARIES = libbtrfs.la
+libbtrfs_la_SOURCES = send-stream.c send-utils.c rbtree.c btrfs-list.c crc32c.c
+libbtrfs_la_LDFLAGS = -version-info 0:1:0
+libbtrfs_static_la_SOURCES = $(libbtrfs_la_SOURCES)
+
+noinst_LTLIBRARIES += libbtrfscore.la
+libbtrfscore_la_SOURCES = ctree.c disk-io.c radix-tree.c extent-tree.c \
+			  print-tree.c root-tree.c dir-item.c file-item.c \
+			  inode-item.c inode-map.c extent-cache.c extent_io.c \
+			  volumes.c utils.c btrfslabel.c repair.c qgroup.c
+
+CMDS = cmds-subvolume.c cmds-filesystem.c cmds-device.c cmds-scrub.c \
+       cmds-inspect.c cmds-balance.c cmds-send.c cmds-receive.c \
+       cmds-quota.c cmds-qgroup.c
+
+sbin_PROGRAMS = mkfs.btrfs btrfs-debug-tree btrfsck btrfs btrfs-image \
+		btrfs-zero-log btrfs-find-root btrfs-restore btrfstune \
+		btrfs-select-super btrfs-convert
+bin_PROGRAMS = btrfsctl btrfs-show btrfs-vol btrfs-map-logical
+noinst_PROGRAMS = send-test
+
+LDADD = libbtrfscore.la libbtrfs_static.la -luuid -lm
+
+libbtrfsdir = $(includedir)/btrfs
+libbtrfs_HEADERS = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
+		  crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
+		  extent_io.h ioctl.h ctree.h
+
+btrfs_SOURCES = btrfs.c help.c common.c $(CMDS)
+btrfs_LDADD = -lpthread $(LDADD)
+btrfs_debug_tree_SOURCES = debug-tree.c
+
+btrfs_convert_SOURCES = convert.c
+btrfs_convert_LDADD = -lext2fs -lcom_err $(LDADD)
+
+btrfs_restore_SOURCES = restore.c
+btrfs_restore_LDADD = -lz $(LDADD)
+
+btrfs_find_root_SOURCES = find-root.c
+
+btrfs_image_LDADD = -lpthread -lz $(LDADD)
+
+send_test_LDADD = -lpthread $(LDADD)
+
diff --git a/NEWS b/NEWS
new file mode 100644
index 0000000..e69de29
diff --git a/README b/README
new file mode 100644
index 0000000..292350b
--- /dev/null
+++ b/README
@@ -0,0 +1,59 @@
+Usage Instructions
+
+Btrfs puts snapshots and subvolumes into the root directory of the FS.  This
+directory can only be changed by btrfsctl right now, and normal filesystem
+operations do not work on it.  The default subvolume is called 'default',
+and you can create files and directories in mount_point/default
+
+Btrfs uses libcrc32c in the kernel for file and metadata checksums.  You need
+to compile the kernel with:
+
+CONFIG_LIBCRC32C=m
+
+libcrc32c can be static as well.  Once your kernel is setup, typing make in the
+btrfs module sources will build against the running kernel.  When the build is
+complete:
+
+modprobe libcrc32c
+insmod btrfs.ko
+
+The Btrfs utility programs require libuuid to build.  This can be found
+in the e2fsprogs sources, and is usually available as libuuid or
+e2fsprogs-devel from various distros.
+
+Building the utilities is just ./autogen.sh ; make ; make install.
+The main commands available are:
+
+mkfs.btrfs: create a filesystem
+
+btrfs: control program to create snapshots and subvolumes:
+	# mount a btrfs filesystem
+	mount /dev/sda2 /mnt
+
+	# create a subvolume
+	btrfs subvolume create /mnt/new_subvol_name
+
+	# snapshot of a subvolume
+	btrfs subvolume snapshot /mnt/default /mnt/snapshot_of_default 
+	btrfs subvolume snapshot /mnt/snapshot_of_default \
+		/mnt/snapshot_of_a_snapshot
+
+	# list of the subvolumes
+	ls /mnt
+	default snapshot_of_a_snapshot snapshot_of_new_subvol
+	new_subvol_name snapshot_of_default
+
+	# removal of a subvolume or a snapshot
+	btrfs subvolume delete /mn/snapshot_of_a_snapshot
+
+	# look a the btrfs man page for further information
+	man btrfs
+
+btrfsck: do a limited check of the FS extent trees.</li>
+
+btrfs-debug-tree: print all of the FS metadata in text form.  Example:
+
+	btrfs-debug-tree /dev/sda2 >& big_output_file
+
+
+
diff --git a/autogen.sh b/autogen.sh
new file mode 100755
index 0000000..154cd1c
--- /dev/null
+++ b/autogen.sh
@@ -0,0 +1,5 @@
+#!/bin/sh
+
+rm -fr aclocal.m4 autom4te.cache/
+autoreconf -iv
+./configure
diff --git a/configure.ac b/configure.ac
new file mode 100644
index 0000000..080b7f4
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,6 @@
+AC_INIT([btrfsprogs], [0.20])
+AM_INIT_AUTOMAKE([1.9])
+
+AC_PROG_LIBTOOL
+AC_PROG_CC
+AC_OUTPUT([Makefile man/Makefile])
diff --git a/man/Makefile b/man/Makefile
deleted file mode 100644
index 4a90b75..0000000
--- a/man/Makefile
+++ /dev/null
@@ -1,37 +0,0 @@
-GZIP=gzip
-INSTALL= install
-
-prefix ?= /usr/local
-bindir = $(prefix)/bin
-mandir = $(prefix)/man
-man8dir = $(mandir)/man8
-
-MANPAGES = mkfs.btrfs.8.gz btrfsctl.8.gz btrfsck.8.gz btrfs-image.8.gz \
-	   btrfs-show.8.gz btrfs.8.gz
-
-all: $(MANPAGES)
-
-mkfs.btrfs.8.gz: mkfs.btrfs.8.in
-	$(GZIP) -n -c mkfs.btrfs.8.in > mkfs.btrfs.8.gz
-
-btrfs.8.gz: btrfs.8.in
-	$(GZIP) -n -c btrfs.8.in > btrfs.8.gz
-
-btrfsctl.8.gz: btrfsctl.8.in
-	$(GZIP) -n -c btrfsctl.8.in > btrfsctl.8.gz
-
-btrfsck.8.gz: btrfsck.8.in
-	$(GZIP) -n -c btrfsck.8.in > btrfsck.8.gz
-
-btrfs-image.8.gz: btrfs-image.8.in
-	$(GZIP) -n -c btrfs-image.8.in > btrfs-image.8.gz
-
-btrfs-show.8.gz: btrfs-show.8.in
-	$(GZIP) -n -c btrfs-show.8.in > btrfs-show.8.gz
-
-clean :
-	rm -f $(MANPAGES)
-
-install: $(MANPAGES)
-	$(INSTALL) -m755 -d $(DESTDIR)$(man8dir)
-	$(INSTALL) -m 644 $(MANPAGES) $(DESTDIR)$(man8dir)
diff --git a/man/Makefile.am b/man/Makefile.am
new file mode 100644
index 0000000..a6e6c9d
--- /dev/null
+++ b/man/Makefile.am
@@ -0,0 +1,2 @@
+man8_MANS = btrfs.8 btrfsck.8 btrfsctl.8 btrfs-image.8 \
+	    btrfs-show.8 mkfs.btrfs.8
diff --git a/man/btrfs-image.8 b/man/btrfs-image.8
new file mode 100644
index 0000000..7a348f8
--- /dev/null
+++ b/man/btrfs-image.8
@@ -0,0 +1,34 @@
+.TH BTRFS-IMAGE 8
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
diff --git a/man/btrfs-image.8.in b/man/btrfs-image.8.in
deleted file mode 100644
index 7a348f8..0000000
--- a/man/btrfs-image.8.in
+++ /dev/null
@@ -1,34 +0,0 @@
-.TH BTRFS-IMAGE 8
-.SH NAME
-btrfs-image \- create/restore an image of the filesystem
-.SH SYNOPSIS
-.B btrfs-image
-[options] \fIsource\fP \fItarget\fP
-.SH DESCRIPTION
-.B btrfs-image
-is used to create an image of a btrfs filesystem. All data will be zeroed,
-but metadata and the like is preserved.
-.I source
-is the special file corresponding to the device containing a btrfs filesystem.
-(e.g \fI/dev/sdXX\fP).
-.I target
-is the image file that btrfs-image creates. When used with \fB-r\fP option,
-\fBbtrfs-image\fP restores the image file from source into target.
-.SH OPTIONS
-.TP
-\fB\-r\fP
-restore metadump image.
-.TP
-\fB\-c\fR \fIvalue\fP
-compression level (0 ~ 9).
-.TP
-\fB\-t\fR \fIvalue\fP
-number of threads (1 ~ 32) to be used to process the image dump or restore.
-.SH AVAILABILITY
-.B btrfs-image
-is part of btrfs-progs. Btrfs is currently under heavy development,
-and not suitable for any uses other than benchmarking and review.
-Please refer to the btrfs wiki
-http://btrfs.wiki.kernel.org for further details.
-.SH SEE ALSO
-.BR btrfsck (8), btrfsctl (8), mkfs.btrfs (8)
diff --git a/man/btrfs-show.8 b/man/btrfs-show.8
new file mode 100644
index 0000000..cb98b68
--- /dev/null
+++ b/man/btrfs-show.8
@@ -0,0 +1,22 @@
+.TH BTRFS-SHOW 8
+.SH NAME
+btrfs-show \- scan the /dev directory for btrfs partitions and print results.
+.SH SYNOPSIS
+.B btrfs-show
+.SH NOTE
+.B btrfs-show
+is deprecated. Please consider to switch to the btrfs utility.	
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
diff --git a/man/btrfs-show.8.in b/man/btrfs-show.8.in
deleted file mode 100644
index cb98b68..0000000
--- a/man/btrfs-show.8.in
+++ /dev/null
@@ -1,22 +0,0 @@
-.TH BTRFS-SHOW 8
-.SH NAME
-btrfs-show \- scan the /dev directory for btrfs partitions and print results.
-.SH SYNOPSIS
-.B btrfs-show
-.SH NOTE
-.B btrfs-show
-is deprecated. Please consider to switch to the btrfs utility.	
-.SH DESCRIPTION
-.B btrfs-show
-is used to scan the /dev directory for btrfs partitions and display brief
-information such as lable, uuid, etc of each btrfs partition.
-.SH OPTIONS
-none
-.SH AVAILABILITY
-.B btrfs-show
-is part of btrfs-progs. Btrfs is currently under heavy development,
-and not suitable for any uses other than benchmarking and review.
-Please refer to the btrfs wiki
-http://btrfs.wiki.kernel.org for further details.
-.SH SEE ALSO
-.BR btrfsck (8), btrfsctl (8), mkfs.btrfs (8), btrfs-image (8)
diff --git a/man/btrfs.8 b/man/btrfs.8
new file mode 100644
index 0000000..9222580
--- /dev/null
+++ b/man/btrfs.8
@@ -0,0 +1,365 @@
+.TH BTRFS 8 "" "btrfs" "btrfs"
+.\"
+.\" Man page written by Goffredo Baroncelli <kreijack@inwind.it> (Feb 2010)
+.\"
+.SH NAME
+btrfs \- control a btrfs filesystem
+.SH SYNOPSIS
+\fBbtrfs\fP \fBsubvolume snapshot\fP\fI [-r] <source> [<dest>/]<name>\fP
+.PP
+\fBbtrfs\fP \fBsubvolume delete\fP\fI <subvolume> [<subvolume>...]\fP
+.PP
+\fBbtrfs\fP \fBsubvolume create\fP\fI [<dest>/]<name>\fP
+.PP
+\fBbtrfs\fP \fBsubvolume list\fP\fI [-aprts] [-g [+|-]value] [-c [+|-]value] [--rootid=rootid,gen,ogen,path] <path>\fP
+.PP
+\fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
+.PP
+\fBbtrfs\fP \fBsubvolume get-default\fP\fI <path>\fP
+.PP
+\fBbtrfs\fP \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] \
+[-s \fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> \
+[<\fIfile\fR>|<\fIdir\fR>...]
+.PP
+\fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
+.PP
+\fBbtrfs\fP \fBfilesystem resize\fP\fI [devid:][+/\-]<size>[gkm]|[devid:]max <filesystem>\fP
+.PP
+\fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
+.PP
+\fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
+.PP
+\fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
+.PP
+\fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|<device> [<device>...]]\fP
+.PP
+\fBbtrfs\fP \fBdevice show\fP\fI [--all-devices|<uuid>|<label>]\fP
+.PP
+\fBbtrfs\fP \fBdevice add\fP\fI <device> [<device>...] <path> \fP
+.PP
+\fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP
+.PP
+\fBbtrfs\fP \fBscrub start\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
+.PP
+\fBbtrfs\fP \fBscrub cancel\fP {\fI<path>\fP|\fI<device>\fP}
+.PP
+\fBbtrfs\fP \fBscrub resume\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
+.PP
+\fBbtrfs\fP \fBscrub status\fP [-d] {\fI<path>\fP|\fI<device>\fP}
+.PP
+\fBbtrfs\fP \fBinspect-internal inode-resolve\fP [-v] \fI<inode>\fP \fI<path>\fP
+.PP
+\fBbtrfs\fP \fBinspect-internal logical-resolve\fP
+[-Pv] [-s size] \fI<logical>\fP \fI<path>\fP
+.PP
+\fBbtrfs\fP \fBhelp|\-\-help|\-h \fP\fI\fP
+.PP
+\fBbtrfs\fP \fB<command> \-\-help \fP\fI\fP
+.PP
+.SH DESCRIPTION
+.B btrfs
+is used to control the filesystem and the files and directories stored. It is
+the tool to create or destroy a snapshot or a subvolume for the
+filesystem, to defrag a file or a directory, flush the data to the disk,
+to resize the filesystem, to scan the device.
+
+It is possible to abbreviate the commands unless the commands  are ambiguous.
+For example: it is possible to run
+.I btrfs sub snaps
+instead of
+.I btrfs subvolume snapshot.
+But
+.I btrfs file s
+is not allowed, because
+.I file s
+may be interpreted both as
+.I filesystem show
+and as
+.I filesystem sync.
+In this case
+.I btrfs
+returns filesystem sync
+If a command is terminated by
+.I --help
+, the detailed help is showed. If the passed command matches more commands,
+detailed help of all the matched commands is showed. For example
+.I btrfs dev --help
+shows the help of all
+.I device*
+commands.
+
+.SH COMMANDS
+.TP
+
+\fBsubvolume snapshot\fR\fI [-r] <source> [<dest>/]<name>\fR
+Create a writable/readonly snapshot of the subvolume \fI<source>\fR with the
+name \fI<name>\fR in the \fI<dest>\fR directory. If \fI<source>\fR is not a
+subvolume, \fBbtrfs\fR returns an error. If \fI-r\fR is given, the snapshot
+will be readonly.
+.TP
+
+\fBsubvolume delete\fR\fI <subvolume> [<subvolume>...]\fR
+Delete the subvolume \fI<subvolume>\fR. If \fI<subvolume>\fR is not a
+subvolume, \fBbtrfs\fR returns an error.
+.TP
+
+\fBsubvolume create\fR\fI [<dest>/]<name>\fR
+Create a subvolume in \fI<dest>\fR (or in the current directory if
+\fI<dest>\fR is omitted).
+.TP
+
+\fBsubvolume list\fR\fI [-aprts][-g [+|-]value] [-c [+|-]value] [--sort=gen,ogen,rootid,path] <path>\fR
+.RS
+List the subvolumes present in the filesystem \fI<path>\fR. For every
+subvolume the following information is shown by default.
+ID <ID> top level <ID> path <path>
+where path is the relative path of the subvolume to the \fItop level\fR
+subvolume.
+
+The subvolume's ID may be used by the \fBsubvolume set-default\fR command, or
+at mount time via the \fIsubvol=\fR option.
+If \fI-p\fR is given, then \fIparent <ID>\fR is added to the output between ID
+and top level. The parent's ID may be used at mount time via the
+\fIsubvolrootid=\fR option.
+
+\fB-t\fP print the result as a table.
+
+\fB-a\fP print all the subvolumes in the filesystem.
+
+\fB-r\fP only readonly subvolumes in the filesystem wille be listed.
+
+\fB-s\fP only snapshot subvolumes in the filesystem will  be listed.
+
+\fB-g [+|-]value\fP
+list subvolumes in the filesystem that its generation is
+>=, <= or = value. '+' means >= value, '-' means <= value, If there is
+neither '+' nor '-', it means = value.
+
+\fB-c [+|-]value\fP
+list subvolumes in the filesystem that its ogeneration is
+>=, <= or = value. The usage is the same to '-g' option.
+
+\fB--sort=gen,ogen,path,rootid\fP
+list subvolumes in order by specified items.
+you can add '+' or '-' in front of each items, '+' means ascending,'-'
+means descending. The default is ascending.
+
+for \fB--sort\fP you can combine some items together by ',', just like
+\f--sort=+ogen,-gen,path,rootid\fR.
+.RE
+.TP
+
+\fBsubvolume set-default\fR\fI <id> <path>\fR
+Set the subvolume of the filesystem \fI<path>\fR which is mounted as 
+\fIdefault\fR. The subvolume is identified by \fI<id>\fR, which 
+is returned by the \fBsubvolume list\fR command.
+.TP
+
+\fBsubvolume get-default\fR\fI <path>\fR
+Get the default subvolume of the filesystem \fI<path>\fR. The output format
+is similar to \fBsubvolume list\fR command.
+.TP
+
+\fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] [-s \fIstart\fR] \
+[-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> [<\fIfile\fR>|<\fIdir\fR>...]
+
+Defragment file data and/or directory metadata. To defragment all files in a
+directory you have to specify each one on its own or use your shell wildcards.
+
+The start position and the number of bytes to defragment can be specified by
+\fIstart\fR and \fIlen\fR. Any extent bigger than threshold will be
+considered already defragged. Use 0 to take the kernel default, and use 1 to
+say every single extent must be rewritten. You can also turn on compression in
+defragment operations.
+
+\fB-v\fP be verbose
+
+\fB-c\fP compress file contents while defragmenting
+
+\fB-f\fP flush filesystem after defragmenting
+
+\fB-s start\fP defragment only from byte \fIstart\fR onward
+
+\fB-l len\fP defragment only up to \fIlen\fR bytes
+
+\fB-t size\fP defragment only files at least \fIsize\fR bytes big
+
+NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed copies of data,
+don't use it if you use snapshots, have de-duplicated your data or made
+copies with \fBcp --reflink\fP.
+.TP
+
+\fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
+List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
+.TP
+
+\fBfilesystem sync\fR\fI <path> \fR
+Force a sync for the filesystem identified by \fI<path>\fR.
+.TP
+
+.\"
+.\" Some wording are extracted by the resize2fs man page
+.\"
+
+\fBfilesystem resize\fR\fI [devid:][+/\-]<size>[gkm]|[devid:]max <path>\fR
+Resize a filesystem identified by \fI<path>\fR for the underlying device
+\fIdevid\fR.  The \fIdevid\fR can be found with \fBbtrfs filesystem show\fR and
+defaults to 1 if not specified.
+The \fI<size>\fR parameter specifies the new size of the filesystem.
+If the prefix \fI+\fR or \fI\-\fR is present the size is increased or decreased
+by the quantity \fI<size>\fR.
+If no units are specified, the unit of the \fI<size>\fR parameter defaults to
+bytes. Optionally, the size parameter may be suffixed by one of the following
+units designators: 'K', 'M', or 'G', kilobytes, megabytes, or gigabytes,
+respectively.
+
+If 'max' is passed, the filesystem will occupy all available space on the
+device \fIdevid\fR.
+
+The \fBresize\fR command \fBdoes not\fR manipulate the size of underlying
+partition.  If you wish to enlarge/reduce a filesystem, you must make sure you
+can expand the partition before enlarging the filesystem and shrink the
+partition after reducing the size of the filesystem.  This can done using
+\fBfdisk(8)\fR or \fBparted(8)\fR to delete the existing partition and recreate
+it with the new desired size.  When recreating the partition make sure to use
+the same starting disk cylinder as before.
+.TP
+
+\fBfilesystem label\fP\fI <dev> [newlabel]\fP
+Show or update the label of a filesystem. \fI<dev>\fR is used to identify the
+filesystem. 
+If a \fInewlabel\fR optional argument is passed, the label is changed. The
+following constraints exist for a label:
+.IP
+- the maximum allowable length shall be less or equal than 256 chars
+.IP
+- the label shall not  contain the '/' or '\\' characters.
+
+NOTE: Currently there are the following limitations:
+.IP
+- the filesystem has to be unmounted
+.IP
+- the filesystem should not have more than one device.
+.TP
+
+\fBfilesystem show\fR [--all-devices|<uuid>|<label>]\fR
+Show the btrfs filesystem with some additional info. If no \fIUUID\fP or 
+\fIlabel\fP is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
+If \fB--all-devices\fP is passed, all the devices under /dev are scanned;
+otherwise the devices list is extracted from the /proc/partitions file.
+.TP
+
+\fBfilesystem balance\fR \fI<path>\fR
+Balance the chunks of the filesystem identified by \fI<path>\fR
+across the devices.
+.TP
+
+\fBdevice add\fR\fI <dev> [<dev>..] <path>\fR
+Add device(s) to the filesystem identified by \fI<path>\fR.
+.TP
+
+\fBdevice delete\fR\fI <dev> [<dev>..] <path>\fR
+Remove device(s) from a filesystem identified by \fI<path>\fR.
+.TP
+
+\fBdevice scan\fR \fI[--all-devices|<device> [<device>...]\fR
+If one or more devices are passed, these are scanned for a btrfs filesystem. 
+If no devices are passed, \fBbtrfs\fR scans all the block devices listed
+in the /proc/partitions file.
+Finally, if \fB--all-devices\fP is passed, all the devices under /dev are 
+scanned.
+.TP
+
+\fBscrub start\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
+Start a scrub on all devices of the filesystem identified by \fI<path>\fR or on
+a single \fI<device>\fR. Without options, scrub is started as a background
+process. Progress can be obtained with the \fBscrub status\fR command. Scrubbing
+involves reading all data from all disks and verifying checksums. Errors are
+corrected along the way if possible.
+.RS
+
+\fIOptions\fR
+.IP -B 5
+Do not background and print scrub statistics when finished.
+.IP -d 5
+Print separate statistics for each device of the filesystem (-B only).
+.IP -q 5
+Quiet. Omit error messages and statistics.
+.IP -r 5
+Read only mode. Do not attempt to correct anything.
+.IP -u 5
+Scrub unused space as well. (NOT IMPLEMENTED)
+.RE
+.TP
+
+\fBscrub cancel\fP {\fI<path>\fP|\fI<device>\fP}
+If a scrub is running on the filesystem identified by \fI<path>\fR, cancel it.
+Progress is saved in the scrub progress file and scrubbing can be resumed later
+using the \fBscrub resume\fR command.
+If a \fI<device>\fR is given, the corresponding filesystem is found and
+\fBscrub cancel\fP behaves as if it was called on that filesystem.
+.TP
+
+\fBscrub resume\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
+Resume a canceled or interrupted scrub cycle on the filesystem identified by
+\fI<path>\fR or on a given \fI<device>\fR. Does not start a new scrub if the
+last scrub finished successfully.
+.RS
+
+\fIOptions\fR
+.TP
+see \fBscrub start\fP.
+.RE
+.TP
+
+\fBscrub status\fP [-d] {\fI<path>\fP|\fI<device>\fP}
+Show status of a running scrub for the filesystem identified by \fI<path>\fR or
+for the specified \fI<device>\fR.
+If no scrub is running, show statistics of the last finished or canceled scrub
+for that filesystem or device.
+.RS
+
+\fIOptions\fR
+.IP -d 5
+Print separate statistics for each device of the filesystem.
+.RE
+.TP
+
+\fBinspect-internal inode-resolve\fP [-v] \fI<inode>\fP \fI<path>\fP
+Resolves an <inode> in subvolume <path> to all filesystem paths.
+.RS
+
+\fIOptions\fR
+.IP -v 5
+verbose mode. print count of returned paths and ioctl() return value
+.RE
+.TP
+
+\fBinspect-internal logical-resolve\fP [-Pv] [-s bufsize] \fI<logical>\fP \fI<path>\fP
+Resolves a <logical> address in the filesystem mounted at <path> to all inodes.
+By default, each inode is then resolved to a file system path (similar to the
+\fBinode-resolve\fP subcommand).
+.RS
+
+\fIOptions\fR
+.IP -P 5
+skip the path resolving and print the inodes instead
+.IP -v 5
+verbose mode. print count of returned paths and all ioctl() return values
+.IP -s bufsize 5
+set inode container's size. This is used to increase inode container's size in case it is
+not enough to read all the resolved results. The max value one can set is 64k.
+.RE
+
+.SH EXIT STATUS
+\fBbtrfs\fR returns a zero exist status if it succeeds. Non zero is returned in
+case of failure.
+
+.SH AVAILABILITY
+.B btrfs
+is part of btrfs-progs. Btrfs filesystem is currently under heavy development,
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+.SH SEE ALSO
+.BR mkfs.btrfs (8)
diff --git a/man/btrfs.8.in b/man/btrfs.8.in
deleted file mode 100644
index 9222580..0000000
--- a/man/btrfs.8.in
+++ /dev/null
@@ -1,365 +0,0 @@
-.TH BTRFS 8 "" "btrfs" "btrfs"
-.\"
-.\" Man page written by Goffredo Baroncelli <kreijack@inwind.it> (Feb 2010)
-.\"
-.SH NAME
-btrfs \- control a btrfs filesystem
-.SH SYNOPSIS
-\fBbtrfs\fP \fBsubvolume snapshot\fP\fI [-r] <source> [<dest>/]<name>\fP
-.PP
-\fBbtrfs\fP \fBsubvolume delete\fP\fI <subvolume> [<subvolume>...]\fP
-.PP
-\fBbtrfs\fP \fBsubvolume create\fP\fI [<dest>/]<name>\fP
-.PP
-\fBbtrfs\fP \fBsubvolume list\fP\fI [-aprts] [-g [+|-]value] [-c [+|-]value] [--rootid=rootid,gen,ogen,path] <path>\fP
-.PP
-\fBbtrfs\fP \fBsubvolume set-default\fP\fI <id> <path>\fP
-.PP
-\fBbtrfs\fP \fBsubvolume get-default\fP\fI <path>\fP
-.PP
-\fBbtrfs\fP \fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] \
-[-s \fIstart\fR] [-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> \
-[<\fIfile\fR>|<\fIdir\fR>...]
-.PP
-\fBbtrfs\fP \fBfilesystem sync\fP\fI <path> \fP
-.PP
-\fBbtrfs\fP \fBfilesystem resize\fP\fI [devid:][+/\-]<size>[gkm]|[devid:]max <filesystem>\fP
-.PP
-\fBbtrfs\fP \fBfilesystem label\fP\fI <dev> [newlabel]\fP
-.PP
-\fBbtrfs\fP \fBsubvolume find-new\fP\fI <subvolume> <last_gen>\fP
-.PP
-\fBbtrfs\fP \fBfilesystem balance\fP\fI <path> \fP
-.PP
-\fBbtrfs\fP \fBdevice scan\fP\fI [--all-devices|<device> [<device>...]]\fP
-.PP
-\fBbtrfs\fP \fBdevice show\fP\fI [--all-devices|<uuid>|<label>]\fP
-.PP
-\fBbtrfs\fP \fBdevice add\fP\fI <device> [<device>...] <path> \fP
-.PP
-\fBbtrfs\fP \fBdevice delete\fP\fI <device> [<device>...] <path> \fP
-.PP
-\fBbtrfs\fP \fBscrub start\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
-.PP
-\fBbtrfs\fP \fBscrub cancel\fP {\fI<path>\fP|\fI<device>\fP}
-.PP
-\fBbtrfs\fP \fBscrub resume\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
-.PP
-\fBbtrfs\fP \fBscrub status\fP [-d] {\fI<path>\fP|\fI<device>\fP}
-.PP
-\fBbtrfs\fP \fBinspect-internal inode-resolve\fP [-v] \fI<inode>\fP \fI<path>\fP
-.PP
-\fBbtrfs\fP \fBinspect-internal logical-resolve\fP
-[-Pv] [-s size] \fI<logical>\fP \fI<path>\fP
-.PP
-\fBbtrfs\fP \fBhelp|\-\-help|\-h \fP\fI\fP
-.PP
-\fBbtrfs\fP \fB<command> \-\-help \fP\fI\fP
-.PP
-.SH DESCRIPTION
-.B btrfs
-is used to control the filesystem and the files and directories stored. It is
-the tool to create or destroy a snapshot or a subvolume for the
-filesystem, to defrag a file or a directory, flush the data to the disk,
-to resize the filesystem, to scan the device.
-
-It is possible to abbreviate the commands unless the commands  are ambiguous.
-For example: it is possible to run
-.I btrfs sub snaps
-instead of
-.I btrfs subvolume snapshot.
-But
-.I btrfs file s
-is not allowed, because
-.I file s
-may be interpreted both as
-.I filesystem show
-and as
-.I filesystem sync.
-In this case
-.I btrfs
-returns filesystem sync
-If a command is terminated by
-.I --help
-, the detailed help is showed. If the passed command matches more commands,
-detailed help of all the matched commands is showed. For example
-.I btrfs dev --help
-shows the help of all
-.I device*
-commands.
-
-.SH COMMANDS
-.TP
-
-\fBsubvolume snapshot\fR\fI [-r] <source> [<dest>/]<name>\fR
-Create a writable/readonly snapshot of the subvolume \fI<source>\fR with the
-name \fI<name>\fR in the \fI<dest>\fR directory. If \fI<source>\fR is not a
-subvolume, \fBbtrfs\fR returns an error. If \fI-r\fR is given, the snapshot
-will be readonly.
-.TP
-
-\fBsubvolume delete\fR\fI <subvolume> [<subvolume>...]\fR
-Delete the subvolume \fI<subvolume>\fR. If \fI<subvolume>\fR is not a
-subvolume, \fBbtrfs\fR returns an error.
-.TP
-
-\fBsubvolume create\fR\fI [<dest>/]<name>\fR
-Create a subvolume in \fI<dest>\fR (or in the current directory if
-\fI<dest>\fR is omitted).
-.TP
-
-\fBsubvolume list\fR\fI [-aprts][-g [+|-]value] [-c [+|-]value] [--sort=gen,ogen,rootid,path] <path>\fR
-.RS
-List the subvolumes present in the filesystem \fI<path>\fR. For every
-subvolume the following information is shown by default.
-ID <ID> top level <ID> path <path>
-where path is the relative path of the subvolume to the \fItop level\fR
-subvolume.
-
-The subvolume's ID may be used by the \fBsubvolume set-default\fR command, or
-at mount time via the \fIsubvol=\fR option.
-If \fI-p\fR is given, then \fIparent <ID>\fR is added to the output between ID
-and top level. The parent's ID may be used at mount time via the
-\fIsubvolrootid=\fR option.
-
-\fB-t\fP print the result as a table.
-
-\fB-a\fP print all the subvolumes in the filesystem.
-
-\fB-r\fP only readonly subvolumes in the filesystem wille be listed.
-
-\fB-s\fP only snapshot subvolumes in the filesystem will  be listed.
-
-\fB-g [+|-]value\fP
-list subvolumes in the filesystem that its generation is
->=, <= or = value. '+' means >= value, '-' means <= value, If there is
-neither '+' nor '-', it means = value.
-
-\fB-c [+|-]value\fP
-list subvolumes in the filesystem that its ogeneration is
->=, <= or = value. The usage is the same to '-g' option.
-
-\fB--sort=gen,ogen,path,rootid\fP
-list subvolumes in order by specified items.
-you can add '+' or '-' in front of each items, '+' means ascending,'-'
-means descending. The default is ascending.
-
-for \fB--sort\fP you can combine some items together by ',', just like
-\f--sort=+ogen,-gen,path,rootid\fR.
-.RE
-.TP
-
-\fBsubvolume set-default\fR\fI <id> <path>\fR
-Set the subvolume of the filesystem \fI<path>\fR which is mounted as 
-\fIdefault\fR. The subvolume is identified by \fI<id>\fR, which 
-is returned by the \fBsubvolume list\fR command.
-.TP
-
-\fBsubvolume get-default\fR\fI <path>\fR
-Get the default subvolume of the filesystem \fI<path>\fR. The output format
-is similar to \fBsubvolume list\fR command.
-.TP
-
-\fBfilesystem defragment\fP -c[zlib|lzo] [-l \fIlen\fR] [-s \fIstart\fR] \
-[-t \fIsize\fR] -[vf] <\fIfile\fR>|<\fIdir\fR> [<\fIfile\fR>|<\fIdir\fR>...]
-
-Defragment file data and/or directory metadata. To defragment all files in a
-directory you have to specify each one on its own or use your shell wildcards.
-
-The start position and the number of bytes to defragment can be specified by
-\fIstart\fR and \fIlen\fR. Any extent bigger than threshold will be
-considered already defragged. Use 0 to take the kernel default, and use 1 to
-say every single extent must be rewritten. You can also turn on compression in
-defragment operations.
-
-\fB-v\fP be verbose
-
-\fB-c\fP compress file contents while defragmenting
-
-\fB-f\fP flush filesystem after defragmenting
-
-\fB-s start\fP defragment only from byte \fIstart\fR onward
-
-\fB-l len\fP defragment only up to \fIlen\fR bytes
-
-\fB-t size\fP defragment only files at least \fIsize\fR bytes big
-
-NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed copies of data,
-don't use it if you use snapshots, have de-duplicated your data or made
-copies with \fBcp --reflink\fP.
-.TP
-
-\fBsubvolume find-new\fR\fI <subvolume> <last_gen>\fR
-List the recently modified files in a subvolume, after \fI<last_gen>\fR ID.
-.TP
-
-\fBfilesystem sync\fR\fI <path> \fR
-Force a sync for the filesystem identified by \fI<path>\fR.
-.TP
-
-.\"
-.\" Some wording are extracted by the resize2fs man page
-.\"
-
-\fBfilesystem resize\fR\fI [devid:][+/\-]<size>[gkm]|[devid:]max <path>\fR
-Resize a filesystem identified by \fI<path>\fR for the underlying device
-\fIdevid\fR.  The \fIdevid\fR can be found with \fBbtrfs filesystem show\fR and
-defaults to 1 if not specified.
-The \fI<size>\fR parameter specifies the new size of the filesystem.
-If the prefix \fI+\fR or \fI\-\fR is present the size is increased or decreased
-by the quantity \fI<size>\fR.
-If no units are specified, the unit of the \fI<size>\fR parameter defaults to
-bytes. Optionally, the size parameter may be suffixed by one of the following
-units designators: 'K', 'M', or 'G', kilobytes, megabytes, or gigabytes,
-respectively.
-
-If 'max' is passed, the filesystem will occupy all available space on the
-device \fIdevid\fR.
-
-The \fBresize\fR command \fBdoes not\fR manipulate the size of underlying
-partition.  If you wish to enlarge/reduce a filesystem, you must make sure you
-can expand the partition before enlarging the filesystem and shrink the
-partition after reducing the size of the filesystem.  This can done using
-\fBfdisk(8)\fR or \fBparted(8)\fR to delete the existing partition and recreate
-it with the new desired size.  When recreating the partition make sure to use
-the same starting disk cylinder as before.
-.TP
-
-\fBfilesystem label\fP\fI <dev> [newlabel]\fP
-Show or update the label of a filesystem. \fI<dev>\fR is used to identify the
-filesystem. 
-If a \fInewlabel\fR optional argument is passed, the label is changed. The
-following constraints exist for a label:
-.IP
-- the maximum allowable length shall be less or equal than 256 chars
-.IP
-- the label shall not  contain the '/' or '\\' characters.
-
-NOTE: Currently there are the following limitations:
-.IP
-- the filesystem has to be unmounted
-.IP
-- the filesystem should not have more than one device.
-.TP
-
-\fBfilesystem show\fR [--all-devices|<uuid>|<label>]\fR
-Show the btrfs filesystem with some additional info. If no \fIUUID\fP or 
-\fIlabel\fP is passed, \fBbtrfs\fR show info of all the btrfs filesystem.
-If \fB--all-devices\fP is passed, all the devices under /dev are scanned;
-otherwise the devices list is extracted from the /proc/partitions file.
-.TP
-
-\fBfilesystem balance\fR \fI<path>\fR
-Balance the chunks of the filesystem identified by \fI<path>\fR
-across the devices.
-.TP
-
-\fBdevice add\fR\fI <dev> [<dev>..] <path>\fR
-Add device(s) to the filesystem identified by \fI<path>\fR.
-.TP
-
-\fBdevice delete\fR\fI <dev> [<dev>..] <path>\fR
-Remove device(s) from a filesystem identified by \fI<path>\fR.
-.TP
-
-\fBdevice scan\fR \fI[--all-devices|<device> [<device>...]\fR
-If one or more devices are passed, these are scanned for a btrfs filesystem. 
-If no devices are passed, \fBbtrfs\fR scans all the block devices listed
-in the /proc/partitions file.
-Finally, if \fB--all-devices\fP is passed, all the devices under /dev are 
-scanned.
-.TP
-
-\fBscrub start\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
-Start a scrub on all devices of the filesystem identified by \fI<path>\fR or on
-a single \fI<device>\fR. Without options, scrub is started as a background
-process. Progress can be obtained with the \fBscrub status\fR command. Scrubbing
-involves reading all data from all disks and verifying checksums. Errors are
-corrected along the way if possible.
-.RS
-
-\fIOptions\fR
-.IP -B 5
-Do not background and print scrub statistics when finished.
-.IP -d 5
-Print separate statistics for each device of the filesystem (-B only).
-.IP -q 5
-Quiet. Omit error messages and statistics.
-.IP -r 5
-Read only mode. Do not attempt to correct anything.
-.IP -u 5
-Scrub unused space as well. (NOT IMPLEMENTED)
-.RE
-.TP
-
-\fBscrub cancel\fP {\fI<path>\fP|\fI<device>\fP}
-If a scrub is running on the filesystem identified by \fI<path>\fR, cancel it.
-Progress is saved in the scrub progress file and scrubbing can be resumed later
-using the \fBscrub resume\fR command.
-If a \fI<device>\fR is given, the corresponding filesystem is found and
-\fBscrub cancel\fP behaves as if it was called on that filesystem.
-.TP
-
-\fBscrub resume\fP [-Bdqru] {\fI<path>\fP|\fI<device>\fP}
-Resume a canceled or interrupted scrub cycle on the filesystem identified by
-\fI<path>\fR or on a given \fI<device>\fR. Does not start a new scrub if the
-last scrub finished successfully.
-.RS
-
-\fIOptions\fR
-.TP
-see \fBscrub start\fP.
-.RE
-.TP
-
-\fBscrub status\fP [-d] {\fI<path>\fP|\fI<device>\fP}
-Show status of a running scrub for the filesystem identified by \fI<path>\fR or
-for the specified \fI<device>\fR.
-If no scrub is running, show statistics of the last finished or canceled scrub
-for that filesystem or device.
-.RS
-
-\fIOptions\fR
-.IP -d 5
-Print separate statistics for each device of the filesystem.
-.RE
-.TP
-
-\fBinspect-internal inode-resolve\fP [-v] \fI<inode>\fP \fI<path>\fP
-Resolves an <inode> in subvolume <path> to all filesystem paths.
-.RS
-
-\fIOptions\fR
-.IP -v 5
-verbose mode. print count of returned paths and ioctl() return value
-.RE
-.TP
-
-\fBinspect-internal logical-resolve\fP [-Pv] [-s bufsize] \fI<logical>\fP \fI<path>\fP
-Resolves a <logical> address in the filesystem mounted at <path> to all inodes.
-By default, each inode is then resolved to a file system path (similar to the
-\fBinode-resolve\fP subcommand).
-.RS
-
-\fIOptions\fR
-.IP -P 5
-skip the path resolving and print the inodes instead
-.IP -v 5
-verbose mode. print count of returned paths and all ioctl() return values
-.IP -s bufsize 5
-set inode container's size. This is used to increase inode container's size in case it is
-not enough to read all the resolved results. The max value one can set is 64k.
-.RE
-
-.SH EXIT STATUS
-\fBbtrfs\fR returns a zero exist status if it succeeds. Non zero is returned in
-case of failure.
-
-.SH AVAILABILITY
-.B btrfs
-is part of btrfs-progs. Btrfs filesystem is currently under heavy development,
-and not suitable for any uses other than benchmarking and review.
-Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
-further details.
-.SH SEE ALSO
-.BR mkfs.btrfs (8)
diff --git a/man/btrfsck.8 b/man/btrfsck.8
new file mode 100644
index 0000000..4bf1cff
--- /dev/null
+++ b/man/btrfsck.8
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
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+.SH SEE ALSO
+.BR mkfs.btrfs (8)
+.BR btrfsctl (8)
diff --git a/man/btrfsck.8.in b/man/btrfsck.8.in
deleted file mode 100644
index 4bf1cff..0000000
--- a/man/btrfsck.8.in
+++ /dev/null
@@ -1,17 +0,0 @@
-.TH BTRFSCK 8
-.SH NAME
-btrfsck \- check a btrfs filesystem
-.SH SYNOPSIS
-.B btrfsck \fI device\fP
-.SH DESCRIPTION
-\fBbtrfsck\fP is used to check a btrfs filesystem.
-\fIdevice\fP is the device file where the filesystem is stored.
-.SH AVAILABILITY
-.B btrfsck
-is part of btrfs-progs. Btrfs is currently under heavy development,
-and not suitable for any uses other than benchmarking and review.
-Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
-further details.
-.SH SEE ALSO
-.BR mkfs.btrfs (8)
-.BR btrfsctl (8)
diff --git a/man/btrfsctl.8 b/man/btrfsctl.8
new file mode 100644
index 0000000..8705fa6
--- /dev/null
+++ b/man/btrfsctl.8
@@ -0,0 +1,48 @@
+.TH BTRFSCTL 8
+.SH NAME
+btrfsctl \- control a btrfs filesystem
+.SH SYNOPSIS
+.B btrfsctl
+[ \fB\-d\fP\fI file|directory \fP ]
+[ \fB\-s\fP\fI snapshot-name directory\fP ]
+[ \fB \-S\fP\fI subvolume-name directory\fP ]
+[ \fB \-r\fP\fI [+-]size\fP ]
+[ \fB \-A\fP\fI device\fP ]
+[ \fB \-a\fP ]
+[ \fB \-c\fP ]
+.SH NOTE
+B btrfsctl
+is deprecated. Please consider to switch to the btrfs utility.
+.SH DESCRIPTION
+.B btrfsctl
+is used to control the filesystem and the files and directories stored. It is the tool to create a new snapshot for the filesystem.
+.SH OPTIONS
+.TP
+\fB\-d\fR \fIfile|directory\fR
+Defragment a file or a directory. If the argument is a directory, the entire b-tree under the directory is defragged.
+.TP
+\fB\-s\fR \fIsnapshot-name directory\fR
+Creates a new \fIsnapshot\fP of the \fIdirectory\fP specified.
+.TP
+\fB\-S\fR \fIsubvolume-name directory\fR
+Creates a new subvolume.
+.TP
+\fB\-r\fR \fI[+|-]size\fR
+Resizes the filesystem with the \fIsize\fP specified. If the value is preceded with a signed symbol, the filesystem is resized with respect to the current filesystem size. \fIsize\fP can be suffixed by k,m or g to represent kilobytes, megabytes, or gigabytes respectively.
+.TP
+\fB\-A\fR \fIdevice\fR
+Scans the \fIdevice\fR for btrfs filesystem.
+.TP
+\fB\-a\fR
+Scans all devices present in the system for btrfs filesystem.
+.TP
+\fB\-c\fR
+Forces a filesystem sync.
+.SH AVAILABILITY
+.B btrfsctl
+is part of btrfs-progs. Btrfs is currently under heavy development,
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
+further details.
+.SH SEE ALSO
+.BR mkfs.btrfs (8)
diff --git a/man/btrfsctl.8.in b/man/btrfsctl.8.in
deleted file mode 100644
index 8705fa6..0000000
--- a/man/btrfsctl.8.in
+++ /dev/null
@@ -1,48 +0,0 @@
-.TH BTRFSCTL 8
-.SH NAME
-btrfsctl \- control a btrfs filesystem
-.SH SYNOPSIS
-.B btrfsctl
-[ \fB\-d\fP\fI file|directory \fP ]
-[ \fB\-s\fP\fI snapshot-name directory\fP ]
-[ \fB \-S\fP\fI subvolume-name directory\fP ]
-[ \fB \-r\fP\fI [+-]size\fP ]
-[ \fB \-A\fP\fI device\fP ]
-[ \fB \-a\fP ]
-[ \fB \-c\fP ]
-.SH NOTE
-B btrfsctl
-is deprecated. Please consider to switch to the btrfs utility.
-.SH DESCRIPTION
-.B btrfsctl
-is used to control the filesystem and the files and directories stored. It is the tool to create a new snapshot for the filesystem.
-.SH OPTIONS
-.TP
-\fB\-d\fR \fIfile|directory\fR
-Defragment a file or a directory. If the argument is a directory, the entire b-tree under the directory is defragged.
-.TP
-\fB\-s\fR \fIsnapshot-name directory\fR
-Creates a new \fIsnapshot\fP of the \fIdirectory\fP specified.
-.TP
-\fB\-S\fR \fIsubvolume-name directory\fR
-Creates a new subvolume.
-.TP
-\fB\-r\fR \fI[+|-]size\fR
-Resizes the filesystem with the \fIsize\fP specified. If the value is preceded with a signed symbol, the filesystem is resized with respect to the current filesystem size. \fIsize\fP can be suffixed by k,m or g to represent kilobytes, megabytes, or gigabytes respectively.
-.TP
-\fB\-A\fR \fIdevice\fR
-Scans the \fIdevice\fR for btrfs filesystem.
-.TP
-\fB\-a\fR
-Scans all devices present in the system for btrfs filesystem.
-.TP
-\fB\-c\fR
-Forces a filesystem sync.
-.SH AVAILABILITY
-.B btrfsctl
-is part of btrfs-progs. Btrfs is currently under heavy development,
-and not suitable for any uses other than benchmarking and review.
-Please refer to the btrfs wiki http://btrfs.wiki.kernel.org for
-further details.
-.SH SEE ALSO
-.BR mkfs.btrfs (8)
diff --git a/man/mkfs.btrfs.8 b/man/mkfs.btrfs.8
new file mode 100644
index 0000000..72025ed
--- /dev/null
+++ b/man/mkfs.btrfs.8
@@ -0,0 +1,79 @@
+.TH MKFS.BTRFS 8
+.SH NAME
+mkfs.btrfs \- create a btrfs filesystem
+.SH SYNOPSIS
+.B mkfs.btrfs
+[ \fB\-A\fP\fI alloc-start\fP ]
+[ \fB\-b\fP\fI byte-count\fP ]
+[ \fB\-d\fP\fI data-profile\fP ]
+[ \fB\-l\fP\fI leafsize\fP ]
+[ \fB\-L\fP\fI label\fP ]
+[ \fB\-m\fP\fI metadata profile\fP ]
+[ \fB\-M\fP\fI mixed data+metadata\fP ]
+[ \fB\-n\fP\fI nodesize\fP ]
+[ \fB\-s\fP\fI sectorsize\fP ]
+[ \fB\-r\fP\fI rootdir\fP ]
+[ \fB\-K\fP ]
+[ \fB\-h\fP ]
+[ \fB\-V\fP ]
+\fI device\fP [ \fIdevice ...\fP ]
+.SH DESCRIPTION
+.B mkfs.btrfs
+is used to create a btrfs filesystem (usually in a disk partition, or an array
+of disk partitions).
+.I device
+is the special file corresponding to the device (e.g \fI/dev/sdXX\fP ).
+If multiple \fI devices \fP are specified, btrfs is created
+spanning across the specified \fI devices\fP.
+.SH OPTIONS
+.TP
+\fB\-A\fR, \fB\-\-alloc\-start \fIoffset\fR
+Specify the offset from the start of the device to start the btrfs filesystem. The default value is zero, or the start of the device.
+.TP
+\fB\-b\fR, \fB\-\-byte\-count \fIsize\fR
+Specify the size of the resultant filesystem. If this option is not used,
+mkfs.btrfs uses all the available storage for the filesystem.
+.TP
+\fB\-d\fR, \fB\-\-data \fItype\fR
+Specify how the data must be spanned across the devices specified. Valid
+values are raid0, raid1, raid10 or single.
+.TP
+\fB\-l\fR, \fB\-\-leafsize \fIsize\fR
+Specify the leaf size, the least data item in which btrfs stores data. The
+default value is the page size.
+.TP
+\fB\-L\fR, \fB\-\-label \fIname\fR
+Specify a label for the filesystem.
+.TP
+\fB\-m\fR, \fB\-\-metadata \fIprofile\fR
+Specify how metadata must be spanned across the devices specified. Valid
+values are raid0, raid1, raid10 or single.
+.TP
+\fB\-M\fR, \fB\-\-mixed\fR
+Mix data and metadata chunks together for more efficient space 
+utilization.  This feature incurs a performance penalty in
+larger filesystems.  It is recommended for use with filesystems
+of 1 GiB or smaller.
+.TP
+\fB\-n\fR, \fB\-\-nodesize \fIsize\fR
+Specify the nodesize. By default the value is set to the pagesize.
+.TP
+\fB\-s\fR, \fB\-\-sectorsize \fIsize\fR
+Specify the sectorsize, the minimum block allocation.
+.TP
+\fB\-r\fR, \fB\-\-rootdir \fIrootdir\fR
+Specify a directory to copy into the newly created fs.
+.TP
+\fB\-K\fR, \fB\-\-nodiscard \fR
+Do not perform whole device TRIM operation by default.
+.TP
+\fB\-V\fR, \fB\-\-version\fR
+Print the \fBmkfs.btrfs\fP version and exit.
+.SH AVAILABILITY
+.B mkfs.btrfs
+is part of btrfs-progs. Btrfs is currently under heavy development,
+and not suitable for any uses other than benchmarking and review.
+Please refer to the btrfs wiki
+http://btrfs.wiki.kernel.org for further details.
+.SH SEE ALSO
+.BR btrfsck (8)
diff --git a/man/mkfs.btrfs.8.in b/man/mkfs.btrfs.8.in
deleted file mode 100644
index 72025ed..0000000
--- a/man/mkfs.btrfs.8.in
+++ /dev/null
@@ -1,79 +0,0 @@
-.TH MKFS.BTRFS 8
-.SH NAME
-mkfs.btrfs \- create a btrfs filesystem
-.SH SYNOPSIS
-.B mkfs.btrfs
-[ \fB\-A\fP\fI alloc-start\fP ]
-[ \fB\-b\fP\fI byte-count\fP ]
-[ \fB\-d\fP\fI data-profile\fP ]
-[ \fB\-l\fP\fI leafsize\fP ]
-[ \fB\-L\fP\fI label\fP ]
-[ \fB\-m\fP\fI metadata profile\fP ]
-[ \fB\-M\fP\fI mixed data+metadata\fP ]
-[ \fB\-n\fP\fI nodesize\fP ]
-[ \fB\-s\fP\fI sectorsize\fP ]
-[ \fB\-r\fP\fI rootdir\fP ]
-[ \fB\-K\fP ]
-[ \fB\-h\fP ]
-[ \fB\-V\fP ]
-\fI device\fP [ \fIdevice ...\fP ]
-.SH DESCRIPTION
-.B mkfs.btrfs
-is used to create a btrfs filesystem (usually in a disk partition, or an array
-of disk partitions).
-.I device
-is the special file corresponding to the device (e.g \fI/dev/sdXX\fP ).
-If multiple \fI devices \fP are specified, btrfs is created
-spanning across the specified \fI devices\fP.
-.SH OPTIONS
-.TP
-\fB\-A\fR, \fB\-\-alloc\-start \fIoffset\fR
-Specify the offset from the start of the device to start the btrfs filesystem. The default value is zero, or the start of the device.
-.TP
-\fB\-b\fR, \fB\-\-byte\-count \fIsize\fR
-Specify the size of the resultant filesystem. If this option is not used,
-mkfs.btrfs uses all the available storage for the filesystem.
-.TP
-\fB\-d\fR, \fB\-\-data \fItype\fR
-Specify how the data must be spanned across the devices specified. Valid
-values are raid0, raid1, raid10 or single.
-.TP
-\fB\-l\fR, \fB\-\-leafsize \fIsize\fR
-Specify the leaf size, the least data item in which btrfs stores data. The
-default value is the page size.
-.TP
-\fB\-L\fR, \fB\-\-label \fIname\fR
-Specify a label for the filesystem.
-.TP
-\fB\-m\fR, \fB\-\-metadata \fIprofile\fR
-Specify how metadata must be spanned across the devices specified. Valid
-values are raid0, raid1, raid10 or single.
-.TP
-\fB\-M\fR, \fB\-\-mixed\fR
-Mix data and metadata chunks together for more efficient space 
-utilization.  This feature incurs a performance penalty in
-larger filesystems.  It is recommended for use with filesystems
-of 1 GiB or smaller.
-.TP
-\fB\-n\fR, \fB\-\-nodesize \fIsize\fR
-Specify the nodesize. By default the value is set to the pagesize.
-.TP
-\fB\-s\fR, \fB\-\-sectorsize \fIsize\fR
-Specify the sectorsize, the minimum block allocation.
-.TP
-\fB\-r\fR, \fB\-\-rootdir \fIrootdir\fR
-Specify a directory to copy into the newly created fs.
-.TP
-\fB\-K\fR, \fB\-\-nodiscard \fR
-Do not perform whole device TRIM operation by default.
-.TP
-\fB\-V\fR, \fB\-\-version\fR
-Print the \fBmkfs.btrfs\fP version and exit.
-.SH AVAILABILITY
-.B mkfs.btrfs
-is part of btrfs-progs. Btrfs is currently under heavy development,
-and not suitable for any uses other than benchmarking and review.
-Please refer to the btrfs wiki
-http://btrfs.wiki.kernel.org for further details.
-.SH SEE ALSO
-.BR btrfsck (8)
-- 
1.7.10.4

