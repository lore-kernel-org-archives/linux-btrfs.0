Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33811 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934408AbdBQOoT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 09:44:19 -0500
Received: by mail-wr0-f193.google.com with SMTP id c4so5516988wrd.1
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Feb 2017 06:44:18 -0800 (PST)
From: Nikolay Borisov <n.borisov.lkml@gmail.com>
To: dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 26/38] btrfs: make repair_io_failure take btrfs_inode
Date: Fri, 17 Feb 2017 16:43:17 +0200
Message-Id: <1487342609-20652-27-git-send-email-nborisov@suse.com>
In-Reply-To: <1487342609-20652-1-git-send-email-nborisov@suse.com>
References: <1487342609-20652-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent_io.c | 10 +++++-----
 fs/btrfs/extent_io.h |  4 ++--
 fs/btrfs/scrub.c     |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0e73e48a9c4c..a405f63f7053 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1992,10 +1992,10 @@ int free_io_failure(struct btrfs_inode *inode, struct io_failure_record *rec)
  * currently, there can be no more than two copies of every data bit. thus,
  * exactly one rewrite is required.
  */
-int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
+int repair_io_failure(struct btrfs_inode *inode, u64 start, u64 length, u64 logical,
 		      struct page *page, unsigned int pg_offset, int mirror_num)
 {
-	struct btrfs_fs_info *fs_info = BTRFS_I(inode)->root->fs_info;
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct bio *bio;
 	struct btrfs_device *dev;
 	u64 map_length = 0;
@@ -2054,7 +2054,7 @@ int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
 
 	btrfs_info_rl_in_rcu(fs_info,
 		"read error corrected: ino %llu off %llu (dev %s sector %llu)",
-				  btrfs_ino(BTRFS_I(inode)), start,
+				  btrfs_ino(inode), start,
 				  rcu_str_deref(dev->name), sector);
 	btrfs_bio_counter_dec(fs_info);
 	bio_put(bio);
@@ -2074,7 +2074,7 @@ int repair_eb_io_failure(struct btrfs_fs_info *fs_info,
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = eb->pages[i];
 
-		ret = repair_io_failure(fs_info->btree_inode, start,
+		ret = repair_io_failure(BTRFS_I(fs_info->btree_inode), start,
 					PAGE_SIZE, start, p,
 					start - page_offset(p), mirror_num);
 		if (ret)
@@ -2133,7 +2133,7 @@ int clean_io_failure(struct inode *inode, u64 start, struct page *page,
 		num_copies = btrfs_num_copies(fs_info, failrec->logical,
 					      failrec->len);
 		if (num_copies > 1)  {
-			repair_io_failure(inode, start, failrec->len,
+			repair_io_failure(BTRFS_I(inode), start, failrec->len,
 					  failrec->logical, page,
 					  pg_offset, failrec->failed_mirror);
 		}
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 5b4132a9093a..a3b13b4385bc 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -451,8 +451,9 @@ struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs);
 struct bio *btrfs_bio_clone(struct bio *bio, gfp_t gfp_mask);
 
 struct btrfs_fs_info;
+struct btrfs_inode;
 
-int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
+int repair_io_failure(struct btrfs_inode *inode, u64 start, u64 length, u64 logical,
 		      struct page *page, unsigned int pg_offset,
 		      int mirror_num);
 int clean_io_failure(struct inode *inode, u64 start, struct page *page,
@@ -480,7 +481,6 @@ struct io_failure_record {
 	int in_validation;
 };
 
-struct btrfs_inode;
 
 void btrfs_free_io_failure_record(struct inode *inode, u64 start, u64 end);
 int btrfs_get_io_failure_record(struct inode *inode, u64 start, u64 end,
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 82d873406aa3..bdf58b0eaef8 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -731,7 +731,7 @@ static int scrub_fixup_readpage(u64 inum, u64 offset, u64 root, void *fixup_ctx)
 			ret = -EIO;
 			goto out;
 		}
-		ret = repair_io_failure(inode, offset, PAGE_SIZE,
+		ret = repair_io_failure(BTRFS_I(inode), offset, PAGE_SIZE,
 					fixup->logical, page,
 					offset - page_offset(page),
 					fixup->mirror_num);
-- 
2.7.4

