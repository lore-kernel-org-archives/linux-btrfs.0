Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D53F0C282C8
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:25:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 984B22184D
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548710727;
	bh=M+f7O9W/x2jW4vOTs57FuOlSEIIKuk/xzkTB/DmaKqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LnflbBK1s7uax1cxRI8Jaohn9rcWDOpdovUAcLJLmo6qoZ6QcmaAWiu36GU+OQ+F5
	 d01C8m2crNUJpi+pbBlCne1ZmLDipMqLllWbiEJY1NHszb3ier7qPZE66JcUFocHxV
	 ovww0KenhIjTCqeOsZ7v7QTLMt+eEERcoawIlcvA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbfA1VZX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 16:25:23 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:37090 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728316AbfA1VY4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 16:24:56 -0500
Received: by mail-yw1-f67.google.com with SMTP id h193so7358275ywc.4;
        Mon, 28 Jan 2019 13:24:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OpMPEOdbVcWt4t/2TFv/NEECu9N5O2HbNXitx/LNP7k=;
        b=YDiERm27/Vo14tpG3VYqNdE0FXV3tw0SEehD2b0hzu6ExoNgbgXFcUx8v+3KSaVPJC
         eUb79wZ7TKOBrHbNj2ZQnjbZD2VojuKIUBLfwjI3ZVRwetRz5hq5mLoxjV8q6/qC+LA9
         L2PjFM1p86zz/SYS8PvYzDiMTFuHfNUgu7DNRfXgWHAi3GngZd7thhiGk32+8trRZ2YS
         f/ZruV4pyYVA7/IafCs2uvSPz4gwuIuuPX2owLx/AGKtaa3B3GD5eJQzQ/Ueute5gB1R
         DwuZUoHyJ63AG+M8HEYwtLW9Q98OMqgSjfl0vev0Bt3PBETW7ttf3nthuHRd48b0cIND
         j4IQ==
X-Gm-Message-State: AJcUukfm56ZhBFqLriSOasCCNbmRuoMivuDj2ZSYkrrN7UUcX5Xz8UZv
        qNAqSW5wI4f5e4S15HQ+GHU=
X-Google-Smtp-Source: ALg8bN4TlsfktrxYLCaEyhNx98IE9Q0yEcHlTEAGh9XyZj0y1KqBrakMwg1rKEmOTKXc3ZUIW/WZeQ==
X-Received: by 2002:a81:378b:: with SMTP id e133mr22220086ywa.79.1548710695992;
        Mon, 28 Jan 2019 13:24:55 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id a7sm24170415ywb.18.2019.01.28.13.24.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 28 Jan 2019 13:24:55 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 08/11] btrfs: plumb level through the compression interface
Date:   Mon, 28 Jan 2019 16:24:34 -0500
Message-Id: <20190128212437.11597-9-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190128212437.11597-1-dennis@kernel.org>
References: <20190128212437.11597-1-dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Zlib compression supports multiple levels, but doesn't require changing
in how a workspace itself is created and managed. Zstd introduces a
different memory requirement such that higher levels of compression
require more memory. This requires changes in how the alloc()/get()
methods work for zstd. This pach plumbs compression level through the
interface as a parameter in preparation for zstd compression levels.
This gives the compression types opportunity to create/manage based on
the compression level.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 fs/btrfs/compression.c | 31 ++++++++++++++++---------------
 fs/btrfs/compression.h |  7 ++++---
 fs/btrfs/lzo.c         |  6 +++---
 fs/btrfs/zlib.c        |  7 ++++---
 fs/btrfs/zstd.c        |  6 +++---
 5 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ab694760ffdb..e509071eaa69 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -744,9 +744,9 @@ static void heuristic_cleanup_workspace_manager(void)
 	btrfs_cleanup_workspace_manager(&heuristic_wsm);
 }
 
-static struct list_head *heuristic_get_workspace(void)
+static struct list_head *heuristic_get_workspace(unsigned int level)
 {
-	return btrfs_get_workspace(&heuristic_wsm);
+	return btrfs_get_workspace(&heuristic_wsm, level);
 }
 
 static void heuristic_put_workspace(struct list_head *ws)
