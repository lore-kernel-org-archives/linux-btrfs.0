Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD4BC282C4
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 424E82176F
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549311698;
	bh=0brfs/jhhvF0359dVfUJJcZrHyf4BOW2afjhfzgGrdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=g2EKNlMV+oVBDeDHMBCho+nmKk4Sd1Xpn0YD3BHTpGEPjIREZQumdMh5PW5rfLRAw
	 fXWpvN99rvK/rhhNrekeRmIGLdRQmMKddQMhWtv4V1CBLoq/xjHiCQZAX15ToZrqI3
	 QuNtzPBweh8AFrBynL21RoxVArQgALBkl4CxJkXc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbfBDUVc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 15:21:32 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:42229 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728731AbfBDUUr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2019 15:20:47 -0500
Received: by mail-yb1-f195.google.com with SMTP id l20so129538ybl.9;
        Mon, 04 Feb 2019 12:20:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jQ0ggbXanC5bwEU20jJTtkgvwhodjRHo3Is5X9Gvpwg=;
        b=OQXGgRVpyS6WPJ6zHJKTGjTQKGsqYaBqIQ7G+HcDChX7t1Vos1LlpoDHWkOkACxGCn
         iutC5vdaVpINNRSzS21P44jXqeKqgwmBU7MexErJy9ZjEOZ4R5RkiJ1Q0ecxVCqZSxH1
         CAnoBKDCfB5M/TjS0xDcw5Yxm5JKep3Usg7/DwbauGRUu+W3e42Yb++N6GDv9uUcuTQ+
         jU2gtpNL/mixtqzNNXnzyammkskNFoqVnD+IsJ6DIDkcLJShlVglp5RkgGqR5Dj/MG+D
         cepJxFd3zBw6U/ZqB5vbfPErYo5N89TIlhw1aCqAdlgPWvCe+P7GMkLQOXT+LmT72fVl
         QXEQ==
X-Gm-Message-State: AHQUAuZLb++j3gvoDejbNUF5FUipy1+yub6a4DNAZcWTbEDwpJIY1yga
        RWYzAJ+i3jqVm5doys/AMSmk/43jXcY=
X-Google-Smtp-Source: AHgI3IagbBXbic77ujP42XPvA4uUtwXwLpiPIUYVapU2p6kEbG0VzlDp8WAgXMe9ZM7DdTlfyevY4g==
X-Received: by 2002:a25:6b04:: with SMTP id g4mr1034350ybc.485.1549311645925;
        Mon, 04 Feb 2019 12:20:45 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id c68sm708456ywd.52.2019.02.04.12.20.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Feb 2019 12:20:45 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 07/12] btrfs: move to fn pointers for get/put workspaces
Date:   Mon,  4 Feb 2019 15:20:03 -0500
Message-Id: <20190204202008.51652-8-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190204202008.51652-1-dennis@kernel.org>
References: <20190204202008.51652-1-dennis@kernel.org>
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
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/compression.c | 101 +++++++++++++++++++++++------------------
 fs/btrfs/compression.h |  26 +++++++++++
 fs/btrfs/lzo.c         |  26 +++++++++++
 fs/btrfs/zlib.c        |  26 +++++++++++
 fs/btrfs/zstd.c        |  26 +++++++++++
 5 files changed, 160 insertions(+), 45 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 98e1b222f78c..3d42ab71455d 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -730,6 +730,28 @@ struct heuristic_ws {
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
@@ -770,24 +792,14 @@ static struct list_head *alloc_heuristic_ws(void)
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
-static struct workspace_manager wsm[BTRFS_NR_WORKSPACE_MANAGERS];
-
 static const struct btrfs_compress_op * const btrfs_compress_op[] = {
 	&btrfs_heuristic_compress,
 	&btrfs_zlib_compress,
@@ -795,33 +807,33 @@ static const struct btrfs_compress_op * const btrfs_compress_op[] = {
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
 
@@ -839,7 +851,7 @@ static void btrfs_cleanup_workspace_manager(struct workspace_manager *wsman)
  * Preallocation makes a forward progress guarantees and we do not return
  * errors.
  */
-static struct list_head *btrfs_get_workspace(struct workspace_manager *wsman)
+struct list_head *btrfs_get_workspace(struct workspace_manager *wsm)
 {
 	struct list_head *workspace;
 	int cpus = num_online_cpus();
@@ -850,11 +862,11 @@ static struct list_head *btrfs_get_workspace(struct workspace_manager *wsman)
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
@@ -885,7 +897,7 @@ static struct list_head *btrfs_get_workspace(struct workspace_manager *wsman)
 	 * context of btrfs_compress_bio/btrfs_compress_pages
 	 */
 	nofs_flag = memalloc_nofs_save();
-	workspace = wsman->ops->alloc_workspace();
+	workspace = wsm->ops->alloc_workspace();
 	memalloc_nofs_restore(nofs_flag);
 
 	if (IS_ERR(workspace)) {
@@ -918,15 +930,14 @@ static struct list_head *btrfs_get_workspace(struct workspace_manager *wsman)
 
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
@@ -934,11 +945,11 @@ static void btrfs_put_workspace(struct workspace_manager *wsman,
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
@@ -949,7 +960,7 @@ static void btrfs_put_workspace(struct workspace_manager *wsman,
 	}
 	spin_unlock(ws_lock);
 
-	wsman->ops->free_workspace(ws);
+	wsm->ops->free_workspace(ws);
 	atomic_dec(total_ws);
 wake:
 	cond_wake_up(ws_wait);
@@ -957,7 +968,7 @@ static void btrfs_put_workspace(struct workspace_manager *wsman,
 
 static void put_workspace(int type, struct list_head *ws)
 {
-	return btrfs_put_workspace(&wsm[type], ws);
+	return btrfs_compress_op[type]->put_workspace(ws);
 }
 
 /*
@@ -1057,7 +1068,7 @@ void __init btrfs_init_compress(void)
 	int i;
 
 	for (i = 0; i < BTRFS_NR_WORKSPACE_MANAGERS; i++)
-		btrfs_init_workspace_manager(i);
+		btrfs_compress_op[i]->init_workspace_manager();
 }
 
 void __cold btrfs_exit_compress(void)
@@ -1065,7 +1076,7 @@ void __cold btrfs_exit_compress(void)
 	int i;
 
 	for (i = 0; i < BTRFS_NR_WORKSPACE_MANAGERS; i++)
-		btrfs_cleanup_workspace_manager(&wsm[i]);
+		btrfs_compress_op[i]->cleanup_workspace_manager();
 }
 
 /*
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 7ef62caa60ab..8422e6ce4838 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -107,7 +107,33 @@ enum btrfs_compression_type {
 	BTRFS_COMPRESS_TYPES = 3,
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
index 2bd655c4f8b4..773d1d70ceec 100644
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

