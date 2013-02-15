Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55819 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161357Ab3BONIj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 08:08:39 -0500
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, hyojun.im@lge.com, chan.jeong@lge.com,
        raphael.andy.lee@gmail.com, Kyungsik Lee <kyungsik.lee@lge.com>
Subject: [PATCH] btrfs: use kmalloc for lzo de/compress buffer
Date: Fri, 15 Feb 2013 22:08:21 +0900
Message-Id: <1360933701-17434-1-git-send-email-kyungsik.lee@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The size of de/compress buffer and LZO1X_MEM_COMPRESS is small enough.
Allocating it with kmalloc rather than vmalloc is preferred.

This patch depends on my previous patch, “btrfs: fix decompress buffer size”.

Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/lzo.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 223893a..f223742 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -18,7 +18,6 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/vmalloc.h>
 #include <linux/init.h>
 #include <linux/err.h>
 #include <linux/sched.h>
@@ -40,9 +39,9 @@ static void lzo_free_workspace(struct list_head *ws)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 
-	vfree(workspace->buf);
-	vfree(workspace->cbuf);
-	vfree(workspace->mem);
+	kfree(workspace->buf);
+	kfree(workspace->cbuf);
+	kfree(workspace->mem);
 	kfree(workspace);
 }
 
@@ -54,9 +53,10 @@ static struct list_head *lzo_alloc_workspace(void)
 	if (!workspace)
 		return ERR_PTR(-ENOMEM);
 
-	workspace->mem = vmalloc(LZO1X_MEM_COMPRESS);
-	workspace->buf = vmalloc(PAGE_CACHE_SIZE);
-	workspace->cbuf = vmalloc(lzo1x_worst_compress(PAGE_CACHE_SIZE));
+	workspace->mem = kmalloc(LZO1X_MEM_COMPRESS, GFP_NOFS);
+	workspace->buf = kmalloc(PAGE_CACHE_SIZE, GFP_NOFS);
+	workspace->cbuf = kmalloc(lzo1x_worst_compress(PAGE_CACHE_SIZE),
+			GFP_NOFS);
 	if (!workspace->mem || !workspace->buf || !workspace->cbuf)
 		goto fail;
 
-- 
1.8.0.3

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
