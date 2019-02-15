Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66912C4360F
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 10:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3559121900
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 10:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405871AbfBOKvG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 05:51:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:54542 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405866AbfBOKvF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 05:51:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AC164AFA9
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2019 10:51:04 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5 05/12] btrfs: extent_io: Handle error better in extent_write_full_page()
Date:   Fri, 15 Feb 2019 18:50:37 +0800
Message-Id: <20190215105044.17619-6-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190215105044.17619-1-wqu@suse.com>
References: <20190215105044.17619-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since now flush_write_bio() could return error, kill the BUG_ON() first.

Then don't call flush_write_bio() unconditionally, instead we check the
return value from __extent_writepage() first.

If __extent_writepage() fails, we do cleanup, and return error without
submitting the possible corrupted or half-baked bio.

If __extent_writepage() successes, then we call flush_write_bio() and
return the result.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 47a579650a61..d14c11592495 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -169,6 +169,16 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 	return blk_status_to_errno(ret);
 }
 
+/* A wrapper for bio_endio() to cleanup unsubmitted bios */
+static void end_write_bio(struct extent_page_data *epd, int ret)
+{
+	if (epd->bio) {
+		epd->bio->bi_status = errno_to_blk_status(ret);
+		bio_endio(epd->bio);
+		epd->bio = NULL;
+	}
+}
+
 /*
  * A wrapper for submit_one_bio().
  *
@@ -3431,6 +3441,9 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
  * records are inserted to lock ranges in the tree, and as dirty areas
  * are found, they are marked writeback.  Then the lock bits are removed
  * and the end_io handler clears the writeback ranges
+ *
+ * Return 0 if everything goes well.
+ * Return <0 for error.
  */
 static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 			      struct extent_page_data *epd)
@@ -3500,6 +3513,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 		end_extent_writepage(page, ret, start, page_end);
 	}
 	unlock_page(page);
+	ASSERT(ret <= 0);
 	return ret;
 
 done_unlocked:
@@ -4040,7 +4054,6 @@ static int extent_write_cache_pages(struct address_space *mapping,
 int extent_write_full_page(struct page *page, struct writeback_control *wbc)
 {
 	int ret;
-	int flush_ret;
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = &BTRFS_I(page->mapping->host)->io_tree,
@@ -4049,9 +4062,14 @@ int extent_write_full_page(struct page *page, struct writeback_control *wbc)
 	};
 
 	ret = __extent_writepage(page, wbc, &epd);
+	ASSERT(ret <= 0);
+	if (ret < 0) {
+		end_write_bio(&epd, ret);
+		return ret;
+	}
 
-	flush_ret = flush_write_bio(&epd);
-	BUG_ON(flush_ret < 0);
+	ret = flush_write_bio(&epd);
+	ASSERT(ret <= 0);
 	return ret;
 }
 
-- 
2.20.1

