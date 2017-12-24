Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36148 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756514AbdLXEzq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Dec 2017 23:55:46 -0500
Received: by mail-wm0-f68.google.com with SMTP id b76so27972344wmg.1
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Dec 2017 20:55:45 -0800 (PST)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH 2/2] Btrfs: compression: replace workspace managment code by mempool API
Date: Sun, 24 Dec 2017 07:55:28 +0300
Message-Id: <20171224045528.12991-3-nefelim4ag@gmail.com>
In-Reply-To: <20171224045528.12991-1-nefelim4ag@gmail.com>
References: <20171224045528.12991-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mostly cleanup of old code and replace
old API with new one.

1. Drop old linked list based approach

2. Replace all ERR_PTR(-ENOMEM) with NULL, as mempool code
   only understood NULL

3. mempool call alloc methods on create/resize,
   so for be sure, move nofs_{save,restore} to
   appropriate places

4. Update btrfs_comp_op to use void *ws, instead of list_head *ws

5. LZO more aggressive use of kmalloc on order 1 alloc,
   for more aggressive fallback to mempool

6. Refactor alloc functions to check every allocation,
   because mempool flags are aggressive and can fail more
   frequently.

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 213 +++++++++----------------------------------------
 fs/btrfs/compression.h |  12 +--
 fs/btrfs/lzo.c         |  64 +++++++++------
 fs/btrfs/zlib.c        |  56 +++++++------
 fs/btrfs/zstd.c        |  49 +++++++-----
 5 files changed, 148 insertions(+), 246 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 02bd60357f04..869df3f5bd1b 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -811,23 +811,12 @@ static void *heuristic_ws_alloc(gfp_t gfp_mask, void *pool_data)
 	return NULL;
 }
 
-struct workspaces_list {
-	struct list_head idle_ws;
-	spinlock_t ws_lock;
-	/* Number of free workspaces */
-	int free_ws;
-	/* Total number of allocated workspaces */
-	atomic_t total_ws;
-	/* Waiters for a free workspace */
-	wait_queue_head_t ws_wait;
-};
-
 struct workspace_stor {
 	mempool_t *pool;
 };
 
 static struct workspace_stor btrfs_heuristic_ws_stor;
