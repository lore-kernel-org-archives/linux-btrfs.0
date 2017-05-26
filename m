Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60081 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033270AbdEZI4r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 04:56:47 -0400
From: Christoph Hellwig <hch@lst.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 05/13] fs: remove the unused error argument to dio_end_io()
Date: Fri, 26 May 2017 11:56:12 +0300
Message-Id: <20170526085620.3113-6-hch@lst.de>
In-Reply-To: <20170526085620.3113-1-hch@lst.de>
References: <20170526085620.3113-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>
---
 fs/btrfs/inode.c   | 6 +++---
 fs/direct-io.c     | 3 +--
 include/linux/fs.h | 2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 17cbe9306faf..758b2666885e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8244,7 +8244,7 @@ static void btrfs_endio_direct_read(struct bio *bio)
 	kfree(dip);
 
 	dio_bio->bi_error = bio->bi_error;
-	dio_end_io(dio_bio, bio->bi_error);
+	dio_end_io(dio_bio);
 
 	if (io_bio->end_io)
 		io_bio->end_io(io_bio, err);
@@ -8304,7 +8304,7 @@ static void btrfs_endio_direct_write(struct bio *bio)
 	kfree(dip);
 
 	dio_bio->bi_error = bio->bi_error;
-	dio_end_io(dio_bio, bio->bi_error);
+	dio_end_io(dio_bio);
 	bio_put(bio);
 }
 
@@ -8673,7 +8673,7 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 		 * Releases and cleans up our dio_bio, no need to bio_put()
 		 * nor bio_endio()/bio_io_error() against dio_bio.
 		 */
-		dio_end_io(dio_bio, ret);
+		dio_end_io(dio_bio);
 	}
 	if (io_bio)
 		bio_put(io_bio);
diff --git a/fs/direct-io.c b/fs/direct-io.c
index a04ebea77de8..04247a6c3f73 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -348,13 +348,12 @@ static void dio_bio_end_io(struct bio *bio)
 /**
  * dio_end_io - handle the end io action for the given bio
  * @bio: The direct io bio thats being completed
- * @error: Error if there was one
  *
  * This is meant to be called by any filesystem that uses their own dio_submit_t
  * so that the DIO specific endio actions are dealt with after the filesystem
  * has done it's completion work.
  */
-void dio_end_io(struct bio *bio, int error)
+void dio_end_io(struct bio *bio)
 {
 	struct dio *dio = bio->bi_private;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 803e5a9b2654..4388ab58843d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2843,7 +2843,7 @@ enum {
 	DIO_SKIP_DIO_COUNT = 0x08,
 };
 
-void dio_end_io(struct bio *bio, int error);
+void dio_end_io(struct bio *bio);
 
 ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 			     struct block_device *bdev, struct iov_iter *iter,
-- 
2.11.0

