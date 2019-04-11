Return-Path: <SRS0=DOz6=SN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E9BC10F13
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 16:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D79220693
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Apr 2019 16:41:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfDKQlE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Apr 2019 12:41:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:36488 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726644AbfDKQlE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Apr 2019 12:41:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AAB97AC7F;
        Thu, 11 Apr 2019 16:41:03 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] btrfs: simplify read_extent_buffer_pages a bit
Date:   Thu, 11 Apr 2019 18:40:59 +0200
Message-Id: <20190411164059.4981-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently read_extent_buffer_pages() uses a 4 pass algorithm to read an
extent buffer's pages from disk, all 4 stages looping over all pages of
the extent buffer.

1) Loop over all pages and lock them.
2) Loop over all pages and see if one is not marked as PageUptodate, so we
   can break out of the function early.
3) Loop over all pages and if the page is !PageUptodate read the page,
   otherwise unlock the page.
4) Loop over all pages and wait for stable pages.

Unify the 1st two for loops, we can count the number of uptodate pages
after we have locked them without the need for re-starting the loop.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/extent_io.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 828708f6510c..1d538bda4929 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5357,14 +5357,12 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 			lock_page(page);
 		}
 		locked_pages++;
-	}
-	/*
-	 * We need to firstly lock all pages to make sure that
-	 * the uptodate bit of our pages won't be affected by
-	 * clear_extent_buffer_uptodate().
-	 */
-	for (i = 0; i < num_pages; i++) {
-		page = eb->pages[i];
+
+		/*
+		 * We need to firstly lock all pages to make sure that
+		 * the uptodate bit of our pages won't be affected by
+		 * clear_extent_buffer_uptodate().
+		 */
 		if (!PageUptodate(page)) {
 			num_reads++;
 			all_uptodate = 0;
-- 
2.16.4

