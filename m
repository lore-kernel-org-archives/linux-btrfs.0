Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:33652 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab2IYSXJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 14:23:09 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id hTH5EbXkvHC5jREZ (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 25 Sep 2012 12:22:56 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: do not async metadata csumming in certain situations
Date: Tue, 25 Sep 2012 14:28:28 -0400
Message-ID: <1348597708-20039-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are a coule scenarios where farming metadata csumming off to an async
thread doesn't help.  The first is if our processor supports crc32c, in
which case the csumming will be fast and so the overhead of the async model
is not worth the cost.  The other case is for our tree log.  We will be
making that stuff dirty and writing it out and waiting for it immediately.
Even with software crc32c this gives me a ~15% increase in speed with O_SYNC
workloads.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/disk-io.c   |   19 +++++++++++++++++++
 fs/btrfs/extent_io.c |   14 ++++++++++++--
 fs/btrfs/extent_io.h |    1 +
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dcaf556..c47a3ae 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -31,6 +31,7 @@
 #include <linux/migrate.h>
 #include <linux/ratelimit.h>
 #include <asm/unaligned.h>
+#include <asm/cpufeature.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -859,10 +860,22 @@ static int __btree_submit_bio_done(struct inode *inode, int rw, struct bio *bio,
 	return btrfs_map_bio(BTRFS_I(inode)->root, rw, bio, mirror_num, 1);
 }
 
+static int check_async_write(struct inode *inode, unsigned long bio_flags)
+{
+	if (bio_flags & EXTENT_BIO_TREE_LOG)
+		return 0;
+#ifdef CONFIG_X86
+	if (cpu_has_xmm4_2)
+		return 0;
+#endif
+	return 1;
+}
+
 static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags,
 				 u64 bio_offset)
 {
+	int async = check_async_write(inode, bio_flags);
 	int ret;
 
 	if (!(rw & REQ_WRITE)) {
@@ -877,6 +890,12 @@ static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 			return ret;
 		return btrfs_map_bio(BTRFS_I(inode)->root, rw, bio,
 				     mirror_num, 0);
+	} else if (!async) {
+		ret = btree_csum_one_bio(bio);
+		if (ret)
+			return ret;
+		return btrfs_map_bio(BTRFS_I(inode)->root, rw, bio,
+				     mirror_num, 0);
 	}
 
 	/*
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 263c392..8f0f03b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -45,6 +45,7 @@ struct extent_page_data {
 	struct bio *bio;
 	struct extent_io_tree *tree;
 	get_extent_t *get_extent;
+	unsigned long bio_flags;
 
 	/* tells writepage not to lock the state bits for this range
 	 * it still does the unlocking
@@ -3163,12 +3164,16 @@ static int write_one_eb(struct extent_buffer *eb,
 	struct block_device *bdev = fs_info->fs_devices->latest_bdev;
 	u64 offset = eb->start;
 	unsigned long i, num_pages;
+	unsigned long bio_flags = 0;
 	int rw = (epd->sync_io ? WRITE_SYNC : WRITE);
 	int ret = 0;
 
 	clear_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
 	num_pages = num_extent_pages(eb->start, eb->len);
 	atomic_set(&eb->io_pages, num_pages);
+	if (btrfs_header_owner(eb) == BTRFS_TREE_LOG_OBJECTID)
+		bio_flags = EXTENT_BIO_TREE_LOG;
+
 	for (i = 0; i < num_pages; i++) {
 		struct page *p = extent_buffer_page(eb, i);
 
@@ -3177,7 +3182,8 @@ static int write_one_eb(struct extent_buffer *eb,
 		ret = submit_extent_page(rw, eb->tree, p, offset >> 9,
 					 PAGE_CACHE_SIZE, 0, bdev, &epd->bio,
 					 -1, end_bio_extent_buffer_writepage,
-					 0, 0, 0);
+					 0, epd->bio_flags, bio_flags);
+		epd->bio_flags = bio_flags;
 		if (ret) {
 			set_bit(EXTENT_BUFFER_IOERR, &eb->bflags);
 			SetPageError(p);
@@ -3212,6 +3218,7 @@ int btree_write_cache_pages(struct address_space *mapping,
 		.tree = tree,
 		.extent_locked = 0,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
+		.bio_flags = 0,
 	};
 	int ret = 0;
 	int done = 0;
@@ -3474,7 +3481,7 @@ static void flush_epd_write_bio(struct extent_page_data *epd)
 		if (epd->sync_io)
 			rw = WRITE_SYNC;
 
-		ret = submit_one_bio(rw, epd->bio, 0, 0);
+		ret = submit_one_bio(rw, epd->bio, 0, epd->bio_flags);
 		BUG_ON(ret < 0); /* -ENOMEM */
 		epd->bio = NULL;
 	}
@@ -3497,6 +3504,7 @@ int extent_write_full_page(struct extent_io_tree *tree, struct page *page,
 		.get_extent = get_extent,
 		.extent_locked = 0,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
+		.bio_flags = 0,
 	};
 
 	ret = __extent_writepage(page, wbc, &epd);
@@ -3521,6 +3529,7 @@ int extent_write_locked_range(struct extent_io_tree *tree, struct inode *inode,
 		.get_extent = get_extent,
 		.extent_locked = 1,
 		.sync_io = mode == WB_SYNC_ALL,
+		.bio_flags = 0,
 	};
 	struct writeback_control wbc_writepages = {
 		.sync_mode	= mode,
@@ -3560,6 +3569,7 @@ int extent_writepages(struct extent_io_tree *tree,
 		.get_extent = get_extent,
 		.extent_locked = 0,
 		.sync_io = wbc->sync_mode == WB_SYNC_ALL,
+		.bio_flags = 0,
 	};
 
 	ret = extent_write_cache_pages(tree, mapping, wbc,
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 512f8da..a69dea2 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -27,6 +27,7 @@
  * type for this bio
  */
 #define EXTENT_BIO_COMPRESSED 1
+#define EXTENT_BIO_TREE_LOG 2
 #define EXTENT_BIO_FLAG_SHIFT 16
 
 /* these are bit numbers for test/set bit */
-- 
1.7.7.6

