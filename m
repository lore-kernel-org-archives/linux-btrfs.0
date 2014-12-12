Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967699AbaLLMgK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 07:36:10 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sBCCaAH4022472
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 07:36:10 -0500
From: Karel Zak <kzak@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Karel Zak <kzak@redhat.com>
Subject: [PATCH 07/10] btrfs-progs: cleanup compilation flags usage
Date: Fri, 12 Dec 2014 13:35:21 +0100
Message-Id: <1418387724-20188-8-git-send-email-kzak@redhat.com>
In-Reply-To: <1418387724-20188-1-git-send-email-kzak@redhat.com>
References: <1418387724-20188-1-git-send-email-kzak@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

- define basic default CFLAGS in configure.ac, because:

   * autoconf default is -g -O2, but btrfs uses -g -O1

   * it's better to follow autoconf; standard way to modify
     CFLAGS is to call:  CFLAGS="foo bar" ./configure

- move all flags to one place in Makefile.in

- don't use AM_CFLAGS, the CFLAGS and STATIC_CFLAGS are enough

- don't mix objects and flags in $LIBS, it's more readable to
  add $(libs) to make rules

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 Makefile.in  | 67 +++++++++++++++++++++++++++++++++++-------------------------
 configure.ac |  2 ++
 2 files changed, 41 insertions(+), 28 deletions(-)

diff --git a/Makefile.in b/Makefile.in
index df590ab..58200ca 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -4,10 +4,27 @@ export
 CC = @CC@
 LN_S = @LN_S@
 AR = @AR@
-AM_CFLAGS = -include config.h -Wall \
-	    -D_FILE_OFFSET_BITS=64 -DBTRFS_FLAT_INCLUDES \
-	    -fno-strict-aliasing -fPIC
-CFLAGS = -g -O1 -fno-strict-aliasing -rdynamic
+INSTALL = @INSTALL@
+
+# Non-static compilation flags
+CFLAGS = @CFLAGS@ \
+	 -include config.h -Wall \
+	 -D_FILE_OFFSET_BITS=64 -DBTRFS_FLAT_INCLUDES \
+	 -fno-strict-aliasing -fPIC \
+	 -rdynamic
+
+LDFLAGS = @LDFLAGS@
+
+LIBS = @UUID_LIBS@ @BLKID_LIBS@ @ZLIB_LIBS@ @LZO2_LIBS@ -lm -L.
+LIBBTRFS_LIBS = $(LIBS)
+
+# Static compilation flags
+STATIC_CFLAGS = $(CFLAGS) -ffunction-sections -fdata-sections
+STATIC_LDFLAGS = -static -Wl,--gc-sections
+STATIC_LIBS = @UUID_LIBS_STATIC@ @BLKID_LIBS_STATIC@ \
+	      @ZLIB_LIBS_STATIC@ @LZO2_LIBS_STATIC@ -lpthread
+
+
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
@@ -25,13 +42,10 @@ libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
 	       extent_io.h ioctl.h ctree.h btrfsck.h version.h
 TESTS = fsck-tests.sh convert-tests.sh
 
-INSTALL = @INSTALL@
 prefix ?= @prefix@
 bindir = @bindir@
-lib_LIBS = @UUID_LIBS@ @BLKID_LIBS@ @ZLIB_LIBS@ @LZO2_LIBS@ -m -L.
 libdir ?= @libdir@
 incdir = @includedir@/btrfs
-LIBS = $(lib_LIBS) $(libs_static)
 
 ifeq ("$(origin V)", "command line")
   BUILD_VERBOSE = $(V)
@@ -69,7 +83,7 @@ INSTALLDIRS = $(patsubst %,install-%,$(SUBDIRS))
 CLEANDIRS = $(patsubst %,clean-%,$(SUBDIRS))
 
 ifeq ($(DISABLE_BACKTRACE),1)
-AM_CFLAGS += -DBTRFS_DISABLE_BACKTRACE
+CFLAGS += -DBTRFS_DISABLE_BACKTRACE
 endif
 
 ifneq ($(DISABLE_DOCUMENTATION),1)
@@ -89,10 +103,6 @@ static_objects = $(patsubst %.o, %.static.o, $(objects))
 static_cmds_objects = $(patsubst %.o, %.static.o, $(cmds_objects))
 static_libbtrfs_objects = $(patsubst %.o, %.static.o, $(libbtrfs_objects))
 
-# Define static compilation flags
-STATIC_CFLAGS = $(CFLAGS) -ffunction-sections -fdata-sections
-STATIC_LDFLAGS = -static -Wl,--gc-sections
-STATIC_LIBS = $(lib_LIBS) -lpthread
 
 libs_shared = libbtrfs.so.0.1
 libs_static = libbtrfs.a
@@ -120,7 +130,7 @@ ifdef C
 else
 	check = true
 	check_echo = true
-	AM_CFLAGS += -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
+	CFLAGS += -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
 endif
 
 %.o.d: %.c
@@ -128,13 +138,13 @@ endif
 
 .c.o:
 	@$(check_echo) "    [SP]     $<"
-	$(Q)$(check) $(AM_CFLAGS) $(CFLAGS) $<
+	$(Q)$(check) $(CFLAGS) $<
 	@echo "    [CC]     $@"
-	$(Q)$(CC) $(AM_CFLAGS) $(CFLAGS) -c $<
+	$(Q)$(CC) $(CFLAGS) -c $<
 
 %.static.o: %.c
 	@echo "    [CC]     $@"
-	$(Q)$(CC) $(AM_CFLAGS) $(STATIC_CFLAGS) -c $< -o $@
+	$(Q)$(CC) $(STATIC_CFLAGS) -c $< -o $@
 
 all: $(progs) $(BUILDDIRS)
 $(SUBDIRS): $(BUILDDIRS)
