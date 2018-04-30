Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 50-226-31-50-static.hfc.comcastbusiness.net ([50.226.31.50]:55553
        "EHLO linux-q7u8.site" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753022AbeD3Om2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Apr 2018 10:42:28 -0400
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 3/3 v2] btrfs-progs: build: detect whether -std=gnu90 is supported
Date: Mon, 30 Apr 2018 10:37:08 -0400
Message-Id: <1525099028-11737-3-git-send-email-jeffm@suse.com>
In-Reply-To: <1525099028-11737-1-git-send-email-jeffm@suse.com>
References: <1525099028-11737-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

GCC releases prior to 4.5.0 don't support -std=gnu90 so btrfs-progs won't
build at all on older distros.  We can detect whether the compiler
supports -std=gnu90 and fall back to -std=gnu89 if it doesn't.

AX_CHECK_COMPILE_FLAG is the right way to do this, but it depends on
autoconf 2.64.  AX_GCC_VERSION has been deprecated, so we'll use that
only for earlier autoconf versions so we can drop it when we drop
support for older autoconf releases.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 Makefile                    |  1 -
 Makefile.inc.in             |  1 +
 configure.ac                |  1 +
 m4/ax_check_compile_flag.m4 | 74 +++++++++++++++++++++++++++++++++++++++++++++
 m4/ax_gcc_version.m4        | 37 +++++++++++++++++++++++
 m4/btrfs_detect_cstd.m4     | 20 ++++++++++++
 6 files changed, 133 insertions(+), 1 deletion(-)
 create mode 100644 m4/ax_check_compile_flag.m4
 create mode 100644 m4/ax_gcc_version.m4
 create mode 100644 m4/btrfs_detect_cstd.m4

diff --git a/Makefile b/Makefile
index 5ba76d2..c0eb3d6 100644
--- a/Makefile
+++ b/Makefile
@@ -63,7 +63,6 @@ ABSTOPDIR = $(shell pwd)
 TOPDIR := .
 
 # Common build flags
-CSTD = -std=gnu90
 CFLAGS = $(SUBST_CFLAGS) \
 	 $(CSTD) \
 	 -include config.h \
diff --git a/Makefile.inc.in b/Makefile.inc.in
index 52410f6..fb32461 100644
--- a/Makefile.inc.in
+++ b/Makefile.inc.in
@@ -4,6 +4,7 @@
 export
 
 CC = @CC@
+CSTD = @BTRFS_CSTD_FLAGS@
 LN_S = @LN_S@
 AR = @AR@
 RM = @RM@
diff --git a/configure.ac b/configure.ac
index 9e5603b..4f63bb6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -26,6 +26,7 @@ AC_CONFIG_SRCDIR([btrfs.c])
 AC_PREFIX_DEFAULT([/usr/local])
 
 AC_PROG_CC
+BTRFS_DETECT_CSTD
 AC_CANONICAL_HOST
 AC_C_CONST
 AC_C_VOLATILE
