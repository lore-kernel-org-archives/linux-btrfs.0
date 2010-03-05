From: jim owens <owens6336@gmail.com>
Subject: [PATCH 2/2] Btrfs: change dio.c to use dio_min_blocksize instead
 of 512.
Date: Fri, 05 Mar 2010 14:51:03 -0500
Message-ID: <4B9160A7.3090402@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Instead of hard coding the minimum I/O alignment, use the smallest
bdev_logical_blocksize in the filesystem.  Also change the alignment
tests to determine the real user request minimum alignment and make
all eof tail and device checks on that user blocksize.

Signed-off-by: jim owens <jim6336@gmail.com>
---
 fs/btrfs/dio.c |  144 ++++++++++++++++++++------------------------------------
 1 files changed, 51 insertions(+), 93 deletions(-)

diff --git a/fs/btrfs/dio.c b/fs/btrfs/dio.c
index b1beafc..b76b227 100644
--- a/fs/btrfs/dio.c
+++ b/fs/btrfs/dio.c
@@ -134,6 +134,7 @@ struct btrfs_diocb {
 	struct workspace *workspace;
 	char *csum_buf;
 
+	u32 alignment;
 	int rw;
 	int error;
 	int sleeping;
@@ -160,12 +161,10 @@ static void btrfs_dio_write(struct btrfs_diocb *diocb);
 static void btrfs_dio_read(struct btrfs_diocb *diocb);
 static int btrfs_dio_new_extcb(struct btrfs_dio_extcb **alloc_extcb,
 			struct btrfs_diocb *diocb, struct extent_map *em);
-static void btrfs_dio_eof_tail(u32 *filetail, int eof,
-				struct btrfs_diocb *diocb);
 static int btrfs_dio_compressed_read(struct btrfs_diocb *diocb,
 				struct extent_map *lem, u64 data_len);
 static int btrfs_dio_extent_read(struct btrfs_diocb *diocb,
-				struct extent_map *lem, u64 data_len, int eof);
+				struct extent_map *lem, u64 data_len);
 static void btfrs_dio_unplug(struct btrfs_dio_extcb *extcb);
 static int btrfs_dio_read_stripes(struct btrfs_dio_extcb *extcb,
 				u64 *rd_start, u64 *rd_len, int temp_pages);
@@ -180,8 +179,6 @@ static int btrfs_dio_inline_next_in(struct bio_vec *ivec,
 				struct btrfs_inflate *icb);
 static int btrfs_dio_get_user_bvec(struct bio_vec *uv,
 				struct btrfs_dio_user_mem_control *umc);
