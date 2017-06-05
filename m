Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:33796 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751297AbdFEHMl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jun 2017 03:12:41 -0400
Received: by mail-pg0-f46.google.com with SMTP id v18so6692552pgb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Jun 2017 00:12:41 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH] Btrfs: use memalloc_nofs and kvzalloc() for free space tree bitmaps
Date: Mon,  5 Jun 2017 00:12:31 -0700
Message-Id: <a8cd2db26fc69434206eecf1846d73d97cd39cfe.1496646708.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

First, instead of open-coding the vmalloc() fallback, use the new
kvzalloc() helper. Second, use memalloc_nofs_{save,restore}() instead of
GFP_NOFS, as vmalloc() uses some GFP_KERNEL allocations internally which
could lead to deadlocks.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/free-space-tree.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index fc0bd8406758..e5e92e6ba734 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -17,7 +17,7 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/vmalloc.h>
+#include <linux/sched/mm.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "locking.h"
@@ -153,21 +153,21 @@ static inline u32 free_space_bitmap_size(u64 size, u32 sectorsize)
 
 static u8 *alloc_bitmap(u32 bitmap_size)
 {
-	void *mem;
+	u8 *ret;
+	unsigned int nofs_flag;
 
 	/*
-	 * The allocation size varies, observed numbers were < 4K up to 16K.
-	 * Using vmalloc unconditionally would be too heavy, we'll try
-	 * contiguous allocations first.
+	 * GFP_NOFS doesn't work with kvmalloc(), but we really can't recurse
+	 * into the filesystem as the free space bitmap can be modified in the
+	 * critical section of a transaction commit.
+	 *
+	 * TODO: push the memalloc_nofs_{save,restore}() to the caller where we
+	 * know that recursion is unsafe.
 	 */
-	if  (bitmap_size <= PAGE_SIZE)
-		return kzalloc(bitmap_size, GFP_NOFS);
-
-	mem = kzalloc(bitmap_size, GFP_NOFS | __GFP_NOWARN);
-	if (mem)
-		return mem;
-
-	return __vmalloc(bitmap_size, GFP_NOFS | __GFP_ZERO, PAGE_KERNEL);
+	nofs_flag = memalloc_nofs_save();
+	ret = kvzalloc(bitmap_size, GFP_KERNEL);
+	memalloc_nofs_restore(nofs_flag);
+	return ret;
 }
 
 int convert_free_space_to_bitmaps(struct btrfs_trans_handle *trans,
-- 
2.13.0

