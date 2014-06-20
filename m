Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966656AbaFTLDI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jun 2014 07:03:08 -0400
From: David Sterba <dsterba@suse.cz>
To: clm@fb.com
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: [PATCH 8/8] btrfs: use DIV_ROUND_UP instead of open-coded variants
Date: Fri, 20 Jun 2014 13:03:06 +0200
Message-Id: <cbe260e207c57843c1dcd550f9adbab7507945c6.1403260620.git.dsterba@suse.cz>
In-Reply-To: <cover.1403260619.git.dsterba@suse.cz>
References: <cover.1403260619.git.dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The form

  (value + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT

is equivalent to

  (value + PAGE_CACHE_SIZE - 1) / PAGE_CACHE_SIZE

The rest is a simple subsitution, no difference in the generated
assembly code.

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/check-integrity.c  |    3 +--
 fs/btrfs/compression.c      |   10 ++++------
 fs/btrfs/file.c             |   19 ++++++++-----------
 fs/btrfs/free-space-cache.c |    3 +--
 fs/btrfs/ioctl.c            |    5 ++---
 fs/btrfs/lzo.c              |    3 +--
 fs/btrfs/raid56.c           |    8 ++++----
 fs/btrfs/zlib.c             |    3 +--
 8 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index d0690da3b150..e0033c843ce7 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1251,8 +1251,7 @@ static void btrfsic_read_from_block_data(
 
 	while (len > 0) {
 		cur = min(len, ((size_t)PAGE_CACHE_SIZE - offset_in_page));
-		BUG_ON(i >= (block_ctx->len + PAGE_CACHE_SIZE - 1) >>
-			    PAGE_CACHE_SHIFT);
+		BUG_ON(i >= DIV_ROUND_UP(block_ctx->len, PAGE_CACHE_SIZE));
 		kaddr = block_ctx->datav[i];
 		memcpy(dst, kaddr + offset_in_page, cur);
 
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 92371c414228..75a2943f2fc5 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -91,8 +91,7 @@ static inline int compressed_bio_size(struct btrfs_root *root,
 	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
 
 	return sizeof(struct compressed_bio) +
-		((disk_size + root->sectorsize - 1) / root->sectorsize) *
-		csum_size;
+		(DIV_ROUND_UP(disk_size, root->sectorsize)) * csum_size;
 }
 
 static struct bio *compressed_bio_alloc(struct block_device *bdev,
@@ -615,8 +614,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	cb->compress_type = extent_compress_type(bio_flags);
 	cb->orig_bio = bio;
 
-	nr_pages = (compressed_len + PAGE_CACHE_SIZE - 1) /
-				 PAGE_CACHE_SIZE;
+	nr_pages = DIV_ROUND_UP(compressed_len, PAGE_CACHE_SIZE);
 	cb->compressed_pages = kzalloc(sizeof(struct page *) * nr_pages,
 				       GFP_NOFS);
 	if (!cb->compressed_pages)
@@ -686,8 +684,8 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 							comp_bio, sums);
 				BUG_ON(ret); /* -ENOMEM */
 			}
-			sums += (comp_bio->bi_iter.bi_size +
-				 root->sectorsize - 1) / root->sectorsize;
+			sums += DIV_ROUND_UP(comp_bio->bi_iter.bi_size,
+					     root->sectorsize);
 
 			ret = btrfs_map_bio(root, READ, comp_bio,
 					    mirror_num, 0);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f71d29c76d1e..48ce6e1e1693 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1480,9 +1480,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 	bool force_page_uptodate = false;
 	bool need_unlock;
 
-	nrptrs = min((iov_iter_count(i) + PAGE_CACHE_SIZE - 1) /
-		     PAGE_CACHE_SIZE, PAGE_CACHE_SIZE /
-		     (sizeof(struct page *)));
+	nrptrs = min(DIV_ROUND_UP(iov_iter_count(i), PAGE_CACHE_SIZE),
+			PAGE_CACHE_SIZE / (sizeof(struct page *)));
 	nrptrs = min(nrptrs, current->nr_dirtied_pause - current->nr_dirtied);
 	nrptrs = max(nrptrs, 8);
 	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
@@ -1496,8 +1495,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 		size_t write_bytes = min(iov_iter_count(i),
 					 nrptrs * (size_t)PAGE_CACHE_SIZE -
 					 offset);
-		size_t num_pages = (write_bytes + offset +
-				    PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+		size_t num_pages = DIV_ROUND_UP(write_bytes + offset,
+						PAGE_CACHE_SIZE);
 		size_t reserve_bytes;
 		size_t dirty_pages;
 		size_t copied;
@@ -1525,9 +1524,8 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
 				 * our prealloc extent may be smaller than
 				 * write_bytes, so scale down.
 				 */
-				num_pages = (write_bytes + offset +
-					     PAGE_CACHE_SIZE - 1) >>
-					PAGE_CACHE_SHIFT;
+				num_pages = DIV_ROUND_UP(write_bytes + offset,
+							 PAGE_CACHE_SIZE);
 				reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
 				ret = 0;
 			} else {
@@ -1589,9 +1587,8 @@ again:
 			dirty_pages = 0;
 		} else {
 			force_page_uptodate = false;
-			dirty_pages = (copied + offset +
-				       PAGE_CACHE_SIZE - 1) >>
-				       PAGE_CACHE_SHIFT;
+			dirty_pages = DIV_ROUND_UP(copied + offset,
+						   PAGE_CACHE_SIZE);
 		}
 
 		/*
diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index f181c9afe5f4..2f0fe1028e51 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -279,8 +279,7 @@ static int io_ctl_init(struct io_ctl *io_ctl, struct inode *inode,
 	int num_pages;
 	int check_crcs = 0;
 
-	num_pages = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
-		    PAGE_CACHE_SHIFT;
+	num_pages = DIV_ROUND_UP(i_size_read(inode), PAGE_CACHE_SIZE);
 
 	if (btrfs_ino(inode) != BTRFS_FREE_INO_OBJECTID)
 		check_crcs = 1;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f8af35d63881..9d2a43f230ff 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1364,8 +1364,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		inode->i_mapping->writeback_index = i;
 
 	while (i <= last_index && defrag_count < max_to_defrag &&
-	       (i < (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
-		PAGE_CACHE_SHIFT)) {
+	       (i < DIV_ROUND_UP(i_size_read(inode), PAGE_CACHE_SIZE))) {
 		/*
 		 * make sure we stop running if someone unmounts
 		 * the FS
@@ -1388,7 +1387,7 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			 * the should_defrag function tells us how much to skip
 			 * bump our counter by the suggested amount
 			 */
-			next = (skip + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+			next = DIV_ROUND_UP(skip, PAGE_CACHE_SIZE);
 			i = max(i + 1, next);
 			continue;
 		}
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index dfad8514f0da..78285f30909e 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -266,8 +266,7 @@ static int lzo_decompress_biovec(struct list_head *ws,
 	char *data_in;
 	unsigned long page_in_index = 0;
 	unsigned long page_out_index = 0;
-	unsigned long total_pages_in = (srclen + PAGE_CACHE_SIZE - 1) /
-					PAGE_CACHE_SIZE;
+	unsigned long total_pages_in = DIV_ROUND_UP(srclen, PAGE_CACHE_SIZE);
 	unsigned long buf_start;
 	unsigned long buf_offset = 0;
 	unsigned long bytes;
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 4055291a523e..da4e2da0202a 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -912,7 +912,7 @@ static struct page *page_in_rbio(struct btrfs_raid_bio *rbio,
 static unsigned long rbio_nr_pages(unsigned long stripe_len, int nr_stripes)
 {
 	unsigned long nr = stripe_len * nr_stripes;
-	return (nr + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	return DIV_ROUND_UP(nr, PAGE_CACHE_SIZE);
 }
 
 /*
@@ -1440,7 +1440,7 @@ static int raid56_rmw_stripe(struct btrfs_raid_bio *rbio)
 	struct btrfs_bio *bbio = rbio->bbio;
 	struct bio_list bio_list;
 	int ret;
-	int nr_pages = (rbio->stripe_len + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	int nr_pages = DIV_ROUND_UP(rbio->stripe_len, PAGE_CACHE_SIZE);
 	int pagenr;
 	int stripe;
 	struct bio *bio;
@@ -1722,7 +1722,7 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 	int pagenr, stripe;
 	void **pointers;
 	int faila = -1, failb = -1;
-	int nr_pages = (rbio->stripe_len + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	int nr_pages = DIV_ROUND_UP(rbio->stripe_len, PAGE_CACHE_SIZE);
 	struct page *page;
 	int err;
 	int i;
@@ -1937,7 +1937,7 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 	struct btrfs_bio *bbio = rbio->bbio;
 	struct bio_list bio_list;
 	int ret;
-	int nr_pages = (rbio->stripe_len + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	int nr_pages = DIV_ROUND_UP(rbio->stripe_len, PAGE_CACHE_SIZE);
 	int pagenr;
 	int stripe;
 	struct bio *bio;
diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 4f196314c0c1..48070e357858 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -225,8 +225,7 @@ static int zlib_decompress_biovec(struct list_head *ws, struct page **pages_in,
 	size_t total_out = 0;
 	unsigned long page_in_index = 0;
 	unsigned long page_out_index = 0;
-	unsigned long total_pages_in = (srclen + PAGE_CACHE_SIZE - 1) /
-					PAGE_CACHE_SIZE;
+	unsigned long total_pages_in = DIV_ROUND_UP(srclen, PAGE_CACHE_SIZE);
 	unsigned long buf_start;
 	unsigned long pg_offset;
 
-- 
1.7.9

