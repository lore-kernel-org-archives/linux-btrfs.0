From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Subject: [PATCH] Btrfs: check return value of bio_alloc() properly
Date: Thu, 12 Apr 2012 13:47:07 +0900
Message-ID: <201204120447.AA00000@FM-323941448.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

bio_alloc() has the possibility of returning NULL.
So, it is necessary to check the return value.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/compression.c |    2 ++
 fs/btrfs/extent_io.c   |    4 ++++
 fs/btrfs/scrub.c       |    4 ++++
 3 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index d11afa67..646f5e6 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -405,6 +405,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 			bio_put(bio);
 
 			bio = compressed_bio_alloc(bdev, first_byte, GFP_NOFS);
+			BUG_ON(!bio);
 			bio->bi_private = cb;
 			bio->bi_end_io = end_compressed_bio_write;
 			bio_add_page(bio, page, PAGE_CACHE_SIZE, 0);
@@ -687,6 +688,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 
 			comp_bio = compressed_bio_alloc(bdev, cur_disk_byte,
 							GFP_NOFS);
+			BUG_ON(!comp_bio);
 			comp_bio->bi_private = cb;
 			comp_bio->bi_end_io = end_compressed_bio_read;
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0c3ec00..f5d4e2c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2180,6 +2180,10 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
 	}
 
 	bio = bio_alloc(GFP_NOFS, 1);
+	if (!bio) {
+		free_io_failure(inode, failrec, 0);
+		return -EIO;
+	}
 	bio->bi_private = state;
 	bio->bi_end_io = failed_bio->bi_end_io;
 	bio->bi_sector = failrec->logical >> 9;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index c9a2c1a..60f0e28 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1044,6 +1044,8 @@ static int scrub_recheck_block(struct btrfs_fs_info *fs_info,
 
 		BUG_ON(!page->page);
 		bio = bio_alloc(GFP_NOFS, 1);
+		if (!bio)
+			return -EIO;
 		bio->bi_bdev = page->bdev;
 		bio->bi_sector = page->physical >> 9;
 		bio->bi_end_io = scrub_complete_bio_end_io;
@@ -1172,6 +1174,8 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 		DECLARE_COMPLETION_ONSTACK(complete);
 
 		bio = bio_alloc(GFP_NOFS, 1);
+		if (!bio)
+			return -EIO;
 		bio->bi_bdev = page_bad->bdev;
 		bio->bi_sector = page_bad->physical >> 9;
 		bio->bi_end_io = scrub_complete_bio_end_io;

----
Tsutomu Itoh  t-itoh@jp.fujitsu.com

