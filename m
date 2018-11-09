Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A96AC43610
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 14:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E652820825
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 14:08:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E652820825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbeKIXta (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 18:49:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:49806 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728684AbeKIXt3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Nov 2018 18:49:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A4E77AFD0
        for <linux-btrfs@vger.kernel.org>; Fri,  9 Nov 2018 14:08:41 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4/9] btrfs: Remove extent_io_ops::writepage_end_io_hook
Date:   Fri,  9 Nov 2018 16:08:33 +0200
Message-Id: <20181109140838.10457-5-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181109140838.10457-1-nborisov@suse.com>
References: <20181109140838.10457-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This callback is ony ever called for data page writeout so there is no
need to actually abstract it via extent_io_ops. Lets just export it,
remove the definition of the callback and call it directly in the
functions that invoke the callback. Also rename the function to
btrfs_writepage_endio_finish_ordered since what it really does is
account finished io in the ordered extent data structures.  No
functional changes.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/compression.c | 11 +++--------
 fs/btrfs/ctree.h       |  2 ++
 fs/btrfs/extent_io.c   | 33 ++++++++++++---------------------
 fs/btrfs/extent_io.h   |  2 --
 fs/btrfs/inode.c       |  9 ++++-----
 5 files changed, 21 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 2955a4ea2fa8..088570c5dfb8 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -229,7 +229,6 @@ static noinline void end_compressed_writeback(struct inode *inode,
  */
 static void end_compressed_bio_write(struct bio *bio)
 {
-	struct extent_io_tree *tree;
 	struct compressed_bio *cb = bio->bi_private;
 	struct inode *inode;
 	struct page *page;
@@ -248,14 +247,10 @@ static void end_compressed_bio_write(struct bio *bio)
 	 * call back into the FS and do all the end_io operations
 	 */
 	inode = cb->inode;
-	tree = &BTRFS_I(inode)->io_tree;
 	cb->compressed_pages[0]->mapping = cb->inode->i_mapping;
-	tree->ops->writepage_end_io_hook(cb->compressed_pages[0],
-					 cb->start,
-					 cb->start + cb->len - 1,
-					 NULL,
-					 bio->bi_status ?
-					 BLK_STS_OK : BLK_STS_NOTSUPP);
+	btrfs_writepage_endio_finish_ordered(cb->compressed_pages[0],
+			cb->start, cb->start + cb->len - 1, NULL,
+			bio->bi_status ? BLK_STS_OK : BLK_STS_NOTSUPP);
 	cb->compressed_pages[0]->mapping = NULL;
 
 	end_compressed_writeback(inode, cb);
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index ba9539c6acf2..f7df6bc8b8a8 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3190,6 +3190,8 @@ int btrfs_run_delalloc_range(void *private_data, struct page *locked_page,
 		u64 start, u64 end, int *page_started, unsigned long *nr_written,
 		struct writeback_control *wbc);
 int btrfs_writepage_cow_fixup(struct page *page, u64 start, u64 end);
+void btrfs_writepage_endio_finish_ordered(struct page *page, u64 start,
+		u64 end, struct extent_state *state, int uptodate);
 extern const struct dentry_operations btrfs_dentry_operations;
 
 /* ioctl.c */
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6cec272292a6..33d761ff5bd3 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2412,14 +2412,9 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 void end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 {
 	int uptodate = (err == 0);
-	struct extent_io_tree *tree;
 	int ret = 0;
 
-	tree = &BTRFS_I(page->mapping->host)->io_tree;
-
-	if (tree->ops && tree->ops->writepage_end_io_hook)
-		tree->ops->writepage_end_io_hook(page, start, end, NULL,
-				uptodate);
+	btrfs_writepage_endio_finish_ordered(page, start, end, NULL, uptodate);
 
 	if (!uptodate) {
 		ClearPageUptodate(page);
@@ -3342,9 +3337,8 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 
 	end = page_end;
 	if (i_size <= start) {
-		if (tree->ops && tree->ops->writepage_end_io_hook)
-			tree->ops->writepage_end_io_hook(page, start,
-							 page_end, NULL, 1);
+		btrfs_writepage_endio_finish_ordered(page, start, page_end,
+						     NULL, 1);
 		goto done;
 	}
 
@@ -3355,9 +3349,8 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 		u64 offset;
 
 		if (cur >= i_size) {
-			if (tree->ops && tree->ops->writepage_end_io_hook)
-				tree->ops->writepage_end_io_hook(page, cur,
-							 page_end, NULL, 1);
+			btrfs_writepage_endio_finish_ordered(page, cur,
+							     page_end, NULL, 1);
 			break;
 		}
 		em = btrfs_get_extent(BTRFS_I(inode), page, pg_offset, cur,
@@ -3391,11 +3384,10 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
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
@@ -4079,10 +4071,9 @@ int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
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
index f0133ce9c73f..536635efa069 100644
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
@@ -3159,7 +3159,7 @@ static void finish_ordered_fn(struct btrfs_work *work)
 	btrfs_finish_ordered_io(ordered_extent);
 }
 
-static void btrfs_writepage_end_io_hook(struct page *page, u64 start, u64 end,
+void btrfs_writepage_endio_finish_ordered(struct page *page, u64 start, u64 end,
 				struct extent_state *state, int uptodate)
 {
 	struct inode *inode = page->mapping->host;
@@ -10514,7 +10514,6 @@ static const struct extent_io_ops btrfs_extent_io_ops = {
 	.readpage_io_failed_hook = btrfs_readpage_io_failed_hook,
 
 	/* optional callbacks */
-	.writepage_end_io_hook = btrfs_writepage_end_io_hook,
 	.set_bit_hook = btrfs_set_bit_hook,
 	.clear_bit_hook = btrfs_clear_bit_hook,
 	.merge_extent_hook = btrfs_merge_extent_hook,
-- 
2.17.1

