Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:53445 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752623AbdJLCWd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 22:22:33 -0400
Received: by mail-pf0-f195.google.com with SMTP id t188so384343pfd.10
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Oct 2017 19:22:33 -0700 (PDT)
From: Naohiro Aota <naota@elisp.net>
To: linux-btrfs@vger.kernel.org
Cc: Naohiro Aota <naota@elisp.net>
Subject: [PATCH] btrfs-progs: set include path relatively
Date: Thu, 12 Oct 2017 11:22:24 +0900
Message-Id: <20171012022224.28376-1-naota@elisp.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, gcc is passed the include directory with full path. As a result,
dependency files (*.o.d) also record the full path at the build time. Such
full path dependency is annoying for sharing the source between multiple
machines, containers, or anything the path differ.

And this is the same way what other program using autotools e.g. e2fsprogs
is doing:

$ grep top_builddir Makefile
top_builddir = .
CPPFLAGS = -I. -I$(top_builddir)/lib -I$(top_srcdir)/lib
BUILD_CFLAGS = -g -O2  -I. -I$(top_builddir)/lib -I$(top_srcdir)/lib -DHAVE_CONFIG_H
<snip>

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index b1f3388..69b94fb 100644
--- a/Makefile
+++ b/Makefile
@@ -70,8 +70,8 @@ CFLAGS = $(SUBST_CFLAGS) \
 	 -D_XOPEN_SOURCE=700  \
 	 -fno-strict-aliasing \
 	 -fPIC \
-	 -I$(TOPDIR) \
-	 -I$(TOPDIR)/kernel-lib \
+	 -I. \
+	 -I./kernel-lib \
 	 $(EXTRAWARN_CFLAGS) \
 	 $(DEBUG_CFLAGS_INTERNAL) \
 	 $(EXTRA_CFLAGS)
-- 
2.14.1

