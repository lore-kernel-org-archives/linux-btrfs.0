From: Cong Wang <amwang@redhat.com>
Subject: [PATCH 30/62] btrfs: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:10 +0800
Message-ID: <1322371662-26166-31-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/btrfs/compression.c |   12 ++++++------
 fs/btrfs/extent_io.c   |   16 ++++++++--------
 fs/btrfs/file-item.c   |    4 ++--
 fs/btrfs/inode.c       |   26 +++++++++++++-------------
 fs/btrfs/lzo.c         |    4 ++--
 fs/btrfs/scrub.c       |    8 ++++----
 fs/btrfs/zlib.c        |    4 ++--
 7 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 14f1c5a..93f4af1 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -120,10 +120,10 @@ static int check_compressed_csum(struct inode *inode,
 		page = cb->compressed_pages[i];
 		csum = ~(u32)0;
 
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic(page);
 		csum = btrfs_csum_data(root, kaddr, csum, PAGE_CACHE_SIZE);
 		btrfs_csum_final(csum, (char *)&csum);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 
 		if (csum != *cb_sum) {
 			printk(KERN_INFO "btrfs csum failed ino %llu "
@@ -521,10 +521,10 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 			if (zero_offset) {
 				int zeros;
 				zeros = PAGE_CACHE_SIZE - zero_offset;
-				userpage = kmap_atomic(page, KM_USER0);
+				userpage = kmap_atomic(page);
 				memset(userpage + zero_offset, 0, zeros);
 				flush_dcache_page(page);
-				kunmap_atomic(userpage, KM_USER0);
+				kunmap_atomic(userpage);
 			}
 		}
 
@@ -991,9 +991,9 @@ int btrfs_decompress_buf2page(char *buf, unsigned long buf_start,
 		bytes = min(PAGE_CACHE_SIZE - *pg_offset,
 			    PAGE_CACHE_SIZE - buf_offset);
 		bytes = min(bytes, working_bytes);
-		kaddr = kmap_atomic(page_out, KM_USER0);
+		kaddr = kmap_atomic(page_out);
 		memcpy(kaddr + *pg_offset, buf + buf_offset, bytes);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		flush_dcache_page(page_out);
 
 		*pg_offset += bytes;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9472d3d..64a8a77 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2513,10 +2513,10 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 
 		if (zero_offset) {
 			iosize = PAGE_CACHE_SIZE - zero_offset;
-			userpage = kmap_atomic(page, KM_USER0);
+			userpage = kmap_atomic(page);
 			memset(userpage + zero_offset, 0, iosize);
 			flush_dcache_page(page);
-			kunmap_atomic(userpage, KM_USER0);
+			kunmap_atomic(userpage);
 		}
 	}
 	while (cur <= end) {
@@ -2525,10 +2525,10 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 			struct extent_state *cached = NULL;
 
 			iosize = PAGE_CACHE_SIZE - pg_offset;
-			userpage = kmap_atomic(page, KM_USER0);
+			userpage = kmap_atomic(page);
 			memset(userpage + pg_offset, 0, iosize);
 			flush_dcache_page(page);
-			kunmap_atomic(userpage, KM_USER0);
+			kunmap_atomic(userpage);
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
 					    &cached, GFP_NOFS);
 			unlock_extent_cached(tree, cur, cur + iosize - 1,
@@ -2574,10 +2574,10 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
 			char *userpage;
 			struct extent_state *cached = NULL;
 
-			userpage = kmap_atomic(page, KM_USER0);
+			userpage = kmap_atomic(page);
 			memset(userpage + pg_offset, 0, iosize);
 			flush_dcache_page(page);
-			kunmap_atomic(userpage, KM_USER0);
+			kunmap_atomic(userpage);
 
 			set_extent_uptodate(tree, cur, cur + iosize - 1,
 					    &cached, GFP_NOFS);
@@ -2723,10 +2723,10 @@ static int __extent_writepage(struct page *page, struct writeback_control *wbc,
 	if (page->index == end_index) {
 		char *userpage;
 
-		userpage = kmap_atomic(page, KM_USER0);
+		userpage = kmap_atomic(page);
 		memset(userpage + pg_offset, 0,
 		       PAGE_CACHE_SIZE - pg_offset);
-		kunmap_atomic(userpage, KM_USER0);
+		kunmap_atomic(userpage);
 		flush_dcache_page(page);
 	}
 	pg_offset = 0;
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index c7fb3a4..078b4fd 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -447,13 +447,13 @@ int btrfs_csum_one_bio(struct btrfs_root *root, struct inode *inode,
 			sums->bytenr = ordered->start;
 		}
 
-		data = kmap_atomic(bvec->bv_page, KM_USER0);
+		data = kmap_atomic(bvec->bv_page);
 		sector_sum->sum = ~(u32)0;
 		sector_sum->sum = btrfs_csum_data(root,
 						  data + bvec->bv_offset,
 						  sector_sum->sum,
 						  bvec->bv_len);
-		kunmap_atomic(data, KM_USER0);
+		kunmap_atomic(data);
 		btrfs_csum_final(sector_sum->sum,
 				 (char *)&sector_sum->sum);
 		sector_sum->bytenr = disk_bytenr;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 526dd51..b26483b 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -172,9 +172,9 @@ static noinline int insert_inline_extent(struct btrfs_trans_handle *trans,
 			cur_size = min_t(unsigned long, compressed_size,
 				       PAGE_CACHE_SIZE);
 
-			kaddr = kmap_atomic(cpage, KM_USER0);
+			kaddr = kmap_atomic(cpage);
 			write_extent_buffer(leaf, kaddr, ptr, cur_size);
-			kunmap_atomic(kaddr, KM_USER0);
+			kunmap_atomic(kaddr);
 
 			i++;
 			ptr += cur_size;
@@ -186,10 +186,10 @@ static noinline int insert_inline_extent(struct btrfs_trans_handle *trans,
 		page = find_get_page(inode->i_mapping,
 				     start >> PAGE_CACHE_SHIFT);
 		btrfs_set_file_extent_compression(leaf, ei, 0);
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic(page);
 		offset = start & (PAGE_CACHE_SIZE - 1);
 		write_extent_buffer(leaf, kaddr + offset, ptr, size);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		page_cache_release(page);
 	}
 	btrfs_mark_buffer_dirty(leaf);
@@ -421,10 +421,10 @@ again:
 			 * sending it down to disk
 			 */
 			if (offset) {
-				kaddr = kmap_atomic(page, KM_USER0);
+				kaddr = kmap_atomic(page);
 				memset(kaddr + offset, 0,
 				       PAGE_CACHE_SIZE - offset);
-				kunmap_atomic(kaddr, KM_USER0);
+				kunmap_atomic(kaddr);
 			}
 			will_compress = 1;
 		}
@@ -1862,7 +1862,7 @@ static int btrfs_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 	} else {
 		ret = get_state_private(io_tree, start, &private);
 	}
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic(page);
 	if (ret)
 		goto zeroit;
 
@@ -1871,7 +1871,7 @@ static int btrfs_readpage_end_io_hook(struct page *page, u64 start, u64 end,
 	if (csum != private)
 		goto zeroit;
 
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 good:
 	return 0;
 
@@ -1883,7 +1883,7 @@ zeroit:
 		       (unsigned long long)private);
 	memset(kaddr + offset, 1, end - start + 1);
 	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 	if (private == 0)
 		return 0;
 	return -EIO;
@@ -4808,12 +4808,12 @@ static noinline int uncompress_inline(struct btrfs_path *path,
 	ret = btrfs_decompress(compress_type, tmp, page,
 			       extent_offset, inline_size, max_size);
 	if (ret) {
-		char *kaddr = kmap_atomic(page, KM_USER0);
+		char *kaddr = kmap_atomic(page);
 		unsigned long copy_size = min_t(u64,
 				  PAGE_CACHE_SIZE - pg_offset,
 				  max_size - extent_offset);
 		memset(kaddr + pg_offset, 0, copy_size);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 	}
 	kfree(tmp);
 	return 0;
@@ -5590,11 +5590,11 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 			unsigned long flags;
 
 			local_irq_save(flags);
-			kaddr = kmap_atomic(page, KM_IRQ0);
+			kaddr = kmap_atomic(page);
 			csum = btrfs_csum_data(root, kaddr + bvec->bv_offset,
 					       csum, bvec->bv_len);
 			btrfs_csum_final(csum, (char *)&csum);
-			kunmap_atomic(kaddr, KM_IRQ0);
+			kunmap_atomic(kaddr);
 			local_irq_restore(flags);
 
 			flush_dcache_page(bvec->bv_page);
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index a178f5e..743b86f 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -411,9 +411,9 @@ static int lzo_decompress(struct list_head *ws, unsigned char *data_in,
 
 	bytes = min_t(unsigned long, destlen, out_len - start_byte);
 
-	kaddr = kmap_atomic(dest_page, KM_USER0);
+	kaddr = kmap_atomic(dest_page);
 	memcpy(kaddr, workspace->buf + start_byte, bytes);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 out:
 	return ret;
 }
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index fab420d..42e0674 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -584,7 +584,7 @@ static int scrub_fixup_check(struct scrub_bio *sbio, int ix)
 	u64 flags = sbio->spag[ix].flags;
 
 	page = sbio->bio->bi_io_vec[ix].bv_page;
-	buffer = kmap_atomic(page, KM_USER0);
+	buffer = kmap_atomic(page);
 	if (flags & BTRFS_EXTENT_FLAG_DATA) {
 		ret = scrub_checksum_data(sbio->sdev,
 					  sbio->spag + ix, buffer);
@@ -596,7 +596,7 @@ static int scrub_fixup_check(struct scrub_bio *sbio, int ix)
 	} else {
 		WARN_ON(1);
 	}
-	kunmap_atomic(buffer, KM_USER0);
+	kunmap_atomic(buffer);
 
 	return ret;
 }
@@ -785,7 +785,7 @@ static void scrub_checksum(struct btrfs_work *work)
 	}
 	for (i = 0; i < sbio->count; ++i) {
 		page = sbio->bio->bi_io_vec[i].bv_page;
-		buffer = kmap_atomic(page, KM_USER0);
+		buffer = kmap_atomic(page);
 		flags = sbio->spag[i].flags;
 		logical = sbio->logical + i * PAGE_SIZE;
 		ret = 0;
@@ -800,7 +800,7 @@ static void scrub_checksum(struct btrfs_work *work)
 		} else {
 			WARN_ON(1);
 		}
-		kunmap_atomic(buffer, KM_USER0);
+		kunmap_atomic(buffer);
 		if (ret) {
 			ret = scrub_recheck_error(sbio, i);
 			if (!ret) {
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index faccd47..92c2065 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -370,9 +370,9 @@ static int zlib_decompress(struct list_head *ws, unsigned char *data_in,
 			    PAGE_CACHE_SIZE - buf_offset);
 		bytes = min(bytes, bytes_left);
 
-		kaddr = kmap_atomic(dest_page, KM_USER0);
+		kaddr = kmap_atomic(dest_page);
 		memcpy(kaddr + pg_offset, workspace->buf + buf_offset, bytes);
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 
 		pg_offset += bytes;
 		bytes_left -= bytes;
-- 
1.7.4.4

