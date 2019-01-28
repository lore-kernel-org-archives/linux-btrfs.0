Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC66BC282C8
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71964217F5
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548710739;
	bh=9uICnTcPUSEMufM2GkINP736O0GV6EbGUHxiYUI69NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=bmR9ipvFjfSnzdjX7y8TWCK39RIQZBZwgzTtjVSvbX9jTDqc7r//mGfNZzWWTMbVi
	 QUkO0sPmWp+hyi+xLxvj7M6r9eg1AsB7rHr5yV1cFaAgdGH2dZsMJ1MUEaOL7zCBGk
	 tRih2YG2ex22BUkOosywJEj9daVRPsqcTb0lHAqM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbfA1VZd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 16:25:33 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:46082 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728329AbfA1VYy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 16:24:54 -0500
Received: by mail-yw1-f68.google.com with SMTP id t13so7329678ywe.13;
        Mon, 28 Jan 2019 13:24:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LjkQC3v3bDQeODs64cW3hycjplTBkfWbIT2+EqSQ+uc=;
        b=tONn/PICYMbK2k5JNfZdvCPZjdaV/bh9prVdNubhwIVwgzUgK8h3JUzC5UURIuoTb/
         IGRKZ7EA9HvetkNdcmzGNVCagipReuMC4mBWEw9yJc5bqW4QkFhj7h3fiiGgKK89MUQ+
         rX9obWjcrbrMGJ1eqe5p5xwcMhAslo+R7RhpY6IW0Y8WIuUVMmQU6oqixBz8OvvPlusE
         uwu0c8sm7gnBA1WESb2wrrm6Pfokh+7ImI0Lc1OEHxOuLLAvnLA+qAFeEZpKZqVNkP8b
         PM1dcRD5uOATRuZnpiuSmLULA66ngkvABvkZPxapiKWmZYbkokLBJv7fidY2eyUiMJMk
         Cg5A==
X-Gm-Message-State: AJcUukdvQmi+mLYDlUtaD92a6c+YodVkSd9TC/BImkUKp7tv/MginoEe
        ubwTvv4oNqKlXrtqZ71nDFg=
X-Google-Smtp-Source: ALg8bN4krUaaFh3/FYbayZmTR5wPbx/Lm0BpztA0iqE4JGNhILMBbLMdeQY1QlfnL0vFXwT+C2wt0g==
X-Received: by 2002:a81:b61a:: with SMTP id u26mr22289727ywh.250.1548710693154;
        Mon, 28 Jan 2019 13:24:53 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id a7sm24170415ywb.18.2019.01.28.13.24.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 28 Jan 2019 13:24:52 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 06/11] btrfs: add compression interface in (get/put)_workspace()
Date:   Mon, 28 Jan 2019 16:24:32 -0500
Message-Id: <20190128212437.11597-7-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190128212437.11597-1-dennis@kernel.org>
References: <20190128212437.11597-1-dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There are two levels of workspace management. First, alloc()/free()
which are responsible for actually creating and destroy workspaces.
Second, at a higher level, get()/put() which is the compression code
asking for a workspace from a workspace_manager.

The compression code shouldn't really care how it gets a workspace, but
that it got a workspace. This adds get_workspace() and put_workspace()
to be the higher level interface which is responsible for indexing into
the appropriate compression type. It also introduces
btrfs_put_workspace() and btrfs_get_workspace() to be the generic
implementations of the higher interface.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 fs/btrfs/compression.c | 57 +++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 63fa3eaeeacc..2e748d8785f0 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -841,7 +841,7 @@ static void btrfs_cleanup_workspace_manager(struct workspace_manager *wsman)
  * Preallocation makes a forward progress guarantees and we do not return
  * errors.
  */
