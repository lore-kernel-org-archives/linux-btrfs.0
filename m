Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20418 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755160Ab3GYLWu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jul 2013 07:22:50 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r6PBMlhe027098
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2013 19:22:48 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH V2 1/6] Btrfs: remove unnecessary argument of bio_readpage_error()
Date: Thu, 25 Jul 2013 19:22:32 +0800
Message-Id: <1374751357-3327-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1374751357-3327-1-git-send-email-miaox@cn.fujitsu.com>
References: <1374751357-3327-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- None
---
 fs/btrfs/extent_io.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f8586a9..a722235 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2202,8 +2202,7 @@ out:
  */
 
 static int bio_readpage_error(struct bio *failed_bio, struct page *page,
-				u64 start, u64 end, int failed_mirror,
-				struct extent_state *state)
+				u64 start, u64 end, int failed_mirror)
 {
 	struct io_failure_record *failrec = NULL;
 	u64 private;
@@ -2212,6 +2211,7 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
 	struct extent_io_tree *failure_tree = &BTRFS_I(inode)->io_failure_tree;
 	struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 	struct extent_map_tree *em_tree = &BTRFS_I(inode)->extent_tree;
+	struct extent_state *state;
 	struct bio *bio;
 	int num_copies;
 	int ret;
@@ -2296,22 +2296,18 @@ static int bio_readpage_error(struct bio *failed_bio, struct page *page,
 		 * all the retry and error correction code that follows. no
 		 * matter what the error is, it is very likely to persist.
 		 */
-		pr_debug("bio_readpage_error: cannot repair, num_copies == 1. "
-			 "state=%p, num_copies=%d, next_mirror %d, "
-			 "failed_mirror %d\n", state, num_copies,
-			 failrec->this_mirror, failed_mirror);
+		pr_debug("bio_readpage_error: cannot repair, num_copies=%d, next_mirror %d, failed_mirror %d\n",
+			 num_copies, failrec->this_mirror, failed_mirror);
 		free_io_failure(inode, failrec, 0);
 		return -EIO;
 	}
 
-	if (!state) {
-		spin_lock(&tree->lock);
-		state = find_first_extent_bit_state(tree, failrec->start,
-						    EXTENT_LOCKED);
-		if (state && state->start != failrec->start)
-			state = NULL;
-		spin_unlock(&tree->lock);
-	}
+	spin_lock(&tree->lock);
+	state = find_first_extent_bit_state(tree, failrec->start,
+					    EXTENT_LOCKED);
+	if (state && state->start != failrec->start)
+		state = NULL;
+	spin_unlock(&tree->lock);
 
 	/*
 	 * there are two premises:
@@ -2541,7 +2537,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 			 * can't handle the error it will return -EIO and we
 			 * remain responsible for that page.
 			 */
-			ret = bio_readpage_error(bio, page, start, end, mirror, NULL);
+			ret = bio_readpage_error(bio, page, start, end, mirror);
 			if (ret == 0) {
 				uptodate =
 					test_bit(BIO_UPTODATE, &bio->bi_flags);
-- 
1.8.1.4