@@ -766,7 +766,7 @@ static void free_heuristic_ws(struct list_head *ws)
 	kfree(workspace);
 }
 
-static struct list_head *alloc_heuristic_ws(void)
+static struct list_head *alloc_heuristic_ws(unsigned int level)
 {
 	struct heuristic_ws *ws;
 
@@ -825,7 +825,7 @@ void btrfs_init_workspace_manager(struct workspace_manager *wsm,
 	 * Preallocate one workspace for each compression type so
 	 * we can guarantee forward progress in the worst case
 	 */
-	workspace = wsm->ops->alloc_workspace();
+	workspace = wsm->ops->alloc_workspace(0);
 	if (IS_ERR(workspace)) {
 		pr_warn("BTRFS: cannot preallocate compression workspace, will try later\n");
 	} else {
@@ -853,7 +853,8 @@ void btrfs_cleanup_workspace_manager(struct workspace_manager *wsman)
  * Preallocation makes a forward progress guarantees and we do not return
  * errors.
  */
-struct list_head *btrfs_get_workspace(struct workspace_manager *wsm)
+struct list_head *btrfs_get_workspace(struct workspace_manager *wsm,
+				      unsigned int level)
 {
 	struct list_head *workspace;
 	int cpus = num_online_cpus();
@@ -899,7 +900,7 @@ struct list_head *btrfs_get_workspace(struct workspace_manager *wsm)
 	 * context of btrfs_compress_bio/btrfs_compress_pages
 	 */
 	nofs_flag = memalloc_nofs_save();
-	workspace = wsm->ops->alloc_workspace();
+	workspace = wsm->ops->alloc_workspace(level);
 	memalloc_nofs_restore(nofs_flag);
 
 	if (IS_ERR(workspace)) {
@@ -930,9 +931,9 @@ struct list_head *btrfs_get_workspace(struct workspace_manager *wsm)
 	return workspace;
 }
 
-static struct list_head *get_workspace(int type)
+static struct list_head *get_workspace(int type, int level)
 {
-	return btrfs_compress_op[type]->get_workspace();
+	return btrfs_compress_op[type]->get_workspace(level);
 }
 
 /*
@@ -1003,12 +1004,13 @@ int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
 			 unsigned long *total_out)
 {
 	int type = BTRFS_COMPRESS_TYPE(type_level);
+	int level = BTRFS_COMPRESS_LEVEL(type_level);
 	struct list_head *workspace;
 	int ret;
 
-	workspace = get_workspace(type);
+	workspace = get_workspace(type, level);
 
-	btrfs_compress_op[type]->set_level(workspace, type_level);
+	btrfs_compress_op[type]->set_level(workspace, level);
 	ret = btrfs_compress_op[type]->compress_pages(workspace, mapping,
 						      start, pages,
 						      out_pages,
@@ -1037,7 +1039,7 @@ static int btrfs_decompress_bio(struct compressed_bio *cb)
 	int ret;
 	int type = cb->compress_type;
 
-	workspace = get_workspace(type);
+	workspace = get_workspace(type, 0);
 	ret = btrfs_compress_op[type]->decompress_bio(workspace, cb);
 	put_workspace(type, workspace);
 
@@ -1055,13 +1057,12 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 	struct list_head *workspace;
 	int ret;
 
-	workspace = get_workspace(type);
-
+	workspace = get_workspace(type, 0);
 	ret = btrfs_compress_op[type]->decompress(workspace, data_in,
 						  dest_page, start_byte,
 						  srclen, destlen);
-
 	put_workspace(type, workspace);
+
 	return ret;
 }
 
@@ -1489,7 +1490,7 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
  */
 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 {
-	struct list_head *ws_list = get_workspace(0);
+	struct list_head *ws_list = get_workspace(0, 0);
 	struct heuristic_ws *ws;
 	u32 i;
 	u8 byte;
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 05342ad081d6..e3627139bc5c 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -114,7 +114,8 @@ struct workspace_manager {
 
 void btrfs_init_workspace_manager(struct workspace_manager *wsm,
 				  const struct btrfs_compress_op *ops);
-struct list_head *btrfs_get_workspace(struct workspace_manager *wsm);
+struct list_head *btrfs_get_workspace(struct workspace_manager *wsm,
+				      unsigned int level);
 void btrfs_put_workspace(struct workspace_manager *wsm, struct list_head *ws);
 void btrfs_cleanup_workspace_manager(struct workspace_manager *wsm);
 
@@ -123,11 +124,11 @@ struct btrfs_compress_op {
 
 	void (*cleanup_workspace_manager)(void);
 
-	struct list_head *(*get_workspace)(void);
+	struct list_head *(*get_workspace)(unsigned int level);
 
 	void (*put_workspace)(struct list_head *ws);
 
-	struct list_head *(*alloc_workspace)(void);
+	struct list_head *(*alloc_workspace)(unsigned int level);
 
 	void (*free_workspace)(struct list_head *workspace);
 
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index f0837b2c8e94..f132af45a924 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -73,9 +73,9 @@ static void lzo_cleanup_workspace_manager(void)
 	btrfs_cleanup_workspace_manager(&wsm);
 }
 
-static struct list_head *lzo_get_workspace(void)
+static struct list_head *lzo_get_workspace(unsigned int level)
 {
-	return btrfs_get_workspace(&wsm);
+	return btrfs_get_workspace(&wsm, level);
 }
 
 static void lzo_put_workspace(struct list_head *ws)
@@ -93,7 +93,7 @@ static void lzo_free_workspace(struct list_head *ws)
 	kfree(workspace);
 }
 
-static struct list_head *lzo_alloc_workspace(void)
+static struct list_head *lzo_alloc_workspace(unsigned int level)
 {
 	struct workspace *workspace;
 
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 04687bf692e3..e2173d0c4fd3 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -39,9 +39,9 @@ static void zlib_cleanup_workspace_manager(void)
 	btrfs_cleanup_workspace_manager(&wsm);
 }
 
-static struct list_head *zlib_get_workspace(void)
+static struct list_head *zlib_get_workspace(unsigned int level)
 {
-	return btrfs_get_workspace(&wsm);
+	return btrfs_get_workspace(&wsm, level);
 }
 
 static void zlib_put_workspace(struct list_head *ws)
@@ -58,7 +58,7 @@ static void zlib_free_workspace(struct list_head *ws)
 	kfree(workspace);
 }
 
-static struct list_head *zlib_alloc_workspace(void)
+static struct list_head *zlib_alloc_workspace(unsigned int level)
 {
 	struct workspace *workspace;
 	int workspacesize;
@@ -71,6 +71,7 @@ static struct list_head *zlib_alloc_workspace(void)
 			zlib_inflate_workspacesize());
 	workspace->strm.workspace = kvmalloc(workspacesize, GFP_KERNEL);
 	workspace->buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	workspace->level = level;
 	if (!workspace->strm.workspace || !workspace->buf)
 		goto fail;
 
diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index b06eaf171be7..404101864220 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -53,9 +53,9 @@ static void zstd_cleanup_workspace_manager(void)
 	btrfs_cleanup_workspace_manager(&wsm);
 }
 
-static struct list_head *zstd_get_workspace(void)
+static struct list_head *zstd_get_workspace(unsigned int level)
 {
-	return btrfs_get_workspace(&wsm);
+	return btrfs_get_workspace(&wsm, level);
 }
 
 static void zstd_put_workspace(struct list_head *ws)
@@ -72,7 +72,7 @@ static void zstd_free_workspace(struct list_head *ws)
 	kfree(workspace);
 }
 
-static struct list_head *zstd_alloc_workspace(void)
+static struct list_head *zstd_alloc_workspace(unsigned int level)
 {
 	ZSTD_parameters params =
 			zstd_get_btrfs_parameters(ZSTD_BTRFS_MAX_INPUT);
-- 
2.17.1

