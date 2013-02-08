Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.vapor.com ([83.220.149.2]:48621 "EHLO nitrogen.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947297Ab3BHXeI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Feb 2013 18:34:08 -0500
Received: from twilight.demius.net (c-297271d5.013-195-6c756e10.cust.bredbandsbolaget.se [213.113.114.41])
	by nitrogen.vapor.com (Postfix) with ESMTPSA id 9C97D40C023
	for <linux-btrfs@vger.kernel.org>; Sat,  9 Feb 2013 00:34:06 +0100 (CET)
From: Ian Kumlien <pomac@demius.net>
To: linux-btrfs@vger.kernel.org
Cc: Ian Kumlien <pomac@demius.net>
Subject: [PATCH] Btrfs-progs: -U_FORTIFY_SOURCE before -D
Date: Sat,  9 Feb 2013 00:30:21 +0100
Message-Id: <1360366221-22703-1-git-send-email-pomac@demius.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My builds are cluttered with:
<command-line>:0:0: warning: "_FORTIFY_SOURCE" redefined [enabled by
default]

Which makes it hard to tell if something breaks or not.

Signed-off-by: Ian Kumlien <pomac@demius.net>
---

I don't know about you, but bilding with 
GCC 4.7.2 on gentoo, this is a issue.

 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index afd6cb2..ae3abdc 100644
--- a/Makefile
+++ b/Makefile
@@ -1,5 +1,5 @@
 CC = gcc
-AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2
+AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
 CFLAGS = -g -O1
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o \
-- 
1.8.1.2

