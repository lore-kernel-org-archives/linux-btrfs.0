Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859Ab3AXXcy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 18:32:54 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0ONWsNx003011
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jan 2013 18:32:54 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r0ONWquE013800
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jan 2013 18:32:54 -0500
Message-ID: <5101C4A4.30304@redhat.com>
Date: Thu, 24 Jan 2013 17:32:52 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs pretty/quiet build
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A quieter build makes warnings more obvious.

This could probably be improved, but just to see
if people like this or if they hate it.  :)

make V=1 overrides it and gets you the full
glory again.

# make
    [CC]     ctree.o
    [CC]     disk-io.o
    [CC]     radix-tree.o
    [CC]     extent-tree.o
    ...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 Makefile     |   92 +++++++++++++++++++++++++++++++++++++++++-----------------
 man/Makefile |   29 +++++++-----------
 2 files changed, 76 insertions(+), 45 deletions(-)

diff --git a/Makefile b/Makefile
index 4894903..73657bf 100644
--- a/Makefile
+++ b/Makefile
@@ -20,6 +20,21 @@ bindir = $(prefix)/bin
 LIBS=-luuid -lm
 RESTORE_LIBS=-lz
 
+ifeq ("$(origin V)", "command line")
+  BUILD_VERBOSE = $(V)
+endif
+ifndef BUILD_VERBOSE
+  BUILD_VERBOSE = 0
+endif
+
+ifeq ($(BUILD_VERBOSE),1)
+  Q =
+else
+  Q = @
+endif
+
+MAKEOPTS = --no-print-directory Q=$(Q)
+
 progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
 	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
 	btrfs-find-root btrfs-restore btrfstune
@@ -28,90 +43,113 @@ progs = btrfsctl mkfs.btrfs btrfs-debug-tree btrfs-show btrfs-vol btrfsck \
 ifdef C
 	check = sparse $(CHECKFLAGS)
 else
-	check = ls
+	check = true
 endif
 
 .c.o:
-	$(check) $<
-	$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
+	$(Q)$(check) $<
+	@echo "    [CC]     $@"
+	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
 
 
 all: version $(progs) manpages
 
 version:
-	bash version.sh
+	$(Q)bash version.sh
 
 btrfs: $(objects) btrfs.o help.o common.o $(cmds_objects)
-	$(CC) $(CFLAGS) -o btrfs btrfs.o help.o common.o $(cmds_objects) \
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfs btrfs.o help.o common.o $(cmds_objects) \
 		$(objects) $(LDFLAGS) $(LIBS) -lpthread
 
 calc-size: $(objects) calc-size.o
