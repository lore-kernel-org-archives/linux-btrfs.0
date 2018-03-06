Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49280 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933294AbeCFTYk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Mar 2018 14:24:40 -0500
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH v8 50/63] shmem: Convert shmem_free_swap to XArray
Date: Tue,  6 Mar 2018 11:24:00 -0800
Message-Id: <20180306192413.5499-51-willy@infradead.org>
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Matthew Wilcox <mawilcox@microsoft.com>

This is a perfect use for xa_cmpxchg().  Note the use of 0 for GFP
flags; we won't be allocating memory.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/shmem.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index a0a354a87f3b..cfbffb4b47a2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -635,16 +635,13 @@ static void shmem_delete_from_page_cache(struct page *page, void *radswap)
 }
 
 /*
- * Remove swap entry from radix tree, free the swap and its page cache.
+ * Remove swap entry from page cache, free the swap and its page cache.
  */
 static int shmem_free_swap(struct address_space *mapping,
 			   pgoff_t index, void *radswap)
 {
-	void *old;
+	void *old = xa_cmpxchg(&mapping->i_pages, index, radswap, NULL, 0);
 
-	xa_lock_irq(&mapping->i_pages);
-	old = radix_tree_delete_item(&mapping->i_pages, index, radswap);
-	xa_unlock_irq(&mapping->i_pages);
 	if (old != radswap)
 		return -ENOENT;
 	free_swap_and_cache(radix_to_swp_entry(radswap));
-- 
2.16.1