diff --git a/m4/ax_check_compile_flag.m4 b/m4/ax_check_compile_flag.m4
new file mode 100644
index 0000000..dcabb92
--- /dev/null
+++ b/m4/ax_check_compile_flag.m4
@@ -0,0 +1,74 @@
+# ===========================================================================
+#  https://www.gnu.org/software/autoconf-archive/ax_check_compile_flag.html
+# ===========================================================================
+#
+# SYNOPSIS
+#
+#   AX_CHECK_COMPILE_FLAG(FLAG, [ACTION-SUCCESS], [ACTION-FAILURE], [EXTRA-FLAGS], [INPUT])
+#
+# DESCRIPTION
+#
+#   Check whether the given FLAG works with the current language's compiler
+#   or gives an error.  (Warnings, however, are ignored)
+#
+#   ACTION-SUCCESS/ACTION-FAILURE are shell commands to execute on
+#   success/failure.
+#
+#   If EXTRA-FLAGS is defined, it is added to the current language's default
+#   flags (e.g. CFLAGS) when the check is done.  The check is thus made with
+#   the flags: "CFLAGS EXTRA-FLAGS FLAG".  This can for example be used to
+#   force the compiler to issue an error when a bad flag is given.
+#
+#   INPUT gives an alternative input source to AC_COMPILE_IFELSE.
+#
+#   NOTE: Implementation based on AX_CFLAGS_GCC_OPTION. Please keep this
+#   macro in sync with AX_CHECK_{PREPROC,LINK}_FLAG.
+#
+# LICENSE
+#
+#   Copyright (c) 2008 Guido U. Draheim <guidod@gmx.de>
+#   Copyright (c) 2011 Maarten Bosmans <mkbosmans@gmail.com>
+#
+#   This program is free software: you can redistribute it and/or modify it
+#   under the terms of the GNU General Public License as published by the
+#   Free Software Foundation, either version 3 of the License, or (at your
+#   option) any later version.
+#
+#   This program is distributed in the hope that it will be useful, but
+#   WITHOUT ANY WARRANTY; without even the implied warranty of
+#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
+#   Public License for more details.
+#
+#   You should have received a copy of the GNU General Public License along
+#   with this program. If not, see <https://www.gnu.org/licenses/>.
+#
+#   As a special exception, the respective Autoconf Macro's copyright owner
+#   gives unlimited permission to copy, distribute and modify the configure
+#   scripts that are the output of Autoconf when processing the Macro. You
+#   need not follow the terms of the GNU General Public License when using
+#   or distributing such scripts, even though portions of the text of the
+#   Macro appear in them. The GNU General Public License (GPL) does govern
+#   all other use of the material that constitutes the Autoconf Macro.
+#
+#   This special exception to the GPL applies to versions of the Autoconf
+#   Macro released by the Autoconf Archive. When you make and distribute a
+#   modified version of the Autoconf Macro, you may extend this special
+#   exception to the GPL to apply to your modified version as well.
+
+#serial 5
+
+AC_DEFUN([AX_CHECK_COMPILE_FLAG],
+[AC_PREREQ(2.64)dnl for _AC_LANG_PREFIX and AS_VAR_IF
+AS_VAR_PUSHDEF([CACHEVAR],[ax_cv_check_[]_AC_LANG_ABBREV[]flags_$4_$1])dnl
+AC_CACHE_CHECK([whether _AC_LANG compiler accepts $1], CACHEVAR, [
+  ax_check_save_flags=$[]_AC_LANG_PREFIX[]FLAGS
+  _AC_LANG_PREFIX[]FLAGS="$[]_AC_LANG_PREFIX[]FLAGS $4 $1"
+  AC_COMPILE_IFELSE([m4_default([$5],[AC_LANG_PROGRAM()])],
+    [AS_VAR_SET(CACHEVAR,[yes])],
+    [AS_VAR_SET(CACHEVAR,[no])])
+  _AC_LANG_PREFIX[]FLAGS=$ax_check_save_flags])
+AS_VAR_IF(CACHEVAR,yes,
+  [m4_default([$2], :)],
+  [m4_default([$3], :)])
+AS_VAR_POPDEF([CACHEVAR])dnl
+])dnl AX_CHECK_COMPILE_FLAGS
diff --git a/m4/ax_gcc_version.m4 b/m4/ax_gcc_version.m4
new file mode 100644
index 0000000..63914d5
--- /dev/null
+++ b/m4/ax_gcc_version.m4
@@ -0,0 +1,37 @@
+dnl @synopsis AX_GCC_VERSION(MAJOR, MINOR, PATCHLEVEL, [ACTION-SUCCESS], [ACTION-FAILURE])
+dnl @summary check wither gcc is at least version MAJOR.MINOR.PATCHLEVEL
+dnl @category InstalledPackages
+dnl
+dnl Check whether we are using gcc and, if so, whether its version
+dnl is at least MAJOR.MINOR.PATCHLEVEL
+dnl
+dnl ACTION-SUCCESS/ACTION-FAILURE are shell commands to execute on
+dnl success/failure.
+dnl
+dnl @version 2005-05-30
+dnl @license GPLWithACException
+dnl @author Steven G. Johnson <stevenj@alum.mit.edu> and Matteo Frigo.
+AC_DEFUN([AX_GCC_VERSION],
+[
+AC_REQUIRE([AC_PROG_CC])
+AC_CACHE_CHECK(whether we are using gcc $1.$2.$3 or later, ax_cv_gcc_$1_$2_$3,
+[
+ax_cv_gcc_$1_$2_$3=no
+if test "$GCC" = "yes"; then
+dnl The semicolon after "yes" below is to pacify NeXT's syntax-checking cpp.
+AC_EGREP_CPP(yes, [
+#ifdef __GNUC__
+#  if (__GNUC__ > $1) || (__GNUC__ == $1 && __GNUC_MINOR__ > $2) \
+   || (__GNUC__ == $1 && __GNUC_MINOR__ == $2 && __GNUC_PATCHLEVEL__ >= $3)
+     yes;
+#  endif
+#endif
+], [ax_cv_gcc_$1_$2_$3=yes])
+fi
+])
+if test "$ax_cv_gcc_$1_$2_$3" = yes; then
+	m4_default([$4], :)
+else
+	m4_default([$5], :)
+fi
+])
diff --git a/m4/btrfs_detect_cstd.m4 b/m4/btrfs_detect_cstd.m4
new file mode 100644
index 0000000..f0c45d9
--- /dev/null
+++ b/m4/btrfs_detect_cstd.m4
@@ -0,0 +1,20 @@
+dnl We prefer -std=gnu90 but gcc versions prior to 4.5.0 don't support
+dnl it.  AX_CHECK_COMPILE_FLAG is the right way to determine whether a
+dnl particular version of gcc supports a flag, but it requires autoconf
+dnl 2.64.  Since (for now) we still want to support older releases
+dnl that ship with autoconf 2.63, we the also-deprecated AX_GCC_VERSION
+dnl macro there.
+AC_DEFUN([BTRFS_DETECT_CSTD],
+[
+ m4_version_prereq([2.64], [
+     AX_CHECK_COMPILE_FLAG([-std=gnu90],
+       [BTRFS_CSTD_FLAGS=-std=gnu90],
+       [BTRFS_CSTD_FLAGS=-std=gnu89])
+   ], [
+     AX_GCC_VERSION([4], [5], [0],
+       [BTRFS_CSTD_FLAGS=-std=gnu90],
+       [BTRFS_CSTD_FLAGS=-std=gnu89])
+   ])
+   AC_SUBST([BTRFS_CSTD_FLAGS])
+]) dnl BTRFS_DETECT_CSTD
+
-- 
1.7.12.4

