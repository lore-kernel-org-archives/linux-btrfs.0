Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:33117 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752809AbeDKJAI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Apr 2018 05:00:08 -0400
Received: by mail-pl0-f65.google.com with SMTP id s10-v6so921847plp.0
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Apr 2018 02:00:08 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 2/2] btrfs-progs: make all programs and libraries optional
Date: Wed, 11 Apr 2018 01:59:59 -0700
Message-Id: <071315a4f7290d0ca669d5ec1a8bbef7d10ac38b.1523437169.git.osandov@fb.com>
In-Reply-To: <aad7571b405df8681347642c2e62cebc375919ce.1523437169.git.osandov@fb.com>
References: <aad7571b405df8681347642c2e62cebc375919ce.1523437169.git.osandov@fb.com>
In-Reply-To: <aad7571b405df8681347642c2e62cebc375919ce.1523437169.git.osandov@fb.com>
References: <aad7571b405df8681347642c2e62cebc375919ce.1523437169.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

We have a build system internally which only needs to build the
libraries out of a repository, not any binaries. I looked at how this
works with other projects, and the best example was util-linux, which
makes it possible to enable or disable everything individually. This is
nice and really flexible, so let's do the same. This way, if you only
want to build and install libbtrfsutil, you can simply do

  ./configure --disable-documentation --disable-all-programs --enable-libbtrfsutil
  make
  make install

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 Makefile        | 129 +++++++++++++++++++++++++++++++-------------
 Makefile.inc.in |  16 +++++-
 configure.ac    | 138 +++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 226 insertions(+), 57 deletions(-)

diff --git a/Makefile b/Makefile
index 5f27011c..74bd118c 100644
--- a/Makefile
+++ b/Makefile
@@ -206,22 +206,40 @@ endif
 
 MAKEOPTS = --no-print-directory Q=$(Q)
 
-# build all by default
-progs = $(progs_install) btrfsck btrfs-corrupt-block
-
-# install only selected
-progs_install = btrfs mkfs.btrfs btrfs-map-logical btrfs-image \
-	btrfs-find-root btrfstune \
-	btrfs-select-super
-
-# other tools, not built by default
-progs_extra = btrfs-fragments
-
-progs_static = $(foreach p,$(progs),$(p).static)
-
-ifneq ($(DISABLE_BTRFSCONVERT),1)
+ifeq ($(BUILD_BTRFS),1)
+progs_install += btrfs
+progs += btrfsck
+endif
+ifeq ($(BUILD_CONVERT),1)
 progs_install += btrfs-convert
 endif
+ifeq ($(BUILD_CORRUPT_BLOCK),1)
+progs += btrfs-corrupt-block
+endif
+ifeq ($(BUILD_FIND_ROOT),1)
+progs_install += btrfs-find-root
+endif
+ifeq ($(BUILD_FRAGMENTS),1)
+progs += btrfs-fragments
+endif
+ifeq ($(BUILD_IMAGE),1)
+progs_install += btrfs-image
+endif
+ifeq ($(BUILD_MAP_LOGICAL),1)
+progs_install += btrfs-map-logical
+endif
+ifeq ($(BUILD_MKFS),1)
+progs_install += mkfs.btrfs
+endif
+ifeq ($(BUILD_SELECT_SUPER),1)
+progs_install += btrfs-select-super
+endif
+ifeq ($(BUILD_TUNE),1)
+progs_install += btrfstune
+endif
+
+progs += $(progs_install)
+progs_static = $(foreach p,$(progs),$(p).static)
 
 # external libs required by various binaries; for btrfs-foo,
 # specify btrfs_foo_libs = <list of libs>; see $($(subst...)) rules below
@@ -233,7 +251,7 @@ cmds_restore_cflags = -DBTRFSRESTORE_ZSTD=$(BTRFSRESTORE_ZSTD)
 CHECKER_FLAGS += $(btrfs_convert_cflags)
 
 # collect values of the variables above
