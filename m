Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57197 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752740AbdHOARx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 20:17:53 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: [RESEND PATCH] btrfs-progs: Specify C standard to gnu90 explicitly
Date: Tue, 15 Aug 2017 09:17:12 +0900
Message-Id: <20170815001712.6710-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Different C compilers have different default language standard.
This sometimes causes problem on different system.

For distribution like CentOS/RHEL7, its gcc is still 4.8 and will report
error for c90 style declaration, while most developers are using newer
gcc which will just ignore it.
This makes us hard to detect such language standard problem.

This patch will specify standard to gnu90 explicitly to avoid such problem.
Gnu90 is a good mix of c90 while provide a lot of useful gnu extension,
and is supported by all modern gcc and clang.

Reported-by: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>
Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 81598df1..cb1b3c5f 100644
--- a/Makefile
+++ b/Makefile
@@ -58,6 +58,7 @@ TOPDIR := $(shell pwd)
 
 # Common build flags
 CFLAGS = $(SUBST_CFLAGS) \
+	 -std=gnu90 \
 	 -include config.h \
 	 -DBTRFS_FLAT_INCLUDES \
 	 -D_XOPEN_SOURCE=700  \
-- 
2.13.2

