Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:64900 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbaEaXsq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 31 May 2014 19:48:46 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so2844981wib.13
        for <linux-btrfs@vger.kernel.org>; Sat, 31 May 2014 16:48:45 -0700 (PDT)
From: Philip Worrall <philip.worrall@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Philip Worrall <philip.worrall@googlemail.com>
Subject: [PATCH 2/8] Btrfs: Add lz4.c to the Makefile
Date: Sat, 31 May 2014 23:48:30 +0000
Message-Id: <1401580116-10458-3-git-send-email-philip.worrall@googlemail.com>
In-Reply-To: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
References: <1401580116-10458-1-git-send-email-philip.worrall@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add lz4.c to the btrfs makefile

Signed-off-by: Philip Worrall <philip.worrall@googlemail.com>
---
 fs/btrfs/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index f341a98..af8d12d 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -6,7 +6,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   transaction.o inode.o file.o tree-defrag.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
-	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
+	   export.o tree-log.o free-space-cache.o zlib.o lzo.o lz4.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
 	   reada.o backref.o ulist.o qgroup.o send.o dev-replace.o raid56.o \
 	   uuid-tree.o props.o hash.o
-- 
1.9.1

