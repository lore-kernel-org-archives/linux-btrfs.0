Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95797C282C4
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:21:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 547E02087C
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549311718;
	bh=gKBTzq6gpsKjeGjw3D+lPykiOpxRAYXT2vFMsEQ161g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=A1jUWtZEQsfUcEhdRfN/xapjyymwvUYf/8cLuPnLIUzYdIgkHMHB5tKKdhdR1E/6o
	 22bIEDe3siQEEJTIBGPxhCB2qxygcBvZLy/XC5jNK3ywrhU3FSjAHQRH4Nj2FZQ1cj
	 WYlaCy7qMEB/uJJ+sVWNmRAEMCZU3N+6r3dGzAPg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbfBDUUh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 15:20:37 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:33540 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbfBDUUg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2019 15:20:36 -0500
Received: by mail-yw1-f65.google.com with SMTP id p17so860350ywg.0;
        Mon, 04 Feb 2019 12:20:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BILipWbxA9h5hhhAY63H5kfrwiYVl0dPJDgmefDrDrE=;
        b=WtBrcecnMG2Ab0435wADJd8cgRP0ZAwparRzCZrr0uiDd25C3mvQcdjsaOUqEDn6fe
         EVkTXC4kBiwYxOk/CAdhz6L+njnSEJiS5t+kdmDNtc8sjnYn6l5EdyZ9Fi+1NUGZnDwl
         5wS7Pgh+4X/jUKHcqKpUNHgKFf+hLNeuYKABv/V8ODbJ/4UbHckoFh5qBBiH2gfjRwD3
         F6NXuNV/gWMwkTwnwVtMYFfYVNubXS83qrhWEyF0WOvttXpED1VvncNKaYRgVQh+YmKm
         tAugtN/rtJyfsGMdWidHHc1j/gGG2iQvxJxIAGfy7DSLuhnSWc8auUN3mjURwj9oCCIk
         HMEA==
X-Gm-Message-State: AHQUAuaepOa7aW6FfXBnNhOmeP2XGjFzR8NX8BSDdwlIjUGrUB5T7ayi
        R0ZW77t5eeqzbwbmkiM26gk=
X-Google-Smtp-Source: AHgI3IbP/JzOwvCBH+PFAR7UN3JM6nUijwghiv2/qF6qmUQh8Rx5Yvy3Kp2/J4bHbihHZjsOGs/Rgg==
X-Received: by 2002:a81:a988:: with SMTP id g130mr1040192ywh.307.1549311636019;
        Mon, 04 Feb 2019 12:20:36 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id c68sm708456ywd.52.2019.02.04.12.20.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Feb 2019 12:20:35 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 03/12] btrfs: manage heuristic workspace as index 0
Date:   Mon,  4 Feb 2019 15:19:59 -0500
Message-Id: <20190204202008.51652-4-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190204202008.51652-1-dennis@kernel.org>
References: <20190204202008.51652-1-dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

While the heuristic workspaces aren't really compression workspaces,
they use the same interface for managing them. So rather than branching,
let's just handle them once again as the index 0 compression type.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
v2:
- added BTRFS_NR_WORKSPACE_MANAGERS instead of overriding
  BTRFS_COMPRESS_TYPES

 fs/btrfs/compression.c | 111 +++++++++++------------------------------
 fs/btrfs/compression.h |   4 ++
 2 files changed, 33 insertions(+), 82 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index d098df768b67..5b508cb3b236 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -769,6 +769,11 @@ static struct list_head *alloc_heuristic_ws(void)
 	return ERR_PTR(-ENOMEM);
 }
 
