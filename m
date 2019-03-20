Return-Path: <SRS0=xnYl=RX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEBFFC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E90B2184E
	for <linux-btrfs@archiver.kernel.org>; Wed, 20 Mar 2019 06:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbfCTG2D (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Mar 2019 02:28:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:39780 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727452AbfCTG2C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Mar 2019 02:28:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 51C7CAD49
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Mar 2019 06:28:01 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v5.3 04/11] btrfs: extent_io: Handle error better in extent_write_full_page()
Date:   Wed, 20 Mar 2019 14:27:42 +0800
Message-Id: <20190320062749.30953-5-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190320062749.30953-1-wqu@suse.com>
References: <20190320062749.30953-1-wqu@suse.com>
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
index 58bf6ae29319..2a51627d7f24 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -170,6 +170,16 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
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
@@ -3432,6 +3442,9 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
  * records are inserted to lock ranges in the tree, and as dirty areas
  * are found, they are marked writeback.  Then the lock bits are removed
  * and the end_io handler clears the writeback ranges
+ *
+ * Return 0 if everything goes well.
+ * Return <0 for error.
  */
 static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 			      struct extent_page_data *epd)
@@ -3501,6 +3514,7 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 		end_extent_writepage(page, ret, start, page_end);
 	}
 	unlock_page(page);
+	ASSERT(ret <= 0);
 	return ret;
 
 done_unlocked:
@@ -4042,7 +4056,6 @@ static int extent_write_cache_pages(struct address_space *mapping,
 int extent_write_full_page(struct page *page, struct writeback_control *wbc)
 {
 	int ret;
-	int flush_ret;
 	struct extent_page_data epd = {
 		.bio = NULL,
 		.tree = &BTRFS_I(page->mapping->host)->io_tree,
@@ -4051,9 +4064,14 @@ int extent_write_full_page(struct page *page, struct writeback_control *wbc)
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
2.21.0

