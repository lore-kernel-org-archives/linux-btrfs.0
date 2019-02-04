Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66DDC282CB
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 789A42087C
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549311682;
	bh=QHbshw8L8v/QTV0OoUXKImNaj1GlZM0dws2ZcyjKSiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=cFO+DoNgrGeELoDJmcWq+w/SF816o1DvUOy5aauDV7PQQFeUFc65Imj92//SifzSJ
	 2TXRiSXLKLmBkJ1UMf1ooGfCF7Gd3HoktpnyLMiaDREGLsonsuADC+tC69HOrpfdFX
	 F2Ok+Of4d1iZEOvQn8BO3W7Wdlb0mm+Adsw9w1zU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbfBDUUu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 15:20:50 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:39457 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728678AbfBDUUt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2019 15:20:49 -0500
Received: by mail-yb1-f195.google.com with SMTP id s17so129759ybp.6;
        Mon, 04 Feb 2019 12:20:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Me85pUs0XYPFEJfk4M7NM1PtfT8vCEUo6SpT+p3l0Dg=;
        b=RhweovtVQhk1OGrGqCUjuhXSuocl0nOTKELrk7aDb5StGrd7rT2HRBi/0+Oh1QggdH
         D8iyK+IOlFwOLOq9nYP7XxH4RvqFsXvO5b8gkbyLnjmfv+dk3NQds/Mw+3iBR82rRrel
         NeZXMmsIwW5tg4zCJLXA+AAAWHmIWKo46eynC8nZfQTwAu8HB36bwdr9kJTk6cHu9cPV
         XovTcLGLb3giYYc0rOUuGQ28kQp7tvPPYkSYLWKSgOrPkseWcFDyyDRY9hiasT5Ru30T
         AiHv8ZhwkuiKUyHYpD0wR1KSL/ViPDqfmyZNYTMem/prn+RMrPwtRpWM01ingSE+BRbj
         N5eA==
X-Gm-Message-State: AHQUAuaKcNQWLD61E0A9WEEHR9plwdVoqIKjYd6E3QSV08fnnY9mNMzN
        qWB+ICIqnHLH5qDFt6z0/24=
X-Google-Smtp-Source: AHgI3IbED7i/Mwu5MN9vs8ptka+I0TAPO/LHvglliUkQxuZv9eIX2JVatSVBs6VpCeANggMYKmviwA==
X-Received: by 2002:a25:5755:: with SMTP id l82mr1163800ybb.138.1549311648033;
        Mon, 04 Feb 2019 12:20:48 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id c68sm708456ywd.52.2019.02.04.12.20.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Feb 2019 12:20:47 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 08/12] btrfs: plumb level through the compression interface
Date:   Mon,  4 Feb 2019 15:20:04 -0500
Message-Id: <20190204202008.51652-9-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190204202008.51652-1-dennis@kernel.org>
References: <20190204202008.51652-1-dennis@kernel.org>
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
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/compression.c | 31 ++++++++++++++++---------------
 fs/btrfs/compression.h |  7 ++++---
 fs/btrfs/lzo.c         |  6 +++---
 fs/btrfs/zlib.c        |  7 ++++---
 fs/btrfs/zstd.c        |  6 +++---
 5 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 3d42ab71455d..a54b210739bc 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -742,9 +742,9 @@ static void heuristic_cleanup_workspace_manager(void)
 	btrfs_cleanup_workspace_manager(&heuristic_wsm);
 }
 
-static struct list_head *heuristic_get_workspace(void)
+static struct list_head *heuristic_get_workspace(unsigned int level)
 {
-	return btrfs_get_workspace(&heuristic_wsm);
+	return btrfs_get_workspace(&heuristic_wsm, level);
 }
 
 static void heuristic_put_workspace(struct list_head *ws)
@@ -764,7 +764,7 @@ static void free_heuristic_ws(struct list_head *ws)
 	kfree(workspace);
 }
 