-static struct workspaces_list btrfs_comp_ws[BTRFS_COMPRESS_TYPES];
+static struct workspace_stor btrfs_comp_stor[BTRFS_COMPRESS_TYPES];
 
 static const struct btrfs_compress_op * const btrfs_compress_op[] = {
 	&btrfs_zlib_compress,
@@ -837,14 +826,14 @@ static const struct btrfs_compress_op * const btrfs_compress_op[] = {
 
 void __init btrfs_init_compress(void)
 {
-	struct list_head *workspace;
 	int i;
-	mempool_t *pool = btrfs_heuristic_ws_stor.pool;
+	mempool_t *pool;
 
 	/*
 	 * Preallocate one workspace for heuristic so
 	 * we can guarantee forward progress in the worst case
 	 */
+	pool = btrfs_heuristic_ws_stor.pool;
 	pool = mempool_create(1, heuristic_ws_alloc,
 				 heuristic_ws_free, NULL);
 
@@ -852,23 +841,17 @@ void __init btrfs_init_compress(void)
 		pr_warn("BTRFS: cannot preallocate heuristic workspace, will try later\n");
 
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
-		INIT_LIST_HEAD(&btrfs_comp_ws[i].idle_ws);
-		spin_lock_init(&btrfs_comp_ws[i].ws_lock);
-		atomic_set(&btrfs_comp_ws[i].total_ws, 0);
-		init_waitqueue_head(&btrfs_comp_ws[i].ws_wait);
-
+		pool = btrfs_comp_stor[i].pool;
 		/*
 		 * Preallocate one workspace for each compression type so
 		 * we can guarantee forward progress in the worst case
 		 */
-		workspace = btrfs_compress_op[i]->alloc_workspace();
-		if (IS_ERR(workspace)) {
+		pool = mempool_create(1, btrfs_compress_op[i]->alloc_workspace,
+				      btrfs_compress_op[i]->free_workspace,
+				      NULL);
+
+		if (pool == NULL)
 			pr_warn("BTRFS: cannot preallocate compression workspace, will try later\n");
-		} else {
-			atomic_set(&btrfs_comp_ws[i].total_ws, 1);
-			btrfs_comp_ws[i].free_ws = 1;
-			list_add(workspace, &btrfs_comp_ws[i].idle_ws);
-		}
 	}
 }
 
@@ -881,6 +864,7 @@ static void *mempool_alloc_wrap(struct workspace_stor *stor)
 	int ncpu = num_online_cpus();
 
 	while (unlikely(stor->pool == NULL)) {
+		int i;
 		mempool_t *pool;
 		void *(*ws_alloc)(gfp_t gfp_mask, void *pool_data);
 		void (*ws_free)(void *element, void *pool_data);
@@ -888,6 +872,13 @@ static void *mempool_alloc_wrap(struct workspace_stor *stor)
 		if (stor == &btrfs_heuristic_ws_stor) {
 			ws_alloc = heuristic_ws_alloc;
 			ws_free  = heuristic_ws_free;
+		} else {
+			for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
+				if (stor == &btrfs_comp_stor[i])
+					break;
+			}
+			ws_alloc = btrfs_compress_op[i]->alloc_workspace;
+			ws_free  = btrfs_compress_op[i]->free_workspace;
 		}
 
 		pool = mempool_create(1, ws_alloc, ws_free, NULL);
@@ -915,7 +906,12 @@ static void *mempool_alloc_wrap(struct workspace_stor *stor)
 	if (stor->pool->min_nr != ncpu)
 		mempool_resize(stor->pool, ncpu);
 
-	return mempool_alloc(stor->pool, GFP_KERNEL);
+	/*
+	 * Allocation helpers call vmalloc that can't use GFP_NOFS.
+	 * mempool call alloc/free function indirectly on init/mempool_resize
+	 * so that must be handled at specified alloc/free functions
+	 */
+	return mempool_alloc(stor->pool, GFP_KERNEL | GFP_NOFS);
 }
 
 /*
@@ -926,147 +922,17 @@ static inline void mempool_free_wrap(void *element, struct workspace_stor *stor)
 	mempool_free(element, stor->pool);
 }
 
-/*
- * This finds an available workspace or allocates a new one.
- * If it's not possible to allocate a new one, waits until there's one.
- * Preallocation makes a forward progress guarantees and we do not return
- * errors.
- */
-static struct list_head *find_workspace(int type)
-{
-	struct list_head *workspace;
-	int cpus = num_online_cpus();
-	int idx = type - 1;
-	unsigned nofs_flag;
-	struct list_head *idle_ws;
-	spinlock_t *ws_lock;
-	atomic_t *total_ws;
-	wait_queue_head_t *ws_wait;
-	int *free_ws;
-
-	idle_ws	 = &btrfs_comp_ws[idx].idle_ws;
-	ws_lock	 = &btrfs_comp_ws[idx].ws_lock;
-	total_ws = &btrfs_comp_ws[idx].total_ws;
-	ws_wait	 = &btrfs_comp_ws[idx].ws_wait;
-	free_ws	 = &btrfs_comp_ws[idx].free_ws;
-
-again:
-	spin_lock(ws_lock);
-	if (!list_empty(idle_ws)) {
-		workspace = idle_ws->next;
-		list_del(workspace);
-		(*free_ws)--;
-		spin_unlock(ws_lock);
-		return workspace;
-
-	}
-	if (atomic_read(total_ws) > cpus) {
-		DEFINE_WAIT(wait);
-
-		spin_unlock(ws_lock);
-		prepare_to_wait(ws_wait, &wait, TASK_UNINTERRUPTIBLE);
-		if (atomic_read(total_ws) > cpus && !*free_ws)
-			schedule();
-		finish_wait(ws_wait, &wait);
-		goto again;
-	}
-	atomic_inc(total_ws);
-	spin_unlock(ws_lock);
-
-	/*
-	 * Allocation helpers call vmalloc that can't use GFP_NOFS, so we have
-	 * to turn it off here because we might get called from the restricted
-	 * context of btrfs_compress_bio/btrfs_compress_pages
-	 */
-	nofs_flag = memalloc_nofs_save();
-	workspace = btrfs_compress_op[idx]->alloc_workspace();
-	memalloc_nofs_restore(nofs_flag);
-
-	if (IS_ERR(workspace)) {
-		atomic_dec(total_ws);
-		wake_up(ws_wait);
-
-		/*
-		 * Do not return the error but go back to waiting. There's a
-		 * workspace preallocated for each type and the compression
-		 * time is bounded so we get to a workspace eventually. This
-		 * makes our caller's life easier.
-		 *
-		 * To prevent silent and low-probability deadlocks (when the
-		 * initial preallocation fails), check if there are any
-		 * workspaces at all.
-		 */
-		if (atomic_read(total_ws) == 0) {
-			static DEFINE_RATELIMIT_STATE(_rs,
-					/* once per minute */ 60 * HZ,
-					/* no burst */ 1);
-
-			if (__ratelimit(&_rs)) {
-				pr_warn("BTRFS: no compression workspaces, low memory, retrying\n");
-			}
-		}
-		goto again;
-	}
-	return workspace;
-}
-
-/*
- * put a workspace struct back on the list or free it if we have enough
- * idle ones sitting around
- */
-static void free_workspace(int type, struct list_head *workspace)
-{
-	int idx = type - 1;
-	struct list_head *idle_ws;
-	spinlock_t *ws_lock;
-	atomic_t *total_ws;
-	wait_queue_head_t *ws_wait;
-	int *free_ws;
-
-	idle_ws	 = &btrfs_comp_ws[idx].idle_ws;
-	ws_lock	 = &btrfs_comp_ws[idx].ws_lock;
-	total_ws = &btrfs_comp_ws[idx].total_ws;
-	ws_wait	 = &btrfs_comp_ws[idx].ws_wait;
-	free_ws	 = &btrfs_comp_ws[idx].free_ws;
-
-	spin_lock(ws_lock);
-	if (*free_ws <= num_online_cpus()) {
-		list_add(workspace, idle_ws);
-		(*free_ws)++;
-		spin_unlock(ws_lock);
-		goto wake;
-	}
-	spin_unlock(ws_lock);
-
-	btrfs_compress_op[idx]->free_workspace(workspace);
-	atomic_dec(total_ws);
-wake:
-	/*
-	 * Make sure counter is updated before we wake up waiters.
-	 */
-	smp_mb();
-	if (waitqueue_active(ws_wait))
-		wake_up(ws_wait);
-}
-
 /*
  * cleanup function for module exit
  */
 static void free_workspaces(void)
 {
-	struct list_head *workspace;
 	int i;
 
 	mempool_destroy(btrfs_heuristic_ws_stor.pool);
 
-	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
-		while (!list_empty(&btrfs_comp_ws[i].idle_ws)) {
-			workspace = btrfs_comp_ws[i].idle_ws.next;
-			list_del(workspace);
-			btrfs_compress_op[i]->free_workspace(workspace);
-			atomic_dec(&btrfs_comp_ws[i].total_ws);
-		}
-	}
+	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++)
+		mempool_destroy(btrfs_comp_stor[i].pool);
 }
 
 /*
@@ -1098,18 +964,18 @@ int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
 			 unsigned long *total_in,
 			 unsigned long *total_out)
 {
-	struct list_head *workspace;
+	void *ws;
 	int ret;
 	int type = type_level & 0xF;
 
-	workspace = find_workspace(type);
-
-	btrfs_compress_op[type - 1]->set_level(workspace, type_level);
-	ret = btrfs_compress_op[type-1]->compress_pages(workspace, mapping,
+	ws =  mempool_alloc_wrap(&btrfs_comp_stor[type - 1]);
+	btrfs_compress_op[type - 1]->set_level(ws, type_level);
+	ret = btrfs_compress_op[type-1]->compress_pages(ws, mapping,
 						      start, pages,
 						      out_pages,
 						      total_in, total_out);
-	free_workspace(type, workspace);
+
+	mempool_free_wrap(ws, &btrfs_comp_stor[type - 1]);
 	return ret;
 }
 
@@ -1129,13 +995,13 @@ int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
  */
 static int btrfs_decompress_bio(struct compressed_bio *cb)
 {
-	struct list_head *workspace;
+	void *ws;
 	int ret;
 	int type = cb->compress_type;
 
-	workspace = find_workspace(type);
-	ret = btrfs_compress_op[type - 1]->decompress_bio(workspace, cb);
-	free_workspace(type, workspace);
+	ws = mempool_alloc_wrap(&btrfs_comp_stor[type - 1]);
+	ret = btrfs_compress_op[type - 1]->decompress_bio(ws, cb);
+	mempool_free_wrap(ws, &btrfs_comp_stor[type - 1]);
 
 	return ret;
 }
