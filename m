Return-Path: <SRS0=Rt3R=CX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889B8C433E2
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Sep 2020 09:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 420142192A
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Sep 2020 09:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgINJhd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Sep 2020 05:37:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:41242 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgINJhS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Sep 2020 05:37:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 22A3DABB2;
        Mon, 14 Sep 2020 09:37:33 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 9/9] btrfs: Sink mirror_num argument in __do_readpage
Date:   Mon, 14 Sep 2020 12:37:11 +0300
Message-Id: <20200914093711.13523-10-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200914093711.13523-1-nborisov@suse.com>
References: <20200914093711.13523-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

It's always set to 0 by the 2 callers so move it inside __do_readpage.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent_io.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 1c959d66195c..1ef857c0d784 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3142,9 +3142,8 @@ __get_extent_map(struct inode *inode, struct page *page, size_t pg_offset,
  * return 0 on success, otherwise return error
  */
 static int __do_readpage(struct page *page, struct extent_map **em_cached,
-			 struct bio **bio, int mirror_num,
-			 unsigned long *bio_flags, unsigned int read_flags,
-			 u64 *prev_em_start)
+			 struct bio **bio, unsigned long *bio_flags,
+			 unsigned int read_flags, u64 *prev_em_start)
 {
 	struct inode *inode = page->mapping->host;
 	u64 start = page_offset(page);
@@ -3322,7 +3321,7 @@ static int __do_readpage(struct page *page, struct extent_map **em_cached,
 		ret = submit_extent_page(REQ_OP_READ | read_flags, NULL,
 					 page, offset, disk_io_size,
 					 pg_offset, bio,
-					 end_bio_extent_readpage, mirror_num,
+					 end_bio_extent_readpage, 0,
 					 *bio_flags,
 					 this_bio_flag,
 					 force_bio_submit);
@@ -3359,7 +3358,7 @@ static inline void contiguous_readpages(struct page *pages[], int nr_pages,
 	btrfs_lock_and_flush_ordered_range(inode, start, end, NULL);

 	for (index = 0; index < nr_pages; index++) {
-		__do_readpage(pages[index], em_cached, bio, 0, bio_flags,
+		__do_readpage(pages[index], em_cached, bio, bio_flags,
 			      REQ_RAHEAD, prev_em_start);
 		put_page(pages[index]);
 	}
@@ -3375,7 +3374,7 @@ int extent_read_full_page(struct page *page, struct bio **bio,

 	btrfs_lock_and_flush_ordered_range(inode, start, end, NULL);

-	ret = __do_readpage(page, NULL, bio, 0, bio_flags, 0, NULL);
+	ret = __do_readpage(page, NULL, bio, bio_flags, 0, NULL);
 	return ret;
 }

--
2.17.1

