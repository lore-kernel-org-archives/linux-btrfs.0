From: Shaohua Li <shaohua.li@intel.com>
Subject: [patch]btrfs: finish read pages in the order they are submitted
Date: Wed, 3 Feb 2010 15:45:11 +0800
Message-ID: <20100203074511.GA26548@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

the endio is done at reverse order of bio vectors. That means for a sequential
read, the page first submitted will finish last in a bio. Considering we will
do checksum (making cache hot) for every page, this does introduce delay (and
chance to squeeze cache used soon) for pages submitted at the begining. I
don't observe obvious performance difference with below patch at my simple test,
but seems more natural to finish read in the order they are submitted.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 96577e8..4df0c56 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1750,7 +1750,8 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 static void end_bio_extent_readpage(struct bio *bio, int err)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
+	struct bio_vec *bvec_end = bio->bi_io_vec + bio->bi_vcnt - 1;
+	struct bio_vec *bvec = bio->bi_io_vec;
 	struct extent_io_tree *tree;
 	u64 start;
 	u64 end;
@@ -1773,7 +1774,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 		else
 			whole_page = 0;
 
-		if (--bvec >= bio->bi_io_vec)
+		if (++bvec <= bvec_end)
 			prefetchw(&bvec->bv_page->flags);
 
 		if (uptodate && tree->ops && tree->ops->readpage_end_io_hook) {
@@ -1818,7 +1819,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 			}
 			check_page_locked(tree, page);
 		}
-	} while (bvec >= bio->bi_io_vec);
+	} while (bvec <= bvec_end);
 
 	bio_put(bio);
 }
