From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] btrfs scrub - restore bios properly after media errors
Date: Sat, 9 Apr 2011 14:29:24 +0300
Message-ID: <20110409112924.GB29836@kwango.lan.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arne Jansen <sensille@gmx.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The current code reallocates a bio after a media error.  This is a
temporary measure introduced in v3 after a serious problem related to
bio reuse was found in v2 of scrub patchset.

Basically we did not reset bv_offset and bv_len fields of the bio_vec
structure.  They are changed in case I/O error happens, for example, at
offset 512 or 1024 into the page.  Also bi_flags field wasn't properly
setup before reusing the bio.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 fs/btrfs/scrub.c |   48 +++++++++++++-----------------------------------
 1 files changed, 13 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index e862167..1631327 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -418,45 +418,24 @@ static void scrub_checksum(scrub_work_t *work)
 	int ret;
 
 	if (sbio->err) {
-		struct bio *bio;
-		struct bio *old_bio;
-
-		for (i = 0; i < sbio->count; ++i) {
+		for (i = 0; i < sbio->count; ++i)
 			scrub_recheck_error(sbio, i);
+
+		sbio->bio->bi_flags &= ~(BIO_POOL_MASK - 1);
+		sbio->bio->bi_flags |= 1 << BIO_UPTODATE;
+		sbio->bio->bi_phys_segments = 0;
+		sbio->bio->bi_idx = 0;
+
+		for (i = 0; i < sbio->count; i++) {
+			struct bio_vec *bi;
+			bi = &sbio->bio->bi_io_vec[i];
+			bi->bv_offset = 0;
+			bi->bv_len = PAGE_SIZE;
 		}
+
 		spin_lock(&sdev->stat_lock);
 		++sdev->stat.read_errors;
 		spin_unlock(&sdev->stat_lock);
-
-		/*
-		 * FIXME: allocate a new bio after a media error. I haven't
-		 * figured out how to reuse this one
-		 */
-		old_bio = sbio->bio;
-		bio = bio_kmalloc(GFP_NOFS, SCRUB_PAGES_PER_BIO);
-		if (!bio) {
-			/*
-			 * alloc failed. cancel the scrub and don't requeue
-			 * this sbio
-			 */
-			printk(KERN_ERR "btrfs scrub: allocation failure, "
-			                "cancelling scrub\n");
-			atomic_inc(&sdev->dev->dev_root->fs_info->
-			                          scrub_cancel_req);
-			goto out_no_enqueue;
-		}
-		sbio->bio = bio;
-		bio->bi_private = sbio;
-		bio->bi_end_io = scrub_bio_end_io;
-		bio->bi_sector = 0;
-		bio->bi_bdev = sbio->sdev->dev->bdev;
-		bio->bi_size = 0;
-		for (i = 0; i < SCRUB_PAGES_PER_BIO; ++i) {
-			struct page *page;
-			page = old_bio->bi_io_vec[i].bv_page;
-			bio_add_page(bio, page, PAGE_SIZE, 0);
-		}
-		bio_put(old_bio);
 		goto out;
 	}
 	for (i = 0; i < sbio->count; ++i) {
@@ -486,7 +465,6 @@ out:
 	sbio->next_free = sdev->first_free;
 	sdev->first_free = sbio->index;
 	spin_unlock(&sdev->list_lock);
-out_no_enqueue:
 	atomic_dec(&sdev->in_flight);
 	wake_up(&sdev->list_wait);
 }
-- 
1.7.2.5

