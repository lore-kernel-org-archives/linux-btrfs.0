From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Avoid using __GFP_HIGHMEM with slab allocator
Date: Mon, 09 Feb 2009 21:32:16 +0800
Message-ID: <49903060.80304@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

btrfs_releasepage may call kmem_cache_alloc indirectly,
and provide same GFP flags it gets to kmem_cache_alloc.
So it's possible to use __GFP_HIGHMEM with the slab
allocator.

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/inode.c 2/fs/btrfs/inode.c
--- 1/fs/btrfs/inode.c	2009-02-05 07:27:07.333888537 +0800
+++ 2/fs/btrfs/inode.c	2009-02-09 21:11:01.000000000 +0800
@@ -4263,7 +4263,7 @@ static int btrfs_releasepage(struct page
 {
 	if (PageWriteback(page) || PageDirty(page))
 		return 0;
-	return __btrfs_releasepage(page, gfp_flags);
+	return __btrfs_releasepage(page, gfp_flags & GFP_NOFS);
 }
 
 static void btrfs_invalidatepage(struct page *page, unsigned long offset)

