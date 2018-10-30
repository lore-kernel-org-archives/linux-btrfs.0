Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FD1C2BC61
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 06:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 239E820657
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 06:58:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="pzxuacnD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 239E820657
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=synology.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbeJ3Pux (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 11:50:53 -0400
Received: from synology.com ([59.124.61.242]:36272 "EHLO synology.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbeJ3Puw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 11:50:52 -0400
Received: from localhost.localdomain (unknown [10.13.20.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by synology.com (Postfix) with ESMTPSA id 5FBFA2535028;
        Tue, 30 Oct 2018 14:58:36 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
        t=1540882716; bh=Y7+5rAuss99oRsFsAnWFiuRYJPEYokTLc/wVzn4ApSE=;
        h=From:To:Cc:Subject:Date;
        b=pzxuacnDzzbsLQNvaoiPXJOP/YmOn7P05FK50FsAbxNDHxzvM62jSv/E6C1puxjat
         4PRoYi1/O/5pTvoLQJ7FLEah9pQwmhwqCop1Lx9oDaFxjxQ+Ja4dHBndXswmq+WATg
         ik5lMskIHnxJsI/jA6hRKd7WsuibnIZ1fYj9W7fo=
From:   robbieko <robbieko@synology.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Robbie Ko <robbieko@synology.com>
Subject: [PATCH] Btrfs: incremental send, fix infinite loop when apply children dir moves
Date:   Tue, 30 Oct 2018 14:58:22 +0800
Message-Id: <1540882702-21104-1-git-send-email-robbieko@synology.com>
X-Mailer: git-send-email 1.9.1
X-Synology-MCP-Status: no
X-Synology-Spam-Flag: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Virus-Status: no
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Robbie Ko <robbieko@synology.com>

In apply_children_dir_moves, we first create an empty list (stack),
then we get an entry from pending_dir_moves and add it to the stack,
but we didn't delete the entry from rb_tree.

So, in add_pending_dir_move, we create a new entry and then use the
parent_ino in the current rb_tree to find the corresponding entry,
and if so, add the new entry to the corresponding list.

However, the entry may have been added to the stack, causing new
entries to be added to the stack as well.

Finally, each time we take the first entry from the stack and start
processing, it ends up with an infinite loop.

Fix this problem by remove node from pending_dir_moves,
avoid add new pending_dir_move to error list.

Signed-off-by: Robbie Ko <robbieko@synology.com>
---
 fs/btrfs/send.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 094cc144..5be83b5 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3340,7 +3340,8 @@ static void free_pending_move(struct send_ctx *sctx, struct pending_dir_move *m)
 	kfree(m);
 }
 
-static void tail_append_pending_moves(struct pending_dir_move *moves,
+static void tail_append_pending_moves(struct send_ctx *sctx,
+				      struct pending_dir_move *moves,
 				      struct list_head *stack)
 {
 	if (list_empty(&moves->list)) {
@@ -3351,6 +3352,10 @@ static void tail_append_pending_moves(struct pending_dir_move *moves,
 		list_add_tail(&moves->list, stack);
 		list_splice_tail(&list, stack);
 	}
+	if (!RB_EMPTY_NODE(&moves->node)) {
+		rb_erase(&moves->node, &sctx->pending_dir_moves);
+		RB_CLEAR_NODE(&moves->node);
+	}
 }
 
 static int apply_children_dir_moves(struct send_ctx *sctx)
@@ -3365,7 +3370,7 @@ static int apply_children_dir_moves(struct send_ctx *sctx)
 		return 0;
 
 	INIT_LIST_HEAD(&stack);
-	tail_append_pending_moves(pm, &stack);
+	tail_append_pending_moves(sctx, pm, &stack);
 
 	while (!list_empty(&stack)) {
 		pm = list_first_entry(&stack, struct pending_dir_move, list);
@@ -3376,7 +3381,7 @@ static int apply_children_dir_moves(struct send_ctx *sctx)
 			goto out;
 		pm = get_pending_dir_moves(sctx, parent_ino);
 		if (pm)
-			tail_append_pending_moves(pm, &stack);
+			tail_append_pending_moves(sctx, pm, &stack);
 	}
 	return 0;
 
-- 
1.9.1

