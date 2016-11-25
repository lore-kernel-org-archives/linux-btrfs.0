Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60919 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750762AbcKYI2Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Nov 2016 03:28:24 -0500
From: Christoph Hellwig <hch@lst.de>
To: linux-btrfs@vger.kernel.org
Cc: Liu Bo <bo.li.liu@oracle.com>, Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 2/8] btrfs: don't access the bio directly in the raid5/6 code
Date: Fri, 25 Nov 2016 09:07:47 +0100
Message-Id: <1480061273-5722-3-git-send-email-hch@lst.de>
In-Reply-To: <1480061273-5722-1-git-send-email-hch@lst.de>
References: <1480061273-5722-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just use bio_for_each_segment_all to iterate over all segments.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/raid56.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index d016d4a..eece126 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1144,10 +1144,10 @@ static void validate_rbio_for_rmw(struct btrfs_raid_bio *rbio)
 static void index_rbio_pages(struct btrfs_raid_bio *rbio)
 {
 	struct bio *bio;
+	struct bio_vec *bvec;
 	u64 start;
 	unsigned long stripe_offset;
 	unsigned long page_index;
-	struct page *p;
 	int i;
 
 	spin_lock_irq(&rbio->bio_list_lock);
@@ -1156,10 +1156,8 @@ static void index_rbio_pages(struct btrfs_raid_bio *rbio)
 		stripe_offset = start - rbio->bbio->raid_map[0];
 		page_index = stripe_offset >> PAGE_SHIFT;
 
-		for (i = 0; i < bio->bi_vcnt; i++) {
-			p = bio->bi_io_vec[i].bv_page;
-			rbio->bio_pages[page_index + i] = p;
-		}
+		bio_for_each_segment_all(bvec, bio, i)
+			rbio->bio_pages[page_index + i] = bvec->bv_page;
 	}
 	spin_unlock_irq(&rbio->bio_list_lock);
 }
@@ -1433,13 +1431,11 @@ static int fail_bio_stripe(struct btrfs_raid_bio *rbio,
  */
 static void set_bio_pages_uptodate(struct bio *bio)
 {
+	struct bio_vec *bvec;
 	int i;
-	struct page *p;
 
-	for (i = 0; i < bio->bi_vcnt; i++) {
-		p = bio->bi_io_vec[i].bv_page;
-		SetPageUptodate(p);
-	}
+	bio_for_each_segment_all(bvec, bio, i)
+		SetPageUptodate(bvec->bv_page);
 }
 
 /*
-- 
2.1.4

