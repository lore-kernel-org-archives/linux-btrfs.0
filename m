Return-Path: <SRS0=6ZPf=QL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 286A6C282C4
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E94742082E
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Feb 2019 20:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549311643;
	bh=5BzBDGl89iY8uNP9ukBLWcC08CJGJRIDx36qdlk9FjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=2EAlBNEe3lvJyhAANTh0bwF8N21X7N0RdoURSbLm9UUrt2u47Ab9cfBbMWVusjBTF
	 PRWqmAkoPDqKzDz/+GsHn2TU8JXdnIcenzhPbygTxEDQffAOQnERua6iAGiuwkKFc2
	 kkbpP4IrCETXOFOiF3LLXqlADNWbf4oJXcHsvS5s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbfBDUUm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Feb 2019 15:20:42 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:46777 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728620AbfBDUUk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Feb 2019 15:20:40 -0500
Received: by mail-yw1-f66.google.com with SMTP id n12so785177ywn.13;
        Mon, 04 Feb 2019 12:20:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dS7931gnmpXPlqIElyMB/kD2yIQUH7kCsCyNP2Jaotc=;
        b=ruMVOvYXaeF6VdF4ORg9v/QRYePfZ2mGEr6HXLVU1UOpUChzeK6LFYYxVsYfA7A+46
         1Dy+1uBV3HeTDRNSQs0Vwy1AGEiJ/azMXUtgG+Mmxys2N5W+G5t19c0eMH/1rUmRd57o
         KxsZjmyvHVdHg2mALvYRRF/RID13KyNQUPcsDTNjSy2A8ZusfxrSf6UWm+u6dCi1qUyD
         roDXVlU8cCsef98zuf2vSAas2/vbxe4pqab+ZnTkmwShjTsqJAZNGwf9n762Ed4WWArK
         Rqf3R9AggzEhN2m70inJ9Mx7WQh2ZpA4kPM3QX9t4AdSLuojZcy5yKX7PifFmxVhSIQH
         +J7A==
X-Gm-Message-State: AHQUAuabZZR6JFXXXEsHzqR2KwsvIUGGWwtCMPU4VIQWyge8Mkl2k5Dn
        I0jC0sI0izAmN9+0v/pbGKI=
X-Google-Smtp-Source: AHgI3IZ7rJqoKxJ2EgaYC03M+IqpVCKRZmi5Er7BM1bBBlhBCkF5DTpnzqS1VykkXfZBJcWLuRPa+g==
X-Received: by 2002:a81:5e86:: with SMTP id s128mr1166068ywb.134.1549311639600;
        Mon, 04 Feb 2019 12:20:39 -0800 (PST)
Received: from dennisz-mbp.thefacebook.com ([199.201.65.135])
        by smtp.gmail.com with ESMTPSA id c68sm708456ywd.52.2019.02.04.12.20.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Feb 2019 12:20:38 -0800 (PST)
From:   Dennis Zhou <dennis@kernel.org>
To:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        Omar Sandoval <osandov@osandov.com>,
        Nick Terrell <terrelln@fb.com>,
        Nikolay Borisov <nborisov@suse.com>
Cc:     kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 04/12] btrfs: unify compression ops with workspace_manager
Date:   Mon,  4 Feb 2019 15:20:00 -0500
Message-Id: <20190204202008.51652-5-dennis@kernel.org>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20190204202008.51652-1-dennis@kernel.org>
References: <20190204202008.51652-1-dennis@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Make the workspace_manager own the interface operations rather than
managing index-paired arrays for the workspace_manager and compression
operations.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/compression.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 5b508cb3b236..ef560b47b9c5 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -775,6 +775,7 @@ const struct btrfs_compress_op btrfs_heuristic_compress = {
 };
 
 struct workspace_manager {
+	const struct btrfs_compress_op *ops;
 	struct list_head idle_ws;
 	spinlock_t ws_lock;
 	/* Number of free workspaces */
@@ -800,6 +801,8 @@ void __init btrfs_init_compress(void)
 	int i;
 
 	for (i = 0; i < BTRFS_NR_WORKSPACE_MANAGERS; i++) {
+		wsm[i].ops = btrfs_compress_op[i];
+
 		INIT_LIST_HEAD(&wsm[i].idle_ws);
 		spin_lock_init(&wsm[i].ws_lock);
 		atomic_set(&wsm[i].total_ws, 0);
@@ -809,7 +812,7 @@ void __init btrfs_init_compress(void)
 		 * Preallocate one workspace for each compression type so
 		 * we can guarantee forward progress in the worst case
 		 */
-		workspace = btrfs_compress_op[i]->alloc_workspace();
+		workspace = wsm[i].ops->alloc_workspace();
 		if (IS_ERR(workspace)) {
 			pr_warn("BTRFS: cannot preallocate compression workspace, will try later\n");
 		} else {
@@ -872,7 +875,7 @@ static struct list_head *find_workspace(int type)
 	 * context of btrfs_compress_bio/btrfs_compress_pages
 	 */
 	nofs_flag = memalloc_nofs_save();
-	workspace = btrfs_compress_op[type]->alloc_workspace();
+	workspace = wsm[type].ops->alloc_workspace();
 	memalloc_nofs_restore(nofs_flag);
 
 	if (IS_ERR(workspace)) {
@@ -930,7 +933,7 @@ static void free_workspace(int type, struct list_head *workspace)
 	}
 	spin_unlock(ws_lock);
 
-	btrfs_compress_op[type]->free_workspace(workspace);
+	wsm[type].ops->free_workspace(workspace);
 	atomic_dec(total_ws);
 wake:
 	cond_wake_up(ws_wait);
@@ -948,7 +951,7 @@ static void free_workspaces(void)
 		while (!list_empty(&wsm[i].idle_ws)) {
 			workspace = wsm[i].idle_ws.next;
 			list_del(workspace);
-			btrfs_compress_op[i]->free_workspace(workspace);
+			wsm[i].ops->free_workspace(workspace);
 			atomic_dec(&wsm[i].total_ws);
 		}
 	}
-- 
2.17.1

