Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5324 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752759AbaILKmS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 06:42:18 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s8CAgQZw017332
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 18:42:26 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4 05/11] Btrfs: Cleanup unused variant and argument of IO failure handlers
Date: Fri, 12 Sep 2014 18:43:58 +0800
Message-ID: <1410518644-31806-6-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1410518644-31806-1-git-send-email-miaox@cn.fujitsu.com>
References: <5405C08B.9020009@fb.com>
 <1410518644-31806-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v4:
- None
---
 fs/btrfs/extent_io.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f8dda46..154cb8e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1981,8 +1981,7 @@ struct io_failure_record {
 	int in_validation;
 };
 
-static int free_io_failure(struct inode *inode, struct io_failure_record *rec,
-				int did_repair)
+static int free_io_failure(struct inode *inode, struct io_failure_record *rec)
 {
 	int ret;
 	int err = 0;
@@ -2109,7 +2108,6 @@ static int clean_io_failure(u64 start, struct page *page)
 	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	struct extent_state *state;
 	int num_copies;
-	int did_repair = 0;
 	int ret;
 
 	private = 0;
@@ -2130,7 +2128,6 @@ static int clean_io_failure(u64 start, struct page *page)
 		/* there was no real error, just free the record */
 		pr_debug("clean_io_failure: freeing dummy error at %llu\n",
 			 failrec->start);
-		did_repair = 1;
 		goto out;
 	}
 	if (fs_info->sb->s_flags & MS_RDONLY)
@@ -2147,19 +2144,16 @@ static int clean_io_failure(u64 start, struct page *page)
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
@@ -2269,7 +2263,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 		 */
 		pr_debug("bio_readpage_error: cannot repair, num_copies=%d, next_mirror %d, failed_mirror %d\n",
 			 num_copies, failrec->this_mirror, failed_mirror);
-		free_io_failure(inode, failrec, 0);
+		free_io_failure(inode, failrec);
 		return -EIO;
 	}
 
@@ -2312,13 +2306,13 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
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
@@ -2349,7 +2343,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 					 failrec->this_mirror,
 					 failrec->bio_flags, 0);
 	if (ret) {
-		free_io_failure(inode, failrec, 0);
+		free_io_failure(inode, failrec);
 		bio_put(bio);
 	}
 
-- 
1.9.3

