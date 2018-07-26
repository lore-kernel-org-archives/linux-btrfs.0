Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f45.google.com ([209.85.160.45]:46484 "EHLO
        mail-pl0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730508AbeGZVxS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jul 2018 17:53:18 -0400
Received: by mail-pl0-f45.google.com with SMTP id t17-v6so1304165ply.13
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 13:34:48 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 1/2] btrfs-progs: add --disable-programs
Date: Thu, 26 Jul 2018 13:34:38 -0700
Message-Id: <776daf99050c7bfc08c292fa662f74ff9ae1fff4.1532637115.git.osandov@fb.com>
In-Reply-To: <cover.1532637115.git.osandov@fb.com>
References: <cover.1532637115.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

We have a build system internally which only needs to build and install
the libraries out of a repository, not any binaries. There's no easy way
to do this in btrfs-progs currently. Add --disable-programs to
./configure to support this.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 Makefile        | 43 ++++++++++++++++++++++++++-----------------
 Makefile.inc.in |  1 +
 configure.ac    | 10 +++++++++-
 3 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/Makefile b/Makefile
index d53f6c1d..24aa8234 100644
--- a/Makefile
+++ b/Makefile
@@ -207,23 +207,31 @@ endif
 
 MAKEOPTS = --no-print-directory Q=$(Q)
 
-# build all by default
-progs = $(progs_install) btrfsck btrfs-corrupt-block
 
-# install only selected
+# Programs to install.
 progs_install = btrfs mkfs.btrfs btrfs-map-logical btrfs-image \
-	btrfs-find-root btrfstune \
-	btrfs-select-super
+		btrfs-find-root btrfstune btrfs-select-super
 
-# other tools, not built by default
-progs_extra = btrfs-fragments
+# Programs to build.
+progs_build = $(progs_install) btrfsck btrfs-corrupt-block
 
-progs_static = $(foreach p,$(progs),$(p).static)
+# All programs. Use := instead of = so that this is expanded before we reassign
+# progs_build below.
+progs := $(progs_build) btrfs-convert btrfs-fragments
 
 ifneq ($(DISABLE_BTRFSCONVERT),1)
 progs_install += btrfs-convert
 endif
 
+# Static programs to build. Use := instead of = because `make static` should
+# still build everything even if --disable-programs was passed to ./configure.
+progs_static := $(foreach p,$(progs_build),$(p).static)
+
+ifneq ($(BUILD_PROGRAMS),1)
+progs_install =
+progs_build =
+endif
+
 # external libs required by various binaries; for btrfs-foo,
 # specify btrfs_foo_libs = <list of libs>; see $($(subst...)) rules below
 btrfs_convert_cflags = -DBTRFSCONVERT_EXT2=$(BTRFSCONVERT_EXT2)
@@ -234,7 +242,7 @@ cmds_restore_cflags = -DBTRFSRESTORE_ZSTD=$(BTRFSRESTORE_ZSTD)
 CHECKER_FLAGS += $(btrfs_convert_cflags)
 
 # collect values of the variables above
-standalone_deps = $(foreach dep,$(patsubst %,%_objects,$(subst -,_,$(filter btrfs-%, $(progs) $(progs_extra)))),$($(dep)))
+standalone_deps = $(foreach dep,$(patsubst %,%_objects,$(subst -,_,$(filter btrfs-%, $(progs)))),$($(dep)))
 
 SUBDIRS =
 BUILDDIRS = $(patsubst %,build-%,$(SUBDIRS))
@@ -303,7 +311,7 @@ endif
 	$(Q)$(CC) $(STATIC_CFLAGS) -c $< -o $@ $($(subst -,_,$(@:%.static.o=%)-cflags)) \
 		$($(subst -,_,btrfs-$(@:%/$(notdir $@)=%)-cflags))
 
-all: $(progs) $(libs) $(lib_links) $(BUILDDIRS)
+all: $(progs_build) $(libs) $(lib_links) $(BUILDDIRS)
 ifeq ($(PYTHON_BINDINGS),1)
 all: libbtrfsutil_python
 endif
@@ -570,9 +578,8 @@ test-build-pre:
 test-build-real:
 	$(MAKE) $(MAKEOPTS) library-test
 	-$(MAKE) $(MAKEOPTS) library-test.static
-	$(MAKE) $(MAKEOPTS) -j 8 all
+	$(MAKE) $(MAKEOPTS) -j 8 $(progs) $(libs) $(lib_links) $(BUILDDIRS)
 	-$(MAKE) $(MAKEOPTS) -j 8 static
