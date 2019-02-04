Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E067C282C4
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 322C12175B
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549311708;
	bh=wMCAWLmFIDppZH85jSAMdcbP7TOlF9Fl8GyBjlMcRWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hP3vUyW27Gq33eMpfS+/Ep6QcvwPbpK+F54d84h8VldLu5T+DCLeRZyHMHQq4ZJQJ
	 u1287DI1MgIbKCyo3rNA4d1ao+l3rzfWSZ9rQoQt50IeqQ3JEtIC4vyjI/KnjcMYP9
	 AR8OBuyNldEx/AUGzDscm4WSjsrqHrx1v2K8WMSw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbfBDUUp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 15:20:45 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:35250 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728678AbfBDUUo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2019 15:20:44 -0500
Received: by mail-yb1-f196.google.com with SMTP id 64so130592ybs.2;
        Mon, 04 Feb 2019 12:20:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MRC7unlvK6tISJtlLra2M1Dg1hPUsYydDHfrfqPcfSc=;
        b=F3pP8pO+We1mCSQ1NFToWrsvSNtSSGM+P/LWjmeMAVcJSTrrJvFYReNQPkX7y6GfU2
         6rfhmK9GVfGxaEM2IBz2D4ZTg2qilBOrWhlUEycTd/ULgY6j8BGWFXk9Oqgf8AJQFDVE
         5beqXZldmqMaYGqiJJYT2+Pt9fSZ0A+rLCvOhkXRn49ynGVVE2/kr1yM5qnDisWPp5Zq
         jKu+BKH/rnrd/b3XvvcPkRvgz3R9nTl18uz4Hf3Jm0xMvM6y8MWyj2ce87t41IfDZeu8
         fuU0oZQ3EkXqeJRG7KkaBHSCMqoYv3rOFqHm3VPNPFr8lpuMnh/zvB5ydBpxJA5Fje7d
         FnEA==
X-Gm-Message-State: AHQUAuZANjuB73vG9xZ/a7wE/jXQCgjclyV7uM25gCIixeyGKVHAU/28
        efBThj6UtRfXfG+E/kou+lA=
X-Google-Smtp-Source: AHgI3IaM1imlCef2X43j1j2GOBZUhZYYbEjMMGV4QGhOAEs8dMgLmHYD/dWrI/MYlpDAP9QLK+jH0g==
X-Received: by 2002:a25:9a45:: with SMTP id r5mr1087129ybo.139.1549311643862;
        Mon, 04 Feb 2019 12:20:43 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id c68sm708456ywd.52.2019.02.04.12.20.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Feb 2019 12:20:43 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 06/12] btrfs: add compression interface in (get/put)_workspace()
Date:   Mon,  4 Feb 2019 15:20:02 -0500
Message-Id: <20190204202008.51652-7-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190204202008.51652-1-dennis@kernel.org>
References: <20190204202008.51652-1-dennis@kernel.org>
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
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/compression.c | 57 +++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b213d1efb586..98e1b222f78c 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -839,7 +839,7 @@ static void btrfs_cleanup_workspace_manager(struct workspace_manager *wsman)
  * Preallocation makes a forward progress guarantees and we do not return
  * errors.
  */
-static struct list_head *find_workspace(int type)
+static struct list_head *btrfs_get_workspace(struct workspace_manager *wsman)
 {
 	struct list_head *workspace;
 	int cpus = num_online_cpus();
@@ -850,11 +850,11 @@ static struct list_head *find_workspace(int type)
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
@@ -885,7 +885,7 @@ static struct list_head *find_workspace(int type)
 	 * context of btrfs_compress_bio/btrfs_compress_pages
 	 */
 	nofs_flag = memalloc_nofs_save();
-	workspace = wsm[type].ops->alloc_workspace();
+	workspace = wsman->ops->alloc_workspace();
 	memalloc_nofs_restore(nofs_flag);
 
 	if (IS_ERR(workspace)) {
@@ -916,11 +916,17 @@ static struct list_head *find_workspace(int type)
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
@@ -928,27 +934,32 @@ static void free_workspace(int type, struct list_head *workspace)
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
@@ -982,14 +993,14 @@ int btrfs_compress_pages(unsigned int type_level, struct address_space *mapping,
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
 
@@ -1013,9 +1024,9 @@ static int btrfs_decompress_bio(struct compressed_bio *cb)
 	int ret;
 	int type = cb->compress_type;
 
-	workspace = find_workspace(type);
+	workspace = get_workspace(type);
 	ret = btrfs_compress_op[type]->decompress_bio(workspace, cb);
-	free_workspace(type, workspace);
+	put_workspace(type, workspace);
 
 	return ret;
 }
@@ -1031,13 +1042,13 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
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
 
@@ -1465,7 +1476,7 @@ static void heuristic_collect_sample(struct inode *inode, u64 start, u64 end,
  */
 int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 {
-	struct list_head *ws_list = find_workspace(0);
+	struct list_head *ws_list = get_workspace(0);
 	struct heuristic_ws *ws;
 	u32 i;
 	u8 byte;
@@ -1534,7 +1545,7 @@ int btrfs_compress_heuristic(struct inode *inode, u64 start, u64 end)
 	}
 
 out:
-	free_workspace(0, ws_list);
+	put_workspace(0, ws_list);
 	return ret;
 }
 
-- 
2.17.1

