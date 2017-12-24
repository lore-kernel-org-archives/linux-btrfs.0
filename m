Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38541 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756828AbdLXEzp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Dec 2017 23:55:45 -0500
Received: by mail-wm0-f68.google.com with SMTP id 64so27787097wme.3
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Dec 2017 20:55:44 -0800 (PST)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 1/2] Btrfs: heuristic: replace workspace managment code by mempool API
Date: Sun, 24 Dec 2017 07:55:27 +0300
Message-Id: <20171224045528.12991-2-nefelim4ag@gmail.com>
In-Reply-To: <20171224045528.12991-1-nefelim4ag@gmail.com>
References: <20171224045528.12991-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently compression code have custom workspace/memory cache
for guarantee forward progress on high memory pressure.

That api can be replaced with mempool API, which can guarantee the same.
Main goal is simplify/cleanup code and replace it with general solution.

I try avoid use of atomic/lock/wait stuff,
as that all already hidden in mempool API.
Only thing that must be racy safe is initialization of
mempool.

So i create simple mempool_alloc_wrap, which will handle
mempool_create failures, and sync threads work by cmpxchg()
on mempool_t pointer.

Another logic difference between our custom stuff and mempool:
 - ws find/free mosly reuse current workspaces whenever possible.
 - mempool use alloc/free of provided helpers with more
   aggressive use of __GFP_NOMEMALLOC, __GFP_NORETRY, GFP_NOWARN,
   and only use already preallocated space when memory get tight.

Not sure which approach are better, but simple stress tests with
writing stuff on compressed fs on ramdisk show negligible difference on
8 CPU Virtual Machine with Intel Xeon E5-2420 0 @ 1.90GHz (+-1%).

Other needed changes to use mempool:
 - memalloc_nofs_{save,restore} move to each place where kvmalloc
   will be used in call chain.
 - mempool_create return pointer to mampool or NULL,
   no error, so macros like IS_ERR(ptr) can't be used.

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 197 ++++++++++++++++++++++++++-----------------------
 1 file changed, 106 insertions(+), 91 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 208334aa6c6e..02bd60357f04 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -34,6 +34,7 @@
 #include <linux/slab.h>
 #include <linux/sched/mm.h>
 #include <linux/log2.h>
+#include <linux/mempool.h>
 #include "ctree.h"
 #include "disk-io.h"
 #include "transaction.h"
@@ -768,46 +769,46 @@ struct heuristic_ws {
 	struct bucket_item *bucket;
 	/* Sorting buffer */
 	struct bucket_item *bucket_b;
-	struct list_head list;
 };
 
-static void free_heuristic_ws(struct list_head *ws)
+static void heuristic_ws_free(void *element, void *pool_data)
 {
-	struct heuristic_ws *workspace;
+	struct heuristic_ws *ws = (struct heuristic_ws *) element;
 
-	workspace = list_entry(ws, struct heuristic_ws, list);
-
-	kvfree(workspace->sample);
-	kfree(workspace->bucket);
-	kfree(workspace->bucket_b);
-	kfree(workspace);
+	kfree(ws->sample);
+	kfree(ws->bucket);
+	kfree(ws->bucket_b);
+	kfree(ws);
 }
 
