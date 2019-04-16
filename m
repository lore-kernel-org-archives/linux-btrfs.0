Return-Path: <SRS0=AHcI=SS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40325C10F14
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 10:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AA2E206BA
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Apr 2019 10:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729023AbfDPKVx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Apr 2019 06:21:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:50676 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728625AbfDPKVw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Apr 2019 06:21:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8DD6BAFD4
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Apr 2019 10:21:51 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs-progs: Avoid nested chunk allocation call
Date:   Tue, 16 Apr 2019 18:21:43 +0800
Message-Id: <20190416102144.12173-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190416102144.12173-1-wqu@suse.com>
References: <20190416102144.12173-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is a hidden call loop which can trigger itself:

btrfs_reserve_extent()             <--|
|- do_chunk_alloc()                   |
   |- btrfs_alloc_chunk()             |
      |- btrfs_insert_item()          |
	 |- btrfs_reserve_extent() <--|

Currently, we're using root->ref_cows to determine whether we should do
chunk prealloc to avoid such loop.

But that's still a hidden trap. Instead of solving it using some hidden
tricks, this patch will make chunk/block group allocation exclusive.

Now if do_chunk_alloc() determines to alloc chunk, it will set a special
flag in transaction handler so it new do_chunk_alloc() will refuse to
allocate new chunk until current chunk allocation finishes.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c  |  2 +-
 extent-tree.c | 12 ++++++++++++
 transaction.c |  3 ++-
 transaction.h |  3 ++-
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/check/main.c b/check/main.c
index 683c322eba6f..121be4b73c4f 100644
--- a/check/main.c
+++ b/check/main.c
@@ -10185,7 +10185,7 @@ int cmd_check(int argc, char **argv)
 			goto close_out;
 		}
 
-		trans->reinit_extent_tree = true;
+		trans->reinit_extent_tree = 1;
 		if (init_extent_tree) {
 			printf("Creating a new extent tree\n");
 			ret = reinit_extent_tree(trans, info,
diff --git a/extent-tree.c b/extent-tree.c
index 8c9cdeff3b02..e25ddf02e5cc 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1873,10 +1873,21 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	    (flags & BTRFS_BLOCK_GROUP_SYSTEM))
 		return 0;
 
+	/*
+	 * We're going to allocate new chunk, during the process, we will
+	 * allocate new tree blocks, which can trigger new chunk allocation
+	 * again.
+	 * Avoid such loop call
+	 */
+	if (trans->allocating_chunk)
+		return 0;
+	trans->allocating_chunk = 1;
+
 	ret = btrfs_alloc_chunk(trans, fs_info, &start, &num_bytes,
 	                        space_info->flags);
 	if (ret == -ENOSPC) {
 		space_info->full = 1;
+		trans->allocating_chunk = 0;
 		return 0;
 	}
 
@@ -1885,6 +1896,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 	ret = btrfs_make_block_group(trans, fs_info, 0, space_info->flags,
 				     start, num_bytes);
 	BUG_ON(ret);
+	trans->allocating_chunk = 0;
 	return 0;
 }
 
diff --git a/transaction.c b/transaction.c
index 3a63988b0969..21377282f806 100644
--- a/transaction.c
+++ b/transaction.c
@@ -46,7 +46,8 @@ struct btrfs_trans_handle* btrfs_start_transaction(struct btrfs_root *root,
 	fs_info->generation++;
 	h->transid = fs_info->generation;
 	h->blocks_reserved = num_blocks;
-	h->reinit_extent_tree = false;
+	h->reinit_extent_tree = 0;
+	h->allocating_chunk = 0;
 	root->last_trans = h->transid;
 	root->commit_root = root->node;
 	extent_buffer_get(root->node);
diff --git a/transaction.h b/transaction.h
index 34060252dd5c..b426cd112447 100644
--- a/transaction.h
+++ b/transaction.h
@@ -28,7 +28,8 @@ struct btrfs_trans_handle {
 	u64 transid;
 	u64 alloc_exclude_start;
 	u64 alloc_exclude_nr;
-	bool reinit_extent_tree;
+	unsigned int reinit_extent_tree:1;
+	unsigned int allocating_chunk:1;
 	u64 delayed_ref_updates;
 	unsigned long blocks_reserved;
 	unsigned long blocks_used;
-- 
2.21.0

