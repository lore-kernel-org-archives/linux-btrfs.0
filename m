Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34505 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753857AbcKYIi5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 03:38:57 -0500
From: Christoph Hellwig <hch@lst.de>
To: linux-btrfs@vger.kernel.org
Cc: Liu Bo <bo.li.liu@oracle.com>, Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 6/8] btrfs: calculate end of bio offset properly
Date: Fri, 25 Nov 2016 09:07:51 +0100
Message-Id: <1480061273-5722-7-git-send-email-hch@lst.de>
In-Reply-To: <1480061273-5722-1-git-send-email-hch@lst.de>
References: <1480061273-5722-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Use the bvec offset and len members to prepare for multipage bvecs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/compression.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 77042a8..3c1c25c 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -445,6 +445,13 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	return 0;
 }
 
+static u64 bio_end_offset(struct bio *bio)
+{
+	struct bio_vec *last = &bio->bi_io_vec[bio->bi_vcnt - 1];
+
+	return page_offset(last->bv_page) + last->bv_len + last->bv_offset;
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