-static struct list_head *alloc_heuristic_ws(void)
+static void *heuristic_ws_alloc(gfp_t gfp_mask, void *pool_data)
 {
-	struct heuristic_ws *ws;
+	struct heuristic_ws *ws = kzalloc(sizeof(*ws), gfp_mask);
 
-	ws = kzalloc(sizeof(*ws), GFP_KERNEL);
 	if (!ws)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
-	ws->sample = kvmalloc(MAX_SAMPLE_SIZE, GFP_KERNEL);
+	/*
+	 * We can handle allocation failures and
+	 * slab have caches for 8192 byte allocations
+	 */
+	ws->sample = kmalloc(MAX_SAMPLE_SIZE, gfp_mask);
 	if (!ws->sample)
 		goto fail;
 
-	ws->bucket = kcalloc(BUCKET_SIZE, sizeof(*ws->bucket), GFP_KERNEL);
+	ws->bucket = kcalloc(BUCKET_SIZE, sizeof(*ws->bucket), gfp_mask);
 	if (!ws->bucket)
 		goto fail;
 
-	ws->bucket_b = kcalloc(BUCKET_SIZE, sizeof(*ws->bucket_b), GFP_KERNEL);
+	ws->bucket_b = kcalloc(BUCKET_SIZE, sizeof(*ws->bucket_b), gfp_mask);
 	if (!ws->bucket_b)
 		goto fail;
 
-	INIT_LIST_HEAD(&ws->list);
-	return &ws->list;
+	return ws;
+
 fail:
-	free_heuristic_ws(&ws->list);
-	return ERR_PTR(-ENOMEM);
+	heuristic_ws_free(ws, NULL);
+	return NULL;
 }
 
 struct workspaces_list {
@@ -821,9 +822,12 @@ struct workspaces_list {
 	wait_queue_head_t ws_wait;
 };
 
-static struct workspaces_list btrfs_comp_ws[BTRFS_COMPRESS_TYPES];
+struct workspace_stor {
+	mempool_t *pool;
+};
 
-static struct workspaces_list btrfs_heuristic_ws;
+static struct workspace_stor btrfs_heuristic_ws_stor;
+static struct workspaces_list btrfs_comp_ws[BTRFS_COMPRESS_TYPES];
 
 static const struct btrfs_compress_op * const btrfs_compress_op[] = {
 	&btrfs_zlib_compress,
@@ -835,21 +839,17 @@ void __init btrfs_init_compress(void)
 {
 	struct list_head *workspace;
 	int i;
+	mempool_t *pool = btrfs_heuristic_ws_stor.pool;
 
-	INIT_LIST_HEAD(&btrfs_heuristic_ws.idle_ws);
-	spin_lock_init(&btrfs_heuristic_ws.ws_lock);
-	atomic_set(&btrfs_heuristic_ws.total_ws, 0);
-	init_waitqueue_head(&btrfs_heuristic_ws.ws_wait);
+	/*
+	 * Preallocate one workspace for heuristic so
+	 * we can guarantee forward progress in the worst case
+	 */
+	pool = mempool_create(1, heuristic_ws_alloc,
+				 heuristic_ws_free, NULL);
 
-	workspace = alloc_heuristic_ws();
-	if (IS_ERR(workspace)) {
-		pr_warn(
-	"BTRFS: cannot preallocate heuristic workspace, will try later\n");
-	} else {
-		atomic_set(&btrfs_heuristic_ws.total_ws, 1);
-		btrfs_heuristic_ws.free_ws = 1;
-		list_add(workspace, &btrfs_heuristic_ws.idle_ws);
-	}
+	if (pool == NULL)
+		pr_warn("BTRFS: cannot preallocate heuristic workspace, will try later\n");
 
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
 		INIT_LIST_HEAD(&btrfs_comp_ws[i].idle_ws);
@@ -872,13 +872,67 @@ void __init btrfs_init_compress(void)
 	}
 }
 
+/*
+ * Handle mempool init failures
+ * Call resize of mempool if min_nr and ncpu differ
+ */
+static void *mempool_alloc_wrap(struct workspace_stor *stor)
+{
+	int ncpu = num_online_cpus();
+
+	while (unlikely(stor->pool == NULL)) {
+		mempool_t *pool;
+		void *(*ws_alloc)(gfp_t gfp_mask, void *pool_data);
+		void (*ws_free)(void *element, void *pool_data);
+
+		if (stor == &btrfs_heuristic_ws_stor) {
+			ws_alloc = heuristic_ws_alloc;
+			ws_free  = heuristic_ws_free;
+		}
+
+		pool = mempool_create(1, ws_alloc, ws_free, NULL);
+
+		if (pool) {
+			pool = cmpxchg(&stor->pool, NULL, pool);
+			if (pool)
+				mempool_destroy(pool);
+		}
+
+		if (stor->pool == NULL) {
+			/* once per minute, no burst */
+			static DEFINE_RATELIMIT_STATE(_rs, 60 * HZ, 1);
+
+			if (__ratelimit(&_rs))
+				pr_warn("BTRFS: no compression workspaces, low memory, retrying\n");
+		}
+	}
+
+	/*
+	 * mempool_resize() can return error
+	 * but we can safely ignore it and try resize again
+	 * on next allocate request
+	 */
+	if (stor->pool->min_nr != ncpu)
+		mempool_resize(stor->pool, ncpu);
+
+	return mempool_alloc(stor->pool, GFP_KERNEL);
+}
+
+/*
+ * Just for have similiar semantic with mempool_alloc_wrap
+ */
+static inline void mempool_free_wrap(void *element, struct workspace_stor *stor)
+{
+	mempool_free(element, stor->pool);
+}
+
 /*
  * This finds an available workspace or allocates a new one.
  * If it's not possible to allocate a new one, waits until there's one.
  * Preallocation makes a forward progress guarantees and we do not return
  * errors.
  */
-static struct list_head *__find_workspace(int type, bool heuristic)
+static struct list_head *find_workspace(int type)
 {
 	struct list_head *workspace;
 	int cpus = num_online_cpus();
@@ -890,19 +944,11 @@ static struct list_head *__find_workspace(int type, bool heuristic)
 	wait_queue_head_t *ws_wait;
 	int *free_ws;
 
-	if (heuristic) {
-		idle_ws	 = &btrfs_heuristic_ws.idle_ws;
-		ws_lock	 = &btrfs_heuristic_ws.ws_lock;
-		total_ws = &btrfs_heuristic_ws.total_ws;
-		ws_wait	 = &btrfs_heuristic_ws.ws_wait;
-		free_ws	 = &btrfs_heuristic_ws.free_ws;
-	} else {
-		idle_ws	 = &btrfs_comp_ws[idx].idle_ws;
-		ws_lock	 = &btrfs_comp_ws[idx].ws_lock;
-		total_ws = &btrfs_comp_ws[idx].total_ws;
-		ws_wait	 = &btrfs_comp_ws[idx].ws_wait;
-		free_ws	 = &btrfs_comp_ws[idx].free_ws;
-	}
+	idle_ws	 = &btrfs_comp_ws[idx].idle_ws;
+	ws_lock	 = &btrfs_comp_ws[idx].ws_lock;
+	total_ws = &btrfs_comp_ws[idx].total_ws;
+	ws_wait	 = &btrfs_comp_ws[idx].ws_wait;
+	free_ws	 = &btrfs_comp_ws[idx].free_ws;
 
 again:
 	spin_lock(ws_lock);
@@ -933,10 +979,7 @@ static struct list_head *__find_workspace(int type, bool heuristic)
 	 * context of btrfs_compress_bio/btrfs_compress_pages
 	 */
 	nofs_flag = memalloc_nofs_save();
-	if (heuristic)
-		workspace = alloc_heuristic_ws();
-	else
-		workspace = btrfs_compress_op[idx]->alloc_workspace();
+	workspace = btrfs_compress_op[idx]->alloc_workspace();
 	memalloc_nofs_restore(nofs_flag);
 
 	if (IS_ERR(workspace)) {
@@ -967,17 +1010,11 @@ static struct list_head *__find_workspace(int type, bool heuristic)
 	return workspace;
 }
 
-static struct list_head *find_workspace(int type)
-{
-	return __find_workspace(type, false);
-}
-
 /*
  * put a workspace struct back on the list or free it if we have enough
  * idle ones sitting around
  */
-static void __free_workspace(int type, struct list_head *workspace,
-			     bool heuristic)
+static void free_workspace(int type, struct list_head *workspace)
 {
 	int idx = type - 1;
 	struct list_head *idle_ws;
@@ -986,19 +1023,11 @@ static void __free_workspace(int type, struct list_head *workspace,
 	wait_queue_head_t *ws_wait;
 	int *free_ws;
 
-	if (heuristic) {
-		idle_ws	 = &btrfs_heuristic_ws.idle_ws;
-		ws_lock	 = &btrfs_heuristic_ws.ws_lock;
-		total_ws = &btrfs_heuristic_ws.total_ws;
-		ws_wait	 = &btrfs_heuristic_ws.ws_wait;
-		free_ws	 = &btrfs_heuristic_ws.free_ws;
-	} else {
-		idle_ws	 = &btrfs_comp_ws[idx].idle_ws;
-		ws_lock	 = &btrfs_comp_ws[idx].ws_lock;
-		total_ws = &btrfs_comp_ws[idx].total_ws;
-		ws_wait	 = &btrfs_comp_ws[idx].ws_wait;
-		free_ws	 = &btrfs_comp_ws[idx].free_ws;
-	}
+	idle_ws	 = &btrfs_comp_ws[idx].idle_ws;
+	ws_lock	 = &btrfs_comp_ws[idx].ws_lock;
+	total_ws = &btrfs_comp_ws[idx].total_ws;
+	ws_wait	 = &btrfs_comp_ws[idx].ws_wait;
+	free_ws	 = &btrfs_comp_ws[idx].free_ws;
 
 	spin_lock(ws_lock);
 	if (*free_ws <= num_online_cpus()) {
@@ -1009,10 +1038,7 @@ static void __free_workspace(int type, struct list_head *workspace,
 	}
 	spin_unlock(ws_lock);
 
-	if (heuristic)
-		free_heuristic_ws(workspace);
-	else
-		btrfs_compress_op[idx]->free_workspace(workspace);
+	btrfs_compress_op[idx]->free_workspace(workspace);
 	atomic_dec(total_ws);
 wake:
 	/*
@@ -1023,11 +1049,6 @@ static void __free_workspace(int type, struct list_head *workspace,
 		wake_up(ws_wait);
 }
 
-static void free_workspace(int type, struct list_head *ws)
-{
-	return __free_workspace(type, ws, false);
-}
-
 /*
  * cleanup function for module exit
  */
@@ -1036,12 +1057,7 @@ static void free_workspaces(void)
 	struct list_head *workspace;
 	int i;
 
-	while (!list_empty(&btrfs_heuristic_ws.idle_ws)) {
-		workspace = btrfs_heuristic_ws.idle_ws.next;
-		list_del(workspace);
-		free_heuristic_ws(workspace);
-		atomic_dec(&btrfs_heuristic_ws.total_ws);
-	}
+	mempool_destroy(btrfs_heuristic_ws_stor.pool);
 
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
 		while (!list_empty(&btrfs_comp_ws[i].idle_ws)) {
@@ -1558,13 +1574,12 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
  */
 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 {
-	struct list_head *ws_list = __find_workspace(0, true);
 	struct heuristic_ws *ws;
 	u32 i;
 	u8 byte;
 	int ret = 0;
 
-	ws = list_entry(ws_list, struct heuristic_ws, list);
+	ws = mempool_alloc_wrap(&btrfs_heuristic_ws_stor);
 
 	heuristic_collect_sample(inode, start, end, ws);
 
@@ -1627,7 +1642,7 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 	}
 
 out:
-	__free_workspace(0, ws_list, true);
+	mempool_free_wrap(ws, &btrfs_heuristic_ws_stor);
 	return ret;
 }
 
-- 
2.15.1

