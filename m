Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19424 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750918AbbBKAs1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 19:48:27 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: Move -rdynamic linker only option to LDFLAGS.
Date: Wed, 11 Feb 2015 08:46:24 +0800
Message-ID: <1423615584-32176-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Same thing as clang cleanup patch:
commit 040b3f11ba6b5555d793a9ef79ed4d9032d22370
Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date:   Fri Dec 19 14:13:08 2014 +0800

    btrfs-progs: Makefile: Move linker only option to LDFLAGS

But the move to autoconfig seems using old Makefile.
So do it again.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 Makefile.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile.in b/Makefile.in
index 3a60398..d5940c6 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -17,9 +17,9 @@ CFLAGS = @CFLAGS@ \
 	 -D_XOPEN_SOURCE=700  \
 	 -fno-strict-aliasing \
 	 -fPIC \
-	 -rdynamic
 
-LDFLAGS = @LDFLAGS@
+LDFLAGS = @LDFLAGS@ \
+	  -rdynamic
 
 LIBS = @UUID_LIBS@ @BLKID_LIBS@ @ZLIB_LIBS@ @LZO2_LIBS@ -L. -pthread
 LIBBTRFS_LIBS = $(LIBS)
-- 
2.3.0

