From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH 2/3] Btrfs: minor cleanup in scrub
Date: Fri, 23 Mar 2012 15:59:09 +0100
Message-ID: <d6338f53073c521fb50f717d9f7676fbb6bdc61a.1332513438.git.sbehrens@giantdisaster.de>
References: <cover.1332513438.git.sbehrens@giantdisaster.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <cover.1332513438.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1332513438.git.sbehrens@giantdisaster.de>
List-ID: <linux-btrfs.vger.kernel.org>

Just a minor cleanup commit in preparation for the big block changes.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 fs/btrfs/scrub.c |   61 ++++++++++++++++++++++-------------------------------
 1 files changed, 25 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index abc0fbf..e68bab4 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -36,28 +36,11 @@
  * Future enhancements:
  *  - In case an unrepairable extent is encountered, track which files are
  *    affected and report them
- *  - In case of a read error on files with nodatasum, map the file and read
- *    the extent to trigger a writeback of the good copy
  *  - track and record media errors, throw out bad devices
  *  - add a mode to also read unallocated space
  */
 
-struct scrub_bio;
-struct scrub_page;
 struct scrub_dev;
-static void scrub_bio_end_io(struct bio *bio, int err);
-static void scrub_checksum(struct btrfs_work *work);
-static int scrub_checksum_data(struct scrub_dev *sdev,
-			       struct scrub_page *spag, void *buffer);
-static int scrub_checksum_tree_block(struct scrub_dev *sdev,
-				     struct scrub_page *spag, u64 logical,
-				     void *buffer);
-static int scrub_checksum_super(struct scrub_bio *sbio, void *buffer);
-static int scrub_fixup_check(struct scrub_bio *sbio, int ix);
-static void scrub_fixup_end_io(struct bio *bio, int err);
-static int scrub_fixup_io(int rw, struct block_device *bdev, sector_t sector,
-			  struct page *page);
-static void scrub_fixup(struct scrub_bio *sbio, int ix);
 
 #define SCRUB_PAGES_PER_BIO	16	/* 64k per bio */
 #define SCRUB_BIOS_PER_DEV	16	/* 1 MB per device in flight */
@@ -124,6 +107,21 @@ struct scrub_warning {
 	int			scratch_bufsize;
 };
 
+static void scrub_bio_end_io(struct bio *bio, int err);
+static void scrub_checksum(struct btrfs_work *work);
+static int scrub_checksum_data(struct scrub_dev *sdev,
+			       struct scrub_page *spag, void *buffer);
+static int scrub_checksum_tree_block(struct scrub_dev *sdev,
+				     struct scrub_page *spag, u64 logical,
+				     void *buffer);
+static int scrub_checksum_super(struct scrub_bio *sbio, void *buffer);
+static int scrub_fixup_check(struct scrub_bio *sbio, int ix);
+static void scrub_fixup_end_io(struct bio *bio, int err);
+static int scrub_fixup_io(int rw, struct block_device *bdev, sector_t sector,
+			  struct page *page);
+static void scrub_fixup(struct scrub_bio *sbio, int ix);
+
+
 static void scrub_free_csums(struct scrub_dev *sdev)
 {
 	while (!list_empty(&sdev->csum_list)) {
@@ -342,7 +340,8 @@ static void scrub_print_warning(const char *errstr, struct scrub_bio *sbio,
 		do {
 			ret = tree_backref_for_extent(&ptr, eb, ei, item_size,
 							&ref_root, &ref_level);
-			printk(KERN_WARNING "%s at logical %llu on dev %s, "
+			printk(KERN_WARNING
+				"btrfs: %s at logical %llu on dev %s, "
 				"sector %llu: metadata %s (level %d) in tree "
 				"%llu\n", errstr, swarn.logical, dev->name,
 				(unsigned long long)swarn.sector,
@@ -948,12 +947,12 @@ static int scrub_checksum_super(struct scrub_bio *sbio, void *buffer)
 	return fail;
 }
 
-static int scrub_submit(struct scrub_dev *sdev)
+static void scrub_submit(struct scrub_dev *sdev)
 {
 	struct scrub_bio *sbio;
 
 	if (sdev->curr == -1)
-		return 0;
+		return;
 
 	sbio = sdev->bios[sdev->curr];
 	sbio->err = 0;
@@ -961,8 +960,6 @@ static int scrub_submit(struct scrub_dev *sdev)
 	atomic_inc(&sdev->in_flight);
 
 	btrfsic_submit_bio(READ, sbio->bio);
-
-	return 0;
 }
 
 static int scrub_page(struct scrub_dev *sdev, u64 logical, u64 len,
@@ -1008,9 +1005,7 @@ again:
 		sbio->bio = bio;
 	} else if (sbio->physical + sbio->count * PAGE_SIZE != physical ||
 		   sbio->logical + sbio->count * PAGE_SIZE != logical) {
-		ret = scrub_submit(sdev);
-		if (ret)
-			return ret;
+		scrub_submit(sdev);
 		goto again;
 	}
 	sbio->spag[sbio->count].flags = flags;
@@ -1025,9 +1020,7 @@ again:
 	ret = bio_add_page(sbio->bio, page, PAGE_SIZE, 0);
 	if (!ret) {
 		__free_page(page);
-		ret = scrub_submit(sdev);
-		if (ret)
-			return ret;
+		scrub_submit(sdev);
 		goto again;
 	}
 
@@ -1036,13 +1029,8 @@ again:
 		memcpy(sbio->spag[sbio->count].csum, csum, sdev->csum_size);
 	}
 	++sbio->count;
-	if (sbio->count == SCRUB_PAGES_PER_BIO || force) {
-		int ret;
-
-		ret = scrub_submit(sdev);
-		if (ret)
-			return ret;
-	}
+	if (sbio->count == SCRUB_PAGES_PER_BIO || force)
+		scrub_submit(sdev);
 
 	return 0;
 }
@@ -1520,7 +1508,7 @@ static noinline_for_stack int scrub_supers(struct scrub_dev *sdev)
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-		if (bytenr + BTRFS_SUPER_INFO_SIZE >= device->total_bytes)
+		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->total_bytes)
 			break;
 
 		ret = scrub_page(sdev, bytenr, PAGE_SIZE, bytenr,
@@ -1741,6 +1729,7 @@ int btrfs_scrub_cancel_dev(struct btrfs_root *root, struct btrfs_device *dev)
 
 	return 0;
 }
+
 int btrfs_scrub_cancel_devid(struct btrfs_root *root, u64 devid)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
-- 
1.7.3.4