-static struct list_head *alloc_heuristic_ws(void)
+static struct list_head *alloc_heuristic_ws(unsigned int level)
 {
 	struct heuristic_ws *ws;
 
@@ -823,7 +823,7 @@ void btrfs_init_workspace_manager(struct workspace_manager *wsm,
 	 * Preallocate one workspace for each compression type so
 	 * we can guarantee forward progress in the worst case
 	 */
-	workspace = wsm->ops->alloc_workspace();
+	workspace = wsm->ops->alloc_workspace(0);
 	if (IS_ERR(workspace)) {
 		pr_warn("BTRFS: cannot preallocate compression workspace, will try later\n");
 	} else {
@@ -851,7 +851,8 @@ void btrfs_cleanup_workspace_manager(struct workspace_manager *wsman)
  * Preallocation makes a forward progress guarantees and we do not return
  * errors.
  */
-struct list_head *btrfs_get_workspace(struct workspace_manager *wsm)
+struct list_head *btrfs_get_workspace(struct workspace_manager *wsm,
+				      unsigned int level)
 {
 	struct list_head *workspace;
 	int cpus = num_online_cpus();
@@ -897,7 +898,7 @@ struct list_head *btrfs_get_workspace(struct workspace_manager *wsm)
 	 * context of btrfs_compress_bio/btrfs_compress_pages
 	 */
 	nofs_flag = memalloc_nofs_save();
-	workspace = wsm->ops->alloc_workspace();
+	workspace = wsm->ops->alloc_workspace(level);
 	memalloc_nofs_restore(nofs_flag);
 
 	if (IS_ERR(workspace)) {
@@ -928,9 +929,9 @@ struct list_head *btrfs_get_workspace(struct workspace_manager *wsm)
 	return workspace;
 }
 
-static struct list_head *get_workspace(int type)
+static struct list_head *get_workspace(int type, int level)
 {
-	return btrfs_compress_op[type]->get_workspace();
+	return btrfs_compress_op[type]->get_workspace(level);
 }
 
 /*
@@ -1001,12 +1002,13 @@ int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
 			 unsigned long *total_out)
 {
 	int type = btrfs_compress_type(type_level);
+	int level = btrfs_compress_level(type_level);
 	struct list_head *workspace;
 	int ret;
 
-	workspace = get_workspace(type);
+	workspace = get_workspace(type, level);
 
-	btrfs_compress_op[type]->set_level(workspace, type_level);
+	btrfs_compress_op[type]->set_level(workspace, level);
 	ret = btrfs_compress_op[type]->compress_pages(workspace, mapping,
 						      start, pages,
 						      out_pages,
@@ -1035,7 +1037,7 @@ static int btrfs_decompress_bio(struct compressed_bio *cb)
 	int ret;
 	int type = cb->compress_type;
 
-	workspace = get_workspace(type);
+	workspace = get_workspace(type, 0);
 	ret = btrfs_compress_op[type]->decompress_bio(workspace, cb);
 	put_workspace(type, workspace);
 
@@ -1053,13 +1055,12 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
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
 
@@ -1487,7 +1488,7 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
  */
 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 {
-	struct list_head *ws_list = get_workspace(0);
+	struct list_head *ws_list = get_workspace(0, 0);
 	struct heuristic_ws *ws;
 	u32 i;
 	u8 byte;
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index 8422e6ce4838..32ba40ebae1d 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -121,7 +121,8 @@ struct workspace_manager {
 
 void btrfs_init_workspace_manager(struct workspace_manager *wsm,
 				  const struct btrfs_compress_op *ops);
-struct list_head *btrfs_get_workspace(struct workspace_manager *wsm);
+struct list_head *btrfs_get_workspace(struct workspace_manager *wsm,
+				      unsigned int level);
 void btrfs_put_workspace(struct workspace_manager *wsm, struct list_head *ws);
 void btrfs_cleanup_workspace_manager(struct workspace_manager *wsm);
 
@@ -130,11 +131,11 @@ struct btrfs_compress_op {
 
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
index 773d1d70ceec..c0ef09bef3b3 100644
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

