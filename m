Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10067 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752293AbaF1Ldf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Jun 2014 07:33:35 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5SBXXfg021033
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Jun 2014 19:33:33 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 09/12] Btrfs: modify clean_io_failure and make it suit direct io
Date: Sat, 28 Jun 2014 19:34:59 +0800
Message-ID: <1403955302-22396-10-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
References: <1403955302-22396-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We could not use clean_io_failure in the direct IO path because it got the
filesystem information from the page structure, but the page in the direct
IO bio didn't have the filesystem information in its structure. So we need
modify it and pass all the information it need by parameters.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/extent_io.c | 31 +++++++++++++++----------------
 fs/btrfs/extent_io.h |  6 +++---
 fs/btrfs/scrub.c     |  3 +--
 3 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 20c3f2e..6e30a8c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1992,10 +1992,10 @@ static int free_io_failure(struct inode *inode, struct io_failure_record *rec)
  * currently, there can be no more than two copies of every data bit. thus,
  * exactly one rewrite is required.
  */
-int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
-			u64 length, u64 logical, struct page *page,
-			unsigned int pg_offset, int mirror_num)
+int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
+		      struct page *page, unsigned int pg_offset, int mirror_num)
 {
+	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	struct bio *bio;
 	struct btrfs_device *dev;
 	u64 map_length = 0;
@@ -2043,10 +2043,9 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 	}
 
 	printk_ratelimited_in_rcu(KERN_INFO
-			"BTRFS: read error corrected: ino %lu off %llu "
-		    "(dev %s sector %llu)\n", page->mapping->host->i_ino,
-		    start, rcu_str_deref(dev->name), sector);
-
+				  "BTRFS: read error corrected: ino %llu off %llu (dev %s sector %llu)\n",
+				  btrfs_ino(inode), start,
+				  rcu_str_deref(dev->name), sector);
 	bio_put(bio);
 	return 0;
 }
@@ -2063,9 +2062,10 @@ int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = extent_buffer_page(eb, i);
-		ret = repair_io_failure(root->fs_info, start, PAGE_CACHE_SIZE,
-					start, p, start - page_offset(p),
-					mirror_num);
+
+		ret = repair_io_failure(root->fs_info->btree_inode, start,
+					PAGE_CACHE_SIZE, start, p,
+					start - page_offset(p), mirror_num);
 		if (ret)
 			break;
 		start += PAGE_CACHE_SIZE;
@@ -2078,12 +2078,12 @@ int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
  * each time an IO finishes, we do a fast check in the IO failure tree
  * to see if we need to process or clean up an io_failure_record
  */
-static int clean_io_failure(u64 start, struct page *page)
+static int clean_io_failure(struct inode *inode, u64 start,
+			    struct page *page, unsigned int pg_offset)
 {
 	u64 private;
 	u64 private_failure;
 	struct io_failure_record *failrec;
-	struct inode *inode = page->mapping->host;
 	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	struct extent_state *state;
 	int num_copies;
@@ -2123,10 +2123,9 @@ static int clean_io_failure(u64 start, struct page *page)
 		num_copies = btrfs_num_copies(fs_info, failrec->logical,
 					      failrec->len);
 		if (num_copies > 1)  {
-			repair_io_failure(fs_info, start, failrec->len,
+			repair_io_failure(inode, start, failrec->len,
 					  failrec->logical, page,
-					  start - page_offset(page),
-					  failrec->failed_mirror);
+					  pg_offset, failrec->failed_mirror);
 		}
 	}
 
@@ -2535,7 +2534,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 			if (ret)
 				uptodate = 0;
 			else
-				clean_io_failure(start, page);
+				clean_io_failure(inode, start, page, 0);
 		}
 
 		if (likely(uptodate))
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 4366453..7662eaa 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -341,9 +341,9 @@ struct bio *btrfs_bio_clone(struct bio *bio, gfp_t gfp_mask);
 
 struct btrfs_fs_info;
 
-int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
-			u64 length, u64 logical, struct page *page,
-			unsigned int pg_offset, int mirror_num);
+int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
+		      struct page *page, unsigned int pg_offset,
+		      int mirror_num);
 int end_extent_writepage(struct page *page, int err, u64 start, u64 end);
 int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 			 int mirror_num);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 0609245..149a528 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -681,8 +681,7 @@ static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *fixup_ctx)
 			ret = -EIO;
 			goto out;
 		}
-		fs_info = BTRFS_I(inode)->root->fs_info;
-		ret = repair_io_failure(fs_info, offset, PAGE_SIZE,
+		ret = repair_io_failure(inode, offset, PAGE_SIZE,
 					fixup->logical, page,
 					offset - page_offset(page),
 					fixup->mirror_num);
-- 
1.9.3

