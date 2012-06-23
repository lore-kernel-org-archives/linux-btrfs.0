Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34631 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab2FWIID (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jun 2012 04:08:03 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so3165483obb.19
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jun 2012 01:08:03 -0700 (PDT)
From: Andrew Mahone <andrew.mahone@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Andrew Mahone <andrew.mahone@gmail.com>
Subject: [PATCH 4/5] btrfs: lz4: add lz4 files in Makefile
Date: Sat, 23 Jun 2012 04:05:47 -0400
Message-Id: <1340438748-348-5-git-send-email-andrew.mahone@gmail.com>
In-Reply-To: <1340438748-348-1-git-send-email-andrew.mahone@gmail.com>
References: <1340438748-348-1-git-send-email-andrew.mahone@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Andrew Mahone <andrew.mahone@gmail.com>
---
 fs/btrfs/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index 0c4fa2b..ba5dd55 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -8,7 +8,7 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o free-space-cache.o zlib.o lzo.o \
 	   compression.o delayed-ref.o relocation.o delayed-inode.o scrub.o \
-	   reada.o backref.o ulist.o
+	   reada.o backref.o ulist.o lz4.o lz4_wrapper.o lz4hc.o
 
 btrfs-$(CONFIG_BTRFS_FS_POSIX_ACL) += acl.o
 btrfs-$(CONFIG_BTRFS_FS_CHECK_INTEGRITY) += check-integrity.o
-- 
1.7.11

