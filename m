Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:53989 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753334AbdI1Odv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 10:33:51 -0400
Received: by mail-wm0-f67.google.com with SMTP id q132so2701861wmd.2
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Sep 2017 07:33:51 -0700 (PDT)
From: Timofey Titovets <nefelim4ag@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Timofey Titovets <nefelim4ag@gmail.com>
Subject: [PATCH v8 1/6] Btrfs: compression.c separated heuristic/compression workspaces
Date: Thu, 28 Sep 2017 17:33:36 +0300
Message-Id: <20170928143341.24491-2-nefelim4ag@gmail.com>
In-Reply-To: <20170928143341.24491-1-nefelim4ag@gmail.com>
References: <20170928143341.24491-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Compression heuristic itself is not a compression type,
as current infrastructure supposed to provide workspaces
for several compression types, it's difficult to just add
heuristic workspace.

Just refactor the code to support compression/heuristic
workspaces with maximum code sharing and minimum changes in it.

Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
---
 fs/btrfs/compression.c | 138 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 120 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b51d23f5cafa..c3624e8e3919 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -690,7 +690,33 @@ blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	return ret;
 }

-static struct {
+
+struct heuristic_ws {
+	struct list_head list;
+};
+
+static void free_heuristic_ws(struct list_head *ws)
+{
+	struct heuristic_ws *workspace;
+
+	workspace = list_entry(ws, struct heuristic_ws, list);
+
+	kfree(workspace);
+}
+
+static struct list_head *alloc_heuristic_ws(void){
+	struct heuristic_ws *ws;
+
+	ws = kzalloc(sizeof(*ws), GFP_KERNEL);
+	if (!ws)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&ws->list);
+
+	return &ws->list;
+}
+
+struct workspaces_list {
 	struct list_head idle_ws;
 	spinlock_t ws_lock;
 	/* Number of free workspaces */
@@ -699,7 +725,11 @@ static struct {
 	atomic_t total_ws;
 	/* Waiters for a free workspace */
 	wait_queue_head_t ws_wait;
-} btrfs_comp_ws[BTRFS_COMPRESS_TYPES];
+};
+
+static struct workspaces_list btrfs_comp_ws[BTRFS_COMPRESS_TYPES];
+
+static struct workspaces_list btrfs_heuristic_ws;

 static const struct btrfs_compress_op * const btrfs_compress_op[] = {
 	&btrfs_zlib_compress,
@@ -709,11 +739,24 @@ static const struct btrfs_compress_op * const btrfs_compress_op[] = {

 void __init btrfs_init_compress(void)
 {
+	struct list_head *workspace;
 	int i;

-	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
-		struct list_head *workspace;
+	INIT_LIST_HEAD(&btrfs_heuristic_ws.idle_ws);
+	spin_lock_init(&btrfs_heuristic_ws.ws_lock);
+	atomic_set(&btrfs_heuristic_ws.total_ws, 0);
+	init_waitqueue_head(&btrfs_heuristic_ws.ws_wait);

+	workspace = alloc_heuristic_ws();
+	if (IS_ERR(workspace)) {
+		pr_warn("BTRFS: cannot preallocate heuristic workspace, will try later\n");
+	} else {
+		atomic_set(&btrfs_heuristic_ws.total_ws, 1);
+		btrfs_heuristic_ws.free_ws = 1;
+		list_add(workspace, &btrfs_heuristic_ws.idle_ws);
+	}
+
+	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
 		INIT_LIST_HEAD(&btrfs_comp_ws[i].idle_ws);
 		spin_lock_init(&btrfs_comp_ws[i].ws_lock);
 		atomic_set(&btrfs_comp_ws[i].total_ws, 0);
@@ -740,18 +783,33 @@ void __init btrfs_init_compress(void)
  * Preallocation makes a forward progress guarantees and we do not return
  * errors.
  */
-static struct list_head *find_workspace(int type)
+static struct list_head *__find_workspace(int type, bool heuristic)
 {
 	struct list_head *workspace;
 	int cpus = num_online_cpus();
 	int idx = type - 1;
 	unsigned nofs_flag;

-	struct list_head *idle_ws	= &btrfs_comp_ws[idx].idle_ws;
-	spinlock_t *ws_lock		= &btrfs_comp_ws[idx].ws_lock;
-	atomic_t *total_ws		= &btrfs_comp_ws[idx].total_ws;
-	wait_queue_head_t *ws_wait	= &btrfs_comp_ws[idx].ws_wait;
-	int *free_ws			= &btrfs_comp_ws[idx].free_ws;
+	struct list_head *idle_ws;
+	spinlock_t *ws_lock;
+	atomic_t *total_ws;
+	wait_queue_head_t *ws_wait;
+	int *free_ws;
+
+	if (!heuristic) {
+		idle_ws		= &btrfs_comp_ws[idx].idle_ws;
+		ws_lock		= &btrfs_comp_ws[idx].ws_lock;
+		total_ws	= &btrfs_comp_ws[idx].total_ws;
+		ws_wait		= &btrfs_comp_ws[idx].ws_wait;
+		free_ws		= &btrfs_comp_ws[idx].free_ws;
+	} else {
+		idle_ws		= &btrfs_heuristic_ws.idle_ws;
+		ws_lock		= &btrfs_heuristic_ws.ws_lock;
+		total_ws	= &btrfs_heuristic_ws.total_ws;
+		ws_wait		= &btrfs_heuristic_ws.ws_wait;
+		free_ws		= &btrfs_heuristic_ws.free_ws;
+	}
+
 again:
 	spin_lock(ws_lock);
 	if (!list_empty(idle_ws)) {
@@ -781,7 +839,10 @@ static struct list_head *find_workspace(int type)
 	 * context of btrfs_compress_bio/btrfs_compress_pages
 	 */
 	nofs_flag = memalloc_nofs_save();
-	workspace = btrfs_compress_op[idx]->alloc_workspace();
+	if (!heuristic)
+		workspace = btrfs_compress_op[idx]->alloc_workspace();
+	else
+		workspace = alloc_heuristic_ws();
 	memalloc_nofs_restore(nofs_flag);

 	if (IS_ERR(workspace)) {
@@ -812,18 +873,38 @@ static struct list_head *find_workspace(int type)
 	return workspace;
 }

+static struct list_head *find_workspace(int type)
+{
+	return __find_workspace(type, false);
+}
+
 /*
  * put a workspace struct back on the list or free it if we have enough
  * idle ones sitting around
  */
-static void free_workspace(int type, struct list_head *workspace)
+static void __free_workspace(int type, struct list_head *workspace,
+			     bool heuristic)
 {
 	int idx = type - 1;
-	struct list_head *idle_ws	= &btrfs_comp_ws[idx].idle_ws;
-	spinlock_t *ws_lock		= &btrfs_comp_ws[idx].ws_lock;
-	atomic_t *total_ws		= &btrfs_comp_ws[idx].total_ws;
-	wait_queue_head_t *ws_wait	= &btrfs_comp_ws[idx].ws_wait;
-	int *free_ws			= &btrfs_comp_ws[idx].free_ws;
+	struct list_head *idle_ws;
+	spinlock_t *ws_lock;
+	atomic_t *total_ws;
+	wait_queue_head_t *ws_wait;
+	int *free_ws;
+
+	if (!heuristic) {
+		idle_ws		= &btrfs_comp_ws[idx].idle_ws;
+		ws_lock		= &btrfs_comp_ws[idx].ws_lock;
+		total_ws	= &btrfs_comp_ws[idx].total_ws;
+		ws_wait		= &btrfs_comp_ws[idx].ws_wait;
+		free_ws		= &btrfs_comp_ws[idx].free_ws;
+	} else {
+		idle_ws		= &btrfs_heuristic_ws.idle_ws;
+		ws_lock		= &btrfs_heuristic_ws.ws_lock;
+		total_ws	= &btrfs_heuristic_ws.total_ws;
+		ws_wait		= &btrfs_heuristic_ws.ws_wait;
+		free_ws		= &btrfs_heuristic_ws.free_ws;
+	}

 	spin_lock(ws_lock);
 	if (*free_ws <= num_online_cpus()) {
@@ -834,7 +915,10 @@ static void free_workspace(int type, struct list_head *workspace)
 	}
 	spin_unlock(ws_lock);

-	btrfs_compress_op[idx]->free_workspace(workspace);
+	if (!heuristic)
+		btrfs_compress_op[idx]->free_workspace(workspace);
+	else
+		free_heuristic_ws(workspace);
 	atomic_dec(total_ws);
 wake:
 	/*
@@ -845,6 +929,11 @@ static void free_workspace(int type, struct list_head *workspace)
 		wake_up(ws_wait);
 }

+static void free_workspace(int type, struct list_head *ws)
+{
+	return __free_workspace(type, ws, false);
+}
+
 /*
  * cleanup function for module exit
  */
@@ -853,6 +942,13 @@ static void free_workspaces(void)
 	struct list_head *workspace;
 	int i;

+	while (!list_empty(&btrfs_heuristic_ws.idle_ws)) {
+		workspace = btrfs_heuristic_ws.idle_ws.next;
+		list_del(workspace);
+		free_heuristic_ws(workspace);
+		atomic_dec(&btrfs_heuristic_ws.total_ws);
+	}
+
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
 		while (!list_empty(&btrfs_comp_ws[i].idle_ws)) {
 			workspace = btrfs_comp_ws[i].idle_ws.next;
@@ -1066,11 +1162,15 @@ int btrfs_decompress_buf2page(const char *buf, unsigned long buf_start,
  */
 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 {
+	struct list_head *ws_list = __find_workspace(0, true);
+	struct heuristic_ws *ws;
 	u64 index = start >> PAGE_SHIFT;
 	u64 end_index = end >> PAGE_SHIFT;
 	struct page *page;
 	int ret = 1;

+	ws = list_entry(ws_list, struct heuristic_ws, list);
+
 	while (index <= end_index) {
 		page = find_get_page(inode->i_mapping, index);
 		kmap(page);
@@ -1079,5 +1179,7 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 		index++;
 	}

+	__free_workspace(0, ws_list, true);
+
 	return ret;
 }
--
2.14.2
