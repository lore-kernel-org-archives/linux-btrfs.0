Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:52279 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbbJ0JlU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 05:41:20 -0400
Received: from /spool/local
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 27 Oct 2015 19:41:18 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id AB4F43578054
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 20:41:15 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9R9f9hn31260698
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 20:41:17 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9R9egUV018743
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 20:40:43 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, clm@fb.com, jbacik@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, quwenruo@cn.fujitsu.com,
        chandan@mykolab.com
Subject: [PATCH V7 03/13] Btrfs: Direct I/O read: Work on sectorsized blocks
Date: Tue, 27 Oct 2015 15:09:36 +0530
Message-Id: <1445938786-12488-4-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1445938786-12488-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1445938786-12488-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The direct I/O read's endio and corresponding repair functions work on
page sized blocks. This commit adds the ability for direct I/O read to work on
subpagesized blocks.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c | 98 +++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 75 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a018e47..98d901e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7764,9 +7764,9 @@ static int btrfs_check_dio_repairable(struct inode *inode,
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
@@ -7787,7 +7787,9 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 		return -EIO;
 	}
 
-	if (failed_bio->bi_vcnt > 1)
+	if ((failed_bio->bi_vcnt > 1)
+		|| (failed_bio->bi_io_vec->bv_len
+			> BTRFS_I(inode)->root->sectorsize))
 		read_mode = READ_SYNC | REQ_FAILFAST_DEV;
 	else
 		read_mode = READ_SYNC;
@@ -7795,7 +7797,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 	isector = start - btrfs_io_bio(failed_bio)->logical;
 	isector >>= inode->i_sb->s_blocksize_bits;
 	bio = btrfs_create_repair_bio(inode, failed_bio, failrec, page,
-				      0, isector, repair_endio, repair_arg);
+				pgoff, isector, repair_endio, repair_arg);
 	if (!bio) {
 		free_io_failure(inode, failrec);
 		return -EIO;
@@ -7825,12 +7827,17 @@ struct btrfs_retry_complete {
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
@@ -7842,25 +7849,35 @@ end:
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
 
@@ -7868,10 +7885,15 @@ try_again:
 
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
@@ -7881,7 +7903,9 @@ static void btrfs_retry_endio(struct bio *bio)
 {
 	struct btrfs_retry_complete *done = bio->bi_private;
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+	struct inode *inode;
 	struct bio_vec *bvec;
+	u64 start;
 	int uptodate;
 	int ret;
 	int i;
@@ -7890,13 +7914,20 @@ static void btrfs_retry_endio(struct bio *bio)
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
@@ -7910,20 +7941,34 @@ end:
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
@@ -7931,10 +7976,10 @@ try_again:
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
@@ -7947,8 +7992,15 @@ try_again:
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

