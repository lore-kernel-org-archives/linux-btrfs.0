Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55951 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932178AbcIBTk7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Sep 2016 15:40:59 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u82JXSqT003058
        for <linux-btrfs@vger.kernel.org>; Fri, 2 Sep 2016 12:40:58 -0700
Received: from maileast.thefacebook.com ([199.201.65.23])
        by mx0a-00082601.pphosted.com with ESMTP id 257dbc0ych-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Sep 2016 12:40:58 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
Subject: [PATCH 2/7] btrfs: remove inode argument from repair_io_failure
Date: Fri, 2 Sep 2016 15:40:01 -0400
Message-ID: <1472845206-22870-3-git-send-email-jbacik@fb.com>
In-Reply-To: <1472845206-22870-1-git-send-email-jbacik@fb.com>
References: <1472845206-22870-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Once we remove the btree_inode we won't have an inode to pass anymore, just pass
the fs_info directly and the inum since we use that to print out the repair
message.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 fs/btrfs/extent_io.c | 14 +++++++-------
 fs/btrfs/extent_io.h |  6 +++---
 fs/btrfs/scrub.c     |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 515b78a..3132f1a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1979,10 +1979,10 @@ int free_io_failure(struct inode *inode, struct io_failure_record *rec)
  * currently, there can be no more than two copies of every data bit. thus,
  * exactly one rewrite is required.
  */
-int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
-		      struct page *page, unsigned int pg_offset, int mirror_num)
+int repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
+		      u64 length, u64 logical, struct page *page,
+		      unsigned int pg_offset, int mirror_num)
 {
-	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
 	struct bio *bio;
 	struct btrfs_device *dev;
 	u64 map_length = 0;
@@ -2041,7 +2041,7 @@ int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
 
 	btrfs_info_rl_in_rcu(fs_info,
 		"read error corrected: ino %llu off %llu (dev %s sector %llu)",
-				  btrfs_ino(inode), start,
+				  ino, start,
 				  rcu_str_deref(dev->name), sector);
 	btrfs_bio_counter_dec(fs_info);
 	bio_put(bio);
@@ -2061,7 +2061,7 @@ int repair_eb_io_failure(struct btrfs_root *root, struct extent_buffer *eb,
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = eb->pages[i];
 
-		ret = repair_io_failure(root->fs_info->btree_inode, start,
+		ret = repair_io_failure(root->fs_info, 0, start,
 					PAGE_SIZE, start, p,
 					start - page_offset(p), mirror_num);
 		if (ret)
@@ -2119,8 +2119,8 @@ int clean_io_failure(struct inode *inode, u64 start, struct page *page,
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
index c3dd064..61adf16 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -426,9 +426,9 @@ struct bio *btrfs_bio_clone(struct bio *bio, gfp_t gfp_mask);
 
 struct btrfs_fs_info;
 
-int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
-		      struct page *page, unsigned int pg_offset,
-		      int mirror_num);
+int repair_io_failure(struct btrfs_fs_info *fs_info, u64 ino, u64 start,
+		      u64 length, u64 logical, struct page *page,
+		      unsigned int pg_offset, int mirror_num);
 int clean_io_failure(struct inode *inode, u64 start, struct page *page,
 		     unsigned int pg_offset);
 void end_extent_writepage(struct page *page, int err, u64 start, u64 end);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 1d195d2..4624283 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -732,7 +732,7 @@ static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *fixup_ctx)
 			ret = -EIO;
 			goto out;
 		}
-		ret = repair_io_failure(inode, offset, PAGE_SIZE,
+		ret = repair_io_failure(fs_info, inum, offset, PAGE_SIZE,
 					fixup->logical, page,
 					offset - page_offset(page),
 					fixup->mirror_num);
-- 
2.7.4

