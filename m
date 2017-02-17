Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33710 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934526AbdBQOoP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:15 -0500
Received: by mail-wr0-f193.google.com with SMTP id i10so5520665wrb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:14 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 27/38] btrfs: make clean_io_failure take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:18 +0200
Message-Id: <1487342609-20652-28-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 20 ++++++++++----------
 fs/btrfs/extent_io.h |  2 +-
 fs/btrfs/inode.c     |  4 ++--
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a405f63f7053..16860ab7cb5e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2089,23 +2089,23 @@ int repair_eb_io_failure(struct btrfs_fs_info *fs_info,
  * each time an IO finishes, we do a fast check in the IO failure tree
  * to see if we need to process or clean up an io_failure_record
  */
-int clean_io_failure(struct inode *inode, u64 start, struct page *page,
+int clean_io_failure(struct btrfs_inode *inode, u64 start, struct page *page,
 		     unsigned int pg_offset)
 {
 	u64 private;
 	struct io_failure_record *failrec;
-	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct extent_state *state;
 	int num_copies;
 	int ret;
 
 	private = 0;
-	ret = count_range_bits(&BTRFS_I(inode)->io_failure_tree, &private,
+	ret = count_range_bits(&inode->io_failure_tree, &private,
 				(u64)-1, 1, EXTENT_DIRTY, 0);
 	if (!ret)
 		return 0;
 
-	ret = get_state_failrec(&BTRFS_I(inode)->io_failure_tree, start,
+	ret = get_state_failrec(&inode->io_failure_tree, start,
 			&failrec);
 	if (ret)
 		return 0;
@@ -2122,25 +2122,25 @@ int clean_io_failure(struct inode *inode, u64 start, struct page *page,
 	if (fs_info->sb->s_flags & MS_RDONLY)
 		goto out;
 
-	spin_lock(&BTRFS_I(inode)->io_tree.lock);
-	state = find_first_extent_bit_state(&BTRFS_I(inode)->io_tree,
+	spin_lock(&inode->io_tree.lock);
+	state = find_first_extent_bit_state(&inode->io_tree,
 					    failrec->start,
 					    EXTENT_LOCKED);
-	spin_unlock(&BTRFS_I(inode)->io_tree.lock);
+	spin_unlock(&inode->io_tree.lock);
 
 	if (state && state->start <= failrec->start &&
 	    state->end >= failrec->start + failrec->len - 1) {
 		num_copies = btrfs_num_copies(fs_info, failrec->logical,
 					      failrec->len);
 		if (num_copies > 1)  {
-			repair_io_failure(BTRFS_I(inode), start, failrec->len,
+			repair_io_failure(inode, start, failrec->len,
 					  failrec->logical, page,
 					  pg_offset, failrec->failed_mirror);
 		}
 	}
 
 out:
-	free_io_failure(BTRFS_I(inode), failrec);
+	free_io_failure(inode, failrec);
 
 	return 0;
 }
@@ -2576,7 +2576,7 @@ static void end_bio_extent_readpage(struct bio *bio)
 			if (ret)
 				uptodate = 0;
 			else
-				clean_io_failure(inode, start, page, 0);
+				clean_io_failure(BTRFS_I(inode), start, page, 0);
 		}
 
 		if (likely(uptodate))
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index a3b13b4385bc..81c9f678ada5 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -456,7 +456,7 @@ struct btrfs_inode;
 int repair_io_failure(struct btrfs_inode *inode, u64 start, u64 length, u64 logical,
 		      struct page *page, unsigned int pg_offset,
 		      int mirror_num);
-int clean_io_failure(struct inode *inode, u64 start, struct page *page,
+int clean_io_failure(struct btrfs_inode *inode, u64 start, struct page *page,
 		     unsigned int pg_offset);
 void end_extent_writepage(struct page *page, int err, u64 start, u64 end);
 int repair_eb_io_failure(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f71296933aec..a472d13a9ecb 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7907,7 +7907,7 @@ static void btrfs_retry_endio_nocsum(struct bio *bio)
 
 	done->uptodate = 1;
 	bio_for_each_segment_all(bvec, bio, i)
-		clean_io_failure(done->inode, done->start, bvec->bv_page, 0);
+		clean_io_failure(BTRFS_I(done->inode), done->start, bvec->bv_page, 0);
 end:
 	complete(&done->done);
 	bio_put(bio);
@@ -7993,7 +7993,7 @@ static void btrfs_retry_endio(struct bio *bio)
 					bvec->bv_page, bvec->bv_offset,
 					done->start, bvec->bv_len);
 		if (!ret)
-			clean_io_failure(done->inode, done->start,
+			clean_io_failure(BTRFS_I(done->inode), done->start,
 					bvec->bv_page, bvec->bv_offset);
 		else
 			uptodate = 0;
-- 
2.7.4

