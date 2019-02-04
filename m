Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90097C282C4
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D5912087C
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549311723;
	bh=qWM0K3PJx/ozc42BKFe4btQpjaI19/RRHt8w8Bpi40I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=TSQP+1wIyBrnMBFdk60sezjV/UUOmZ3YqNrfD0CMF4fCR1BSl9VlfUbM36+7TxcU+
	 BSkwZPy6eDCLInjqpbXXqsZqHFAioZ1R36HXsa2COTMtuWgExOtwAXbHYq6a9yc9bE
	 XOOUtu7awHBMGTrhNuqpPb5qhvrbB2SgNp6XkAmQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbfBDUWC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 15:22:02 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:34255 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728551AbfBDUUf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2019 15:20:35 -0500
Received: by mail-yb1-f194.google.com with SMTP id k9so129448ybg.1;
        Mon, 04 Feb 2019 12:20:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=t7UZvl6klzJ8qvHeRBRDc9TGhsVr7wX//i27IIsrtGM=;
        b=GauX656p71QMu0v/J/qfPT1rQ3tym0Z/kVxFCWLSmR3ADwW0whXfZJZcUC9ZC5R4RX
         K10f2iYm9HmMMZIdkdaL/birJytIL80ZgSS7UytQssFv8YbGifvgICcPY8ohKXqW2G9G
         BE7RQRjn3uLu33ydYJG7bns7/lDX/jkvtdl7S1LqZdAxsZCasDyEblf6ypRwTnwFWNpB
         fw4OA0xEhOQBvZVYoln827SxihM7nhuBmqGmkAccGotrClDT8Xt8unU16+vE00lMbjEd
         jb0i3R0Imtq5keZj8ODqWdCs5luI99ZwcsFrpMnOQgqGHvxUd9okYTNbnk+qKfgP/d2t
         XauA==
X-Gm-Message-State: AHQUAuY360VWD/rhNnMA0rd4SeSPIocYfjpA9I4qUpQZDZ8F7nNOXLvw
        42lELZBThDdwhUw/t9IL+eY=
X-Google-Smtp-Source: AHgI3IYtX86PGZ12ESO61+OL9T7eBhUdwv5reLqDUnqkh7IzCfC63MbTA/S1Af2gxEAfRs/CX/fS2Q==
X-Received: by 2002:a5b:5c1:: with SMTP id w1mr1081571ybp.264.1549311634316;
        Mon, 04 Feb 2019 12:20:34 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id c68sm708456ywd.52.2019.02.04.12.20.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Feb 2019 12:20:33 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 02/12] btrfs: rename workspaces_list to workspace_manager
Date:   Mon,  4 Feb 2019 15:19:58 -0500
Message-Id: <20190204202008.51652-3-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190204202008.51652-1-dennis@kernel.org>
References: <20190204202008.51652-1-dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is in preparation for zstd compression levels. As each level will
require different sized workspaces, workspaces_list is no longer a
really fitting name.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/compression.c | 46 +++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 94a0b0a3a301..d098df768b67 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -769,7 +769,7 @@ static struct list_head *alloc_heuristic_ws(void)
 	return ERR_PTR(-ENOMEM);
 }
 
