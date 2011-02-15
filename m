From: Yoshinori Sano <yoshinori.sano@gmail.com>
Subject: [PATCH] Btrfs: fix uncheck memory allocations
Date: Tue, 15 Feb 2011 21:01:42 +0900
Message-ID: <1297771302-28297-1-git-send-email-yoshinori.sano@gmail.com>
Cc: Yoshinori Sano <yoshinori.sano@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

To make Btrfs code more robust, several return value checks where memory
allocation can fail are introduced. I use BUG_ON where I don't know how
to handle the error properly, which increases the number of using the
notorious BUG_ON, though.

Signed-off-by: Yoshinori Sano <yoshinori.sano@gmail.com>
---
 fs/btrfs/compression.c |    6 ++++++
 fs/btrfs/extent-tree.c |    4 ++++
 fs/btrfs/inode.c       |    2 ++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 4d2110e..992a4b9 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -340,6 +340,8 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 
 	WARN_ON(start & ((u64)PAGE_CACHE_SIZE - 1));
 	cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
+	if (!cb)
+		return -ENOMEM;
 	atomic_set(&cb->pending_bios, 0);
 	cb->errors = 0;
 	cb->inode = inode;
@@ -354,6 +356,10 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 	bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
 
 	bio = compressed_bio_alloc(bdev, first_byte, GFP_NOFS);
+	if(!bio) {
+		kfree(cb);
+		return -ENOMEM;
+	}
 	bio->bi_private = cb;
 	bio->bi_end_io = end_compressed_bio_write;
 	atomic_inc(&cb->pending_bios);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a7aaa10..3c6d0f2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6931,6 +6931,10 @@ static noinline int get_new_locations(struct inode *reloc_inode,
 			struct disk_extent *old = exts;
 			max *= 2;
 			exts = kzalloc(sizeof(*exts) * max, GFP_NOFS);
+			if (!exts) {
+				ret = -ENOMEM;
+				goto out;
+			}
 			memcpy(exts, old, sizeof(*exts) * nr);
 			if (old != *extents)
 				kfree(old);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8d392ed..12a5a40 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -287,6 +287,7 @@ static noinline int add_async_extent(struct async_cow *cow,
 	struct async_extent *async_extent;
 
 	async_extent = kmalloc(sizeof(*async_extent), GFP_NOFS);
+	BUG_ON(!async_extent);
 	async_extent->start = start;
 	async_extent->ram_size = ram_size;
 	async_extent->compressed_size = compressed_size;
@@ -384,6 +385,7 @@ again:
 	     (BTRFS_I(inode)->force_compress))) {
 		WARN_ON(pages);
 		pages = kzalloc(sizeof(struct page *) * nr_pages, GFP_NOFS);
+		BUG_ON(!pages);
 
 		if (BTRFS_I(inode)->force_compress)
 			compress_type = BTRFS_I(inode)->force_compress;
-- 
1.7.1

