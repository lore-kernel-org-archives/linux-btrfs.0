Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45171 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbeHIUhK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Aug 2018 16:37:10 -0400
From: Naohiro Aota <naota@elisp.net>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Matias Bjorling <mb@lightnvm.io>, Naohiro Aota <naota@elisp.net>
Subject: [RFC PATCH 01/12] btrfs-progs: build: Check zoned block device support
Date: Fri, 10 Aug 2018 03:10:54 +0900
Message-Id: <20180809181105.12856-1-naota@elisp.net>
In-Reply-To: <20180809180450.5091-1-naota@elisp.net>
References: <20180809180450.5091-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the kernel supports zoned block devices, the file
/usr/include/linux/blkzoned.h will be present. Check this and define
BTRFS_ZONED if the file is present.

If it present, enables HMZONED feature, if not disable it.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 configure.ac | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/configure.ac b/configure.ac
index df02f206..616d62a1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -207,6 +207,18 @@ else
 AC_DEFINE([HAVE_OWN_FIEMAP_EXTENT_SHARED_DEFINE], [0], [We did not define FIEMAP_EXTENT_SHARED])
 fi
 
+AC_CHECK_HEADER(linux/blkzoned.h, [blkzoned_found=yes], [blkzoned_found=no])
+AC_ARG_ENABLE([zoned],
+  AS_HELP_STRING([--disable-zoned], [disable zoned block device support]),
+  [], [enable_zoned=$blkzoned_found]
+)
+
+AS_IF([test "x$enable_zoned" = xyes], [
+	AC_CHECK_HEADER(linux/blkzoned.h, [],
+		[AC_MSG_ERROR([Couldn't find linux/blkzoned.h])])
+	AC_DEFINE([BTRFS_ZONED], [1], [enable zoned block device support])
+])
+
 dnl Define <NAME>_LIBS= and <NAME>_CFLAGS= by pkg-config
 dnl
 dnl The default PKG_CHECK_MODULES() action-if-not-found is end the
@@ -308,6 +320,7 @@ AC_MSG_RESULT([
 	btrfs-restore zstd: ${enable_zstd}
 	Python bindings:    ${enable_python}
 	Python interpreter: ${PYTHON}
+	zoned device:       ${enable_zoned}
 
 	Type 'make' to compile.
 ])
-- 
2.18.0

