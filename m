From: jim owens <owens6336@gmail.com>
Subject: [PATCH dio.c V2 3/6] Btrfs: minor code corrections in dio.c from
 Josef.
Date: Wed, 03 Mar 2010 13:55:07 -0500
Message-ID: <4B8EB08B.4010802@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: jim owens <jim6336@gmail.com>
---
 fs/btrfs/dio.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/dio.c b/fs/btrfs/dio.c
index 97ab77f..9f53577 100644
--- a/fs/btrfs/dio.c
+++ b/fs/btrfs/dio.c
@@ -199,7 +199,7 @@ static void btrfs_dio_read_done(struct btrfs_dio_extcb *extcb);
 static void btrfs_dio_decompress(struct btrfs_dio_extcb *extcb);
 static void btrfs_dio_free_extcb(struct btrfs_dio_extcb *extcb);
 static int btrfs_dio_get_workbuf(struct btrfs_dio_extcb *extcb);
-static int btrfs_dio_drop_workbuf(struct btrfs_dio_extcb *extcb);
+static void btrfs_dio_drop_workbuf(struct btrfs_dio_extcb *extcb);
 static void btrfs_dio_complete_bios(struct btrfs_diocb *diocb);
 static int btrfs_dio_new_bio(struct btrfs_dio_extcb *extcb, int dvn);
 static void btrfs_dio_submit_bio(struct btrfs_dio_extcb *extcb, int dvn);
@@ -281,15 +281,15 @@ ssize_t btrfs_direct_IO(int rw, struct kiocb *kiocb,
 		else
 			btrfs_dio_write(diocb);
 		done = btrfs_dio_wait(diocb);
-
 		btrfs_dio_free_diocb(diocb);
-		return done;
 	} else {
 		diocb->submit.func = btrfs_dio_aio_submit;
 		btrfs_queue_worker(&BTRFS_I(diocb->inode)->root->fs_info->
 				submit_workers, &diocb->submit);
-		return -EIOCBQUEUED;
+		done = -EIOCBQUEUED;
 	}
+
+	return done;
 }
 
 /* process context worker routine to handle bio completion
@@ -1293,12 +1293,11 @@ static int btrfs_dio_get_workbuf(struct btrfs_dio_extcb *extcb)
 /* on error retries, our work buffers could be released
  * if not in use for other extcbs, so drop them to be safe
  */
-static int btrfs_dio_drop_workbuf(struct btrfs_dio_extcb *extcb)
+static void btrfs_dio_drop_workbuf(struct btrfs_dio_extcb *extcb)
 {
 	extcb->icb.workspace = NULL;
 	extcb->tmpbuf = NULL;
 	extcb->tmpbuf_size = 0;
-	return 0;
 }
 
 static void btrfs_dio_complete_bios(struct btrfs_diocb *diocb)
@@ -1498,6 +1497,8 @@ static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 *data_len)
 	struct btrfs_key found_key;
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 
 	err = btrfs_lookup_file_extent(NULL, root, path, objectid,
 					diocb->start, 0);
@@ -1547,8 +1548,6 @@ static int btrfs_dio_inline_read(struct btrfs_diocb *diocb, u64 *data_len)
 
 	extent_offset = diocb->start - extent_start;
 	size = min_t(u64, *data_len, size - extent_offset);
-
-	size = min_t(u64, *data_len, size);
 	*data_len = size;
 
 	if (btrfs_file_extent_compression(leaf, item) == BTRFS_COMPRESS_ZLIB) {
@@ -1815,12 +1814,14 @@ static int btrfs_dio_retry_block(struct btrfs_dio_extcb *extcb)
 		struct page *page;
 
 		/* compressed read bios use temp pages, reuse them */
-		if (extcb->compressed)
+		if (extcb->compressed) {
 			page = extcb->order[extcb->bo_now]->
 					bi_io_vec[extcb->bo_bvn].bv_page;
-		else
+		} else {
 			page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
-
+			if (!page)
+				return -ENOMEM;
+		}
 		if (!bio_add_page(extcb->retry_bio, page, pglen, 0)) {
 			if (!extcb->compressed)
 				page_cache_release(page);
-- 
1.6.3.3
