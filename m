Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22685 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751656AbdEPJdd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 05:33:33 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/2] block: Introduce blkdev_issue_flush_no_wait()
Date: Tue, 16 May 2017 17:39:13 +0800
Message-Id: <20170516093914.16035-2-anand.jain@oracle.com>
In-Reply-To: <20170516093914.16035-1-anand.jain@oracle.com>
References: <20170516093914.16035-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

blkdev_issue_flush() is a blocking function and returns only after
the flush bio is completed, so a module handling more than one
device can't issue flush for all the devices unless it uses worker
thread.

This patch adds a new function blkdev_issue_flush_no_wait(), which
uses submit_bio() instead of submit_bio_wait(), and accepts the
completion function and data from the caller.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 block/blk-flush.c      | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |  8 ++++++++
 2 files changed, 55 insertions(+)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index c4e0880b54bb..16b9c61f4cd3 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -488,6 +488,53 @@ void blk_insert_flush(struct request *rq)
 	blk_flush_complete_seq(rq, fq, REQ_FSEQ_ACTIONS & ~policy, 0);
 }
 
+/*
+ * blkdev_issue_flush_no_wait - Issue a flush for the given block device
+ * @bdev:       blockdev to issue flush for
+ * @gfp_mask:   memory allocation flags (for bio_alloc)
+ * @endio_fn:   completion function for the flush bio
+ * @data:       flush bio private data
+ *
+ * Description:
+ *    Issue a flush for the block device in question. Caller must provide
+ *    the completion function and the private data, to be called when the
+ *    issued flush bio completes.
+ */
+int blkdev_issue_flush_no_wait(struct block_device *bdev, gfp_t gfp_mask,
+		bio_end_io_t *endio_fn, void *data)
+{
+	struct request_queue *q;
+	struct bio *bio;
+
+	if (bdev->bd_disk == NULL)
+		return -ENXIO;
+
+	q = bdev_get_queue(bdev);
+	if (!q)
+		return -ENXIO;
+
+	/*
+	 * some block devices may not have their queue correctly set up here
+	 * (e.g. loop device without a backing file) and so issuing a flush
+	 * here will panic. Ensure there is a request function before issuing
+	 * the flush.
+	 */
+	if (!q->make_request_fn)
+		return -ENXIO;
+
+	bio = bio_alloc(gfp_mask, 0);
+	bio->bi_bdev = bdev;
+	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
+	bio->bi_end_io = endio_fn;
+	bio->bi_private = data;
+
+	init_completion(data);
+	submit_bio(bio);
+
+	return 0;
+}
+EXPORT_SYMBOL(blkdev_issue_flush_no_wait);
+
 /**
  * blkdev_issue_flush - queue a flush
  * @bdev:	blockdev to issue flush for
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b5d1e27631ee..5d2b62239251 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1322,6 +1322,8 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 }
 
 extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
+extern int blkdev_issue_flush_no_wait(struct block_device *bdev,
+			gfp_t gfp_mask, bio_end_io_t *endio_fn, void *data);
 extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
 
@@ -1994,6 +1996,12 @@ static inline int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 	return 0;
 }
 
+static inline int blkdev_issue_flush_no_wait(struct block_device *bdev,
+			gfp_t gfp_mask, bio_end_io_t *endio_fn, void *data)
+{
+	return 0;
+}
+
 #endif /* CONFIG_BLOCK */
 
 #endif
-- 
2.10.0

