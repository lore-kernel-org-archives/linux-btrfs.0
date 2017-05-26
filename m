Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42165 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033270AbdEZI4z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 04:56:55 -0400
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 07/13] block_dev: propagate bio_iov_iter_get_pages error in __blkdev_direct_IO
Date: Fri, 26 May 2017 11:56:14 +0300
Message-Id: <20170526085620.3113-8-hch@lst.de>
In-Reply-To: <20170526085620.3113-1-hch@lst.de>
References: <20170526085620.3113-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Once we move the block layer to its own status code we'll still want to
propagate the bio_iov_iter_get_pages, so restructure __blkdev_direct_IO
to take ret into account when returning the errno.
---
 fs/block_dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 519599dddd36..c1dc393ad6b9 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -334,7 +334,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 	bool is_read = (iov_iter_rw(iter) == READ), is_sync;
 	loff_t pos = iocb->ki_pos;
 	blk_qc_t qc = BLK_QC_T_NONE;
-	int ret;
+	int ret = 0;
 
 	if ((pos | iov_iter_alignment(iter)) &
 	    (bdev_logical_block_size(bdev) - 1))
@@ -363,7 +363,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 
 		ret = bio_iov_iter_get_pages(bio, iter);
 		if (unlikely(ret)) {
-			bio->bi_error = ret;
+			bio->bi_error = -EIO;
 			bio_endio(bio);
 			break;
 		}
@@ -412,7 +412,8 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 	}
 	__set_current_state(TASK_RUNNING);
 
-	ret = dio->bio.bi_error;
+	if (!ret)
+		ret = dio->bio.bi_error;
 	if (likely(!ret))
 		ret = dio->size;
 
-- 
2.11.0

