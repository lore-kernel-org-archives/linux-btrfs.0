Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35BA4C282C8
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4CD12171F
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548710693;
	bh=+4HbNEVxD9Kj4DjoCga3A/2w9I1c+XntKDwUT/IuXM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=yfAazpuv/dpqN8muwi1anzkfZZOKfXHPJIKgBfqLkRXJflrby1Stpf3xJV0TVO5Nq
	 bWsvkWloip20gme9hn5z1RnFu7PCyWTiBMLr//1ICC+XEtfnmqZiiHZv7N/c71ln+S
	 k4JCZ6WVrkjfI6J8XWKvTgeEKBI9DoNzM55ba9hc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbfA1VYv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 16:24:51 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:44115 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728274AbfA1VYu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 16:24:50 -0500
Received: by mail-yw1-f66.google.com with SMTP id b63so7334597ywc.11;
        Mon, 28 Jan 2019 13:24:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mffI2+SI9kSKwDwOcuUxQxRb/or/4TAhqInDe+WLfoQ=;
        b=KG3biWfV3l6CMi2Dr5rDBs9f065iu5BDP9c5SPotVH44LBsY4w0Ufq7clSMKZgHFsk
         ucXgMWrkluKDsyyDL9bOITZMZckRJUAoEFZIyTZ7cAesGP8sinJoAOUykgfy3wjJNdLi
         YeZ7XXzuaJFQzpYd89qtLjgd2jPm9E6qioYxsyy4I0FXnUZq+1IbOnf1IRLho1GTTMFD
         54OWs4PWBOj5Lo1swKTRukJViXnMUhUGjjYbzOTyYROfpfo5er1G63RcW1h+08i7WM/7
         Am+bhRGzJkQjWm+6wbYfEKJLW2V77zw2h9z8YPUeMKaJJKMSM8MOMPPx5rqpAUZbeys2
         i5sA==
X-Gm-Message-State: AJcUukciiiX7cYWnaupN5pIoouGr+2zxBZ38cLmG8zoDyT9bWX3IeetG
        NTD/AqkzqYtZd4ApHZfrMWJJDY41BtI=
X-Google-Smtp-Source: ALg8bN6gVOdA/3XbYurcL0Ff54OZDwOi+x5cP6ahzHIe5UNI32JMkp+Ie3vj96kDSSfj/Mu08Q46sw==
X-Received: by 2002:a0d:c182:: with SMTP id c124mr22508227ywd.190.1548710688956;
        Mon, 28 Jan 2019 13:24:48 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id a7sm24170415ywb.18.2019.01.28.13.24.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 28 Jan 2019 13:24:48 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 03/11] btrfs: manage heuristic workspace as index 0
Date:   Mon, 28 Jan 2019 16:24:29 -0500
Message-Id: <20190128212437.11597-4-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190128212437.11597-1-dennis@kernel.org>
References: <20190128212437.11597-1-dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

While the heuristic workspaces aren't really compression workspaces,
they use the same interface for managing them. So rather than branching,
let's just handle them once again as the index 0 compression type.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 fs/btrfs/compression.c  | 107 +++++++++++-----------------------------
 fs/btrfs/compression.h  |   3 +-
 fs/btrfs/ioctl.c        |   2 +-
 fs/btrfs/tree-checker.c |   4 +-
 4 files changed, 33 insertions(+), 83 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index aced261984e2..bda7e8d2cbc7 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -37,6 +37,8 @@ const char* btrfs_compress_type2str(enum btrfs_compression_type type)
 	case BTRFS_COMPRESS_ZSTD:
 	case BTRFS_COMPRESS_NONE:
 		return btrfs_compress_types[type];
+	default:
+		return NULL;
 	}
 
 	return NULL;
