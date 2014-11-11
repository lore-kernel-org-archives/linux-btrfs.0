Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:41600 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbaKKLuA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Nov 2014 06:50:00 -0500
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] mm: check memory reclaim bugs caused fs reentrance
Date: Tue, 11 Nov 2014 15:49:50 +0400
Message-Id: <1415706590-24159-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If filesystem holds transaction open 'current->journal_info' it should not
performs memory allocations with __GFP_FS flag enabled otherwise this result in fs
reentarance which lead to:
1) reentrance to itself : deadlock or internal assertion failure due to incorrect journal credits
1) entrance to another fs: assertion faulure or silient corruption due to incorrect journal

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 include/linux/kernel.h |    7 +++++++
 mm/dmapool.c           |    1 +
 mm/mempool.c           |    1 +
 mm/page_alloc.c        |    1 +
 mm/slab.c              |    1 +
 mm/slub.c              |    1 +
 6 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3d770f5..69923d4 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -232,6 +232,13 @@ void might_fault(void);
 static inline void might_fault(void) { }
 #endif
 
+#ifdef CONFIG_PROVE_LOCKING
+#define might_enter_fs_if(cond) \
+	 WARN_ON_ONCE((cond) && current->journal_info)
+#else
+static inline void might_enter_fs_if(bool cond) { }
+#endif
+
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(int state);
 __printf(1, 2)
diff --git a/mm/dmapool.c b/mm/dmapool.c
index fd5fe43..c543eb8 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -324,6 +324,7 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 	void *retval;
 
 	might_sleep_if(mem_flags & __GFP_WAIT);
+	might_enter_fs_if(mem_flags & __GFP_FS);
 
 	spin_lock_irqsave(&pool->lock, flags);
 	list_for_each_entry(page, &pool->page_list, page_list) {
diff --git a/mm/mempool.c b/mm/mempool.c
index e209c98..b5bb86f 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -204,6 +204,7 @@ void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
 
 	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
 	might_sleep_if(gfp_mask & __GFP_WAIT);
+	might_enter_fs_if(gfp_mask & __GFP_FS);
 
 	gfp_mask |= __GFP_NOMEMALLOC;	/* don't allocate emergency reserves */
 	gfp_mask |= __GFP_NORETRY;	/* don't loop in __alloc_pages */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9cd36b8..284a699 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2805,6 +2805,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 	lockdep_trace_alloc(gfp_mask);
 
 	might_sleep_if(gfp_mask & __GFP_WAIT);
+	might_enter_fs_if(gfp_mask & __GFP_FS);
 
 	if (should_fail_alloc_page(gfp_mask, order))
 		return NULL;
diff --git a/mm/slab.c b/mm/slab.c
index eb2b2ea..43b0d2f 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2844,6 +2844,7 @@ static inline void cache_alloc_debugcheck_before(struct kmem_cache *cachep,
 						gfp_t flags)
 {
 	might_sleep_if(flags & __GFP_WAIT);
+	might_enter_fs_if(flags & __GFP_FS);
 #if DEBUG
 	kmem_flagcheck(cachep, flags);
 #endif
diff --git a/mm/slub.c b/mm/slub.c
index ae7b9f1..474fc53 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1238,6 +1238,7 @@ static inline int slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
 	flags &= gfp_allowed_mask;
 	lockdep_trace_alloc(flags);
 	might_sleep_if(flags & __GFP_WAIT);
+	might_enter_fs_if(flags & __GFP_FS);
 
 	return should_failslab(s->object_size, flags, s->flags);
 }
-- 
1.7.1

