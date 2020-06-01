Return-Path: <SRS0=ZM7b=7O=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1578C433DF
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Jun 2020 15:38:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1B842074B
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Jun 2020 15:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgFAPiT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 11:38:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:34142 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727971AbgFAPhx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Jun 2020 11:37:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 58709B220;
        Mon,  1 Jun 2020 15:37:53 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 22/46] btrfs: Make cow_file_range_async take btrfs_inode
Date:   Mon,  1 Jun 2020 18:37:20 +0300
Message-Id: <20200601153744.31891-23-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200601153744.31891-1-nborisov@suse.com>
References: <20200601153744.31891-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

It only uses vfs inode for assigning it to the async_chunk function.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2798154f2c48..192a2f0ce4ba 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1215,13 +1215,13 @@ static noinline void async_cow_free(struct btrfs_work *work)
 		kvfree(async_chunk->pending);
 }

-static int cow_file_range_async(struct inode *inode,
+static int cow_file_range_async(struct btrfs_inode *inode,
 				struct writeback_control *wbc,
 				struct page *locked_page,
 				u64 start, u64 end, int *page_started,
 				unsigned long *nr_written)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct cgroup_subsys_state *blkcg_css = wbc_blkcg_css(wbc);
 	struct async_cow *ctx;
 	struct async_chunk *async_chunk;
@@ -1233,9 +1233,9 @@ static int cow_file_range_async(struct inode *inode,
 	unsigned nofs_flag;
 	const unsigned int write_flags = wbc_to_write_flags(wbc);

-	unlock_extent(&BTRFS_I(inode)->io_tree, start, end);
+	unlock_extent(&inode->io_tree, start, end);

-	if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
+	if (inode->flags & BTRFS_INODE_NOCOMPRESS &&
 	    !btrfs_test_opt(fs_info, FORCE_COMPRESS)) {
 		num_chunks = 1;
 		should_compress = false;
@@ -1255,8 +1255,8 @@ static int cow_file_range_async(struct inode *inode,
 			PAGE_SET_WRITEBACK | PAGE_END_WRITEBACK |
 			PAGE_SET_ERROR;

-		extent_clear_unlock_delalloc(BTRFS_I(inode), start, end,
-					     locked_page, clear_bits, page_ops);
+		extent_clear_unlock_delalloc(inode, start, end, locked_page,
+					     clear_bits, page_ops);
 		return -ENOMEM;
 	}

@@ -1273,9 +1273,9 @@ static int cow_file_range_async(struct inode *inode,
 		 * igrab is called higher up in the call chain, take only the
 		 * lightweight reference for the callback lifetime
 		 */
-		ihold(inode);
+		ihold(&inode->vfs_inode);
 		async_chunk[i].pending = &ctx->num_chunks;
-		async_chunk[i].inode = inode;
+		async_chunk[i].inode = &inode->vfs_inode;
 		async_chunk[i].start = start;
 		async_chunk[i].end = cur_end;
 		async_chunk[i].write_flags = write_flags;
@@ -1815,7 +1815,7 @@ int btrfs_run_delalloc_range(struct inode *inode, struct page *locked_page,
 	} else {
 		set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
 			&BTRFS_I(inode)->runtime_flags);
-		ret = cow_file_range_async(inode, wbc, locked_page, start, end,
+		ret = cow_file_range_async(BTRFS_I(inode), wbc, locked_page, start, end,
 					   page_started, nr_written);
 	}
 	if (ret)
--
2.17.1

