Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C813AC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 10:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2EB520851
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 10:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbfAQKPi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 05:15:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:35956 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726029AbfAQKPi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 05:15:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 57EDBAE24
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Jan 2019 10:15:37 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 2/5] btrfs: extent_io: Kill the forward declaration of flush_write_bio()
Date:   Thu, 17 Jan 2019 18:15:25 +0800
Message-Id: <20190117101528.8675-3-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190117101528.8675-1-wqu@suse.com>
References: <20190117101528.8675-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is no need to forward declare flush_write_bio(), as it only
depends on submit_one_bio().

Both of them are pretty small, just move them to kill the forward
declaration.

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c | 66 +++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 52abe4082680..8a2335713a2d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -147,7 +147,38 @@ static int add_extent_changeset(struct extent_state *state, unsigned bits,
 	return ret;
 }
 
-static void flush_write_bio(struct extent_page_data *epd);
+static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
+				       unsigned long bio_flags)
+{
+	blk_status_t ret = 0;
+	struct bio_vec *bvec = bio_last_bvec_all(bio);
+	struct page *page = bvec->bv_page;
+	struct extent_io_tree *tree = bio->bi_private;
+	u64 start;
+
+	start = page_offset(page) + bvec->bv_offset;
+
+	bio->bi_private = NULL;
+
+	if (tree->ops)
+		ret = tree->ops->submit_bio_hook(tree->private_data, bio,
+					   mirror_num, bio_flags, start);
+	else
+		btrfsic_submit_bio(bio);
+
+	return blk_status_to_errno(ret);
+}
+
+static void flush_write_bio(struct extent_page_data *epd)
+{
+	if (epd->bio) {
+		int ret;
+
+		ret = submit_one_bio(epd->bio, 0, 0);
+		BUG_ON(ret < 0); /* -ENOMEM */
+		epd->bio = NULL;
+	}
+}
 
 int __init extent_io_init(void)
 {
@@ -2692,28 +2723,6 @@ struct bio *btrfs_bio_clone_partial(struct bio *orig, int offset, int size)
 	return bio;
 }
 
-static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
-				       unsigned long bio_flags)
-{
-	blk_status_t ret = 0;
-	struct bio_vec *bvec = bio_last_bvec_all(bio);
-	struct page *page = bvec->bv_page;
-	struct extent_io_tree *tree = bio->bi_private;
-	u64 start;
-
-	start = page_offset(page) + bvec->bv_offset;
-
-	bio->bi_private = NULL;
-
-	if (tree->ops)
-		ret = tree->ops->submit_bio_hook(tree->private_data, bio,
-					   mirror_num, bio_flags, start);
-	else
-		btrfsic_submit_bio(bio);
-
-	return blk_status_to_errno(ret);
-}
-
 /*
  * @opf:	bio REQ_OP_* and REQ_* flags as one value
  * @tree:	tree so we can call our merge_bio hook
@@ -4007,17 +4016,6 @@ static int extent_write_cache_pages(struct address_space *mapping,
 	return ret;
 }
 
-static void flush_write_bio(struct extent_page_data *epd)
-{
-	if (epd->bio) {
-		int ret;
-
-		ret = submit_one_bio(epd->bio, 0, 0);
-		BUG_ON(ret < 0); /* -ENOMEM */
-		epd->bio = NULL;
-	}
-}
-
 int extent_write_full_page(struct page *page, struct writeback_control *wbc)
 {
 	int ret;
-- 
2.20.1

