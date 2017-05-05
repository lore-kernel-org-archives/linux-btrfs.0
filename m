Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:33093 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752087AbdEEP5W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 May 2017 11:57:22 -0400
Received: by mail-yb0-f196.google.com with SMTP id d72so341816ybh.0
        for <linux-btrfs@vger.kernel.org>; Fri, 05 May 2017 08:57:21 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 2/3] btrfs: remove inode argument from repair_io_failure
Date: Fri,  5 May 2017 11:57:14 -0400
Message-Id: <1493999835-26731-3-git-send-email-jbacik@fb.com>
In-Reply-To: <1493999835-26731-1-git-send-email-jbacik@fb.com>
References: <1493999835-26731-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Once we remove the btree_inode we won't have an inode to pass anymore, just pass
the fs_info directly and the inum since we use that to print out the repair
message.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent_io.c | 16 +++++++---------
 fs/btrfs/extent_io.h |  6 +++---
 fs/btrfs/scrub.c     |  2 +-
 3 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index acc7c68..de6f890 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1972,11 +1972,10 @@ int free_io_failure(struct btrfs_inode *inode, struct io_failure_record *rec)
  * currently, there can be no more than two copies of every data bit. thus,
  * exactly one rewrite is required.
  */
-int repair_io_failure(struct btrfs_inode *inode, u64 start, u64 length,
-		u64 logical, struct page *page,
-		unsigned int pg_offset, int mirror_num)
+int repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
+		      u64 length, u64 logical, struct page *page,
+		      unsigned int pg_offset, int mirror_num)
 {
-	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct bio *bio;
 	struct btrfs_device *dev;
 	u64 map_length = 0;
@@ -2035,7 +2034,7 @@ int repair_io_failure(struct btrfs_inode *inode, u64 start, u64 length,
 
 	btrfs_info_rl_in_rcu(fs_info,
 		"read error corrected: ino %llu off %llu (dev %s sector %llu)",
-				  btrfs_ino(inode), start,
+				  ino, start,
 				  rcu_str_deref(dev->name), sector);
 	btrfs_bio_counter_dec(fs_info);
 	bio_put(bio);
@@ -2055,8 +2054,7 @@ int repair_eb_io_failure(struct btrfs_fs_info *fs_info,
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = eb->pages[i];
 
-		ret = repair_io_failure(BTRFS_I(fs_info->btree_inode), start,
-					PAGE_SIZE, start, p,
+		ret = repair_io_failure(fs_info, 0, start, PAGE_SIZE, start, p,
 					start - page_offset(p), mirror_num);
 		if (ret)
 			break;
@@ -2114,8 +2112,8 @@ int clean_io_failure(struct btrfs_inode *inode, u64 start, struct page *page,
 		num_copies = btrfs_num_copies(fs_info, failrec->logical,
 					      failrec->len);
 		if (num_copies > 1)  {
-			repair_io_failure(inode, start, failrec->len,
-					  failrec->logical, page,
+			repair_io_failure(fs_info, btrfs_ino(inode), start,
+					  failrec->len, failrec->logical, page,
 					  pg_offset, failrec->failed_mirror);
 		}
 	}
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index e4e01d1..fd04124 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -467,9 +467,9 @@ struct bio *btrfs_bio_clone(struct bio *bio, gfp_t gfp_mask);
 struct btrfs_fs_info;
 struct btrfs_inode;
 
-int repair_io_failure(struct btrfs_inode *inode, u64 start, u64 length,
-		u64 logical, struct page *page,
-		unsigned int pg_offset, int mirror_num);
+int repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
+		      u64 length, u64 logical, struct page *page,
+		      unsigned int pg_offset, int mirror_num);
 int clean_io_failure(struct btrfs_inode *inode, u64 start,
 		struct page *page, unsigned int pg_offset);
 void end_extent_writepage(struct page *page, int err, u64 start, u64 end);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index b0251eb..594d5c4 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -731,7 +731,7 @@ static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *fixup_ctx)
 			ret = -EIO;
 			goto out;
 		}
-		ret = repair_io_failure(BTRFS_I(inode), offset, PAGE_SIZE,
+		ret = repair_io_failure(fs_info, inum, offset, PAGE_SIZE,
 					fixup->logical, page,
 					offset - page_offset(page),
 					fixup->mirror_num);
-- 
2.7.4