-	$(CC) $(CFLAGS) -o calc-size calc-size.o $(objects) $(LDFLAGS) $(LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o calc-size calc-size.o $(objects) $(LDFLAGS) $(LIBS)
 
 btrfs-find-root: $(objects) find-root.o
-	$(CC) $(CFLAGS) -o btrfs-find-root find-root.o $(objects) $(LDFLAGS) $(LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfs-find-root find-root.o $(objects) $(LDFLAGS) $(LIBS)
 
 btrfs-restore: $(objects) restore.o
-	$(CC) $(CFLAGS) -o btrfs-restore restore.o $(objects) $(LDFLAGS) $(LIBS) $(RESTORE_LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfs-restore restore.o $(objects) $(LDFLAGS) $(LIBS) $(RESTORE_LIBS)
 
 btrfsctl: $(objects) btrfsctl.o
-	$(CC) $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfsctl btrfsctl.o $(objects) $(LDFLAGS) $(LIBS)
 
 btrfs-vol: $(objects) btrfs-vol.o
-	$(CC) $(CFLAGS) -o btrfs-vol btrfs-vol.o $(objects) $(LDFLAGS) $(LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfs-vol btrfs-vol.o $(objects) $(LDFLAGS) $(LIBS)
 
 btrfs-show: $(objects) btrfs-show.o
-	$(CC) $(CFLAGS) -o btrfs-show btrfs-show.o $(objects) $(LDFLAGS) $(LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfs-show btrfs-show.o $(objects) $(LDFLAGS) $(LIBS)
 
 btrfsck: $(objects) btrfsck.o
-	$(CC) $(CFLAGS) -o btrfsck btrfsck.o $(objects) $(LDFLAGS) $(LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfsck btrfsck.o $(objects) $(LDFLAGS) $(LIBS)
 
 mkfs.btrfs: $(objects) mkfs.o
-	$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
 
 btrfs-debug-tree: $(objects) debug-tree.o
-	$(CC) $(CFLAGS) -o btrfs-debug-tree $(objects) debug-tree.o $(LDFLAGS) $(LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfs-debug-tree $(objects) debug-tree.o $(LDFLAGS) $(LIBS)
 
 btrfs-zero-log: $(objects) btrfs-zero-log.o
-	$(CC) $(CFLAGS) -o btrfs-zero-log $(objects) btrfs-zero-log.o $(LDFLAGS) $(LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfs-zero-log $(objects) btrfs-zero-log.o $(LDFLAGS) $(LIBS)
 
 btrfs-select-super: $(objects) btrfs-select-super.o
-	$(CC) $(CFLAGS) -o btrfs-select-super $(objects) btrfs-select-super.o $(LDFLAGS) $(LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfs-select-super $(objects) btrfs-select-super.o $(LDFLAGS) $(LIBS)
 
 btrfstune: $(objects) btrfstune.o
-	$(CC) $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
 
 btrfs-map-logical: $(objects) btrfs-map-logical.o
-	$(CC) $(CFLAGS) -o btrfs-map-logical $(objects) btrfs-map-logical.o $(LDFLAGS) $(LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfs-map-logical $(objects) btrfs-map-logical.o $(LDFLAGS) $(LIBS)
 
 btrfs-corrupt-block: $(objects) btrfs-corrupt-block.o
-	$(CC) $(CFLAGS) -o btrfs-corrupt-block $(objects) btrfs-corrupt-block.o $(LDFLAGS) $(LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfs-corrupt-block $(objects) btrfs-corrupt-block.o $(LDFLAGS) $(LIBS)
 
 btrfs-image: $(objects) btrfs-image.o
-	$(CC) $(CFLAGS) -o btrfs-image $(objects) btrfs-image.o -lpthread -lz $(LDFLAGS) $(LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfs-image $(objects) btrfs-image.o -lpthread -lz $(LDFLAGS) $(LIBS)
 
 dir-test: $(objects) dir-test.o
-	$(CC) $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
 
 quick-test: $(objects) quick-test.o
-	$(CC) $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
 
 btrfs-convert: $(objects) convert.o
-	$(CC) $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs -lcom_err $(LDFLAGS) $(LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfs-convert $(objects) convert.o -lext2fs -lcom_err $(LDFLAGS) $(LIBS)
 
 ioctl-test: $(objects) ioctl-test.o
-	$(CC) $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)
 
 manpages:
-	cd man; $(MAKE)
+	@echo "    [LD]     $@"
+	$(Q)$(MAKE) $(MAKEOPTS) -C man
 
 install-man:
 	cd man; $(MAKE) install
 
 clean :
-	rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
+	@echo "Cleaning"
+	$(Q)rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
 	      btrfs-zero-log btrfstune dir-test ioctl-test quick-test version.h
-	cd man; $(MAKE) clean
+	$(Q)$(MAKE) $(MAKEOPTS) -C man $@
 
 install: $(progs) install-man
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
diff --git a/man/Makefile b/man/Makefile
index 4a90b75..2c063bd 100644
--- a/man/Makefile
+++ b/man/Makefile
@@ -6,31 +6,24 @@ bindir = $(prefix)/bin
 mandir = $(prefix)/man
 man8dir = $(mandir)/man8
 
+# clear out all suffixes
+.SUFFIXES:
+# list only those we use
+.SUFFIXES: .in .gz
+
 MANPAGES = mkfs.btrfs.8.gz btrfsctl.8.gz btrfsck.8.gz btrfs-image.8.gz \
 	   btrfs-show.8.gz btrfs.8.gz
+INFILES = ${MANPAGES:.in=.gz}
 
 all: $(MANPAGES)
 
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
+.in.gz :
+	@echo "    [MAN]    $@"
+	$(Q)$(GZIP) -n -c $< > $@
 
 clean :
-	rm -f $(MANPAGES)
+	@echo "Cleaning manpages"
+	$(Q)rm -f $(MANPAGES)
 
 install: $(MANPAGES)
 	$(INSTALL) -m755 -d $(DESTDIR)$(man8dir)

