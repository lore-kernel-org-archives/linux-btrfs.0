Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:56822 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753049AbdHOCTN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 22:19:13 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: [PATCH] btrfs-progs: Fix cross-compile error for mktables
Date: Tue, 15 Aug 2017 11:19:03 +0900
Message-Id: <20170815021903.6923-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When cross compiling btrfs-progs, following error will prevent
btrfs-progs to be compiled:

    [CC]     mktables
    [TABLE]  kernel-lib/tables.c
/bin/sh: ./mktables: cannot execute binary file: Exec format error
make: *** No rule to make target 'kernel-lib/tables.c', needed by 'kernel-lib/tables.o'.  Stop.

"mktables" should only be executed in host environment, while @CC
set by autoconf will follow host/build/target setting, causing mktables
to be cross-compiled.

The fix is to introduce a new @HOSTCC for mktables, which will not be
affected by host/build/target settings.

Reported-by: Hallo32 <Hallo32@gmx.net>
Suggested-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
Tested with AArch64 cross-toolchain created by buildroot.
---
 Makefile        | 2 +-
 Makefile.inc.in | 1 +
 configure.ac    | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index b3e2b636..0395e37f 100644
--- a/Makefile
+++ b/Makefile
@@ -323,7 +323,7 @@ version.h: version.sh version.h.in configure.ac
 
 mktables: kernel-lib/mktables.c
 	@echo "    [CC]     $@"
-	$(Q)$(CC) $(CFLAGS) $< -o $@
+	$(Q)$(HOSTCC) $(CFLAGS) $< -o $@
 
 kernel-lib/tables.c: mktables
 	@echo "    [TABLE]  $@"
diff --git a/Makefile.inc.in b/Makefile.inc.in
index 4e1b68cb..308acca3 100644
--- a/Makefile.inc.in
+++ b/Makefile.inc.in
@@ -4,6 +4,7 @@
 export
 
 CC = @CC@
+HOSTCC = @HOSTCC@
 LN_S = @LN_S@
 AR = @AR@
 RM = @RM@
diff --git a/configure.ac b/configure.ac
index 30055f85..f6051ebd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -26,6 +26,7 @@ AC_CONFIG_SRCDIR([btrfs.c])
 AC_PREFIX_DEFAULT([/usr/local])
 
 AC_PROG_CC
+AC_PATH_PROGS([HOSTCC], [gcc clang])
 AC_CANONICAL_HOST
 AC_C_CONST
 AC_C_VOLATILE
-- 
2.14.0

