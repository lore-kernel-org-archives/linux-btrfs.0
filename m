Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5324 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752753AbaILKmU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 06:42:20 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s8CAgSNV017338
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Sep 2014 18:42:28 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v4 07/11] Btrfs: modify repair_io_failure and make it suit direct io
Date: Fri, 12 Sep 2014 18:44:00 +0800
Message-ID: <1410518644-31806-8-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1410518644-31806-1-git-send-email-miaox@cn.fujitsu.com>
References: <5405C08B.9020009@fb.com>
 <1410518644-31806-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The original code of repair_io_failure was just used for buffered read,
because it got some filesystem data from page structure, it is safe for
the page in the page cache. But when we do a direct read, the pages in bio
are not in the page cache, that is there is no filesystem data in the page
structure. In order to implement direct read data repair, we need modify
repair_io_failure and pass all filesystem data it need by function
parameters.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v4:
- None
---
 fs/btrfs/extent_io.c | 8 +++++---
 fs/btrfs/extent_io.h | 2 +-
 fs/btrfs/scrub.c     | 1 +
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index cf1de40..9fbc005 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1997,7 +1997,7 @@ static int free_io_failure(struct inode *inode, struct io_failure_record *rec)
  */
 int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 			u64 length, u64 logical, struct page *page,
-			int mirror_num)
+			unsigned int pg_offset, int mirror_num)
 {
 	struct bio *bio;
 	struct btrfs_device *dev;
@@ -2036,7 +2036,7 @@ int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 		return -EIO;
 	}
 	bio->bi_bdev = dev->bdev;
-	bio_add_page(bio, page, length, start - page_offset(page));
+	bio_add_page(bio, page, length, pg_offset);
 
 	if (btrfsic_submit_bio_wait(WRITE_SYNC, bio)) {
 		/* try to remap that extent elsewhere? */
@@ -2067,7 +2067,8 @@ int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = extent_buffer_page(eb, i);
 		ret = repair_io_failure(root->fs_info, start, PAGE_CACHE_SIZE,
-					start, p, mirror_num);
+					start, p, start - page_offset(p),
+					mirror_num);
 		if (ret)
 			break;
 		start += PAGE_CACHE_SIZE;
@@ -2127,6 +2128,7 @@ static int clean_io_failure(u64 start, struct page *page)
 		if (num_copies > 1)  {
 			repair_io_failure(fs_info, start, failrec->len,
 					  failrec->logical, page,
+					  start - page_offset(page),
 					  failrec->failed_mirror);
 		}
 	}
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 75b621b..a82ecbc 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -340,7 +340,7 @@ struct btrfs_fs_info;
 
 int repair_io_failure(struct btrfs_fs_info *fs_info, u64 start,
 			u64 length, u64 logical, struct page *page,
-			int mirror_num);
+			unsigned int pg_offset, int mirror_num);
 int end_extent_writepage(struct page *page, int err, u64 start, u64 end);
 int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 			 int mirror_num);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index cce122b..3978529 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -682,6 +682,7 @@ static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *fixup_ctx)
 		fs_info = BTRFS_I(inode)->root->fs_info;
 		ret = repair_io_failure(fs_info, offset, PAGE_SIZE,
 					fixup->logical, page,
+					offset - page_offset(page),
 					fixup->mirror_num);
 		unlock_page(page);
 		corrected = !ret;
-- 
1.9.3

