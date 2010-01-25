From: jim owens <jowens@hp.com>
Subject: [PATCH] Btrfs: correct mistakes in direct I/O read found by fsx
Date: Mon, 25 Jan 2010 09:01:12 -0500
Message-ID: <4B5DA428.3020109@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Thanks to Josef Bacik for breaking the code with fsx and
figuring out with Chris what I was doing wrong:

1) change inline extent processing because an inline can
   be at the beginning of a large file when a hole follows
   and any access within the first block points at the
   inline even when the starting fpos is in that hole.
2) change compressed extent expansion because the end of
   the extent can be another implied hole that is not
   part of the compressed data stream.
3) reorder EOF test to be safer with concurrent write.
4) add better error reporting for inline extents.

Signed-off-by: jim owens <jowens@hp.com>
---
 fs/btrfs/dio.c |  101 ++++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 72 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/dio.c b/fs/btrfs/dio.c
index 2c0579a..3315cc9 100644
--- a/fs/btrfs/dio.c
+++ b/fs/btrfs/dio.c
@@ -203,7 +203,7 @@ static void btrfs_dio_submit_bio(struct btrfs_dio_extcb *extcb, int dvn);
 static int btrfs_dio_add_user_pages(u64 *dev_left, struct btrfs_dio_extcb *extcb, int dvn);
 static int btrfs_dio_add_temp_pages(u64 *dev_left, struct btrfs_dio_extcb *extcb, int dvn);
 static int btrfs_dio_hole_read(struct btrfs_diocb *diocb, u64 hole_len);
-static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 data_len);
+static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 *data_len);
 static int btrfs_dio_read_csum(struct btrfs_dio_extcb *extcb);
 static void btrfs_dio_free_retry(struct btrfs_dio_extcb *extcb);
 static int btrfs_dio_retry_block(struct btrfs_dio_extcb *extcb);
@@ -433,9 +433,21 @@ static void btrfs_dio_read(struct btrfs_diocb *diocb)
 
 	/* expand lock region to include what we read to validate checksum */ 
 	diocb->lockstart = diocb->start & ~(diocb->blocksize-1);
+	diocb->lockend = ALIGN(diocb->terminate, diocb->blocksize) - 1;
 
 getlock:
 	mutex_lock(&diocb->inode->i_mutex);
+		
+	/* ensure writeout and btree update on everything
+	 * we might read for checksum or compressed extents
+	 */
+	data_len = diocb->lockend + 1 - diocb->lockstart;
+	err = btrfs_wait_ordered_range(diocb->inode, diocb->lockstart, data_len);
+	if (err) {
+		diocb->error = err;
+		mutex_unlock(&diocb->inode->i_mutex);
+		return;
+	}
 	data_len = i_size_read(diocb->inode);
 	if (data_len < end)
 		end = data_len;
@@ -448,17 +460,7 @@ getlock:
 		diocb->terminate = end;
 		diocb->lockend = ALIGN(diocb->terminate, diocb->blocksize) - 1;
 	}
-		
-	/* ensure writeout and btree update on everything
-	 * we might read for checksum or compressed extents
-	 */
-	data_len = diocb->lockend + 1 - diocb->lockstart;
-	err = btrfs_wait_ordered_range(diocb->inode, diocb->lockstart, data_len);
-	if (err) {
-		diocb->error = err;
-		mutex_unlock(&diocb->inode->i_mutex);
-		return;
-	}
+
 	lock_extent(io_tree, diocb->lockstart, diocb->lockend, GFP_NOFS);
 	mutex_unlock(&diocb->inode->i_mutex);
 
@@ -483,7 +485,18 @@ getlock:
 		}
 		
 		if (em->block_start == EXTENT_MAP_INLINE) {
-			err = btrfs_dio_inline_read(diocb, len);
+			/* ugly stuff because inline can exist in a large file
+			 * with other extents if a hole immediately follows.
+			 * the inline might end short of the btrfs block with
+			 * an implied hole that we need to zero here.
+			 */
+			u64 expected = min(diocb->start + len, em->start + em->len);
+			err = btrfs_dio_inline_read(diocb, &len);
+			if (!err && expected > diocb->start) {
+				data_len -= len;
+				len = expected - diocb->start;
+				err = btrfs_dio_hole_read(diocb, len);
+			}
 		} else {
 			len = min(len, em->len - (diocb->start - em->start));
 			if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags) ||
