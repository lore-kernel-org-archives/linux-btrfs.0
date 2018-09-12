Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tty0.vserver.softronics.ch ([91.214.169.36]:32834 "EHLO
        fe1.digint.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbeILTvH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 15:51:07 -0400
Received: from mail.tty0.ch (hermes.tty0.ch [172.21.1.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by fe1.digint.ch (Postfix) with ESMTPS id 1EA6F3097A
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 16:47:13 +0200 (CEST)
From: Axel Burri <axel@tty0.ch>
To: linux-btrfs@vger.kernel.org
Cc: Axel Burri <axel@tty0.ch>
Subject: [RFC PATCH v2 4/4] btrfs-progs: build: add --enable-setcap-install, --enable-setuid-install, --enable-btrfs-separated
Date: Wed, 12 Sep 2018 16:46:04 +0200
Message-Id: <20180912144604.6178-5-axel@tty0.ch>
In-Reply-To: <20180912144604.6178-1-axel@tty0.ch>
References: <20180912144604.6178-1-axel@tty0.ch>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adds Makefile target "install-separated": install all
"btrfs-*.separated" binaries and rename to "btrfs-*". If configured
with --enable-setcap-install, also sets linux capabilities(7) using
setcap(8). If configured with "--enable-setuid-install", sets setuid
bit while installing.

Use --enable-btrfs-separated if you want to build (but not install)
all "btrfs-*.separated" binaries.

Signed-off-by: Axel Burri <axel@tty0.ch>
---
 Makefile        | 36 +++++++++++++++++++++++++++++++++++-
 Makefile.inc.in |  6 ++++++
 configure.ac    | 40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 362550c9..e0edcb75 100644
--- a/Makefile
+++ b/Makefile
@@ -232,6 +232,25 @@ progs_install =
 progs_build =
 endif
 
+ifeq ($(BUILD_BTRFS_SEPARATED),1)
+# Note: intentionally not addded to progs_install:
+# use -enable-setcap-install, --enable-setuid-install instead.
+progs_build += $(progs_separated)
+endif
+
+INSTALL_SEPARATED_OPTIONS = -m755
+ifeq ($(ENABLE_INSTALL_SETCAP),1)
+INSTALL_SEPARATED_OPTIONS = -m710
+progs_install_separated += $(progs_separated_fscaps)
+endif
+ifeq ($(ENABLE_INSTALL_SETUID),1)
+INSTALL_SEPARATED_OPTIONS = -m4710
+progs_install_separated += $(progs_separated_fscaps)
+endif
+ifdef SETCAP_GROUP
+INSTALL_SEPARATED_OPTIONS += -g$(SETCAP_GROUP)
+endif
+
 # Parse "int cmd_xxx_yyy(int argc, char **argv)" lines in cfiles, and
 # create whitespace separated map of form: "btrfs-xxx-yyy@key:value".
 sc_cfiles := $(wildcard cmds-*.c)
@@ -704,7 +723,7 @@ $(CLEANDIRS):
 	@echo "Cleaning $(patsubst clean-%,%,$@)"
 	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst clean-%,%,$@) clean
 
-install: $(libs_build) $(progs_install) $(INSTALLDIRS)
+install: $(libs_build) $(progs_install) $(progs_install_separated) $(INSTALLDIRS)
 ifeq ($(BUILD_PROGRAMS),1)
 	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
 	$(INSTALL) $(progs_install) $(DESTDIR)$(bindir)
@@ -726,6 +745,9 @@ endif
 	$(INSTALL) -m644 $(libbtrfs_headers) $(DESTDIR)$(incdir)/btrfs
 	$(INSTALL) -m644 libbtrfsutil/btrfsutil.h $(DESTDIR)$(incdir)
 endif
+ifeq ($(BUILD_BTRFS_SEPARATED),1)
+	$(Q)$(MAKE) $(MAKEOPTS) install-separated
+endif
 
 ifeq ($(PYTHON_BINDINGS),1)
 install_python: libbtrfsutil_python
@@ -741,6 +763,18 @@ install-static: $(progs_static) $(INSTALLDIRS)
 	# btrfsck is a link to btrfs in the src tree, make it so for installed file as well
 	$(LN_S) -f btrfs.static $(DESTDIR)$(bindir)/btrfsck.static
 
+# install separated btrfs binaries, set linux capabilities(7) defined
+# in "@SEPARATED" lines using setcap(8), remove ".separated" postfix
+install-btrfs-%.separated: btrfs-%.separated
+	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
+	$(INSTALL) $(INSTALL_SEPARATED_OPTIONS) $< $(DESTDIR)$(bindir)
+ifeq ($(ENABLE_INSTALL_SETCAP),1)
+	$(SETCAP) $(call sc_get,$(<:%.separated=%),fscaps)+ep $(DESTDIR)$(bindir)/$<
+endif
+	$(MV) $(DESTDIR)$(bindir)/$< $(DESTDIR)$(bindir)/$(<:%.separated=%)
+
+install-separated: $(progs_install_separated) $(patsubst %,install-%,$(progs_install_separated))
+
 $(INSTALLDIRS):
 	@echo "Making install in $(patsubst install-%,%,$@)"
 	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst install-%,%,$@) install
diff --git a/Makefile.inc.in b/Makefile.inc.in
index a86c528e..93df2edf 100644
--- a/Makefile.inc.in
+++ b/Makefile.inc.in
@@ -10,6 +10,8 @@ AR = @AR@
 RM = @RM@
 RMDIR = @RMDIR@
 INSTALL = @INSTALL@
+MV = @MV@
+SETCAP = @SETCAP@
 DISABLE_DOCUMENTATION = @DISABLE_DOCUMENTATION@
 DISABLE_BTRFSCONVERT = @DISABLE_BTRFSCONVERT@
 BUILD_PROGRAMS = @BUILD_PROGRAMS@
@@ -22,6 +24,10 @@ PYTHON_BINDINGS = @PYTHON_BINDINGS@
 PYTHON = @PYTHON@
 PYTHON_CFLAGS = @PYTHON_CFLAGS@
 
+BUILD_BTRFS_SEPARATED = @BUILD_BTRFS_SEPARATED@
+ENABLE_INSTALL_SETCAP = @ENABLE_INSTALL_SETCAP@
+ENABLE_INSTALL_SETUID = @ENABLE_INSTALL_SETUID@
+
 SUBST_CFLAGS = @CFLAGS@
 SUBST_LDFLAGS = @LDFLAGS@
 
diff --git a/configure.ac b/configure.ac
index df02f206..981250bc 100644
--- a/configure.ac
+++ b/configure.ac
@@ -39,6 +39,8 @@ AC_PROG_LN_S
 AC_CHECK_TOOL([AR], [ar])
 AC_PATH_PROG([RM], [rm], [rm])
 AC_PATH_PROG([RMDIR], [rmdir], [rmdir])
+AC_PATH_PROG([MV], [mv], [mv])
+AC_PATH_PROG([SETCAP], [setcap], [setcap])
 
 
 AC_CHECK_FUNCS([openat], [],
@@ -248,6 +250,40 @@ AS_IF([test "x$enable_python" = xyes], [PYTHON_BINDINGS=1], [PYTHON_BINDINGS=0])
 AC_SUBST(PYTHON_BINDINGS)
 AC_SUBST(PYTHON)
 
+# check whether to build/install separated btrfs binaries
+AC_ARG_ENABLE([setcap-install],
+	AS_HELP_STRING([--enable-setcap-install], [install separated binaries with capabilities]),
+	[], [enable_setcap_install=no]
+)
+AS_IF([test "x$enable_setcap_install" = xyes], [ENABLE_INSTALL_SETCAP=1], [ENABLE_INSTALL_SETCAP=0])
+AC_SUBST([ENABLE_INSTALL_SETCAP])
+AM_CONDITIONAL(SETCAP_INSTALL, test x$enable_setcap_install = xyes)
+
+AC_ARG_ENABLE([setuid-install],
+	AS_HELP_STRING([--enable-setuid-install], [install separated binaries as setuid]),
+	[], [enable_setuid_install=no]
+)
+AS_IF([test "x$enable_setuid_install" = xyes], [ENABLE_INSTALL_SETUID=1], [ENABLE_INSTALL_SETUID=0])
+AC_SUBST([ENABLE_INSTALL_SETUID])
+
+if test "x$enable_setcap_install" = "xyes"; then
+	enable_btrfs_separated=yes
+	if test "x$enable_setuid_install" = "xyes"; then
+		AC_MSG_RESULT(setcap and setuid both selected)
+		AC_MSG_ERROR(You must choose either setcap-install or setuid-install)
+	fi
+fi
+if test "x$enable_setuid_install" = "xyes"; then
+	enable_btrfs_separated=yes
+fi
+
+AC_ARG_ENABLE([btrfs-separated],
+	AS_HELP_STRING([--enable-btrfs-separated], [build separated binaries for btrfs subcommands]),
+	[], [enable_btrfs_separated=no]
+)
+AS_IF([test "x$enable_btrfs_separated" = xyes], [BUILD_BTRFS_SEPARATED=1], [BUILD_BTRFS_SEPARATED=0])
+AC_SUBST([BUILD_BTRFS_SEPARATED])
+
 # udev v190 introduced the btrfs builtin and a udev rule to use it.
 # Our udev rule gives us the friendly dm names but isn't required (or valid)
 # on earlier releases.
@@ -309,5 +345,9 @@ AC_MSG_RESULT([
 	Python bindings:    ${enable_python}
 	Python interpreter: ${PYTHON}
 
+	separated progs:    ${enable_btrfs_separated}
+	Install separated progs with capabilities: ${enable_setcap_install}
+	Install separated progs suid: ${enable_setuid_install}
+
 	Type 'make' to compile.
 ])
-- 
2.16.4
