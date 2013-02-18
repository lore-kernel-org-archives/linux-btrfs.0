Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56767 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab3BRH4e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Feb 2013 02:56:34 -0500
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        Kyungsik Lee <kyungsik.lee@lge.com>, David Sterba <dsterba@suse.cz>
Subject: [PATCH v2] btrfs: use kmalloc for lzo de/compress buffer
Date: Mon, 18 Feb 2013 16:56:04 +0900
Message-Id: <1361174164-7182-1-git-send-email-kyungsik.lee@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The size of de/compress buffer is small enough to use kmalloc.
Allocating it with kmalloc rather than vmalloc is preferred.

This patch depends on my previous patch, “btrfs: fix decompress buffer size”.

v2: Using vmalloc for "workspace->mem" due to the size limit.

Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/lzo.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 223893a..aaaab2e 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -40,8 +40,8 @@ static void lzo_free_workspace(struct list_head *ws)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 
-	vfree(workspace->buf);
-	vfree(workspace->cbuf);
+	kfree(workspace->buf);
+	kfree(workspace->cbuf);
 	vfree(workspace->mem);
 	kfree(workspace);
 }
@@ -55,8 +55,9 @@ static struct list_head *lzo_alloc_workspace(void)
 		return ERR_PTR(-ENOMEM);
 
 	workspace->mem = vmalloc(LZO1X_MEM_COMPRESS);
-	workspace->buf = vmalloc(PAGE_CACHE_SIZE);
-	workspace->cbuf = vmalloc(lzo1x_worst_compress(PAGE_CACHE_SIZE));
+	workspace->buf = kmalloc(PAGE_CACHE_SIZE, GFP_NOFS);
+	workspace->cbuf = kmalloc(lzo1x_worst_compress(PAGE_CACHE_SIZE),
+			GFP_NOFS);
 	if (!workspace->mem || !workspace->buf || !workspace->cbuf)
 		goto fail;
 
-- 
1.8.0.3

