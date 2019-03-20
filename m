Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 760A1C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A27A2184E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbfCTG2C (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 02:28:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:39772 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726749AbfCTG2B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 02:28:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7E668AD3B
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2019 06:27:59 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v5.3 03/11] btrfs: extent_io: Move the BUG_ON() in flush_write_bio() one level up
Date:   Wed, 20 Mar 2019 14:27:41 +0800
Message-Id: <20190320062749.30953-4-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190320062749.30953-1-wqu@suse.com>
References: <20190320062749.30953-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have a BUG_ON() in flush_write_bio() to handle the return value of
submit_one_bio().

Move the BUG_ON() one level up to all its callers.

This patch will introduce temporary variable, @flush_ret to keep code
change minimal in this patch. That variable will be cleaned up when
enhancing the error handling later.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/extent_io.c | 55 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ca8b8e785cf3..58bf6ae29319 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -170,15 +170,28 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 	return blk_status_to_errno(ret);
 }
 
-static void flush_write_bio(struct extent_page_data *epd)
+/*
+ * A wrapper for submit_one_bio().
+ *
+ * Return 0 if everything is OK.
+ * Return <0 for error.
+ */
+static int __must_check flush_write_bio(struct extent_page_data *epd)
 {
-	if (epd->bio) {
-		int ret;
+	int ret = 0;
 
+	if (epd->bio) {
 		ret = submit_one_bio(epd->bio, 0, 0);
-		BUG_ON(ret < 0); /* -ENOMEM */
+		/*
+		 * Clean up of epd->bio is handled by its endio function.
+		 * And endio is either triggered by successful bio execution
+		 * or the error handler of submit bio hook.
+		 * So at this point, no matter what happened, we don't need
+		 * to clean up epd->bio.
+		 */
 		epd->bio = NULL;
 	}
+	return ret;
 }
 
 int __init extent_io_init(void)
@@ -3511,7 +3524,8 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 
 	if (!btrfs_try_tree_write_lock(eb)) {
 		flush = 1;
-		flush_write_bio(epd);
+		ret = flush_write_bio(epd);
+		BUG_ON(ret < 0);
 		btrfs_tree_lock(eb);
 	}
 
@@ -3520,7 +3534,8 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 		if (!epd->sync_io)
 			return 0;
 		if (!flush) {
-			flush_write_bio(epd);
+			ret = flush_write_bio(epd);
+			BUG_ON(ret < 0);
 			flush = 1;
 		}
 		while (1) {
@@ -3561,7 +3576,8 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 
 		if (!trylock_page(p)) {
 			if (!flush) {
-				flush_write_bio(epd);
+				ret = flush_write_bio(epd);
+				BUG_ON(ret < 0);
 				flush = 1;
 			}
 			lock_page(p);
@@ -3753,6 +3769,7 @@ int btree_write_cache_pages(struct address_space *mapping,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
 	};
 	int ret = 0;
+	int flush_ret;
 	int done = 0;
 	int nr_to_write_done = 0;
 	struct pagevec pvec;
@@ -3852,7 +3869,8 @@ int btree_write_cache_pages(struct address_space *mapping,
 		index = 0;
 		goto retry;
 	}
-	flush_write_bio(&epd);
+	flush_ret = flush_write_bio(&epd);
+	BUG_ON(flush_ret < 0);
 	return ret;
 }
 
@@ -3949,7 +3967,8 @@ static int extent_write_cache_pages(struct address_space *mapping,
 			 * tmpfs file mapping
 			 */
 			if (!trylock_page(page)) {
-				flush_write_bio(epd);
+				ret = flush_write_bio(epd);
+				BUG_ON(ret < 0);
 				lock_page(page);
 			}
 
@@ -3959,8 +3978,10 @@ static int extent_write_cache_pages(struct address_space *mapping,
 			}
 
 			if (wbc->sync_mode != WB_SYNC_NONE) {
-				if (PageWriteback(page))
-					flush_write_bio(epd);
+				if (PageWriteback(page)) {
+					ret = flush_write_bio(epd);
+					BUG_ON(ret < 0);
+				}
 				wait_on_page_writeback(page);
 			}
 
@@ -4021,6 +4042,7 @@ static int extent_write_cache_pages(struct address_space *mapping,
 int extent_write_full_page(struct page *page, struct writeback_control *wbc)
 {
 	int ret;
+	int flush_ret;
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = &BTRFS_I(page->mapping->host)->io_tree,
@@ -4030,7 +4052,8 @@ int extent_write_full_page(struct page *page, struct writeback_control *wbc)
 
 	ret = __extent_writepage(page, wbc, &epd);
 
-	flush_write_bio(&epd);
+	flush_ret = flush_write_bio(&epd);
+	BUG_ON(flush_ret < 0);
 	return ret;
 }
 
@@ -4038,6 +4061,7 @@ int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
 			      int mode)
 {
 	int ret = 0;
+	int flush_ret;
 	struct address_space *mapping = inode->i_mapping;
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 	struct page *page;
@@ -4070,7 +4094,8 @@ int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
 		start += PAGE_SIZE;
 	}
 
-	flush_write_bio(&epd);
+	flush_ret = flush_write_bio(&epd);
+	BUG_ON(flush_ret < 0);
 	return ret;
 }
 
@@ -4078,6 +4103,7 @@ int extent_writepages(struct address_space *mapping,
 		      struct writeback_control *wbc)
 {
 	int ret = 0;
+	int flush_ret;
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = &BTRFS_I(mapping->host)->io_tree,
@@ -4086,7 +4112,8 @@ int extent_writepages(struct address_space *mapping,
 	};
 
 	ret = extent_write_cache_pages(mapping, wbc, &epd);
-	flush_write_bio(&epd);
+	flush_ret = flush_write_bio(&epd);
+	BUG_ON(flush_ret < 0);
 	return ret;
 }
 
-- 
2.21.0

