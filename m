Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:33467 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730989AbeGZVxT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Jul 2018 17:53:19 -0400
Received: by mail-pl0-f67.google.com with SMTP id 6-v6so1315807plb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Jul 2018 13:34:49 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 2/2] btrfs-progs: add --disable-shared and --disable-static
Date: Thu, 26 Jul 2018 13:34:39 -0700
Message-Id: <5c00de1c7367440a147a7afebb418ed67db3747b.1532637115.git.osandov@fb.com>
In-Reply-To: <cover.1532637115.git.osandov@fb.com>
References: <cover.1532637115.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

The build system mentioned in the previous commit builds libraries in
both PIC and non-PIC mode. Shared libraries don't work in PIC mode, so
it expects a --disable-shared configure option, which most open source
libraries using autoconf have. Let's add it, too.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 Makefile        | 17 ++++++++++++++---
 Makefile.inc.in |  2 ++
 configure.ac    | 18 +++++++++++++++++-
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 24aa8234..f4ab14ea 100644
--- a/Makefile
+++ b/Makefile
@@ -275,6 +275,13 @@ libs_shared = libbtrfs.so.0.1 libbtrfsutil.so.$(libbtrfsutil_version)
 libs_static = libbtrfs.a libbtrfsutil.a
 libs = $(libs_shared) $(libs_static)
 lib_links = libbtrfs.so.0 libbtrfs.so libbtrfsutil.so.$(libbtrfsutil_major) libbtrfsutil.so
+libs_build =
+ifeq ($(BUILD_SHARED_LIBRARIES),1)
+libs_build += $(libs_shared) $(lib_links)
+endif
+ifeq ($(BUILD_STATIC_LIBRARIES),1)
+libs_build += $(libs_static)
+endif
 
 # make C=1 to enable sparse
 ifdef C
@@ -311,7 +318,7 @@ endif
 	$(Q)$(CC) $(STATIC_CFLAGS) -c $< -o $@ $($(subst -,_,$(@:%.static.o=%)-cflags)) \
 		$($(subst -,_,btrfs-$(@:%/$(notdir $@)=%)-cflags))
 
-all: $(progs_build) $(libs) $(lib_links) $(BUILDDIRS)
+all: $(progs_build) $(libs_build) $(BUILDDIRS)
 ifeq ($(PYTHON_BINDINGS),1)
 all: libbtrfsutil_python
 endif
@@ -635,7 +642,7 @@ $(CLEANDIRS):
 	@echo "Cleaning $(patsubst clean-%,%,$@)"
 	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst clean-%,%,$@) clean
 
-install: $(libs) $(progs_install) $(INSTALLDIRS)
+install: $(libs_build) $(progs_install) $(INSTALLDIRS)
 ifeq ($(BUILD_PROGRAMS),1)
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(progs_install) $(DESTDIR)$(bindir)
@@ -647,12 +654,16 @@ ifneq ($(udevdir),)
 	$(INSTALL) -m644 $(udev_rules) $(DESTDIR)$(udevruledir)
 endif
 endif
+ifneq ($(libs_build),)
 	$(INSTALL) -m755 -d $(DESTDIR)$(libdir)
-	$(INSTALL) $(libs) $(DESTDIR)$(libdir)
+	$(INSTALL) $(libs_build) $(DESTDIR)$(libdir)
+ifeq ($(BUILD_SHARED_LIBRARIES),1)
 	cp -d $(lib_links) $(DESTDIR)$(libdir)
+endif
 	$(INSTALL) -m755 -d $(DESTDIR)$(incdir)/btrfs
 	$(INSTALL) -m644 $(libbtrfs_headers) $(DESTDIR)$(incdir)/btrfs
 	$(INSTALL) -m644 libbtrfsutil/btrfsutil.h $(DESTDIR)$(incdir)
+endif
 
 ifeq ($(PYTHON_BINDINGS),1)
 install_python: libbtrfsutil_python
diff --git a/Makefile.inc.in b/Makefile.inc.in
index 5c8d1297..a86c528e 100644
--- a/Makefile.inc.in
+++ b/Makefile.inc.in
@@ -13,6 +13,8 @@ INSTALL = @INSTALL@
 DISABLE_DOCUMENTATION = @DISABLE_DOCUMENTATION@
 DISABLE_BTRFSCONVERT = @DISABLE_BTRFSCONVERT@
 BUILD_PROGRAMS = @BUILD_PROGRAMS@
+BUILD_SHARED_LIBRARIES = @BUILD_SHARED_LIBRARIES@
+BUILD_STATIC_LIBRARIES = @BUILD_STATIC_LIBRARIES@
 BTRFSCONVERT_EXT2 = @BTRFSCONVERT_EXT2@
 BTRFSCONVERT_REISERFS = @BTRFSCONVERT_REISERFS@
 BTRFSRESTORE_ZSTD = @BTRFSRESTORE_ZSTD@
diff --git a/configure.ac b/configure.ac
index 230f37fa..df02f206 100644
--- a/configure.ac
+++ b/configure.ac
@@ -125,6 +125,20 @@ AC_ARG_ENABLE([programs],
 AS_IF([test "x$enable_programs" = xyes], [BUILD_PROGRAMS=1], [BUILD_PROGRAMS=0])
 AC_SUBST([BUILD_PROGRAMS])
 
+AC_ARG_ENABLE([shared],
+	      AS_HELP_STRING([--disable-shared], [do not build shared libraries]),
+	      [], [enable_shared=yes]
+)
+AS_IF([test "x$enable_shared" = xyes], [BUILD_SHARED_LIBRARIES=1], [BUILD_SHARED_LIBRARIES=0])
+AC_SUBST([BUILD_SHARED_LIBRARIES])
+
+AC_ARG_ENABLE([static],
+	      AS_HELP_STRING([--disable-static], [do not build static libraries]),
+	      [], [enable_static=yes]
+)
+AS_IF([test "x$enable_static" = xyes], [BUILD_STATIC_LIBRARIES=1], [BUILD_STATIC_LIBRARIES=0])
+AC_SUBST([BUILD_STATIC_LIBRARIES])
+
 AC_ARG_ENABLE([convert],
 	      AS_HELP_STRING([--disable-convert], [do not build btrfs-convert]),
   [], [enable_convert=$enable_programs]
@@ -222,7 +236,7 @@ AC_SUBST(BTRFSRESTORE_ZSTD)
 
 AC_ARG_ENABLE([python],
 	AS_HELP_STRING([--disable-python], [do not build libbtrfsutil Python bindings]),
-	[], [enable_python=yes]
+	[], [enable_python=$enable_shared]
 )
 
 if test "x$enable_python" = xyes; then
@@ -285,6 +299,8 @@ AC_MSG_RESULT([
 	ldflags:            ${LDFLAGS}
 
 	programs:           ${enable_programs}
+	shared libraries:   ${enable_shared}
+	static libraries:   ${enable_static}
 	documentation:      ${enable_documentation}
 	doc generator:      ${ASCIIDOC_TOOL}
 	backtrace support:  ${enable_backtrace}
-- 
2.18.0