@@ -769,6 +771,11 @@ static struct list_head *alloc_heuristic_ws(void)
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
@@ -782,9 +789,8 @@ struct workspace_manager {
 
 static struct workspace_manager wsm[BTRFS_COMPRESS_TYPES];
 
-static struct workspace_manager btrfs_heuristic_ws;
-
 static const struct btrfs_compress_op * const btrfs_compress_op[] = {
+	&btrfs_heuristic_compress,
 	&btrfs_zlib_compress,
 	&btrfs_lzo_compress,
 	&btrfs_zstd_compress,
@@ -795,21 +801,6 @@ void __init btrfs_init_compress(void)
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
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
 		INIT_LIST_HEAD(&wsm[i].idle_ws);
 		spin_lock_init(&wsm[i].ws_lock);
@@ -837,11 +828,10 @@ void __init btrfs_init_compress(void)
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
@@ -849,19 +839,11 @@ static struct list_head *__find_workspace(int type, bool heuristic)
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
@@ -892,10 +874,7 @@ static struct list_head *__find_workspace(int type, bool heuristic)
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
@@ -926,38 +905,23 @@ static struct list_head *__find_workspace(int type, bool heuristic)
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
@@ -968,20 +932,12 @@ static void __free_workspace(int type, struct list_head *workspace,
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
@@ -990,13 +946,6 @@ static void free_workspaces(void)
 	struct list_head *workspace;
 	int i;
 
-	while (!list_empty(&btrfs_heuristic_ws.idle_ws)) {
-		workspace = btrfs_heuristic_ws.idle_ws.next;
-		list_del(workspace);
-		free_heuristic_ws(workspace);
-		atomic_dec(&btrfs_heuristic_ws.total_ws);
-	}
-
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
 		while (!list_empty(&wsm[i].idle_ws)) {
 			workspace = wsm[i].idle_ws.next;
@@ -1042,8 +991,8 @@ int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
 
 	workspace = find_workspace(type);
 
-	btrfs_compress_op[type - 1]->set_level(workspace, type_level);
-	ret = btrfs_compress_op[type-1]->compress_pages(workspace, mapping,
+	btrfs_compress_op[type]->set_level(workspace, type_level);
+	ret = btrfs_compress_op[type]->compress_pages(workspace, mapping,
 						      start, pages,
 						      out_pages,
 						      total_in, total_out);
@@ -1072,7 +1021,7 @@ static int btrfs_decompress_bio(struct compressed_bio *cb)
 	int type = cb->compress_type;
 
 	workspace = find_workspace(type);
-	ret = btrfs_compress_op[type - 1]->decompress_bio(workspace, cb);
+	ret = btrfs_compress_op[type]->decompress_bio(workspace, cb);
 	free_workspace(type, workspace);
 
 	return ret;
@@ -1091,7 +1040,7 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 
 	workspace = find_workspace(type);
 
-	ret = btrfs_compress_op[type-1]->decompress(workspace, data_in,
+	ret = btrfs_compress_op[type]->decompress(workspace, data_in,
 						  dest_page, start_byte,
 						  srclen, destlen);
 
@@ -1512,7 +1461,7 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
  */
 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 {
-	struct list_head *ws_list = __find_workspace(0, true);
+	struct list_head *ws_list = find_workspace(0);
 	struct heuristic_ws *ws;
 	u32 i;
 	u8 byte;
@@ -1581,7 +1530,7 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 	}
 
 out:
-	__free_workspace(0, ws_list, true);
+	free_workspace(0, ws_list);
 	return ret;
 }
 
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 69a9197dadc3..53a8b9e93217 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -97,7 +97,7 @@ enum btrfs_compression_type {
 	BTRFS_COMPRESS_ZLIB  = 1,
 	BTRFS_COMPRESS_LZO   = 2,
 	BTRFS_COMPRESS_ZSTD  = 3,
-	BTRFS_COMPRESS_TYPES = 3,
+	BTRFS_COMPRESS_TYPES = 4,
 };
 
 struct btrfs_compress_op {
@@ -125,6 +125,7 @@ struct btrfs_compress_op {
 	void (*set_level)(struct list_head *ws, unsigned int type);
 };
 
+extern const struct btrfs_compress_op btrfs_heuristic_compress;
 extern const struct btrfs_compress_op btrfs_zlib_compress;
 extern const struct btrfs_compress_op btrfs_lzo_compress;
 extern const struct btrfs_compress_op btrfs_zstd_compress;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9c8e1734429c..20081465a451 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1410,7 +1410,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		return -EINVAL;
 
 	if (do_compress) {
-		if (range->compress_type > BTRFS_COMPRESS_TYPES)
+		if (range->compress_type >= BTRFS_COMPRESS_TYPES)
 			return -EINVAL;
 		if (range->compress_type)
 			compress_type = range->compress_type;
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index a62e1e837a89..c88e146d8e99 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -133,9 +133,9 @@ static int check_extent_data_item(struct btrfs_fs_info *fs_info,
 	 * Support for new compression/encryption must introduce incompat flag,
 	 * and must be caught in open_ctree().
 	 */
-	if (btrfs_file_extent_compression(leaf, fi) > BTRFS_COMPRESS_TYPES) {
+	if (btrfs_file_extent_compression(leaf, fi) >= BTRFS_COMPRESS_TYPES) {
 		file_extent_err(fs_info, leaf, slot,
-	"invalid compression for file extent, have %u expect range [0, %u]",
+	"invalid compression for file extent, have %u expect range [0, %u)",
 			btrfs_file_extent_compression(leaf, fi),
 			BTRFS_COMPRESS_TYPES);
 		return -EUCLEAN;
-- 
2.17.1

