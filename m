Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53541 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752135AbaF1Ldf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 07:33:35 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5SBXVs4021027
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Jun 2014 19:33:31 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 07/12] Btrfs: split bio_readpage_error into several functions
Date: Sat, 28 Jun 2014 19:34:57 +0800
Message-ID: <1403955302-22396-8-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
References: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The data repair function of direct read will be implemented later, and some code
in bio_readpage_error will be reused, so split bio_readpage_error into
several functions which will be used in direct read repair later.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c | 159 ++++++++++++++++++++++++++++++---------------------
 fs/btrfs/extent_io.h |  28 +++++++++
 2 files changed, 123 insertions(+), 64 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b6b391e..f44c210 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1959,25 +1959,6 @@ static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
 		SetPageUptodate(page);
 }
 
-/*
- * When IO fails, either with EIO or csum verification fails, we
- * try other mirrors that might have a good copy of the data.  This
- * io_failure_record is used to record state as we go through all the
- * mirrors.  If another mirror has good data, the page is set up to date
- * and things continue.  If a good mirror can't be found, the original
- * bio end_io callback is called to indicate things have failed.
- */
-struct io_failure_record {
-	struct page *page;
-	u64 start;
-	u64 len;
-	u64 logical;
-	unsigned long bio_flags;
-	int this_mirror;
-	int failed_mirror;
-	int in_validation;
-};
-
 static int free_io_failure(struct inode *inode, struct io_failure_record *rec)
 {
 	int ret;
@@ -2153,40 +2134,24 @@ out:
 	return 0;
 }
 
-/*
- * this is a generic handler for readpage errors (default
- * readpage_io_failed_hook). if other copies exist, read those and write back
- * good data to the failed position. does not investigate in remapping the
- * failed extent elsewhere, hoping the device will be smart enough to do this as
- * needed
- */
-
-static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
-			      struct page *page, u64 start, u64 end,
-			      int failed_mirror)
+int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
+				struct io_failure_record **failrec_ret)
 {
-	struct io_failure_record *failrec = NULL;
+	struct io_failure_record *failrec;
 	u64 private;
 	struct extent_map *em;
-	struct inode *inode = page->mapping->host;
 	struct extent_io_tree *failure_tree = &BTRFS_I(inode)->io_failure_tree;
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
-	struct bio *bio;
-	struct btrfs_io_bio *btrfs_failed_bio;
-	struct btrfs_io_bio *btrfs_bio;
-	int num_copies;
 	int ret;
-	int read_mode;
 	u64 logical;
 
-	BUG_ON(failed_bio->bi_rw & REQ_WRITE);
-
 	ret = get_state_private(failure_tree, start, &private);
 	if (ret) {
 		failrec = kzalloc(sizeof(*failrec), GFP_NOFS);
 		if (!failrec)
 			return -ENOMEM;
+
 		failrec->start = start;
 		failrec->len = end - start + 1;
 		failrec->this_mirror = 0;
@@ -2206,11 +2171,11 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 			em = NULL;
 		}
 		read_unlock(&em_tree->lock);
-
 		if (!em) {
 			kfree(failrec);
 			return -EIO;
 		}
+
 		logical = start - em->start;
 		logical = em->block_start + logical;
 		if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags)) {
@@ -2219,8 +2184,10 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 			extent_set_compress_type(&failrec->bio_flags,
 						 em->compress_type);
 		}
-		pr_debug("bio_readpage_error: (new) logical=%llu, start=%llu, "
-			 "len=%llu\n", logical, start, failrec->len);
+
+		pr_debug("Get IO Failure Record: (new) logical=%llu, start=%llu, len=%llu\n",
+			 logical, start, failrec->len);
+
 		failrec->logical = logical;
 		free_extent_map(em);
 