-static struct list_head *find_workspace(int type)
+static struct list_head *btrfs_get_workspace(struct workspace_manager *wsman)
 {
 	struct list_head *workspace;
 	int cpus = num_online_cpus();
@@ -852,11 +852,11 @@ static struct list_head *find_workspace(int type)
 	wait_queue_head_t *ws_wait;
 	int *free_ws;
 
-	idle_ws	 = &wsm[type].idle_ws;
-	ws_lock	 = &wsm[type].ws_lock;
-	total_ws = &wsm[type].total_ws;
-	ws_wait	 = &wsm[type].ws_wait;
-	free_ws	 = &wsm[type].free_ws;
+	idle_ws	 = &wsman->idle_ws;
+	ws_lock	 = &wsman->ws_lock;
+	total_ws = &wsman->total_ws;
+	ws_wait	 = &wsman->ws_wait;
+	free_ws	 = &wsman->free_ws;
 
 again:
 	spin_lock(ws_lock);
@@ -887,7 +887,7 @@ static struct list_head *find_workspace(int type)
 	 * context of btrfs_compress_bio/btrfs_compress_pages
 	 */
 	nofs_flag = memalloc_nofs_save();
-	workspace = wsm[type].ops->alloc_workspace();
+	workspace = wsman->ops->alloc_workspace();
 	memalloc_nofs_restore(nofs_flag);
 
 	if (IS_ERR(workspace)) {
@@ -918,11 +918,17 @@ static struct list_head *find_workspace(int type)
 	return workspace;
 }
 
+static struct list_head *get_workspace(int type)
+{
+	return btrfs_get_workspace(&wsm[type]);
+}
+
 /*
  * put a workspace struct back on the list or free it if we have enough
  * idle ones sitting around
  */
-static void free_workspace(int type, struct list_head *workspace)
+static void btrfs_put_workspace(struct workspace_manager *wsman,
+				struct list_head *ws)
 {
 	struct list_head *idle_ws;
 	spinlock_t *ws_lock;
@@ -930,27 +936,32 @@ static void free_workspace(int type, struct list_head *workspace)
 	wait_queue_head_t *ws_wait;
 	int *free_ws;
 
-	idle_ws	 = &wsm[type].idle_ws;
-	ws_lock	 = &wsm[type].ws_lock;
-	total_ws = &wsm[type].total_ws;
-	ws_wait	 = &wsm[type].ws_wait;
-	free_ws	 = &wsm[type].free_ws;
+	idle_ws	 = &wsman->idle_ws;
+	ws_lock	 = &wsman->ws_lock;
+	total_ws = &wsman->total_ws;
+	ws_wait	 = &wsman->ws_wait;
+	free_ws	 = &wsman->free_ws;
 
 	spin_lock(ws_lock);
 	if (*free_ws <= num_online_cpus()) {
-		list_add(workspace, idle_ws);
+		list_add(ws, idle_ws);
 		(*free_ws)++;
 		spin_unlock(ws_lock);
 		goto wake;
 	}
 	spin_unlock(ws_lock);
 
-	wsm[type].ops->free_workspace(workspace);
+	wsman->ops->free_workspace(ws);
 	atomic_dec(total_ws);
 wake:
 	cond_wake_up(ws_wait);
 }
 
+static void put_workspace(int type, struct list_head *ws)
+{
+	return btrfs_put_workspace(&wsm[type], ws);
+}
+
 /*
  * Given an address space and start and length, compress the bytes into @pages
  * that are allocated on demand.
@@ -984,14 +995,14 @@ int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
 	struct list_head *workspace;
 	int ret;
 
-	workspace = find_workspace(type);
+	workspace = get_workspace(type);
 
 	btrfs_compress_op[type]->set_level(workspace, type_level);
 	ret = btrfs_compress_op[type]->compress_pages(workspace, mapping,
 						      start, pages,
 						      out_pages,
 						      total_in, total_out);
-	free_workspace(type, workspace);
+	put_workspace(type, workspace);
 	return ret;
 }
 
@@ -1015,9 +1026,9 @@ static int btrfs_decompress_bio(struct compressed_bio *cb)
 	int ret;
 	int type = cb->compress_type;
 
-	workspace = find_workspace(type);
+	workspace = get_workspace(type);
 	ret = btrfs_compress_op[type]->decompress_bio(workspace, cb);
-	free_workspace(type, workspace);
+	put_workspace(type, workspace);
 
 	return ret;
 }
@@ -1033,13 +1044,13 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 	struct list_head *workspace;
 	int ret;
 
-	workspace = find_workspace(type);
+	workspace = get_workspace(type);
 
 	ret = btrfs_compress_op[type]->decompress(workspace, data_in,
 						  dest_page, start_byte,
 						  srclen, destlen);
 
-	free_workspace(type, workspace);
+	put_workspace(type, workspace);
 	return ret;
 }
 
@@ -1467,7 +1478,7 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
  */
 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 {
-	struct list_head *ws_list = find_workspace(0);
+	struct list_head *ws_list = get_workspace(0);
 	struct heuristic_ws *ws;
 	u32 i;
 	u8 byte;
@@ -1536,7 +1547,7 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 	}
 
 out:
-	free_workspace(0, ws_list);
+	put_workspace(0, ws_list);
 	return ret;
 }
 
-- 
2.17.1