@@ -156,7 +166,7 @@ static: $(progs_static)
 
 $(libs_shared): $(libbtrfs_objects) $(lib_links) send.h
 	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) $(libbtrfs_objects) $(LDFLAGS) $(lib_LIBS) \
+	$(Q)$(CC) $(CFLAGS) $(libbtrfs_objects) $(LDFLAGS) $(LIBBTRFS_LIBS) \
 		-shared -Wl,-soname,libbtrfs.so.0 -o libbtrfs.so.0.1
 
 $(libs_static): $(libbtrfs_objects)
@@ -186,12 +196,13 @@ btrfs-%.static: $(static_objects) btrfs-%.static.o $(static_libbtrfs_objects)
 
 btrfs-%: $(objects) $(libs) btrfs-%.o
 	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o $@ $(objects) $@.o $(LDFLAGS) $(LIBS) $($(subst -,_,$@-libs))
+	$(Q)$(CC) $(CFLAGS) -o $@ $(objects) $@.o $(libs) \
+		$(LDFLAGS) $(LIBS) $($(subst -,_,$@-libs))
 
 btrfs: $(objects) btrfs.o help.o $(cmds_objects) $(libs)
 	@echo "    [LD]     $@"
 	$(Q)$(CC) $(CFLAGS) -o btrfs btrfs.o help.o $(cmds_objects) \
-		$(objects) $(LDFLAGS) $(LIBS) -lpthread
+		$(objects) $(libs) $(LDFLAGS) $(LIBS) -lpthread
 
 btrfs.static: $(static_objects) btrfs.static.o help.static.o $(static_cmds_objects) $(static_libbtrfs_objects)
 	@echo "    [LD]     $@"
@@ -201,15 +212,15 @@ btrfs.static: $(static_objects) btrfs.static.o help.static.o $(static_cmds_objec
 # For backward compatibility, 'btrfs' changes behaviour to fsck if it's named 'btrfsck'
 btrfsck: btrfs
 	@echo "    [LN]     $@"
-	$(Q)$(LN) -f btrfs btrfsck
+	$(Q)$(LN_S) -f btrfs btrfsck
 
 btrfsck.static: btrfs.static
 	@echo "    [LN]     $@"
-	$(Q)$(LN) -f $^ $@
+	$(Q)$(LN_S) -f $^ $@
 
 mkfs.btrfs: $(objects) $(libs) mkfs.o
 	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
+	$(Q)$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) $(libs) mkfs.o $(LDFLAGS) $(LIBS)
 
 mkfs.btrfs.static: $(static_objects) mkfs.static.o $(static_libbtrfs_objects)
 	@echo "    [LD]     $@"
@@ -218,7 +229,7 @@ mkfs.btrfs.static: $(static_objects) mkfs.static.o $(static_libbtrfs_objects)
 
 btrfstune: $(objects) $(libs) btrfstune.o
 	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
+	$(Q)$(CC) $(CFLAGS) -o btrfstune $(objects) $(libs) btrfstune.o $(LDFLAGS) $(LIBS)
 
 btrfstune.static: $(static_objects) btrfstune.static.o $(static_libbtrfs_objects)
 	@echo "    [LD]     $@"
@@ -227,19 +238,19 @@ btrfstune.static: $(static_objects) btrfstune.static.o $(static_libbtrfs_objects
 
 dir-test: $(objects) $(libs) dir-test.o
 	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
+	$(Q)$(CC) $(CFLAGS) -o dir-test $(objects) $(libs) dir-test.o $(LDFLAGS) $(LIBS)
 
 quick-test: $(objects) $(libs) quick-test.o
 	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
+	$(Q)$(CC) $(CFLAGS) -o quick-test $(objects) $(libs) quick-test.o $(LDFLAGS) $(LIBS)
 
 ioctl-test: $(objects) $(libs) ioctl-test.o
 	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)
+	$(Q)$(CC) $(CFLAGS) -o ioctl-test $(objects) $(libs) ioctl-test.o $(LDFLAGS) $(LIBS)
 
 send-test: $(objects) $(libs) send-test.o
 	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o send-test $(objects) send-test.o $(LDFLAGS) $(LIBS) -lpthread
+	$(Q)$(CC) $(CFLAGS) -o send-test $(objects) $(libs) send-test.o $(LDFLAGS) $(LIBS) -lpthread
 
 library-test: $(libs_shared) library-test.o
 	@echo "    [LD]     $@"
@@ -284,7 +295,7 @@ install: $(libs) $(progs) $(INSTALLDIRS)
 	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
 	$(INSTALL) fsck.btrfs $(DESTDIR)$(bindir)
 	# btrfsck is a link to btrfs in the src tree, make it so for installed file as well
-	$(LN) -f $(DESTDIR)$(bindir)/btrfs $(DESTDIR)$(bindir)/btrfsck
+	$(LN_S) -f $(DESTDIR)$(bindir)/btrfs $(DESTDIR)$(bindir)/btrfsck
 	$(INSTALL) -m755 -d $(DESTDIR)$(libdir)
 	$(INSTALL) $(libs) $(DESTDIR)$(libdir)
 	cp -a $(lib_links) $(DESTDIR)$(libdir)
diff --git a/configure.ac b/configure.ac
index 662d9ff..f6adefb 100644
--- a/configure.ac
+++ b/configure.ac
@@ -8,6 +8,8 @@ LIBBTRFS_MAJOR=0
 LIBBTRFS_MINOR=1
 LIBBTRFS_PATCHLEVEL=1
 
+CFLAGS="-g -O1"
+
 AC_PREREQ([2.60])
 
 AC_CONFIG_AUX_DIR([config])
-- 
1.9.3

