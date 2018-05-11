Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:35735 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752309AbeEKGa3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 02:30:29 -0400
Received: by mail-pl0-f65.google.com with SMTP id i5-v6so2721443plt.2
        for <linux-btrfs@vger.kernel.org>; Thu, 10 May 2018 23:30:29 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: kernel-team@fb.com
Subject: [PATCH 3/3] Btrfs: stop abusing current->journal_info in btrfs_direct_IO()
Date: Thu, 10 May 2018 23:30:12 -0700
Message-Id: <23547c262a1b96459496e6e4073f1ef04f52feca.1525933432.git.osandov@fb.com>
In-Reply-To: <cover.1525933432.git.osandov@fb.com>
References: <cover.1525933432.git.osandov@fb.com>
In-Reply-To: <cover.1525933432.git.osandov@fb.com>
References: <cover.1525933432.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Now that we can pass around the struct btrfs_dio_data through the
different callbacks generically, we don't need to shove it in
current->journal_info.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 33 +++++++--------------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 46e3d366df8b..3673c0420509 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7574,7 +7574,7 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct extent_map *em;
 	struct extent_state *cached_state = NULL;
-	struct btrfs_dio_data *dio_data = NULL;
+	struct btrfs_dio_data *dio_data = bh_result->b_private;
 	u64 start = iblock << inode->i_blkbits;
 	u64 lockstart, lockend;
 	u64 len = bh_result->b_size;
@@ -7589,25 +7589,13 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 	lockstart = start;
 	lockend = start + len - 1;
 
-	if (current->journal_info) {
-		/*
-		 * Need to pull our outstanding extents and set journal_info to NULL so
-		 * that anything that needs to check if there's a transaction doesn't get
-		 * confused.
-		 */
-		dio_data = current->journal_info;
-		current->journal_info = NULL;
-	}
-
 	/*
 	 * If this errors out it's because we couldn't invalidate pagecache for
 	 * this range and we need to fallback to buffered.
 	 */
 	if (lock_extent_direct(inode, lockstart, lockend, &cached_state,
-			       create)) {
-		ret = -ENOTBLK;
-		goto err;
-	}
+			       create))
+		return -ENOTBLK;
 
 	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, start, len, 0);
 	if (IS_ERR(em)) {
@@ -7732,7 +7720,6 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 		WARN_ON(dio_data->reserve < len);
 		dio_data->reserve -= len;
 		dio_data->unsubmitted_oe_range_end = start + len;
-		current->journal_info = dio_data;
 	}
 
 	/*
@@ -7755,9 +7742,6 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 unlock_err:
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 			 unlock_bits, 1, 0, &cached_state);
-err:
-	if (dio_data)
-		current->journal_info = dio_data;
 	return ret;
 }
 
@@ -8460,7 +8444,7 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 	 * time by btrfs_direct_IO().
 	 */
 	if (write) {
-		struct btrfs_dio_data *dio_data = current->journal_info;
+		struct btrfs_dio_data *dio_data = private;
 
 		dio_data->unsubmitted_oe_range_end = dip->logical_offset +
 			dip->bytes;
@@ -8602,13 +8586,11 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		/*
 		 * We need to know how many extents we reserved so that we can
 		 * do the accounting properly if we go over the number we
-		 * originally calculated.  Abuse current->journal_info for this.
+		 * originally calculated.
 		 */
-		dio_data.reserve = round_up(count,
-					    fs_info->sectorsize);
+		dio_data.reserve = round_up(count, fs_info->sectorsize);
 		dio_data.unsubmitted_oe_range_start = (u64)offset;
 		dio_data.unsubmitted_oe_range_end = (u64)offset;
-		current->journal_info = &dio_data;
 		down_read(&BTRFS_I(inode)->dio_sem);
 	} else if (test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
 				     &BTRFS_I(inode)->runtime_flags)) {
@@ -8620,10 +8602,9 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	ret = __blockdev_direct_IO(iocb, inode,
 				   fs_info->fs_devices->latest_bdev, iter,
 				   btrfs_get_blocks_direct, NULL,
-				   btrfs_submit_direct, flags, NULL);
+				   btrfs_submit_direct, flags, &dio_data);
 	if (iov_iter_rw(iter) == WRITE) {
 		up_read(&BTRFS_I(inode)->dio_sem);
-		current->journal_info = NULL;
 		if (ret < 0 && ret != -EIOCBQUEUED) {
 			if (dio_data.reserve)
 				btrfs_delalloc_release_space(inode, data_reserved,
-- 
2.17.0

