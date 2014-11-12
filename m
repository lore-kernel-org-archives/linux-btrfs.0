Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:51646 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaKLISz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 03:18:55 -0500
Received: from /spool/local
	by e23smtp08.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 12 Nov 2014 18:18:54 +1000
Received: from d23relay07.au.ibm.com (d23relay07.au.ibm.com [9.190.26.37])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id F2E3E2BB0047
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 19:18:52 +1100 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay07.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sAC8IcrS39321794
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 19:18:38 +1100
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sAC8Ipo5009366
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 19:18:52 +1100
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, bo.li.liu@oracle.com, dsterba@suse.cz
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        aneesh.kumar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org,
        chandan@mykolab.com, steve.capper@linaro.org
Subject: [RFC PATCH V8 16/16] Btrfs: subpagesize-blocksize: Track blocks of ordered extent submitted for write I/O.
Date: Wed, 12 Nov 2014 13:47:48 +0530
Message-Id: <1415780268-2017-17-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1415780268-2017-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1415780268-2017-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the subpagesize-blocksize scenario, the following command (with 4k as the
PAGE_SIZE and 2k as the block size) can cause false accounting of blocks of an
ordered extent that is written to disk:

$ xfs_io -f -c "pwrite 0 10240" \
-c "sync_range 0 4096" \
-c "sync_range 8192 2048" \
-c "pwrite 10240 2048" \
-c "sync_range 10240 2048" \
/mnt/btrfs/file.bin

To fix this, we would have to explicitly track the blocks of an ordered extent
that have already been submitted for write I/O.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/btrfs/extent_io.c    | 24 ++++++++++++++++++++++--
 fs/btrfs/ordered-data.c |  4 +++-
 fs/btrfs/ordered-data.h |  4 ++++
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 168252e..3649c5d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3201,6 +3201,8 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 	u64 extent_offset;
 	u64 extent_end;
 	u64 iosize;
+	u64 blk, nr_blks;
+	u64 blk_submitted;
 	sector_t sector;
 	struct extent_state *cached_state = NULL;
 	struct block_device *bdev;
@@ -3267,11 +3269,26 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 		iosize = min(extent_end - cur, end - cur + 1);
 		iosize = ALIGN(iosize, blocksize);
 
+		blk = extent_offset >> inode->i_sb->s_blocksize_bits;
+		nr_blks = iosize >> inode->i_sb->s_blocksize_bits;
+
+		blk_submitted = find_next_bit(ordered->blocks_submitted,
+					ordered->len >> inode->i_sb->s_blocksize_bits,
+					blk);
+		if (blk_submitted < blk + nr_blks) {
+			if (blk_submitted == blk) {
+				cur += blocksize;
+				btrfs_put_ordered_extent(ordered);
+				continue;
+			}
+			iosize = (blk_submitted - blk)
+				<< inode->i_sb->s_blocksize_bits;
+			nr_blks = iosize >> inode->i_sb->s_blocksize_bits;
+		}
+
 		sector = (ordered->start + extent_offset) >> 9;
 		bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
 		compressed = test_bit(BTRFS_ORDERED_COMPRESSED, &ordered->flags);
-		btrfs_put_ordered_extent(ordered);
-		ordered = NULL;
 
 		/*
 		 * compressed and inline extents are written through other
@@ -3284,6 +3301,7 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
  			 */
 			nr++;
 			cur += iosize;
+			btrfs_put_ordered_extent(ordered);
 			continue;
 		}
 
@@ -3298,6 +3316,8 @@ static noinline_for_stack int __extent_writepage_io(struct inode *inode,
 		} else {
 			unsigned long max_nr = (i_size >> PAGE_CACHE_SHIFT) + 1;
 
+			bitmap_set(ordered->blocks_submitted, blk, nr_blks);
+			btrfs_put_ordered_extent(ordered);
 			set_range_writeback(tree, cur, cur + iosize - 1);
 			if (!PageWriteback(page)) {
 				btrfs_err(BTRFS_I(inode)->root->fs_info,
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 4d9832f..59b2544 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -199,13 +199,15 @@ static int __btrfs_add_ordered_extent(struct inode *inode, u64 file_offset,
 	nr_longs = BITS_TO_LONGS(len >> inode->i_sb->s_blocksize_bits);
 	if (nr_longs == 1) {
 		entry->blocks_done = &entry->blocks_bitmap;
+		entry->blocks_submitted = &entry->blocks_submitted_bitmap;
 	} else {
-		entry->blocks_done = kzalloc(nr_longs * sizeof(unsigned long),
+		entry->blocks_done = kzalloc(2 * nr_longs * sizeof(unsigned long),
 					GFP_NOFS);
 		if (!entry->blocks_done) {
 			kmem_cache_free(btrfs_ordered_extent_cache, entry);
 			return -ENOMEM;
 		}
+		entry->blocks_submitted = entry->blocks_done + nr_longs;
 	}
 
 	entry->file_offset = file_offset;
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 7de3b1e..851914c 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -139,6 +139,10 @@ struct btrfs_ordered_extent {
 	/* bitmap to track the blocks that have been written to disk */
 	unsigned long *blocks_done;
 	unsigned long blocks_bitmap;
+
+	/* bitmap to track the blocks that have been submitted for write i/o */
+	unsigned long *blocks_submitted;
+	unsigned long blocks_submitted_bitmap;
 };
 
 /*
-- 
2.1.0

