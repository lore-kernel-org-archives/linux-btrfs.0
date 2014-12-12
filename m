Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966556AbaLLMgA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 07:36:00 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sBCCa0wE014099
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Dec 2014 07:36:00 -0500
From: Karel Zak <kzak@redhat.com>
To: linux-btrfs@vger.kernel.org
Cc: Karel Zak <kzak@redhat.com>
Subject: [PATCH 01/10] btrfs-progs: add ./configure script
Date: Fri, 12 Dec 2014 13:35:15 +0100
Message-Id: <1418387724-20188-2-git-send-email-kzak@redhat.com>
In-Reply-To: <1418387724-20188-1-git-send-email-kzak@redhat.com>
References: <1418387724-20188-1-git-send-email-kzak@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add ./autogen.sh script, you have to use it after "git clone/clean" to
generate ./configure from configure.ac.

Modify version.sh to be usable from the configure script.

The patch also renames Makefile to Makefile.in, but does NOT change
anything in the file.

Signed-off-by: Karel Zak <kzak@redhat.com>
---
 .gitignore   |  28 ++++++
 Makefile     |  87 +++++++++--------
 Makefile.in  | 314 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 autogen.sh   |  58 +++++++++++
 configure.ac | 102 +++++++++++++++++++
 version.sh   |   7 ++
 6 files changed, 557 insertions(+), 39 deletions(-)
 create mode 100644 Makefile.in
 create mode 100755 autogen.sh
 create mode 100644 configure.ac
 mode change 100644 => 100755 version.sh

diff --git a/.gitignore b/.gitignore
index e637b17..beddedb 100644
--- a/.gitignore
+++ b/.gitignore
@@ -39,3 +39,31 @@ libbtrfs.so.0
 libbtrfs.so.0.1
 library-test
 library-test-static
