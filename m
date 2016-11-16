Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41792 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932390AbcKPMwk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 07:52:40 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6zhf-0005T6-Dm
        for linux-btrfs@vger.kernel.org; Wed, 16 Nov 2016 12:52:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 6/9] btrfs: calculate end of bio offset properly
Date: Wed, 16 Nov 2016 13:52:13 +0100
Message-Id: <1479300736-9724-7-git-send-email-hch@lst.de>
In-Reply-To: <1479300736-9724-1-git-send-email-hch@lst.de>
References: <1479300736-9724-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the bvec offset and len members to prepare for multipage bvecs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/compression.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 8618ac3..27e9feb 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -445,6 +445,13 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	return 0;
 }
 
+static u64 bio_end_offset(struct bio *bio)
+{
+	struct bio_vec *last = &bio->bi_io_vec[bio->bi_vcnt - 1];
+
+	return page_offset(last->bv_page) + last->bv_len - last->bv_offset;
+}
+
 static noinline int add_ra_bio_pages(struct inode *inode,
 				     u64 compressed_end,
 				     struct compressed_bio *cb)
@@ -463,8 +470,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 	u64 end;
 	int misses = 0;
 
-	page = cb->orig_bio->bi_io_vec[cb->orig_bio->bi_vcnt - 1].bv_page;
-	last_offset = (page_offset(page) + PAGE_SIZE);
+	last_offset = bio_end_offset(cb->orig_bio);
 	em_tree = &BTRFS_I(inode)->extent_tree;
 	tree = &BTRFS_I(inode)->io_tree;
 
-- 
2.1.4

