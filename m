Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42190 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758020AbeD0S4x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 14:56:53 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2AAFBADAE
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 18:56:52 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 2/3] btrfs-progs: build: detect whether -std=gnu90 is supported
Date: Fri, 27 Apr 2018 14:56:36 -0400
Message-Id: <20180427185637.16642-3-jeffm@suse.com>
In-Reply-To: <20180427185637.16642-1-jeffm@suse.com>
References: <20180427185637.16642-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

Older versions of gcc don't support -std=gnu90 so btrfs-progs won't
build at all on older distros.  We can detect whether the compiler
supports -std=gnu90 and fall back to -std=gnu89 if it doesn't.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 Makefile                    |  1 -
 Makefile.inc.in             |  1 +
 configure.ac                |  2 ++
 m4/ax_check_compile_flag.m4 | 74 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 77 insertions(+), 1 deletion(-)
 create mode 100644 m4/ax_check_compile_flag.m4

diff --git a/Makefile b/Makefile
index 5ba76d2e..c0eb3d68 100644
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
index 52410f69..fc3dec69 100644
--- a/Makefile.inc.in
+++ b/Makefile.inc.in
@@ -4,6 +4,7 @@
 export
 
 CC = @CC@
+CSTD = @CSTD@
 LN_S = @LN_S@
 AR = @AR@
 RM = @RM@
diff --git a/configure.ac b/configure.ac
index 2dea1c64..17880206 100644
--- a/configure.ac
+++ b/configure.ac
@@ -30,6 +30,8 @@ AC_CANONICAL_HOST
 AC_C_CONST
 AC_C_VOLATILE
 AC_C_BIGENDIAN
+AX_CHECK_COMPILE_FLAG([-std=gnu90],[CSTD=-std=gnu90],[CSTD=-std=gnu89])
+AC_SUBST([CSTD])
 
 AC_SYS_LARGEFILE
 
diff --git a/m4/ax_check_compile_flag.m4 b/m4/ax_check_compile_flag.m4
new file mode 100644
index 00000000..dcabb92a
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
-- 
2.12.3

