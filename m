Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33094 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753429AbdFLPao (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Jun 2017 11:30:44 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, bo.li.liu@oracle.com
Subject: [PATCH 2/3] btrfs: add helper to initialize the non-bio part of btrfs_io_bio
Date: Mon, 12 Jun 2017 17:29:39 +0200
Message-Id: <001926c9d36fa5fb42b829ed8ba28d711cee4ae0.1497281195.git.dsterba@suse.com>
In-Reply-To: <cover.1497281195.git.dsterba@suse.com>
References: <cover.1497281195.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We use btrfs_bioset for bios and ask to allocate the entire size of
btrfs_io_bio from btrfs bio_alloc_bioset. The member 'bio' is
initialized but the bytes from 0 to offset of 'bio' are left
uninitialized. Although we initialize some of the members in our
helpers, we should initialize the whole structures.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5037fd918f43..cbd0a9a1daa5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2654,22 +2654,28 @@ static void end_bio_extent_readpage(struct bio *bio)
 }
 
 /*
+ * Initialize the members up to but not including 'bio'. Use after allocating a
+ * new bio by bio_alloc_bioset as it does not initialize the bytes outside of
+ * 'bio' because use of __GFP_ZERO is not supported.
+ */
+static inline void btrfs_io_bio_init(struct btrfs_io_bio *btrfs_bio)
+{
+	memset(btrfs_bio, 0, offsetof(struct btrfs_io_bio, bio));
+}
+
+/*
  * The following helpers allocate a bio. As it's backed by a bioset, it'll
  * never fail.  We're returning a bio right now but you can call btrfs_io_bio
  * for the appropriate container_of magic
  */
 struct bio *btrfs_bio_alloc(struct block_device *bdev, u64 first_byte)
 {
-	struct btrfs_io_bio *btrfs_bio;
 	struct bio *bio;
 
 	bio = bio_alloc_bioset(GFP_NOFS, BIO_MAX_PAGES, btrfs_bioset);
 	bio->bi_bdev = bdev;
 	bio->bi_iter.bi_sector = first_byte >> 9;
-	btrfs_bio = btrfs_io_bio(bio);
-	btrfs_bio->csum = NULL;
-	btrfs_bio->csum_allocated = NULL;
-	btrfs_bio->end_io = NULL;
+	btrfs_io_bio_init(btrfs_io_bio(bio));
 	return bio;
 }
 
@@ -2681,24 +2687,18 @@ struct bio *btrfs_bio_clone(struct bio *bio)
 	/* Bio allocation backed by a bioset does not fail */
 	new = bio_clone_fast(bio, GFP_NOFS, btrfs_bioset);
 	btrfs_bio = btrfs_io_bio(new);
-	btrfs_bio->csum = NULL;
-	btrfs_bio->csum_allocated = NULL;
-	btrfs_bio->end_io = NULL;
+	btrfs_io_bio_init(btrfs_bio);
 	btrfs_bio->iter = bio->bi_iter;
 	return new;
 }
 
 struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 {
-	struct btrfs_io_bio *btrfs_bio;
 	struct bio *bio;
 
 	/* Bio allocation backed by a bioset does not fail */
 	bio = bio_alloc_bioset(gfp_mask, nr_iovecs, btrfs_bioset);
-	btrfs_bio = btrfs_io_bio(bio);
-	btrfs_bio->csum = NULL;
-	btrfs_bio->csum_allocated = NULL;
-	btrfs_bio->end_io = NULL;
+	btrfs_io_bio_init(btrfs_io_bio(bio));
 	return bio;
 }
 
@@ -2712,9 +2712,7 @@ struct bio *btrfs_bio_clone_partial(struct bio *orig, int offset, int size)
 	ASSERT(bio);
 
 	btrfs_bio = btrfs_io_bio(bio);
-	btrfs_bio->csum = NULL;
-	btrfs_bio->csum_allocated = NULL;
-	btrfs_bio->end_io = NULL;
+	btrfs_io_bio_init(btrfs_bio);
 
 	bio_trim(bio, offset >> 9, size >> 9);
 	btrfs_bio->iter = bio->bi_iter;
-- 
2.13.0