+
+
+aclocal.m4
+autom4te.cache
+compile
+config.cache
+config.guess
+config.h
+config.h.in
+config.log
+config.rpath
+config.status
+config.sub
+config/ltmain.sh
+config/py-compile
+config/test-driver
+configure
+cscope.out
+depcomp
+install-sh
+libtool
+m4/*.m4
+Makefile
+missing
+mkinstalldirs
+stamp-h
+stamp-h.in
+stamp-h1
diff --git a/Makefile b/Makefile
index 4cae30c..95700be 100644
--- a/Makefile
+++ b/Makefile
@@ -1,11 +1,30 @@
 # Export all variables to sub-makes by default
 export
 
-CC = gcc
-LN = ln
-AR = ar
-AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -DBTRFS_FLAT_INCLUDES -fno-strict-aliasing -fPIC
-CFLAGS = -g -O1 -fno-strict-aliasing -rdynamic
+CC = gcc -std=gnu99
+LN_S = ln -s
+AR = /usr/bin/ar
+INSTALL = /usr/bin/install -c
+
+# Non-static compilation flags
+CFLAGS = -g -O1 \
+	 -include config.h -Wall \
+	 -D_FILE_OFFSET_BITS=64 -DBTRFS_FLAT_INCLUDES \
+	 -fno-strict-aliasing -fPIC \
+	 -rdynamic
+
+LDFLAGS = 
+
+LIBS = -luuid  -lblkid  -L/usr/lib64 -lz  -lzo2 -lm -L.
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
@@ -23,13 +42,10 @@ libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
 	       extent_io.h ioctl.h ctree.h btrfsck.h version.h
 TESTS = fsck-tests.sh convert-tests.sh
 
-INSTALL = install
-prefix ?= /usr/local
-bindir = $(prefix)/bin
-lib_LIBS = -luuid -lblkid -lm -lz -llzo2 -L.
-libdir ?= $(prefix)/lib
-incdir = $(prefix)/include/btrfs
-LIBS = $(lib_LIBS) $(libs_static)
+prefix ?= /usr
+bindir = ${exec_prefix}/bin
+libdir ?= ${exec_prefix}/lib
+incdir = ${prefix}/include/btrfs
 
 ifeq ("$(origin V)", "command line")
   BUILD_VERBOSE = $(V)
@@ -67,7 +83,7 @@ INSTALLDIRS = $(patsubst %,install-%,$(SUBDIRS))
 CLEANDIRS = $(patsubst %,clean-%,$(SUBDIRS))
 
 ifeq ($(DISABLE_BACKTRACE),1)
-AM_CFLAGS += -DBTRFS_DISABLE_BACKTRACE
+CFLAGS += -DBTRFS_DISABLE_BACKTRACE
 endif
 
 ifneq ($(DISABLE_DOCUMENTATION),1)
@@ -87,10 +103,6 @@ static_objects = $(patsubst %.o, %.static.o, $(objects))
 static_cmds_objects = $(patsubst %.o, %.static.o, $(cmds_objects))
 static_libbtrfs_objects = $(patsubst %.o, %.static.o, $(libbtrfs_objects))
 
-# Define static compilation flags
-STATIC_CFLAGS = $(CFLAGS) -ffunction-sections -fdata-sections
-STATIC_LDFLAGS = -static -Wl,--gc-sections
-STATIC_LIBS = $(lib_LIBS) -lpthread
 
 libs_shared = libbtrfs.so.0.1
 libs_static = libbtrfs.a
@@ -118,7 +130,7 @@ ifdef C
 else
 	check = true
 	check_echo = true
-	AM_CFLAGS += -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
+	CFLAGS += -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
 endif
 
 %.o.d: %.c
@@ -126,13 +138,13 @@ endif
 
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
@@ -152,13 +164,9 @@ test:
 #
 static: $(progs_static)
 
-version.h:
-	@echo "    [SH]     $@"
-	$(Q)bash version.sh
-
 $(libs_shared): $(libbtrfs_objects) $(lib_links) send.h
 	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) $(libbtrfs_objects) $(LDFLAGS) $(lib_LIBS) \
+	$(Q)$(CC) $(CFLAGS) $(libbtrfs_objects) $(LDFLAGS) $(LIBBTRFS_LIBS) \
 		-shared -Wl,-soname,libbtrfs.so.0 -o libbtrfs.so.0.1
 
 $(libs_static): $(libbtrfs_objects)
@@ -167,8 +175,8 @@ $(libs_static): $(libbtrfs_objects)
 
 $(lib_links):
 	@echo "    [LN]     $@"
-	$(Q)$(LN) -sf libbtrfs.so.0.1 libbtrfs.so.0
-	$(Q)$(LN) -sf libbtrfs.so.0.1 libbtrfs.so
+	$(Q)$(LN_S) -f libbtrfs.so.0.1 libbtrfs.so.0
+	$(Q)$(LN_S) -f libbtrfs.so.0.1 libbtrfs.so
 
 # keep intermediate files from the below implicit rules around
 .PRECIOUS: $(addsuffix .o,$(progs))
@@ -188,12 +196,13 @@ btrfs-%.static: $(static_objects) btrfs-%.static.o $(static_libbtrfs_objects)
 
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
@@ -203,15 +212,15 @@ btrfs.static: $(static_objects) btrfs.static.o help.static.o $(static_cmds_objec
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
@@ -220,7 +229,7 @@ mkfs.btrfs.static: $(static_objects) mkfs.static.o $(static_libbtrfs_objects)
 
 btrfstune: $(objects) $(libs) btrfstune.o
 	@echo "    [LD]     $@"
-	$(Q)$(CC) $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
+	$(Q)$(CC) $(CFLAGS) -o btrfstune $(objects) $(libs) btrfstune.o $(LDFLAGS) $(LIBS)
 
 btrfstune.static: $(static_objects) btrfstune.static.o $(static_libbtrfs_objects)
 	@echo "    [LD]     $@"
@@ -229,19 +238,19 @@ btrfstune.static: $(static_objects) btrfstune.static.o $(static_libbtrfs_objects
 
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
@@ -286,7 +295,7 @@ install: $(libs) $(progs) $(INSTALLDIRS)
 	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
 	$(INSTALL) fsck.btrfs $(DESTDIR)$(bindir)
 	# btrfsck is a link to btrfs in the src tree, make it so for installed file as well
-	$(LN) -f $(DESTDIR)$(bindir)/btrfs $(DESTDIR)$(bindir)/btrfsck
+	$(LN_S) -f $(DESTDIR)$(bindir)/btrfs $(DESTDIR)$(bindir)/btrfsck
 	$(INSTALL) -m755 -d $(DESTDIR)$(libdir)
 	$(INSTALL) $(libs) $(DESTDIR)$(libdir)
 	cp -a $(lib_links) $(DESTDIR)$(libdir)
diff --git a/Makefile.in b/Makefile.in
new file mode 100644
index 0000000..4cae30c
--- /dev/null
+++ b/Makefile.in
@@ -0,0 +1,314 @@
+# Export all variables to sub-makes by default
+export
+
+CC = gcc
+LN = ln
+AR = ar
+AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -DBTRFS_FLAT_INCLUDES -fno-strict-aliasing -fPIC
+CFLAGS = -g -O1 -fno-strict-aliasing -rdynamic
+objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
+	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
+	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
+	  qgroup.o raid6.o free-space-cache.o list_sort.o props.o \
+	  ulist.o qgroup-verify.o backref.o
+cmds_objects = cmds-subvolume.o cmds-filesystem.o cmds-device.o cmds-scrub.o \
+	       cmds-inspect.o cmds-balance.o cmds-send.o cmds-receive.o \
+	       cmds-quota.o cmds-qgroup.o cmds-replace.o cmds-check.o \
+	       cmds-restore.o cmds-rescue.o chunk-recover.o super-recover.o \
+	       cmds-property.o
+libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
+		   uuid-tree.o utils-lib.o rbtree-utils.o
+libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
+	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
+	       extent_io.h ioctl.h ctree.h btrfsck.h version.h
+TESTS = fsck-tests.sh convert-tests.sh
+
+INSTALL = install
+prefix ?= /usr/local
+bindir = $(prefix)/bin
+lib_LIBS = -luuid -lblkid -lm -lz -llzo2 -L.
+libdir ?= $(prefix)/lib
+incdir = $(prefix)/include/btrfs
+LIBS = $(lib_LIBS) $(libs_static)
+
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
+progs = mkfs.btrfs btrfs-debug-tree btrfsck \
+	btrfs btrfs-map-logical btrfs-image btrfs-zero-log btrfs-convert \
+	btrfs-find-root btrfstune btrfs-show-super
+
+progs_extra = btrfs-corrupt-block btrfs-fragments btrfs-calc-size \
+	      btrfs-select-super
+
+progs_static = $(foreach p,$(progs),$(p).static)
+
+# external libs required by various binaries; for btrfs-foo,
+# specify btrfs_foo_libs = <list of libs>; see $($(subst...)) rules below
+btrfs_convert_libs = -lext2fs -lcom_err
+btrfs_image_libs = -lpthread
+btrfs_fragments_libs = -lgd -lpng -ljpeg -lfreetype
+
+SUBDIRS =
+BUILDDIRS = $(patsubst %,build-%,$(SUBDIRS))
+INSTALLDIRS = $(patsubst %,install-%,$(SUBDIRS))
+CLEANDIRS = $(patsubst %,clean-%,$(SUBDIRS))
+
+ifeq ($(DISABLE_BACKTRACE),1)
+AM_CFLAGS += -DBTRFS_DISABLE_BACKTRACE
+endif
+
+ifneq ($(DISABLE_DOCUMENTATION),1)
+BUILDDIRS += build-Documentation
+INSTALLDIRS += install-Documentation
+endif
+
+.PHONY: $(SUBDIRS)
+.PHONY: $(BUILDDIRS)
+.PHONY: $(INSTALLDIRS)
+.PHONY: $(TESTDIRS)
+.PHONY: $(CLEANDIRS)
+.PHONY: all install clean
+
+# Create all the static targets
+static_objects = $(patsubst %.o, %.static.o, $(objects))
+static_cmds_objects = $(patsubst %.o, %.static.o, $(cmds_objects))
+static_libbtrfs_objects = $(patsubst %.o, %.static.o, $(libbtrfs_objects))
+
+# Define static compilation flags
+STATIC_CFLAGS = $(CFLAGS) -ffunction-sections -fdata-sections
+STATIC_LDFLAGS = -static -Wl,--gc-sections
+STATIC_LIBS = $(lib_LIBS) -lpthread
+
+libs_shared = libbtrfs.so.0.1
+libs_static = libbtrfs.a
+libs = $(libs_shared) $(libs_static)
+lib_links = libbtrfs.so.0 libbtrfs.so
+headers = $(libbtrfs_headers)
+
+# make C=1 to enable sparse
+check_defs := .cc-defines.h 
+ifdef C
+	#
+	# We're trying to use sparse against glibc headers which go wild
+	# trying to use internal compiler macros to test features.  We
+	# copy gcc's and give them to sparse.  But not __SIZE_TYPE__
+	# 'cause sparse defines that one.
+	#
+	dummy := $(shell $(CC) -dM -E -x c - < /dev/null | \
+			grep -v __SIZE_TYPE__ > $(check_defs))
+	check = sparse -include $(check_defs) -D__CHECKER__ \
+		-D__CHECK_ENDIAN__ -Wbitwise -Wuninitialized -Wshadow -Wundef
+	check_echo = echo
+	# don't use FORTIFY with sparse because glibc with FORTIFY can
+	# generate so many sparse errors that sparse stops parsing,
+	# which masks real errors that we want to see.
+else
+	check = true
+	check_echo = true
+	AM_CFLAGS += -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
+endif
+
+%.o.d: %.c
+	$(Q)$(CC) -MM -MG -MF $@ -MT $(@:.o.d=.o) -MT $(@:.o.d=.static.o) -MT $@ $(AM_CFLAGS) $(CFLAGS) $<
+
+.c.o:
+	@$(check_echo) "    [SP]     $<"
+	$(Q)$(check) $(AM_CFLAGS) $(CFLAGS) $<
+	@echo "    [CC]     $@"
+	$(Q)$(CC) $(AM_CFLAGS) $(CFLAGS) -c $<
+
+%.static.o: %.c
+	@echo "    [CC]     $@"
+	$(Q)$(CC) $(AM_CFLAGS) $(STATIC_CFLAGS) -c $< -o $@
+
+all: $(progs) $(BUILDDIRS)
+$(SUBDIRS): $(BUILDDIRS)
+$(BUILDDIRS):
+	@echo "Making all in $(patsubst build-%,%,$@)"
+	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst build-%,%,$@)
+
+test:
+	$(Q)for t in $(TESTS); do \
+		echo "     [TEST]    $$t"; \
+		bash tests/$$t || exit 1; \
+	done
+
+#
+# NOTE: For static compiles, you need to have all the required libs
+# 	static equivalent available
+#
+static: $(progs_static)
+
+version.h:
+	@echo "    [SH]     $@"
+	$(Q)bash version.sh
+
+$(libs_shared): $(libbtrfs_objects) $(lib_links) send.h
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) $(libbtrfs_objects) $(LDFLAGS) $(lib_LIBS) \
+		-shared -Wl,-soname,libbtrfs.so.0 -o libbtrfs.so.0.1
+
+$(libs_static): $(libbtrfs_objects)
+	@echo "    [AR]     $@"
+	$(Q)$(AR) cru libbtrfs.a $(libbtrfs_objects)
+
+$(lib_links):
+	@echo "    [LN]     $@"
+	$(Q)$(LN) -sf libbtrfs.so.0.1 libbtrfs.so.0
+	$(Q)$(LN) -sf libbtrfs.so.0.1 libbtrfs.so
+
+# keep intermediate files from the below implicit rules around
+.PRECIOUS: $(addsuffix .o,$(progs))
+
+# Make any btrfs-foo out of btrfs-foo.o, with appropriate libs.
+# The $($(subst...)) bits below takes the btrfs_*_libs definitions above and
+# turns them into a list of libraries to link against if they exist
+#
+# For static variants, use an extra $(subst) to get rid of the ".static"
+# from the target name before translating to list of libs
+
+btrfs-%.static: $(static_objects) btrfs-%.static.o $(static_libbtrfs_objects)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(STATIC_CFLAGS) -o $@ $@.o $(static_objects) \
+		$(static_libbtrfs_objects) $(STATIC_LDFLAGS) \
+		$($(subst -,_,$(subst .static,,$@)-libs)) $(STATIC_LIBS)
+
+btrfs-%: $(objects) $(libs) btrfs-%.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o $@ $(objects) $@.o $(LDFLAGS) $(LIBS) $($(subst -,_,$@-libs))
+
+btrfs: $(objects) btrfs.o help.o $(cmds_objects) $(libs)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfs btrfs.o help.o $(cmds_objects) \
+		$(objects) $(LDFLAGS) $(LIBS) -lpthread
+
+btrfs.static: $(static_objects) btrfs.static.o help.static.o $(static_cmds_objects) $(static_libbtrfs_objects)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(STATIC_CFLAGS) -o btrfs.static btrfs.static.o help.static.o $(static_cmds_objects) \
+		$(static_objects) $(static_libbtrfs_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)
+
+# For backward compatibility, 'btrfs' changes behaviour to fsck if it's named 'btrfsck'
+btrfsck: btrfs
+	@echo "    [LN]     $@"
+	$(Q)$(LN) -f btrfs btrfsck
+
+btrfsck.static: btrfs.static
+	@echo "    [LN]     $@"
+	$(Q)$(LN) -f $^ $@
+
+mkfs.btrfs: $(objects) $(libs) mkfs.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o mkfs.btrfs $(objects) mkfs.o $(LDFLAGS) $(LIBS)
+
+mkfs.btrfs.static: $(static_objects) mkfs.static.o $(static_libbtrfs_objects)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(STATIC_CFLAGS) -o mkfs.btrfs.static mkfs.static.o $(static_objects) \
+		$(static_libbtrfs_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)
+
+btrfstune: $(objects) $(libs) btrfstune.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o btrfstune $(objects) btrfstune.o $(LDFLAGS) $(LIBS)
+
+btrfstune.static: $(static_objects) btrfstune.static.o $(static_libbtrfs_objects)
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(STATIC_CFLAGS) -o $@ btrfstune.static.o $(static_objects) \
+		$(static_libbtrfs_objects) $(STATIC_LDFLAGS) $(STATIC_LIBS)
+
+dir-test: $(objects) $(libs) dir-test.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o dir-test $(objects) dir-test.o $(LDFLAGS) $(LIBS)
+
+quick-test: $(objects) $(libs) quick-test.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o quick-test $(objects) quick-test.o $(LDFLAGS) $(LIBS)
+
+ioctl-test: $(objects) $(libs) ioctl-test.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o ioctl-test $(objects) ioctl-test.o $(LDFLAGS) $(LIBS)
+
+send-test: $(objects) $(libs) send-test.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o send-test $(objects) send-test.o $(LDFLAGS) $(LIBS) -lpthread
+
+library-test: $(libs_shared) library-test.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o library-test library-test.o $(LDFLAGS) -lbtrfs
+
+library-test.static: $(libs_static) library-test.o
+	@echo "    [LD]     $@"
+	$(Q)$(CC) $(CFLAGS) -o library-test-static library-test.o $(LDFLAGS) $(libs_static)
+
+test-build:
+	$(MAKE) clean-all
+	$(MAKE) library-test
+	-$(MAKE) library-test.static
+	$(MAKE) -j 8 all
+	-$(MAKE) -j 8 static
+	$(MAKE) -j 8 $(progs_extra)
+
+manpages:
+	$(Q)$(MAKE) $(MAKEOPTS) -C Documentation
+
+clean-all: clean-doc clean
+
+clean: $(CLEANDIRS)
+	@echo "Cleaning"
+	$(Q)rm -f $(progs) cscope.out *.o *.o.d \
+	      dir-test ioctl-test quick-test send-test library-test library-test-static \
+	      btrfs.static mkfs.btrfs.static \
+	      version.h $(check_defs) \
+	      $(libs) $(lib_links) \
+	      $(progs_static) $(progs_extra)
+
+clean-doc:
+	@echo "Cleaning Documentation"
+	$(Q)$(MAKE) $(MAKEOPTS) -C Documentation clean
+
+$(CLEANDIRS):
+	@echo "Cleaning $(patsubst clean-%,%,$@)"
+	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst clean-%,%,$@) clean
+
+install: $(libs) $(progs) $(INSTALLDIRS)
+	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
+	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
+	$(INSTALL) fsck.btrfs $(DESTDIR)$(bindir)
+	# btrfsck is a link to btrfs in the src tree, make it so for installed file as well
+	$(LN) -f $(DESTDIR)$(bindir)/btrfs $(DESTDIR)$(bindir)/btrfsck
+	$(INSTALL) -m755 -d $(DESTDIR)$(libdir)
+	$(INSTALL) $(libs) $(DESTDIR)$(libdir)
+	cp -a $(lib_links) $(DESTDIR)$(libdir)
+	$(INSTALL) -m755 -d $(DESTDIR)$(incdir)
+	$(INSTALL) -m644 $(headers) $(DESTDIR)$(incdir)
+
+install-static: $(progs_static) $(INSTALLDIRS)
+	for p in $(progs_static) ; do \
+		$(INSTALL) -D -m755 $$p $(DESTDIR)$(bindir)/`basename $$p .static` ; \
+	done
+
+$(INSTALLDIRS):
+	@echo "Making install in $(patsubst install-%,%,$@)"
+	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst install-%,%,$@) install
+
+uninstall:
+	$(Q)$(MAKE) $(MAKEOPTS) -C Documentation uninstall
+	cd $(DESTDIR)$(incdir); rm -f $(headers)
+	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(incdir)
+	cd $(DESTDIR)$(libdir); rm -f $(lib_links) $(libs)
+	cd $(DESTDIR)$(bindir); rm -f btrfsck fsck.btrfs $(progs)
+
+ifneq ($(MAKECMDGOALS),clean)
+-include $(objects:.o=.o.d) $(cmd-objects:.o=.o.d) $(subst .btrfs,, $(filter-out btrfsck.o.d, $(progs:=.o.d)))
+endif
diff --git a/autogen.sh b/autogen.sh
new file mode 100755
index 0000000..0198f1f
--- /dev/null
+++ b/autogen.sh
@@ -0,0 +1,58 @@
+#!/bin/sh
+
+#
+# Helps generate autoconf stuff, when code is checked out from SCM.
+#
+# Copyright (C) 2006-2014 - Karel Zak <kzak@redhat.com>
+#
+
+srcdir=`dirname $0`
+test -z "$srcdir" && srcdir=.
+
+THEDIR=`pwd`
+cd $srcdir
+DIE=0
+
+test -f btrfs.c || {
+	echo
+	echo "You must run this script in the top-level btrfs-progs directory"
+	echo
+	DIE=1
+}
+
+(autoconf --version) < /dev/null > /dev/null 2>&1 || {
+	echo
+	echo "You must have autoconf installed to generate btrfs-progs build system."
+	echo
+	DIE=1
+}
+(autoheader --version) < /dev/null > /dev/null 2>&1 || {
+	echo
+	echo "You must have autoheader installed to generate btrfs-progs build system."
+	echo "The autoheader command is part of the GNU autoconf package."
+	echo
+	DIE=1
+}
+
+if test "$DIE" -eq 1; then
+	exit 1
+fi
+
+echo
+echo "Generate build-system by:"
+echo "   aclocal:    $(aclocal --version | head -1)"
+echo "   autoconf:   $(autoconf --version | head -1)"
+echo "   autoheader: $(autoheader --version | head -1)"
+
+chmod +x version.sh
+rm -rf autom4te.cache
+
+aclocal $AL_OPTS
+autoconf $AC_OPTS
+autoheader $AH_OPTS
+
+cd $THEDIR
+
+echo
+echo "Now type '$srcdir/configure' and 'make' to compile."
+echo
diff --git a/configure.ac b/configure.ac
new file mode 100644
index 0000000..7a6c264
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,102 @@
+AC_INIT([btrfs-progs],
+	m4_esyscmd([./version.sh --configure]),
+	[linux-btrfs@vger.kernel.org],,
+	[http://btrfs.wiki.kernel.org])
+
+
+AC_PREREQ([2.60])
+
+AC_CONFIG_AUX_DIR([config])
+dnl AC_USE_SYSTEM_EXTENSIONS must be called before any macros that run
+dnl the compiler (like AC_PROG_LIBTOOL) to avoid autoconf errors.
+AC_USE_SYSTEM_EXTENSIONS
+
+AC_CONFIG_SRCDIR([btrfs.c])
+AC_PREFIX_DEFAULT([/usr])
+
+AC_PROG_CC
+AC_CANONICAL_HOST
+AC_C_CONST
+AC_C_VOLATILE
+AC_C_BIGENDIAN
+
+AC_SYS_LARGEFILE
+
+AC_PROG_INSTALL
+
+AC_CHECK_FUNCS([openat], [],
+	[AC_MSG_ERROR([cannot find openat() function])])
+
+m4_ifndef([PKG_PROG_PKG_CONFIG],
+  [m4_fatal([Could not locate the pkg-config autoconf
+    macros. These are usually located in /usr/share/aclocal/pkg.m4.
+    If your macros are in a different location, try setting the
+    environment variable AL_OPTS="-I/other/macro/dir" before running
+    ./autogen.sh or autoreconf again.])])
+PKG_PROG_PKG_CONFIG
+
+
+dnl
+dnl Calls pkg-config --static
+dnl
+AC_DEFUN([PKG_STATIC], [
+  if AC_RUN_LOG([pkg-config --exists --print-errors "$2"]); then
+    $1=`pkg-config --libs --static "$2"`
+    AC_SUBST([$1])
+  else
+    AC_MSG_ERROR([pkg-config description of $2, needed for static build, is not available])
+  fi
+])
+
+dnl Define <NAME>_LIBS= and <NAME>_CFLAGS= by pkg-config
+dnl
+dnl The default PKG_CHECK_MODULES() action-if-not-found is end the
+dnl execution with error. The static libs are optional.
+
+PKG_CHECK_MODULES(BLKID, [blkid])
+PKG_STATIC(BLKID_LIBS_STATIC, [blkid])
+
+PKG_CHECK_MODULES(UUID, [uuid])
+PKG_STATIC(UUID_LIBS_STATIC, [uuid])
+
+PKG_CHECK_MODULES(ZLIB, [zlib])
+PKG_STATIC(ZLIB_LIBS_STATIC, [zlib])
+
+dnl lzo library does not provide pkg-config, let use classic way
+AC_CHECK_LIB([lzo2], [lzo_version], [
+	LZO2_LIBS="-llzo2"
+	LZO2_CFLAGS=""
+	LZO2_LIBS_STATIC="-llzo2"],[
+	AC_MSG_ERROR([cannot find lzo2 library])
+])
+AC_SUBST([LZO2_LIBS])
+AC_SUBST([LZO2_LIBS_STATIC])
+AC_SUBST([LZO2_CFLAGS])
+
+
+
+AC_CONFIG_HEADERS([config.h])
+
+AC_CONFIG_FILES([
+Makefile
+])
+
+AC_OUTPUT
+
+AC_MSG_RESULT([
+	${PACKAGE_NAME} ${PACKAGE_VERSION}
+
+	prefix:            ${prefix}
+	exec prefix:       ${exec_prefix}
+
+	bindir:            ${bindir}
+	libdir:            ${libdir}
+	includedir:        ${includedir}
+
+	compiler:          ${CC}
+	cflags:            ${CFLAGS}
+	ldflags:           ${LDFLAGS}
+
+	Type 'make' to compile.
+])
+
diff --git a/version.sh b/version.sh
old mode 100644
new mode 100755
index 773482d..456853c
--- a/version.sh
+++ b/version.sh
@@ -8,6 +8,7 @@
  
 v="v3.17.3"
 
+opt=$1
 lib_major=0
 lib_minor=1
 lib_patchlevel=1
@@ -28,6 +29,12 @@ if [ $? == 0 -a -d .git ]; then
     fi
 fi
 
+if [ "$opt" = "--configure" ]; then
+	# Omit the trailing newline, so that m4_esyscmd can use the result directly.
+	echo "$v" | tr -d '\n'
+	exit 0
+fi
+
 echo "/* NOTE: this file is autogenerated by version.sh, do not edit */" > .build-version.h
 echo "#ifndef __BUILD_VERSION" >> .build-version.h
 echo >> .build-version.h
-- 
1.9.3

