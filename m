Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40789 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932650AbcJNRE7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 13:04:59 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5844BAC37
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Oct 2016 17:04:53 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs-progs: build: detect fiemap shared flag but don't fail build
Date: Fri, 14 Oct 2016 19:04:46 +0200
Message-Id: <20161014170446.6797-1-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The FIEMAP_EXTENT_SHARED fiemap flag was introduced in 2.6.33. If the
headers do not provide the definition, the build will fail. The support
of the fiemap sharing depends on the running kernel. There are still
systems with 2.6.32 kernel headers but running newer versions.

To support such environment, don't fail build, provide own defintion of
the structure and detect if there's an old kernel in use in the relevant
command (btrfs fi du).

Reported-by: Abhay Sachan <lkp.abhay@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 cmds-fi-du.c | 14 ++++++++++++++
 configure.ac | 10 +++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/cmds-fi-du.c b/cmds-fi-du.c
index a5b66e6fdf1a..895c242e821c 100644
--- a/cmds-fi-du.c
+++ b/cmds-fi-du.c
@@ -27,8 +27,13 @@
 
 #include <sys/ioctl.h>
 #include <linux/fs.h>
+#include <linux/version.h>
 #include <linux/fiemap.h>
 
+#if !defined(FIEMAP_EXTENT_SHARED) && (HAVE_OWN_FIEMAP_EXTENT_SHARED_DEFINE == 1)
+#define FIEMAP_EXTENT_SHARED           0x00002000
+#endif
+
 #include "utils.h"
 #include "commands.h"
 #include "kerncompat.h"
@@ -546,6 +551,7 @@ int cmd_filesystem_du(int argc, char **argv)
 {
 	int ret = 0, err = 0;
 	int i;
+	u32 kernel_version;
 
 	unit_mode = get_unit_mode_from_arg(&argc, argv, 1);
 
@@ -570,6 +576,14 @@ int cmd_filesystem_du(int argc, char **argv)
 	if (check_argc_min(argc - optind, 1))
 		usage(cmd_filesystem_du_usage);
 
+	kernel_version = get_running_kernel_version();
+
+	if (kernel_version < KERNEL_VERSION(2,6,33)) {
+		warning(
+"old kernel version detected, shared space will be reported as exclusive\n"
+"due to missing support for FIEMAP_EXTENT_SHARED flag");
+	}
+
 	printf("%10s  %10s  %10s  %s\n", "Total", "Exclusive", "Set shared",
 			"Filename");
 
diff --git a/configure.ac b/configure.ac
index 8fd8f425a076..9c6df3b9d4ed 100644
--- a/configure.ac
+++ b/configure.ac
@@ -144,8 +144,16 @@ if test "$DISABLE_BTRFSCONVERT" = 0 && test "x$convertfs" = "x"; then
 	AC_MSG_ERROR([no filesystems for convert, use --disable-convert instead])
 fi
 
+HAVE_OWN_FIEMAP_EXTENT_SHARED_DEFINE=0
 AX_CHECK_DEFINE([linux/fiemap.h], [FIEMAP_EXTENT_SHARED], [],
-		[AC_MSG_ERROR([no definition of FIEMAP_EXTENT_SHARED found])])
+		[HAVE_OWN_FIEMAP_EXTENT_SHARED_DEFINE=1
+		 AC_MSG_WARN([no definition of FIEMAP_EXTENT_SHARED found, probably old kernel, will use own defintion, 'btrfs fi du' might report wrong numbers])])
+
+if test "x$HAVE_OWN_FIEMAP_EXTENT_SHARED_DEFINE" == "x1"; then
+AC_DEFINE([HAVE_OWN_FIEMAP_EXTENT_SHARED_DEFINE], [1], [We defined FIEMAP_EXTENT_SHARED])
+else
+AC_DEFINE([HAVE_OWN_FIEMAP_EXTENT_SHARED_DEFINE], [0], [We did not define FIEMAP_EXTENT_SHARED])
+fi
 
 dnl Define <NAME>_LIBS= and <NAME>_CFLAGS= by pkg-config
 dnl
-- 
2.10.0

