Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55259 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbdFCHiS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Jun 2017 03:38:18 -0400
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 03/13] gfs2: remove the unused sd_log_error field
Date: Sat,  3 Jun 2017 09:37:56 +0200
Message-Id: <20170603073806.2046-4-hch@lst.de>
In-Reply-To: <20170603073806.2046-1-hch@lst.de>
References: <20170603073806.2046-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>
---
 fs/gfs2/incore.h | 1 -
 fs/gfs2/lops.c   | 4 +---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index b7cf65d13561..aa3d44527fa2 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -815,7 +815,6 @@ struct gfs2_sbd {
 	atomic_t sd_log_in_flight;
 	struct bio *sd_log_bio;
 	wait_queue_head_t sd_log_flush_wait;
-	int sd_log_error;
 
 	atomic_t sd_reserving_log;
 	wait_queue_head_t sd_reserving_log_wait;
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index b1f9144b42c7..13ebf15a4db0 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -209,10 +209,8 @@ static void gfs2_end_log_write(struct bio *bio)
 	struct page *page;
 	int i;
 
-	if (bio->bi_error) {
-		sdp->sd_log_error = bio->bi_error;
+	if (bio->bi_error)
 		fs_err(sdp, "Error %d writing to log\n", bio->bi_error);
-	}
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		page = bvec->bv_page;
-- 
2.11.0