-struct workspaces_list {
+struct workspace_manager {
 	struct list_head idle_ws;
 	spinlock_t ws_lock;
 	/* Number of free workspaces */
@@ -780,9 +780,9 @@ struct workspaces_list {
 	wait_queue_head_t ws_wait;
 };
 
-static struct workspaces_list btrfs_comp_ws[BTRFS_COMPRESS_TYPES];
+static struct workspace_manager wsm[BTRFS_COMPRESS_TYPES];
 
-static struct workspaces_list btrfs_heuristic_ws;
+static struct workspace_manager btrfs_heuristic_ws;
 
 static const struct btrfs_compress_op * const btrfs_compress_op[] = {
 	&btrfs_zlib_compress,
@@ -811,10 +811,10 @@ void __init btrfs_init_compress(void)
 	}
 
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
-		INIT_LIST_HEAD(&btrfs_comp_ws[i].idle_ws);
-		spin_lock_init(&btrfs_comp_ws[i].ws_lock);
-		atomic_set(&btrfs_comp_ws[i].total_ws, 0);
-		init_waitqueue_head(&btrfs_comp_ws[i].ws_wait);
+		INIT_LIST_HEAD(&wsm[i].idle_ws);
+		spin_lock_init(&wsm[i].ws_lock);
+		atomic_set(&wsm[i].total_ws, 0);
+		init_waitqueue_head(&wsm[i].ws_wait);
 
 		/*
 		 * Preallocate one workspace for each compression type so
@@ -824,9 +824,9 @@ void __init btrfs_init_compress(void)
 		if (IS_ERR(workspace)) {
 			pr_warn("BTRFS: cannot preallocate compression workspace, will try later\n");
 		} else {
-			atomic_set(&btrfs_comp_ws[i].total_ws, 1);
-			btrfs_comp_ws[i].free_ws = 1;
-			list_add(workspace, &btrfs_comp_ws[i].idle_ws);
+			atomic_set(&wsm[i].total_ws, 1);
+			wsm[i].free_ws = 1;
+			list_add(workspace, &wsm[i].idle_ws);
 		}
 	}
 }
@@ -856,11 +856,11 @@ static struct list_head *__find_workspace(int type, bool heuristic)
 		ws_wait	 = &btrfs_heuristic_ws.ws_wait;
 		free_ws	 = &btrfs_heuristic_ws.free_ws;
 	} else {
-		idle_ws	 = &btrfs_comp_ws[idx].idle_ws;
-		ws_lock	 = &btrfs_comp_ws[idx].ws_lock;
-		total_ws = &btrfs_comp_ws[idx].total_ws;
-		ws_wait	 = &btrfs_comp_ws[idx].ws_wait;
-		free_ws	 = &btrfs_comp_ws[idx].free_ws;
+		idle_ws	 = &wsm[idx].idle_ws;
+		ws_lock	 = &wsm[idx].ws_lock;
+		total_ws = &wsm[idx].total_ws;
+		ws_wait	 = &wsm[idx].ws_wait;
+		free_ws	 = &wsm[idx].free_ws;
 	}
 
 again:
@@ -952,11 +952,11 @@ static void __free_workspace(int type, struct list_head *workspace,
 		ws_wait	 = &btrfs_heuristic_ws.ws_wait;
 		free_ws	 = &btrfs_heuristic_ws.free_ws;
 	} else {
-		idle_ws	 = &btrfs_comp_ws[idx].idle_ws;
-		ws_lock	 = &btrfs_comp_ws[idx].ws_lock;
-		total_ws = &btrfs_comp_ws[idx].total_ws;
-		ws_wait	 = &btrfs_comp_ws[idx].ws_wait;
-		free_ws	 = &btrfs_comp_ws[idx].free_ws;
+		idle_ws	 = &wsm[idx].idle_ws;
+		ws_lock	 = &wsm[idx].ws_lock;
+		total_ws = &wsm[idx].total_ws;
+		ws_wait	 = &wsm[idx].ws_wait;
+		free_ws	 = &wsm[idx].free_ws;
 	}
 
 	spin_lock(ws_lock);
@@ -998,11 +998,11 @@ static void free_workspaces(void)
 	}
 
 	for (i = 0; i < BTRFS_COMPRESS_TYPES; i++) {
-		while (!list_empty(&btrfs_comp_ws[i].idle_ws)) {
-			workspace = btrfs_comp_ws[i].idle_ws.next;
+		while (!list_empty(&wsm[i].idle_ws)) {
+			workspace = wsm[i].idle_ws.next;
 			list_del(workspace);
 			btrfs_compress_op[i]->free_workspace(workspace);
-			atomic_dec(&btrfs_comp_ws[i].total_ws);
+			atomic_dec(&wsm[i].total_ws);
 		}
 	}
 }
-- 
2.17.1

