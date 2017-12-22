Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:39910 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751770AbdLVNtD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Dec 2017 08:49:03 -0500
Received: by mail-wr0-f194.google.com with SMTP id a41so27943108wra.6
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Dec 2017 05:49:03 -0800 (PST)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>, David Sterba <dsterba@suse.com>
Subject: [RFC PATCH] Btrfs: replace custom heuristic ws allocation logic with mempool API
Date: Fri, 22 Dec 2017 16:48:49 +0300
Message-Id: <20171222134849.26587-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently btrfs compression code use custom wrapper
for store allocated compression/heuristic workspaces.

That logic try store at least ncpu+1 each type of workspaces.

As far, as i can see that logic fully reimplement
mempool API.
So i think, that use of mempool api can simplify code
and allow for cleanup it.

That a proof of concept patch, i have tested it (at least that works),
future version will looks mostly same.

If that acceptable,
next step will be:
1. Create mempool_alloc_w()
that will resize mempool to apropriate size ncpu+1
And will create apropriate mempool, if creating failed in __init.

2. Convert per compression ws to mempool.

Thanks.

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
Cc: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 123 ++++++++++++++++---------------------------------
 1 file changed, 39 insertions(+), 84 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 208334aa6c6e..cf47089b9ec0 100644
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
@@ -768,14 +769,11 @@ struct heuristic_ws {
 	struct bucket_item *bucket;
 	/* Sorting buffer */
 	struct bucket_item *bucket_b;
-	struct list_head list;
 };
 
-static void free_heuristic_ws(struct list_head *ws)
+static void heuristic_ws_free(void *element, void *pool_data)
 {
-	struct heuristic_ws *workspace;
-
-	workspace = list_entry(ws, struct heuristic_ws, list);
+	struct heuristic_ws *workspace = (struct heuristic_ws *) element;
 
 	kvfree(workspace->sample);
 	kfree(workspace->bucket);
@@ -783,13 +781,12 @@ static void free_heuristic_ws(struct list_head *ws)
 	kfree(workspace);
 }
 
-static struct list_head *alloc_heuristic_ws(void)
+static void *heuristic_ws_alloc(gfp_t gfp_mask, void *pool_data)
 {
-	struct heuristic_ws *ws;
+	struct heuristic_ws *ws = kmalloc(sizeof(*ws), GFP_KERNEL);
 
-	ws = kzalloc(sizeof(*ws), GFP_KERNEL);
 	if (!ws)
-		return ERR_PTR(-ENOMEM);
+		return ws;
 
 	ws->sample = kvmalloc(MAX_SAMPLE_SIZE, GFP_KERNEL);
 	if (!ws->sample)
@@ -803,11 +800,14 @@ static struct list_head *alloc_heuristic_ws(void)
 	if (!ws->bucket_b)
 		goto fail;
 
-	INIT_LIST_HEAD(&ws->list);
-	return &ws->list;
+	return ws;
+
 fail:
-	free_heuristic_ws(&ws->list);
-	return ERR_PTR(-ENOMEM);
+	kvfree(ws->sample);
+	kfree(ws->bucket);
+	kfree(ws->bucket_b);
+	kfree(ws);
+	return NULL;
 }
 
 struct workspaces_list {
@@ -821,10 +821,9 @@ struct workspaces_list {
 	wait_queue_head_t ws_wait;
 };
 
+static mempool_t *btrfs_heuristic_ws_pool;
 static struct workspaces_list btrfs_comp_ws[BTRFS_COMPRESS_TYPES];
 
-static struct workspaces_list btrfs_heuristic_ws;
-
 static const struct btrfs_compress_op * const btrfs_compress_op[] = {
 	&btrfs_zlib_compress,
 	&btrfs_lzo_compress,
@@ -836,20 +835,15 @@ void __init btrfs_init_compress(void)
 	struct list_head *workspace;
 	int i;
 
-	INIT_LIST_HEAD(&btrfs_heuristic_ws.idle_ws);
-	spin_lock_init(&btrfs_heuristic_ws.ws_lock);
-	atomic_set(&btrfs_heuristic_ws.total_ws, 0);
-	init_waitqueue_head(&btrfs_heuristic_ws.ws_wait);
+	/*
+	 * Try preallocate pool with minimum size for successful
+	 * initialization of btrfs module
+	 */
+	btrfs_heuristic_ws_pool = mempool_create(1, heuristic_ws_alloc,
+					    heuristic_ws_free, NULL);
 
-	workspace = alloc_heuristic_ws();
-	if (IS_ERR(workspace)) {
-		pr_warn(
-	"BTRFS: cannot preallocate heuristic workspace, will try later\n");
-	} else {
-		atomic_set(&btrfs_heuristic_ws.total_ws, 1);
-		btrfs_heuristic_ws.free_ws = 1;
-		list_add(workspace, &btrfs_heuristic_ws.idle_ws);
-	}
+	if (IS_ERR(btrfs_heuristic_ws_pool))
+		pr_warn("BTRFS: cannot preallocate heuristic workspace, will try later\n");
 
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
 		INIT_LIST_HEAD(&btrfs_comp_ws[i].idle_ws);
@@ -878,7 +872,7 @@ void __init btrfs_init_compress(void)
  * Preallocation makes a forward progress guarantees and we do not return
  * errors.
  */
-static struct list_head *__find_workspace(int type, bool heuristic)
+static struct list_head *find_workspace(int type)
 {
 	struct list_head *workspace;
 	int cpus = num_online_cpus();
@@ -890,19 +884,11 @@ static struct list_head *__find_workspace(int type, bool heuristic)
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
@@ -933,10 +919,7 @@ static struct list_head *__find_workspace(int type, bool heuristic)
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
@@ -967,17 +950,11 @@ static struct list_head *__find_workspace(int type, bool heuristic)
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
@@ -986,19 +963,11 @@ static void __free_workspace(int type, struct list_head *workspace,
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
@@ -1009,10 +978,7 @@ static void __free_workspace(int type, struct list_head *workspace,
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
@@ -1023,11 +989,6 @@ static void __free_workspace(int type, struct list_head *workspace,
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
@@ -1036,12 +997,7 @@ static void free_workspaces(void)
 	struct list_head *workspace;
 	int i;
 
-	while (!list_empty(&btrfs_heuristic_ws.idle_ws)) {
-		workspace = btrfs_heuristic_ws.idle_ws.next;
-		list_del(workspace);
-		free_heuristic_ws(workspace);
-		atomic_dec(&btrfs_heuristic_ws.total_ws);
-	}
+	mempool_destroy(btrfs_heuristic_ws_pool);
 
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
 		while (!list_empty(&btrfs_comp_ws[i].idle_ws)) {
@@ -1558,13 +1514,12 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
  */
 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 {
-	struct list_head *ws_list = __find_workspace(0, true);
 	struct heuristic_ws *ws;
 	u32 i;
 	u8 byte;
 	int ret = 0;
 
-	ws = list_entry(ws_list, struct heuristic_ws, list);
+	ws = mempool_alloc(btrfs_heuristic_ws_pool, GFP_KERNEL);
 
 	heuristic_collect_sample(inode, start, end, ws);
 
@@ -1627,7 +1582,7 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 	}
 
 out:
-	__free_workspace(0, ws_list, true);
+	mempool_free(ws, btrfs_heuristic_ws_pool);
 	return ret;
 }
 
-- 
2.15.1
