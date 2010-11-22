From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH -V2 2/3] btrfs: cleanup similar source code
Date: Mon, 22 Nov 2010 11:02:55 +0800
Message-ID: <4CE9DD5F.1000302@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Ito <t-itoh@jp.fujitsu.com>
To: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

extent_bio_alloc() and compressed_bio_alloc() are similar, cleanup
similar source code.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/compression.c |   15 +--------------
 fs/btrfs/extent_io.c   |    8 ++++----
 fs/btrfs/extent_io.h   |    3 +++
 3 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 7845d1f..b50bc4b 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -91,23 +91,10 @@ static inline int compressed_bio_size(struct btrfs_root *root,
 static struct bio *compressed_bio_alloc(struct block_device *bdev,
 					u64 first_byte, gfp_t gfp_flags)
 {
-	struct bio *bio;
 	int nr_vecs;
 
 	nr_vecs = bio_get_nr_vecs(bdev);
-	bio = bio_alloc(gfp_flags, nr_vecs);
-
-	if (bio == NULL && (current->flags & PF_MEMALLOC)) {
-		while (!bio && (nr_vecs /= 2))
-			bio = bio_alloc(gfp_flags, nr_vecs);
-	}
-
-	if (bio) {
-		bio->bi_size = 0;
-		bio->bi_bdev = bdev;
-		bio->bi_sector = first_byte >> 9;
-	}
-	return bio;
+	return btrfs_bio_alloc(bdev, first_byte >> 9, nr_vecs, gfp_flags);
 }
 
 static int check_compressed_csum(struct inode *inode,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index eac10e3..b6543d7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1828,9 +1828,9 @@ static void end_bio_extent_preparewrite(struct bio *bio, int err)
 	bio_put(bio);
 }
 
-static struct bio *
-extent_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
-		 gfp_t gfp_flags)
+struct bio *
+btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
+		gfp_t gfp_flags)
 {
 	struct bio *bio;
 
@@ -1919,7 +1919,7 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 	else
 		nr = bio_get_nr_vecs(bdev);
 
-	bio = extent_bio_alloc(bdev, sector, nr, GFP_NOFS | __GFP_HIGH);
+	bio = btrfs_bio_alloc(bdev, sector, nr, GFP_NOFS | __GFP_HIGH);
 
 	bio_add_page(bio, page, page_size, offset);
 	bio->bi_end_io = end_io_func;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 1c6d4f3..4183c81 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -310,4 +310,7 @@ int extent_clear_unlock_delalloc(struct inode *inode,
 				struct extent_io_tree *tree,
 				u64 start, u64 end, struct page *locked_page,
 				unsigned long op);
+struct bio *
+btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
+		gfp_t gfp_flags);
 #endif
-- 
1.7.0.1
