Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF54C282C8
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 387B921852
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548710730;
	bh=A0Fpz91ZDi5ZwvgNMdr6VsjqgfRvJnqePE1104Vbd9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=G3iWluSFZSTSO5myubDleG5B1HcOKSOuLdmXfRSIqjRkzdnYKTjPMY+iYOKma4Dbq
	 URCxox85kipjAd99AeAujJmWCczG+wzBafA8jtDYvXe2/ZGbPjho215dYYX4vSKmBw
	 IO/u/74KY8rETvog0PRzd65cw7cUqqCcrry4zmGQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfA1VY4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 16:24:56 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:44720 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbfA1VYz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 16:24:55 -0500
Received: by mail-yb1-f195.google.com with SMTP id k189so7307212yba.11;
        Mon, 28 Jan 2019 13:24:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Q0ZvSFCLiR7eTR8xTiZFKMwRMlztmOcs6W4lWC+wmE8=;
        b=cjVhheisfakN3e9wPIk/t6uubHotDSpqs3XTvOqYpyypK18Ks1BOFZj4Is1WqQaldS
         BAegOjlvZrsGwsF20YgDVBxCy7lGW/3b+2BDc1OEY4wUMDM9H3KMKlPzh4gMXC3slnF2
         lalCWCLHCegQcUIBMlQfxgQJsGypv3BS6Et/5u95pkbU2FGu1ByKfAj412O9ENwSKZkm
         1ksNjRc2X4qLRVv5e/G2SM5g67ZnicADAG/C3QfOh04W2GgxQxkirqv5uy5pzncq74Q5
         6gDFCNGi9k2ymG/MJItm4Iw1YYGEkSlsLv4cIKgX47K5YXJ10J6/PD5N6gOfBXY+xly2
         Kp9w==
X-Gm-Message-State: AHQUAubgFJn+/q6hcaKGTzl9rbW95nYGBKcbqgHOti1PSxzuk/2vIHDp
        nKol17pSYKs54LTxbBrAk+o=
X-Google-Smtp-Source: AHgI3Ia36WbIIpamVRjNH4SkkElnXA8w6+SF1a/chvpdveen5rElxe2KQp3/mXPDdUoRY/eSluY9Yw==
X-Received: by 2002:a25:6742:: with SMTP id b63mr9724713ybc.115.1548710694505;
        Mon, 28 Jan 2019 13:24:54 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id a7sm24170415ywb.18.2019.01.28.13.24.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 28 Jan 2019 13:24:53 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 07/11] btrfs: move to fn pointers for get/put workspaces
Date:   Mon, 28 Jan 2019 16:24:33 -0500
Message-Id: <20190128212437.11597-8-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190128212437.11597-1-dennis@kernel.org>
References: <20190128212437.11597-1-dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The previous patch added generic helpers for get_workspace() and
put_workspace(). Now, we can migrate ownership of the workspace_manager
to be in the compression type code as the compression code itself
doesn't care beyond being able to get a workspace. The init/cleanup
and get/put methods are abstracted so each compression algorithm can
decide how they want to manage their workspaces.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 fs/btrfs/compression.c | 101 +++++++++++++++++++++++------------------
 fs/btrfs/compression.h |  26 +++++++++++
 fs/btrfs/lzo.c         |  26 +++++++++++
 fs/btrfs/zlib.c        |  26 +++++++++++
 fs/btrfs/zstd.c        |  26 +++++++++++
 5 files changed, 160 insertions(+), 45 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 2e748d8785f0..ab694760ffdb 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -732,6 +732,28 @@ struct heuristic_ws {
 	struct list_head list;
 };
 
+static struct workspace_manager heuristic_wsm;
+
+static void heuristic_init_workspace_manager(void)
+{
+	btrfs_init_workspace_manager(&heuristic_wsm, &btrfs_heuristic_compress);
+}
+
+static void heuristic_cleanup_workspace_manager(void)
+{
+	btrfs_cleanup_workspace_manager(&heuristic_wsm);
+}
+
+static struct list_head *heuristic_get_workspace(void)
+{
+	return btrfs_get_workspace(&heuristic_wsm);
+}
+
+static void heuristic_put_workspace(struct list_head *ws)
+{
+	btrfs_put_workspace(&heuristic_wsm, ws);
+}
+
 static void free_heuristic_ws(struct list_head *ws)
 {
 	struct heuristic_ws *workspace;
@@ -772,24 +794,14 @@ static struct list_head *alloc_heuristic_ws(void)
 }
 
 const struct btrfs_compress_op btrfs_heuristic_compress = {
+	.init_workspace_manager = heuristic_init_workspace_manager,
+	.cleanup_workspace_manager = heuristic_cleanup_workspace_manager,
+	.get_workspace = heuristic_get_workspace,
+	.put_workspace = heuristic_put_workspace,
 	.alloc_workspace = alloc_heuristic_ws,
 	.free_workspace = free_heuristic_ws,
 };
 