+const struct btrfs_compress_op btrfs_heuristic_compress = {
+	.alloc_workspace = alloc_heuristic_ws,
+	.free_workspace = free_heuristic_ws,
+};
+
 struct workspace_manager {
 	struct list_head idle_ws;
 	spinlock_t ws_lock;
@@ -780,11 +785,10 @@ struct workspace_manager {
 	wait_queue_head_t ws_wait;
 };
 
-static struct workspace_manager wsm[BTRFS_COMPRESS_TYPES];
-
-static struct workspace_manager btrfs_heuristic_ws;
+static struct workspace_manager wsm[BTRFS_NR_WORKSPACE_MANAGERS];
 
 static const struct btrfs_compress_op * const btrfs_compress_op[] = {
+	&btrfs_heuristic_compress,
 	&btrfs_zlib_compress,
 	&btrfs_lzo_compress,
 	&btrfs_zstd_compress,
@@ -795,22 +799,7 @@ void __init btrfs_init_compress(void)
 	struct list_head *workspace;
 	int i;
 
-	INIT_LIST_HEAD(&btrfs_heuristic_ws.idle_ws);
-	spin_lock_init(&btrfs_heuristic_ws.ws_lock);
-	atomic_set(&btrfs_heuristic_ws.total_ws, 0);
-	init_waitqueue_head(&btrfs_heuristic_ws.ws_wait);
-
-	workspace = alloc_heuristic_ws();
-	if (IS_ERR(workspace)) {
-		pr_warn(
-	"BTRFS: cannot preallocate heuristic workspace, will try later\n");
-	} else {
-		atomic_set(&btrfs_heuristic_ws.total_ws, 1);
-		btrfs_heuristic_ws.free_ws = 1;
-		list_add(workspace, &btrfs_heuristic_ws.idle_ws);
-	}
-
-	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
+	for (i = 0; i < BTRFS_NR_WORKSPACE_MANAGERS; i++) {
 		INIT_LIST_HEAD(&wsm[i].idle_ws);
 		spin_lock_init(&wsm[i].ws_lock);
 		atomic_set(&wsm[i].total_ws, 0);
@@ -837,11 +826,10 @@ void __init btrfs_init_compress(void)
  * Preallocation makes a forward progress guarantees and we do not return
  * errors.
  */
-static struct list_head *__find_workspace(int type, bool heuristic)
+static struct list_head *find_workspace(int type)
 {
 	struct list_head *workspace;
 	int cpus = num_online_cpus();
-	int idx = type - 1;
 	unsigned nofs_flag;
 	struct list_head *idle_ws;
 	spinlock_t *ws_lock;
@@ -849,19 +837,11 @@ static struct list_head *__find_workspace(int type, bool heuristic)
 	wait_queue_head_t *ws_wait;
 	int *free_ws;
 
-	if (heuristic) {
-		idle_ws	 = &btrfs_heuristic_ws.idle_ws;
-		ws_lock	 = &btrfs_heuristic_ws.ws_lock;
-		total_ws = &btrfs_heuristic_ws.total_ws;
-		ws_wait	 = &btrfs_heuristic_ws.ws_wait;
-		free_ws	 = &btrfs_heuristic_ws.free_ws;
-	} else {
-		idle_ws	 = &wsm[idx].idle_ws;
-		ws_lock	 = &wsm[idx].ws_lock;
-		total_ws = &wsm[idx].total_ws;
-		ws_wait	 = &wsm[idx].ws_wait;
-		free_ws	 = &wsm[idx].free_ws;
-	}
+	idle_ws	 = &wsm[type].idle_ws;
+	ws_lock	 = &wsm[type].ws_lock;
+	total_ws = &wsm[type].total_ws;
+	ws_wait	 = &wsm[type].ws_wait;
+	free_ws	 = &wsm[type].free_ws;
 
 again:
 	spin_lock(ws_lock);
@@ -892,10 +872,7 @@ static struct list_head *__find_workspace(int type, bool heuristic)
 	 * context of btrfs_compress_bio/btrfs_compress_pages
 	 */
 	nofs_flag = memalloc_nofs_save();
-	if (heuristic)
-		workspace = alloc_heuristic_ws();
-	else
-		workspace = btrfs_compress_op[idx]->alloc_workspace();
+	workspace = btrfs_compress_op[type]->alloc_workspace();
 	memalloc_nofs_restore(nofs_flag);
 
 	if (IS_ERR(workspace)) {
@@ -926,38 +903,23 @@ static struct list_head *__find_workspace(int type, bool heuristic)
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
-	int idx = type - 1;
 	struct list_head *idle_ws;
 	spinlock_t *ws_lock;
 	atomic_t *total_ws;
 	wait_queue_head_t *ws_wait;
 	int *free_ws;
 
-	if (heuristic) {
-		idle_ws	 = &btrfs_heuristic_ws.idle_ws;
-		ws_lock	 = &btrfs_heuristic_ws.ws_lock;
-		total_ws = &btrfs_heuristic_ws.total_ws;
-		ws_wait	 = &btrfs_heuristic_ws.ws_wait;
-		free_ws	 = &btrfs_heuristic_ws.free_ws;
-	} else {
-		idle_ws	 = &wsm[idx].idle_ws;
-		ws_lock	 = &wsm[idx].ws_lock;
-		total_ws = &wsm[idx].total_ws;
-		ws_wait	 = &wsm[idx].ws_wait;
-		free_ws	 = &wsm[idx].free_ws;
-	}
+	idle_ws	 = &wsm[type].idle_ws;
+	ws_lock	 = &wsm[type].ws_lock;
+	total_ws = &wsm[type].total_ws;
+	ws_wait	 = &wsm[type].ws_wait;
+	free_ws	 = &wsm[type].free_ws;
 
 	spin_lock(ws_lock);
 	if (*free_ws <= num_online_cpus()) {
@@ -968,20 +930,12 @@ static void __free_workspace(int type, struct list_head *workspace,
 	}
 	spin_unlock(ws_lock);
 
-	if (heuristic)
-		free_heuristic_ws(workspace);
-	else
-		btrfs_compress_op[idx]->free_workspace(workspace);
+	btrfs_compress_op[type]->free_workspace(workspace);
 	atomic_dec(total_ws);
 wake:
 	cond_wake_up(ws_wait);
 }
 
-static void free_workspace(int type, struct list_head *ws)
-{
-	return __free_workspace(type, ws, false);
-}
-
 /*
  * cleanup function for module exit
  */
@@ -990,14 +944,7 @@ static void free_workspaces(void)
 	struct list_head *workspace;
 	int i;
 
-	while (!list_empty(&btrfs_heuristic_ws.idle_ws)) {
-		workspace = btrfs_heuristic_ws.idle_ws.next;
-		list_del(workspace);
-		free_heuristic_ws(workspace);
-		atomic_dec(&btrfs_heuristic_ws.total_ws);
-	}
-
-	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
+	for (i = 0; i < BTRFS_NR_WORKSPACE_MANAGERS; i++) {
 		while (!list_empty(&wsm[i].idle_ws)) {
 			workspace = wsm[i].idle_ws.next;
 			list_del(workspace);
@@ -1042,8 +989,8 @@ int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
 
 	workspace = find_workspace(type);
 
-	btrfs_compress_op[type - 1]->set_level(workspace, type_level);
-	ret = btrfs_compress_op[type-1]->compress_pages(workspace, mapping,
+	btrfs_compress_op[type]->set_level(workspace, type_level);
+	ret = btrfs_compress_op[type]->compress_pages(workspace, mapping,
 						      start, pages,
 						      out_pages,
 						      total_in, total_out);
@@ -1072,7 +1019,7 @@ static int btrfs_decompress_bio(struct compressed_bio *cb)
 	int type = cb->compress_type;
 
 	workspace = find_workspace(type);
-	ret = btrfs_compress_op[type - 1]->decompress_bio(workspace, cb);
+	ret = btrfs_compress_op[type]->decompress_bio(workspace, cb);
 	free_workspace(type, workspace);
 
 	return ret;
@@ -1091,7 +1038,7 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 
 	workspace = find_workspace(type);
 
-	ret = btrfs_compress_op[type-1]->decompress(workspace, data_in,
+	ret = btrfs_compress_op[type]->decompress(workspace, data_in,
 						  dest_page, start_byte,
 						  srclen, destlen);
 
@@ -1512,7 +1459,7 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
  */
 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 {
-	struct list_head *ws_list = __find_workspace(0, true);
+	struct list_head *ws_list = find_workspace(0);
 	struct heuristic_ws *ws;
 	u32 i;
 	u8 byte;
@@ -1581,7 +1528,7 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 	}
 
 out:
-	__free_workspace(0, ws_list, true);
+	free_workspace(0, ws_list);
 	return ret;
 }
 
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 004db0b3111b..7ef62caa60ab 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -132,6 +132,10 @@ struct btrfs_compress_op {
 	void (*set_level)(struct list_head *ws, unsigned int type);
 };
 
+/* the heuristic workspaces are managed via the 0th workspace manager */
+#define BTRFS_NR_WORKSPACE_MANAGERS	(BTRFS_COMPRESS_TYPES + 1)
+
+extern const struct btrfs_compress_op btrfs_heuristic_compress;
 extern const struct btrfs_compress_op btrfs_zlib_compress;
 extern const struct btrfs_compress_op btrfs_lzo_compress;
 extern const struct btrfs_compress_op btrfs_zstd_compress;
-- 
2.17.1

