From: Yan Zheng <zheng.yan@oracle.com>
Subject: [PATCH] Fix csum error for compressed data
Date: Mon, 10 Nov 2008 17:32:32 +0800
Message-ID: <4917FFB0.2000100@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

The decompress code doesn't take the logical offset in extent
pointer into account. If the logical offset isn't zero, data
will be decompressed into wrong pages. Thank you,

Signed-off-by: Yan Zheng <zheng.yan@oracle.com>

---
diff -urp 1/fs/btrfs/compression.c 2/fs/btrfs/compression.c
--- 1/fs/btrfs/compression.c	2008-11-08 02:16:20.000000000 +0800
+++ 2/fs/btrfs/compression.c	2008-11-10 15:25:07.000000000 +0800
@@ -505,7 +505,6 @@ int btrfs_submit_compressed_read(struct 
 	struct block_device *bdev;
 	struct bio *comp_bio;
 	u64 cur_disk_byte = (u64)bio->bi_sector << 9;
-	u64 em_len;
 	struct extent_map *em;
 	int ret;
 
@@ -524,9 +523,8 @@ int btrfs_submit_compressed_read(struct 
 	cb->errors = 0;
 	cb->inode = inode;
 
-	cb->start = em->start;
+	cb->start = em->orig_start;
 	compressed_len = em->block_len;
-	em_len = em->len;
 	free_extent_map(em);
 
 	cb->len = uncompressed_len;
@@ -545,7 +543,7 @@ int btrfs_submit_compressed_read(struct 
 	}
 	cb->nr_pages = nr_pages;
 
-	add_ra_bio_pages(inode, cb->start + em_len, cb);
+	add_ra_bio_pages(inode, em->start + em->len, cb);
 
 	if (!btrfs_test_opt(root, NODATASUM) &&
 	    !btrfs_test_flag(inode, NODATASUM)) {
diff -urp 1/fs/btrfs/extent_map.h 2/fs/btrfs/extent_map.h
--- 1/fs/btrfs/extent_map.h	2008-11-01 01:04:31.000000000 +0800
+++ 2/fs/btrfs/extent_map.h	2008-11-10 13:52:43.000000000 +0800
@@ -20,6 +20,7 @@ struct extent_map {
 	/* all of these are in bytes */
 	u64 start;
 	u64 len;
+	u64 orig_start;
 	u64 block_start;
 	u64 block_len;
 	unsigned long flags;
diff -urp 1/fs/btrfs/file.c 2/fs/btrfs/file.c
--- 1/fs/btrfs/file.c	2008-11-07 19:16:08.000000000 +0800
+++ 2/fs/btrfs/file.c	2008-11-10 13:53:12.000000000 +0800
@@ -222,6 +222,7 @@ int btrfs_drop_extent_cache(struct inode
 		    em->start < start) {
 			split->start = em->start;
 			split->len = start - em->start;
+			split->orig_start = em->orig_start;
 			split->block_start = em->block_start;
 
 			if (compressed)
@@ -243,6 +244,7 @@ int btrfs_drop_extent_cache(struct inode
 
 			split->start = start + len;
 			split->len = em->start + em->len - (start + len);
+			split->orig_start = em->orig_start;
 			split->bdev = em->bdev;
 			split->flags = flags;
 
diff -urp 1/fs/btrfs/inode.c 2/fs/btrfs/inode.c
--- 1/fs/btrfs/inode.c	2008-11-07 19:16:08.000000000 +0800
+++ 2/fs/btrfs/inode.c	2008-11-10 13:55:04.000000000 +0800
@@ -3949,6 +3949,8 @@ again:
 	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
 		em->start = extent_start;
 		em->len = extent_end - extent_start;
+		em->orig_start = extent_start -
+				 btrfs_file_extent_offset(leaf, item);
 		bytenr = btrfs_file_extent_disk_bytenr(leaf, item);
 		if (bytenr == 0) {
 			em->block_start = EXTENT_MAP_HOLE;
@@ -3988,6 +3990,7 @@ again:
 		em->start = extent_start + extent_offset;
 		em->len = (copy_size + root->sectorsize - 1) &
 			~((u64)root->sectorsize - 1);
+		em->orig_start = EXTENT_MAP_INLINE;
 		if (compressed)
 			set_bit(EXTENT_FLAG_COMPRESSED, &em->flags);
 		ptr = btrfs_file_extent_inline_start(item) + extent_offset;