-static int btrfs_dio_not_aligned(unsigned long iomask, u32 testlen,
-				struct btrfs_dio_user_mem_control *umc);
 static void btrfs_dio_put_user_bvec(struct bio_vec *uv,
 				struct btrfs_dio_user_mem_control *umc);
 static void btrfs_dio_release_unused_pages(
@@ -221,29 +218,33 @@ ssize_t btrfs_direct_IO(int rw, struct kiocb *kiocb,
 	ssize_t done = 0;
 	struct btrfs_diocb *diocb;
 	struct inode *inode = kiocb->ki_filp->f_mapping->host;
+	u32 alignment = BTRFS_I(inode)->root->sectorsize;
 
-	/* traditional 512-byte device sector alignment is the
-	 * minimum required. if they have a larger sector disk
-	 * (possibly multiple sizes in the filesystem) and need
-	 * a larger alignment for this I/O, we just fail later.
-	 */
-	if (offset & 511)
-		return -EINVAL;
-
-	/* check memory alignment, blocks cannot straddle pages.
+	/* check memory alignment, device blocks cannot straddle pages
+	 * because special hardware (e.g. iommu) is needed for split dma.
 	 * allow 0-length vectors which are questionable but seem legal.
+	 * limit I/O to smaller of request size or available memory.
 	 */
-	for (seg = 0; seg < nr_segs; seg++) {
-		if (iov[seg].iov_len &&
-		    ((unsigned long)iov[seg].iov_base & 511))
-			return -EINVAL;
-		if (iov[seg].iov_len & 511)
-			return -EINVAL;
-		done += iov[seg].iov_len;
-	}
+	alignment |= offset;
+	for (seg = 0; seg < nr_segs && done < kiocb->ki_left; seg++)
+		if (iov[seg].iov_len) {
+			/* alignment only needed through size of I/O */
+			done += iov[seg].iov_len;
+			done = min_t(ssize_t, done, kiocb->ki_left);
+			alignment |= done | (unsigned long)iov[seg].iov_base;
+		}
 
-	/* limit request size to available memory */
-	done = min_t(ssize_t, done, kiocb->ki_left);
+	/* minimum alignment is smallest logical_block_size of all devices in
+	 * this fs. this check is not enough if there are larger blocksizes
+	 * in the filesystem and we need a larger alignment for this I/O, so
+	 * we retest alignment as we build the bio and fail it at that point.
+	 * aligning here on largest blocksize would be simpler, but it would
+	 * mean applications that were working might fail if the user added a
+	 * larger blocksize device even though none of their file was on it.
+	 */
+	if (alignment &
+	    (BTRFS_I(inode)->root->fs_info->fs_devices->dio_min_blocksize - 1))
+		return -EINVAL;
 
 	/* no write code here so fall back to buffered writes */
 	if (rw == WRITE)
@@ -253,6 +254,14 @@ ssize_t btrfs_direct_IO(int rw, struct kiocb *kiocb,
 	if (!diocb)
 		return -ENOMEM;
 
+	/* determine minimum user alignment block size across entire I/O
+	 * so we can use it for eof tail handling and testing each device
+	 */
+	diocb->alignment =
+		BTRFS_I(inode)->root->fs_info->fs_devices->dio_min_blocksize;
+	while (!(alignment & diocb->alignment))
+		diocb->alignment *= 2;
+
 	diocb->rw = rw;
 	diocb->kiocb = kiocb;
 	diocb->start = offset;
@@ -523,8 +532,7 @@ getlock:
 				}
 				err = btrfs_dio_compressed_read(diocb, em, len);
 			} else {
-				err = btrfs_dio_extent_read(diocb, em, len,
-							len == data_len);
+				err = btrfs_dio_extent_read(diocb, em, len);
 			}
 		}
 
@@ -650,28 +658,13 @@ static int btrfs_dio_compressed_read(struct btrfs_diocb *diocb,
 	return err;
 }
 
-/* for consistent eof processing between inline/compressed/normal
- * extents, an unaligned eof gets special treatment, read into temp
- * and memcpy to user on completion the part that does not match
- * the users I/O alignment (for now always 511)
- */
-static void btrfs_dio_eof_tail(u32 *filetail, int eof,
-				struct btrfs_diocb *diocb)
-{
-	if (eof)
-		*filetail &= 511;
-	else
-		*filetail = 0; /* aligned direct to user memory */
-}
-
 /* called with a hard-sector bounded file byte data start/len
  * which covers areas of disk data.  it might not... be contiguous,
  * be on the same device(s), have the same redundancy property.
  * get the extent map per contiguous chunk and submit bios.
  */
