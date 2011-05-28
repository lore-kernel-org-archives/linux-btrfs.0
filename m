From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs: scrub: add explicit plugging
Date: Sat, 28 May 2011 22:58:38 +0200
Message-ID: <1306616318-16126-1-git-send-email-sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

With the removal of the implicit plugging scrub ends up doing more and
smaller I/O than necessary. This patch adds explicit plugging per chunk.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/scrub.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 2d1f890..1204eab 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -348,9 +348,6 @@ static int scrub_fixup_io(int rw, struct block_device *bdev, sector_t sector,
 	int ret;
 	DECLARE_COMPLETION_ONSTACK(complete);
 
-	/* we are going to wait on this IO */
-	rw |= REQ_SYNC;
-
 	bio = bio_alloc(GFP_NOFS, 1);
 	bio->bi_bdev = bdev;
 	bio->bi_sector = sector;
@@ -359,6 +356,7 @@ static int scrub_fixup_io(int rw, struct block_device *bdev, sector_t sector,
 	bio->bi_private = &complete;
 	submit_bio(rw, bio);
 
+	/* this will also unplug the queue */
 	wait_for_completion(&complete);
 
 	ret = !test_bit(BIO_UPTODATE, &bio->bi_flags);
@@ -743,6 +741,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
 	struct btrfs_root *root = fs_info->extent_root;
 	struct btrfs_root *csum_root = fs_info->csum_root;
 	struct btrfs_extent_item *extent;
+	struct blk_plug plug;
 	u64 flags;
 	int ret;
 	int slot;
@@ -847,6 +846,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_dev *sdev,
 	 * the scrub. This might currently (crc32) end up to be about 1MB
 	 */
 	start_stripe = 0;
+	blk_start_plug(&plug);
 again:
 	logical = base + offset + start_stripe * increment;
 	for (i = start_stripe; i < nstripes; ++i) {
@@ -988,6 +988,7 @@ next:
 	scrub_submit(sdev);
 
 out:
+	blk_finish_plug(&plug);
 	btrfs_free_path(path);
 	return ret < 0 ? ret : 0;
 }
-- 
1.7.3.4

