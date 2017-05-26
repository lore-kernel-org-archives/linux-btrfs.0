Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49920 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033270AbdEZI4v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 04:56:51 -0400
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 06/13] fs: simplify dio_bio_complete
Date: Fri, 26 May 2017 11:56:13 +0300
Message-Id: <20170526085620.3113-7-hch@lst.de>
In-Reply-To: <20170526085620.3113-1-hch@lst.de>
References: <20170526085620.3113-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Only read bio->bi_error once in the common path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>
---
 fs/direct-io.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 04247a6c3f73..bb711e4b86c2 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -477,13 +477,12 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 {
 	struct bio_vec *bvec;
 	unsigned i;
-	int err;
+	int err = bio->bi_error;
 
-	if (bio->bi_error)
+	if (err)
 		dio->io_error = -EIO;
 
 	if (dio->is_async && dio->op == REQ_OP_READ && dio->should_dirty) {
-		err = bio->bi_error;
 		bio_check_pages_dirty(bio);	/* transfers ownership */
 	} else {
 		bio_for_each_segment_all(bvec, bio, i) {
@@ -494,7 +493,6 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 				set_page_dirty_lock(page);
 			put_page(page);
 		}
-		err = bio->bi_error;
 		bio_put(bio);
 	}
 	return err;
-- 
2.11.0

