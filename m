Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10067 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751531AbaF1Ldi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 07:33:38 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5SBXZCE021040
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Jun 2014 19:33:35 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 11/12] Btrfs: implement repair function when direct read fails
Date: Sat, 28 Jun 2014 19:35:01 +0800
Message-ID: <1403955302-22396-12-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
References: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch implement data repair function when direct read fails.

The detail of the implementation is:
- When we find the data is not right, we try to read the data from the other
  mirror.
- After we get right data, we write it back to the corrupted mirror.
- And if the data on the new mirror is still corrupted, we will try next
  mirror until we read right data or all the mirrors are traversed.
- After the above work, we set the uptodate flag according to the result.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/btrfs_inode.h |   2 +-
 fs/btrfs/disk-io.c     |  43 ++++++--
 fs/btrfs/disk-io.h     |   1 +
 fs/btrfs/extent_io.c   |  12 ++-
 fs/btrfs/extent_io.h   |   5 +-
 fs/btrfs/inode.c       | 276 +++++++++++++++++++++++++++++++++++++++++++++----
 6 files changed, 300 insertions(+), 39 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index e82014f..e17c7ae 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -271,7 +271,7 @@ struct btrfs_dio_private {
 	 * The original bio may be splited to several sub-bios, this is
 	 * done during endio of sub-bios
 	 */
-	int (*subio_endio)(struct inode *, struct btrfs_io_bio *);
+	int (*subio_endio)(struct inode *, struct btrfs_io_bio *, int);
 };
 
 /*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8bb4aa1..a55e594 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -690,6 +690,27 @@ static int btree_io_failed_hook(struct page *page, int failed_mirror)
 	return -EIO;	/* we fixed nothing */
 }
 
