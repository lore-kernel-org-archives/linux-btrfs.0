Return-Path: <SRS0=R2l8=VB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C6DC0651F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Jul 2019 15:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 920842083B
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Jul 2019 15:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562253888;
	bh=nUke0nk8yQ71KLQjvjOG8QcHBxqhwFD1Reln3qR/5vU=;
	h=From:To:Subject:Date:List-ID:From;
	b=ZNHB8a2cv7NgD2IZ6FVFy7rWC1gcPlQoRMF8Kcjg40SzcHekO9J4cqmtkJTXuoY0Z
	 35sabaD/nFYJ8oGmEKGEtStoQbHHiJt+VEFum5l6WshX1DHYu+cUgOdp0DBnK8xGit
	 6Nq8Xp4dP9foz4ad70eaK7Mi0QggDEy+AasHpMyU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbfGDPYr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Jul 2019 11:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbfGDPYr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Jul 2019 11:24:47 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 511082083B
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Jul 2019 15:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562253886;
        bh=nUke0nk8yQ71KLQjvjOG8QcHBxqhwFD1Reln3qR/5vU=;
        h=From:To:Subject:Date:From;
        b=pSnH0N8Lj/3yCbkRUKFuYc5Cpsp2oWrOkfbtJX4mRuAXVy+FH/XOOydhqE6nPwRgs
         rs3dWxB9x8Ay9p9AylCJmfER8noply4qdS5NPF97Nu7OUaqs1c0UV9z8+8oZo0Hieu
         2+mmz8F5QQxR3lNP0d837x6ANLE3dxBieyTbOLG4=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] Btrfs: fix inode cache waiters hanging on path allocation failure
Date:   Thu,  4 Jul 2019 16:24:44 +0100
Message-Id: <20190704152444.20815-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

If the caching thread fails to allocate a path, it returns without waking
up any cache waiters, leaving them hang forever. Fix this by following the
same approach as when we fail to start the caching thread: print an error
message, disable inode caching and make the wakers fallback to non-caching
mode behaviour (calling btrfs_find_free_objectid()).

Fixes: 581bb050941b4f ("Btrfs: Cache free inode numbers in memory")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode-map.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
index 05b8c9927f29..4820e05ea6bd 100644
--- a/fs/btrfs/inode-map.c
+++ b/fs/btrfs/inode-map.c
@@ -41,8 +41,10 @@ static int caching_kthread(void *data)
 		return 0;
 
 	path = btrfs_alloc_path();
-	if (!path)
+	if (!path) {
+		fail_caching_thread(root);
 		return -ENOMEM;
+	}
 
 	/* Since the commit root is read-only, we can safely skip locking. */
 	path->skip_locking = 1;
-- 
2.11.0

