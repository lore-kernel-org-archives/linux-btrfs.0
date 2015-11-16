Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:49487 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbbKPHGl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 02:06:41 -0500
Received: from localhost
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 16 Nov 2015 17:06:38 +1000
Received: from d23relay09.au.ibm.com (d23relay09.au.ibm.com [9.185.63.181])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 79F2C357804F
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 18:06:35 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay09.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tAG76R0b27131970
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 18:06:35 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tAG761A5029763
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 18:06:03 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V9 03/12] Btrfs: Direct I/O read: Work on sectorsized blocks
Date: Mon, 16 Nov 2015 12:35:23 +0530
Message-Id: <1447657532-9393-4-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1447657532-9393-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1447657532-9393-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The direct I/O read's endio and corresponding repair functions work on
page sized blocks. This commit adds the ability for direct I/O read to work on
subpagesized blocks.

Reviewed-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c | 98 +++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 75 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4439fbb..b73491d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7760,9 +7760,9 @@ static int btrfs_check_dio_repairable(struct inode *inode,
 }
 
 static int dio_read_error(struct inode *inode, struct bio *failed_bio,
-			  struct page *page, u64 start, u64 end,
-			  int failed_mirror, bio_end_io_t *repair_endio,
-			  void *repair_arg)
+			struct page *page, unsigned int pgoff,
+			u64 start, u64 end, int failed_mirror,
+			bio_end_io_t *repair_endio, void *repair_arg)
 {
 	struct io_failure_record *failrec;
 	struct bio *bio;
@@ -7783,7 +7783,9 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 		return -EIO;
 	}
 
-	if (failed_bio->bi_vcnt > 1)
+	if ((failed_bio->bi_vcnt > 1)
+		|| (failed_bio->bi_io_vec->bv_len
+			> BTRFS_I(inode)->root->sectorsize))
 		read_mode = READ_SYNC | REQ_FAILFAST_DEV;
 	else
 		read_mode = READ_SYNC;
