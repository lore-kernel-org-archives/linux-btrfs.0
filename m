Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:34963 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab3BGKLY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Feb 2013 05:11:24 -0500
Message-ID: <51137DF7.7050006@cn.fujitsu.com>
Date: Thu, 07 Feb 2013 18:12:07 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fusionio.com>
Subject: [RFC][PATCH] Btrfs: fix deadlock due to unsubmitted
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The deadlock problem happened when running fsstress(a test program in LTP).

Steps to reproduce:
 # mkfs.btrfs -b 100M <partition>
 # mount <partition> <mnt>
 # <Path>/fsstress -p 3 -n 10000000 -d <mnt>

The reason is:
btrfs_direct_IO()
 |->do_direct_IO()
     |->get_page()
     |->get_blocks()
     |	 |->btrfs_delalloc_resereve_space()
     |	 |->btrfs_add_ordered_extent() -------	Add a new ordered extent
     |->dio_send_cur_page(page0) --------------	We didn't submit bio here
     |->get_page()
     |->get_blocks()
	 |->btrfs_delalloc_resereve_space()
	     |->flush_space()
		 |->btrfs_start_ordered_extent()
		     |->wait_event() ----------	Wait the completion of
						the ordered extent that is
						mentioned above

But because we didn't submit the bio that is mentioned above, the ordered
extent can not complete, we would wait for its completion forever.

There are two methods which can fix this deadlock problem:
1. submit the bio before we invoke get_blocks()
2. reserve the space before we do dio

Though the 1st is the simplest way, we need modify the code of VFS, and it
is likely to break contiguous requests, and introduce performance regression
for the other filesystems.

So we have to choose the 2nd way.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |    3 +-
 fs/btrfs/inode.c       |   81 ++++++++++++++++++++++++-----------------------
 2 files changed, 43 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 85b8454..ca9afc4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4670,7 +4670,8 @@ void btrfs_delalloc_release_metadata(struct inode *inode, u64 num_bytes)
 	spin_lock(&BTRFS_I(inode)->lock);
 	dropped = drop_outstanding_extent(inode);
 
-	to_free = calc_csum_metadata_size(inode, num_bytes, 0);
+	if (num_bytes)
+		to_free = calc_csum_metadata_size(inode, num_bytes, 0);
 	spin_unlock(&BTRFS_I(inode)->lock);
 	if (dropped > 0)
 		to_free += btrfs_calc_trans_metadata_size(root, dropped);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ca7ace7..c5d829d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6004,16 +6004,15 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 	u64 len = bh_result->b_size;
 	struct btrfs_trans_handle *trans;
 	int unlock_bits = EXTENT_LOCKED;
-	int ret;
+	int ret = 0;
 
 	if (create) {
-		ret = btrfs_delalloc_reserve_space(inode, len);
-		if (ret)
-			return ret;
+		spin_lock(&BTRFS_I(inode)->lock);
+		BTRFS_I(inode)->outstanding_extents++;
+		spin_unlock(&BTRFS_I(inode)->lock);
 		unlock_bits |= EXTENT_DELALLOC | EXTENT_DIRTY;
-	} else {
+	} else
 		len = min_t(u64, len, root->sectorsize);
-	}
 
 	lockstart = start;
 	lockend = start + len - 1;
@@ -6025,14 +6024,6 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 	if (lock_extent_direct(inode, lockstart, lockend, &cached_state, create))
 		return -ENOTBLK;
 
-	if (create) {
-		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
-				     lockend, EXTENT_DELALLOC, NULL,
-				     &cached_state, GFP_NOFS);
-		if (ret)
-			goto unlock_err;
-	}
-
 	em = btrfs_get_extent(inode, NULL, 0, start, len, 0);
 	if (IS_ERR(em)) {
 		ret = PTR_ERR(em);
@@ -6064,7 +6055,6 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 	if (!create && (em->block_start == EXTENT_MAP_HOLE ||
 			test_bit(EXTENT_FLAG_PREALLOC, &em->flags))) {
 		free_extent_map(em);
-		ret = 0;
 		goto unlock_err;
 	}
 
@@ -6162,6 +6152,11 @@ unlock:
 		 */
 		if (start + len > i_size_read(inode))
 			i_size_write(inode, start + len);
+
+		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
+				     lockstart + len - 1, EXTENT_DELALLOC, NULL,
+				     &cached_state, GFP_NOFS);
+		BUG_ON(ret);
 	}
 
 	/*
@@ -6170,24 +6165,9 @@ unlock:
 	 * aren't using if there is any left over space.
 	 */
 	if (lockstart < lockend) {
-		if (create && len < lockend - lockstart) {
-			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
-					 lockstart + len - 1,
-					 unlock_bits | EXTENT_DEFRAG, 1, 0,
-					 &cached_state, GFP_NOFS);
-			/*
-			 * Beside unlock, we also need to cleanup reserved space
-			 * for the left range by attaching EXTENT_DO_ACCOUNTING.
-			 */
-			clear_extent_bit(&BTRFS_I(inode)->io_tree,
-					 lockstart + len, lockend,
-					 unlock_bits | EXTENT_DO_ACCOUNTING |
-					 EXTENT_DEFRAG, 1, 0, NULL, GFP_NOFS);
-		} else {
-			clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
-					 lockend, unlock_bits, 1, 0,
-					 &cached_state, GFP_NOFS);
-		}
+		clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
+				 lockend, unlock_bits, 1, 0,
+				 &cached_state, GFP_NOFS);
 	} else {
 		free_extent_state(cached_state);
 	}
@@ -6197,9 +6177,6 @@ unlock:
 	return 0;
 
 unlock_err:
-	if (create)
-		unlock_bits |= EXTENT_DO_ACCOUNTING;
-
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, lockstart, lockend,
 			 unlock_bits, 1, 0, &cached_state, GFP_NOFS);
 	return ret;
@@ -6637,15 +6614,39 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
+	size_t count = 0;
+	ssize_t ret;
 
 	if (check_direct_IO(BTRFS_I(inode)->root, rw, iocb, iov,
 			    offset, nr_segs))
 		return 0;
 
-	return __blockdev_direct_IO(rw, iocb, inode,
-		   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
-		   iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
-		   btrfs_submit_direct, 0);
+	if (rw & WRITE) {
+		count = iov_length(iov, nr_segs);
+		ret = btrfs_delalloc_reserve_space(inode, count);
+		if (ret)
+			return ret;
+	}
+
+	ret = __blockdev_direct_IO(rw, iocb, inode,
+			BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
+			iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
+			btrfs_submit_direct, 0);
+
+	if (rw & WRITE) {
+		if (ret < 0 && ret != -EIOCBQUEUED)
+			btrfs_delalloc_release_space(inode, count);
+		else if (ret > 0 && (size_t)ret < count) {
+			spin_lock(&BTRFS_I(inode)->lock);
+			BTRFS_I(inode)->outstanding_extents++;
+			spin_unlock(&BTRFS_I(inode)->lock);
+			btrfs_delalloc_release_space(inode,
+						     count - (size_t)ret);
+		}
+		btrfs_delalloc_release_metadata(inode, 0);
+	}
+
+	return ret;
 }
 
 #define BTRFS_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC)
-- 
1.6.5.2
