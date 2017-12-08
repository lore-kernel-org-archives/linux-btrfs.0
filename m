Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752989AbdLHNQM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Dec 2017 08:16:12 -0500
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@redhat.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH 09/10] btrfs: avoid access to .bi_vcnt directly
Date: Fri,  8 Dec 2017 21:14:08 +0800
Message-Id: <20171208131409.11889-10-ming.lei@redhat.com>
In-Reply-To: <20171208131409.11889-1-ming.lei@redhat.com>
References: <20171208131409.11889-1-ming.lei@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

BTRFS uses bio->bi_vcnt to figure out page numbers, this way becomes not
correct once we start to enable multipage bvec.

So use bio_nr_pages() to do that instead.

Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org
Acked-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 fs/btrfs/extent_io.c | 9 +++++----
 fs/btrfs/extent_io.h | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6f6669f93beb..27795bf2507c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2257,7 +2257,7 @@ int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
 	return 0;
 }
 
-bool btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
+bool btrfs_check_repairable(struct inode *inode, unsigned failed_bio_pages,
 			   struct io_failure_record *failrec, int failed_mirror)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
@@ -2281,7 +2281,7 @@ bool btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
 	 *	a) deliver good data to the caller
 	 *	b) correct the bad sectors on disk
 	 */
-	if (failed_bio->bi_vcnt > 1) {
+	if (failed_bio_pages > 1) {
 		/*
 		 * to fulfill b), we need to know the exact failing sectors, as
 		 * we don't want to rewrite any more than the failed ones. thus,
@@ -2374,6 +2374,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	int read_mode = 0;
 	blk_status_t status;
 	int ret;
+	unsigned failed_bio_pages = bio_nr_pages(failed_bio);
 
 	BUG_ON(bio_op(failed_bio) == REQ_OP_WRITE);
 
@@ -2381,13 +2382,13 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	if (ret)
 		return ret;
 
-	if (!btrfs_check_repairable(inode, failed_bio, failrec,
+	if (!btrfs_check_repairable(inode, failed_bio_pages, failrec,
 				    failed_mirror)) {
 		free_io_failure(failure_tree, tree, failrec);
 		return -EIO;
 	}
 
-	if (failed_bio->bi_vcnt > 1)
+	if (failed_bio_pages > 1)
 		read_mode |= REQ_FAILFAST_DEV;
 
 	phy_offset >>= inode->i_sb->s_blocksize_bits;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 93dcae0c3183..20854d63c75b 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -540,7 +540,7 @@ void btrfs_free_io_failure_record(struct btrfs_inode *inode, u64 start,
 		u64 end);
 int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
 				struct io_failure_record **failrec_ret);
-bool btrfs_check_repairable(struct inode *inode, struct bio *failed_bio,
+bool btrfs_check_repairable(struct inode *inode, unsigned failed_bio_pages,
 			    struct io_failure_record *failrec, int fail_mirror);
 struct bio *btrfs_create_repair_bio(struct inode *inode, struct bio *failed_bio,
 				    struct io_failure_record *failrec,
-- 
2.9.5

