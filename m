From: Chris Samuel <chris@csamuel.org>
Subject: [For review] [PATCH]  Check all kmalloc(), etc, functions for success
Date: Mon, 26 Apr 2010 16:07:22 -0700
Message-ID: <4BD61CAA.7090206@csamuel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080702030303020506030003"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080702030303020506030003
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Chris, et. al,

I was bored on the long flight from Melbourne to LA (and kept
awake by crying babies) so I thought I'd dip my toe into kernel
programming and thought I'd see if any results from kmalloc()
were being used without being checked for success first.

Turns out there were quite a few that I found by hand with a
simple "git grep -A2 kmalloc fs/btrfs" and so I've gone through
and either BUG_ON()'d them or made them return -ENOMEM in those
cases where the return value is checked.

I then installed Coccinelle (packaged in Ubuntu 10.04) and
used the kmtest.cocci file to pick up other cases of memory
allocations that need to be tested:

http://coccinelle.lip6.fr/impact/kmtest.html

There was one odd case in fs/btrfs/inode.c where the kzalloc()
was preceded by a WARN_ON(pages); which would always be true
as the only prior reference was its declaration and initialisation
to NULL, so I took the liberty of moving that after the allocation
and changing it to a BUG_ON().

As I'm new to this I'm only using BUG_ON() as that seems to be
used elsewhere for this case in btrfs but the kernel itself
(include/asm-generic/bug.h) seems to indicate that you should
only use BUG_ON() as a last resort.

Please review the patch and let me know whether I'm on the
right track or not!  Just be gentle with me, I'm jetlagged. :-)

Patch is included inline and also attached as a MIME attachment
to give a better alternative in case of wordwrap breakage in
the inline version.

