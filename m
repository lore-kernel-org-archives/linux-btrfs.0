Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57748 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2JOLB6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 07:01:58 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so4821987pbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2012 04:01:57 -0700 (PDT)
From: Li Dongyang <jerry87905@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: do not zero the page if it's in a hole
Date: Mon, 15 Oct 2012 22:03:50 +1100
Message-Id: <1350299031-2854-1-git-send-email-Jerry87905@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Don't bother zeroing the page if it's already a hole under there.
We can save one allocation from this.

Signed-off-by: Li Dongyang <Jerry87905@gmail.com>
---
 fs/btrfs/inode.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 85a1e50..017052e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3481,6 +3481,7 @@ int btrfs_truncate_page(struct inode *inode, loff_t from, loff_t len,
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct btrfs_ordered_extent *ordered;
 	struct extent_state *cached_state = NULL;
+	struct extent_map *em = NULL;
 	char *kaddr;
 	u32 blocksize = root->sectorsize;
 	pgoff_t index = from >> PAGE_CACHE_SHIFT;
@@ -3538,6 +3539,20 @@ again:
 		goto again;
 	}
 
+	em = btrfs_get_extent_fiemap(inode, NULL, 0, page_start,
+				     PAGE_CACHE_SIZE, 0);
+	if (!IS_ERR_OR_NULL(em) && em->block_start == EXTENT_MAP_HOLE) {
+		u64 em_end = extent_map_end(em);
+		if (em->start <= page_start &&
+		    em_end >= page_start + PAGE_CACHE_SIZE) {
+			btrfs_delalloc_release_space(inode, PAGE_CACHE_SIZE);
+			unlock_extent_cached(io_tree, page_start, page_end,
+					     &cached_state, GFP_NOFS);
+			ret = 0;
+			goto out_unlock;
+		}
+	}
+
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, page_start, page_end,
 			  EXTENT_DIRTY | EXTENT_DELALLOC |
 			  EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
@@ -3574,6 +3589,8 @@ out_unlock:
 	unlock_page(page);
 	page_cache_release(page);
 out:
+	if (em)
+		free_extent_map(em);
 	return ret;
 }
 
-- 
1.7.12.3

