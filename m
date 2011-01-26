From: liubo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs: fix uncheck memory allocation in btrfs_submit_compressed_read
Date: Wed, 26 Jan 2011 14:21:39 +0800
Message-ID: <4D3FBD73.9070107@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


btrfs_submit_compressed_read() is lack of memory allocation checks and
corresponding error route.

After this fix, if it comes to "no memory" case, errno will be returned
to userland step by step, and tell users this operation cannot go on.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/compression.c |   25 +++++++++++++++++++++++--
 fs/btrfs/extent_io.c   |    4 ++--
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index f745287..3a932f1 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -562,7 +562,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	u64 em_len;
 	u64 em_start;
 	struct extent_map *em;
-	int ret;
+	int ret = -ENOMEM;
 	u32 *sums;
 
 	tree = &BTRFS_I(inode)->io_tree;
@@ -577,6 +577,9 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 
 	compressed_len = em->block_len;
 	cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
+	if (!cb)
+		goto out;
+
 	atomic_set(&cb->pending_bios, 0);
 	cb->errors = 0;
 	cb->inode = inode;
@@ -597,13 +600,18 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 
 	nr_pages = (compressed_len + PAGE_CACHE_SIZE - 1) /
 				 PAGE_CACHE_SIZE;
-	cb->compressed_pages = kmalloc(sizeof(struct page *) * nr_pages,
+	cb->compressed_pages = kzalloc(sizeof(struct page *) * nr_pages,
 				       GFP_NOFS);
+	if (!cb->compressed_pages)
+		goto fail1;
+
 	bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
 
 	for (page_index = 0; page_index < nr_pages; page_index++) {
 		cb->compressed_pages[page_index] = alloc_page(GFP_NOFS |
 							      __GFP_HIGHMEM);
+		if (!cb->compressed_pages[page_index])
+			goto fail2;
 	}
 	cb->nr_pages = nr_pages;
 
@@ -614,6 +622,8 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	cb->len = uncompressed_len;
 
 	comp_bio = compressed_bio_alloc(bdev, cur_disk_byte, GFP_NOFS);
+	if (!comp_bio)
+		goto fail2;
 	comp_bio->bi_private = cb;
 	comp_bio->bi_end_io = end_compressed_bio_read;
 	atomic_inc(&cb->pending_bios);
@@ -681,6 +691,17 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 
 	bio_put(comp_bio);
 	return 0;
+
+fail2:
+	for (page_index = 0; page_index < nr_pages; page_index++)
+		free_page((unsigned long)cb->compressed_pages[page_index]);
+
+	kfree(cb->compressed_pages);
+fail1:
+	kfree(cb);
+out:
+	free_extent_map(em);
+	return ret;
 }
 
 static struct list_head comp_idle_workspace[BTRFS_COMPRESS_TYPES];
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8b8d3d9..6411ed6 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1865,7 +1865,7 @@ static int submit_one_bio(int rw, struct bio *bio, int mirror_num,
 	bio_get(bio);
 
 	if (tree->ops && tree->ops->submit_bio_hook)
-		tree->ops->submit_bio_hook(page->mapping->host, rw, bio,
+		ret = tree->ops->submit_bio_hook(page->mapping->host, rw, bio,
 					   mirror_num, bio_flags, start);
 	else
 		submit_bio(rw, bio);
@@ -2126,7 +2126,7 @@ int extent_read_full_page(struct extent_io_tree *tree, struct page *page,
 	ret = __extent_read_full_page(tree, page, get_extent, &bio, 0,
 				      &bio_flags);
 	if (bio)
-		submit_one_bio(READ, bio, 0, bio_flags);
+		ret = submit_one_bio(READ, bio, 0, bio_flags);
 	return ret;
 }
 
-- 
1.6.5.2
