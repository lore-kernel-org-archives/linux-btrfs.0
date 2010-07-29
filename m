From: Vasiliy Kulikov <segooon@gmail.com>
Subject: [Bug] check return of kmalloc()
Date: Thu, 29 Jul 2010 23:15:57 +0400
Message-ID: <20100729191557.GA9784@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: kernel-janitors@vger.kernel.org, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've discovered that some btrfs code doesn't check whether kmalloc()
call succeeded. I poorly understand what this code does and how it can
be changed, maybe it would be happy with __GFP_NOFAIL.

Also there are BUG_ON() after kmalloc()'s, if they could be changed not
to panic it would be great.


--- ./fs/btrfs/compression.c	2010-07-06 16:45:48.000000000 +0400
+++ /tmp/cocci-output-7773-0df3b6-compression.c	2010-07-28 18:43:07.000000000 +0400
@@ -350,7 +350,6 @@ int btrfs_submit_compressed_write(struct
 	int ret;
 
 	WARN_ON(start & ((u64)PAGE_CACHE_SIZE - 1));
-	cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
 	atomic_set(&cb->pending_bios, 0);
 	cb->errors = 0;
 	cb->inode = inode;
@@ -587,7 +586,6 @@ int btrfs_submit_compressed_read(struct
 	read_unlock(&em_tree->lock);
 
 	compressed_len = em->block_len;
-	cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
 	atomic_set(&cb->pending_bios, 0);
 	cb->errors = 0;
 	cb->inode = inode;
--- ./fs/btrfs/tree-log.c	2010-07-06 16:45:48.000000000 +0400
+++ /tmp/cocci-output-7783-8f7d1b-tree-log.c	2010-07-28 18:43:08.000000000 +0400
@@ -336,8 +336,6 @@ static noinline int overwrite_item(struc
 			btrfs_release_path(root, path);
 			return 0;
 		}
-		dst_copy = kmalloc(item_size, GFP_NOFS);
-		src_copy = kmalloc(item_size, GFP_NOFS);
 
 		read_extent_buffer(eb, src_copy, src_ptr, item_size);
 
@@ -664,7 +662,6 @@ static noinline int drop_one_dir_item(st
 
 	btrfs_dir_item_key_to_cpu(leaf, di, &location);
 	name_len = btrfs_dir_name_len(leaf, di);
-	name = kmalloc(name_len, GFP_NOFS);
 	read_extent_buffer(leaf, name, (unsigned long)(di + 1), name_len);
 	btrfs_release_path(root, path);
 
@@ -819,7 +816,6 @@ again:
 	ref = (struct btrfs_inode_ref *)ref_ptr;
 
 	namelen = btrfs_inode_ref_name_len(eb, ref);
-	name = kmalloc(namelen, GFP_NOFS);
 	BUG_ON(!name);
 
 	read_extent_buffer(eb, name, (unsigned long)(ref + 1), namelen);
@@ -1182,7 +1177,6 @@ static noinline int replay_one_name(stru
 	BUG_ON(!dir);
 
 	name_len = btrfs_dir_name_len(eb, di);
-	name = kmalloc(name_len, GFP_NOFS);
 	log_type = btrfs_dir_type(eb, di);
 	read_extent_buffer(eb, name, (unsigned long)(di + 1),
 		   name_len);
@@ -2605,8 +2599,6 @@ static noinline int copy_items(struct bt
 
 	INIT_LIST_HEAD(&ordered_sums);
 
-	ins_data = kmalloc(nr * sizeof(struct btrfs_key) +
-			   nr * sizeof(u32), GFP_NOFS);
 	ins_sizes = (u32 *)ins_data;
 	ins_keys = (struct btrfs_key *)(ins_data + nr * sizeof(u32));
 
--- ./fs/btrfs/file.c	2010-07-09 15:55:34.000000000 +0400
+++ /tmp/cocci-output-7826-b84666-file.c	2010-07-28 18:43:13.000000000 +0400
@@ -925,7 +925,6 @@ static ssize_t btrfs_file_aio_write(stru
 	nrptrs = min((iov_iter_count(&i) + PAGE_CACHE_SIZE - 1) /
 		     PAGE_CACHE_SIZE, PAGE_CACHE_SIZE /
 		     (sizeof(struct page *)));
-	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
 
 	/* generic_write_checks can change our pos */
 	start_pos = pos;
--- ./fs/btrfs/inode.c	2010-07-28 08:11:33.000000000 +0400
+++ /tmp/cocci-output-7824-c1d367-inode.c	2010-07-28 18:43:15.000000000 +0400
@@ -284,7 +284,6 @@ static noinline int add_async_extent(str
 {
 	struct async_extent *async_extent;
 
-	async_extent = kmalloc(sizeof(*async_extent), GFP_NOFS);
 	async_extent->start = start;
 	async_extent->ram_size = ram_size;
 	async_extent->compressed_size = compressed_size;
@@ -940,7 +939,6 @@ static int cow_file_range_async(struct i
 	clear_extent_bit(&BTRFS_I(inode)->io_tree, start, end, EXTENT_LOCKED,
 			 1, 0, NULL, GFP_NOFS);
 	while (start < end) {
-		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
 		async_cow->inode = inode;
 		async_cow->root = root;
 		async_cow->locked_page = locked_page;
@@ -4891,7 +4888,6 @@ static noinline int uncompress_inline(st
 	max_size = btrfs_file_extent_ram_bytes(leaf, item);
 	inline_size = btrfs_file_extent_inline_item_len(leaf,
 					btrfs_item_nr(leaf, path->slots[0]));
-	tmp = kmalloc(inline_size, GFP_NOFS);
 	ptr = btrfs_file_extent_inline_start(item);
 
 	read_extent_buffer(leaf, tmp, ptr, inline_size);



Thanks,
Vasiliy.