@@ -7791,7 +7793,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 	isector = start - btrfs_io_bio(failed_bio)->logical;
 	isector >>= inode->i_sb->s_blocksize_bits;
 	bio = btrfs_create_repair_bio(inode, failed_bio, failrec, page,
-				      0, isector, repair_endio, repair_arg);
+				pgoff, isector, repair_endio, repair_arg);
 	if (!bio) {
 		free_io_failure(inode, failrec);
 		return -EIO;
@@ -7821,12 +7823,17 @@ struct btrfs_retry_complete {
 static void btrfs_retry_endio_nocsum(struct bio *bio)
 {
 	struct btrfs_retry_complete *done = bio->bi_private;
+	struct inode *inode;
 	struct bio_vec *bvec;
 	int i;
 
 	if (bio->bi_error)
 		goto end;
 
+	ASSERT(bio->bi_vcnt == 1);
+	inode = bio->bi_io_vec->bv_page->mapping->host;
+	ASSERT(bio->bi_io_vec->bv_len == BTRFS_I(inode)->root->sectorsize);
+
 	done->uptodate = 1;
 	bio_for_each_segment_all(bvec, bio, i)
 		clean_io_failure(done->inode, done->start, bvec->bv_page, 0);
@@ -7838,25 +7845,35 @@ end:
 static int __btrfs_correct_data_nocsum(struct inode *inode,
 				       struct btrfs_io_bio *io_bio)
 {
+	struct btrfs_fs_info *fs_info;
 	struct bio_vec *bvec;
 	struct btrfs_retry_complete done;
 	u64 start;
+	unsigned int pgoff;
+	u32 sectorsize;
+	int nr_sectors;
 	int i;
 	int ret;
 
+	fs_info = BTRFS_I(inode)->root->fs_info;
+	sectorsize = BTRFS_I(inode)->root->sectorsize;
+
 	start = io_bio->logical;
 	done.inode = inode;
 
 	bio_for_each_segment_all(bvec, &io_bio->bio, i) {
-try_again:
+		nr_sectors = BTRFS_BYTES_TO_BLKS(fs_info, bvec->bv_len);
+		pgoff = bvec->bv_offset;
+
+next_block_or_try_again:
 		done.uptodate = 0;
 		done.start = start;
 		init_completion(&done.done);
 
-		ret = dio_read_error(inode, &io_bio->bio, bvec->bv_page, start,
-				     start + bvec->bv_len - 1,
-				     io_bio->mirror_num,
-				     btrfs_retry_endio_nocsum, &done);
+		ret = dio_read_error(inode, &io_bio->bio, bvec->bv_page,
+				pgoff, start, start + sectorsize - 1,
+				io_bio->mirror_num,
+				btrfs_retry_endio_nocsum, &done);
 		if (ret)
 			return ret;
 
@@ -7864,10 +7881,15 @@ try_again:
 
 		if (!done.uptodate) {
 			/* We might have another mirror, so try again */
-			goto try_again;
+			goto next_block_or_try_again;
 		}
 
-		start += bvec->bv_len;
+		start += sectorsize;
+
+		if (nr_sectors--) {
+			pgoff += sectorsize;
+			goto next_block_or_try_again;
+		}
 	}
 
 	return 0;
@@ -7877,7 +7899,9 @@ static void btrfs_retry_endio(struct bio *bio)
 {
 	struct btrfs_retry_complete *done = bio->bi_private;
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+	struct inode *inode;
 	struct bio_vec *bvec;
+	u64 start;
 	int uptodate;
 	int ret;
 	int i;
@@ -7886,13 +7910,20 @@ static void btrfs_retry_endio(struct bio *bio)
 		goto end;
 
 	uptodate = 1;
+
+	start = done->start;
+
+	ASSERT(bio->bi_vcnt == 1);
+	inode = bio->bi_io_vec->bv_page->mapping->host;
+	ASSERT(bio->bi_io_vec->bv_len == BTRFS_I(inode)->root->sectorsize);
+
 	bio_for_each_segment_all(bvec, bio, i) {
 		ret = __readpage_endio_check(done->inode, io_bio, i,
-					     bvec->bv_page, 0,
-					     done->start, bvec->bv_len);
+					bvec->bv_page, bvec->bv_offset,
+					done->start, bvec->bv_len);
 		if (!ret)
 			clean_io_failure(done->inode, done->start,
-					 bvec->bv_page, 0);
+					bvec->bv_page, bvec->bv_offset);
 		else
 			uptodate = 0;
 	}
@@ -7906,20 +7937,34 @@ end:
 static int __btrfs_subio_endio_read(struct inode *inode,
 				    struct btrfs_io_bio *io_bio, int err)
 {
+	struct btrfs_fs_info *fs_info;
 	struct bio_vec *bvec;
 	struct btrfs_retry_complete done;
 	u64 start;
 	u64 offset = 0;
+	u32 sectorsize;
+	int nr_sectors;
+	unsigned int pgoff;
+	int csum_pos;
 	int i;
 	int ret;
 
+	fs_info = BTRFS_I(inode)->root->fs_info;
+	sectorsize = BTRFS_I(inode)->root->sectorsize;
+
 	err = 0;
 	start = io_bio->logical;
 	done.inode = inode;
 
 	bio_for_each_segment_all(bvec, &io_bio->bio, i) {
-		ret = __readpage_endio_check(inode, io_bio, i, bvec->bv_page,
-					     0, start, bvec->bv_len);
+		nr_sectors = BTRFS_BYTES_TO_BLKS(fs_info, bvec->bv_len);
+
+		pgoff = bvec->bv_offset;
+next_block:
+		csum_pos = BTRFS_BYTES_TO_BLKS(fs_info, offset);
+		ret = __readpage_endio_check(inode, io_bio, csum_pos,
+					bvec->bv_page, pgoff, start,
+					sectorsize);
 		if (likely(!ret))
 			goto next;
 try_again:
@@ -7927,10 +7972,10 @@ try_again:
 		done.start = start;
 		init_completion(&done.done);
 
-		ret = dio_read_error(inode, &io_bio->bio, bvec->bv_page, start,
-				     start + bvec->bv_len - 1,
-				     io_bio->mirror_num,
-				     btrfs_retry_endio, &done);
+		ret = dio_read_error(inode, &io_bio->bio, bvec->bv_page,
+				pgoff, start, start + sectorsize - 1,
+				io_bio->mirror_num,
+				btrfs_retry_endio, &done);
 		if (ret) {
 			err = ret;
 			goto next;
@@ -7943,8 +7988,15 @@ try_again:
 			goto try_again;
 		}
 next:
-		offset += bvec->bv_len;
-		start += bvec->bv_len;
+		offset += sectorsize;
+		start += sectorsize;
+
+		ASSERT(nr_sectors);
+
+		if (--nr_sectors) {
+			pgoff += sectorsize;
+			goto next_block;
+		}
 	}
 
 	return err;
-- 
2.1.0

