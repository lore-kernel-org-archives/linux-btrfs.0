Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49191 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932204AbdHWRKo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 13:10:44 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] raid5: remove a call to get_start_sect
Date: Wed, 23 Aug 2017 19:10:28 +0200
Message-Id: <20170823171032.30529-3-hch@lst.de>
In-Reply-To: <20170823171032.30529-1-hch@lst.de>
References: <20170823171032.30529-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The block layer always remaps partitions before calling into the
->make_request methods of drivers.  Thus the call to get_start_sect in
in_chunk_boundary will always return 0 and can be removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0fc2748aaf95..d687aeb1b538 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5092,10 +5092,12 @@ static int raid5_congested(struct mddev *mddev, int bits)
 static int in_chunk_boundary(struct mddev *mddev, struct bio *bio)
 {
 	struct r5conf *conf = mddev->private;
-	sector_t sector = bio->bi_iter.bi_sector + get_start_sect(bio->bi_bdev);
+	sector_t sector = bio->bi_iter.bi_sector;
 	unsigned int chunk_sectors;
 	unsigned int bio_sectors = bio_sectors(bio);
 
+	WARN_ON_ONCE(bio->bi_partno);
+
 	chunk_sectors = min(conf->chunk_sectors, conf->prev_chunk_sectors);
 	return  chunk_sectors >=
 		((sector & (chunk_sectors - 1)) + bio_sectors);
-- 
2.11.0

