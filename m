Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:46883 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab2HCUqw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Aug 2012 16:46:52 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id i6n0mVpidqklhSNe (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 03 Aug 2012 14:46:51 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: don't allocate a seperate csums array for direct reads
Date: Fri, 3 Aug 2012 16:51:55 -0400
Message-ID: <1344027115-31893-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've been allocating a big array for csums instead of storing them in the
io_tree like we do for buffered reads because previously we were locking the
entire range, so we didn't have an extent state for each sector of the
range.  But now that we do the range locking as we map the buffers we can
limit the mapping lenght to sectorsize and use the private part of the
io_tree for our csums.  This allows us to avoid an extra memory allocation
for direct reads which could incur latency.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/ctree.h     |    2 +-
 fs/btrfs/file-item.c |    4 ++--
 fs/btrfs/inode.c     |   45 ++++++++++++++++-----------------------------
 3 files changed, 19 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index adb1cd7..3481963 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3192,7 +3192,7 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
 int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
 			  struct bio *bio, u32 *dst);
 int btrfs_lookup_bio_sums_dio(struct btrfs_root *root, struct inode *inode,
-			      struct bio *bio, u64 logical_offset, u32 *dst);
+			      struct bio *bio, u64 logical_offset);
 int btrfs_insert_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     u64 objectid, u64 pos,
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index b45b9de..857d93c 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -272,9 +272,9 @@ int btrfs_lookup_bio_sums(struct btrfs_root *root, struct inode *inode,
 }
 
 int btrfs_lookup_bio_sums_dio(struct btrfs_root *root, struct inode *inode,
-			      struct bio *bio, u64 offset, u32 *dst)
+			      struct bio *bio, u64 offset)
 {
-	return __btrfs_lookup_bio_sums(root, inode, bio, offset, dst, 1);
+	return __btrfs_lookup_bio_sums(root, inode, bio, offset, NULL, 1);
 }
 
 int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5e70526..8a8f0d6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5845,15 +5845,18 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
 	int unlock_bits = EXTENT_LOCKED;
 	int ret;
 
-	lockstart = start;
-	lockend = start + len - 1;
 	if (create) {
 		ret = btrfs_delalloc_reserve_space(inode, len);
 		if (ret)
 			return ret;
 		unlock_bits |= EXTENT_DELALLOC | EXTENT_DIRTY;
+	} else {
+		len = min_t(u64, len, root->sectorsize);
 	}
 
+	lockstart = start;
+	lockend = start + len - 1;
+
 	/*
 	 * If this errors out it's because we couldn't invalidate pagecache for
 	 * this range and we need to fallback to buffered.
@@ -6013,7 +6016,6 @@ struct btrfs_dio_private {
 	u64 logical_offset;
 	u64 disk_bytenr;
 	u64 bytes;
-	u32 *csums;
 	void *private;
 
 	/* number of bios pending for this dio */
@@ -6033,7 +6035,6 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 	struct inode *inode = dip->inode;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	u64 start;
-	u32 *private = dip->csums;
 
 	start = dip->logical_offset;
 	do {
@@ -6041,8 +6042,12 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 			struct page *page = bvec->bv_page;
 			char *kaddr;
 			u32 csum = ~(u32)0;
+			u64 private = ~(u32)0;
 			unsigned long flags;
 
+			if (get_state_private(&BTRFS_I(inode)->io_tree,
+					      start, &private))
+				goto failed;
 			local_irq_save(flags);
 			kaddr = kmap_atomic(page);
 			csum = btrfs_csum_data(root, kaddr + bvec->bv_offset,
@@ -6052,18 +6057,18 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 			local_irq_restore(flags);
 
 			flush_dcache_page(bvec->bv_page);
-			if (csum != *private) {
+			if (csum != private) {
+failed:
 				printk(KERN_ERR "btrfs csum failed ino %llu off"
 				      " %llu csum %u private %u\n",
 				      (unsigned long long)btrfs_ino(inode),
 				      (unsigned long long)start,
-				      csum, *private);
+				      csum, (unsigned)private);
 				err = -EIO;
 			}
 		}
 
 		start += bvec->bv_len;
-		private++;
 		bvec++;
 	} while (bvec <= bvec_end);
 
@@ -6071,7 +6076,6 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 		      dip->logical_offset + dip->bytes - 1);
 	bio->bi_private = dip->private;
 
-	kfree(dip->csums);
 	kfree(dip);
 
 	/* If we had a csum failure make sure to clear the uptodate flag */
@@ -6177,7 +6181,7 @@ static struct bio *btrfs_dio_bio_alloc(struct block_device *bdev,
 
 static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 					 int rw, u64 file_offset, int skip_sum,
-					 u32 *csums, int async_submit)
+					 int async_submit)
 {
 	int write = rw & REQ_WRITE;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
@@ -6210,8 +6214,7 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 		if (ret)
 			goto err;
 	} else if (!skip_sum) {
-		ret = btrfs_lookup_bio_sums_dio(root, inode, bio,
-					  file_offset, csums);
+		ret = btrfs_lookup_bio_sums_dio(root, inode, bio, file_offset);
 		if (ret)
 			goto err;
 	}
@@ -6237,10 +6240,8 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	u64 submit_len = 0;
 	u64 map_length;
 	int nr_pages = 0;
-	u32 *csums = dip->csums;
 	int ret = 0;
 	int async_submit = 0;
-	int write = rw & REQ_WRITE;
 
 	map_length = orig_bio->bi_size;
 	ret = btrfs_map_block(map_tree, READ, start_sector << 9,
@@ -6276,16 +6277,13 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 			atomic_inc(&dip->pending_bios);
 			ret = __btrfs_submit_dio_bio(bio, inode, rw,
 						     file_offset, skip_sum,
-						     csums, async_submit);
+						     async_submit);
 			if (ret) {
 				bio_put(bio);
 				atomic_dec(&dip->pending_bios);
 				goto out_err;
 			}
 
-			/* Write's use the ordered csums */
-			if (!write && !skip_sum)
-				csums = csums + nr_pages;
 			start_sector += submit_len >> 9;
 			file_offset += submit_len;
 
@@ -6315,7 +6313,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 
 submit:
 	ret = __btrfs_submit_dio_bio(bio, inode, rw, file_offset, skip_sum,
-				     csums, async_submit);
+				     async_submit);
 	if (!ret)
 		return 0;
 
@@ -6351,17 +6349,6 @@ static void btrfs_submit_direct(int rw, struct bio *bio, struct inode *inode,
 		ret = -ENOMEM;
 		goto free_ordered;
 	}
-	dip->csums = NULL;
-
-	/* Write's use the ordered csum stuff, so we don't need dip->csums */
-	if (!write && !skip_sum) {
-		dip->csums = kmalloc(sizeof(u32) * bio->bi_vcnt, GFP_NOFS);
-		if (!dip->csums) {
-			kfree(dip);
-			ret = -ENOMEM;
-			goto free_ordered;
-		}
-	}
 
 	dip->private = bio->bi_private;
 	dip->inode = inode;
-- 
1.7.7.6

