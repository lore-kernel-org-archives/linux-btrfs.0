Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:60048 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaJLUHY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Oct 2014 16:07:24 -0400
Received: by mail-oi0-f45.google.com with SMTP id i138so11402876oig.4
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Oct 2014 13:07:24 -0700 (PDT)
Received: from target.stec-inc.ad (pat.hitachigst.com. [199.255.44.5])
        by mx.google.com with ESMTPSA id e7sm8044225oen.17.2014.10.12.13.07.22
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 12 Oct 2014 13:07:23 -0700 (PDT)
From: neo <cknvme@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Test Commit
Date: Sun, 12 Oct 2014 13:07:21 -0700
Message-Id: <1413144441-6894-1-git-send-email-cknvme@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 18eb944..7cc7783 100644
--- a/Makefile
+++ b/Makefile
@@ -5,7 +5,7 @@ CC = gcc
 LN = ln
 AR = ar
 AM_CFLAGS = -Wall -D_FILE_OFFSET_BITS=64 -DBTRFS_FLAT_INCLUDES -fno-strict-aliasing -fPIC
-CFLAGS = -g -O1 -fno-strict-aliasing
+CFLAGS = -g -O1 -fno-strict-aliasing -rdynamic
 objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
 	  root-tree.o dir-item.o file-item.o inode-item.o inode-map.o \
 	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
-- 
1.9.1

