Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49106 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933197AbeCFTYe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Mar 2018 14:24:34 -0500
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [PATCH v8 38/63] mm: Convert delete_from_swap_cache to XArray
Date: Tue,  6 Mar 2018 11:23:48 -0800
Message-Id: <20180306192413.5499-39-willy@infradead.org>
In-Reply-To: <20180306192413.5499-1-willy@infradead.org>
References: <20180306192413.5499-1-willy@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Matthew Wilcox <mawilcox@microsoft.com>

Both callers of __delete_from_swap_cache have the swp_entry_t already,
so pass that in to make constructing the XA_STATE easier.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/swap.h |  5 +++--
 mm/swap_state.c      | 24 ++++++++++--------------
 mm/vmscan.c          |  2 +-
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index dab96af23d96..0b6a47a46c55 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -404,7 +404,7 @@ extern void show_swap_cache_info(void);
 extern int add_to_swap(struct page *page);
 extern int add_to_swap_cache(struct page *, swp_entry_t, gfp_t);
 extern int __add_to_swap_cache(struct page *page, swp_entry_t entry);
-extern void __delete_from_swap_cache(struct page *);
+extern void __delete_from_swap_cache(struct page *, swp_entry_t entry);
 extern void delete_from_swap_cache(struct page *);
 extern void free_page_and_swap_cache(struct page *);
 extern void free_pages_and_swap_cache(struct page **, int);
@@ -564,7 +564,8 @@ static inline int add_to_swap_cache(struct page *page, swp_entry_t entry,
 	return -1;
 }
 
-static inline void __delete_from_swap_cache(struct page *page)
+static inline void __delete_from_swap_cache(struct page *page,
+							swp_entry_t entry)
 {
 }
 
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 329736723d36..21218f6e438b 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -154,23 +154,22 @@ int add_to_swap_cache(struct page *page, swp_entry_t entry, gfp_t gfp)
  * This must be called only on pages that have
  * been verified to be in the swap cache.
  */
-void __delete_from_swap_cache(struct page *page)
+void __delete_from_swap_cache(struct page *page, swp_entry_t entry)
 {
-	struct address_space *address_space;
+	struct address_space *address_space = swap_address_space(entry);
 	int i, nr = hpage_nr_pages(page);
-	swp_entry_t entry;
-	pgoff_t idx;
+	pgoff_t idx = swp_offset(entry);
+	XA_STATE(xas, &address_space->i_pages, idx);
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageSwapCache(page), page);
 	VM_BUG_ON_PAGE(PageWriteback(page), page);
 
-	entry.val = page_private(page);
-	address_space = swap_address_space(entry);
-	idx = swp_offset(entry);
 	for (i = 0; i < nr; i++) {
-		radix_tree_delete(&address_space->i_pages, idx + i);
+		void *entry = xas_store(&xas, NULL);
+		VM_BUG_ON_PAGE(entry != page + i, entry);
 		set_page_private(page + i, 0);
+		xas_next(&xas);
 	}
 	ClearPageSwapCache(page);
 	address_space->nrpages -= nr;
@@ -246,14 +245,11 @@ int add_to_swap(struct page *page)
  */
 void delete_from_swap_cache(struct page *page)
 {
-	swp_entry_t entry;
-	struct address_space *address_space;
-
-	entry.val = page_private(page);
+	swp_entry_t entry = { .val = page_private(page) };
+	struct address_space *address_space = swap_address_space(entry);
 
-	address_space = swap_address_space(entry);
 	xa_lock_irq(&address_space->i_pages);
-	__delete_from_swap_cache(page);
+	__delete_from_swap_cache(page, entry);
 	xa_unlock_irq(&address_space->i_pages);
 
 	put_swap_page(page, entry);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 22bd3720b318..728d7e57cf11 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -689,7 +689,7 @@ static int __remove_mapping(struct address_space *mapping, struct page *page,
 	if (PageSwapCache(page)) {
 		swp_entry_t swap = { .val = page_private(page) };
 		mem_cgroup_swapout(page, swap);
-		__delete_from_swap_cache(page);
+		__delete_from_swap_cache(page, swap);
 		xa_unlock_irqrestore(&mapping->i_pages, flags);
 		put_swap_page(page, swap);
 	} else {
-- 
2.16.1