@@ -1183,9 +1196,24 @@ static void btrfs_dio_decompress(struct btrfs_dio_extcb *extcb)
 	u32 len = extcb->icb.out_len;
 
 	extcb->error = btrfs_zlib_inflate(&extcb->icb);
-	if (extcb->icb.out_len != len && !extcb->error)
-		extcb->error = -EIO;
 
+	/* ugly again - compressed extents can end with an implied hole */
+	if (!extcb->error && extcb->icb.out_len != len) {
+		while (extcb->umc.todo) {
+			struct bio_vec uv;
+			char *out;
+
+			extcb->error = btrfs_dio_get_user_bvec(&uv, &extcb->umc);
+			if (extcb->error)
+				goto fail;
+			out = kmap_atomic(uv.bv_page, KM_USER0);
+			memset(out + uv.bv_offset, 0, uv.bv_len);
+			kunmap_atomic(out, KM_USER0);
+
+			btrfs_dio_done_with_out(&uv, NULL);
+		}
+	}
+fail:
 	btrfs_dio_release_bios(extcb, 0);
 }
 
@@ -1432,7 +1460,7 @@ fail:
 	return err;
 }
 
-static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 data_len)
+static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 *data_len)
 {
 	int err;
 	size_t size;
@@ -1452,8 +1480,11 @@ static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 data_len)
 		if (err < 0)
 			goto notfound;
 		err= -EDOM;
-		if (path->slots[0] == 0)
+		if (path->slots[0] == 0) {
+		printk(KERN_ERR "btrfs directIO inline extent leaf not found ino %lu\n",
+				diocb->inode->i_ino);
 			goto fail;
+		}
 		path->slots[0]--;
 	}
 
@@ -1473,16 +1504,26 @@ static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 data_len)
 	extent_start = found_key.offset;
 	/* uncompressed size */
 	size = btrfs_file_extent_inline_len(leaf, item);
-	if (diocb->start < extent_start || diocb->start >= extent_start + size) {
-		printk(KERN_ERR "btrfs directIO inline extent leaf mismatch ino %lu\n",
-				diocb->inode->i_ino);
+	if (diocb->start < extent_start) {
+		printk(KERN_ERR "btrfs directIO inline extent range mismatch ino %lu"
+			" fpos %lld found start %lld size %ld\n",
+			diocb->inode->i_ino,diocb->start,extent_start,size);
 		err= -EDOM;
 		goto fail;
 	}
 
+	/* we can end here when we start in an implied hole on a larger file */
+	if (diocb->start >= extent_start + size) {
+		*data_len = 0;
+		err = 0;
+		goto fail;
+	}
+
 	extent_offset = diocb->start - extent_start;
+	size = min_t(u64, *data_len, size - extent_offset);
 
-	size = min_t(u64, data_len, size);
+	size = min_t(u64, *data_len, size);
+	*data_len = size;
 
 	if (btrfs_file_extent_compression(leaf, item) ==
 						BTRFS_COMPRESS_ZLIB) {
@@ -1523,11 +1564,11 @@ static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 data_len)
 		if (!err)
 			diocb->start += size;
 
-		/* needed if we ever allowed extents after inline
-		 * diocb->umc.work_iov = extcb->umc.work_iov;
-		 * diocb->umc.user_iov = extcb->umc.user_iov;
-		 * diocb->umc.remaining = extcb->umc.remaining;
-		 */
+		/* we allow extents after inline if a hole follows */
+		diocb->umc.work_iov = extcb->umc.work_iov;
+		diocb->umc.user_iov = extcb->umc.user_iov;
+		diocb->umc.remaining = extcb->umc.remaining;
+
 		kfree(extcb);
 	} else {
 		unsigned long inline_start;
@@ -1556,9 +1597,11 @@ fail:
 	btrfs_release_path(root, path);
 notfound:
 	btrfs_free_path(path);
-	unlock_extent(&BTRFS_I(diocb->inode)->io_tree, diocb->lockstart,
-			diocb->lockstart + data_len - 1, GFP_NOFS);
-	diocb->lockstart += data_len;
+	if (!err && *data_len) {
+		unlock_extent(&BTRFS_I(diocb->inode)->io_tree, diocb->lockstart,
+				diocb->lockstart + *data_len - 1, GFP_NOFS);
+		diocb->lockstart += *data_len;
+	}
 	return err;
 }
 
-- 
1.5.6.3
