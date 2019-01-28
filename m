Return-Path: <SRS0=GbvB=QE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 720DBC282CD
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 439082177E
	for <linux-btrfs@archiver.kernel.org>; Mon, 28 Jan 2019 21:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548710755;
	bh=u+z0fsLpaHz30Jxd1gw6ka/pnc+Ig43T0UIhjQRZH3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ByZq9b/wuNr51RMlO8YN6sT4mp7uolD8dgnO7VzQLYjb75MpKKhRvOBsj2o/o1g+1
	 23BvfbnsTijVXuvQiorYFkQ7Z9GexRqgR8PzxJ+BcMw2XdFZA4hHXReNMfJEAAujMO
	 CNUIYXu5b3uYxwa6zav6MHrlKguWud/BWh0WTloA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbfA1VZy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 28 Jan 2019 16:25:54 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:39603 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbfA1VYs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Jan 2019 16:24:48 -0500
Received: by mail-yb1-f194.google.com with SMTP id s17so7322686ybp.6;
        Mon, 28 Jan 2019 13:24:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/WAqu0DX/+VHR8/AR+fAyEvYgy44PedCWuNMUiZ3ZwQ=;
        b=d9MVOrVNgSX2INSgNVifINeWCR6i0NxJLibRPOyo4/eMoenFfEIFSybljD/QP1XZ0D
         RnF2FMxIrDxRMVkRd7xV/dKDglq91Cf/wNnMK5MIzuA1OfDwD2+U7i0jn9BIrXQTAsMJ
         3QV3LMt9F6Ht3+HQ8hdLgx8Shr7uIJNk1mlwVbpO2SACLK/OTjCkfIEBsQ96vv7tftnP
         s61ufYwwlOe2oLK+BJyjd/oFR1qkP7K18W8IVVL4sl63A/aaL5YlBRka1XhONjocx8yb
         35TaHJXS8TFwv9xBIunYTMkw0Cb/HE5gCfHgpNDpIiUn72fx1dIOzLqUOu4OXao/WNE+
         IA9Q==
X-Gm-Message-State: AHQUAua1EnbjB5KWOo5t1VKmTuhroDNqlWOcplL+log5B+6o8zjccA5n
        gjD+Js98cgIQgSoxYt8plGu1vv7Feyc=
X-Google-Smtp-Source: AHgI3IaVb36rwZpvhgoQDBTd7ET85JdVrNzWf6IindOBp+706Jv0fJWHaNbLuBj4zYOpe7fEkk7+Cw==
X-Received: by 2002:a25:414f:: with SMTP id o76mr6477935yba.159.1548710687582;
        Mon, 28 Jan 2019 13:24:47 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id a7sm24170415ywb.18.2019.01.28.13.24.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 28 Jan 2019 13:24:46 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 02/11] btrfs: rename workspaces_list to workspace_manager
Date:   Mon, 28 Jan 2019 16:24:28 -0500
Message-Id: <20190128212437.11597-3-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190128212437.11597-1-dennis@kernel.org>
References: <20190128212437.11597-1-dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is in preparation for zstd compression levels. As each level will
require different sized workspaces, workspaces_list is no longer a
really fitting name.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 fs/btrfs/compression.c | 46 +++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 586f95ac0aea..aced261984e2 100644
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

