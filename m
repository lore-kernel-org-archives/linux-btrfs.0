Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8283AC10F12
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 09:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B1F12173C
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 09:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555493338;
	bh=BHooVTkdpyQX8oO41Xf2W8ClDBM2qf93QuDHCuwRmZw=;
	h=From:To:Subject:Date:List-ID:From;
	b=UvNNJzwWqpLAWwNzcjE2BoLxrisIDASwUAmoM+K9tTsBavSSKGm4tJgitDgGgoknT
	 I3HOiLVtLL3xf041xC5lEY1ioNBKYAhwsRV0h7wpzM4qsZjDjoikE7JouRtcrCkbpt
	 qyNn76pAzrKHEHvj9qZKgoj1Ze9+W/pDb+crTfWM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731549AbfDQJ25 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 05:28:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726237AbfDQJ2w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 05:28:52 -0400
Received: from localhost.localdomain (bl8-197-74.dsl.telepac.pt [85.241.197.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9F232073F
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Apr 2019 09:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555493331;
        bh=BHooVTkdpyQX8oO41Xf2W8ClDBM2qf93QuDHCuwRmZw=;
        h=From:To:Subject:Date:From;
        b=HYfMEJOHKva3tv5xVkehhycKnWSn7aLnpKSmzPHOw7lDlTwWtkuFqo3Q6PIKY83lB
         Z0pptXnzs8S+V3+z8N8UAvr854it60M4k2ct4NbEffSikXs7PL+qHc6WL+jDG0WybN
         vQCIHlRF0y6mmHRbDCenTJHo9HdPoxm2h9zT6qNA=
From:   fdmanana@kernel.org
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: remove no longer used function to run delayed refs asynchronously
Date:   Wed, 17 Apr 2019 10:28:47 +0100
Message-Id: <20190417092847.17299-1-fdmanana@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

It used to be called from only two places (truncate path and releasing a
transaction handle), but commits 28bad2125767c5 ("btrfs: fix truncate
throttling") and db2462a6ad3dc4 ("btrfs: don't run delayed refs in the end
transaction logic") removed their calls to this function, so it's not used
anymore. Just remove it and all its helpers.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/ctree.h       |  2 --
 fs/btrfs/extent-tree.c | 91 --------------------------------------------------
 2 files changed, 93 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 0f4838e00fbc..a1c7effe6de4 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2698,8 +2698,6 @@ void btrfs_wait_nocow_writers(struct btrfs_block_group_cache *bg);
 void btrfs_put_block_group(struct btrfs_block_group_cache *cache);
 int btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 			   unsigned long count);
-int btrfs_async_run_delayed_refs(struct btrfs_fs_info *fs_info,
-				 unsigned long count, u64 transid, int wait);
 void btrfs_cleanup_ref_head_accounting(struct btrfs_fs_info *fs_info,
 				  struct btrfs_delayed_ref_root *delayed_refs,
 				  struct btrfs_delayed_ref_head *head);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 5b33cf0a539b..22dccd691c1e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2877,97 +2877,6 @@ int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans)
 	return btrfs_check_space_for_delayed_refs(trans->fs_info);
 }
 
-struct async_delayed_refs {
-	struct btrfs_root *root;
-	u64 transid;
-	int count;
-	int error;
-	int sync;
-	struct completion wait;
-	struct btrfs_work work;
-};
-
-static inline struct async_delayed_refs *
-to_async_delayed_refs(struct btrfs_work *work)
-{
-	return container_of(work, struct async_delayed_refs, work);
-}
-
-static void delayed_ref_async_start(struct btrfs_work *work)
-{
-	struct async_delayed_refs *async = to_async_delayed_refs(work);
-	struct btrfs_trans_handle *trans;
-	struct btrfs_fs_info *fs_info = async->root->fs_info;
-	int ret;
-
-	/* if the commit is already started, we don't need to wait here */
-	if (btrfs_transaction_blocked(fs_info))
-		goto done;
-
-	trans = btrfs_join_transaction(async->root);
-	if (IS_ERR(trans)) {
-		async->error = PTR_ERR(trans);
-		goto done;
-	}
-
-	/*
-	 * trans->sync means that when we call end_transaction, we won't
-	 * wait on delayed refs
-	 */
-	trans->sync = true;
-
-	/* Don't bother flushing if we got into a different transaction */
-	if (trans->transid > async->transid)
-		goto end;
-
-	ret = btrfs_run_delayed_refs(trans, async->count);
-	if (ret)
-		async->error = ret;
-end:
-	ret = btrfs_end_transaction(trans);
-	if (ret && !async->error)
-		async->error = ret;
-done:
-	if (async->sync)
-		complete(&async->wait);
-	else
-		kfree(async);
-}
-
-int btrfs_async_run_delayed_refs(struct btrfs_fs_info *fs_info,
-				 unsigned long count, u64 transid, int wait)
-{
-	struct async_delayed_refs *async;
-	int ret;
-
-	async = kmalloc(sizeof(*async), GFP_NOFS);
-	if (!async)
-		return -ENOMEM;
-
-	async->root = fs_info->tree_root;
-	async->count = count;
-	async->error = 0;
-	async->transid = transid;
-	if (wait)
-		async->sync = 1;
-	else
-		async->sync = 0;
-	init_completion(&async->wait);
-
-	btrfs_init_work(&async->work, btrfs_extent_refs_helper,
-			delayed_ref_async_start, NULL, NULL);
-
-	btrfs_queue_work(fs_info->extent_workers, &async->work);
-
-	if (wait) {
-		wait_for_completion(&async->wait);
-		ret = async->error;
-		kfree(async);
-		return ret;
-	}
-	return 0;
-}
-
 /*
  * this starts processing the delayed reference count updates and
  * extent insertions we have queued up so far.  count can be
-- 
2.11.0

