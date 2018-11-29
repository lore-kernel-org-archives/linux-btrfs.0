Return-Path: <SRS0=A/rP=OI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E972C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 16:41:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FBFC20989
	for <linux-btrfs@archiver.kernel.org>; Thu, 29 Nov 2018 16:41:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FBFC20989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbeK3Drf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 22:47:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:58656 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729290AbeK3Dre (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 22:47:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ED88DAD48
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2018 16:41:35 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Refactor main loop in extent_readpages
Date:   Thu, 29 Nov 2018 18:41:31 +0200
Message-Id: <20181129164131.4716-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

extent_readpages processes all pages in the readlist in batches of 16,
this is implemented by a single for loop but thanks to an if condition
the loop does 2 things based on whether we've filled the batch or not.
Additionally due to the structure of the code there is an additional
check which deals with partial batches.

Streamline all of this by explicitly using two loops. The outter one is
used to process all pages while the inner one just fills in the batch
of 16 (currently). Due to this new structure the code guarantees that
all pages are processed in the loop hence the code to deal with any
leftovers is eliminated.

This also enable the compiler to inline __extent_readpages:

	./scripts/bloat-o-meter fs/btrfs/extent_io.o extent_io.for

	add/remove: 0/1 grow/shrink: 1/0 up/down: 660/-820 (-160)
	Function                                     old     new   delta
	extent_readpages                             476    1136    +660
	__extent_readpages                           820       -    -820
	Total: Before=44315, After=44155, chg -0.36%

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8332c5f4b1c3..233f835dd6f8 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4093,43 +4093,38 @@ int extent_writepages(struct address_space *mapping,
 int extent_readpages(struct address_space *mapping, struct list_head *pages,
 		     unsigned nr_pages)
 {
+#define BTRFS_PAGES_BATCH 16
+
 	struct bio *bio = NULL;
-	unsigned page_idx;
 	unsigned long bio_flags = 0;
-	struct page *pagepool[16];
-	struct page *page;
+	struct page *pagepool[BTRFS_PAGES_BATCH];
 	struct extent_map *em_cached = NULL;
 	struct extent_io_tree *tree = &BTRFS_I(mapping->host)->io_tree;
 	int nr = 0;
 	u64 prev_em_start = (u64)-1;
 
-	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
-		page = lru_to_page(pages);
+	while (!list_empty(pages)) {
+		for (nr = 0; nr < BTRFS_PAGES_BATCH && !list_empty(pages);) {
+			struct page *page = lru_to_page(pages);
 
-		prefetchw(&page->flags);
-		list_del(&page->lru);
-		if (add_to_page_cache_lru(page, mapping,
-					page->index,
-					readahead_gfp_mask(mapping))) {
-			put_page(page);
-			continue;
+			prefetchw(&page->flags);
+			list_del(&page->lru);
+			if (add_to_page_cache_lru(page, mapping, page->index,
+						readahead_gfp_mask(mapping))) {
+				put_page(page);
+				continue;
+			}
+
+			pagepool[nr++] = page;
 		}
 
-		pagepool[nr++] = page;
-		if (nr < ARRAY_SIZE(pagepool))
-			continue;
 		__extent_readpages(tree, pagepool, nr, &em_cached, &bio,
-				&bio_flags, &prev_em_start);
-		nr = 0;
+				   &bio_flags, &prev_em_start);
 	}
-	if (nr)
-		__extent_readpages(tree, pagepool, nr, &em_cached, &bio,
-				&bio_flags, &prev_em_start);
 
 	if (em_cached)
 		free_extent_map(em_cached);
 
-	BUG_ON(!list_empty(pages));
 	if (bio)
 		return submit_one_bio(bio, 0, bio_flags);
 	return 0;
-- 
2.17.1