@@ -1148,16 +1014,15 @@ static int btrfs_decompress_bio(struct compressed_bio *cb)
 int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 		     unsigned long start_byte, size_t srclen, size_t destlen)
 {
-	struct list_head *workspace;
+	void *ws;
 	int ret;
 
-	workspace = find_workspace(type);
-
-	ret = btrfs_compress_op[type-1]->decompress(workspace, data_in,
+	ws = mempool_alloc_wrap(&btrfs_comp_stor[type - 1]);
+	ret = btrfs_compress_op[type-1]->decompress(ws, data_in,
 						  dest_page, start_byte,
 						  srclen, destlen);
 
-	free_workspace(type, workspace);
+	mempool_free_wrap(ws, &btrfs_comp_stor[type - 1]);
 	return ret;
 }
 
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 677fa4aa0bd7..3b8d7c0dee91 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -109,11 +109,11 @@ enum btrfs_compression_type {
 };
 
 struct btrfs_compress_op {
-	struct list_head *(*alloc_workspace)(void);
+	void *(*alloc_workspace)(gfp_t gfp_mask, void *pool_data);
 
-	void (*free_workspace)(struct list_head *workspace);
+	void (*free_workspace)(void *element, void *pool_data);
 
-	int (*compress_pages)(struct list_head *workspace,
+	int (*compress_pages)(void *ws,
 			      struct address_space *mapping,
 			      u64 start,
 			      struct page **pages,
@@ -121,16 +121,16 @@ struct btrfs_compress_op {
 			      unsigned long *total_in,
 			      unsigned long *total_out);
 
-	int (*decompress_bio)(struct list_head *workspace,
+	int (*decompress_bio)(void *ws,
 				struct compressed_bio *cb);
 
-	int (*decompress)(struct list_head *workspace,
+	int (*decompress)(void *ws,
 			  unsigned char *data_in,
 			  struct page *dest_page,
 			  unsigned long start_byte,
 			  size_t srclen, size_t destlen);
 
-	void (*set_level)(struct list_head *ws, unsigned int type);
+	void (*set_level)(void *ws, unsigned int type);
 };
 
 extern const struct btrfs_compress_op btrfs_zlib_compress;
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 6c7f18cd3b61..744f4abc3703 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -26,6 +26,7 @@
 #include <linux/bio.h>
 #include <linux/lzo.h>
 #include <linux/refcount.h>
+#include <linux/sched/mm.h>
 #include "compression.h"
 
 #define LZO_LEN	4
@@ -34,39 +35,56 @@ struct workspace {
 	void *mem;
 	void *buf;	/* where decompressed data goes */
 	void *cbuf;	/* where compressed data goes */
-	struct list_head list;
 };
 
-static void lzo_free_workspace(struct list_head *ws)
+static void lzo_free_workspace(void *element, void *pool_data)
 {
-	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	struct workspace *workspace = (struct workspace *) element;
 
-	kvfree(workspace->buf);
-	kvfree(workspace->cbuf);
+	kfree(workspace->buf);
+	kfree(workspace->cbuf);
 	kvfree(workspace->mem);
 	kfree(workspace);
 }
 
-static struct list_head *lzo_alloc_workspace(void)
+static void *lzo_alloc_workspace(gfp_t gfp_mask, void *pool_data)
 {
 	struct workspace *workspace;
+	unsigned nofs_flag;
 
-	workspace = kzalloc(sizeof(*workspace), GFP_KERNEL);
+	workspace = kzalloc(sizeof(*workspace), gfp_mask);
 	if (!workspace)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
-	workspace->mem = kvmalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
-	workspace->buf = kvmalloc(lzo1x_worst_compress(PAGE_SIZE), GFP_KERNEL);
-	workspace->cbuf = kvmalloc(lzo1x_worst_compress(PAGE_SIZE), GFP_KERNEL);
-	if (!workspace->mem || !workspace->buf || !workspace->cbuf)
+	/*
+	 * That allocations size are 107% of order 0
+	 * So it's easy fits to slab order 1 cache and that allow
+	 * Aggressive fallback to mempool memory
+	 */
+	workspace->buf = kmalloc(lzo1x_worst_compress(PAGE_SIZE), gfp_mask);
+	if (!workspace->buf)
+		goto fail;
+
+	workspace->cbuf = kmalloc(lzo1x_worst_compress(PAGE_SIZE), gfp_mask);
+	if (!workspace->cbuf)
 		goto fail;
 
-	INIT_LIST_HEAD(&workspace->list);
+	nofs_flag = memalloc_nofs_save();
+	/*
+	 * Order 2 allication
+	 * kvmalloc require gfp_mask superset of GFP_KERNEL
+	 * But we still need want GFP_NOFS
+	 */
+	gfp_mask |= GFP_KERNEL;
+	workspace->mem = kvmalloc(LZO1X_MEM_COMPRESS, gfp_mask);
+	memalloc_nofs_restore(nofs_flag);
+	if (!workspace->mem)
+		goto fail;
 
-	return &workspace->list;
+	return workspace;
 fail:
-	lzo_free_workspace(&workspace->list);
-	return ERR_PTR(-ENOMEM);
+	lzo_free_workspace(workspace, NULL);
+	return NULL;
 }
 
 static inline void write_compress_length(char *buf, size_t len)
@@ -85,7 +103,7 @@ static inline size_t read_compress_length(const char *buf)
 	return le32_to_cpu(dlen);
 }
 
-static int lzo_compress_pages(struct list_head *ws,
+static int lzo_compress_pages(void *ws,
 			      struct address_space *mapping,
 			      u64 start,
 			      struct page **pages,
@@ -93,7 +111,7 @@ static int lzo_compress_pages(struct list_head *ws,
 			      unsigned long *total_in,
 			      unsigned long *total_out)
 {
-	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	struct workspace *workspace = (struct workspace *) ws;
 	int ret = 0;
 	char *data_in;
 	char *cpage_out;
@@ -257,9 +275,9 @@ static int lzo_compress_pages(struct list_head *ws,
 	return ret;
 }
 
-static int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
+static int lzo_decompress_bio(void *ws, struct compressed_bio *cb)
 {
-	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	struct workspace *workspace = (struct workspace *) ws;
 	int ret = 0, ret2;
 	char *data_in;
 	unsigned long page_in_index = 0;
@@ -374,12 +392,12 @@ static int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 	return ret;
 }
 
-static int lzo_decompress(struct list_head *ws, unsigned char *data_in,
+static int lzo_decompress(void *ws, unsigned char *data_in,
 			  struct page *dest_page,
 			  unsigned long start_byte,
 			  size_t srclen, size_t destlen)
 {
-	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	struct workspace *workspace = (struct workspace *) ws;
 	size_t in_len;
 	size_t out_len;
 	size_t tot_len;
@@ -430,7 +448,7 @@ static int lzo_decompress(struct list_head *ws, unsigned char *data_in,
 	return ret;
 }
 
-static void lzo_set_level(struct list_head *ws, unsigned int type)
+static void lzo_set_level(void *ws, unsigned int type)
 {
 }
 
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 2b52950dc2c6..4d9d189d77ee 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -31,49 +31,59 @@
 #include <linux/pagemap.h>
 #include <linux/bio.h>
 #include <linux/refcount.h>
+#include <linux/sched/mm.h>
 #include "compression.h"
 
 struct workspace {
 	z_stream strm;
 	char *buf;
-	struct list_head list;
 	int level;
 };
 
-static void zlib_free_workspace(struct list_head *ws)
+static void zlib_free_workspace(void *element, void *pool_data)
 {
-	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	struct workspace *workspace = (struct workspace *) element;
 
 	kvfree(workspace->strm.workspace);
 	kfree(workspace->buf);
 	kfree(workspace);
 }
 
-static struct list_head *zlib_alloc_workspace(void)
+static void *zlib_alloc_workspace(gfp_t gfp_mask, void *pool_data)
 {
 	struct workspace *workspace;
 	int workspacesize;
+	unsigned nofs_flag;
 
-	workspace = kzalloc(sizeof(*workspace), GFP_KERNEL);
+	workspace = kzalloc(sizeof(*workspace), gfp_mask);
 	if (!workspace)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
-	workspacesize = max(zlib_deflate_workspacesize(MAX_WBITS, MAX_MEM_LEVEL),
-			zlib_inflate_workspacesize());
-	workspace->strm.workspace = kvmalloc(workspacesize, GFP_KERNEL);
-	workspace->buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!workspace->strm.workspace || !workspace->buf)
+	workspace->buf = kmalloc(PAGE_SIZE, gfp_mask);
+	if (!workspace->buf)
 		goto fail;
 
-	INIT_LIST_HEAD(&workspace->list);
+	workspacesize = zlib_deflate_workspacesize(MAX_WBITS, MAX_MEM_LEVEL);
+	workspacesize = max(workspacesize, zlib_inflate_workspacesize());
 
-	return &workspace->list;
+	/*
+	 * kvmalloc require gfp_mask superset of GFP_KERNEL
+	 * But we still need want GFP_NOFS
+	 */
+	gfp_mask |= GFP_KERNEL;
+	nofs_flag = memalloc_nofs_save();
+	workspace->strm.workspace = kvmalloc(workspacesize, gfp_mask);
+	memalloc_nofs_restore(nofs_flag);
+	if (!workspace->strm.workspace)
+		goto fail;
+
+	return workspace;
 fail:
-	zlib_free_workspace(&workspace->list);
-	return ERR_PTR(-ENOMEM);
+	zlib_free_workspace(workspace, NULL);
+	return NULL;
 }
 
-static int zlib_compress_pages(struct list_head *ws,
+static int zlib_compress_pages(void *ws,
 			       struct address_space *mapping,
 			       u64 start,
 			       struct page **pages,
@@ -81,7 +91,7 @@ static int zlib_compress_pages(struct list_head *ws,
 			       unsigned long *total_in,
 			       unsigned long *total_out)
 {
-	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	struct workspace *workspace = (struct workspace *) ws;
 	int ret;
 	char *data_in;
 	char *cpage_out;
@@ -213,9 +223,9 @@ static int zlib_compress_pages(struct list_head *ws,
 	return ret;
 }
 
-static int zlib_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
+static int zlib_decompress_bio(void *ws, struct compressed_bio *cb)
 {
-	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	struct workspace *workspace = (struct workspace *) ws;
 	int ret = 0, ret2;
 	int wbits = MAX_WBITS;
 	char *data_in;
@@ -304,12 +314,12 @@ static int zlib_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 	return ret;
 }
 
-static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
+static int zlib_decompress(void *ws, unsigned char *data_in,
 			   struct page *dest_page,
 			   unsigned long start_byte,
 			   size_t srclen, size_t destlen)
 {
-	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	struct workspace *workspace = (struct workspace *) ws;
 	int ret = 0;
 	int wbits = MAX_WBITS;
 	unsigned long bytes_left;
@@ -403,9 +413,9 @@ static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
 	return ret;
 }
 
-static void zlib_set_level(struct list_head *ws, unsigned int type)
+static void zlib_set_level(void *ws, unsigned int type)
 {
-	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	struct workspace *workspace = (struct workspace *) ws;
 	unsigned level = (type & 0xF0) >> 4;
 
 	if (level > 9)
diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index 01a4eab602a3..736d2cd4e2fd 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/zstd.h>
+#include <linux/sched/mm.h>
 #include "compression.h"
 
 #define ZSTD_BTRFS_MAX_WINDOWLOG 17
@@ -42,47 +43,55 @@ struct workspace {
 	void *mem;
 	size_t size;
 	char *buf;
-	struct list_head list;
 	ZSTD_inBuffer in_buf;
 	ZSTD_outBuffer out_buf;
 };
 
-static void zstd_free_workspace(struct list_head *ws)
+static void zstd_free_workspace(void *element, void *pool_data)
 {
-	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	struct workspace *workspace = (struct workspace *) element;
 
 	kvfree(workspace->mem);
 	kfree(workspace->buf);
 	kfree(workspace);
 }
 
-static struct list_head *zstd_alloc_workspace(void)
+static void *zstd_alloc_workspace(gfp_t gfp_mask, void *pool_data)
 {
 	ZSTD_parameters params =
 			zstd_get_btrfs_parameters(ZSTD_BTRFS_MAX_INPUT);
 	struct workspace *workspace;
+	unsigned nofs_flag;
 
-	workspace = kzalloc(sizeof(*workspace), GFP_KERNEL);
+	workspace = kzalloc(sizeof(*workspace), gfp_mask);
 	if (!workspace)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
+
+	workspace->buf = kmalloc(PAGE_SIZE, gfp_mask);
+	if (!workspace->buf)
+		return NULL;
 
 	workspace->size = max_t(size_t,
 			ZSTD_CStreamWorkspaceBound(params.cParams),
 			ZSTD_DStreamWorkspaceBound(ZSTD_BTRFS_MAX_INPUT));
+	/*
+	 * kvmalloc require gfp_mask superset of GFP_KERNEL
+	 * But we still need want GFP_NOFS
+	 */
+	gfp_mask |= GFP_KERNEL;
+	nofs_flag = memalloc_nofs_save();
 	workspace->mem = kvmalloc(workspace->size, GFP_KERNEL);
-	workspace->buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!workspace->mem || !workspace->buf)
+	memalloc_nofs_restore(nofs_flag);
+	if (!workspace->mem)
 		goto fail;
 
-	INIT_LIST_HEAD(&workspace->list);
-
-	return &workspace->list;
+	return workspace;
 fail:
-	zstd_free_workspace(&workspace->list);
-	return ERR_PTR(-ENOMEM);
+	zstd_free_workspace(workspace, NULL);
+	return NULL;
 }
 
-static int zstd_compress_pages(struct list_head *ws,
+static int zstd_compress_pages(void *ws,
 		struct address_space *mapping,
 		u64 start,
 		struct page **pages,
@@ -90,7 +99,7 @@ static int zstd_compress_pages(struct list_head *ws,
 		unsigned long *total_in,
 		unsigned long *total_out)
 {
-	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	struct workspace *workspace = (struct workspace *) ws;
 	ZSTD_CStream *stream;
 	int ret = 0;
 	int nr_pages = 0;
@@ -262,9 +271,9 @@ static int zstd_compress_pages(struct list_head *ws,
 	return ret;
 }
 
-static int zstd_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
+static int zstd_decompress_bio(void *ws, struct compressed_bio *cb)
 {
-	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	struct workspace *workspace = (struct workspace *) ws;
 	struct page **pages_in = cb->compressed_pages;
 	u64 disk_start = cb->start;
 	struct bio *orig_bio = cb->orig_bio;
@@ -340,12 +349,12 @@ static int zstd_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 	return ret;
 }
 
-static int zstd_decompress(struct list_head *ws, unsigned char *data_in,
+static int zstd_decompress(void *ws, unsigned char *data_in,
 		struct page *dest_page,
 		unsigned long start_byte,
 		size_t srclen, size_t destlen)
 {
-	struct workspace *workspace = list_entry(ws, struct workspace, list);
+	struct workspace *workspace = (struct workspace *) ws;
 	ZSTD_DStream *stream;
 	int ret = 0;
 	size_t ret2;
@@ -425,7 +434,7 @@ static int zstd_decompress(struct list_head *ws, unsigned char *data_in,
 	return ret;
 }
 
-static void zstd_set_level(struct list_head *ws, unsigned int type)
+static void zstd_set_level(void *ws, unsigned int type)
 {
 }
 
-- 
2.15.1

