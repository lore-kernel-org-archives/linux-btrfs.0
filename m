Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34162 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934382AbdBQOoQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:16 -0500
Received: by mail-wm0-f66.google.com with SMTP id c85so2931907wmi.1
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:15 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 23/38] btrfs: make free_io_failure take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:14 +0200
Message-Id: <1487342609-20652-24-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 14 +++++++-------
 fs/btrfs/extent_io.h |  4 +++-
 fs/btrfs/inode.c     |  6 +++---
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 996306d322de..0e73e48a9c4c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1959,11 +1959,11 @@ static void check_page_uptodate(struct extent_io_tree *tree, struct page *page)
 		SetPageUptodate(page);
 }
 
-int free_io_failure(struct inode *inode, struct io_failure_record *rec)
+int free_io_failure(struct btrfs_inode *inode, struct io_failure_record *rec)
 {
 	int ret;
 	int err = 0;
-	struct extent_io_tree *failure_tree = &BTRFS_I(inode)->io_failure_tree;
+	struct extent_io_tree *failure_tree = &inode->io_failure_tree;
 
 	set_state_failrec(failure_tree, rec->start, NULL);
 	ret = clear_extent_bits(failure_tree, rec->start,
@@ -1972,7 +1972,7 @@ int free_io_failure(struct inode *inode, struct io_failure_record *rec)
 	if (ret)
 		err = ret;
 
-	ret = clear_extent_bits(&BTRFS_I(inode)->io_tree, rec->start,
+	ret = clear_extent_bits(&inode->io_tree, rec->start,
 				rec->start + rec->len - 1,
 				EXTENT_DAMAGED);
 	if (ret && !err)
@@ -2140,7 +2140,7 @@ int clean_io_failure(struct inode *inode, u64 start, struct page *page,
 	}
 
 out:
-	free_io_failure(inode, failrec);
+	free_io_failure(BTRFS_I(inode), failrec);
 
 	return 0;
 }
@@ -2393,7 +2393,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 
 	ret = btrfs_check_repairable(inode, failed_bio, failrec, failed_mirror);
 	if (!ret) {
-		free_io_failure(inode, failrec);
+		free_io_failure(BTRFS_I(inode), failrec);
 		return -EIO;
 	}
 
@@ -2406,7 +2406,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 				      (int)phy_offset, failed_bio->bi_end_io,
 				      NULL);
 	if (!bio) {
-		free_io_failure(inode, failrec);
+		free_io_failure(BTRFS_I(inode), failrec);
 		return -EIO;
 	}
 	bio_set_op_attrs(bio, REQ_OP_READ, read_mode);
@@ -2418,7 +2418,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	ret = tree->ops->submit_bio_hook(inode, bio, failrec->this_mirror,
 					 failrec->bio_flags, 0);
 	if (ret) {
-		free_io_failure(inode, failrec);
+		free_io_failure(BTRFS_I(inode), failrec);
 		bio_put(bio);
 	}
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 270d03be290e..5b4132a9093a 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -480,6 +480,8 @@ struct io_failure_record {
 	int in_validation;
 };
 
+struct btrfs_inode;
+
 void btrfs_free_io_failure_record(struct inode *inode, u64 start, u64 end);
 int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
 				struct io_failure_record **failrec_ret);
@@ -489,7 +491,7 @@ struct bio *btrfs_create_repair_bio(struct inode *inode, struct bio *failed_bio,
 				    struct io_failure_record *failrec,
 				    struct page *page, int pg_offset, int icsum,
 				    bio_end_io_t *endio_func, void *data);
-int free_io_failure(struct inode *inode, struct io_failure_record *rec);
+int free_io_failure(struct btrfs_inode *inode, struct io_failure_record *rec);
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
 noinline u64 find_lock_delalloc_range(struct inode *inode,
 				      struct extent_io_tree *tree,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8c03abf69ac8..8c22820b6b0a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7852,7 +7852,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 	ret = btrfs_check_dio_repairable(inode, failed_bio, failrec,
 					 failed_mirror);
 	if (!ret) {
-		free_io_failure(inode, failrec);
+		free_io_failure(BTRFS_I(inode), failrec);
 		return -EIO;
 	}
 
@@ -7866,7 +7866,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 	bio = btrfs_create_repair_bio(inode, failed_bio, failrec, page,
 				pgoff, isector, repair_endio, repair_arg);
 	if (!bio) {
-		free_io_failure(inode, failrec);
+		free_io_failure(BTRFS_I(inode), failrec);
 		return -EIO;
 	}
 	bio_set_op_attrs(bio, REQ_OP_READ, read_mode);
@@ -7877,7 +7877,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 
 	ret = submit_dio_repair_bio(inode, bio, failrec->this_mirror);
 	if (ret) {
-		free_io_failure(inode, failrec);
+		free_io_failure(BTRFS_I(inode), failrec);
 		bio_put(bio);
 	}
 
-- 
2.7.4