All the best,
Chris

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 396039b..eb6e785 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -351,6 +351,7 @@ int btrfs_submit_compressed_write(struct inode 
*inode, u64 start,

         WARN_ON(start & ((u64)PAGE_CACHE_SIZE - 1));
         cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
+       BUG_ON(!cb);
         atomic_set(&cb->pending_bios, 0);
         cb->errors = 0;
         cb->inode = inode;
@@ -588,6 +589,7 @@ int btrfs_submit_compressed_read(struct inode 
*inode, struct bio *bio,

         compressed_len = em->block_len;
         cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
+       BUG_ON(!cb);
         atomic_set(&cb->pending_bios, 0);
         cb->errors = 0;
         cb->inode = inode;
@@ -609,6 +611,7 @@ int btrfs_submit_compressed_read(struct inode 
*inode, struct bio *bio,
                                  PAGE_CACHE_SIZE;
         cb->compressed_pages = kmalloc(sizeof(struct page *) * nr_pages,
                                        GFP_NOFS);
+       BUG_ON(!cb->compressed_pages);
         bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;

         for (page_index = 0; page_index < nr_pages; page_index++) {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e7b8f2c..3e5f0ff 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1967,6 +1967,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,

                 log_tree_root = kzalloc(sizeof(struct btrfs_root),
                                                       GFP_NOFS);
+               BUG_ON(!log_tree_root);

                 __setup_root(nodesize, leafsize, sectorsize, stripesize,
                              log_tree_root, fs_info, 
BTRFS_TREE_LOG_OBJECTID);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b34d32f..6e20c54 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7161,6 +7161,8 @@ static noinline int relocate_one_extent(struct 
btrfs_root *extent_root,
                                 u64 group_start = group->key.objectid;
                                 new_extents = kmalloc(sizeof(*new_extents),
                                                       GFP_NOFS);
+                               if(!new_extents)
+                                       goto out;
                                 nr_extents = 1;
                                 ret = get_new_locations(reloc_inode,
                                                         extent_key,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 29ff749..59765bc 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -877,6 +877,7 @@ static ssize_t btrfs_file_write(struct file *file, 
const char __user *buf,
         file_update_time(file);

         pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
+       BUG_ON(!pages);

         /* generic_write_checks can change our pos */
         start_pos = pos;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2bfdc64..d1216ba 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -284,6 +284,7 @@ static noinline int add_async_extent(struct 
async_cow *cow,
         struct async_extent *async_extent;

         async_extent = kmalloc(sizeof(*async_extent), GFP_NOFS);
+       BUG_ON(!async_extent);
         async_extent->start = start;
         async_extent->ram_size = ram_size;
         async_extent->compressed_size = compressed_size;
@@ -382,8 +383,8 @@ again:
         if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS) &&
             (btrfs_test_opt(root, COMPRESS) ||
              (BTRFS_I(inode)->force_compress))) {
-               WARN_ON(pages);
                 pages = kzalloc(sizeof(struct page *) * nr_pages, 
GFP_NOFS);
+               BUG_ON(pages);

                 ret = btrfs_zlib_compress_pages(inode->i_mapping, start,
                                                 total_compressed, pages,
@@ -930,6 +931,8 @@ static int cow_file_range_async(struct inode *inode, 
struct page *locked_page,
                          1, 0, NULL, GFP_NOFS);
         while (start < end) {
                 async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
+               if (!async_cow)
+                       return -ENOMEM;
                 async_cow->inode = inode;
                 async_cow->root = root;
                 async_cow->locked_page = locked_page;
@@ -1958,6 +1961,7 @@ void btrfs_add_delayed_iput(struct inode *inode)
                 return;

         delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);
+       BUG_ON(!delayed);
         delayed->inode = inode;

         spin_lock(&fs_info->delayed_iput_lock);
@@ -4568,6 +4572,8 @@ static noinline int uncompress_inline(struct 
btrfs_path *path,
         inline_size = btrfs_file_extent_inline_item_len(leaf,
                                         btrfs_item_nr(leaf, 
path->slots[0]));
         tmp = kmalloc(inline_size, GFP_NOFS);
+       if(!tmp)
+               return -ENOMEM;
         ptr = btrfs_file_extent_inline_start(item);

         read_extent_buffer(leaf, tmp, ptr, inline_size);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index af57dd2..e168a12 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -334,7 +334,11 @@ static noinline int overwrite_item(struct 
btrfs_trans_handle *trans,
                         return 0;
                 }
                 dst_copy = kmalloc(item_size, GFP_NOFS);
+               if (!dst_copy)
+                       return -ENOMEM;
                 src_copy = kmalloc(item_size, GFP_NOFS);
+               if (!src_copy)
+                       return -ENOMEM;

                 read_extent_buffer(eb, src_copy, src_ptr, item_size);

@@ -662,6 +666,8 @@ static noinline int drop_one_dir_item(struct 
btrfs_trans_handle *trans,
         btrfs_dir_item_key_to_cpu(leaf, di, &location);
         name_len = btrfs_dir_name_len(leaf, di);
         name = kmalloc(name_len, GFP_NOFS);
+       if (!name)
+               return -ENOMEM;
         read_extent_buffer(leaf, name, (unsigned long)(di + 1), name_len);
         btrfs_release_path(root, path);

@@ -1180,6 +1186,8 @@ static noinline int replay_one_name(struct 
btrfs_trans_handle *trans,

         name_len = btrfs_dir_name_len(eb, di);
         name = kmalloc(name_len, GFP_NOFS);
+       if (!name)
+               return -ENOMEM;
         log_type = btrfs_dir_type(eb, di);
         read_extent_buffer(eb, name, (unsigned long)(di + 1),
                    name_len);

-- 
  Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

--------------080702030303020506030003
Content-Type: text/x-diff;
 name="btrfs-kmalloc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="btrfs-kmalloc.patch"

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 396039b..eb6e785 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -351,6 +351,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 
 	WARN_ON(start & ((u64)PAGE_CACHE_SIZE - 1));
 	cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
+	BUG_ON(!cb);
 	atomic_set(&cb->pending_bios, 0);
 	cb->errors = 0;
 	cb->inode = inode;
@@ -588,6 +589,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 
 	compressed_len = em->block_len;
 	cb = kmalloc(compressed_bio_size(root, compressed_len), GFP_NOFS);
+	BUG_ON(!cb);
 	atomic_set(&cb->pending_bios, 0);
 	cb->errors = 0;
 	cb->inode = inode;
@@ -609,6 +611,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 				 PAGE_CACHE_SIZE;
 	cb->compressed_pages = kmalloc(sizeof(struct page *) * nr_pages,
 				       GFP_NOFS);
+	BUG_ON(!cb->compressed_pages);
 	bdev = BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev;
 
 	for (page_index = 0; page_index < nr_pages; page_index++) {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e7b8f2c..3e5f0ff 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1967,6 +1967,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 		log_tree_root = kzalloc(sizeof(struct btrfs_root),
 						      GFP_NOFS);
+		BUG_ON(!log_tree_root);
 
 		__setup_root(nodesize, leafsize, sectorsize, stripesize,
 			     log_tree_root, fs_info, BTRFS_TREE_LOG_OBJECTID);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index b34d32f..6e20c54 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7161,6 +7161,8 @@ static noinline int relocate_one_extent(struct btrfs_root *extent_root,
 				u64 group_start = group->key.objectid;
 				new_extents = kmalloc(sizeof(*new_extents),
 						      GFP_NOFS);
+				if(!new_extents)
+					goto out;
 				nr_extents = 1;
 				ret = get_new_locations(reloc_inode,
 							extent_key,
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 29ff749..59765bc 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -877,6 +877,7 @@ static ssize_t btrfs_file_write(struct file *file, const char __user *buf,
 	file_update_time(file);
 
 	pages = kmalloc(nrptrs * sizeof(struct page *), GFP_KERNEL);
+	BUG_ON(!pages);
 
 	/* generic_write_checks can change our pos */
 	start_pos = pos;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2bfdc64..d1216ba 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -284,6 +284,7 @@ static noinline int add_async_extent(struct async_cow *cow,
 	struct async_extent *async_extent;
 
 	async_extent = kmalloc(sizeof(*async_extent), GFP_NOFS);
+	BUG_ON(!async_extent);
 	async_extent->start = start;
 	async_extent->ram_size = ram_size;
 	async_extent->compressed_size = compressed_size;
@@ -382,8 +383,8 @@ again:
 	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NOCOMPRESS) &&
 	    (btrfs_test_opt(root, COMPRESS) ||
 	     (BTRFS_I(inode)->force_compress))) {
-		WARN_ON(pages);
 		pages = kzalloc(sizeof(struct page *) * nr_pages, GFP_NOFS);
+		BUG_ON(pages);
 
 		ret = btrfs_zlib_compress_pages(inode->i_mapping, start,
 						total_compressed, pages,
@@ -930,6 +931,8 @@ static int cow_file_range_async(struct inode *inode, struct page *locked_page,
 			 1, 0, NULL, GFP_NOFS);
 	while (start < end) {
 		async_cow = kmalloc(sizeof(*async_cow), GFP_NOFS);
+		if (!async_cow)
+			return -ENOMEM;
 		async_cow->inode = inode;
 		async_cow->root = root;
 		async_cow->locked_page = locked_page;
@@ -1958,6 +1961,7 @@ void btrfs_add_delayed_iput(struct inode *inode)
 		return;
 
 	delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);
+	BUG_ON(!delayed);
 	delayed->inode = inode;
 
 	spin_lock(&fs_info->delayed_iput_lock);
@@ -4568,6 +4572,8 @@ static noinline int uncompress_inline(struct btrfs_path *path,
 	inline_size = btrfs_file_extent_inline_item_len(leaf,
 					btrfs_item_nr(leaf, path->slots[0]));
 	tmp = kmalloc(inline_size, GFP_NOFS);
+	if(!tmp)
+		return -ENOMEM;
 	ptr = btrfs_file_extent_inline_start(item);
 
 	read_extent_buffer(leaf, tmp, ptr, inline_size);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index af57dd2..e168a12 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -334,7 +334,11 @@ static noinline int overwrite_item(struct btrfs_trans_handle *trans,
 			return 0;
 		}
 		dst_copy = kmalloc(item_size, GFP_NOFS);
+		if (!dst_copy)
+			return -ENOMEM;
 		src_copy = kmalloc(item_size, GFP_NOFS);
+		if (!src_copy)
+			return -ENOMEM;
 
 		read_extent_buffer(eb, src_copy, src_ptr, item_size);
 
@@ -662,6 +666,8 @@ static noinline int drop_one_dir_item(struct btrfs_trans_handle *trans,
 	btrfs_dir_item_key_to_cpu(leaf, di, &location);
 	name_len = btrfs_dir_name_len(leaf, di);
 	name = kmalloc(name_len, GFP_NOFS);
+	if (!name)
+		return -ENOMEM;
 	read_extent_buffer(leaf, name, (unsigned long)(di + 1), name_len);
 	btrfs_release_path(root, path);
 
@@ -1180,6 +1186,8 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 
 	name_len = btrfs_dir_name_len(eb, di);
 	name = kmalloc(name_len, GFP_NOFS);
+	if (!name)
+		return -ENOMEM;
 	log_type = btrfs_dir_type(eb, di);
 	read_extent_buffer(eb, name, (unsigned long)(di + 1),
 		   name_len);

--------------080702030303020506030003--
