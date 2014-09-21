Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63817 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaIUBBc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Sep 2014 21:01:32 -0400
Received: by mail-wi0-f171.google.com with SMTP id ho1so1197366wib.10
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Sep 2014 18:01:30 -0700 (PDT)
From: Dimitri John Ledkov <xnox@debian.org>
To: linux-btrfs@vger.kernel.org
Cc: Luk Claes <luk@debian.org>, Dimitri John Ledkov <xnox@debian.org>
Subject: [PATCH 2/4] Fixes FTBFS with --no-add-needed.
Date: Sun, 21 Sep 2014 02:01:20 +0100
Message-Id: <1411261282-26831-2-git-send-email-xnox@debian.org>
In-Reply-To: <1411261282-26831-1-git-send-email-xnox@debian.org>
References: <1411261282-26831-1-git-send-email-xnox@debian.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Luk Claes <luk@debian.org>

Bug-Debian: http://bugs.debian.org/554059
Signed-off-by: Dimitri John Ledkov <xnox@debian.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index e721e99..441e925 100644
--- a/Makefile
+++ b/Makefile
@@ -26,7 +26,7 @@ TESTS = fsck-tests.sh convert-tests.sh
 INSTALL = install
 prefix ?= /usr/local
 bindir = $(prefix)/bin
-lib_LIBS = -luuid -lblkid -lm -lz -llzo2 -L.
+lib_LIBS = -luuid -lblkid -lm -lz -llzo2 -lcom_err -L.
 libdir ?= $(prefix)/lib
 incdir = $(prefix)/include/btrfs
 LIBS = $(lib_LIBS) $(libs_static)
-- 
2.1.0.rc1

