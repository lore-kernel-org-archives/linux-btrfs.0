Return-Path: <SRS0=I+S+=SR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9A0C10F0E
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 08:29:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A354120651
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Apr 2019 08:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555316963;
	bh=uZPYE35s+Y5yZhkP/DkbHwLMSsBBxTW6TVDPPjvJr6M=;
	h=From:To:Subject:Date:List-ID:From;
	b=es66Q+Ysillav+wbAHw1CSz03xGtFjXAYbLcgSpSavVrN1R0zNBoDxZCxpdL4iWgb
	 jOP/PFnQaHs98IqrdFUgTH5TBoIJBq48r17ajQStZUwpD5cFjsawsFwEs80FYL9z6U
	 TxWsfjWAakKdym1D0/oaYwTQUspqqKNHRcb+nOm0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbfDOI3W (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Apr 2019 04:29:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbfDOI3W (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Apr 2019 04:29:22 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5393A20651
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2019 08:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555316961;
        bh=uZPYE35s+Y5yZhkP/DkbHwLMSsBBxTW6TVDPPjvJr6M=;
        h=From:To:Subject:Date:From;
        b=DtNEF42AISkCGCLfOqvSYCj7C8FtgjQRvBmJNpuX3ybdXHL0LynE5h2MZUM3SvI8C
         TtyRnWpTTA4lT8aEO12Z5DwcFTrm2j+tNTHe7QN0hbAM872JQRHhBFs4ecfGLseqmm
         6074jWSEOh3vpmmrmcc74McfmLFTjKjOP415UD8M=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove no longer used member num_dirty_bgs from transaction
Date:   Mon, 15 Apr 2019 09:29:19 +0100
Message-Id: <20190415082919.2123-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

The member num_dirty_bgs of struct btrfs_transaction is not used anymore,
it is set and incremented but nothing reads its value anymore. Its last
read use was removed by commit 64403612b73a94 ("btrfs: rework
btrfs_check_space_for_delayed_refs"). So just remove that member.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-tree.c | 1 -
 fs/btrfs/transaction.c | 1 -
 fs/btrfs/transaction.h | 1 -
 3 files changed, 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c5880329ae37..5b33cf0a539b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6444,7 +6444,6 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 		if (list_empty(&cache->dirty_list)) {
 			list_add_tail(&cache->dirty_list,
 				      &trans->transaction->dirty_bgs);
-			trans->transaction->num_dirty_bgs++;
 			trans->delayed_ref_updates++;
 			btrfs_get_block_group(cache);
 		}
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e4e665f422fc..fe3df89be708 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -269,7 +269,6 @@ static noinline int join_transaction(struct btrfs_fs_info *fs_info,
 	INIT_LIST_HEAD(&cur_trans->io_bgs);
 	INIT_LIST_HEAD(&cur_trans->dropped_roots);
 	mutex_init(&cur_trans->cache_write_mutex);
-	cur_trans->num_dirty_bgs = 0;
 	spin_lock_init(&cur_trans->dirty_bgs_lock);
 	INIT_LIST_HEAD(&cur_trans->deleted_bgs);
 	spin_lock_init(&cur_trans->dropped_roots_lock);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index f1ba78949d1b..68e429edbc2f 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -80,7 +80,6 @@ struct btrfs_transaction {
 	 */
 	struct mutex cache_write_mutex;
 	spinlock_t dirty_bgs_lock;
-	unsigned int num_dirty_bgs;
 	/* Protected by spin lock fs_info->unused_bgs_lock. */
 	struct list_head deleted_bgs;
 	spinlock_t dropped_roots_lock;
-- 
2.11.0