+static inline void do_end_workqueue_fn(struct end_io_wq *end_io_wq)
+{
+	struct bio *bio = end_io_wq->bio;
+
+	bio->bi_private = end_io_wq->private;
+	bio->bi_end_io = end_io_wq->end_io;
+	bio_endio_nodec(bio, end_io_wq->error);
+	kfree(end_io_wq);
+}
+
+static void dio_end_workqueue_fn(struct work_struct *work)
+{
+	struct btrfs_work *bwork;
+	struct end_io_wq *end_io_wq;
+
+	bwork = container_of(work, struct btrfs_work, normal_work);
+	end_io_wq = container_of(bwork, struct end_io_wq, work);
+
+	do_end_workqueue_fn(end_io_wq);
+}
+
 static void end_workqueue_bio(struct bio *bio, int err)
 {
 	struct end_io_wq *end_io_wq = bio->bi_private;
@@ -697,7 +718,12 @@ static void end_workqueue_bio(struct bio *bio, int err)
 
 	fs_info = end_io_wq->info;
 	end_io_wq->error = err;
-	btrfs_init_work(&end_io_wq->work, end_workqueue_fn, NULL, NULL);
+
+	if (likely(end_io_wq->metadata != BTRFS_WQ_ENDIO_DIO_REPAIR))
+		btrfs_init_work(&end_io_wq->work, end_workqueue_fn, NULL,
+				NULL);
+	else
+		INIT_WORK(&end_io_wq->work.normal_work, dio_end_workqueue_fn);
 
 	if (bio->bi_rw & REQ_WRITE) {
 		if (end_io_wq->metadata == BTRFS_WQ_ENDIO_METADATA)
@@ -713,7 +739,9 @@ static void end_workqueue_bio(struct bio *bio, int err)
 			btrfs_queue_work(fs_info->endio_write_workers,
 					 &end_io_wq->work);
 	} else {
-		if (end_io_wq->metadata == BTRFS_WQ_ENDIO_RAID56)
+		if (unlikely(end_io_wq->metadata == BTRFS_WQ_ENDIO_DIO_REPAIR))
+			queue_work(system_wq, &end_io_wq->work.normal_work);
+		else if (end_io_wq->metadata == BTRFS_WQ_ENDIO_RAID56)
 			btrfs_queue_work(fs_info->endio_raid56_workers,
 					 &end_io_wq->work);
 		else if (end_io_wq->metadata)
@@ -737,6 +765,7 @@ int btrfs_bio_wq_end_io(struct btrfs_fs_info *info, struct bio *bio,
 			int metadata)
 {
 	struct end_io_wq *end_io_wq;
+
 	end_io_wq = kmalloc(sizeof(*end_io_wq), GFP_NOFS);
 	if (!end_io_wq)
 		return -ENOMEM;
@@ -1729,18 +1758,10 @@ static int setup_bdi(struct btrfs_fs_info *info, struct backing_dev_info *bdi)
  */
 static void end_workqueue_fn(struct btrfs_work *work)
 {
-	struct bio *bio;
 	struct end_io_wq *end_io_wq;
-	int error;
 
 	end_io_wq = container_of(work, struct end_io_wq, work);
-	bio = end_io_wq->bio;
-
-	error = end_io_wq->error;
-	bio->bi_private = end_io_wq->private;
-	bio->bi_end_io = end_io_wq->end_io;
-	kfree(end_io_wq);
-	bio_endio_nodec(bio, error);
+	do_end_workqueue_fn(end_io_wq);
 }
 
 static int cleaner_kthread(void *arg)
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 23ce3ce..4fde7a0 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -30,6 +30,7 @@ enum {
 	BTRFS_WQ_ENDIO_METADATA = 1,
 	BTRFS_WQ_ENDIO_FREE_SPACE = 2,
 	BTRFS_WQ_ENDIO_RAID56 = 3,
+	BTRFS_WQ_ENDIO_DIO_REPAIR = 4,
 };
 
 static inline u64 btrfs_sb_offset(int mirror)
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6e30a8c..edbc3b6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1959,7 +1959,7 @@ static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
 		SetPageUptodate(page);
 }
 
-static int free_io_failure(struct inode *inode, struct io_failure_record *rec)
+int free_io_failure(struct inode *inode, struct io_failure_record *rec)
 {
 	int ret;
 	int err = 0;
@@ -2078,8 +2078,8 @@ int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
  * each time an IO finishes, we do a fast check in the IO failure tree
  * to see if we need to process or clean up an io_failure_record
  */
-static int clean_io_failure(struct inode *inode, u64 start,
-			    struct page *page, unsigned int pg_offset)
+int clean_io_failure(struct inode *inode, u64 start, struct page *page,
+		     unsigned int pg_offset)
 {
 	u64 private;
 	u64 private_failure;
@@ -2288,7 +2288,7 @@ int btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
 struct bio *btrfs_create_repair_bio(struct inode *inode, struct bio *failed_bio,
 				    struct io_failure_record *failrec,
 				    struct page *page, int pg_offset, int icsum,
-				    bio_end_io_t *endio_func)
+				    bio_end_io_t *endio_func, void *data)
 {
 	struct bio *bio;
 	struct btrfs_io_bio *btrfs_failed_bio;
@@ -2302,6 +2302,7 @@ struct bio *btrfs_create_repair_bio(struct inode *inode, struct bio *failed_bio,
 	bio->bi_iter.bi_sector = failrec->logical >> 9;
 	bio->bi_bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
 	bio->bi_iter.bi_size = 0;
+	bio->bi_private = data;
 
 	btrfs_failed_bio = btrfs_io_bio(failed_bio);
 	if (btrfs_failed_bio->csum) {
@@ -2359,7 +2360,8 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	phy_offset >>= inode->i_sb->s_blocksize_bits;
 	bio = btrfs_create_repair_bio(inode, failed_bio, failrec, page,
 				      start - page_offset(page),
-				      (int)phy_offset, failed_bio->bi_end_io);
+				      (int)phy_offset, failed_bio->bi_end_io,
+				      NULL);
 	if (!bio) {
 		free_io_failure(inode, failrec);
 		return -EIO;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 7662eaa..b23c7c2 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -344,6 +344,8 @@ struct btrfs_fs_info;
 int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
 		      struct page *page, unsigned int pg_offset,
 		      int mirror_num);
+int clean_io_failure(struct inode *inode, u64 start, struct page *page,
+		     unsigned int pg_offset);
 int end_extent_writepage(struct page *page, int err, u64 start, u64 end);
 int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 			 int mirror_num);
@@ -374,7 +376,8 @@ int btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
 struct bio *btrfs_create_repair_bio(struct inode *inode, struct bio *failed_bio,
 				    struct io_failure_record *failrec,
 				    struct page *page, int pg_offset, int icsum,
-				    bio_end_io_t *endio_func);
+				    bio_end_io_t *endio_func, void *data);
+int free_io_failure(struct inode *inode, struct io_failure_record *rec);
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 noinline u64 find_lock_delalloc_range(struct inode *inode,
 				      struct extent_io_tree *tree,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8e39645..d6b7048 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7083,30 +7083,267 @@ unlock_err:
 	return ret;
 }
 
-static int btrfs_subio_endio_read(struct inode *inode,
-				  struct btrfs_io_bio *io_bio)
+static inline int submit_dio_repair_bio(struct inode *inode, struct bio *bio,
+					int rw, int mirror_num)
+{
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int ret;
+
+	BUG_ON(rw & REQ_WRITE);
+
+	bio_get(bio);
+
+	ret = btrfs_bio_wq_end_io(root->fs_info, bio,
+				  BTRFS_WQ_ENDIO_DIO_REPAIR);
+	if (ret)
+		goto err;
+
+	ret = btrfs_map_bio(root, rw, bio, mirror_num, 0);
+err:
+	bio_put(bio);
+	return ret;
+}
+
+static int btrfs_check_dio_repairable(struct inode *inode,
+				      struct bio *failed_bio,
+				      struct io_failure_record *failrec,
+				      int failed_mirror)
+{
+	int num_copies;
+
+	num_copies = btrfs_num_copies(BTRFS_I(inode)->root->fs_info,
+				      failrec->logical, failrec->len);
+	if (num_copies == 1) {
+		/*
+		 * we only have a single copy of the data, so don't bother with
+		 * all the retry and error correction code that follows. no
+		 * matter what the error is, it is very likely to persist.
+		 */
+		pr_debug("Check DIO Repairable: cannot repair, num_copies=%d, next_mirror %d, failed_mirror %d\n",
+			 num_copies, failrec->this_mirror, failed_mirror);
+		return 0;
+	}
+
+	failrec->failed_mirror = failed_mirror;
+	failrec->this_mirror++;
+	if (failrec->this_mirror == failed_mirror)
+		failrec->this_mirror++;
+
+	if (failrec->this_mirror > num_copies) {
+		pr_debug("Check DIO Repairable: (fail) num_copies=%d, next_mirror %d, failed_mirror %d\n",
+			 num_copies, failrec->this_mirror, failed_mirror);
+		return 0;
+	}
+
+	return 1;
+}
+
+static int dio_read_error(struct inode *inode, struct bio *failed_bio,
+			  struct page *page, u64 start, u64 end,
+			  int failed_mirror, bio_end_io_t *repair_endio,
+			  void *repair_arg)
+{
+	struct io_failure_record *failrec;
+	struct bio *bio;
+	int isector;
+	int read_mode;
+	int ret;
+
+	BUG_ON(failed_bio->bi_rw & REQ_WRITE);
+
+	ret = btrfs_get_io_failure_record(inode, start, end, &failrec);
+	if (ret)
+		return ret;
+
+	ret = btrfs_check_dio_repairable(inode, failed_bio, failrec,
+					 failed_mirror);
+	if (!ret) {
+		free_io_failure(inode, failrec);
+		return -EIO;
+	}
+
+	if (failed_bio->bi_vcnt > 1)
+		read_mode = READ_SYNC | REQ_FAILFAST_DEV;
+	else
+		read_mode = READ_SYNC;
+
+	isector = start - btrfs_io_bio(failed_bio)->logical;
+	isector >>= inode->i_sb->s_blocksize_bits;
+	bio = btrfs_create_repair_bio(inode, failed_bio, failrec, page,
+				      0, isector, repair_endio, repair_arg);
+	if (!bio) {
+		free_io_failure(inode, failrec);
+		return -EIO;
+	}
+
+	btrfs_debug(BTRFS_I(inode)->root->fs_info,
+		    "Repair DIO Read Error: submitting new dio read[%#x] to this_mirror=%d, in_validation=%d\n",
+		    read_mode, failrec->this_mirror, failrec->in_validation);
+
+	ret = submit_dio_repair_bio(inode, bio, read_mode,
+				    failrec->this_mirror);
+	if (ret) {
+		free_io_failure(inode, failrec);
+		bio_put(bio);
+	}
+
+	return ret;
+}
+
+struct btrfs_retry_complete {
+	struct completion done;
+	struct inode *inode;
+	u64 start;
+	int uptodate;
+};
+
+static void btrfs_retry_endio_nocsum(struct bio *bio, int err)
+{
+	struct btrfs_retry_complete *done = bio->bi_private;
+	struct bio_vec *bvec;
+	int i;
+
+	if (err)
+		goto end;
+
+	done->uptodate = 1;
+	bio_for_each_segment_all(bvec, bio, i)
+		clean_io_failure(done->inode, done->start, bvec->bv_page, 0);
+end:
+	complete(&done->done);
+	bio_put(bio);
+}
+
+static int __btrfs_correct_data_nocsum(struct inode *inode,
+				       struct btrfs_io_bio *io_bio)
 {
 	struct bio_vec *bvec;
+	struct btrfs_retry_complete done;
 	u64 start;
 	int i;
 	int ret;
-	int err = 0;
 
-	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
-		return 0;
+	start = io_bio->logical;
+	done.inode = inode;
+
+	bio_for_each_segment_all(bvec, &io_bio->bio, i) {
+try_again:
+		done.uptodate = 0;
+		done.start = start;
+		init_completion(&done.done);
+
+		ret = dio_read_error(inode, &io_bio->bio, bvec->bv_page, start,
+				     start + bvec->bv_len - 1,
+				     io_bio->mirror_num,
+				     btrfs_retry_endio_nocsum, &done);
+		if (ret)
+			return ret;
+
+		wait_for_completion(&done.done);
+
+		if (!done.uptodate) {
+			/* We might have another mirror, so try again */
+			goto try_again;
+		}
+
+		start += bvec->bv_len;
+	}
+
+	return 0;
+}
+
+static void btrfs_retry_endio(struct bio *bio, int err)
+{
+	struct btrfs_retry_complete *done = bio->bi_private;
+	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+	struct bio_vec *bvec;
+	int uptodate;
+	int ret;
+	int i;
+
+	if (err)
+		goto end;
+
+	uptodate = 1;
+	bio_for_each_segment_all(bvec, bio, i) {
+		ret = __readpage_endio_check(done->inode, io_bio, i,
+					     bvec->bv_page, 0,
+					     done->start, bvec->bv_len);
+		if (!ret)
+			clean_io_failure(done->inode, done->start,
+					 bvec->bv_page, 0);
+		else
+			uptodate = 0;
+	}
+
+	done->uptodate = uptodate;
+end:
+	complete(&done->done);
+	bio_put(bio);
+}
 
+static int __btrfs_subio_endio_read(struct inode *inode,
+				    struct btrfs_io_bio *io_bio, int err)
+{
+	struct bio_vec *bvec;
+	struct btrfs_retry_complete done;
+	u64 start;
+	u64 offset = 0;
+	int i;
+	int ret;
+
+	err = 0;
 	start = io_bio->logical;
+	done.inode = inode;
+
 	bio_for_each_segment_all(bvec, &io_bio->bio, i) {
 		ret = __readpage_endio_check(inode, io_bio, i, bvec->bv_page,
 					     0, start, bvec->bv_len);
-		if (ret)
-			err = -EIO;
+		if (likely(!ret))
+			goto next;
+try_again:
+		done.uptodate = 0;
+		done.start = start;
+		init_completion(&done.done);
+
+		ret = dio_read_error(inode, &io_bio->bio, bvec->bv_page, start,
+				     start + bvec->bv_len - 1,
+				     io_bio->mirror_num,
+				     btrfs_retry_endio, &done);
+		if (ret) {
+			err = ret;
+			goto next;
+		}
+
+		wait_for_completion(&done.done);
+
+		if (!done.uptodate) {
+			/* We might have another mirror, so try again */
+			goto try_again;
+		}
+next:
+		offset += bvec->bv_len;
 		start += bvec->bv_len;
 	}
 
 	return err;
 }
 
+static int btrfs_subio_endio_read(struct inode *inode,
+				  struct btrfs_io_bio *io_bio, int err)
+{
+	bool skip_csum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
+
+	if (skip_csum) {
+		if (unlikely(err))
+			return __btrfs_correct_data_nocsum(inode, io_bio);
+		else
+			return 0;
+	} else {
+		return __btrfs_subio_endio_read(inode, io_bio, err);
+	}
+}
+
 static void btrfs_endio_direct_read(struct bio *bio, int err)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
@@ -7114,8 +7351,8 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 	struct bio *dio_bio;
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
 
-	if (!err && (dip->flags & BTRFS_DIO_ORIG_BIO_SUBMITTED))
-		err = btrfs_subio_endio_read(inode, io_bio);
+	if (dip->flags & BTRFS_DIO_ORIG_BIO_SUBMITTED)
+		err = btrfs_subio_endio_read(inode, io_bio, err);
 
 	unlock_extent(&BTRFS_I(inode)->io_tree, dip->logical_offset,
 		      dip->logical_offset + dip->bytes - 1);
@@ -7193,19 +7430,16 @@ static int __btrfs_submit_bio_start_direct_io(struct inode *inode, int rw,
 static void btrfs_end_dio_bio(struct bio *bio, int err)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
-	int ret;
 
-	if (err) {
-		btrfs_err(BTRFS_I(dip->inode)->root->fs_info,
-			  "direct IO failed ino %llu rw %lu sector %#Lx len %u err no %d",
-		      btrfs_ino(dip->inode), bio->bi_rw,
-		      (unsigned long long)bio->bi_iter.bi_sector,
-		      bio->bi_iter.bi_size, err);
-	} else if (dip->subio_endio) {
-		ret = dip->subio_endio(dip->inode, btrfs_io_bio(bio));
-		if (ret)
-			err = ret;
-	}
+	if (err)
+		btrfs_warn(BTRFS_I(dip->inode)->root->fs_info,
+			   "direct IO failed ino %llu rw %lu sector %#Lx len %u err no %d",
+			   btrfs_ino(dip->inode), bio->bi_rw,
+			   (unsigned long long)bio->bi_iter.bi_sector,
+			   bio->bi_iter.bi_size, err);
+
+	if (dip->subio_endio)
+		err = dip->subio_endio(dip->inode, btrfs_io_bio(bio), err);
 
 	if (err) {
 		dip->errors = 1;
-- 
1.9.3

