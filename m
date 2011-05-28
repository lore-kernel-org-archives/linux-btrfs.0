From: Arne Jansen <sensille@gmx.net>
Subject: [PATCH] btrfs: scrub: don't reuse bios and pages
Date: Sat, 28 May 2011 21:57:55 +0200
Message-ID: <1306612675-5459-1-git-send-email-sensille@gmx.net>
To: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The current scrub implementation reuses bios and pages as often as possible,
allocating them only on start and releasing them when finished. This leads
to more problems with the block layer than it's worth. The elevator gets
confused when there are more pages added to the bio than bi_size suggests.
This patch completely rips out the reuse of bios and pages and allocates
them freshly for each submit.

Signed-off-by: Arne Jansen <sensille@gmx.net>
---
 fs/btrfs/scrub.c |  114 +++++++++++++++++++++++++++++++-----------------------
 1 files changed, 65 insertions(+), 49 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 6dfed0c..2d1f890 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -117,33 +117,37 @@ static void scrub_free_csums(struct scrub_dev *sdev)
 	}
 }
 
+static void scrub_free_bio(struct bio *bio)
+{
+	int i;
+	struct page *last_page = NULL;
+
+	if (!bio)
+		return;
+
+	for (i = 0; i < bio->bi_vcnt; ++i) {
+		if (bio->bi_io_vec[i].bv_page == last_page)
+			continue;
+		last_page = bio->bi_io_vec[i].bv_page;
+		__free_page(last_page);
+	}
+	bio_put(bio);
+}
+
 static noinline_for_stack void scrub_free_dev(struct scrub_dev *sdev)
 {
 	int i;
-	int j;
-	struct page *last_page;
 
 	if (!sdev)
 		return;
 
 	for (i = 0; i < SCRUB_BIOS_PER_DEV; ++i) {
 		struct scrub_bio *sbio = sdev->bios[i];
-		struct bio *bio;
 
 		if (!sbio)
 			break;
 
-		bio = sbio->bio;
-		if (bio) {
-			last_page = NULL;
-			for (j = 0; j < bio->bi_vcnt; ++j) {
-				if (bio->bi_io_vec[j].bv_page == last_page)
-					continue;
-				last_page = bio->bi_io_vec[j].bv_page;
-				__free_page(last_page);
-			}
-			bio_put(bio);
-		}
+		scrub_free_bio(sbio->bio);
 		kfree(sbio);
 	}
 
@@ -156,8 +160,6 @@ struct scrub_dev *scrub_setup_dev(struct btrfs_device *dev)
 {
 	struct scrub_dev *sdev;
 	int		i;
-	int		j;
-	int		ret;
 	struct btrfs_fs_info *fs_info = dev->dev_root->fs_info;
 
 	sdev = kzalloc(sizeof(*sdev), GFP_NOFS);
@@ -165,7 +167,6 @@ struct scrub_dev *scrub_setup_dev(struct btrfs_device *dev)
 		goto nomem;
 	sdev->dev = dev;
 	for (i = 0; i < SCRUB_BIOS_PER_DEV; ++i) {
-		struct bio *bio;
 		struct scrub_bio *sbio;
 
 		sbio = kzalloc(sizeof(*sbio), GFP_NOFS);
@@ -173,32 +174,10 @@ struct scrub_dev *scrub_setup_dev(struct btrfs_device *dev)
 			goto nomem;
 		sdev->bios[i] = sbio;
 
-		bio = bio_kmalloc(GFP_NOFS, SCRUB_PAGES_PER_BIO);
-		if (!bio)
-			goto nomem;
-
 		sbio->index = i;
 		sbio->sdev = sdev;
-		sbio->bio = bio;
 		sbio->count = 0;
 		sbio->work.func = scrub_checksum;
-		bio->bi_private = sdev->bios[i];
-		bio->bi_end_io = scrub_bio_end_io;
-		bio->bi_sector = 0;
-		bio->bi_bdev = dev->bdev;
-		bio->bi_size = 0;
-
-		for (j = 0; j < SCRUB_PAGES_PER_BIO; ++j) {
-			struct page *page;
-			page = alloc_page(GFP_NOFS);
-			if (!page)
-				goto nomem;
-
-			ret = bio_add_page(bio, page, PAGE_SIZE, 0);
-			if (!ret)
-				goto nomem;
-		}
-		WARN_ON(bio->bi_vcnt != SCRUB_PAGES_PER_BIO);
 
 		if (i != SCRUB_BIOS_PER_DEV-1)
 			sdev->bios[i]->next_free = i + 1;
@@ -394,6 +373,7 @@ static void scrub_bio_end_io(struct bio *bio, int err)
 	struct btrfs_fs_info *fs_info = sdev->dev->dev_root->fs_info;
 
 	sbio->err = err;
+	sbio->bio = bio;
 
 	btrfs_queue_worker(&fs_info->scrub_workers, &sbio->work);
 }
@@ -453,6 +433,8 @@ static void scrub_checksum(struct btrfs_work *work)
 	}
 
 out:
+	scrub_free_bio(sbio->bio);
+	sbio->bio = NULL;
 	spin_lock(&sdev->list_lock);
 	sbio->next_free = sdev->first_free;
 	sdev->first_free = sbio->index;
@@ -583,25 +565,50 @@ static int scrub_checksum_super(struct scrub_bio *sbio, void *buffer)
 static int scrub_submit(struct scrub_dev *sdev)
 {
 	struct scrub_bio *sbio;
+	struct bio *bio;
+	int i;
 
 	if (sdev->curr == -1)
 		return 0;
 
 	sbio = sdev->bios[sdev->curr];
 
-	sbio->bio->bi_sector = sbio->physical >> 9;
-	sbio->bio->bi_size = sbio->count * PAGE_SIZE;
-	sbio->bio->bi_next = NULL;
-	sbio->bio->bi_flags |= 1 << BIO_UPTODATE;
-	sbio->bio->bi_comp_cpu = -1;
-	sbio->bio->bi_bdev = sdev->dev->bdev;
+	bio = bio_alloc(GFP_NOFS, sbio->count);
+	if (!bio)
+		goto nomem;
+
+	bio->bi_private = sbio;
+	bio->bi_end_io = scrub_bio_end_io;
+	bio->bi_bdev = sdev->dev->bdev;
+	bio->bi_sector = sbio->physical >> 9;
+
+	for (i = 0; i < sbio->count; ++i) {
+		struct page *page;
+		int ret;
+
+		page = alloc_page(GFP_NOFS);
+		if (!page)
+			goto nomem;
+
+		ret = bio_add_page(bio, page, PAGE_SIZE, 0);
+		if (!ret) {
+			__free_page(page);
+			goto nomem;
+		}
+	}
+
 	sbio->err = 0;
 	sdev->curr = -1;
 	atomic_inc(&sdev->in_flight);
 
-	submit_bio(0, sbio->bio);
+	submit_bio(READ, bio);
 
 	return 0;
+
+nomem:
+	scrub_free_bio(bio);
+
+	return -ENOMEM;
 }
 
 static int scrub_page(struct scrub_dev *sdev, u64 logical, u64 len,
@@ -633,7 +640,11 @@ again:
 		sbio->logical = logical;
 	} else if (sbio->physical + sbio->count * PAGE_SIZE != physical ||
 		   sbio->logical + sbio->count * PAGE_SIZE != logical) {
-		scrub_submit(sdev);
+		int ret;
+
+		ret = scrub_submit(sdev);
+		if (ret)
+			return ret;
 		goto again;
 	}
 	sbio->spag[sbio->count].flags = flags;
@@ -645,8 +656,13 @@ again:
 		memcpy(sbio->spag[sbio->count].csum, csum, sdev->csum_size);
 	}
 	++sbio->count;
-	if (sbio->count == SCRUB_PAGES_PER_BIO || force)
-		scrub_submit(sdev);
+	if (sbio->count == SCRUB_PAGES_PER_BIO || force) {
+		int ret;
+
+		ret = scrub_submit(sdev);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
-- 
1.7.3.4

