Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35854 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727206AbeH1Dwa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Aug 2018 23:52:30 -0400
Received: by mail-pl1-f193.google.com with SMTP id e11-v6so320202plb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2018 17:03:36 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: David Sterba <dsterba@suse.com>, kernel-team@fb.com
Subject: [RFC PATCH v2 6/6] Btrfs: stop abusing current->journal_info in btrfs_direct_IO()
Date: Mon, 27 Aug 2018 17:03:19 -0700
Message-Id: <b699f3de489967b942b50d1e6c0a0dc81211e44c.1535414064.git.osandov@fb.com>
In-Reply-To: <cover.1535414064.git.osandov@fb.com>
References: <cover.1535414064.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

Now that we can pass around the struct btrfs_dio_data through the
different callbacks generically, we don't need to shove it in
current->journal_info.

Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/inode.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6efa6a6e3e20..38a41e9d6e93 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7654,7 +7654,6 @@ static int btrfs_get_blocks_direct_write(struct extent_map **map,
 	WARN_ON(dio_data->reserve < len);
 	dio_data->reserve -= len;
 	dio_data->unsubmitted_oe_range_end = start + len;
-	current->journal_info = dio_data;
 out:
 	return ret;
 }
@@ -7666,7 +7665,7 @@ static int btrfs_get_blocks_direct(struct kiocb *iocb, struct inode *inode,
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct extent_map *em;
 	struct extent_state *cached_state = NULL;
-	struct btrfs_dio_data *dio_data = NULL;
+	struct btrfs_dio_data *dio_data = iocb->private;
 	u64 start = iblock << inode->i_blkbits;
 	u64 lockstart, lockend;
 	u64 len = bh_result->b_size;
@@ -7681,25 +7680,13 @@ static int btrfs_get_blocks_direct(struct kiocb *iocb, struct inode *inode,
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
@@ -7767,9 +7754,6 @@ static int btrfs_get_blocks_direct(struct kiocb *iocb, struct inode *inode,
 unlock_err:
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 			 unlock_bits, 1, 0, &cached_state);
-err:
-	if (dio_data)
-		current->journal_info = dio_data;
 	return ret;
 }
 
@@ -8470,7 +8454,7 @@ static void btrfs_submit_direct(struct kiocb *iocb, struct bio *dio_bio,
 	 * time by btrfs_direct_IO().
 	 */
 	if (write) {
-		struct btrfs_dio_data *dio_data = current->journal_info;
+		struct btrfs_dio_data *dio_data = iocb->private;
 
 		dio_data->unsubmitted_oe_range_end = dip->logical_offset +
 			dip->bytes;
@@ -8612,13 +8596,13 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 		/*
 		 * We need to know how many extents we reserved so that we can
 		 * do the accounting properly if we go over the number we
-		 * originally calculated.  Abuse current->journal_info for this.
+		 * originally calculated.
 		 */
 		dio_data.reserve = round_up(count,
 					    fs_info->sectorsize);
 		dio_data.unsubmitted_oe_range_start = (u64)offset;
 		dio_data.unsubmitted_oe_range_end = (u64)offset;
-		current->journal_info = &dio_data;
+		iocb->private = &dio_data;
 		down_read(&BTRFS_I(inode)->dio_sem);
 	} else if (test_bit(BTRFS_INODE_READDIO_NEED_LOCK,
 				     &BTRFS_I(inode)->runtime_flags)) {
@@ -8633,7 +8617,6 @@ static ssize_t btrfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 				   btrfs_submit_direct, flags);
 	if (iov_iter_rw(iter) == WRITE) {
 		up_read(&BTRFS_I(inode)->dio_sem);
-		current->journal_info = NULL;
 		if (ret < 0 && ret != -EIOCBQUEUED) {
 			if (dio_data.reserve)
 				btrfs_delalloc_release_space(inode, data_reserved,
-- 
2.18.0
