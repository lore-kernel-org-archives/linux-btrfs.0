Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E98AAC282CD
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8EF72171F
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548710733;
	bh=u1o0KKXoRT0xaWdCqR3x0/26CkhMBmqA8IXBEKQkUZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=R8ZCMVxwmxHnnyC4oYTo8EFBuN38S1V+QUff12e0fdDuzhDz1YPrRZ6vQhNJnpqhL
	 k9D36eHAa7nOxRJwlYCL7m+mx6MVDtEXCQroliUgeE59+gMkEH6lSgapkTQH4SWre7
	 zxxe/g4jsf6rvYrRqSR3UNaf5o7aH8sZnG2KcDzw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbfA1VYy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 16:24:54 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:36597 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728316AbfA1VYw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 16:24:52 -0500
Received: by mail-yb1-f194.google.com with SMTP id 64so2823085ybf.3;
        Mon, 28 Jan 2019 13:24:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UiLjqvhWknXTEAjd/auwTYxNB5iT2kzVZ+BxEPsbB3w=;
        b=XkQ2oMmLQBulRrWUEJLqxCBMmAbzhT+M3UUGPkYtyMBDIIJEhKfdxK2/ET/AxiHFwT
         CmEyNPkfOipSDQnoPaHqIOqwNSPidxksoR1MS6BuoVmlBiO9wazAmm42KaYljwLcvRSb
         mxKm+SRwq1yB6qmzzOCl0GO9r4FCxc8Sum3VJ5XMTel22tRKXInaIj3dCKw2UIXQmvtU
         YQcUipuhU33G9vp2+n1EwkqlxXmCViNHOUHRHTJvQNtvgYU41cb7PLHED7UyfvW88orN
         9HSooDK9hnYTX5t/R3Qd/nCE0v3sVpiG/30HGskHemPfn7HK3F/Jr8vXe1kRkwBmZ6so
         SNUg==
X-Gm-Message-State: AJcUukeFSeZipqm5k0hTB4GQtZ6iJa9XX2XADNCEbu2fPfDSh28MflCv
        6UbO6lD8Ep3D9HLOF9uPvwA=
X-Google-Smtp-Source: ALg8bN6JnvRQ/s9r7F8Np2jL0Xi5rbLTJUww7EbJvyaP38sYkULwZbH/3hztamjAdzCprLvq772qoQ==
X-Received: by 2002:a25:c304:: with SMTP id t4mr23111882ybf.359.1548710691713;
        Mon, 28 Jan 2019 13:24:51 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id a7sm24170415ywb.18.2019.01.28.13.24.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 28 Jan 2019 13:24:50 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 05/11] btrfs: add helper methods for workspace manager init and cleanup
Date:   Mon, 28 Jan 2019 16:24:31 -0500
Message-Id: <20190128212437.11597-6-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190128212437.11597-1-dennis@kernel.org>
References: <20190128212437.11597-1-dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Workspace manager init and cleanup code is open coded inside a for loop
over the compression types. This forces each compression type to rely on
the same workspace manager implementation. This patch creates helper
methods that will be the generic implementation for btrfs workspace
management.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 fs/btrfs/compression.c | 81 ++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 39 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index b7e986e16640..63fa3eaeeacc 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -797,31 +797,41 @@ static const struct btrfs_compress_op * const btrfs_compress_op[] = {
 	&btrfs_zstd_compress,
 };
 
-void __init btrfs_init_compress(void)
+static void btrfs_init_workspace_manager(int type)
 {
+	struct workspace_manager *wsman = &wsm[type];
 	struct list_head *workspace;
-	int i;
 
-	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
-		wsm[i].ops = btrfs_compress_op[i];
+	wsman->ops = btrfs_compress_op[type];
 
-		INIT_LIST_HEAD(&wsm[i].idle_ws);
-		spin_lock_init(&wsm[i].ws_lock);
-		atomic_set(&wsm[i].total_ws, 0);
-		init_waitqueue_head(&wsm[i].ws_wait);
+	INIT_LIST_HEAD(&wsman->idle_ws);
+	spin_lock_init(&wsman->ws_lock);
+	atomic_set(&wsman->total_ws, 0);
+	init_waitqueue_head(&wsman->ws_wait);
 
-		/*
-		 * Preallocate one workspace for each compression type so
-		 * we can guarantee forward progress in the worst case
-		 */
-		workspace = wsm[i].ops->alloc_workspace();
-		if (IS_ERR(workspace)) {
-			pr_warn("BTRFS: cannot preallocate compression workspace, will try later\n");
-		} else {
-			atomic_set(&wsm[i].total_ws, 1);
-			wsm[i].free_ws = 1;
-			list_add(workspace, &wsm[i].idle_ws);
-		}
+	/*
+	 * Preallocate one workspace for each compression type so
+	 * we can guarantee forward progress in the worst case
+	 */
+	workspace = wsman->ops->alloc_workspace();
+	if (IS_ERR(workspace)) {
+		pr_warn("BTRFS: cannot preallocate compression workspace, will try later\n");
+	} else {
+		atomic_set(&wsman->total_ws, 1);
+		wsman->free_ws = 1;
+		list_add(workspace, &wsman->idle_ws);
+	}
+}
+
+static void btrfs_cleanup_workspace_manager(struct workspace_manager *wsman)
+{
+	struct list_head *ws;
+
+	while (!list_empty(&wsman->idle_ws)) {
+		ws = wsman->idle_ws.next;
+		list_del(ws);
+		wsman->ops->free_workspace(ws);
+		atomic_dec(&wsman->total_ws);
 	}
 }
 
@@ -941,24 +951,6 @@ static void free_workspace(int type, struct list_head *workspace)
 	cond_wake_up(ws_wait);
 }
 
-/*
- * cleanup function for module exit
- */
-static void free_workspaces(void)
-{
-	struct list_head *workspace;
-	int i;
-
-	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
-		while (!list_empty(&wsm[i].idle_ws)) {
-			workspace = wsm[i].idle_ws.next;
-			list_del(workspace);
-			wsm[i].ops->free_workspace(workspace);
-			atomic_dec(&wsm[i].total_ws);
-		}
-	}
-}
-
 /*
  * Given an address space and start and length, compress the bytes into @pages
  * that are allocated on demand.
@@ -1051,9 +1043,20 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 	return ret;
 }
 
+void __init btrfs_init_compress(void)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++)
+		btrfs_init_workspace_manager(i);
+}
+
 void __cold btrfs_exit_compress(void)
 {
-	free_workspaces();
+	int i;
+
+	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++)
+		btrfs_cleanup_workspace_manager(&wsm[i]);
 }
 
 /*
-- 
2.17.1

