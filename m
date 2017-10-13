Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47667 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751081AbdJMWMh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 18:12:37 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9DMCaj3000363
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 22:12:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v9DMCZGO006701
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 22:12:35 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9DMCZUf007179
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 22:12:35 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: add write_flags for compression bio
Date: Fri, 13 Oct 2017 15:10:35 -0600
Message-Id: <20171013211035.26765-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Compression code path has only flaged bios with REQ_OP_WRITE no matter
where the bios come from.  This breaks the rule that sync writes and
writeback writes need to be differentiated from each other.

This passes writeback_control to compression write path so that it can
send bios with proper flags to block layer.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/compression.c |  7 ++++---
 fs/btrfs/compression.h |  3 ++-
 fs/btrfs/extent_io.c   |  2 +-
 fs/btrfs/extent_io.h   |  3 ++-
 fs/btrfs/inode.c       | 15 +++++++++++----
 5 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 280384b..3dae2f5 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -292,7 +292,8 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
 				 unsigned long len, u64 disk_start,
 				 unsigned long compressed_len,
 				 struct page **compressed_pages,
-				 unsigned long nr_pages)
+				 unsigned long nr_pages,
+				 unsigned int write_flags)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct bio *bio = NULL;
@@ -324,7 +325,7 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	bdev = fs_info->fs_devices->latest_bdev;
 
 	bio = btrfs_bio_alloc(bdev, first_byte);
-	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+	bio->bi_opf = REQ_OP_WRITE | write_flags;
 	bio->bi_private = cb;
 	bio->bi_end_io = end_compressed_bio_write;
 	refcount_set(&cb->pending_bios, 1);
@@ -371,7 +372,7 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
 			bio_put(bio);
 
 			bio = btrfs_bio_alloc(bdev, first_byte);
-			bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+			bio->bi_opf = REQ_OP_WRITE | write_flags;
 			bio->bi_private = cb;
 			bio->bi_end_io = end_compressed_bio_write;
 			bio_add_page(bio, page, PAGE_SIZE, 0);
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index d2781ff..dc45b94 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -91,7 +91,8 @@ blk_status_t btrfs_submit_compressed_write(struct inode *inode, u64 start,
 				  unsigned long len, u64 disk_start,
 				  unsigned long compressed_len,
 				  struct page **compressed_pages,
-				  unsigned long nr_pages);
+				  unsigned long nr_pages,
+				  unsigned int write_flags);
 blk_status_t btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags);
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3e5bb0c..ea64ad0 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3252,7 +3252,7 @@ static noinline_for_stack int writepage_delalloc(struct inode *inode,
 					       delalloc_start,
 					       delalloc_end,
 					       &page_started,
-					       nr_written);
+					       nr_written, wbc);
 		/* File system has been set read-only */
 		if (ret) {
 			SetPageError(page);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index faffa28..a92fd98 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -116,7 +116,8 @@ struct extent_io_ops {
 	 */
 	int (*fill_delalloc)(void *private_data, struct page *locked_page,
 			     u64 start, u64 end, int *page_started,
-			     unsigned long *nr_written);
+			     unsigned long *nr_written,
+			     struct writeback_control *wbc);
 
 	int (*writepage_start_hook)(struct page *page, u64 start, u64 end);
 	void (*writepage_end_io_hook)(struct page *page, u64 start, u64 end,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 128f3e5..ee67773 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -367,6 +367,7 @@ struct async_cow {
 	struct page *locked_page;
 	u64 start;
 	u64 end;
+	unsigned int write_flags;
 	struct list_head extents;
 	struct btrfs_work work;
 };
@@ -846,7 +847,8 @@ static noinline void submit_compressed_extents(struct inode *inode,
 				    async_extent->ram_size,
 				    ins.objectid,
 				    ins.offset, async_extent->pages,
-				    async_extent->nr_pages)) {
+				    async_extent->nr_pages,
+				    async_cow->write_flags)) {
 			struct extent_io_tree *tree = &BTRFS_I(inode)->io_tree;
 			struct page *p = async_extent->pages[0];
 			const u64 start = async_extent->start;
@@ -1176,7 +1178,8 @@ static noinline void async_cow_free(struct btrfs_work *work)
 
 static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 				u64 start, u64 end, int *page_started,
-				unsigned long *nr_written)
+				unsigned long *nr_written,
+				unsigned int write_flags)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct async_cow *async_cow;
@@ -1193,6 +1196,7 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 		async_cow->root = root;
 		async_cow->locked_page = locked_page;
 		async_cow->start = start;
+		async_cow->write_flags = write_flags;
 
 		if (BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS &&
 		    !btrfs_test_opt(fs_info, FORCE_COMPRESS))
@@ -1569,11 +1573,13 @@ static inline int need_force_cow(struct inode *inode, u64 start, u64 end)
  */
 static int run_delalloc_range(void *private_data, struct page *locked_page,
 			      u64 start, u64 end, int *page_started,
-			      unsigned long *nr_written)
+			      unsigned long *nr_written,
+			      struct writeback_control *wbc)
 {
 	struct inode *inode = private_data;
 	int ret;
 	int force_cow = need_force_cow(inode, start, end);
+	unsigned int write_flags = wbc_to_write_flags(wbc);
 
 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW && !force_cow) {
 		ret = run_delalloc_nocow(inode, locked_page, start, end,
@@ -1588,7 +1594,8 @@ static int run_delalloc_range(void *private_data, struct page *locked_page,
 		set_bit(BTRFS_INODE_HAS_ASYNC_EXTENT,
 			&BTRFS_I(inode)->runtime_flags);
 		ret = cow_file_range_async(inode, locked_page, start, end,
-					   page_started, nr_written);
+					   page_started, nr_written,
+					   write_flags);
 	}
 	if (ret)
 		btrfs_cleanup_ordered_extents(inode, start, end - start + 1);
-- 
2.9.4

