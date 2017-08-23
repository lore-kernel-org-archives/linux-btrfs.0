Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45886 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932413AbdHWRKw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 13:10:52 -0400
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 5/6] block: cache the partition index in struct block_device
Date: Wed, 23 Aug 2017 19:10:31 +0200
Message-Id: <20170823171032.30529-6-hch@lst.de>
In-Reply-To: <20170823171032.30529-1-hch@lst.de>
References: <20170823171032.30529-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/block_dev.c     | 1 +
 include/linux/fs.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 9941dc8342df..d29d1c70f833 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1451,6 +1451,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 		bdev->bd_disk = disk;
 		bdev->bd_queue = disk->queue;
 		bdev->bd_contains = bdev;
+		bdev->bd_partno = partno;
 
 		if (!partno) {
 			ret = -ENXIO;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6e1fd5d21248..706dd3a972d2 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -427,6 +427,7 @@ struct block_device {
 #endif
 	struct block_device *	bd_contains;
 	unsigned		bd_block_size;
+	u8			bd_partno;
 	struct hd_struct *	bd_part;
 	/* number of times partitions within this device have been opened. */
 	unsigned		bd_part_count;
-- 
2.11.0

