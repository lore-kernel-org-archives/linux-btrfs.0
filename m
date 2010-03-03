From: jim owens <owens6336@gmail.com>
Subject: [PATCH dio.c V2 4/6] Btrfs: remove blocksize from diocb.
Date: Wed, 03 Mar 2010 13:55:16 -0500
Message-ID: <4B8EB094.3050904@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: jim owens <jim6336@gmail.com>
---
 fs/btrfs/dio.c |   72 ++++++++++++++++++++++++++++----------------------------
 1 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/dio.c b/fs/btrfs/dio.c
index 9f53577..ad9b58f 100644
--- a/fs/btrfs/dio.c
+++ b/fs/btrfs/dio.c
@@ -135,7 +135,6 @@ struct btrfs_diocb {
 	struct workspace *workspace;
 	char *csum_buf;
 
-	u32 blocksize;
 	int rw;
 	int error;
 	int sleeping;
@@ -261,7 +260,6 @@ ssize_t btrfs_direct_IO(int rw, struct kiocb *kiocb,
 	diocb->begin = offset;
 	diocb->terminate = offset + done;
 	diocb->inode = inode;
-	diocb->blocksize = BTRFS_I(diocb->inode)->root->sectorsize;
 
 	diocb->umc.user_iov = iov;
 	diocb->umc.work_iov = *iov;
@@ -436,10 +434,11 @@ static void btrfs_dio_read(struct btrfs_diocb *diocb)
 	u64 data_len;
 	int err = 0;
 	int loop = 0;
+	u32 blocksize = BTRFS_I(diocb->inode)->root->sectorsize;
 
 	/* expand lock region to include what we read to validate checksum */
-	diocb->lockstart = diocb->start & ~(diocb->blocksize-1);
-	diocb->lockend = ALIGN(diocb->terminate, diocb->blocksize) - 1;
+	diocb->lockstart = diocb->start & ~(blocksize - 1);
+	diocb->lockend = ALIGN(diocb->terminate, blocksize) - 1;
 
 getlock:
 	mutex_lock(&diocb->inode->i_mutex);
@@ -465,7 +464,7 @@ getlock:
 	if (!loop) {
 		loop++;
 		diocb->terminate = end;
-		diocb->lockend = ALIGN(diocb->terminate, diocb->blocksize) - 1;
+		diocb->lockend = ALIGN(diocb->terminate, blocksize) - 1;
 	}
 
 	lock_extent(io_tree, diocb->lockstart, diocb->lockend, GFP_NOFS);
@@ -686,12 +685,13 @@ static int btrfs_dio_extent_read(struct btrfs_diocb *diocb,
 	int csum = !(BTRFS_I(diocb->inode)->flags & BTRFS_INODE_NODATASUM);
 	u64 csum_before = 0;
 	u64 csum_after = 0;
-	u32 filetail = (data_start + data_len) & (diocb->blocksize - 1);
+	u32 blocksize = BTRFS_I(diocb->inode)->root->sectorsize;
+	u32 filetail = (data_start + data_len) & (blocksize - 1);
 
 	if (csum) {
-		csum_before = data_start & (diocb->blocksize - 1);
+		csum_before = data_start & (blocksize - 1);
 		if (filetail)
-			csum_after = diocb->blocksize - filetail;
+			csum_after = blocksize - filetail;
 	}
 
 	/* make post-eof consistent between inline/compressed/normal extents */
@@ -767,9 +767,9 @@ static int btrfs_dio_extent_read(struct btrfs_diocb *diocb,
 			 * extent as "tail checksum" and recalculate what we
 			 * have remaining for next loop.
 			 */
-			if (csum && (extcb->iolen & (diocb->blocksize - 1))) {
-				u64 align_size = diocb->blocksize -
-					(extcb->iolen & (diocb->blocksize - 1));
+			if (csum && (extcb->iolen & (blocksize - 1))) {
+				u64 align_size = blocksize -
+					(extcb->iolen & (blocksize - 1));
 
 				data_len += filetail;
 				if (data_len <= align_size) {
@@ -778,10 +778,10 @@ static int btrfs_dio_extent_read(struct btrfs_diocb *diocb,
 				} else {
 					extcb->filetail = align_size;
 					filetail = (data_start + data_len) &
-							(diocb->blocksize - 1);
+							(blocksize - 1);
 					data_len -= align_size;
 					if (csum && filetail)
-						csum_after = diocb->blocksize -
+						csum_after = blocksize -
 							filetail;
 					else
 						csum_after = 0;
@@ -1641,14 +1641,15 @@ static int btrfs_dio_read_csum(struct btrfs_dio_extcb *extcb)
 	struct bio_vec ivec;
 	struct btrfs_root *root =
 			BTRFS_I(extcb->diocb->inode)->root->fs_info->csum_root;
-	u32 iolen_per_csum_buf = extcb->diocb->blocksize * (extcb->tmpbuf_size
+	u32 blocksize = BTRFS_I(extcb->diocb->inode)->root->sectorsize;
+	u32 iolen_per_csum_buf = blocksize * (extcb->tmpbuf_size
 		/ btrfs_super_csum_size(&root->fs_info->super_copy));
 
-	if (extcb->iolen & (extcb->diocb->blocksize - 1)) {
+	if (extcb->iolen & (blocksize - 1)) {
 		printk(KERN_WARNING
 			"btrfs directIO unaligned checksum for ino %lu\n",
 			extcb->diocb->inode->i_ino);
-		extcb->iolen &= ~(extcb->diocb->blocksize - 1);
+		extcb->iolen &= ~(blocksize - 1);
 	}
 
 	ivec.bv_len = 0;
@@ -1671,7 +1672,7 @@ static int btrfs_dio_read_csum(struct btrfs_dio_extcb *extcb)
 		}
 
 		while (len) {
-			u32 csum_len = extcb->diocb->blocksize;
+			u32 csum_len = blocksize;
 
 			/* each checksum block is a filesystem block and on the
 			 * same device, but user memory can be 512 byte aligned
@@ -1709,31 +1710,29 @@ static int btrfs_dio_read_csum(struct btrfs_dio_extcb *extcb)
 				extcb->retry_csum = *fs_csum;
 				extcb->retry_start = extcb->iostart;
 				extcb->retry_mirror = 0;
-				extcb->retry_len = extcb->diocb->blocksize;
+				extcb->retry_len = blocksize;
 
 				/* need to give back vector remaining
 				 * length and the length of checksum block
 				 * so we are at correct input spot for retry
 				 */
-				ivec.bv_len += extcb->diocb->blocksize;
+				ivec.bv_len += blocksize;
 				btrfs_dio_put_next_in(&ivec, extcb);
 				return btrfs_dio_retry_block(extcb);
 			}
 
-			extcb->iostart += extcb->diocb->blocksize;
-			extcb->iolen -= extcb->diocb->blocksize;
+			extcb->iostart += blocksize;
+			extcb->iolen -= blocksize;
 			if (!extcb->compressed) {
 				if (!extcb->iolen && extcb->filetail) {
 					extcb->filestart += extcb->filetail;
 				} else {
-					extcb->filestart +=
-						extcb->diocb->blocksize;
+					extcb->filestart += blocksize;
 					/* 1st extent can start inside block */
-					extcb->filestart &=
-						~(extcb->diocb->blocksize - 1);
+					extcb->filestart &= ~(blocksize - 1);
 				}
 			}
-			len -= extcb->diocb->blocksize;
+			len -= blocksize;
 			fs_csum++;
 			cond_resched();
 		}
@@ -1767,7 +1766,7 @@ static void btrfs_dio_free_retry(struct btrfs_dio_extcb *extcb)
 static int btrfs_dio_retry_block(struct btrfs_dio_extcb *extcb)
 {
 	struct btrfs_stripe_info stripe_info;
-	u64 len = extcb->diocb->blocksize;
+	u64 len = BTRFS_I(extcb->diocb->inode)->root->sectorsize;
 	u64 physical;
 	struct backing_dev_info *bdi;
 	int pages = ALIGN(len, PAGE_SIZE) / PAGE_SIZE;
@@ -1872,6 +1871,8 @@ static int btrfs_dio_bad_bio_scan(struct btrfs_dio_extcb *extcb)
 
 static int btrfs_dio_read_retry(struct btrfs_dio_extcb *extcb)
 {
+	u32 blocksize = BTRFS_I(extcb->diocb->inode)->root->sectorsize;
+
 	/* begin with first I/O error from bios sent by initial extent submit */
 	if (!extcb->retry_bio) {
 		extcb->retry_start = extcb->iostart;
@@ -1913,11 +1914,11 @@ static int btrfs_dio_read_retry(struct btrfs_dio_extcb *extcb)
 	if (!extcb->compressed) {
 		struct bio_vec *retry = extcb->retry_bio->bi_io_vec;
 		struct bio_vec bad;
-		u32 bad_len = min(extcb->retry_len, extcb->diocb->blocksize);
+		u32 bad_len = min(extcb->retry_len, blocksize);
 		u32 offset;
 
 		/* user file position can start inside logical block */
-		offset = extcb->retry_start & (extcb->diocb->blocksize-1);
+		offset = extcb->retry_start & (blocksize - 1);
 		retry->bv_offset += offset;
 		retry->bv_len -= offset;
 
@@ -1953,26 +1954,25 @@ static int btrfs_dio_read_retry(struct btrfs_dio_extcb *extcb)
 	btrfs_dio_free_retry(extcb);
 
 	if (extcb->retry_csum) {
-		extcb->iostart += extcb->diocb->blocksize;
-		extcb->iolen -= extcb->diocb->blocksize;
+		extcb->iostart += blocksize;
+		extcb->iolen -= blocksize;
 		if (!extcb->compressed) {
 			if (!extcb->iolen && extcb->filetail) {
 				extcb->filestart += extcb->filetail;
 			} else {
-				extcb->filestart += extcb->diocb->blocksize;
-				extcb->filestart &=
-					~(extcb->diocb->blocksize - 1);
+				extcb->filestart += blocksize;
+				extcb->filestart &= ~(blocksize - 1);
 			}
 		}
 		return 0;
 	}
 
 	/* we are still processing bad bios from I/O submit */
-	extcb->retry_start += extcb->diocb->blocksize;
+	extcb->retry_start += blocksize;
 	extcb->retry_mirror = 0;
 
 	/* do we have any more blocks to do in this bio */
-	extcb->retry_len -= extcb->diocb->blocksize;
+	extcb->retry_len -= blocksize;
 	if (extcb->retry_len)
 		return btrfs_dio_retry_block(extcb);
 
-- 
1.6.3.3
