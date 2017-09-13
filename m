Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28146 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751892AbdIMTU0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 15:20:26 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8DJKQTK031781
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 19:20:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v8DJKPtX000834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 19:20:26 GMT
Received: from ubhmp0008.oracle.com (ubhmp0008.oracle.com [156.151.24.61])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v8DJKPLu028610
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Sep 2017 19:20:25 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2 v2] Btrfs: remove bio_flags which indicates a meta block of log-tree
Date: Wed, 13 Sep 2017 12:18:22 -0600
Message-Id: <20170913181822.26992-1-bo.li.liu@oracle.com>
In-Reply-To: <20170821215000.2987-2-bo.li.liu@oracle.com>
References: <20170821215000.2987-2-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since both committing transaction and writing log-tree are doing
plugging on metadata IO, we can unify to use %sync_writers to benefit
both cases, instead of checking bio_flags while writing meta blocks of
log-tree.

We can remove this bio_flags because in order to write dirty blocks,
log tree also uses btrfs_write_marked_extents(), inside which we
has enabled %sync_writers, therefore, every write goes in a
synchronous way, so does checksuming.

Please also note that, bio_flags is applied per-context while
%sync_writers is applied per-inode, so this might incur some overhead, ie.

1) while log tree is flushing its dirty blocks via
   btrfs_write_marked_extents(), in which %sync_writers is increased
   by one.

2) in the meantime, some writeback operations may happen upon btrfs's
   metadata inode, so these writes go synchronously, too.

However, AFAICS, the overhead is not a big one while the win is that
we unify the two places that needs synchronous way and remove a
special hack/flag.

This removes the bio_flags related stuff for writing log-tree.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---

v2: Improve the commit log to offer more details why this change makes
    sense.

 fs/btrfs/disk-io.c   |  6 ++----
 fs/btrfs/extent_io.c | 13 ++-----------
 fs/btrfs/extent_io.h |  1 -
 3 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8d097ba..b0e353e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1005,12 +1005,10 @@ static blk_status_t __btree_submit_bio_done(void *private_data, struct bio *bio,
 	return ret;
 }
 
-static int check_async_write(struct btrfs_inode *bi, unsigned long bio_flags)
+static int check_async_write(struct btrfs_inode *bi)
 {
 	if (atomic_read(&bi->sync_writers))
 		return 0;
-	if (bio_flags & EXTENT_BIO_TREE_LOG)
-		return 0;
 #ifdef CONFIG_X86
 	if (static_cpu_has(X86_FEATURE_XMM4_2))
 		return 0;
@@ -1024,7 +1022,7 @@ static blk_status_t btree_submit_bio_hook(void *private_data, struct bio *bio,
 {
 	struct inode *inode = private_data;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	int async = check_async_write(BTRFS_I(inode), bio_flags);
+	int async = check_async_write(BTRFS_I(inode));
 	blk_status_t ret;
 
 	if (bio_op(bio) != REQ_OP_WRITE) {
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0aff9b2..b61d68f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -110,7 +110,6 @@ struct extent_page_data {
 	struct bio *bio;
 	struct extent_io_tree *tree;
 	get_extent_t *get_extent;
-	unsigned long bio_flags;
 
 	/* tells writepage not to lock the state bits for this range
 	 * it still does the unlocking
@@ -3713,7 +3712,6 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 	u64 offset = eb->start;
 	u32 nritems;
 	unsigned long i, num_pages;
-	unsigned long bio_flags = 0;
 	unsigned long start, end;
 	int write_flags = (epd->sync_io ? REQ_SYNC : 0) | REQ_META;
 	int ret = 0;
@@ -3721,8 +3719,6 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 	clear_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags);
 	num_pages = num_extent_pages(eb->start, eb->len);
 	atomic_set(&eb->io_pages, num_pages);
-	if (btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID)
-		bio_flags = EXTENT_BIO_TREE_LOG;
 
 	/* set btree blocks beyond nritems with 0 to avoid stale content. */
 	nritems = btrfs_header_nritems(eb);
@@ -3749,8 +3745,7 @@ static noinline_for_stack int write_one_eb(struct extent_buffer *eb,
 					 p, offset >> 9, PAGE_SIZE, 0, bdev,
 					 &epd->bio,
 					 end_bio_extent_buffer_writepage,
-					 0, epd->bio_flags, bio_flags, false);
-		epd->bio_flags = bio_flags;
+					 0, 0, 0, false);
 		if (ret) {
 			set_btree_ioerr(p);
 			if (PageWriteback(p))
@@ -3787,7 +3782,6 @@ int btree_write_cache_pages(struct address_space *mapping,
 		.tree = tree,
 		.extent_locked = 0,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
-		.bio_flags = 0,
 	};
 	int ret = 0;
 	int done = 0;
@@ -4063,7 +4057,7 @@ static void flush_epd_write_bio(struct extent_page_data *epd)
 		bio_set_op_attrs(epd->bio, REQ_OP_WRITE,
 				 epd->sync_io ? REQ_SYNC : 0);
 
-		ret = submit_one_bio(epd->bio, 0, epd->bio_flags);
+		ret = submit_one_bio(epd->bio, 0, 0);
 		BUG_ON(ret < 0); /* -ENOMEM */
 		epd->bio = NULL;
 	}
@@ -4086,7 +4080,6 @@ int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
 		.get_extent = get_extent,
 		.extent_locked = 0,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
-		.bio_flags = 0,
 	};
 
 	ret = __extent_writepage(page, wbc, &epd);
@@ -4111,7 +4104,6 @@ int extent_write_locked_range(struct extent_io_tree *tree, struct inode *inode,
 		.get_extent = get_extent,
 		.extent_locked = 1,
 		.sync_io = mode == WB_SYNC_ALL,
-		.bio_flags = 0,
 	};
 	struct writeback_control wbc_writepages = {
 		.sync_mode	= mode,
@@ -4151,7 +4143,6 @@ int extent_writepages(struct extent_io_tree *tree,
 		.get_extent = get_extent,
 		.extent_locked = 0,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
-		.bio_flags = 0,
 	};
 
 	ret = extent_write_cache_pages(mapping, wbc, __extent_writepage, &epd,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 4f03091..353dd3b 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -33,7 +33,6 @@
  * type for this bio
  */
 #define EXTENT_BIO_COMPRESSED 1
-#define EXTENT_BIO_TREE_LOG 2
 #define EXTENT_BIO_FLAG_SHIFT 16
 
 /* these are bit numbers for test/set bit */
-- 
2.9.4

