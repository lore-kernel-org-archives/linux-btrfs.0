Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41726 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932155AbcKPMw1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 07:52:27 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6zhS-0005RC-IG
        for linux-btrfs@vger.kernel.org; Wed, 16 Nov 2016 12:52:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/9] btrfs: don't access the bio directly in the raid5/6 code
Date: Wed, 16 Nov 2016 13:52:09 +0100
Message-Id: <1479300736-9724-3-git-send-email-hch@lst.de>
In-Reply-To: <1479300736-9724-1-git-send-email-hch@lst.de>
References: <1479300736-9724-1-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just use bio_for_each_segment_all to iterate over all segments.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/btrfs/raid56.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index d016d4a..da941fb 100644
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
+			rbio->bio_pages[page_index+ i] = bvec->bv_page;
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

