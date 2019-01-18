Return-Path: <SRS0=o3FP=P2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A115C43613
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 02:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1168620883
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 02:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbfARCUK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 21:20:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:46884 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726329AbfARCUJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 21:20:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E95B6AD54
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Jan 2019 02:20:07 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 3/5] btrfs: extent_io: Kill the BUG_ON() in flush_write_bio()
Date:   Fri, 18 Jan 2019 10:19:54 +0800
Message-Id: <20190118021956.22949-4-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118021956.22949-1-wqu@suse.com>
References: <20190118021956.22949-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This BUG_ON() is really just a crappy way to workaround the _must_check
attribute of submit_one_bio().

Now kill the BUG_ON() and allow flush_write_bio() to return error
number.

Also add _must_check attribute to flush_write_bio(), and modify all
callers to handle the possible error returned.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 77 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 58 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8a2335713a2d..a60f3ec22053 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -169,15 +169,15 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 	return blk_status_to_errno(ret);
 }
 
-static void flush_write_bio(struct extent_page_data *epd)
+static int __must_check flush_write_bio(struct extent_page_data *epd)
 {
-	if (epd->bio) {
-		int ret;
+	int ret = 0;
 
+	if (epd->bio) {
 		ret = submit_one_bio(epd->bio, 0, 0);
-		BUG_ON(ret < 0); /* -ENOMEM */
 		epd->bio = NULL;
 	}
+	return ret;
 }
 
 int __init extent_io_init(void)
@@ -3504,13 +3504,15 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 			  struct btrfs_fs_info *fs_info,
 			  struct extent_page_data *epd)
 {
-	int i, num_pages;
+	int i, num_pages, failed_page_nr;
 	int flush = 0;
 	int ret = 0;
 
 	if (!btrfs_try_tree_write_lock(eb)) {
+		ret = flush_write_bio(epd);
+		if (ret < 0)
+			return ret;
 		flush = 1;
-		flush_write_bio(epd);
 		btrfs_tree_lock(eb);
 	}
 
@@ -3519,7 +3521,9 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 		if (!epd->sync_io)
 			return 0;
 		if (!flush) {
-			flush_write_bio(epd);
+			ret = flush_write_bio(epd);
+			if (ret < 0)
+				return ret;
 			flush = 1;
 		}
 		while (1) {
@@ -3560,7 +3564,11 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 
 		if (!trylock_page(p)) {
 			if (!flush) {
-				flush_write_bio(epd);
+				ret = flush_write_bio(epd);
+				if (ret < 0) {
+					failed_page_nr = i;
+					goto err_unlock;
+				}
 				flush = 1;
 			}
 			lock_page(p);
@@ -3568,6 +3576,15 @@ lock_extent_buffer_for_io(struct extent_buffer *eb,
 	}
 
 	return ret;
+
+err_unlock:
+	/* Unlock these already locked pages */
+	for (i = 0; i < failed_page_nr; i++) {
+		struct page *p = eb->pages[i];
+
+		unlock_page(p);
+	}
+	return ret;
 }
 
 static void end_extent_buffer_writeback(struct extent_buffer *eb)
@@ -3751,6 +3768,7 @@ int btree_write_cache_pages(struct address_space *mapping,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
 	};
 	int ret = 0;
+	int flush_ret;
 	int done = 0;
 	int nr_to_write_done = 0;
 	struct pagevec pvec;
@@ -3818,6 +3836,11 @@ int btree_write_cache_pages(struct address_space *mapping,
 
 			prev_eb = eb;
 			ret = lock_extent_buffer_for_io(eb, fs_info, &epd);
+			if (ret < 0) {
+				free_extent_buffer(eb);
+				done = 1;
+				break;
+			}
 			if (!ret) {
 				free_extent_buffer(eb);
 				continue;
@@ -3850,8 +3873,10 @@ int btree_write_cache_pages(struct address_space *mapping,
 		index = 0;
 		goto retry;
 	}
-	flush_write_bio(&epd);
-	return ret;
+	flush_ret = flush_write_bio(&epd);
+	if (ret)
+		return ret;
+	return flush_ret;
 }
 
 /**
@@ -3947,7 +3972,9 @@ static int extent_write_cache_pages(struct address_space *mapping,
 			 * tmpfs file mapping
 			 */
 			if (!trylock_page(page)) {
-				flush_write_bio(epd);
+				ret = flush_write_bio(epd);
+				if (ret < 0)
+					break;
 				lock_page(page);
 			}
 
@@ -3957,8 +3984,11 @@ static int extent_write_cache_pages(struct address_space *mapping,
 			}
 
 			if (wbc->sync_mode != WB_SYNC_NONE) {
-				if (PageWriteback(page))
-					flush_write_bio(epd);
+				if (PageWriteback(page)) {
+					ret = flush_write_bio(epd);
+					if (ret < 0)
+						break;
+				}
 				wait_on_page_writeback(page);
 			}
 
@@ -4019,6 +4049,7 @@ static int extent_write_cache_pages(struct address_space *mapping,
 int extent_write_full_page(struct page *page, struct writeback_control *wbc)
 {
 	int ret;
+	int flush_ret;
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = &BTRFS_I(page->mapping->host)->io_tree,
@@ -4028,14 +4059,17 @@ int extent_write_full_page(struct page *page, struct writeback_control *wbc)
 
 	ret = __extent_writepage(page, wbc, &epd);
 
-	flush_write_bio(&epd);
-	return ret;
+	flush_ret = flush_write_bio(&epd);
+	if (ret)
+		return ret;
+	return flush_ret;
 }
 
 int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
 			      int mode)
 {
 	int ret = 0;
+	int flush_ret;
 	struct address_space *mapping = inode->i_mapping;
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 	struct page *page;
@@ -4068,14 +4102,17 @@ int extent_write_locked_range(struct inode *inode, u64 start, u64 end,
 		start += PAGE_SIZE;
 	}
 
-	flush_write_bio(&epd);
-	return ret;
+	flush_ret = flush_write_bio(&epd);
+	if (ret)
+		return ret;
+	return flush_ret;
 }
 
 int extent_writepages(struct address_space *mapping,
 		      struct writeback_control *wbc)
 {
 	int ret = 0;
+	int flush_ret;
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = &BTRFS_I(mapping->host)->io_tree,
@@ -4084,8 +4121,10 @@ int extent_writepages(struct address_space *mapping,
 	};
 
 	ret = extent_write_cache_pages(mapping, wbc, &epd);
-	flush_write_bio(&epd);
-	return ret;
+	flush_ret = flush_write_bio(&epd);
+	if (ret)
+		return ret;
+	return flush_ret;
 }
 
 int extent_readpages(struct address_space *mapping, struct list_head *pages,
-- 
2.20.1

