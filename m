Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42638 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932780AbcIBTln (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Sep 2016 15:41:43 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u82JZAQn010579
        for <linux-btrfs@vger.kernel.org>; Fri, 2 Sep 2016 12:41:43 -0700
Received: from maileast.thefacebook.com ([199.201.65.23])
        by mx0a-00082601.pphosted.com with ESMTP id 257b5sst73-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Sep 2016 12:41:43 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH 5/7] Btrfs: don't pass the inode through clean_io_failure
Date: Fri, 2 Sep 2016 15:40:04 -0400
Message-ID: <1472845206-22870-6-git-send-email-jbacik@fb.com>
In-Reply-To: <1472845206-22870-1-git-send-email-jbacik@fb.com>
References: <1472845206-22870-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead pass around the failure tree and the io tree.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent_io.c | 49 +++++++++++++++++++++++++++----------------------
 fs/btrfs/extent_io.h | 10 +++++++---
 fs/btrfs/inode.c     | 24 ++++++++++++++++++------
 3 files changed, 52 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 045e525..5dcdd3e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1946,11 +1946,12 @@ static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
 		SetPageUptodate(page);
 }
 
-int free_io_failure(struct inode *inode, struct io_failure_record *rec)
+int free_io_failure(struct extent_io_tree *failure_tree,
+		    struct extent_io_tree *io_tree,
+		    struct io_failure_record *rec)
 {
 	int ret;
 	int err = 0;
-	struct extent_io_tree *failure_tree = &BTRFS_I(inode)->io_failure_tree;
 
 	set_state_failrec(failure_tree, rec->start, NULL);
 	ret = clear_extent_bits(failure_tree, rec->start,
@@ -1959,7 +1960,7 @@ int free_io_failure(struct inode *inode, struct io_failure_record *rec)
 	if (ret)
 		err = ret;
 
-	ret = clear_extent_bits(&BTRFS_I(inode)->io_tree, rec->start,
+	ret = clear_extent_bits(io_tree, rec->start,
 				rec->start + rec->len - 1,
 				EXTENT_DAMAGED);
 	if (ret && !err)
@@ -2076,24 +2077,24 @@ int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
  * each time an IO finishes, we do a fast check in the IO failure tree
  * to see if we need to process or clean up an io_failure_record
  */
-int clean_io_failure(struct inode *inode, u64 start, struct page *page,
-		     unsigned int pg_offset)
+int clean_io_failure(struct btrfs_fs_info *fs_info,
+		     struct extent_io_tree *failure_tree,
+		     struct extent_io_tree *io_tree, u64 start,
+		     struct page *page, u64 ino, unsigned int pg_offset)
 {
 	u64 private;
 	struct io_failure_record *failrec;
-	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	struct extent_state *state;
 	int num_copies;
 	int ret;
 
 	private = 0;
-	ret = count_range_bits(&BTRFS_I(inode)->io_failure_tree, &private,
-				(u64)-1, 1, EXTENT_DIRTY, 0);
+	ret = count_range_bits(failure_tree, &private, (u64)-1, 1,
+			       EXTENT_DIRTY, 0);
 	if (!ret)
 		return 0;
 
-	ret = get_state_failrec(&BTRFS_I(inode)->io_failure_tree, start,
-			&failrec);
+	ret = get_state_failrec(failure_tree, start, &failrec);
 	if (ret)
 		return 0;
 
@@ -2108,25 +2109,25 @@ int clean_io_failure(struct inode *inode, u64 start, struct page *page,
 	if (fs_info->sb->s_flags & MS_RDONLY)
 		goto out;
 
-	spin_lock(&BTRFS_I(inode)->io_tree.lock);
-	state = find_first_extent_bit_state(&BTRFS_I(inode)->io_tree,
+	spin_lock(&io_tree->lock);
+	state = find_first_extent_bit_state(io_tree,
 					    failrec->start,
 					    EXTENT_LOCKED);
-	spin_unlock(&BTRFS_I(inode)->io_tree.lock);
+	spin_unlock(&io_tree->lock);
 
 	if (state && state->start <= failrec->start &&
 	    state->end >= failrec->start + failrec->len - 1) {
 		num_copies = btrfs_num_copies(fs_info, failrec->logical,
 					      failrec->len);
 		if (num_copies > 1)  {
-			repair_io_failure(fs_info, btrfs_ino(inode), start,
-					  failrec->len, failrec->logical, page,
-					  pg_offset, failrec->failed_mirror);
+			repair_io_failure(fs_info, ino, start, failrec->len,
+					  failrec->logical, page, pg_offset,
+					  failrec->failed_mirror);
 		}
 	}
 
 out:
-	free_io_failure(inode, failrec);
+	free_io_failure(failure_tree, io_tree, failrec);
 
 	return 0;
 }
@@ -2362,6 +2363,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	struct io_failure_record *failrec;
 	struct inode *inode = page->mapping->host;
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
+	struct extent_io_tree *failure_tree = &BTRFS_I(inode)->io_failure_tree;
 	struct bio *bio;
 	int read_mode;
 	int ret;
@@ -2374,7 +2376,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 
 	ret = btrfs_check_repairable(inode, failed_bio, failrec, failed_mirror);
 	if (!ret) {
-		free_io_failure(inode, failrec);
+		free_io_failure(failure_tree, tree, failrec);
 		return -EIO;
 	}
 
@@ -2389,7 +2391,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 				      (int)phy_offset, failed_bio->bi_end_io,
 				      NULL);
 	if (!bio) {
-		free_io_failure(inode, failrec);
+		free_io_failure(failure_tree, tree, failrec);
 		return -EIO;
 	}
 	bio_set_op_attrs(bio, REQ_OP_READ, read_mode);
@@ -2400,7 +2402,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	ret = tree->ops->submit_bio_hook(tree->private_data, bio, failrec->this_mirror,
 					 failrec->bio_flags, 0);
 	if (ret) {
-		free_io_failure(inode, failrec);
+		free_io_failure(failure_tree, tree, failrec);
 		bio_put(bio);
 	}
 
@@ -2506,7 +2508,7 @@ static void end_bio_extent_readpage(struct bio *bio)
 	struct bio_vec *bvec;
 	int uptodate = !bio->bi_error;
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
-	struct extent_io_tree *tree;
+	struct extent_io_tree *tree, *failure_tree;
 	u64 offset = 0;
 	u64 start;
 	u64 end;
@@ -2525,6 +2527,7 @@ static void end_bio_extent_readpage(struct bio *bio)
 			 "mirror=%u\n", (u64)bio->bi_iter.bi_sector,
 			 bio->bi_error, io_bio->mirror_num);
 		tree = &BTRFS_I(inode)->io_tree;
+		failure_tree = &BTRFS_I(inode)->io_failure_tree;
 
 		/* We always issue full-page reads, but if some block
 		 * in a page fails to read, blk_update_request() will
@@ -2556,7 +2559,9 @@ static void end_bio_extent_readpage(struct bio *bio)
 			if (ret)
 				uptodate = 0;
 			else
-				clean_io_failure(inode, start, page, 0);
+				clean_io_failure(BTRFS_I(inode)->root->fs_info,
+						 failure_tree, tree, start,
+						 page, btrfs_ino(inode), 0);
 		}
 
 		if (likely(uptodate))
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 0518e3e..c393c06 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -429,8 +429,10 @@ struct btrfs_fs_info;
 int repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
 		      u64 length, u64 logical, struct page *page,
 		      unsigned int pg_offset, int mirror_num);
-int clean_io_failure(struct inode *inode, u64 start, struct page *page,
-		     unsigned int pg_offset);
+int clean_io_failure(struct btrfs_fs_info *fs_info,
+		     struct extent_io_tree *failure_tree,
+		     struct extent_io_tree *io_tree, u64 start,
+		     struct page *page, u64 ino, unsigned int pg_offset);
 void end_extent_writepage(struct page *page, int err, u64 start, u64 end);
 int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 			 int mirror_num);
@@ -463,7 +465,9 @@ struct bio *btrfs_create_repair_bio(struct inode *inode, struct bio *failed_bio,
 				    struct io_failure_record *failrec,
 				    struct page *page, int pg_offset, int icsum,
 				    bio_end_io_t *endio_func, void *data);
-int free_io_failure(struct inode *inode, struct io_failure_record *rec);
+int free_io_failure(struct extent_io_tree *failure_tree,
+		    struct extent_io_tree *io_tree,
+		    struct io_failure_record *rec);
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 noinline u64 find_lock_delalloc_range(struct inode *inode,
 				      struct extent_io_tree *tree,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0b97cb4..8ca791f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7870,6 +7870,8 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 			bio_end_io_t *repair_endio, void *repair_arg)
 {
 	struct io_failure_record *failrec;
+	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	struct extent_io_tree *failure_tree = &BTRFS_I(inode)->io_failure_tree;
 	struct bio *bio;
 	int isector;
 	int read_mode;
@@ -7884,7 +7886,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 	ret = btrfs_check_dio_repairable(inode, failed_bio, failrec,
 					 failed_mirror);
 	if (!ret) {
-		free_io_failure(inode, failrec);
+		free_io_failure(failure_tree, io_tree, failrec);
 		return -EIO;
 	}
 
@@ -7900,7 +7902,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 	bio = btrfs_create_repair_bio(inode, failed_bio, failrec, page,
 				pgoff, isector, repair_endio, repair_arg);
 	if (!bio) {
-		free_io_failure(inode, failrec);
+		free_io_failure(failure_tree, io_tree, failrec);
 		return -EIO;
 	}
 	bio_set_op_attrs(bio, REQ_OP_READ, read_mode);
@@ -7911,7 +7913,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 
 	ret = submit_dio_repair_bio(inode, bio, failrec->this_mirror);
 	if (ret) {
-		free_io_failure(inode, failrec);
+		free_io_failure(failure_tree, io_tree, failrec);
 		bio_put(bio);
 	}
 
@@ -7930,6 +7932,7 @@ static void btrfs_retry_endio_nocsum(struct bio *bio)
 	struct btrfs_retry_complete *done = bio->bi_private;
 	struct inode *inode;
 	struct bio_vec *bvec;
+	struct extent_io_tree *io_tree, *failure_tree;
 	int i;
 
 	if (bio->bi_error)
@@ -7937,11 +7940,15 @@ static void btrfs_retry_endio_nocsum(struct bio *bio)
 
 	ASSERT(bio->bi_vcnt == 1);
 	inode = bio->bi_io_vec->bv_page->mapping->host;
+	io_tree = &BTRFS_I(inode)->io_tree;
+	failure_tree = &BTRFS_I(inode)->io_failure_tree;
 	ASSERT(bio->bi_io_vec->bv_len == BTRFS_I(inode)->root->sectorsize);
 
 	done->uptodate = 1;
 	bio_for_each_segment_all(bvec, bio, i)
-		clean_io_failure(done->inode, done->start, bvec->bv_page, 0);
+		clean_io_failure(BTRFS_I(inode)->root->fs_info, failure_tree,
+				 io_tree, done->start, bvec->bv_page,
+				 btrfs_ino(inode), 0);
 end:
 	complete(&done->done);
 	bio_put(bio);
@@ -8004,6 +8011,7 @@ static void btrfs_retry_endio(struct bio *bio)
 {
 	struct btrfs_retry_complete *done = bio->bi_private;
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+	struct extent_io_tree *io_tree, *failure_tree;
 	struct inode *inode;
 	struct bio_vec *bvec;
 	u64 start;
@@ -8020,6 +8028,8 @@ static void btrfs_retry_endio(struct bio *bio)
 
 	ASSERT(bio->bi_vcnt == 1);
 	inode = bio->bi_io_vec->bv_page->mapping->host;
+	io_tree = &BTRFS_I(inode)->io_tree;
+	failure_tree = &BTRFS_I(inode)->io_failure_tree;
 	ASSERT(bio->bi_io_vec->bv_len == BTRFS_I(inode)->root->sectorsize);
 
 	bio_for_each_segment_all(bvec, bio, i) {
@@ -8027,8 +8037,10 @@ static void btrfs_retry_endio(struct bio *bio)
 					bvec->bv_page, bvec->bv_offset,
 					done->start, bvec->bv_len);
 		if (!ret)
-			clean_io_failure(done->inode, done->start,
-					bvec->bv_page, bvec->bv_offset);
+			clean_io_failure(BTRFS_I(inode)->root->fs_info,
+					 failure_tree, io_tree, done->start,
+					 bvec->bv_page, btrfs_ino(inode),
+					 bvec->bv_offset);
 		else
 			uptodate = 0;
 	}
-- 
2.7.4

