Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:36292 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752190AbdEEP5X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 May 2017 11:57:23 -0400
Received: by mail-yw0-f194.google.com with SMTP id j9so722258ywj.3
        for <linux-btrfs@vger.kernel.org>; Fri, 05 May 2017 08:57:23 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 3/3] Btrfs: don't pass the inode through clean_io_failure
Date: Fri,  5 May 2017 11:57:15 -0400
Message-Id: <1493999835-26731-4-git-send-email-jbacik@fb.com>
In-Reply-To: <1493999835-26731-1-git-send-email-jbacik@fb.com>
References: <1493999835-26731-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead pass around the failure tree and the io tree.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent_io.c | 51 ++++++++++++++++++++++++++++-----------------------
 fs/btrfs/extent_io.h | 10 +++++++---
 fs/btrfs/inode.c     | 37 ++++++++++++++++++++++++++-----------
 3 files changed, 61 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index de6f890..f693de1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1939,11 +1939,12 @@ static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
 		SetPageUptodate(page);
 }
 
-int free_io_failure(struct btrfs_inode *inode, struct io_failure_record *rec)
+int free_io_failure(struct extent_io_tree *failure_tree,
+		    struct extent_io_tree *io_tree,
+		    struct io_failure_record *rec)
 {
 	int ret;
 	int err = 0;
-	struct extent_io_tree *failure_tree = &inode->io_failure_tree;
 
 	set_state_failrec(failure_tree, rec->start, NULL);
 	ret = clear_extent_bits(failure_tree, rec->start,
@@ -1952,7 +1953,7 @@ int free_io_failure(struct btrfs_inode *inode, struct io_failure_record *rec)
 	if (ret)
 		err = ret;
 
-	ret = clear_extent_bits(&inode->io_tree, rec->start,
+	ret = clear_extent_bits(io_tree, rec->start,
 				rec->start + rec->len - 1,
 				EXTENT_DAMAGED);
 	if (ret && !err)
@@ -2068,24 +2069,24 @@ int repair_eb_io_failure(struct btrfs_fs_info *fs_info,
  * each time an IO finishes, we do a fast check in the IO failure tree
  * to see if we need to process or clean up an io_failure_record
  */
-int clean_io_failure(struct btrfs_inode *inode, u64 start, struct page *page,
-		     unsigned int pg_offset)
+int clean_io_failure(struct btrfs_fs_info *fs_info,
+		     struct extent_io_tree *failure_tree,
+		     struct extent_io_tree *io_tree, u64 start,
+		     struct page *page, u64 ino, unsigned int pg_offset)
 {
 	u64 private;
 	struct io_failure_record *failrec;
-	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct extent_state *state;
 	int num_copies;
 	int ret;
 
 	private = 0;
-	ret = count_range_bits(&inode->io_failure_tree, &private,
-				(u64)-1, 1, EXTENT_DIRTY, 0);
+	ret = count_range_bits(failure_tree, &private, (u64)-1, 1,
+			       EXTENT_DIRTY, 0);
 	if (!ret)
 		return 0;
 
-	ret = get_state_failrec(&inode->io_failure_tree, start,
-			&failrec);
+	ret = get_state_failrec(failure_tree, start, &failrec);
 	if (ret)
 		return 0;
 
@@ -2101,25 +2102,25 @@ int clean_io_failure(struct btrfs_inode *inode, u64 start, struct page *page,
 	if (fs_info->sb->s_flags & MS_RDONLY)
 		goto out;
 
-	spin_lock(&inode->io_tree.lock);
-	state = find_first_extent_bit_state(&inode->io_tree,
+	spin_lock(&io_tree->lock);
+	state = find_first_extent_bit_state(io_tree,
 					    failrec->start,
 					    EXTENT_LOCKED);
-	spin_unlock(&inode->io_tree.lock);
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
@@ -2360,6 +2361,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	struct io_failure_record *failrec;
 	struct inode *inode = page->mapping->host;
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
+	struct extent_io_tree *failure_tree = &BTRFS_I(inode)->io_failure_tree;
 	struct bio *bio;
 	int read_mode = 0;
 	int ret;
@@ -2372,7 +2374,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 
 	ret = btrfs_check_repairable(inode, failed_bio, failrec, failed_mirror);
 	if (!ret) {
-		free_io_failure(BTRFS_I(inode), failrec);
+		free_io_failure(failure_tree, tree, failrec);
 		return -EIO;
 	}
 
@@ -2385,7 +2387,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 				      (int)phy_offset, failed_bio->bi_end_io,
 				      NULL);
 	if (!bio) {
-		free_io_failure(BTRFS_I(inode), failrec);
+		free_io_failure(failure_tree, tree, failrec);
 		return -EIO;
 	}
 	bio_set_op_attrs(bio, REQ_OP_READ, read_mode);
@@ -2397,7 +2399,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	ret = tree->ops->submit_bio_hook(tree->private_data, bio, failrec->this_mirror,
 					 failrec->bio_flags, 0);
 	if (ret) {
-		free_io_failure(BTRFS_I(inode), failrec);
+		free_io_failure(failure_tree, tree, failrec);
 		bio_put(bio);
 	}
 
@@ -2501,7 +2503,7 @@ static void end_bio_extent_readpage(struct bio *bio)
 	struct bio_vec *bvec;
 	int uptodate = !bio->bi_error;
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
-	struct extent_io_tree *tree;
+	struct extent_io_tree *tree, *failure_tree;
 	u64 offset = 0;
 	u64 start;
 	u64 end;
@@ -2522,6 +2524,7 @@ static void end_bio_extent_readpage(struct bio *bio)
 			(u64)bio->bi_iter.bi_sector, bio->bi_error,
 			io_bio->mirror_num);
 		tree = &BTRFS_I(inode)->io_tree;
+		failure_tree = &BTRFS_I(inode)->io_failure_tree;
 
 		/* We always issue full-page reads, but if some block
 		 * in a page fails to read, blk_update_request() will
@@ -2551,8 +2554,10 @@ static void end_bio_extent_readpage(struct bio *bio)
 			if (ret)
 				uptodate = 0;
 			else
-				clean_io_failure(BTRFS_I(inode), start,
-						page, 0);
+				clean_io_failure(BTRFS_I(inode)->root->fs_info,
+						 failure_tree, tree, start,
+						 page,
+						 btrfs_ino(BTRFS_I(inode)), 0);
 		}
 
 		if (likely(uptodate))
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index fd04124..e29ffec 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -470,8 +470,10 @@ struct btrfs_inode;
 int repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
 		      u64 length, u64 logical, struct page *page,
 		      unsigned int pg_offset, int mirror_num);
-int clean_io_failure(struct btrfs_inode *inode, u64 start,
-		struct page *page, unsigned int pg_offset);
+int clean_io_failure(struct btrfs_fs_info *fs_info,
+		     struct extent_io_tree *failure_tree,
+		     struct extent_io_tree *io_tree, u64 start,
+		     struct page *page, u64 ino, unsigned int pg_offset);
 void end_extent_writepage(struct page *page, int err, u64 start, u64 end);
 int repair_eb_io_failure(struct btrfs_fs_info *fs_info,
 			 struct extent_buffer *eb, int mirror_num);
@@ -506,7 +508,9 @@ struct bio *btrfs_create_repair_bio(struct inode *inode, struct bio *failed_bio,
 				    struct io_failure_record *failrec,
 				    struct page *page, int pg_offset, int icsum,
 				    bio_end_io_t *endio_func, void *data);
-int free_io_failure(struct btrfs_inode *inode, struct io_failure_record *rec);
+int free_io_failure(struct extent_io_tree *failure_tree,
+		    struct extent_io_tree *io_tree,
+		    struct io_failure_record *rec);
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 noinline u64 find_lock_delalloc_range(struct inode *inode,
 				      struct extent_io_tree *tree,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 71f4668..b18f853 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7862,6 +7862,8 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 			bio_end_io_t *repair_endio, void *repair_arg)
 {
 	struct io_failure_record *failrec;
+	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
+	struct extent_io_tree *failure_tree = &BTRFS_I(inode)->io_failure_tree;
 	struct bio *bio;
 	int isector;
 	int read_mode = 0;
@@ -7876,7 +7878,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 	ret = btrfs_check_dio_repairable(inode, failed_bio, failrec,
 					 failed_mirror);
 	if (!ret) {
-		free_io_failure(BTRFS_I(inode), failrec);
+		free_io_failure(failure_tree, io_tree, failrec);
 		return -EIO;
 	}
 
@@ -7890,7 +7892,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 	bio = btrfs_create_repair_bio(inode, failed_bio, failrec, page,
 				pgoff, isector, repair_endio, repair_arg);
 	if (!bio) {
-		free_io_failure(BTRFS_I(inode), failrec);
+		free_io_failure(failure_tree, io_tree, failrec);
 		return -EIO;
 	}
 	bio_set_op_attrs(bio, REQ_OP_READ, read_mode);
@@ -7901,7 +7903,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 
 	ret = submit_dio_repair_bio(inode, bio, failrec->this_mirror);
 	if (ret) {
-		free_io_failure(BTRFS_I(inode), failrec);
+		free_io_failure(failure_tree, io_tree, failrec);
 		bio_put(bio);
 	}
 
@@ -7918,19 +7920,24 @@ struct btrfs_retry_complete {
 static void btrfs_retry_endio_nocsum(struct bio *bio)
 {
 	struct btrfs_retry_complete *done = bio->bi_private;
+	struct inode *inode = done->inode;
 	struct bio_vec *bvec;
+	struct extent_io_tree *io_tree, *failure_tree;
 	int i;
 
 	if (bio->bi_error)
 		goto end;
 
 	ASSERT(bio->bi_vcnt == 1);
-	ASSERT(bio->bi_io_vec->bv_len == btrfs_inode_sectorsize(done->inode));
+	io_tree = &BTRFS_I(inode)->io_tree;
+	failure_tree = &BTRFS_I(inode)->io_failure_tree;
+	ASSERT(bio->bi_io_vec->bv_len == btrfs_inode_sectorsize(inode));
 
 	done->uptodate = 1;
 	bio_for_each_segment_all(bvec, bio, i)
-		clean_io_failure(BTRFS_I(done->inode), done->start,
-				 bvec->bv_page, 0);
+		clean_io_failure(BTRFS_I(inode)->root->fs_info, failure_tree,
+				 io_tree, done->start, bvec->bv_page,
+				 btrfs_ino(BTRFS_I(inode)), 0);
 end:
 	complete(&done->done);
 	bio_put(bio);
@@ -7995,6 +8002,8 @@ static void btrfs_retry_endio(struct bio *bio)
 {
 	struct btrfs_retry_complete *done = bio->bi_private;
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+	struct extent_io_tree *io_tree, *failure_tree;
+	struct inode *inode = done->inode;
 	struct bio_vec *bvec;
 	int uptodate;
 	int ret;
@@ -8008,13 +8017,19 @@ static void btrfs_retry_endio(struct bio *bio)
 	ASSERT(bio->bi_vcnt == 1);
 	ASSERT(bio->bi_io_vec->bv_len == btrfs_inode_sectorsize(done->inode));
 
+	io_tree = &BTRFS_I(inode)->io_tree;
+	failure_tree = &BTRFS_I(inode)->io_failure_tree;
+
 	bio_for_each_segment_all(bvec, bio, i) {
-		ret = __readpage_endio_check(done->inode, io_bio, i,
-					bvec->bv_page, bvec->bv_offset,
-					done->start, bvec->bv_len);
+		ret = __readpage_endio_check(inode, io_bio, i, bvec->bv_page,
+					     bvec->bv_offset, done->start,
+					     bvec->bv_len);
 		if (!ret)
-			clean_io_failure(BTRFS_I(done->inode), done->start,
-					bvec->bv_page, bvec->bv_offset);
+			clean_io_failure(BTRFS_I(inode)->root->fs_info,
+					 failure_tree, io_tree, done->start,
+					 bvec->bv_page,
+					 btrfs_ino(BTRFS_I(inode)),
+					 bvec->bv_offset);
 		else
 			uptodate = 0;
 	}
-- 
2.7.4

