From: jim owens <owens6336@gmail.com>
Subject: [PATCH dio.c V2 2/6] Btrfs: change size_t to u32 in dio.c for 32-bit
 compile.
Date: Wed, 03 Mar 2010 13:54:58 -0500
Message-ID: <4B8EB082.5090004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: jim owens <jim6336@gmail.com>
---
 fs/btrfs/dio.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/dio.c b/fs/btrfs/dio.c
index 84277a9..97ab77f 100644
--- a/fs/btrfs/dio.c
+++ b/fs/btrfs/dio.c
@@ -1487,8 +1487,8 @@ fail:
 static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 *data_len)
 {
 	int err;
-	size_t size;
-	size_t extent_offset;
+	u32 size;
+	u32 extent_offset;
 	u64 extent_start;
 	u64 objectid = diocb->inode->i_ino;
 	struct btrfs_root *root = BTRFS_I(diocb->inode)->root;
@@ -1532,7 +1532,7 @@ static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 *data_len)
 	size = btrfs_file_extent_inline_len(leaf, item);
 	if (diocb->start < extent_start) {
 		printk(KERN_ERR "btrfs directIO inline range mismatch ino %lu"
-			" fpos %lld found start %lld size %ld\n",
+			" fpos %lld found start %lld size %d\n",
 			diocb->inode->i_ino, diocb->start, extent_start, size);
 		err = -EDOM;
 		goto fail;
@@ -1672,7 +1672,7 @@ static int btrfs_dio_read_csum(struct btrfs_dio_extcb *extcb)
 		}
 
 		while (len) {
-			size_t csum_len = extcb->diocb->blocksize;
+			u32 csum_len = extcb->diocb->blocksize;
 
 			/* each checksum block is a filesystem block and on the
 			 * same device, but user memory can be 512 byte aligned
@@ -1681,11 +1681,11 @@ static int btrfs_dio_read_csum(struct btrfs_dio_extcb *extcb)
 			csum = ~(u32)0;
 			while (csum_len) {
 				char *in;
-				size_t cl;
+				u32 cl;
 
 				if (ivec.bv_len == 0)
 					btrfs_dio_get_next_in(&ivec, extcb);
-				cl = min_t(size_t, ivec.bv_len, csum_len);
+				cl = min_t(u32, ivec.bv_len, csum_len);
 				in = kmap_atomic(ivec.bv_page, KM_USER0);
 				csum = btrfs_csum_data(root,
 						in + ivec.bv_offset, csum, cl);
@@ -1890,11 +1890,11 @@ static int btrfs_dio_read_retry(struct btrfs_dio_extcb *extcb)
 		struct bio_vec *retry = extcb->retry_bio->bi_io_vec;
 		char *new;
 		u32 csum = ~0;
-		size_t csum_len = extcb->retry_len;
+		u32 csum_len = extcb->retry_len;
 
 		/* blocksize can exceed page size */
 		while (csum_len) {
-			size_t cl = min_t(size_t, retry->bv_len, csum_len);
+			u32 cl = min_t(u32, retry->bv_len, csum_len);
 			new = kmap_atomic(retry->bv_page, KM_USER0);
 			csum = btrfs_csum_data(root, new, csum, cl);
 			kunmap_atomic(new, KM_USER0);
@@ -1912,8 +1912,8 @@ static int btrfs_dio_read_retry(struct btrfs_dio_extcb *extcb)
 	if (!extcb->compressed) {
 		struct bio_vec *retry = extcb->retry_bio->bi_io_vec;
 		struct bio_vec bad;
-		size_t bad_len = min(extcb->retry_len, extcb->diocb->blocksize);
-		size_t offset;
+		u32 bad_len = min(extcb->retry_len, extcb->diocb->blocksize);
+		u32 offset;
 
 		/* user file position can start inside logical block */
 		offset = extcb->retry_start & (extcb->diocb->blocksize-1);
@@ -1922,13 +1922,13 @@ static int btrfs_dio_read_retry(struct btrfs_dio_extcb *extcb)
 
 		bad.bv_len = 0;
 		while (bad_len) {
-			size_t cl;
+			u32 cl;
 			char *new;
 			char *out;
 
 			if (bad.bv_len == 0)
 				btrfs_dio_get_next_in(&bad, extcb);
-			cl = min_t(size_t, bad_len,
+			cl = min_t(u32, bad_len,
 					min(bad.bv_len, retry->bv_len));
 			new = kmap_atomic(retry->bv_page, KM_USER0);
 			out = kmap_atomic(bad.bv_page, KM_USER1);
-- 
1.6.3.3
