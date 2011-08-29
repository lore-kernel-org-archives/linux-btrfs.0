From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 5/6] Btrfs: convert to __bio_endio()
Date: Mon, 29 Aug 2011 12:47:39 +0900
Message-ID: <1314589660-2918-6-git-send-email-namhyung@gmail.com>
References: <1314589660-2918-1-git-send-email-namhyung@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1314589660-2918-1-git-send-email-namhyung@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Use untraced __bio_endio() for nested bio handling path to
suppress duplicated trace event.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: linux-btrfs@vger.kernel.org
---
 fs/btrfs/compression.c |    4 ++--
 fs/btrfs/disk-io.c     |    2 +-
 fs/btrfs/inode.c       |    8 ++++----
 fs/btrfs/volumes.c     |    4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 8ec5d86f1734..864d3ad6dae7 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -197,7 +197,7 @@ csum_failed:
 
 	/* do io completion on the original bio */
 	if (cb->errors) {
-		bio_io_error(cb->orig_bio);
+		__bio_io_error(cb->orig_bio);
 	} else {
 		int bio_index = 0;
 		struct bio_vec *bvec = cb->orig_bio->bi_io_vec;
@@ -211,7 +211,7 @@ csum_failed:
 			bvec++;
 			bio_index++;
 		}
-		bio_endio(cb->orig_bio, 0);
+		__bio_endio(cb->orig_bio, 0);
 	}
 
 	/* finally free the cb struct */
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 07b3ac662e19..64ed856bdde6 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1490,7 +1490,7 @@ static void end_workqueue_fn(struct btrfs_work *work)
 	bio->bi_private = end_io_wq->private;
 	bio->bi_end_io = end_io_wq->end_io;
 	kfree(end_io_wq);
-	bio_endio(bio, error);
+	__bio_endio(bio, error);
 }
 
 static int cleaner_kthread(void *arg)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0ccc7438ad34..c98716474a57 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5893,10 +5893,10 @@ static void btrfs_end_dio_bio(struct bio *bio, int err)
 		goto out;
 
 	if (dip->errors)
-		bio_io_error(dip->orig_bio);
+		__bio_io_error(dip->orig_bio);
 	else {
 		set_bit(BIO_UPTODATE, &dip->orig_bio->bi_flags);
-		bio_endio(dip->orig_bio, 0);
+		__bio_endio(dip->orig_bio, 0);
 	}
 out:
 	bio_put(bio);
@@ -6059,7 +6059,7 @@ out_err:
 	 */
 	smp_mb__before_atomic_dec();
 	if (atomic_dec_and_test(&dip->pending_bios))
-		bio_io_error(dip->orig_bio);
+		__bio_io_error(dip->orig_bio);
 
 	/* bio_end_io() will handle error, so we needn't return it */
 	return 0;
@@ -6133,7 +6133,7 @@ free_ordered:
 		btrfs_put_ordered_extent(ordered);
 		btrfs_put_ordered_extent(ordered);
 	}
-	bio_endio(bio, ret);
+	__bio_endio(bio, ret);
 }
 
 static ssize_t check_direct_IO(struct btrfs_root *root, int rw, struct kiocb *iocb,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f2a4cc79da61..0f745a97805d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3224,7 +3224,7 @@ static void end_bio_multi_stripe(struct bio *bio, int err)
 		}
 		kfree(multi);
 
-		bio_endio(bio, err);
+		__bio_endio(bio, err);
 	} else if (!is_orig_bio) {
 		bio_put(bio);
 	}
@@ -3350,7 +3350,7 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 		} else {
 			bio->bi_bdev = root->fs_info->fs_devices->latest_bdev;
 			bio->bi_sector = logical >> 9;
-			bio_endio(bio, -EIO);
+			__bio_io_error(bio);
 		}
 		dev_nr++;
 	}
-- 
1.7.6
