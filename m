From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [patch]btrfs: finish read pages in the order they are submitted
Date: Wed, 3 Feb 2010 13:18:45 -0500
Message-ID: <20100203181845.GE22119@think>
References: <20100203074511.GA26548@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, jens.axboe@oracle.com
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100203074511.GA26548@sli10-desk.sh.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 03, 2010 at 03:45:11PM +0800, Shaohua Li wrote:
> the endio is done at reverse order of bio vectors. That means for a sequential
> read, the page first submitted will finish last in a bio. Considering we will
> do checksum (making cache hot) for every page, this does introduce delay (and
> chance to squeeze cache used soon) for pages submitted at the begining. I
> don't observe obvious performance difference with below patch at my simple test,
> but seems more natural to finish read in the order they are submitted.

Interesting, I wonder if we'd be able to see this on a higher throughput
system.  Jens, care to give it a shot (patch below)?

-chris


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
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
