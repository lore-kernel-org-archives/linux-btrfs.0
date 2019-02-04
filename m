Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2DEAC282CC
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70C242087C
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549311712;
	bh=1Y80seLG5ugPCI+R/PsAQmy0mGbWR+S3X8XYNw5xZNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XAxPq4JigAVKHA4ccd9l3XI71yV1LDOhNbdL1shGEIFfvR8uGXL8qn74MLEhvCuH5
	 GGys/3AnlcbVKZ5WB+iGypaO1yveKyaRFQWtK+ffwZUxK0e4EeqMhpe3vJKSw3jNb8
	 v0QKrZcFgeJZyNZ98jRG1vrn7NzIyds+E2MYoZOg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbfBDUUn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 15:20:43 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:33785 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728644AbfBDUUm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2019 15:20:42 -0500
Received: by mail-yb1-f193.google.com with SMTP id m132so130071ybf.0;
        Mon, 04 Feb 2019 12:20:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3caGqJUCcyvvOv96kDZ/pw2PhfluULU1VO44vYjOu8o=;
        b=rQzVezFgGis5LKwqo4XYpRo86X4px8NCcVIcW0sqeP4fymaeEuy5EPaIZsdqHJRtsE
         wYvsVdrsBAoHHzWi8uCrTVrTxzxVofyAktRGOKv5bOaNP0XyGILeza9R7RVeI6dfxx+5
         o2zyvlNpUgQ0kKKavVCbYrTHqHAzRDgNXqRetBBFVrX/W+5wCyRuVDVFprAAf24RM0gI
         ytif26eEtnS+S8iedu5+vakaVqafq2wWrJLyfn5hV6laW+n89HknnnAd6FAeDIPNIiVo
         xhw3l7D5mc0YcMSO19Q9v+2TKk5U0UO6X66DpcUYgy+aX0DEoCuT9xfy5SjtvlkZC82X
         NGhw==
X-Gm-Message-State: AHQUAuZ4hkk+lQ9D9o3Pgswq5KAVbiZpp6ghOhlKNIBzRzC52y2Zr8hq
        mj6QGGkK1uEfh9p5dvZvS/8=
X-Google-Smtp-Source: AHgI3IY/Vlf6wXVu8lxlGfvHfkdwJMedLl+X906JWPrnpyo2iItVwLcKc4f65EEMOafdr5nDLtq6KQ==
X-Received: by 2002:a25:3450:: with SMTP id b77mr1144242yba.72.1549311641707;
        Mon, 04 Feb 2019 12:20:41 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id c68sm708456ywd.52.2019.02.04.12.20.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Feb 2019 12:20:40 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 05/12] btrfs: add helper methods for workspace manager init and cleanup
Date:   Mon,  4 Feb 2019 15:20:01 -0500
Message-Id: <20190204202008.51652-6-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190204202008.51652-1-dennis@kernel.org>
References: <20190204202008.51652-1-dennis@kernel.org>
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
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/compression.c | 81 ++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 39 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ef560b47b9c5..b213d1efb586 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -795,31 +795,41 @@ static const struct btrfs_compress_op * const btrfs_compress_op[] = {
 	&btrfs_zstd_compress,
 };
 
-void __init btrfs_init_compress(void)
+static void btrfs_init_workspace_manager(int type)
 {
+	struct workspace_manager *wsman = &wsm[type];
 	struct list_head *workspace;
-	int i;
 
-	for (i = 0; i < BTRFS_NR_WORKSPACE_MANAGERS; i++) {
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
 
@@ -939,24 +949,6 @@ static void free_workspace(int type, struct list_head *workspace)
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
-	for (i = 0; i < BTRFS_NR_WORKSPACE_MANAGERS; i++) {
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
@@ -1049,9 +1041,20 @@ int btrfs_decompress(int type, unsigned char *data_in, struct page *dest_page,
 	return ret;
 }
 
+void __init btrfs_init_compress(void)
+{
+	int i;
+
+	for (i = 0; i < BTRFS_NR_WORKSPACE_MANAGERS; i++)
+		btrfs_init_workspace_manager(i);
+}
+
 void __cold btrfs_exit_compress(void)
 {
-	free_workspaces();
+	int i;
+
+	for (i = 0; i < BTRFS_NR_WORKSPACE_MANAGERS; i++)
+		btrfs_cleanup_workspace_manager(&wsm[i]);
 }
 
 /*
-- 
2.17.1

