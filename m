Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10067 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752117AbaF1Lde (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 07:33:34 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5SBXU5q021024
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Jun 2014 19:33:30 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 06/12] Btrfs: Cleanup unused variant and argument of IO failure handlers
Date: Sat, 28 Jun 2014 19:34:56 +0800
Message-ID: <1403955302-22396-7-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
References: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c49c1e1..b6b391e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1978,8 +1978,7 @@ struct io_failure_record {
 	int in_validation;
 };
 
-static int free_io_failure(struct inode *inode, struct io_failure_record *rec,
-				int did_repair)
+static int free_io_failure(struct inode *inode, struct io_failure_record *rec)
 {
 	int ret;
 	int err = 0;
@@ -2106,7 +2105,6 @@ static int clean_io_failure(u64 start, struct page *page)
 	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	struct extent_state *state;
 	int num_copies;
-	int did_repair = 0;
 	int ret;
 
 	private = 0;
@@ -2127,7 +2125,6 @@ static int clean_io_failure(u64 start, struct page *page)
 		/* there was no real error, just free the record */
 		pr_debug("clean_io_failure: freeing dummy error at %llu\n",
 			 failrec->start);
-		did_repair = 1;
 		goto out;
 	}
 	if (fs_info->sb->s_flags & MS_RDONLY)
@@ -2144,19 +2141,16 @@ static int clean_io_failure(u64 start, struct page *page)
 		num_copies = btrfs_num_copies(fs_info, failrec->logical,
 					      failrec->len);
 		if (num_copies > 1)  {
-			ret = repair_io_failure(fs_info, start, failrec->len,
-						failrec->logical, page,
-						failrec->failed_mirror);
-			did_repair = !ret;
+			repair_io_failure(fs_info, start, failrec->len,
+					  failrec->logical, page,
+					  failrec->failed_mirror);
 		}
-		ret = 0;
 	}
 
 out:
-	if (!ret)
-		ret = free_io_failure(inode, failrec, did_repair);
+	free_io_failure(inode, failrec);
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -2266,7 +2260,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 		 */
 		pr_debug("bio_readpage_error: cannot repair, num_copies=%d, next_mirror %d, failed_mirror %d\n",
 			 num_copies, failrec->this_mirror, failed_mirror);
-		free_io_failure(inode, failrec, 0);
+		free_io_failure(inode, failrec);
 		return -EIO;
 	}
 
@@ -2309,13 +2303,13 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 	if (failrec->this_mirror > num_copies) {
 		pr_debug("bio_readpage_error: (fail) num_copies=%d, next_mirror %d, failed_mirror %d\n",
 			 num_copies, failrec->this_mirror, failed_mirror);
-		free_io_failure(inode, failrec, 0);
+		free_io_failure(inode, failrec);
 		return -EIO;
 	}
 
 	bio = btrfs_io_bio_alloc(GFP_NOFS, 1);
 	if (!bio) {
-		free_io_failure(inode, failrec, 0);
+		free_io_failure(inode, failrec);
 		return -EIO;
 	}
 	bio->bi_end_io = failed_bio->bi_end_io;
@@ -2346,7 +2340,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 					 failrec->this_mirror,
 					 failrec->bio_flags, 0);
 	if (ret) {
-		free_io_failure(inode, failrec, 0);
+		free_io_failure(inode, failrec);
 		bio_put(bio);
 	}
 
-- 
1.9.3

