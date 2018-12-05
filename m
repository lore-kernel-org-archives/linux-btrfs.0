Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651D7C04EBF
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E8B52084C
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 12:29:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E8B52084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727759AbeLEM3B (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 07:29:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:48468 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727679AbeLEM3A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 07:29:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E962CADA9
        for <linux-btrfs@vger.kernel.org>; Wed,  5 Dec 2018 12:28:58 +0000 (UTC)
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     linux-btrfs@vger.kernel.org
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 04/10] Rename __endio_write_update_ordered() to btrfs_update_ordered_extent()
Date:   Wed,  5 Dec 2018 06:28:29 -0600
Message-Id: <20181205122835.19290-5-rgoldwyn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20181205122835.19290-1-rgoldwyn@suse.de>
References: <20181205122835.19290-1-rgoldwyn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Since we will be using it in another part of the code, use a
better name to declare it non-static

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/btrfs/ctree.h |  7 +++++--
 fs/btrfs/inode.c | 14 +++++---------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 038d64ecebe5..5144d28216b0 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3170,8 +3170,11 @@ struct inode *btrfs_iget_path(struct super_block *s, struct btrfs_key *location,
 struct inode *btrfs_iget(struct super_block *s, struct btrfs_key *location,
 			 struct btrfs_root *root, int *was_new);
 struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
-				    struct page *page, size_t pg_offset,
-				    u64 start, u64 end, int create);
+		struct page *page, size_t pg_offset,
+		u64 start, u64 end, int create);
+void btrfs_update_ordered_extent(struct inode *inode,
+		const u64 offset, const u64 bytes,
+		const bool uptodate);
 int btrfs_update_inode(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root,
 			      struct inode *inode);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9ea4c6f0352f..96e9fe9e4150 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -97,10 +97,6 @@ static struct extent_map *create_io_em(struct inode *inode, u64 start, u64 len,
 				       u64 ram_bytes, int compress_type,
 				       int type);
 
-static void __endio_write_update_ordered(struct inode *inode,
-					 const u64 offset, const u64 bytes,
-					 const bool uptodate);
-
 /*
  * Cleanup all submitted ordered extents in specified range to handle errors
  * from the fill_dellaloc() callback.
@@ -130,7 +126,7 @@ static inline void btrfs_cleanup_ordered_extents(struct inode *inode,
 		ClearPagePrivate2(page);
 		put_page(page);
 	}
-	return __endio_write_update_ordered(inode, offset + PAGE_SIZE,
+	return btrfs_update_ordered_extent(inode, offset + PAGE_SIZE,
 					    bytes - PAGE_SIZE, false);
 }
 
@@ -8059,7 +8055,7 @@ static void btrfs_endio_direct_read(struct bio *bio)
 	bio_put(bio);
 }
 
-static void __endio_write_update_ordered(struct inode *inode,
+void btrfs_update_ordered_extent(struct inode *inode,
 					 const u64 offset, const u64 bytes,
 					 const bool uptodate)
 {
@@ -8112,7 +8108,7 @@ static void btrfs_endio_direct_write(struct bio *bio)
 	struct btrfs_dio_private *dip = bio->bi_private;
 	struct bio *dio_bio = dip->dio_bio;
 
-	__endio_write_update_ordered(dip->inode, dip->logical_offset,
+	btrfs_update_ordered_extent(dip->inode, dip->logical_offset,
 				     dip->bytes, !bio->bi_status);
 
 	kfree(dip);
@@ -8432,7 +8428,7 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 		bio = NULL;
 	} else {
 		if (write)
-			__endio_write_update_ordered(inode,
+			btrfs_update_ordered_extent(inode,
 						file_offset,
 						dio_bio->bi_iter.bi_size,
 						false);
@@ -8572,7 +8568,7 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 			 */
 			if (dio_data.unsubmitted_oe_range_start <
 			    dio_data.unsubmitted_oe_range_end)
-				__endio_write_update_ordered(inode,
+				btrfs_update_ordered_extent(inode,
 					dio_data.unsubmitted_oe_range_start,
 					dio_data.unsubmitted_oe_range_end -
 					dio_data.unsubmitted_oe_range_start,
-- 
2.16.4