-standalone_deps = $(foreach dep,$(patsubst %,%_objects,$(subst -,_,$(filter btrfs-%, $(progs) $(progs_extra)))),$($(dep)))
+standalone_deps = $(foreach dep,$(patsubst %,%_objects,$(subst -,_,$(filter btrfs-%, $(progs)))),$($(dep)))
 
 SUBDIRS =
 BUILDDIRS = $(patsubst %,build-%,$(SUBDIRS))
@@ -262,10 +280,21 @@ static_convert_objects = $(patsubst %.o, %.static.o, $(convert_objects))
 static_mkfs_objects = $(patsubst %.o, %.static.o, $(mkfs_objects))
 static_image_objects = $(patsubst %.o, %.static.o, $(image_objects))
 
-libs_shared = libbtrfs.so.0.1 libbtrfsutil.so.$(libbtrfsutil_version)
-libs_static = libbtrfs.a libbtrfsutil.a
+ifeq ($(BUILD_LIBBTRFS),1)
+ifeq ($(BUILD_SHARED),1)
+libs_shared += libbtrfs.so.0.1
+lib_links += libbtrfs.so.0 libbtrfs.so
+endif
+libs_static += libbtrfs.a
+endif
+ifeq ($(BUILD_LIBBTRFSUTIL),1)
+ifeq ($(BUILD_SHARED),1)
+libs_shared += libbtrfsutil.so.$(libbtrfsutil_version)
+lib_links += libbtrfsutil.so.$(libbtrfsutil_major) libbtrfsutil.so
+endif
+libs_static += libbtrfsutil.a
+endif
 libs = $(libs_shared) $(libs_static)
-lib_links = libbtrfs.so.0 libbtrfs.so libbtrfsutil.so.$(libbtrfsutil_major) libbtrfsutil.so
 
 # make C=1 to enable sparse
 ifdef C
@@ -303,7 +332,7 @@ endif
 		$($(subst -,_,btrfs-$(@:%/$(notdir $@)=%)-cflags))
 
 all: $(progs) $(libs) $(lib_links) $(BUILDDIRS)
-ifeq ($(PYTHON_BINDINGS),1)
+ifeq ($(BUILD_PYTHON),1)
 all: libbtrfsutil_python
 endif
 $(SUBDIRS): $(BUILDDIRS)
@@ -353,7 +382,7 @@ testsuite: btrfs-corrupt-block fssum
 	@echo "Export tests as a package"
 	$(Q)cd tests && ./export-testsuite.sh
 
-ifeq ($(PYTHON_BINDINGS),1)
+ifeq ($(BUILD_PYTHON),1)
 test-libbtrfsutil: libbtrfsutil_python mkfs.btrfs
 	$(Q)cd libbtrfsutil/python; \
 		LD_LIBRARY_PATH=../.. $(PYTHON) -m unittest discover -v tests
