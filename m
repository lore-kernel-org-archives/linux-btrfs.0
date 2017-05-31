Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49179 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751082AbdEaPmj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 11:42:39 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8024EAC08
        for <linux-btrfs@vger.kernel.org>; Wed, 31 May 2017 15:42:38 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/3] btrfs: switch to kvmalloc and GFP_KERNEL in lzo/zlib alloc_workspace
Date: Wed, 31 May 2017 17:41:38 +0200
Message-Id: <5e5885e05f14e5449d48b9c512c934c241f6139f.1496245064.git.dsterba@suse.com>
In-Reply-To: <cover.1496245064.git.dsterba@suse.com>
References: <cover.1496245064.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The compression workspace buffers are larger than a page so we use
vmalloc, unconditionally. This is not always necessary as there might be
contiguous memory available.

Let's use the kvmalloc helpers that will try kmalloc first and fallback
to vmalloc. For that they require GFP_KERNEL flags. As we now have the
alloc_workspace calls protected by memalloc_nofs in the critical
contexts, we can safely use GFP_KERNEL.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/lzo.c  | 14 +++++++-------
 fs/btrfs/zlib.c |  6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index c556f3f3fbf0..cde13cce01a0 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -18,7 +18,7 @@
 
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/vmalloc.h>
+#include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/err.h>
 #include <linux/sched.h>
@@ -41,9 +41,9 @@ static void lzo_free_workspace(struct list_head *ws)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 
-	vfree(workspace->buf);
-	vfree(workspace->cbuf);
-	vfree(workspace->mem);
+	kvfree(workspace->buf);
+	kvfree(workspace->cbuf);
+	kvfree(workspace->mem);
 	kfree(workspace);
 }
 
@@ -55,9 +55,9 @@ static struct list_head *lzo_alloc_workspace(void)
 	if (!workspace)
 		return ERR_PTR(-ENOMEM);
 
-	workspace->mem = vmalloc(LZO1X_MEM_COMPRESS);
-	workspace->buf = vmalloc(lzo1x_worst_compress(PAGE_SIZE));
-	workspace->cbuf = vmalloc(lzo1x_worst_compress(PAGE_SIZE));
+	workspace->mem = kvmalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+	workspace->buf = kvmalloc(lzo1x_worst_compress(PAGE_SIZE), GFP_KERNEL);
+	workspace->cbuf = kvmalloc(lzo1x_worst_compress(PAGE_SIZE), GFP_KERNEL);
 	if (!workspace->mem || !workspace->buf || !workspace->cbuf)
 		goto fail;
 
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index c1db7572283b..c248f9286366 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/zlib.h>
 #include <linux/zutil.h>
-#include <linux/vmalloc.h>
+#include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/err.h>
 #include <linux/sched.h>
@@ -43,7 +43,7 @@ static void zlib_free_workspace(struct list_head *ws)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 
-	vfree(workspace->strm.workspace);
+	kvfree(workspace->strm.workspace);
 	kfree(workspace->buf);
 	kfree(workspace);
 }
@@ -59,7 +59,7 @@ static struct list_head *zlib_alloc_workspace(void)
 
 	workspacesize = max(zlib_deflate_workspacesize(MAX_WBITS, MAX_MEM_LEVEL),
 			zlib_inflate_workspacesize());
-	workspace->strm.workspace = vmalloc(workspacesize);
+	workspace->strm.workspace = kvmalloc(workspacesize, GFP_KERNEL);
 	workspace->buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!workspace->strm.workspace || !workspace->buf)
 		goto fail;
-- 
2.12.0