-struct workspace_manager {
-	const struct btrfs_compress_op *ops;
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
-static struct workspace_manager wsm[BTRFS_COMPRESS_TYPES];
-
 static const struct btrfs_compress_op * const btrfs_compress_op[] = {
 	&btrfs_heuristic_compress,
 	&btrfs_zlib_compress,
@@ -797,33 +809,33 @@ static const struct btrfs_compress_op * const btrfs_compress_op[] = {
 	&btrfs_zstd_compress,
 };
 
-static void btrfs_init_workspace_manager(int type)
+void btrfs_init_workspace_manager(struct workspace_manager *wsm,
+				  const struct btrfs_compress_op *ops)
 {
-	struct workspace_manager *wsman = &wsm[type];
 	struct list_head *workspace;
 
-	wsman->ops = btrfs_compress_op[type];
+	wsm->ops = ops;
 
-	INIT_LIST_HEAD(&wsman->idle_ws);
-	spin_lock_init(&wsman->ws_lock);
-	atomic_set(&wsman->total_ws, 0);
-	init_waitqueue_head(&wsman->ws_wait);
+	INIT_LIST_HEAD(&wsm->idle_ws);
+	spin_lock_init(&wsm->ws_lock);
+	atomic_set(&wsm->total_ws, 0);
+	init_waitqueue_head(&wsm->ws_wait);
 
 	/*
 	 * Preallocate one workspace for each compression type so
 	 * we can guarantee forward progress in the worst case
 	 */
-	workspace = wsman->ops->alloc_workspace();
+	workspace = wsm->ops->alloc_workspace();
 	if (IS_ERR(workspace)) {
 		pr_warn("BTRFS: cannot preallocate compression workspace, will try later\n");
 	} else {
-		atomic_set(&wsman->total_ws, 1);
-		wsman->free_ws = 1;
-		list_add(workspace, &wsman->idle_ws);
+		atomic_set(&wsm->total_ws, 1);
+		wsm->free_ws = 1;
+		list_add(workspace, &wsm->idle_ws);
 	}
 }
 
-static void btrfs_cleanup_workspace_manager(struct workspace_manager *wsman)
+void btrfs_cleanup_workspace_manager(struct workspace_manager *wsman)
 {
 	struct list_head *ws;
 
@@ -841,7 +853,7 @@ static void btrfs_cleanup_workspace_manager(struct workspace_manager *wsman)
  * Preallocation makes a forward progress guarantees and we do not return
  * errors.
  */
-static struct list_head *btrfs_get_workspace(struct workspace_manager *wsman)
+struct list_head *btrfs_get_workspace(struct workspace_manager *wsm)
 {
 	struct list_head *workspace;
 	int cpus = num_online_cpus();
@@ -852,11 +864,11 @@ static struct list_head *btrfs_get_workspace(struct workspace_manager *wsman)
 	wait_queue_head_t *ws_wait;
 	int *free_ws;
 
-	idle_ws	 = &wsman->idle_ws;
-	ws_lock	 = &wsman->ws_lock;
-	total_ws = &wsman->total_ws;
-	ws_wait	 = &wsman->ws_wait;
-	free_ws	 = &wsman->free_ws;
+	idle_ws	 = &wsm->idle_ws;
+	ws_lock	 = &wsm->ws_lock;
+	total_ws = &wsm->total_ws;
+	ws_wait	 = &wsm->ws_wait;
+	free_ws	 = &wsm->free_ws;
 
 again:
 	spin_lock(ws_lock);
@@ -887,7 +899,7 @@ static struct list_head *btrfs_get_workspace(struct workspace_manager *wsman)
 	 * context of btrfs_compress_bio/btrfs_compress_pages
 	 */
 	nofs_flag = memalloc_nofs_save();
-	workspace = wsman->ops->alloc_workspace();
+	workspace = wsm->ops->alloc_workspace();
 	memalloc_nofs_restore(nofs_flag);
 
 	if (IS_ERR(workspace)) {
@@ -920,15 +932,14 @@ static struct list_head *btrfs_get_workspace(struct workspace_manager *wsman)
 
 static struct list_head *get_workspace(int type)
 {
-	return btrfs_get_workspace(&wsm[type]);
+	return btrfs_compress_op[type]->get_workspace();
 }
 
 /*
  * put a workspace struct back on the list or free it if we have enough
  * idle ones sitting around
  */
-static void btrfs_put_workspace(struct workspace_manager *wsman,
-				struct list_head *ws)
+void btrfs_put_workspace(struct workspace_manager *wsm, struct list_head *ws)
 {
 	struct list_head *idle_ws;
 	spinlock_t *ws_lock;
@@ -936,11 +947,11 @@ static void btrfs_put_workspace(struct workspace_manager *wsman,
 	wait_queue_head_t *ws_wait;
 	int *free_ws;
 
-	idle_ws	 = &wsman->idle_ws;
-	ws_lock	 = &wsman->ws_lock;
-	total_ws = &wsman->total_ws;
-	ws_wait	 = &wsman->ws_wait;
-	free_ws	 = &wsman->free_ws;
+	idle_ws	 = &wsm->idle_ws;
+	ws_lock	 = &wsm->ws_lock;
+	total_ws = &wsm->total_ws;
+	ws_wait	 = &wsm->ws_wait;
+	free_ws	 = &wsm->free_ws;
 
 	spin_lock(ws_lock);
 	if (*free_ws <= num_online_cpus()) {
@@ -951,7 +962,7 @@ static void btrfs_put_workspace(struct workspace_manager *wsman,
 	}
 	spin_unlock(ws_lock);
 
-	wsman->ops->free_workspace(ws);
+	wsm->ops->free_workspace(ws);
 	atomic_dec(total_ws);
 wake:
 	cond_wake_up(ws_wait);
@@ -959,7 +970,7 @@ static void btrfs_put_workspace(struct workspace_manager *wsman,
 
 static void put_workspace(int type, struct list_head *ws)
 {
-	return btrfs_put_workspace(&wsm[type], ws);
+	return btrfs_compress_op[type]->put_workspace(ws);
 }
 
 /*
@@ -1059,7 +1070,7 @@ void __init btrfs_init_compress(void)
 	int i;
 
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++)
-		btrfs_init_workspace_manager(i);
+		btrfs_compress_op[i]->init_workspace_manager();
 }
 
 void __cold btrfs_exit_compress(void)
@@ -1067,7 +1078,7 @@ void __cold btrfs_exit_compress(void)
 	int i;
 
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++)
-		btrfs_cleanup_workspace_manager(&wsm[i]);
+		btrfs_compress_op[i]->cleanup_workspace_manager();
 }
 
 /*
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 53a8b9e93217..05342ad081d6 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -100,7 +100,33 @@ enum btrfs_compression_type {
 	BTRFS_COMPRESS_TYPES = 4,
 };
 
+struct workspace_manager {
+	const struct btrfs_compress_op *ops;
+	struct list_head idle_ws;
+	spinlock_t ws_lock;
+	/* Number of free workspaces */
+	int free_ws;
+	/* Total number of allocated workspaces */
+	atomic_t total_ws;
+	/* Waiters for a free workspace */
+	wait_queue_head_t ws_wait;
+};
+
+void btrfs_init_workspace_manager(struct workspace_manager *wsm,
+				  const struct btrfs_compress_op *ops);
+struct list_head *btrfs_get_workspace(struct workspace_manager *wsm);
+void btrfs_put_workspace(struct workspace_manager *wsm, struct list_head *ws);
+void btrfs_cleanup_workspace_manager(struct workspace_manager *wsm);
+
 struct btrfs_compress_op {
+	void (*init_workspace_manager)(void);
+
+	void (*cleanup_workspace_manager)(void);
+
+	struct list_head *(*get_workspace)(void);
+
+	void (*put_workspace)(struct list_head *ws);
+
 	struct list_head *(*alloc_workspace)(void);
 
 	void (*free_workspace)(struct list_head *workspace);
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 90639140439f..f0837b2c8e94 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -61,6 +61,28 @@ struct workspace {
 	struct list_head list;
 };
 
+static struct workspace_manager wsm;
+
+static void lzo_init_workspace_manager(void)
+{
+	btrfs_init_workspace_manager(&wsm, &btrfs_lzo_compress);
+}
+
+static void lzo_cleanup_workspace_manager(void)
+{
+	btrfs_cleanup_workspace_manager(&wsm);
+}
+
+static struct list_head *lzo_get_workspace(void)
+{
+	return btrfs_get_workspace(&wsm);
+}
+
+static void lzo_put_workspace(struct list_head *ws)
+{
+	btrfs_put_workspace(&wsm, ws);
+}
+
 static void lzo_free_workspace(struct list_head *ws)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
@@ -490,6 +512,10 @@ static void lzo_set_level(struct list_head *ws, unsigned int type)
 }
 
 const struct btrfs_compress_op btrfs_lzo_compress = {
+	.init_workspace_manager	= lzo_init_workspace_manager,
+	.cleanup_workspace_manager = lzo_cleanup_workspace_manager,
+	.get_workspace		= lzo_get_workspace,
+	.put_workspace		= lzo_put_workspace,
 	.alloc_workspace	= lzo_alloc_workspace,
 	.free_workspace		= lzo_free_workspace,
 	.compress_pages		= lzo_compress_pages,
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 1480b3eee306..04687bf692e3 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -27,6 +27,28 @@ struct workspace {
 	int level;
 };
 
+static struct workspace_manager wsm;
+
+static void zlib_init_workspace_manager(void)
+{
+	btrfs_init_workspace_manager(&wsm, &btrfs_zlib_compress);
+}
+
+static void zlib_cleanup_workspace_manager(void)
+{
+	btrfs_cleanup_workspace_manager(&wsm);
+}
+
+static struct list_head *zlib_get_workspace(void)
+{
+	return btrfs_get_workspace(&wsm);
+}
+
+static void zlib_put_workspace(struct list_head *ws)
+{
+	btrfs_put_workspace(&wsm, ws);
+}
+
 static void zlib_free_workspace(struct list_head *ws)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
@@ -402,6 +424,10 @@ static void zlib_set_level(struct list_head *ws, unsigned int type)
 }
 
 const struct btrfs_compress_op btrfs_zlib_compress = {
+	.init_workspace_manager	= zlib_init_workspace_manager,
+	.cleanup_workspace_manager = zlib_cleanup_workspace_manager,
+	.get_workspace		= zlib_get_workspace,
+	.put_workspace		= zlib_put_workspace,
 	.alloc_workspace	= zlib_alloc_workspace,
 	.free_workspace		= zlib_free_workspace,
 	.compress_pages		= zlib_compress_pages,
diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index af6ec59972f5..b06eaf171be7 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -41,6 +41,28 @@ struct workspace {
 	ZSTD_outBuffer out_buf;
 };
 
+static struct workspace_manager wsm;
+
+static void zstd_init_workspace_manager(void)
+{
+	btrfs_init_workspace_manager(&wsm, &btrfs_zstd_compress);
+}
+
+static void zstd_cleanup_workspace_manager(void)
+{
+	btrfs_cleanup_workspace_manager(&wsm);
+}
+
+static struct list_head *zstd_get_workspace(void)
+{
+	return btrfs_get_workspace(&wsm);
+}
+
+static void zstd_put_workspace(struct list_head *ws)
+{
+	btrfs_put_workspace(&wsm, ws);
+}
+
 static void zstd_free_workspace(struct list_head *ws)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
@@ -424,6 +446,10 @@ static void zstd_set_level(struct list_head *ws, unsigned int type)
 }
 
 const struct btrfs_compress_op btrfs_zstd_compress = {
+	.init_workspace_manager = zstd_init_workspace_manager,
+	.cleanup_workspace_manager = zstd_cleanup_workspace_manager,
+	.get_workspace = zstd_get_workspace,
+	.put_workspace = zstd_put_workspace,
 	.alloc_workspace = zstd_alloc_workspace,
 	.free_workspace = zstd_free_workspace,
 	.compress_pages = zstd_compress_pages,
-- 
2.17.1

