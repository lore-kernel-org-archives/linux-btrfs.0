Return-Path: <SRS0=TRLW=RO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB939C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 07:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C397320643
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Mar 2019 07:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfCKHzm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Mar 2019 03:55:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:59684 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725831AbfCKHzm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Mar 2019 03:55:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B0D39AAC4
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Mar 2019 07:55:40 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Exploit the fact pages passed to extent_readpages are always contiguous
Date:   Mon, 11 Mar 2019 09:55:38 +0200
Message-Id: <20190311075538.19242-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently extent_readpages (called from btrfs_redpages) will always call
__extent_readpages which tries to create contiguous range of pages and
call __do_contiguous_readpages when such contiguous range is created.

It turns out this is unnecessary due to the fact that generic VFS code
always calls filesystem's ->readpages callback (btrfs_readpages in
this case) with already contiguous pages. Armed with this knowledge it's
possible to simplify extent_readpages by eliminating the call to
__extent_readpages and directly calling contiguous_readpages. The only
edge case that needs to be handled is when add_to_page_cache_lru
fails. This is easy as all that is needed is to submit whatever is the
number of pages successfully added to the lru.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

I've been running with this patch for the past 3 months and haven't encountered 
any issues with it.
 fs/btrfs/extent_io.c | 58 +++++++++++---------------------------------
 1 file changed, 14 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b20700ad8752..551dd21d7351 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3066,7 +3066,7 @@ static int __do_readpage(struct extent_io_tree *tree,
 	return ret;
 }
 
-static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
+static inline void contiguous_readpages(struct extent_io_tree *tree,
 					     struct page *pages[], int nr_pages,
 					     u64 start, u64 end,
 					     struct extent_map **em_cached,
@@ -3097,46 +3097,6 @@ static inline void __do_contiguous_readpages(struct extent_io_tree *tree,
 	}
 }
 
-static void __extent_readpages(struct extent_io_tree *tree,
-			       struct page *pages[],
-			       int nr_pages,
-			       struct extent_map **em_cached,
-			       struct bio **bio, unsigned long *bio_flags,
-			       u64 *prev_em_start)
-{
-	u64 start = 0;
-	u64 end = 0;
-	u64 page_start;
-	int index;
-	int first_index = 0;
-
-	for (index = 0; index < nr_pages; index++) {
-		page_start = page_offset(pages[index]);
-		if (!end) {
-			start = page_start;
-			end = start + PAGE_SIZE - 1;
-			first_index = index;
-		} else if (end + 1 == page_start) {
-			end += PAGE_SIZE;
-		} else {
-			__do_contiguous_readpages(tree, &pages[first_index],
-						  index - first_index, start,
-						  end, em_cached,
-						  bio, bio_flags,
-						  prev_em_start);
-			start = page_start;
-			end = start + PAGE_SIZE - 1;
-			first_index = index;
-		}
-	}
-
-	if (end)
-		__do_contiguous_readpages(tree, &pages[first_index],
-					  index - first_index, start,
-					  end, em_cached, bio,
-					  bio_flags, prev_em_start);
-}
-
 static int __extent_read_full_page(struct extent_io_tree *tree,
 				   struct page *page,
 				   get_extent_t *get_extent,
@@ -4098,6 +4058,8 @@ int extent_readpages(struct address_space *mapping, struct list_head *pages,
 	u64 prev_em_start = (u64)-1;
 
 	while (!list_empty(pages)) {
+		u64 contig_end = 0;
+
 		for (nr = 0; nr < ARRAY_SIZE(pagepool) && !list_empty(pages);) {
 			struct page *page = lru_to_page(pages);
 
@@ -4106,14 +4068,22 @@ int extent_readpages(struct address_space *mapping, struct list_head *pages,
 			if (add_to_page_cache_lru(page, mapping, page->index,
 						readahead_gfp_mask(mapping))) {
 				put_page(page);
-				continue;
+				break;
 			}
 
 			pagepool[nr++] = page;
+			contig_end = page_offset(page) + PAGE_SIZE - 1;
 		}
 
-		__extent_readpages(tree, pagepool, nr, &em_cached, &bio,
-				   &bio_flags, &prev_em_start);
+		if (nr) {
+			u64 contig_start = page_offset(pagepool[0]);
+
+			ASSERT(contig_start + (nr*PAGE_SIZE) - 1 == contig_end);
+
+			contiguous_readpages(tree, pagepool, nr, contig_start,
+				     contig_end, &em_cached, &bio, &bio_flags,
+				     &prev_em_start);
+		}
 	}
 
 	if (em_cached)
-- 
2.17.1