-
 static int btrfs_dio_extent_read(struct btrfs_diocb *diocb,
-				struct extent_map *lem, u64 data_len, int eof)
+				struct extent_map *lem, u64 data_len)
 {
 	struct extent_map_tree *em_tree = &BTRFS_I(diocb->inode)->
 		root->fs_info->mapping_tree.map_tree;
@@ -690,9 +683,11 @@ static int btrfs_dio_extent_read(struct btrfs_diocb *diocb,
 			csum_after = blocksize - filetail;
 	}
 
-	/* make post-eof consistent between inline/compressed/normal extents */
-	if (filetail)
-		btrfs_dio_eof_tail(&filetail, eof, diocb);
+	/* to make eof consistent between inline/compressed/normal extents,
+	 * any unaligned bytes at eof get special treatment. those bytes are
+	 * read into a kernel temp page and copied to user memory.
+	 */
+	filetail &= diocb->alignment - 1;
 
 	data_start -= csum_before;
 	data_len += csum_before + csum_after;
@@ -781,9 +776,7 @@ static int btrfs_dio_extent_read(struct btrfs_diocb *diocb,
 							filetail;
 					else
 						csum_after = 0;
-					if (filetail)
-						btrfs_dio_eof_tail(&filetail,
-								eof, diocb);
+					filetail &= diocb->alignment - 1;
 				}
 
 				extcb->csum_pg2 = extcb->csum_pg1;
@@ -811,7 +804,7 @@ static int btrfs_dio_extent_read(struct btrfs_diocb *diocb,
 			 */
 			extcb->csum_pg2 = extcb->csum_pg1;
 			csum_after += filetail;
-			csum_after = ALIGN(csum_after, 512); /* for no csum */
+			csum_after = ALIGN(csum_after, diocb->alignment);
 			err = btrfs_dio_read_stripes(extcb,
 				&data_start, &csum_after, 1);
 			if (err)
@@ -867,7 +860,6 @@ static int btrfs_dio_read_stripes(struct btrfs_dio_extcb *extcb,
 	while (*rd_len) {
 		u64 dev_left = *rd_len;
 		struct btrfs_stripe_info stripe_info;
-		unsigned long iomask;
 		int mirror = 0;
 		int dvn;
 
@@ -880,18 +872,16 @@ retry:
 			btrfs_map_stripe_physical(extcb->em,
 						stripe_info.stripe_index);
 
-		/* device start and length may not be sector aligned or
-		 * user memory address/length vectors may not be aligned
-		 * on a device sector because device sector size is > 512.
-		 * we might have different size devices in the filesystem,
-		 * so retry all copies to see if any meet the alignment.
+		/* we can have devices with different logical blocksizes
+		 * in the filesystem. the user I/O start and length or
+		 * memory address and length may not be sector aligned
+		 * on a device with blocksize > dio_min_blocksize.
+		 * if the user alignment is not correct for this device,
+		 * try other copies to see if any meet their alignment.
 		 */
-		iomask = bdev_logical_block_size(
-				btrfs_map_stripe_bdev(extcb->em, dvn)) - 1;
-		if ((extcb->diodev[dvn].physical & iomask) ||
-		    (dev_left & iomask) || (!temp_pages &&
-		    btrfs_dio_not_aligned(iomask, (u32)dev_left,
-						&extcb->diocb->umc))) {
+		if (!temp_pages && extcb->diocb->alignment <
+		    bdev_logical_block_size(btrfs_map_stripe_bdev(
+		    extcb->em, dvn))) {
 			if (mirror < btrfs_map_num_copies(extcb->em)) {
 				mirror++;
 				goto retry;
@@ -1056,38 +1046,6 @@ static int btrfs_dio_get_user_bvec(struct bio_vec *uv,
 	return 0;
 }
 
-static int btrfs_dio_not_aligned(unsigned long iomask, u32 testlen,
-				struct btrfs_dio_user_mem_control *umc)
-{
-	const struct iovec *nuv;
-
-	if (!umc) /* temp pages are always good */
-		return 0;
-
-	if ((unsigned long)umc->work_iov.iov_base & iomask)
-		return 1;
-	if (testlen <= umc->work_iov.iov_len)
-		return 0;
-	if (umc->work_iov.iov_len & iomask)
-		return 1;
-
-	testlen -= umc->work_iov.iov_len;
-	nuv = umc->user_iov;
-	while (testlen) {
-		nuv++;
-		while (nuv->iov_len == 0)
-			nuv++;
-		if ((unsigned long)nuv->iov_base & iomask)
-			return 1;
-		if (testlen <= nuv->iov_len)
-			return 0;
-		if (nuv->iov_len & iomask)
-			return 1;
-		testlen -= nuv->iov_len;
-	}
-	return 0;
-}
-
 /* error processing only, put back the user bvec we could not process
  * so we can get it again later or release it properly
  */
-- 
1.6.3.3