@@ -2240,8 +2207,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 		}
 	} else {
 		failrec = (struct io_failure_record *)(unsigned long)private;
-		pr_debug("bio_readpage_error: (found) logical=%llu, "
-			 "start=%llu, len=%llu, validation=%d\n",
+		pr_debug("Get IO Failure Record: (found) logical=%llu, start=%llu, len=%llu, validation=%d\n",
 			 failrec->logical, failrec->start, failrec->len,
 			 failrec->in_validation);
 		/*
@@ -2250,6 +2216,17 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 		 * clean_io_failure() clean all those errors at once.
 		 */
 	}
+
+	*failrec_ret = failrec;
+
+	return 0;
+}
+
+int btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
+			   struct io_failure_record *failrec, int failed_mirror)
+{
+	int num_copies;
+
 	num_copies = btrfs_num_copies(BTRFS_I(inode)->root->fs_info,
 				      failrec->logical, failrec->len);
 	if (num_copies == 1) {
@@ -2258,10 +2235,9 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 		 * all the retry and error correction code that follows. no
 		 * matter what the error is, it is very likely to persist.
 		 */
-		pr_debug("bio_readpage_error: cannot repair, num_copies=%d, next_mirror %d, failed_mirror %d\n",
+		pr_debug("Check Repairable: cannot repair, num_copies=%d, next_mirror %d, failed_mirror %d\n",
 			 num_copies, failrec->this_mirror, failed_mirror);
-		free_io_failure(inode, failrec);
-		return -EIO;
+		return 0;
 	}
 
 	/*
@@ -2281,7 +2257,6 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 		BUG_ON(failrec->in_validation);
 		failrec->in_validation = 1;
 		failrec->this_mirror = failed_mirror;
-		read_mode = READ_SYNC | REQ_FAILFAST_DEV;
 	} else {
 		/*
 		 * we're ready to fulfill a) and b) alongside. get a good copy
@@ -2297,22 +2272,32 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 		failrec->this_mirror++;
 		if (failrec->this_mirror == failed_mirror)
 			failrec->this_mirror++;
-		read_mode = READ_SYNC;
 	}
 
 	if (failrec->this_mirror > num_copies) {
-		pr_debug("bio_readpage_error: (fail) num_copies=%d, next_mirror %d, failed_mirror %d\n",
+		pr_debug("Check Repairable: (fail) num_copies=%d, next_mirror %d, failed_mirror %d\n",
 			 num_copies, failrec->this_mirror, failed_mirror);
-		free_io_failure(inode, failrec);
-		return -EIO;
+		return 0;
 	}
 
+	return 1;
+}
+
+
+struct bio *btrfs_create_repair_bio(struct inode *inode, struct bio *failed_bio,
+				    struct io_failure_record *failrec,
+				    struct page *page, int pg_offset, int icsum,
+				    bio_end_io_t *endio_func)
+{
+	struct bio *bio;
+	struct btrfs_io_bio *btrfs_failed_bio;
+	struct btrfs_io_bio *btrfs_bio;
+
 	bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
-	if (!bio) {
-		free_io_failure(inode, failrec);
-		return -EIO;
-	}
-	bio->bi_end_io = failed_bio->bi_end_io;
+	if (!bio)
+		return NULL;
+
+	bio->bi_end_io = endio_func;
 	bio->bi_iter.bi_sector = failrec->logical >> 9;
 	bio->bi_bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
 	bio->bi_iter.bi_size = 0;
@@ -2324,17 +2309,63 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 
 		btrfs_bio = btrfs_io_bio(bio);
 		btrfs_bio->csum = btrfs_bio->csum_inline;
-		phy_offset >>= inode->i_sb->s_blocksize_bits;
-		phy_offset *= csum_size;
-		memcpy(btrfs_bio->csum, btrfs_failed_bio->csum + phy_offset,
+		icsum *= csum_size;
+		memcpy(btrfs_bio->csum, btrfs_failed_bio->csum + icsum,
 		       csum_size);
 	}
 
-	bio_add_page(bio, page, failrec->len, start - page_offset(page));
+	bio_add_page(bio, page, failrec->len, pg_offset);
+
+	return bio;
+}
+
+/*
+ * this is a generic handler for readpage errors (default
+ * readpage_io_failed_hook). if other copies exist, read those and write back
+ * good data to the failed position. does not investigate in remapping the
+ * failed extent elsewhere, hoping the device will be smart enough to do this as
+ * needed
+ */
+
+static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
+			      struct page *page, u64 start, u64 end,
+			      int failed_mirror)
+{
+	struct io_failure_record *failrec;
+	struct inode *inode = page->mapping->host;
+	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
+	struct bio *bio;
+	int read_mode;
+	int ret;
+
+	BUG_ON(failed_bio->bi_rw & REQ_WRITE);
+
+	ret = btrfs_get_io_failure_record(inode, start, end, &failrec);
+	if (ret)
+		return ret;
+
+	ret = btrfs_check_repairable(inode, failed_bio, failrec, failed_mirror);
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
+	phy_offset >>= inode->i_sb->s_blocksize_bits;
+	bio = btrfs_create_repair_bio(inode, failed_bio, failrec, page,
+				      start - page_offset(page),
+				      (int)phy_offset, failed_bio->bi_end_io);
+	if (!bio) {
+		free_io_failure(inode, failrec);
+		return -EIO;
+	}
 
-	pr_debug("bio_readpage_error: submitting new read[%#x] to "
-		 "this_mirror=%d, num_copies=%d, in_validation=%d\n", read_mode,
-		 failrec->this_mirror, num_copies, failrec->in_validation);
+	pr_debug("Repair Read Error: submitting new read[%#x] to this_mirror=%d, in_validation=%d\n",
+		 read_mode, failrec->this_mirror, failrec->in_validation);
 
 	ret = tree->ops->submit_bio_hook(inode, read_mode, bio,
 					 failrec->this_mirror,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index ccc264e..4ce0547 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -347,6 +347,34 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 int end_extent_writepage(struct page *page, int err, u64 start, u64 end);
 int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 			 int mirror_num);
+
+/*
+ * When IO fails, either with EIO or csum verification fails, we
+ * try other mirrors that might have a good copy of the data.  This
+ * io_failure_record is used to record state as we go through all the
+ * mirrors.  If another mirror has good data, the page is set up to date
+ * and things continue.  If a good mirror can't be found, the original
+ * bio end_io callback is called to indicate things have failed.
+ */
+struct io_failure_record {
+	struct page *page;
+	u64 start;
+	u64 len;
+	u64 logical;
+	unsigned long bio_flags;
+	int this_mirror;
+	int failed_mirror;
+	int in_validation;
+};
+
+int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
+				struct io_failure_record **failrec_ret);
+int btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
+			   struct io_failure_record *failrec, int fail_mirror);
+struct bio *btrfs_create_repair_bio(struct inode *inode, struct bio *failed_bio,
+				    struct io_failure_record *failrec,
+				    struct page *page, int pg_offset, int icsum,
+				    bio_end_io_t *endio_func);
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 noinline u64 find_lock_delalloc_range(struct inode *inode,
 				      struct extent_io_tree *tree,
-- 
1.9.3