@@ -413,7 +442,7 @@ libbtrfsutil.so.$(libbtrfsutil_major) libbtrfsutil.so: libbtrfsutil.so.$(libbtrf
 	@echo "    [LN]     $@"
 	$(Q)$(LN_S) -f $< $@
 
-ifeq ($(PYTHON_BINDINGS),1)
+ifeq ($(BUILD_PYTHON),1)
 libbtrfsutil_python: libbtrfsutil.so.$(libbtrfsutil_major) libbtrfsutil.so libbtrfsutil/btrfsutil.h
 	@echo "    [PY]     libbtrfsutil"
 	$(Q)cd libbtrfsutil/python; \
@@ -439,14 +468,14 @@ btrfs-%.static: btrfs-%.static.o $(static_objects) $(patsubst %.o,%.static.o,$(s
 		$(static_libbtrfs_objects) $(STATIC_LDFLAGS) \
 		$($(subst -,_,$(subst .static,,$@)-libs)) $(STATIC_LIBS)
 
-btrfs-%: btrfs-%.o $(objects) $(standalone_deps) $(libs_static)
+btrfs-%: btrfs-%.o $(objects) $(standalone_deps) libbtrfs.a libbtrfsutil.a
 	@echo "    [LD]     $@"
 	$(Q)$(CC) -o $@ $(objects) $@.o \
 		$($(subst -,_,$@-objects)) \
-		$(libs_static) \
+		libbtrfs.a libbtrfsutil.a \
 		$(LDFLAGS) $(LIBS) $($(subst -,_,$@-libs))
 
-btrfs: btrfs.o $(objects) $(cmds_objects) $(libs_static)
+btrfs: btrfs.o $(objects) $(cmds_objects) libbtrfs.a libbtrfsutil.a
 	@echo "    [LD]     $@"
 	$(Q)$(CC) -o $@ $^ $(LDFLAGS) $(LIBS) $(LIBS_COMP)
 
@@ -463,7 +492,7 @@ btrfsck.static: btrfs.static
 	@echo "    [LN]     $@"
 	$(Q)$(LN_S) -f $^ $@
 
-mkfs.btrfs: $(mkfs_objects) $(objects) $(libs_static)
+mkfs.btrfs: $(mkfs_objects) $(objects) libbtrfs.a libbtrfsutil.a
 	@echo "    [LD]     $@"
 	$(Q)$(CC) -o $@ $^ $(LDFLAGS) $(LIBS)
 
@@ -471,7 +500,7 @@ mkfs.btrfs.static: $(static_mkfs_objects) $(static_objects) $(static_libbtrfs_ob
 	@echo "    [LD]     $@"
 	$(Q)$(CC) -o $@ $^ $(STATIC_LDFLAGS) $(STATIC_LIBS)
 
-btrfstune: btrfstune.o $(objects) $(libs_static)
+btrfstune: btrfstune.o $(objects) libbtrfs.a libbtrfsutil.a
 	@echo "    [LD]     $@"
 	$(Q)$(CC) -o $@ $^ $(LDFLAGS) $(LIBS)
 
@@ -479,7 +508,7 @@ btrfstune.static: btrfstune.static.o $(static_objects) $(static_libbtrfs_objects
 	@echo "    [LD]     $@"
 	$(Q)$(CC) -o $@ $^ $(STATIC_LDFLAGS) $(STATIC_LIBS)
 
-btrfs-image: $(image_objects) $(objects) $(libs_static)
+btrfs-image: $(image_objects) $(objects) libbtrfs.a libbtrfsutil.a
 	@echo "    [LD]     $@"
 	$(Q)$(CC) -o $@ $^ $(LDFLAGS) $(LIBS) $(LIBS_COMP)
 
@@ -487,7 +516,7 @@ btrfs-image.static: $(static_image_objects) $(static_objects) $(static_libbtrfs_
 	@echo "    [LD]     $@"
 	$(Q)$(CC) -o $@ $^ $(STATIC_LDFLAGS) $(STATIC_LIBS) $(STATIC_LIBS_COMP)
 
-btrfs-convert: $(convert_objects) $(objects) $(libs_static)
+btrfs-convert: $(convert_objects) $(objects) libbtrfs.a libbtrfsutil.a
 	@echo "    [LD]     $@"
 	$(Q)$(CC) -o $@ $^ $(LDFLAGS) $(btrfs_convert_libs) $(LIBS)
 
@@ -541,7 +570,7 @@ library-test: library-test.c libbtrfs.so
 	@echo "    [TEST CLEAN] $@"
 	$(Q)$(RM) -rf -- $(TMPD)
 
-library-test.static: library-test.c $(libs_static)
+library-test.static: library-test.c libbtrfs.a
 	@echo "    [TEST PREP]  $@"$(eval TMPD=$(shell mktemp -d))
 	$(Q)mkdir -p $(TMPD)/include/btrfs && \
 	cp $(libbtrfs_headers) $(TMPD)/include/btrfs && \
@@ -567,7 +596,6 @@ test-build-real:
 	-$(MAKE) $(MAKEOPTS) library-test.static
 	$(MAKE) $(MAKEOPTS) -j 8 all
 	-$(MAKE) $(MAKEOPTS) -j 8 static
-	$(MAKE) $(MAKEOPTS) -j 8 $(progs_extra)
 
 manpages:
 	$(Q)$(MAKE) $(MAKEOPTS) -C Documentation
@@ -598,10 +626,10 @@ clean: $(CLEANDIRS)
 	      ioctl-test library-test library-test-static \
               mktables btrfs.static mkfs.btrfs.static fssum \
 	      $(check_defs) \
-	      $(libs) $(lib_links) \
-	      $(progs_static) $(progs_extra) \
+	      libbtrfs.a libbtrfs.so* libbtrfsutil.a libbtrfsutil.so* \
+	      $(progs_static) \
 	      libbtrfsutil/*.o libbtrfsutil/*.o.d
-ifeq ($(PYTHON_BINDINGS),1)
+ifeq ($(BUILD_PYTHON),1)
 	$(Q)cd libbtrfsutil/python; \
 		$(PYTHON) setup.py $(SETUP_PY_Q) clean -a
 endif
@@ -624,23 +652,36 @@ $(CLEANDIRS):
 	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst clean-%,%,$@) clean
 
 install: $(libs) $(progs_install) $(INSTALLDIRS)
+ifneq ($(progs_install),)
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(progs_install) $(DESTDIR)$(bindir)
+endif
+ifeq ($(BUILD_BTRFS),1)
 	$(INSTALL) fsck.btrfs $(DESTDIR)$(bindir)
 	# btrfsck is a link to btrfs in the src tree, make it so for installed file as well
 	$(LN_S) -f btrfs $(DESTDIR)$(bindir)/btrfsck
+ifneq ($(udevdir),)
+	$(INSTALL) -m755 -d $(DESTDIR)$(udevruledir)
+	$(INSTALL) -m644 $(udev_rules) $(DESTDIR)$(udevruledir)
+endif
+endif
+ifneq ($(libs),)
 	$(INSTALL) -m755 -d $(DESTDIR)$(libdir)
 	$(INSTALL) $(libs) $(DESTDIR)$(libdir)
+ifneq ($(lib_links),)
 	cp -d $(lib_links) $(DESTDIR)$(libdir)
+endif
+endif
+ifeq ($(BUILD_LIBBTRFS),1)
 	$(INSTALL) -m755 -d $(DESTDIR)$(incdir)/btrfs
 	$(INSTALL) -m644 $(libbtrfs_headers) $(DESTDIR)$(incdir)/btrfs
+endif
+ifeq ($(BUILD_LIBBTRFSUTIL),1)
+	$(INSTALL) -m755 -d $(DESTDIR)$(incdir)
 	$(INSTALL) -m644 libbtrfsutil/btrfsutil.h $(DESTDIR)$(incdir)
-ifneq ($(udevdir),)
-	$(INSTALL) -m755 -d $(DESTDIR)$(udevruledir)
-	$(INSTALL) -m644 $(udev_rules) $(DESTDIR)$(udevruledir)
 endif
 
-ifeq ($(PYTHON_BINDINGS),1)
+ifeq ($(BUILD_PYTHON),1)
 install_python: libbtrfsutil_python
 	$(Q)cd libbtrfsutil/python; \
 		$(PYTHON) setup.py install --skip-build $(if $(DESTDIR),--root $(DESTDIR)) --prefix $(prefix)
@@ -649,22 +690,36 @@ install_python: libbtrfsutil_python
 endif
 
 install-static: $(progs_static) $(INSTALLDIRS)
+ifneq ($(progs_static),)
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(progs_static) $(DESTDIR)$(bindir)
+endif
+ifeq ($(BUILD_BTRFS),1)
 	# btrfsck is a link to btrfs in the src tree, make it so for installed file as well
 	$(LN_S) -f btrfs.static $(DESTDIR)$(bindir)/btrfsck.static
+endif
 
 $(INSTALLDIRS):
 	@echo "Making install in $(patsubst install-%,%,$@)"
 	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst install-%,%,$@) install
 
 uninstall:
+ifneq ($(DISABLE_DOCUMENTATION),1)
 	$(Q)$(MAKE) $(MAKEOPTS) -C Documentation uninstall
+endif
+ifeq ($(BUILD_LIBBTRFS),1)
 	cd $(DESTDIR)$(incdir)/btrfs; $(RM) -f -- $(libbtrfs_headers)
 	$(RMDIR) -p --ignore-fail-on-non-empty -- $(DESTDIR)$(incdir)/btrfs
+endif
+ifeq ($(BUILD_LIBBTRFSUTIL),1)
 	cd $(DESTDIR)$(incdir); $(RM) -f -- btrfsutil.h
+endif
+ifneq ($(libs) $(lib_links),)
 	cd $(DESTDIR)$(libdir); $(RM) -f -- $(lib_links) $(libs)
+endif
+ifneq ($(progs_install),)
 	cd $(DESTDIR)$(bindir); $(RM) -f -- btrfsck fsck.btrfs $(progs_install)
+endif
 
 ifneq ($(MAKECMDGOALS),clean)
 -include $(all_objects:.o=.o.d) $(subst .btrfs,, $(filter-out btrfsck.o.d, $(progs:=.o.d)))
diff --git a/Makefile.inc.in b/Makefile.inc.in
index 52410f69..eae4dfbe 100644
--- a/Makefile.inc.in
+++ b/Makefile.inc.in
@@ -10,11 +10,23 @@ RM = @RM@
 RMDIR = @RMDIR@
 INSTALL = @INSTALL@
 DISABLE_DOCUMENTATION = @DISABLE_DOCUMENTATION@
-DISABLE_BTRFSCONVERT = @DISABLE_BTRFSCONVERT@
+BUILD_BTRFS = @BUILD_BTRFS@
+BUILD_CONVERT = @BUILD_CONVERT@
+BUILD_CORRUPT_BLOCK = @BUILD_CORRUPT_BLOCK@
+BUILD_FIND_ROOT = @BUILD_FIND_ROOT@
+BUILD_FRAGMENTS = @BUILD_FRAGMENTS@
+BUILD_IMAGE = @BUILD_IMAGE@
+BUILD_MAP_LOGICAL = @BUILD_MAP_LOGICAL@
+BUILD_MKFS = @BUILD_MKFS@
+BUILD_SELECT_SUPER = @BUILD_SELECT_SUPER@
+BUILD_TUNE = @BUILD_TUNE@
 BTRFSCONVERT_EXT2 = @BTRFSCONVERT_EXT2@
 BTRFSCONVERT_REISERFS = @BTRFSCONVERT_REISERFS@
 BTRFSRESTORE_ZSTD = @BTRFSRESTORE_ZSTD@
-PYTHON_BINDINGS = @PYTHON_BINDINGS@
+BUILD_LIBBTRFS = @BUILD_LIBBTRFS@
+BUILD_LIBBTRFSUTIL = @BUILD_LIBBTRFSUTIL@
+BUILD_PYTHON = @BUILD_PYTHON@
+BUILD_SHARED = @BUILD_SHARED@
 PYTHON = @PYTHON@
 PYTHON_CFLAGS = @PYTHON_CFLAGS@
 
diff --git a/configure.ac b/configure.ac
index af13a959..5b5e5db1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -113,13 +113,129 @@ if test "x$enable_documentation" = xyes; then
 fi
 AC_SUBST([ASCIIDOC_TOOL])
 
+AC_ARG_ENABLE([all-programs],
+  AS_HELP_STRING([--disable-all-programs], [disable everything, might be overridden by --enable-<name>]),
+  [], [enable_all_programs=undefined]
+)
+
+AS_CASE([$enable_all_programs],
+  [yes], [AC_MSG_WARN([force to build all programs by default])
+          default_estate=yes],
+  [no],  [AC_MSG_WARN([disable all programs by default])
+          default_estate=no]
+)
+
+AC_DEFUN([DEFAULT_ENABLE], [
+  m4_define([suffix], $1)
+  if test "x$default_estate" != x; then
+    enable_[]suffix=$default_estate
+  else
+    enable_[]suffix=$2
+  fi
+])
+
+AC_ARG_ENABLE([btrfs],
+	      AS_HELP_STRING([--disable-btrfs], [do not build btrfs]),
+	      [], [DEFAULT_ENABLE([btrfs], [yes])]
+)
+AS_IF([test "x$enable_btrfs" = xyes], [BUILD_BTRFS=1], [BUILD_BTRFS=0])
+AC_SUBST([BUILD_BTRFS])
+
 AC_ARG_ENABLE([convert],
 	      AS_HELP_STRING([--disable-convert], [do not build btrfs-convert]),
-  [], [enable_convert=yes]
+	      [], [DEFAULT_ENABLE([convert], [yes])]
+)
+AS_IF([test "x$enable_convert" = xyes], [BUILD_CONVERT=1], [BUILD_CONVERT=0])
+AC_SUBST([BUILD_CONVERT])
+
+AC_ARG_ENABLE([corrupt-block],
+	      AS_HELP_STRING([--disable-corrupt-block], [do not build btrfs-corrupt-block]),
+	      [], [DEFAULT_ENABLE([corrupt_block], [yes])]
 )
+AS_IF([test "x$enable_corrupt_block" = xyes], [BUILD_CORRUPT_BLOCK=1], [BUILD_CORRUPT_BLOCK=0])
+AC_SUBST([BUILD_CORRUPT_BLOCK])
 
-AS_IF([test "x$enable_convert" = xyes], [DISABLE_BTRFSCONVERT=0], [DISABLE_BTRFSCONVERT=1])
-AC_SUBST([DISABLE_BTRFSCONVERT])
+AC_ARG_ENABLE([find-root],
+	      AS_HELP_STRING([--disable-find-root], [do not build btrfs-find-root]),
+	      [], [DEFAULT_ENABLE([find_root], [yes])]
+)
+AS_IF([test "x$enable_find_root" = xyes], [BUILD_FIND_ROOT=1], [BUILD_FIND_ROOT=0])
+AC_SUBST([BUILD_FIND_ROOT])
+
+AC_ARG_ENABLE([fragments],
+	      AS_HELP_STRING([--enable-fragments], [build btrfs-fragments]),
+	      [], [DEFAULT_ENABLE([fragments], [no])]
+)
+AS_IF([test "x$enable_fragments" = xyes], [BUILD_FRAGMENTS=1], [BUILD_FRAGMENTS=0])
+AC_SUBST([BUILD_FRAGMENTS])
+
+AC_ARG_ENABLE([image],
+	      AS_HELP_STRING([--disable-image], [do not build btrfs-image]),
+	      [], [DEFAULT_ENABLE([image], [yes])]
+)
+AS_IF([test "x$enable_image" = xyes], [BUILD_IMAGE=1], [BUILD_IMAGE=0])
+AC_SUBST([BUILD_IMAGE])
+
+AC_ARG_ENABLE([map-logical],
+	      AS_HELP_STRING([--disable-map-logical], [do not build btrfs-map-logical]),
+	      [], [DEFAULT_ENABLE([map_logical], [yes])]
+)
+AS_IF([test "x$enable_map_logical" = xyes], [BUILD_MAP_LOGICAL=1], [BUILD_MAP_LOGICAL=0])
+AC_SUBST([BUILD_MAP_LOGICAL])
+
+AC_ARG_ENABLE([mkfs],
+	      AS_HELP_STRING([--disable-mkfs], [do not build mkfs.btrfs]),
+	      [], [DEFAULT_ENABLE([mkfs], [yes])]
+)
+AS_IF([test "x$enable_mkfs" = xyes], [BUILD_MKFS=1], [BUILD_MKFS=0])
+AC_SUBST([BUILD_MKFS])
+
+AC_ARG_ENABLE([select-super],
+	      AS_HELP_STRING([--disable-select-super], [do not build btrfs-select-super]),
+	      [], [DEFAULT_ENABLE([select_super], [yes])]
+)
+AS_IF([test "x$enable_select_super" = xyes], [BUILD_SELECT_SUPER=1], [BUILD_SELECT_SUPER=0])
+AC_SUBST([BUILD_SELECT_SUPER])
+
+AC_ARG_ENABLE([tune],
+	      AS_HELP_STRING([--disable-tune], [do not build btrfstune]),
+	      [], [DEFAULT_ENABLE([tune], [yes])]
+)
+AS_IF([test "x$enable_tune" = xyes], [BUILD_TUNE=1], [BUILD_TUNE=0])
+AC_SUBST([BUILD_TUNE])
+
+AC_ARG_ENABLE([libbtrfs],
+	      AS_HELP_STRING([--disable-libbtrfs], [do not build libbtrfs]),
+	      [], [DEFAULT_ENABLE([libbtrfs], [yes])]
+)
+AS_IF([test "x$enable_libbtrfs" = xyes], [BUILD_LIBBTRFS=1], [BUILD_LIBBTRFS=0])
+AC_SUBST([BUILD_LIBBTRFS])
+
+AC_ARG_ENABLE([libbtrfsutil],
+	      AS_HELP_STRING([--disable-libbtrfsutil], [do not build libbtrfsutil]),
+	      [], [DEFAULT_ENABLE([libbtrfsutil], [yes])]
+)
+AS_IF([test "x$enable_libbtrfsutil" = xyes], [BUILD_LIBBTRFSUTIL=1], [BUILD_LIBBTRFSUTIL=0])
+AC_SUBST([BUILD_LIBBTRFSUTIL])
+
+AC_ARG_ENABLE([python],
+	      AS_HELP_STRING([--disable-python], [do not build libbtrfsutil Python bindings]),
+	      [], [DEFAULT_ENABLE([python], [yes])]
+)
+AS_IF([test "x$enable_python" = xyes], [BUILD_PYTHON=1], [BUILD_PYTHON=0])
+AC_SUBST([BUILD_PYTHON])
+AC_SUBST([PYTHON])
+if test "x$enable_python" = xyes; then
+	AM_PATH_PYTHON([3.4])
+	PKG_CHECK_MODULES(PYTHON, [python-${PYTHON_VERSION}])
+fi
+
+AC_ARG_ENABLE([shared],
+	      AS_HELP_STRING([--disable-shared], [do not build shared libraries]),
+	      [], [DEFAULT_ENABLE([shared], [yes])]
+)
+AS_IF([test "x$enable_shared" = xyes], [BUILD_SHARED=1], [BUILD_SHARED=0])
+AC_SUBST([BUILD_SHARED])
 
 AC_ARG_WITH([convert],
 	    AS_HELP_STRING([[[]--with-convert[[=auto]]]], [built-in filesystems for convert (default: auto)
@@ -170,7 +286,7 @@ if ! test "x$tmp" = "x"; then
 	AC_MSG_ERROR([unknown tokens for --with-convert: $tmp])
 fi
 
-if test "$DISABLE_BTRFSCONVERT" = 0 && test "x$convertfs" = "x"; then
+if test "$BUILD_BTRFSCONVERT" = 1 && test "x$convertfs" = "x"; then
 	AC_MSG_ERROR([no filesystems for convert, use --disable-convert instead])
 fi
 
@@ -212,20 +328,6 @@ fi
 AS_IF([test "x$enable_zstd" = xyes], [BTRFSRESTORE_ZSTD=1], [BTRFSRESTORE_ZSTD=0])
 AC_SUBST(BTRFSRESTORE_ZSTD)
 
-AC_ARG_ENABLE([python],
-	AS_HELP_STRING([--disable-python], [do not build libbtrfsutil Python bindings]),
-	[], [enable_python=yes]
-)
-
-if test "x$enable_python" = xyes; then
-	AM_PATH_PYTHON([3.4])
-	PKG_CHECK_MODULES(PYTHON, [python-${PYTHON_VERSION}])
-fi
-
-AS_IF([test "x$enable_python" = xyes], [PYTHON_BINDINGS=1], [PYTHON_BINDINGS=0])
-AC_SUBST(PYTHON_BINDINGS)
-AC_SUBST(PYTHON)
-
 # udev v190 introduced the btrfs builtin and a udev rule to use it.
 # Our udev rule gives us the friendly dm names but isn't required (or valid)
 # on earlier releases.
-- 
2.17.0

