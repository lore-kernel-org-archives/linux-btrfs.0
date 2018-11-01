Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C723DC0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 12:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 914AC20657
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 12:10:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 914AC20657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbeKAVMr (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 17:12:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:45992 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728326AbeKAVMj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Nov 2018 17:12:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C5412ADCE
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Nov 2018 12:09:56 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/8] btrfs: Remove extent_io_ops::writepage_end_io_hook
Date:   Thu,  1 Nov 2018 14:09:48 +0200
Message-Id: <1541074194-22227-4-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1541074194-22227-1-git-send-email-nborisov@suse.com>
References: <1541074194-22227-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This callback is ony ever called for data page writeout so
there is no need to actually abstract it via extent_io_ops. Lets just
export it, remove the definition of the callback and call it directly
in the functions that invoke the callback. Also rename the function to
btrfs_writepage_endio_finish_ordered since what it really does is
account finished io in the ordered extent data structures.
No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/compression.c | 11 +++++------
 fs/btrfs/ctree.h       |  3 +++
 fs/btrfs/extent_io.c   | 31 +++++++++++++------------------
 fs/btrfs/extent_io.h   |  2 --
 fs/btrfs/inode.c       |  9 ++++-----
 5 files changed, 25 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 8703ce68fe9d..2f2b63efe5bb 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -250,12 +250,11 @@ static void end_compressed_bio_write(struct bio *bio)
 	inode = cb->inode;
 	tree = &BTRFS_I(inode)->io_tree;
 	cb->compressed_pages[0]->mapping = cb->inode->i_mapping;
-	tree->ops->writepage_end_io_hook(cb->compressed_pages[0],
-					 cb->start,
-					 cb->start + cb->len - 1,
-					 NULL,
-					 bio->bi_status ?
-					 BLK_STS_OK : BLK_STS_NOTSUPP);
+	btrfs_writepage_endio_finish_ordered(cb->compressed_pages[0],
+					     cb->start,
+					     cb->start + cb->len - 1, NULL,
+					     bio->bi_status ?
+					     BLK_STS_OK : BLK_STS_NOTSUPP);
 	cb->compressed_pages[0]->mapping = NULL;
 
 	end_compressed_writeback(inode, cb);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 8e73301eaa65..10f4dad8b16d 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3190,6 +3190,9 @@ int run_delalloc_range(void *private_data, struct page *locked_page, u64 start,
 		       u64 end, int *page_started, unsigned long *nr_written,
 		       struct writeback_control *wbc);
 int btrfs_writepage_cow_fixup(struct page *page, u64 start, u64 end);
+void btrfs_writepage_endio_finish_ordered(struct page *page, u64 start,
+					  u64 end, struct extent_state *state,
+					  int uptodate);
 extern const struct dentry_operations btrfs_dentry_operations;
 
 /* ioctl.c */
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c5c713ebb9b1..05cbd6b3aeec 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2417,9 +2417,7 @@ void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 
-	if (tree->ops && tree->ops->writepage_end_io_hook)
-		tree->ops->writepage_end_io_hook(page, start, end, NULL,
-				uptodate);
+	btrfs_writepage_endio_finish_ordered(page, start, end, NULL, uptodate);
 
 	if (!uptodate) {
 		ClearPageUptodate(page);
@@ -3342,9 +3340,8 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 
 	end = page_end;
 	if (i_size <= start) {
-		if (tree->ops && tree->ops->writepage_end_io_hook)
-			tree->ops->writepage_end_io_hook(page, start,
-							 page_end, NULL, 1);
+		btrfs_writepage_endio_finish_ordered(page, start, page_end,
+						     NULL, 1);
 		goto done;
 	}
 
@@ -3355,9 +3352,9 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 		u64 offset;
 
 		if (cur >= i_size) {
-			if (tree->ops && tree->ops->writepage_end_io_hook)
-				tree->ops->writepage_end_io_hook(page, cur,
-							 page_end, NULL, 1);
+			btrfs_writepage_endio_finish_ordered(page, cur,
+							     page_end, NULL,
+							     1);
 			break;
 		}
 		em = btrfs_get_extent(BTRFS_I(inode), page, pg_offset, cur,
@@ -3391,11 +3388,10 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 			 * end_io notification does not happen here for
 			 * compressed extents
 			 */
-			if (!compressed && tree->ops &&
-			    tree->ops->writepage_end_io_hook)
-				tree->ops->writepage_end_io_hook(page, cur,
-							 cur + iosize - 1,
-							 NULL, 1);
+			if (!compressed)
+				btrfs_writepage_endio_finish_ordered(page, cur,
+							    cur + iosize - 1,
+							    NULL, 1);
 			else if (compressed) {
 				/* we don't want to end_page_writeback on
 				 * a compressed extent.  this happens
@@ -4079,10 +4075,9 @@ int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
 		if (clear_page_dirty_for_io(page))
 			ret = __extent_writepage(page, &wbc_writepages, &epd);
 		else {
-			if (tree->ops && tree->ops->writepage_end_io_hook)
-				tree->ops->writepage_end_io_hook(page, start,
-						 start + PAGE_SIZE - 1,
-						 NULL, 1);
+			btrfs_writepage_endio_finish_ordered(page, start,
+						    start + PAGE_SIZE - 1,
+						    NULL, 1);
 			unlock_page(page);
 		}
 		put_page(page);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 4275a1061f5a..415ea7c2b058 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -106,8 +106,6 @@ struct extent_io_ops {
 	/*
 	 * Optional hooks, called if the pointer is not NULL
 	 */
-	void (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
-				      struct extent_state *state, int uptodate);
 	void (*set_bit_hook)(void *private_data, struct extent_state *state,
 			     unsigned *bits);
 	void (*clear_bit_hook)(void *private_data,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5c07c6f9f7db..9e0f2728b9de 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -847,14 +847,14 @@ static noinline void submit_compressed_extents(struct inode *inode,
 				    ins.offset, async_extent->pages,
 				    async_extent->nr_pages,
 				    async_cow->write_flags)) {
-			struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 			struct page *p = async_extent->pages[0];
 			const u64 start = async_extent->start;
 			const u64 end = start + async_extent->ram_size - 1;
 
 			p->mapping = inode->i_mapping;
-			tree->ops->writepage_end_io_hook(p, start, end,
-							 NULL, 0);
+			btrfs_writepage_endio_finish_ordered(p, start, end,
+							     NULL, 0);
+
 			p->mapping = NULL;
 			extent_clear_unlock_delalloc(inode, start, end, end,
 						     NULL, 0,
@@ -3161,7 +3161,7 @@ static void finish_ordered_fn(struct btrfs_work *work)
 	btrfs_finish_ordered_io(ordered_extent);
 }
 
-static void btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
+void btrfs_writepage_endio_finish_ordered(struct page *page, u64 start, u64 end,
 				struct extent_state *state, int uptodate)
 {
 	struct inode *inode = page->mapping->host;
@@ -10522,7 +10522,6 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	.readpage_io_failed_hook = btrfs_readpage_io_failed_hook,
 
 	/* optional callbacks */
-	.writepage_end_io_hook = btrfs_writepage_end_io_hook,
 	.set_bit_hook = btrfs_set_bit_hook,
 	.clear_bit_hook = btrfs_clear_bit_hook,
 	.merge_extent_hook = btrfs_merge_extent_hook,
-- 
2.7.4