-	$(MAKE) $(MAKEOPTS) -j 8 $(progs_extra)
 
 manpages:
 	$(Q)$(MAKE) $(MAKEOPTS) -C Documentation
@@ -604,7 +611,7 @@ clean: $(CLEANDIRS)
               mktables btrfs.static mkfs.btrfs.static fssum \
 	      $(check_defs) \
 	      $(libs) $(lib_links) \
-	      $(progs_static) $(progs_extra) \
+	      $(progs_static) \
 	      libbtrfsutil/*.o libbtrfsutil/*.o.d
 ifeq ($(PYTHON_BINDINGS),1)
 	$(Q)cd libbtrfsutil/python; \
@@ -629,21 +636,23 @@ $(CLEANDIRS):
 	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst clean-%,%,$@) clean
 
 install: $(libs) $(progs_install) $(INSTALLDIRS)
+ifeq ($(BUILD_PROGRAMS),1)
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(progs_install) $(DESTDIR)$(bindir)
 	$(INSTALL) fsck.btrfs $(DESTDIR)$(bindir)
 	# btrfsck is a link to btrfs in the src tree, make it so for installed file as well
 	$(LN_S) -f btrfs $(DESTDIR)$(bindir)/btrfsck
+ifneq ($(udevdir),)
+	$(INSTALL) -m755 -d $(DESTDIR)$(udevruledir)
+	$(INSTALL) -m644 $(udev_rules) $(DESTDIR)$(udevruledir)
+endif
+endif
 	$(INSTALL) -m755 -d $(DESTDIR)$(libdir)
 	$(INSTALL) $(libs) $(DESTDIR)$(libdir)
 	cp -d $(lib_links) $(DESTDIR)$(libdir)
 	$(INSTALL) -m755 -d $(DESTDIR)$(incdir)/btrfs
 	$(INSTALL) -m644 $(libbtrfs_headers) $(DESTDIR)$(incdir)/btrfs
 	$(INSTALL) -m644 libbtrfsutil/btrfsutil.h $(DESTDIR)$(incdir)
-ifneq ($(udevdir),)
-	$(INSTALL) -m755 -d $(DESTDIR)$(udevruledir)
-	$(INSTALL) -m644 $(udev_rules) $(DESTDIR)$(udevruledir)
-endif
 
 ifeq ($(PYTHON_BINDINGS),1)
 install_python: libbtrfsutil_python
diff --git a/Makefile.inc.in b/Makefile.inc.in
index fb324614..5c8d1297 100644
--- a/Makefile.inc.in
+++ b/Makefile.inc.in
@@ -12,6 +12,7 @@ RMDIR = @RMDIR@
 INSTALL = @INSTALL@
 DISABLE_DOCUMENTATION = @DISABLE_DOCUMENTATION@
 DISABLE_BTRFSCONVERT = @DISABLE_BTRFSCONVERT@
+BUILD_PROGRAMS = @BUILD_PROGRAMS@
 BTRFSCONVERT_EXT2 = @BTRFSCONVERT_EXT2@
 BTRFSCONVERT_REISERFS = @BTRFSCONVERT_REISERFS@
 BTRFSRESTORE_ZSTD = @BTRFSRESTORE_ZSTD@
diff --git a/configure.ac b/configure.ac
index 2567de12..230f37fa 100644
--- a/configure.ac
+++ b/configure.ac
@@ -118,9 +118,16 @@ if test "x$enable_documentation" = xyes; then
 fi
 AC_SUBST([ASCIIDOC_TOOL])
 
+AC_ARG_ENABLE([programs],
+	      AS_HELP_STRING([--disable-programs], [do not build utility programs]),
+	      [], [enable_programs=yes]
+)
+AS_IF([test "x$enable_programs" = xyes], [BUILD_PROGRAMS=1], [BUILD_PROGRAMS=0])
+AC_SUBST([BUILD_PROGRAMS])
+
 AC_ARG_ENABLE([convert],
 	      AS_HELP_STRING([--disable-convert], [do not build btrfs-convert]),
-  [], [enable_convert=yes]
+  [], [enable_convert=$enable_programs]
 )
 
 AS_IF([test "x$enable_convert" = xyes], [DISABLE_BTRFSCONVERT=0], [DISABLE_BTRFSCONVERT=1])
@@ -277,6 +284,7 @@ AC_MSG_RESULT([
 	cflags:             ${CFLAGS}
 	ldflags:            ${LDFLAGS}
 
+	programs:           ${enable_programs}
 	documentation:      ${enable_documentation}
 	doc generator:      ${ASCIIDOC_TOOL}
 	backtrace support:  ${enable_backtrace}
-- 
2.18.0

