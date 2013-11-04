Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:62082 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab3KDXgt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Nov 2013 18:36:49 -0500
Received: by mail-pb0-f41.google.com with SMTP id wy17so4641685pbc.0
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Nov 2013 15:36:48 -0800 (PST)
From: Kent Overstreet <kmo@daterainc.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc: axboe@kernel.dk, hch@infradead.org, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 9/9] block: Add bio_get_user_pages()
Date: Mon,  4 Nov 2013 15:36:27 -0800
Message-Id: <1383608187-27368-10-git-send-email-kmo@daterainc.com>
In-Reply-To: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
References: <1383608187-27368-1-git-send-email-kmo@daterainc.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This replaces some of the code that was in __bio_map_user_iov(), and
soon we're going to use this helper in the dio code.

Note that this relies on the recent change to make
generic_make_request() take arbitrary sized bios - we're not using
bio_add_page() here.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 fs/bio.c            | 124 +++++++++++++++++++++++++++-------------------------
 include/linux/bio.h |   2 +
 2 files changed, 67 insertions(+), 59 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index c60bfcb..a10b350 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1124,17 +1124,70 @@ struct bio *bio_copy_user(struct request_queue *q, struct rq_map_data *map_data,
 }
 EXPORT_SYMBOL(bio_copy_user);
 
+/**
+ * bio_get_user_pages - pin user pages and add them to a biovec
+ * @bio: bio to add pages to
+ * @uaddr: start of user address
+ * @len: length in bytes
+ * @write_to_vm: bool indicating writing to pages or not
+ *
+ * Pins pages for up to @len bytes and appends them to @bio's bvec array. May
+ * pin only part of the requested pages - @bio need not have room for all the
+ * pages and can already have had pages added to it.
+ *
+ * Returns the number of bytes from @len added to @bio.
+ */
+ssize_t bio_get_user_pages(struct bio *bio, unsigned long uaddr,
+			   unsigned long len, int write_to_vm)
+{
+	int ret;
+	unsigned nr_pages, bytes;
+	unsigned offset = offset_in_page(uaddr);
+	struct bio_vec *bv;
+	struct page **pages;
+
+	nr_pages = min_t(size_t,
+			 DIV_ROUND_UP(len + offset, PAGE_SIZE),
+			 bio->bi_max_vecs - bio->bi_vcnt);
+
+	bv = &bio->bi_io_vec[bio->bi_vcnt];
+	pages = (void *) bv;
+
+	ret = get_user_pages_fast(uaddr, nr_pages, write_to_vm, pages);
+	if (ret < 0)
+		return ret;
+
+	bio->bi_vcnt += ret;
+	bytes = ret * PAGE_SIZE - offset;
+
+	while (ret--) {
+		bv[ret].bv_page = pages[ret];
+		bv[ret].bv_len = PAGE_SIZE;
+		bv[ret].bv_offset = 0;
+	}
+
+	bv[0].bv_offset += offset;
+	bv[0].bv_len -= offset;
+
+	if (bytes > len) {
+		bio->bi_io_vec[bio->bi_vcnt - 1].bv_len -= bytes - len;
+		bytes = len;
+	}
+
+	bio->bi_iter.bi_size += bytes;
+
+	return bytes;
+}
+EXPORT_SYMBOL(bio_get_user_pages);
+
 static struct bio *__bio_map_user_iov(struct request_queue *q,
 				      struct block_device *bdev,
 				      struct sg_iovec *iov, int iov_count,
 				      int write_to_vm, gfp_t gfp_mask)
 {
-	int i, j;
-	int nr_pages = 0;
-	struct page **pages;
+	ssize_t ret;
+	int i, nr_pages = 0;
 	struct bio *bio;
-	int cur_page = 0;
-	int ret, offset;
 
 	for (i = 0; i < iov_count; i++) {
 		unsigned long uaddr = (unsigned long)iov[i].iov_base;
@@ -1163,57 +1216,17 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
 
-	ret = -ENOMEM;
-	pages = kcalloc(nr_pages, sizeof(struct page *), gfp_mask);
-	if (!pages)
-		goto out;
-
 	for (i = 0; i < iov_count; i++) {
-		unsigned long uaddr = (unsigned long)iov[i].iov_base;
-		unsigned long len = iov[i].iov_len;
-		unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-		unsigned long start = uaddr >> PAGE_SHIFT;
-		const int local_nr_pages = end - start;
-		const int page_limit = cur_page + local_nr_pages;
-
-		ret = get_user_pages_fast(uaddr, local_nr_pages,
-				write_to_vm, &pages[cur_page]);
-		if (ret < local_nr_pages) {
-			ret = -EFAULT;
-			goto out_unmap;
-		}
-
-		offset = uaddr & ~PAGE_MASK;
-		for (j = cur_page; j < page_limit; j++) {
-			unsigned int bytes = PAGE_SIZE - offset;
+		ret = bio_get_user_pages(bio, (size_t) iov[i].iov_base,
+					 iov[i].iov_len,
+					 write_to_vm);
+		if (ret < 0)
+			goto out;
 
-			if (len <= 0)
-				break;
-			
-			if (bytes > len)
-				bytes = len;
-
-			/*
-			 * sorry...
-			 */
-			if (bio_add_pc_page(q, bio, pages[j], bytes, offset) <
-					    bytes)
-				break;
-
-			len -= bytes;
-			offset = 0;
-		}
-
-		cur_page = j;
-		/*
-		 * release the pages we didn't map into the bio, if any
-		 */
-		while (j < page_limit)
-			page_cache_release(pages[j++]);
+		if (ret != iov[i].iov_len)
+			break;
 	}
 
-	kfree(pages);
-
 	/*
 	 * set data direction, and check if mapped pages need bouncing
 	 */
@@ -1224,14 +1237,7 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 	bio->bi_flags |= (1 << BIO_USER_MAPPED);
 	return bio;
 
- out_unmap:
-	for (i = 0; i < nr_pages; i++) {
-		if(!pages[i])
-			break;
-		page_cache_release(pages[i]);
-	}
  out:
-	kfree(pages);
 	bio_put(bio);
 	return ERR_PTR(ret);
 }
diff --git a/include/linux/bio.h b/include/linux/bio.h
index d0c0cc7..af4976e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -356,6 +356,8 @@ void bio_chain(struct bio *, struct bio *);
 
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
+extern ssize_t bio_get_user_pages(struct bio *, unsigned long,
+				  unsigned long, int);
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int, gfp_t);
 struct sg_iovec;
-- 
1.8.4.rc3

